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

@WebServlet("/categories")
public class CategoryServlet extends HttpServlet {

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        List<Category> categories = categoryDAO.findAll();
        req.setAttribute("categories", categories);
        req.setAttribute("activePage", "categories");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam);
                Category selected = categoryDAO.findById(id);
                List<Artwork> artworks = artworkDAO.findByCategory(id);
                req.setAttribute("selectedCategory", selected);
                req.setAttribute("artworks", artworks);
            } catch (NumberFormatException ignored) {
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/categories.jsp").forward(req, resp);
    }
}
