package com.artgallery.dao;

import com.artgallery.model.Artist;
import com.artgallery.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for Artist entity.
 */
public class ArtistDAO {

    public List<Artist> findAll() {
        List<Artist> list = new ArrayList<>();
        String sql = "SELECT id, name, bio, profile_image, country FROM artists ORDER BY name";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Artist findById(int id) {
        String sql = "SELECT id, name, bio, profile_image, country FROM artists WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return map(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private Artist map(ResultSet rs) throws SQLException {
        return new Artist(
                rs.getInt("id"),
                rs.getString("name"),
                rs.getString("bio"),
                rs.getString("profile_image"),
                rs.getString("country")
        );
    }
}
