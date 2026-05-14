package com.artgallery.model;

import java.math.BigDecimal;

/**
 * One row of the `carts` table, joined with the artwork it points to.
 */
public class CartItem {

    private int id;
    private String sessionId;
    private Integer userId;
    private int artworkId;
    private int quantity;

    // joined fields from artworks
    private String title;
    private String imageUrl;
    private BigDecimal price;
    private String artistName;

    public CartItem() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getSessionId() { return sessionId; }
    public void setSessionId(String sessionId) { this.sessionId = sessionId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public int getArtworkId() { return artworkId; }
    public void setArtworkId(int artworkId) { this.artworkId = artworkId; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public String getArtistName() { return artistName; }
    public void setArtistName(String artistName) { this.artistName = artistName; }

    public BigDecimal getLineTotal() {
        if (price == null) return BigDecimal.ZERO;
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}
