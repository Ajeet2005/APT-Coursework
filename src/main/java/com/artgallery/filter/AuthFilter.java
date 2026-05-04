package com.artgallery.filter;

import com.artgallery.model.User;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Servlet Filter that enforces authentication and authorization rules.
 *
 * Rules
 * ─────
 * 1. /admin/*       → must be logged in AND have role = "admin"
 * 2. /cart (GET)    → must be logged in (any role)
 * 3. POST /cart     → action "add", "remove", "update", "clear" all require login
 *    AJAX add-to-cart request returns HTTP 401 JSON so JS can handle it gracefully.
 * 4. Add-to-cart action on any page (action=addToCart GET param) → must be logged in
 *
 * Everything else is public.
 */
@WebFilter(filterName = "AuthFilter", urlPatterns = "/*")
public class AuthFilter implements Filter {

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

        // ── Rule 2 & 3: Cart area (both GET and POST) ────────────────────────
        if (path.equals("/cart") || path.startsWith("/cart/")) {

            if (!loggedIn) {
                // For AJAX cart-add calls: return 401 JSON so JS can redirect gracefully
                String action = req.getParameter("action");
                if (isAjax(req) && "add".equals(action)) {
                    resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                    resp.setContentType("application/json;charset=UTF-8");
                    resp.getWriter().write(
                        "{\"ok\":false,\"requiresLogin\":true,\"loginUrl\":\"" +
                        contextPath + "/login" + "\"}"
                    );
                    return;
                }
                // For normal POST/GET: save where they were and redirect
                saveRedirectTarget(session, req, requestURI);
                resp.sendRedirect(contextPath + "/login");
                return;
            }
            chain.doFilter(request, response);
            return;
        }

        // ── Rule 4: Add-to-cart action anywhere (e.g. art detail page) ───────
        // Handles both legacy "addToCart" GET param and "add" POST param from art pages
        String action = req.getParameter("action");
        if (("addToCart".equals(action) || "add".equals(action)) && !loggedIn) {
            if (isAjax(req)) {
                resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
                resp.setContentType("application/json;charset=UTF-8");
                resp.getWriter().write(
                    "{\"ok\":false,\"requiresLogin\":true,\"loginUrl\":\"" +
                    contextPath + "/login" + "\"}"
                );
                return;
            }
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

    /** Checks whether the request is an AJAX/XMLHttpRequest. */
    private static boolean isAjax(HttpServletRequest req) {
        String h = req.getHeader("X-Requested-With");
        return h != null && h.equalsIgnoreCase("XMLHttpRequest");
    }

    @Override public void init(FilterConfig fc) {}
    @Override public void destroy() {}
}
