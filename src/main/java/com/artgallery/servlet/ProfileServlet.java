package com.artgallery.servlet;

import com.artgallery.dao.UserDAO;
import com.artgallery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles user profile viewing and editing.
 *
 * GET  /profile       → show the profile edit form
 * POST /profile       → update name, email, and optionally password
 */
@WebServlet("/profile")
public class ProfileServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Only regular members can edit their profile
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        // Only regular members can edit their profile
        if (user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/admin");
            return;
        }

        String fullName        = req.getParameter("fullName");
        String email           = req.getParameter("email");
        String currentPassword = req.getParameter("currentPassword");
        String newPassword     = req.getParameter("newPassword");

        try {
            // ── Update name & email ──────────────────────────────────────────
            if (fullName != null && !fullName.trim().isEmpty()) {
                user.setFullName(fullName.trim());
            }
            if (email != null && !email.trim().isEmpty()) {
                // Check if email changed and if the new one is already taken
                String normalizedEmail = email.toLowerCase().trim();
                if (!normalizedEmail.equals(user.getEmail().toLowerCase().trim())) {
                    if (userDAO.emailExists(normalizedEmail)) {
                        session.setAttribute("flashMessage", "That email is already in use.");
                        session.setAttribute("flashType", "error");
                        resp.sendRedirect(req.getContextPath() + "/profile");
                        return;
                    }
                }
                user.setEmail(normalizedEmail);
            }

            userDAO.updateProfile(user);

            // ── Optionally update password ───────────────────────────────────
            if (newPassword != null && !newPassword.trim().isEmpty()) {
                if (currentPassword == null || currentPassword.trim().isEmpty()) {
                    session.setAttribute("flashMessage", "Please enter your current password to set a new one.");
                    session.setAttribute("flashType", "error");
                    resp.sendRedirect(req.getContextPath() + "/profile");
                    return;
                }
                boolean changed = userDAO.updatePassword(user.getId(), currentPassword, newPassword);
                if (!changed) {
                    session.setAttribute("flashMessage", "Current password is incorrect.");
                    session.setAttribute("flashType", "error");
                    resp.sendRedirect(req.getContextPath() + "/profile");
                    return;
                }
            }

            // Refresh session with updated user data
            User refreshed = userDAO.findById(user.getId());
            if (refreshed != null) {
                session.setAttribute("loggedInUser", refreshed);
            }

            session.setAttribute("flashMessage", "Profile updated successfully!");
            session.setAttribute("flashType", "success");
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("flashMessage", "Something went wrong. Please try again.");
            session.setAttribute("flashType", "error");
        }

        resp.sendRedirect(req.getContextPath() + "/profile");
    }
}
