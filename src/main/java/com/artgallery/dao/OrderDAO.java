package com.artgallery.dao;

import com.artgallery.model.Order;
import com.artgallery.model.OrderItem;
import com.artgallery.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class OrderDAO {

    public List<Order> findAll() throws SQLException {
        String sql = "SELECT o.*, u.full_name FROM orders o JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC";
        List<Order> orders = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Order order = new Order();
                order.setId(rs.getInt("id"));
                order.setUserId(rs.getInt("user_id"));
                order.setUserFullName(rs.getString("full_name"));
                order.setTotalAmount(rs.getBigDecimal("total_amount"));
                order.setStatus(rs.getString("status"));
                order.setCreatedAt(rs.getTimestamp("created_at"));
                orders.add(order);
            }
        }
        return orders;
    }

    public Order findById(int id) throws SQLException {
        String sql = "SELECT o.*, u.full_name FROM orders o JOIN users u ON o.user_id = u.id WHERE o.id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = new Order();
                    order.setId(rs.getInt("id"));
                    order.setUserId(rs.getInt("user_id"));
                    order.setUserFullName(rs.getString("full_name"));
                    order.setTotalAmount(rs.getBigDecimal("total_amount"));
                    order.setStatus(rs.getString("status"));
                    order.setCreatedAt(rs.getTimestamp("created_at"));
                    return order;
                }
            }
        }
        return null;
    }

    public long countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM orders";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) return rs.getLong(1);
        }
        return 0;
    }

    public Map<String, Integer> getOrdersByMonth() throws SQLException {
        String sql = "SELECT DATE_FORMAT(created_at, '%b') as month, COUNT(*) as count " +
                     "FROM orders " +
                     "WHERE created_at >= DATE_SUB(NOW(), INTERVAL 6 MONTH) " +
                     "GROUP BY month " +
                     "ORDER BY MIN(created_at)";
        Map<String, Integer> stats = new HashMap<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                stats.put(rs.getString("month"), rs.getInt("count"));
            }
        }
        return stats;
    }

    public List<OrderItem> findItemsByOrderId(int orderId) throws SQLException {
        String sql = "SELECT oi.*, a.title FROM order_items oi JOIN artworks a ON oi.artwork_id = a.id WHERE oi.order_id = ?";
        List<OrderItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setArtworkId(rs.getInt("artwork_id"));
                    item.setArtworkTitle(rs.getString("title"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getBigDecimal("price"));
                    items.add(item);
                }
            }
        }
        return items;
    }
}
