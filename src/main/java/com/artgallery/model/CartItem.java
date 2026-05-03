package com.artgallery.model;

import java.math.BigDecimal;

/**
 * One row in a user's cart. Joins with the artwork it points at,
 * so the JSP can render image, title, price without a second query.
 */
public class CartItem {
    private int id;
    private int cartId;
    private int artworkId;
    private int quantity;

    // joined artwork fields (filled by CartDAO via JOIN)
    private String title;
    private String imageUrl;
    private BigDecimal price;
    private String artistName;

    public CartItem() {
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getCartId() { return cartId; }
    public void setCartId(int cartId) { this.cartId = cartId; }

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

    /** Subtotal for this row = price * quantity. */
    public BigDecimal getSubtotal() {
        if (price == null) return BigDecimal.ZERO;
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}
