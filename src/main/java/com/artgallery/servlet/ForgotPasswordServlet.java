package com.artgallery.servlet;

import com.artgallery.dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles GET  /forgot-password → show the reset form
 *         POST /forgot-password → verify email, update password
 *
 * Simple direct-reset flow suitable for a learning project: the user enters
 * their email plus the new password (and confirmation) on a single page.
 * No email tokens, no security questions. A real-world app would mail a
 * one-time link instead — see resetPasswordByEmail() in UserDAO.
 */
@WebServlet("/forgot-password")
public class ForgotPasswordServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
           .forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email           = trim(req.getParameter("email")).toLowerCase();
        String newPassword     = req.getParameter("newPassword");
        String confirmPassword = req.getParameter("confirmPassword");

        // Validate
        if (email.isEmpty()) {
            error(req, resp, "Please enter your email address.", email);
            return;
        }
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            error(req, resp, "Please enter a valid email address.", email);
            return;
        }
        if (newPassword == null || newPassword.length() < 8) {
            error(req, resp, "New password must be at least 8 characters.", email);
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            error(req, resp, "Passwords do not match.", email);
            return;
        }

        try {
            if (!userDAO.emailExists(email)) {
                error(req, resp, "No account is registered with that email.", email);
                return;
            }

            boolean updated = userDAO.resetPasswordByEmail(email, newPassword);
            if (!updated) {
                error(req, resp, "Could not update password. Please try again.", email);
                return;
            }

            // Success — flash and bounce to /login.
            HttpSession session = req.getSession(true);
            session.setAttribute("flashMessage",
                "Password reset successfully. Please sign in with your new password.");
            resp.sendRedirect(req.getContextPath() + "/login");

        } catch (SQLException e) {
            throw new ServletException("Database error during password reset", e);
        }
    }

    private void error(HttpServletRequest req, HttpServletResponse resp,
                       String msg, String email)
            throws ServletException, IOException {
        req.setAttribute("error",      msg);
        req.setAttribute("emailValue", email);
        req.getRequestDispatcher("/WEB-INF/views/forgot-password.jsp")
           .forward(req, resp);
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }
}
