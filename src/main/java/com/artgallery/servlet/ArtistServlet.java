package com.artgallery.servlet;

import com.artgallery.dao.ArtistDAO;
import com.artgallery.dao.ArtworkDAO;
import com.artgallery.model.Artist;
import com.artgallery.model.Artwork;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.util.List;

@WebServlet("/artist")
public class ArtistServlet extends HttpServlet {

    private final ArtistDAO artistDAO = new ArtistDAO();
    private final ArtworkDAO artworkDAO = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String idParam = req.getParameter("id");
        List<Artist> artists = artistDAO.findAll();
        req.setAttribute("artists", artists);
        req.setAttribute("activePage", "artist");

        if (idParam != null && !idParam.isBlank()) {
            try {
                int id = Integer.parseInt(idParam);
                Artist selected = artistDAO.findById(id);
                List<Artwork> artworks = artworkDAO.findByArtist(id);
                req.setAttribute("selectedArtist", selected);
                req.setAttribute("artworks", artworks);
            } catch (NumberFormatException ignored) {
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/artist.jsp").forward(req, resp);
    }
}
