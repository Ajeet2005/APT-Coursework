package com.artgallery.filter;

import com.artgallery.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.Set;

/**
 * Servlet Filter that enforces authentication and authorization rules.
 *
 * Rules
 * ─────
 * 1. /admin/*  → must be logged in AND have role = "admin"
 * 2. /cart/*   → must be logged in (any role)
 * 3. Add-to-cart action (/art?action=addToCart and similar POST/GET params)
 *    → must be logged in; if not, redirect to /login
 *
 * Everything else is public.
 *
 * How it works
 * ────────────
 * Tomcat calls doFilter() for EVERY request that matches the urlPatterns.
 * We map it to "/*" so we can inspect every request in one place.
 * For requests that are fine, we call chain.doFilter(req, res) to continue normally.
 * For requests that need auth, we redirect to /login instead.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = "/*")
public class AuthFilter implements Filter {

    /**
     * Paths that are always public — login/register pages themselves,
     * static assets, and the logout action.
     */
    private static final Set<String> PUBLIC_PATHS = Set.of(
            "/login", "/register", "/logout",
            "/home", "/", "/categories", "/art", "/artist", "/gallery", "/newsletter"
    );

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contextPath = req.getContextPath();           // e.g. "/art-gallery"
        String requestURI  = req.getRequestURI();            // e.g. "/art-gallery/admin"
        String path        = requestURI.substring(contextPath.length()); // e.g. "/admin"

        // Always let static assets through
        if (path.startsWith("/assets/") || path.startsWith("/favicon")) {
            chain.doFilter(request, response);
            return;
        }

        // Get currently logged-in user (null = not logged in)
        HttpSession session  = req.getSession(false);
        User        user     = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        boolean     loggedIn = (user != null);

        // ── Rule 1: Admin area ───────────────────────────────────────────────
        if (path.startsWith("/admin")) {
            if (!loggedIn) {
                saveRedirectTarget(session, req, requestURI);
                resp.sendRedirect(contextPath + "/login");
                return;
            }
            if (!user.isAdmin()) {
                // Logged in but not admin → back to home
                resp.sendRedirect(contextPath + "/home");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── Rule 2: Cart area ────────────────────────────────────────────────
        if (path.startsWith("/cart")) {
            if (!loggedIn) {
                saveRedirectTarget(session, req, requestURI);
                resp.sendRedirect(contextPath + "/login");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── Rule 3: Add-to-cart action anywhere (e.g. art detail page) ───────
        // The existing UI likely sends a parameter like action=addToCart
        String action = req.getParameter("action");
        if ("addToCart".equals(action) && !loggedIn) {
            // Save where they were trying to go
            saveRedirectTarget(session, req, requestURI);
            resp.sendRedirect(contextPath + "/login");
            return;
        }

        // ── Default: public ──────────────────────────────────────────────────
        chain.doFilter(request, response);
    }

    /**
     * Stores the full URL the user was trying to reach so LoginServlet can
     * redirect them back there after a successful login.
     */
    private void saveRedirectTarget(HttpSession existingSession,
                                     HttpServletRequest req,
                                     String requestURI) {
        HttpSession s = (existingSession != null) ? existingSession : req.getSession(true);
        String query = req.getQueryString();
        String target = requestURI + (query != null ? "?" + query : "");
        s.setAttribute("redirectAfterLogin", target);
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
