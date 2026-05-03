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

    /**
     * Search + filter. All parameters optional — pass null or 0 to skip a filter.
     * @param q          free-text search across title, description, artist name
     * @param categoryId 0 / null = any category
     * @param sort       "featured" (default), "price_asc", "price_desc", "newest"
     */
    public List<Artwork> search(String q, Integer categoryId, String sort) {
        StringBuilder sql = new StringBuilder(BASE_SQL);
        List<Object> params = new ArrayList<>();
        List<String> conditions = new ArrayList<>();

        if (q != null && !q.isBlank()) {
            conditions.add("(a.title LIKE ? OR a.description LIKE ? OR ar.name LIKE ? OR c.name LIKE ?)");
            String like = "%" + q.trim() + "%";
            params.add(like);
            params.add(like);
            params.add(like);
            params.add(like);
        }
        if (categoryId != null && categoryId > 0) {
            conditions.add("a.category_id = ?");
            params.add(categoryId);
        }

        if (!conditions.isEmpty()) {
            sql.append("WHERE ").append(String.join(" AND ", conditions)).append(" ");
        }

        String orderBy;
        if ("price_asc".equals(sort))      orderBy = "ORDER BY a.price ASC";
        else if ("price_desc".equals(sort)) orderBy = "ORDER BY a.price DESC";
        else if ("newest".equals(sort))     orderBy = "ORDER BY a.id DESC";
        else                                orderBy = "ORDER BY a.featured DESC, a.id DESC"; // featured default
        sql.append(orderBy);

        List<Artwork> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof Integer) ps.setInt(i + 1, (Integer) p);
                else ps.setString(i + 1, (String) p);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
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
