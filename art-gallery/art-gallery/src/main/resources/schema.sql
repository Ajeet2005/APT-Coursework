-- =============================================================
-- Gallery Artisan's — MySQL schema + seed data
-- Run once to create the database and populate starter content.
-- =============================================================

CREATE DATABASE IF NOT EXISTS art_gallery
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE art_gallery;

-- ---------- categories ----------
DROP TABLE IF EXISTS artworks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS subscribers;

CREATE TABLE categories (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80)  NOT NULL,
    description VARCHAR(400) NOT NULL,
    cover_image VARCHAR(300)
) ENGINE=InnoDB;

-- ---------- artists ----------
CREATE TABLE artists (
    id            INT AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(120) NOT NULL,
    bio           TEXT,
    profile_image VARCHAR(300),
    country       VARCHAR(80)
) ENGINE=InnoDB;

-- ---------- artworks ----------
CREATE TABLE artworks (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    title       VARCHAR(160) NOT NULL,
    description TEXT,
    image_url   VARCHAR(300) NOT NULL,
    price       DECIMAL(10, 2),
    category_id INT,
    artist_id   INT,
    featured    TINYINT(1) DEFAULT 0,
    CONSTRAINT fk_artwork_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_artwork_artist   FOREIGN KEY (artist_id)   REFERENCES artists(id)    ON DELETE SET NULL
) ENGINE=InnoDB;

-- ---------- subscribers ----------
CREATE TABLE subscribers (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(80)  NOT NULL,
    last_name  VARCHAR(80),
    email      VARCHAR(200) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =============================================================
-- SEED DATA (placeholders — swap image paths with your own files
-- dropped into webapp/assets/images/)
-- =============================================================

INSERT INTO categories (name, description, cover_image) VALUES
 ('Acrylic',    'Vibrant acrylic works — our flagship collection of bold, colour-saturated paintings.',
                 '/art-gallery/assets/images/placeholder-1.jpg'),
 ('Abstract',   'Forms dissolve and colour leads the eye. Contemporary abstract pieces.',
                 '/art-gallery/assets/images/placeholder-2.jpg'),
 ('Landscape',  'Colour-forward landscapes — mountain, plain and street.',
                 '/art-gallery/assets/images/placeholder-3.jpg'),
 ('Portrait',   'Portraiture that celebrates texture and personality.',
                 '/art-gallery/assets/images/placeholder-4.jpg');

INSERT INTO artists (name, bio, profile_image, country) VALUES
 ('Anika Sharma',
  'Anika is an acrylic painter known for saturated palettes and layered brushwork.',
  '/art-gallery/assets/images/artist-1.jpg', 'Nepal'),
 ('Rohan Verma',
  'Rohan works between abstraction and portraiture, exploring colour as emotion.',
  '/art-gallery/assets/images/artist-2.jpg', 'India'),
 ('Maya Thapa',
  'A landscape painter capturing the Himalayas in lush acrylic strokes.',
  '/art-gallery/assets/images/artist-3.jpg', 'Nepal'),
 ('Luca Moretti',
  'Italian painter fascinated by Mediterranean colour.',
  '/art-gallery/assets/images/artist-4.jpg', 'Italy');

INSERT INTO artworks (title, description, image_url, price, category_id, artist_id, featured) VALUES
 ('Monsoon Bloom',      'A burst of acrylic marigold over indigo.',
   '/art-gallery/assets/images/placeholder-1.jpg', 420.00, 1, 1, 1),
 ('City in Violet',     'Urban abstraction in ultraviolet washes.',
   '/art-gallery/assets/images/placeholder-2.jpg', 560.00, 2, 2, 1),
 ('Himalaya, Dawn',     'A cold pink dawn on the Annapurnas.',
   '/art-gallery/assets/images/placeholder-3.jpg', 780.00, 3, 3, 1),
 ('Portrait of Aria',   'Thick-impasto portrait study.',
   '/art-gallery/assets/images/placeholder-4.jpg', 640.00, 4, 1, 1),
 ('Coastline, Liguria', 'Mediterranean blue on terracotta.',
   '/art-gallery/assets/images/placeholder-5.jpg', 520.00, 3, 4, 1),
 ('Marigold Field',     'Acrylic on canvas, 90x120cm.',
   '/art-gallery/assets/images/placeholder-1.jpg', 480.00, 1, 2, 0),
 ('Studio in Magenta',  'Interior study, acrylic.',
   '/art-gallery/assets/images/placeholder-2.jpg', 390.00, 2, 4, 0),
 ('Evening Walk',       'Street scene after rain.',
   '/art-gallery/assets/images/placeholder-3.jpg', 350.00, 3, 2, 0),
 ('Girl with Peonies',  'Portrait with floral backdrop.',
   '/art-gallery/assets/images/placeholder-4.jpg', 610.00, 4, 3, 0),
 ('Summer Boats',       'Harbour boats at noon.',
   '/art-gallery/assets/images/placeholder-5.jpg', 420.00, 3, 4, 0),
 ('Tangerine Dream',    'Large-format acrylic.',
   '/art-gallery/assets/images/placeholder-1.jpg', 890.00, 1, 1, 0),
 ('Untitled 07',        'Mixed media, small study.',
   '/art-gallery/assets/images/placeholder-2.jpg', 220.00, 2, 2, 0);
