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

    public long countAll() {
        String sql = "SELECT COUNT(*) FROM artists";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public void insert(Artist a) throws SQLException {
        String sql = "INSERT INTO artists (name, bio, profile_image, country) VALUES (?, ?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getBio());
            ps.setString(3, a.getProfileImage());
            ps.setString(4, a.getCountry());
            ps.executeUpdate();
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) a.setId(keys.getInt(1));
            }
        }
    }

    public void update(Artist a) throws SQLException {
        String sql = "UPDATE artists SET name=?, bio=?, profile_image=?, country=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, a.getName());
            ps.setString(2, a.getBio());
            ps.setString(3, a.getProfileImage());
            ps.setString(4, a.getCountry());
            ps.setInt(5, a.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM artists WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
//test