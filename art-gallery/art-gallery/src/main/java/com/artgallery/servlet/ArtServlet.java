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
 * Controller for /art — lists all artworks (with search + filter), or a single piece by id.
 */
@WebServlet("/art")
public class ArtServlet extends HttpServlet {

    private final ArtworkDAO artworkDAO = new ArtworkDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        req.setAttribute("activePage", "art");

        // Single-artwork detail view
        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam);
                Artwork artwork = artworkDAO.findById(id);
                req.setAttribute("artwork", artwork);
                req.getRequestDispatcher("/WEB-INF/views/art-detail.jsp").forward(req, resp);
                return;
            } catch (NumberFormatException ignored) {
            }
        }

        // Listing — read search/filter params
        String q = req.getParameter("q");
        String categoryParam = req.getParameter("categoryId");
        String sort = req.getParameter("sort");

        Integer categoryId = null;
        if (categoryParam != null && !categoryParam.isBlank()) {
            try {
                categoryId = Integer.parseInt(categoryParam);
            } catch (NumberFormatException ignored) {
            }
        }

        List<Artwork> artworks = artworkDAO.search(q, categoryId, sort);
        List<Category> categories = categoryDAO.findAll();

        // Echo the filters back so the form can preserve state
        req.setAttribute("artworks", artworks);
        req.setAttribute("categories", categories);
        req.setAttribute("q", q == null ? "" : q);
        req.setAttribute("selectedCategoryId", categoryId);
        req.setAttribute("sort", sort == null ? "" : sort);

        req.getRequestDispatcher("/WEB-INF/views/art.jsp").forward(req, resp);
    }
}
