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
 * Controller for /gallery — the full yak-biergarten-style gallery wall.
 */
@WebServlet("/gallery")
public class GalleryServlet extends HttpServlet {

    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        List<Artwork> artworks = artworkDAO.findAll();
        req.setAttribute("artworks", artworks);
        req.setAttribute("activePage", "gallery");
        req.getRequestDispatcher("/WEB-INF/views/gallery.jsp").forward(req, resp);
    }
}
