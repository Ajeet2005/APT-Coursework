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
                 '/art-gallery/assets/images/placeholder-4.jpg'),
 ('Botanical',  'Florals and still-life botanicals — petals, vines and herbarium studies in classical detail.',
                 '/art-gallery/assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp'),
 ('Gesture',    'Quick figure studies and life-drawing pieces — capturing movement, posture and expression in a single breath.',
                 '/art-gallery/assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg');

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
  '/art-gallery/assets/images/artist-4.jpg', 'Italy'),
 ('Albrecht Durer',
  'Renaissance master whose botanical studies treated weeds and wildflowers with unprecedented scientific care.',
  '/art-gallery/assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp', 'Germany'),
 ('Jan Brueghel the Elder',
  'Flemish painter known for richly detailed flower garlands and still-life bouquets.',
  '/art-gallery/assets/images/botanical/Famous-Flower-Paintings-by-Jan-Brueghel.webp', 'Belgium'),
 ('Martin Johnson Heade',
  'American luminist who paired exotic orchids with hummingbirds in lush tropical scenes.',
  '/art-gallery/assets/images/botanical/Fighting-Humming-Birds-With-Pink-Orchid-by-Martin-Johnson-Heade-Famous-Flower-Painting.webp', 'United States'),
 ('Jan van Huysum',
  'Dutch master of opulent flower-vase compositions in the late Baroque tradition.',
  '/art-gallery/assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp', 'Netherlands'),
 ('Rachel Ruysch',
  'Dutch Golden Age still-life painter celebrated for woodland-floor floral arrangements.',
  '/art-gallery/assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp', 'Netherlands'),
 ('Egon Schiele',
  'Austrian Expressionist whose taut, angular figure studies redefined gesture drawing in the early 20th century.',
  '/art-gallery/assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg', 'Austria'),
 ('Edgar Degas',
  'French Impressionist celebrated for his rapid pastel and pencil studies of dancers and bathers in motion.',
  '/art-gallery/assets/images/gesture/d0393fce770cb800176835915be548cd.jpg', 'France'),
 ('Auguste Rodin',
  'French sculptor whose ink-and-watercolour gesture sketches captured the human body in fluid movement.',
  '/art-gallery/assets/images/gesture/d35d02035a23d2ff3bcc4de3eb6b1a7d.jpg', 'France'),
 ('Kathe Kollwitz',
  'German printmaker whose charcoal figure studies carry stark emotional weight and bold gestural lines.',
  '/art-gallery/assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg', 'Germany'),
 ('Jenny Saville',
  'British contemporary painter whose large-scale gestural figure work bridges classical drawing and modern flesh.',
  '/art-gallery/assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg', 'United Kingdom');

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
   '/art-gallery/assets/images/placeholder-2.jpg', 220.00, 2, 2, 0),

 -- Botanical (category id 5)
 ('Cowslips',
  'Albrecht Durer''s study of cowslips — a foundational work of Renaissance botanical observation.',
  '/art-gallery/assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp',
  12000.00, 5, 5, 1),
 ('Flower Garland',
  'Jan Brueghel the Elder''s richly composed flower bouquet, a Flemish still-life classic.',
  '/art-gallery/assets/images/botanical/Famous-Flower-Paintings-by-Jan-Brueghel.webp',
  14500.00, 5, 6, 1),
 ('Hummingbirds with Pink Orchid',
  'Martin Johnson Heade pairs fighting hummingbirds with a pink orchid in a tropical setting.',
  '/art-gallery/assets/images/botanical/Fighting-Humming-Birds-With-Pink-Orchid-by-Martin-Johnson-Heade-Famous-Flower-Painting.webp',
  13200.00, 5, 7, 0),
 ('Flowers in a Vase',
  'Jan van Huysum''s opulent late-Baroque vase of flowers, jewel-bright and luminous.',
  '/art-gallery/assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp',
  16800.00, 5, 8, 1),
 ('Still Life on Woodland Ground',
  'Rachel Ruysch''s woodland-floor floral still life — Dutch Golden Age botanical painting at its finest.',
  '/art-gallery/assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp',
  15500.00, 5, 9, 0),

 -- Gesture (category id 6)
 ('Seated Figure Study',
  'Egon Schiele''s sharp, expressive line capturing tension and emotion in a single seated pose.',
  '/art-gallery/assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg',
  9800.00, 6, 10, 1),
 ('Dancer in Movement',
  'Edgar Degas''s rapid pastel sketch of a ballerina mid-step — a study of grace in motion.',
  '/art-gallery/assets/images/gesture/d0393fce770cb800176835915be548cd.jpg',
  11500.00, 6, 11, 1),
 ('Reclining Nude',
  'Auguste Rodin''s fluid ink-and-wash gesture drawing — the body rendered in a single sweeping line.',
  '/art-gallery/assets/images/gesture/d35d02035a23d2ff3bcc4de3eb6b1a7d.jpg',
  10200.00, 6, 12, 0),
 ('Figure in Charcoal',
  'Kathe Kollwitz''s heavy, mournful charcoal study — gesture drawing as social commentary.',
  '/art-gallery/assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg',
  8900.00, 6, 13, 1),
 ('Standing Pose, No. 5',
  'Jenny Saville''s contemporary large-scale figure study — bridging anatomical precision and gestural energy.',
  '/art-gallery/assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg',
  13400.00, 6, 14, 0);
