package com.artgallery.servlet;

import com.artgallery.dao.SubscriberDAO;
import com.artgallery.model.Subscriber;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;

/**
 * Handles the newsletter signup form POST.
 */
@WebServlet("/newsletter")
public class NewsletterServlet extends HttpServlet {

    private final SubscriberDAO subscriberDAO = new SubscriberDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String first = req.getParameter("firstName");
        String last = req.getParameter("lastName");
        String email = req.getParameter("email");
        String consent = req.getParameter("consent");

        req.setAttribute("activePage", "home");

        if (first == null || first.isBlank()
                || email == null || email.isBlank()
                || consent == null) {
            req.setAttribute("newsletterError",
                    "Please fill in your name, email and confirm the privacy policy.");
            req.getRequestDispatcher("/home").forward(req, resp);
            return;
        }

        Subscriber s = new Subscriber(first.trim(), last == null ? "" : last.trim(), email.trim());
        boolean ok = subscriberDAO.save(s);

        if (ok) {
            req.setAttribute("newsletterSuccess",
                    "Thank you, " + first + "! You are now part of the Gallery Artisan's community.");
        } else {
            req.setAttribute("newsletterError",
                    "Something went wrong. Please try again later.");
        }
        req.getRequestDispatcher("/home").forward(req, resp);
    }
}
