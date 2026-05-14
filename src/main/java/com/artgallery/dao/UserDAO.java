package com.artgallery.dao;

import com.artgallery.model.User;
import com.artgallery.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * Data Access Object for the `users` table.
 *
 * Password security notes
 * ───────────────────────
 * • Passwords are NEVER stored in plain text.
 * • BCrypt.hashpw(plain, BCrypt.gensalt(12)) generates a 60-character hash
 *   that already contains a random salt — different every call even for the
 *   same password, which is exactly what you want (two users with "password"
 *   get completely different hashes).
 * • BCrypt.checkpw(plain, storedHash) verifies a login attempt in constant
 *   time, preventing timing-attack leaks.
 */
public class UserDAO {

    private static final Logger LOG = Logger.getLogger(UserDAO.class.getName());

    // ── Register (INSERT) ────────────────────────────────────────────────────

    /**
     * Creates a new user account.
     *
     * @param fullName    display name
     * @param email       must be unique
     * @param plainPassword raw password typed by the user — hashed before storing
     * @return the newly created User, or null if the email already exists
     * @throws SQLException on any other DB error
     */
    public User register(String fullName, String email, String plainPassword)
            throws SQLException {
        return registerWithRole(fullName, email, plainPassword, "user");
    }

    /**
     * Creates a new user account with a specified role.
     *
     * @param fullName       display name
     * @param email          must be unique
     * @param plainPassword  raw password typed by the user — hashed before storing
     * @param role           "user" or "admin"
     * @return the newly created User, or null if the email already exists
     * @throws SQLException on any other DB error
     */
    public User registerWithRole(String fullName, String email, String plainPassword, String role)
            throws SQLException {

        // Hash with BCrypt work-factor 12 (≈ 250 ms on modern hardware — good balance)
        String hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));

        // Validate role — only allow 'user' or 'admin'
        if (!"user".equalsIgnoreCase(role) && !"admin".equalsIgnoreCase(role)) {
            role = "user";
        }

        // Normalize email to lowercase for consistent lookups
        email = email.toLowerCase().trim();

        String sql = "INSERT INTO users (full_name, email, password_hash, role) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, hash);
            ps.setString(4, role.toLowerCase());

            ps.executeUpdate();

            try (ResultSet keys = ps.getGeneratedKeys()) {
                if (keys.next()) {
                    return findById(keys.getInt(1));
                }
            }
        } catch (SQLException e) {
            // MySQL error 1062 = duplicate entry (email UNIQUE constraint)
            if (e.getErrorCode() == 1062) {
                return null;   // caller treats null as "email already taken"
            }
            throw e;
        }
        return null;
    }

    // ── Login (SELECT + verify) ──────────────────────────────────────────────

    /**
     * Attempts to authenticate a user.
     *
     * @param email         email typed on the login form
     * @param plainPassword password typed on the login form
     * @return the matching User if credentials are correct, otherwise null
     * @throws SQLException on DB errors
     */
    public User login(String email, String plainPassword) throws SQLException {

        // Normalize email to lowercase for case-insensitive comparison
        email = email.toLowerCase().trim();

        String sql = "SELECT id, full_name, email, password_hash, role, created_at " +
                     "FROM users WHERE LOWER(email) = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            LOG.info("Looking up user by email: " + email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String storedHash = rs.getString("password_hash");
                    LOG.info("User found in database: " + rs.getString("email") + " (id=" + rs.getInt("id") + ")");

                    // BCrypt constant-time comparison — prevents timing attacks
                    if (BCrypt.checkpw(plainPassword, storedHash)) {
                        LOG.info("Password verified successfully for: " + email);
                        return mapRow(rs);
                    } else {
                        LOG.info("Password mismatch for: " + email);
                    }
                } else {
                    LOG.info("No user found with email: " + email);
                }
            }
        } catch (SQLException e) {
            LOG.log(Level.SEVERE, "Database error during login lookup for: " + email, e);
            throw e;
        }
        // Return null for wrong email OR wrong password (don't reveal which)
        return null;
    }

    // ── Helpers ──────────────────────────────────────────────────────────────

    public User findById(int id) throws SQLException {
        String sql = "SELECT id, full_name, email, password_hash, role, created_at " +
                     "FROM users WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        }
        return null;
    }

    /** Maps the current ResultSet row to a User object. */
    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(rs.getString("role"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) u.setCreatedAt(ts.toLocalDateTime());
        return u;
    }

    /** Check if an email is already registered (used for real-time validation). */
    public boolean emailExists(String email) throws SQLException {
        email = email.toLowerCase().trim();
        String sql = "SELECT 1 FROM users WHERE LOWER(email) = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }
        }
    }

    /** Counts total users in the database */
    public long countAll() throws SQLException {
        String sql = "SELECT COUNT(*) FROM users";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
        }
        return 0;
    }

    public java.util.List<User> findAll() throws SQLException {
        java.util.List<User> list = new java.util.ArrayList<>();
        String sql = "SELECT id, full_name, email, password_hash, role, created_at FROM users ORDER BY id DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(mapRow(rs));
            }
        }
        return list;
    }

    public void update(User u) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=?, role=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail().toLowerCase().trim());
            ps.setString(3, u.getRole().toLowerCase());
            ps.setInt(4, u.getId());
            ps.executeUpdate();
        }
    }

    /**
     * Updates only name and email (used by the profile-edit page).
     * Does NOT touch the role or password columns.
     */
    public void updateProfile(User u) throws SQLException {
        String sql = "UPDATE users SET full_name=?, email=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, u.getFullName());
            ps.setString(2, u.getEmail().toLowerCase().trim());
            ps.setInt(3, u.getId());
            ps.executeUpdate();
        }
    }

    /**
     * Changes the user's password after verifying the current one.
     *
     * @return true if the password was changed, false if currentPassword was wrong
     */
    public boolean updatePassword(int userId, String currentPassword, String newPassword)
            throws SQLException {
        // 1. Fetch the stored hash
        String selectSql = "SELECT password_hash FROM users WHERE id = ?";
        String storedHash;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(selectSql)) {
            ps.setInt(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return false;
                storedHash = rs.getString("password_hash");
            }
        }

        // 2. Verify current password
        if (!BCrypt.checkpw(currentPassword, storedHash)) {
            return false;
        }

        // 3. Hash the new password and update
        String newHash = BCrypt.hashpw(newPassword, BCrypt.gensalt(12));
        String updateSql = "UPDATE users SET password_hash=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(updateSql)) {
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            ps.executeUpdate();
        }
        return true;
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }
}
