package com.artgallery.servlet;

import com.artgallery.model.User;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles GET /admin → render the admin dashboard.
 *
 * The AuthFilter already blocks non-admin users from reaching this URL,
 * but we do a double-check here for defence-in-depth.
 */
@WebServlet("/admin")
public class AdminServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        // Double-check: must be logged in AND be an admin
        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
    }
}
