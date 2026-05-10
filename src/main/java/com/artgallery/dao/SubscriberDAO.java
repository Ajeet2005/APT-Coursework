package com.artgallery.dao;

import com.artgallery.model.Subscriber;
import com.artgallery.util.DBConnection;

import java.sql.*;

/**
 * DAO for Subscriber (newsletter signup).
 */
public class SubscriberDAO {

    public boolean save(Subscriber s) {
        String sql = "INSERT INTO subscribers (first_name, last_name, email) VALUES (?, ?, ?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, s.getFirstName());
            ps.setString(2, s.getLastName());
            ps.setString(3, s.getEmail());
            int rows = ps.executeUpdate();
            if (rows == 0) return false;
            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) s.setId(keys.getInt(1));
            }
            return true;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public long countAll() {
        String sql = "SELECT COUNT(*) FROM subscribers";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public java.util.List<Subscriber> findAll() throws SQLException {
        java.util.List<Subscriber> list = new java.util.ArrayList<>();
        String sql = "SELECT id, first_name, last_name, email FROM subscribers ORDER BY id DESC";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Subscriber s = new Subscriber();
                s.setId(rs.getInt("id"));
                s.setFirstName(rs.getString("first_name"));
                s.setLastName(rs.getString("last_name"));
                s.setEmail(rs.getString("email"));
                list.add(s);
            }
        }
        return list;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM subscribers WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
