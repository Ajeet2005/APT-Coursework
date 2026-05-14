package com.artgallery.dao;

import com.artgallery.model.CartItem;
import com.artgallery.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the `carts` table.
 *
 * A cart row is keyed by (session_id, artwork_id) — the UNIQUE constraint
 * in schema.sql guarantees one row per artwork per session. We use ON DUPLICATE
 * KEY UPDATE to either insert a fresh row or bump the quantity if the user
 * adds the same artwork again.
 *
 * user_id is optional (NULL for anonymous sessions) but we set it when we know
 * who's signed in, so admins can see who's carrying what.
 */
public class CartDAO {

    /**
     * Add one unit of an artwork to a session's cart, or bump quantity by 1
     * if it's already there.
     */
    public void addItem(String sessionId, Integer userId, int artworkId)
            throws SQLException {

        String sql =
                "INSERT INTO carts (session_id, user_id, artwork_id, quantity) " +
                "VALUES (?, ?, ?, 1) " +
                "ON DUPLICATE KEY UPDATE quantity = quantity + 1, " +
                "                        user_id  = COALESCE(?, user_id)";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {

            ps.setString(1, sessionId);
            if (userId != null) ps.setInt(2, userId);
            else                ps.setNull(2, Types.INTEGER);
            ps.setInt(3, artworkId);
            if (userId != null) ps.setInt(4, userId);
            else                ps.setNull(4, Types.INTEGER);

            ps.executeUpdate();
        }
    }

    /** Total number of items (sum of quantities) in this session's cart. */
    public int countItems(String sessionId) throws SQLException {
        String sql = "SELECT COALESCE(SUM(quantity), 0) FROM carts WHERE session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return 0;
    }

    /** Full list of items in this session's cart, with joined artwork details. */
    public List<CartItem> findBySession(String sessionId) throws SQLException {
        List<CartItem> list = new ArrayList<>();
        String sql =
                "SELECT c.id, c.session_id, c.user_id, c.artwork_id, c.quantity, " +
                "       a.title, a.image_url, a.price, ar.name AS artist_name " +
                "FROM carts c " +
                "JOIN artworks a ON a.id = c.artwork_id " +
                "LEFT JOIN artists ar ON ar.id = a.artist_id " +
                "WHERE c.session_id = ? " +
                "ORDER BY c.added_at DESC";

        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(map(rs));
            }
        }
        return list;
    }

    /** Remove a single cart row (by its own id) — used by the cart page. */
    public void removeItem(String sessionId, int cartItemId) throws SQLException {
        String sql = "DELETE FROM carts WHERE id = ? AND session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartItemId);
            ps.setString(2, sessionId);
            ps.executeUpdate();
        }
    }

    /** Update quantity for a cart row. Setting q <= 0 deletes the row. */
    public void updateQuantity(String sessionId, int cartItemId, int quantity)
            throws SQLException {
        if (quantity <= 0) { removeItem(sessionId, cartItemId); return; }
        String sql = "UPDATE carts SET quantity = ? WHERE id = ? AND session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, quantity);
            ps.setInt(2, cartItemId);
            ps.setString(3, sessionId);
            ps.executeUpdate();
        }
    }

    /** Wipe a session's cart (used on checkout / explicit clear). */
    public void clearSession(String sessionId) throws SQLException {
        String sql = "DELETE FROM carts WHERE session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            ps.executeUpdate();
        }
    }

    /**
     * After a user logs in, attach all of their anonymous cart rows to their
     * user id so the cart survives the session-id refresh that happens on
     * authentication.
     */
    public void attachSessionToUser(String sessionId, int userId) throws SQLException {
        String sql = "UPDATE carts SET user_id = ? WHERE session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setString(2, sessionId);
            ps.executeUpdate();
        }
    }

    /** Subtotal (sum of price * quantity) for a session's cart. */
    public BigDecimal subtotal(String sessionId) throws SQLException {
        String sql =
                "SELECT COALESCE(SUM(a.price * c.quantity), 0) " +
                "FROM carts c JOIN artworks a ON a.id = c.artwork_id " +
                "WHERE c.session_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, sessionId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal(1);
            }
        }
        return BigDecimal.ZERO;
    }

    private CartItem map(ResultSet rs) throws SQLException {
        CartItem ci = new CartItem();
        ci.setId(rs.getInt("id"));
        ci.setSessionId(rs.getString("session_id"));
        int uid = rs.getInt("user_id");
        ci.setUserId(rs.wasNull() ? null : uid);
        ci.setArtworkId(rs.getInt("artwork_id"));
        ci.setQuantity(rs.getInt("quantity"));
        ci.setTitle(rs.getString("title"));
        ci.setImageUrl(rs.getString("image_url"));
        ci.setPrice(rs.getBigDecimal("price"));
        ci.setArtistName(rs.getString("artist_name"));
        return ci;
    }
}
