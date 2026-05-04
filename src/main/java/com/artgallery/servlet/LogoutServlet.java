package com.artgallery.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

/**
 * Handles GET /logout → invalidates the session and redirects to /login.
 *
 * Best practice: always redirect after logout (POST-Redirect-GET) so the
 * browser doesn't re-submit on refresh. We accept GET here for simplicity
 * (a plain link is enough for coursework), but a production app would use POST.
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();   // destroys all session data
        }

        // Prevent the browser from caching a "logged in" page after logout
        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        resp.sendRedirect(req.getContextPath() + "/login");
    }
}
