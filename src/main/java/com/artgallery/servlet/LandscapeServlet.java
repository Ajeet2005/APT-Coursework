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

@WebServlet("/landscape")
public class LandscapeServlet extends HttpServlet {

    private static final int LANDSCAPE_CATEGORY_ID = 3;

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Category landscape = categoryDAO.findById(LANDSCAPE_CATEGORY_ID);
        List<Artwork> artworks = artworkDAO.findByCategory(LANDSCAPE_CATEGORY_ID);

        req.setAttribute("category", landscape);
        req.setAttribute("artworks", artworks);
        req.setAttribute("activePage", "landscape");

        req.getRequestDispatcher("/WEB-INF/views/landscape.jsp").forward(req, resp);
    }
}
