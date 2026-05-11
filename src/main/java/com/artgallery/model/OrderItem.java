package com.artgallery.model;

import java.math.BigDecimal;

public class OrderItem {
    private int id;
    private int orderId;
    private int artworkId;
    private String artworkTitle;
    private int quantity;
    private BigDecimal price;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }

    public int getArtworkId() { return artworkId; }
    public void setArtworkId(int artworkId) { this.artworkId = artworkId; }

    public String getArtworkTitle() { return artworkTitle; }
    public void setArtworkTitle(String artworkTitle) { this.artworkTitle = artworkTitle; }

    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public BigDecimal getSubtotal() {
        if (price == null) return BigDecimal.ZERO;
        return price.multiply(BigDecimal.valueOf(quantity));
    }
}
