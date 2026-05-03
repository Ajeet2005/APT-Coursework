package com.artgallery.dao;

import com.artgallery.model.CartItem;
import com.artgallery.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * DAO for the shopping cart.
 *
 * Each browser session gets one row in `carts` (keyed on JSESSIONID).
 * Adding the same artwork twice increments quantity instead of creating
 * a duplicate row (enforced by the UNIQUE KEY on cart_items).
 */
public class CartDAO {

    /**
     * Find the cart_id for this session, or create a new cart row if none.
     * Returns the cart_id.
     */
    public int getOrCreateCart(String sessionId) {
        try (Connection c = DBConnection.getConnection()) {
            // Try to find existing
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT id FROM carts WHERE session_id = ?")) {
                ps.setString(1, sessionId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("id");
                }
            }
            // Insert new
            try (PreparedStatement ps = c.prepareStatement(
                    "INSERT INTO carts (session_id) VALUES (?)",
                    Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, sessionId);
                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) return keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Add an artwork to the cart. If the artwork already exists in this cart,
     * its quantity is incremented by 1 (using ON DUPLICATE KEY UPDATE).
     */
    public void addItem(int cartId, int artworkId) {
        String sql = "INSERT INTO cart_items (cart_id, artwork_id, quantity) VALUES (?, ?, 1) " +
                     "ON DUPLICATE KEY UPDATE quantity = quantity + 1";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, artworkId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Remove one artwork (the whole row) from the cart. */
    public void removeItem(int cartId, int artworkId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ? AND artwork_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, artworkId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Set quantity for an existing item. Removes it if qty <= 0. */
    public void updateQuantity(int cartId, int artworkId, int qty) {
        if (qty <= 0) {
            removeItem(cartId, artworkId);
            return;
        }
        String sql = "UPDATE cart_items SET quantity = ? WHERE cart_id = ? AND artwork_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, qty);
            ps.setInt(2, cartId);
            ps.setInt(3, artworkId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Empty the cart entirely. */
    public void clearCart(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /** Return all items in this cart, with artwork data joined in. */
    public List<CartItem> getItems(int cartId) {
        String sql =
                "SELECT ci.id, ci.cart_id, ci.artwork_id, ci.quantity, " +
                "       a.title, a.image_url, a.price, ar.name AS artist_name " +
                "FROM cart_items ci " +
                "JOIN artworks a   ON ci.artwork_id = a.id " +
                "LEFT JOIN artists ar ON a.artist_id = ar.id " +
                "WHERE ci.cart_id = ? " +
                "ORDER BY ci.added_at DESC";
        List<CartItem> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setId(rs.getInt("id"));
                    item.setCartId(rs.getInt("cart_id"));
                    item.setArtworkId(rs.getInt("artwork_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTitle(rs.getString("title"));
                    item.setImageUrl(rs.getString("image_url"));
                    item.setPrice(rs.getBigDecimal("price"));
                    item.setArtistName(rs.getString("artist_name"));
                    list.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Total number of pieces in the cart (sum of quantities) — for the header badge. */
    public int getItemCount(int cartId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS total FROM cart_items WHERE cart_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getInt("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Sum of all subtotals in the cart. */
    public BigDecimal getCartTotal(int cartId) {
        String sql = "SELECT COALESCE(SUM(a.price * ci.quantity), 0) AS total " +
                     "FROM cart_items ci JOIN artworks a ON ci.artwork_id = a.id " +
                     "WHERE ci.cart_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return rs.getBigDecimal("total");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return BigDecimal.ZERO;
    }
}
