package com.artgallery.model;

/**
 * Artist domain model.
 */
public class Artist {
    private int id;
    private String name;
    private String bio;
    private String profileImage;
    private String country;

    public Artist() {
    }

    public Artist(int id, String name, String bio, String profileImage, String country) {
        this.id = id;
        this.name = name;
        this.bio = bio;
        this.profileImage = profileImage;
        this.country = country;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getBio() { return bio; }
    public void setBio(String bio) { this.bio = bio; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }
}
