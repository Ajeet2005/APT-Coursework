package com.artgallery.servlet;

import com.artgallery.dao.ArtworkDAO;
import com.artgallery.model.Artwork;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

/**
 * Controller for /art — lists all artworks, optionally a single piece by id.
 */
@WebServlet("/art")
public class ArtServlet extends HttpServlet {

    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        req.setAttribute("activePage", "art");

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

        List<Artwork> artworks = artworkDAO.findAll();
        req.setAttribute("artworks", artworks);
        req.getRequestDispatcher("/WEB-INF/views/art.jsp").forward(req, resp);
    }
}
