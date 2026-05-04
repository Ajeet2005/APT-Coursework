package com.artgallery.servlet;

import com.artgallery.dao.UserDAO;
import com.artgallery.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.sql.SQLException;

/**
 * Handles GET  /register → show the registration page
 *         POST /register → validate + create account + auto-login
 *
 * Supports both "user" and "admin" registrations via a role selector
 * on the registration form.
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedInUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/home");
            return;
        }
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String fullName        = trim(req.getParameter("fullName"));
        String email           = trim(req.getParameter("email"));
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String role            = trim(req.getParameter("role"));

        // Validate role — default to "user" if missing or invalid
        if (!"user".equalsIgnoreCase(role) && !"admin".equalsIgnoreCase(role)) {
            role = "user";
        }

        if (fullName.isEmpty() || email.isEmpty() || password == null || password.isEmpty()) {
            fwd(req, resp, "All fields are required.", fullName, email, role); return;
        }
        if (fullName.length() < 2 || fullName.length() > 120) {
            fwd(req, resp, "Full name must be 2–120 characters.", fullName, email, role); return;
        }
        if (!email.matches("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$")) {
            fwd(req, resp, "Please enter a valid email address.", fullName, email, role); return;
        }
        if (password.length() < 8) {
            fwd(req, resp, "Password must be at least 8 characters.", fullName, email, role); return;
        }
        if (!password.equals(confirmPassword)) {
            fwd(req, resp, "Passwords do not match.", fullName, email, role); return;
        }

        try {
            if (userDAO.emailExists(email)) {
                fwd(req, resp, "An account with that email already exists. Try logging in.", fullName, email, role);
                return;
            }

            User newUser = userDAO.registerWithRole(fullName, email, password, role);
            if (newUser == null) {
                fwd(req, resp, "That email is already taken. Please try another.", fullName, email, role);
                return;
            }

            HttpSession old = req.getSession(false);
            if (old != null) old.invalidate();

            HttpSession s = req.getSession(true);
            s.setAttribute("loggedInUser", newUser);
            s.setMaxInactiveInterval(30 * 60);
            s.setAttribute("flashMessage",
                    "Welcome, " + newUser.getFullName() + "! Your account has been created.");

            // Redirect admin to admin dashboard, regular user to home
            if (newUser.isAdmin()) {
                resp.sendRedirect(req.getContextPath() + "/admin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/home");
            }

        } catch (SQLException e) {
            throw new ServletException("Database error during registration", e);
        }
    }

    private void fwd(HttpServletRequest req, HttpServletResponse resp,
                     String msg, String fullName, String email, String role)
            throws ServletException, IOException {
        req.setAttribute("error",         msg);
        req.setAttribute("fullNameValue", fullName);
        req.setAttribute("emailValue",    email);
        req.setAttribute("roleValue",     role);
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    private String trim(String s) { return s == null ? "" : s.trim(); }
}
