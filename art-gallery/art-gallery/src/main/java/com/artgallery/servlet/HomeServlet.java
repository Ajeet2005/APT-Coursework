package com.artgallery.servlet;

import com.artgallery.dao.ArtworkDAO;
import com.artgallery.dao.CategoryDAO;
import com.artgallery.model.Artwork;
import com.artgallery.model.Category;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for the home page — feeds featured artworks (slideshow + gallery grid)
 * and category shortcuts to the view.
 */
@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    private final ArtworkDAO artworkDAO = new ArtworkDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Artwork> featured = artworkDAO.findFeatured();
        List<Artwork> latest = artworkDAO.findAll();
        List<Category> categories = categoryDAO.findAll();

        req.setAttribute("featured", featured);
        req.setAttribute("latest", latest);
        req.setAttribute("categories", categories);
        req.setAttribute("activePage", "home");

        req.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(req, resp);
    }
}
