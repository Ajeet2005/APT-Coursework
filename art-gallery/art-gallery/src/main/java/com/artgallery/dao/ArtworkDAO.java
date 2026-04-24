package com.artgallery.dao;

import com.artgallery.model.Artwork;
import com.artgallery.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Artwork entity (joins on artist and category).
 */
public class ArtworkDAO {

    private static final String BASE_SQL =
            "SELECT a.id, a.title, a.description, a.image_url, a.price, " +
            "       a.category_id, a.artist_id, a.featured, " +
            "       c.name AS category_name, ar.name AS artist_name " +
            "FROM artworks a " +
            "LEFT JOIN categories c ON a.category_id = c.id " +
            "LEFT JOIN artists    ar ON a.artist_id   = ar.id ";

    public List<Artwork> findAll() {
        return query(BASE_SQL + "ORDER BY a.id DESC", null);
    }

    public List<Artwork> findFeatured() {
        return query(BASE_SQL + "WHERE a.featured = 1 ORDER BY a.id DESC", null);
    }

    public List<Artwork> findByCategory(int categoryId) {
        return query(BASE_SQL + "WHERE a.category_id = ? ORDER BY a.id DESC", categoryId);
    }

    public List<Artwork> findByArtist(int artistId) {
        return query(BASE_SQL + "WHERE a.artist_id = ? ORDER BY a.id DESC", artistId);
    }

    public Artwork findById(int id) {
        List<Artwork> list = query(BASE_SQL + "WHERE a.id = ?", id);
        return list.isEmpty() ? null : list.get(0);
    }

    private List<Artwork> query(String sql, Integer param) {
        List<Artwork> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            if (param != null) ps.setInt(1, param);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    private Artwork map(ResultSet rs) throws SQLException {
        Artwork a = new Artwork();
        a.setId(rs.getInt("id"));
        a.setTitle(rs.getString("title"));
        a.setDescription(rs.getString("description"));
        a.setImageUrl(rs.getString("image_url"));
        a.setPrice(rs.getBigDecimal("price"));
        a.setCategoryId(rs.getInt("category_id"));
        a.setArtistId(rs.getInt("artist_id"));
        a.setFeatured(rs.getBoolean("featured"));
        a.setCategoryName(rs.getString("category_name"));
        a.setArtistName(rs.getString("artist_name"));
        return a;
    }
}
