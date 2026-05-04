package com.artgallery.servlet;

import com.artgallery.dao.UserDAO;
import com.artgallery.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Handles GET /login  → show the login page
 *         POST /login → verify credentials and create a session
 *
 * After successful login:
 *   • admin  → redirected to /admin
 *   • user   → redirected to /home (or wherever they originally wanted to go)
 *
 * The logged-in User object is stored in the HTTP session under the key
 * "loggedInUser" so every JSP/servlet can check it with:
 *
 *   User u = (User) session.getAttribute("loggedInUser");
 *   if (u == null) { /* not logged in *\/ }
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private static final Logger LOG = Logger.getLogger(LoginServlet.class.getName());
    private final UserDAO userDAO = new UserDAO();

    // ── GET ──────────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // If already logged in, skip the login page
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            User u = (User) session.getAttribute("loggedInUser");
            resp.sendRedirect(req.getContextPath() + (u.isAdmin() ? "/admin" : "/home"));
            return;
        }

        // Pass any "redirect after login" URL stored by AuthFilter
        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    // ── POST ─────────────────────────────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = trim(req.getParameter("email")).toLowerCase();
        String password = req.getParameter("password");

        // Basic presence validation
        if (email.isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Please fill in all fields.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        try {
            LOG.info("Login attempt for email: " + email);
            User user = userDAO.login(email, password);

            if (user == null) {
                LOG.info("Login failed for email: " + email + " — invalid credentials");
                // Wrong email or password — don't say which (security best practice)
                req.setAttribute("error", "Invalid email or password.");
                req.setAttribute("emailValue", email); // pre-fill email field
                req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
                return;
            }

            LOG.info("Login successful for: " + user.getEmail() + " (role: " + user.getRole() + ")");

            // ── Save redirect target BEFORE invalidating old session ──
            HttpSession oldSession = req.getSession(false);
            String redirectAfterLogin = null;
            if (oldSession != null) {
                redirectAfterLogin = (String) oldSession.getAttribute("redirectAfterLogin");
                oldSession.invalidate();
            }

            // ── Create a fresh session (prevents session fixation attacks) ──
            HttpSession newSession = req.getSession(true);
            newSession.setAttribute("loggedInUser", user);
            newSession.setMaxInactiveInterval(30 * 60); // 30 minutes

            if (redirectAfterLogin != null && !redirectAfterLogin.isEmpty()) {
                resp.sendRedirect(redirectAfterLogin);
            } else if (user.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }

        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Database error during login for email: " + email, e);
            throw new ServletException("Database error during login", e);
        }
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
