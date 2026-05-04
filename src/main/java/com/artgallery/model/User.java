package com.artgallery.model;

import java.time.LocalDateTime;

/**
 * POJO representing a row in the `users` table.
 * The password_hash is stored here for transport from DAO → Servlet only;
 * it is never exposed to JSPs.
 */
public class User {

    private int           id;
    private String        fullName;
    private String        email;
    private String        passwordHash;   // BCrypt 60-char hash
    private String        role;           // "user" or "admin"
    private LocalDateTime createdAt;

    // ── Constructors ────────────────────────────────────────────────────────

    public User() {}

    public User(int id, String fullName, String email,
                String passwordHash, String role, LocalDateTime createdAt) {
        this.id           = id;
        this.fullName     = fullName;
        this.email        = email;
        this.passwordHash = passwordHash;
        this.role         = role;
        this.createdAt    = createdAt;
    }

    // ── Getters & Setters ────────────────────────────────────────────────────

    public int getId()                    { return id; }
    public void setId(int id)             { this.id = id; }

    public String getFullName()                   { return fullName; }
    public void setFullName(String fullName)       { this.fullName = fullName; }

    public String getEmail()                      { return email; }
    public void setEmail(String email)            { this.email = email; }

    public String getPasswordHash()               { return passwordHash; }
    public void setPasswordHash(String h)         { this.passwordHash = h; }

    public String getRole()                       { return role; }
    public void setRole(String role)              { this.role = role; }

    public LocalDateTime getCreatedAt()           { return createdAt; }
    public void setCreatedAt(LocalDateTime t)     { this.createdAt = t; }

    /** Convenience: true when the user holds the admin role. */
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }
}
