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
 * Once the visitor logs in, the same cart row is linked to their user_id
 * (one user can own many carts over time — no UNIQUE on user_id).
 *
 * Cart contents live in `cart_artworks` (one row per (cart, artwork) pair
 * with a quantity).
 */
public class CartDAO {

    /**
     * Find the cart_id for this session, or create a new cart row if none.
     * Returns the cart_id.
     */
    public int getOrCreateCart(String sessionId) {
        try (Connection c = DBConnection.getConnection()) {
            try (PreparedStatement ps = c.prepareStatement(
                    "SELECT id FROM carts WHERE session_id = ?")) {
                ps.setString(1, sessionId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) return rs.getInt("id");
                }
            }
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
     * Attach this session's cart to the given user_id (called from LoginServlet
     * once the user authenticates). Idempotent.
     */
    public void linkCartToUser(int cartId, int userId) {
        String sql = "UPDATE carts SET user_id = ? WHERE id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    /**
     * Add an artwork to the cart. If the artwork already exists in this cart,
     * its quantity is incremented by 1.
     */
    public void addItem(int cartId, int artworkId) {
        String sql = "INSERT INTO cart_artworks (cart_id, artwork_id, quantity) VALUES (?, ?, 1) " +
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

    public void removeItem(int cartId, int artworkId) {
        String sql = "DELETE FROM cart_artworks WHERE cart_id = ? AND artwork_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.setInt(2, artworkId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void updateQuantity(int cartId, int artworkId, int qty) {
        if (qty <= 0) {
            removeItem(cartId, artworkId);
            return;
        }
        String sql = "UPDATE cart_artworks SET quantity = ? WHERE cart_id = ? AND artwork_id = ?";
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

    public void clearCart(int cartId) {
        String sql = "DELETE FROM cart_artworks WHERE cart_id = ?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, cartId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<CartItem> getItems(int cartId) {
        String sql =
                "SELECT ca.id, ca.cart_id, ca.artwork_id, ca.quantity, " +
                "       a.title, a.image_url, a.price, ar.name AS artist_name " +
                "FROM cart_artworks ca " +
                "JOIN artworks a   ON ca.artwork_id = a.id " +
                "LEFT JOIN artists ar ON a.artist_id = ar.id " +
                "WHERE ca.cart_id = ? " +
                "ORDER BY ca.added_at DESC";
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

    public int getItemCount(int cartId) {
        String sql = "SELECT COALESCE(SUM(quantity), 0) AS total FROM cart_artworks WHERE cart_id = ?";
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

    public BigDecimal getCartTotal(int cartId) {
        String sql = "SELECT COALESCE(SUM(a.price * ca.quantity), 0) AS total " +
                     "FROM cart_artworks ca JOIN artworks a ON ca.artwork_id = a.id " +
                     "WHERE ca.cart_id = ?";
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
