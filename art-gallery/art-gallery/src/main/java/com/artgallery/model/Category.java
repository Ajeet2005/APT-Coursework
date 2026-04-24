package com.artgallery.model;

/**
 * Category domain model (e.g. Acrylic, Oil, Abstract).
 */
public class Category {
    private int id;
    private String name;
    private String description;
    private String coverImage;

    public Category() {
    }

    public Category(int id, String name, String description, String coverImage) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.coverImage = coverImage;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getCoverImage() { return coverImage; }
    public void setCoverImage(String coverImage) { this.coverImage = coverImage; }
}
