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
}
