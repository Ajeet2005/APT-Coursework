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

@WebServlet("/gesture")
public class GestureServlet extends HttpServlet {

    private static final int GESTURE_CATEGORY_ID = 6;

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Category gesture = categoryDAO.findById(GESTURE_CATEGORY_ID);
        List<Artwork> artworks = artworkDAO.findByCategory(GESTURE_CATEGORY_ID);

        req.setAttribute("category", gesture);
        req.setAttribute("artworks", artworks);
        req.setAttribute("activePage", "gesture");

        req.getRequestDispatcher("/WEB-INF/views/gesture.jsp").forward(req, resp);
    }
}
