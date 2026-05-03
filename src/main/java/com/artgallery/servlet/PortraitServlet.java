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

@WebServlet("/portrait")
public class PortraitServlet extends HttpServlet {

    private static final int PORTRAIT_CATEGORY_ID = 4;

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Category portrait = categoryDAO.findById(PORTRAIT_CATEGORY_ID);
        List<Artwork> artworks = artworkDAO.findByCategory(PORTRAIT_CATEGORY_ID);

        req.setAttribute("category", portrait);
        req.setAttribute("artworks", artworks);
        req.setAttribute("activePage", "portrait");

        req.getRequestDispatcher("/WEB-INF/views/portrait.jsp").forward(req, resp);
    }
}
