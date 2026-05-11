-- =======================================================================
-- Gallery Artisan's — MySQL 8.x  Complete Schema + Seed Data
-- =======================================================================
-- HOW TO RUN:
--   Option A (MySQL Workbench):  File → Open SQL Script → Execute (⚡)
--   Option B (command line):     mysql -u root -p < schema.sql
--   Option C (phpMyAdmin):       Import → choose this file → Go
--
-- Database : art_gallery
-- Charset  : utf8mb4 (full Unicode / emoji support)
-- Engine   : InnoDB (transactions + foreign keys)
--
-- ┌─────────────────────────────────────────────────────────────────┐
-- │  FINAL ERD RELATIONSHIPS                                        │
-- │                                                                 │
-- │    users       1 ── *   carts                                   │
-- │    users       1 ── 1   orders        (UNIQUE user_id)          │
-- │    carts       1 ── *   cart_artworks                           │
-- │    categories  1 ── *   artworks                                │
-- │    orders      1 ── *   order_items                             │
-- │    artworks    1 ── *   order_items                             │
-- │                                                                 │
-- │  SHARED SEED CREDENTIALS                                        │
-- │  Role   │  Email                    │  Password                │
-- │─────────┼───────────────────────────┼──────────────────────────│
-- │  admin  │  admin@artgallery.com     │  password                │
-- │  user   │  user@artgallery.com      │  password                │
-- │                                                                 │
-- │  Hashes use BCrypt cost-factor 12 (org.mindrot:jbcrypt:0.4).    │
-- └─────────────────────────────────────────────────────────────────┘
-- =======================================================================

-- ── Create & select the database ────────────────────────────────────────
CREATE DATABASE IF NOT EXISTS art_gallery
    CHARACTER SET  utf8mb4
    COLLATE        utf8mb4_unicode_ci;

USE art_gallery;

-- ── Drop tables in reverse dependency order (safe re-run) ───────────────
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS order_item_artworks;   -- legacy from previous schema iteration
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS cart_artworks;
DROP TABLE IF EXISTS cart_items;        -- legacy name from old schema
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS artworks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS subscribers;
DROP TABLE IF EXISTS users;

SET FOREIGN_KEY_CHECKS = 1;

-- =======================================================================
-- TABLE: users
-- =======================================================================
CREATE TABLE users (
    id            INT          NOT NULL AUTO_INCREMENT,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(255) NOT NULL,
    password_hash VARCHAR(72)  NOT NULL COMMENT 'BCrypt hash (60 chars; 72 = safe margin)',
    role          ENUM('user','admin') NOT NULL DEFAULT 'user',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email),
    INDEX  idx_users_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci
  COMMENT='Registered gallery members and administrators';

INSERT INTO users (full_name, email, password_hash, role) VALUES
(
    'Gallery Admin',
    'admin@artgallery.com',
    '$2a$12$zIe4Yh3eeFZTLquaIlZu0uc5Hy5UhgGGB58eohBZp7tCvRSWG4ROe',
    'admin'
),
(
    'Test User',
    'user@artgallery.com',
    '$2a$12$znWROEzu0Jqp2SIvbeb9DeidzBMtT8GPtsDOObnMFsZPvipVq7VrG',
    'user'
);

-- =======================================================================
-- TABLE: categories       (categories 1 ── * artworks)
-- =======================================================================
CREATE TABLE categories (
    id          INT          NOT NULL AUTO_INCREMENT,
    name        VARCHAR(80)  NOT NULL,
    description VARCHAR(400) NOT NULL DEFAULT '',
    cover_image VARCHAR(300)          DEFAULT NULL COMMENT 'Relative path under webapp/assets/',
    PRIMARY KEY (id),
    UNIQUE KEY uq_category_name (name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: artists
-- =======================================================================
CREATE TABLE artists (
    id            INT          NOT NULL AUTO_INCREMENT,
    name          VARCHAR(120) NOT NULL,
    bio           TEXT                  DEFAULT NULL,
    profile_image VARCHAR(300)          DEFAULT NULL,
    country       VARCHAR(80)           DEFAULT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: artworks         (categories 1 ── * artworks)
-- =======================================================================
CREATE TABLE artworks (
    id          INT             NOT NULL AUTO_INCREMENT,
    title       VARCHAR(160)    NOT NULL,
    description TEXT                     DEFAULT NULL,
    image_url   VARCHAR(300)    NOT NULL,
    price       DECIMAL(12, 2)           DEFAULT NULL,
    category_id INT                      DEFAULT NULL,
    artist_id   INT                      DEFAULT NULL,
    featured    TINYINT(1)      NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    INDEX idx_artwork_category (category_id),
    INDEX idx_artwork_artist   (artist_id),
    INDEX idx_artwork_featured (featured),
    CONSTRAINT fk_artwork_category
        FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL,
    CONSTRAINT fk_artwork_artist
        FOREIGN KEY (artist_id)   REFERENCES artists(id)    ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: subscribers  (newsletter sign-ups)
-- =======================================================================
CREATE TABLE subscribers (
    id         INT          NOT NULL AUTO_INCREMENT,
    first_name VARCHAR(80)  NOT NULL,
    last_name  VARCHAR(80)           DEFAULT NULL,
    email      VARCHAR(255) NOT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_subscriber_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: carts            (users 1 ── * carts)
-- session_id is kept so anonymous browsers can still have a cart.
-- user_id is nullable; it gets filled in once the visitor logs in.
-- No UNIQUE on user_id  →  one user can own many carts over time.
-- =======================================================================
CREATE TABLE carts (
    id         INT          NOT NULL AUTO_INCREMENT,
    session_id VARCHAR(128) NOT NULL,
    user_id    INT                   DEFAULT NULL,
    created_at TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cart_session (session_id),
    INDEX idx_cart_user (user_id),
    CONSTRAINT fk_cart_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: cart_artworks    (carts 1 ── * cart_artworks)
-- Replaces the old cart_items table — each row is one (cart, artwork)
-- link with a quantity.
-- =======================================================================
CREATE TABLE cart_artworks (
    id         INT       NOT NULL AUTO_INCREMENT,
    cart_id    INT       NOT NULL,
    artwork_id INT       NOT NULL,
    quantity   INT       NOT NULL DEFAULT 1,
    added_at   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_cart_artwork (cart_id, artwork_id),
    INDEX idx_cart_artworks_cart    (cart_id),
    INDEX idx_cart_artworks_artwork (artwork_id),
    CONSTRAINT fk_cart_artwork_cart
        FOREIGN KEY (cart_id)    REFERENCES carts(id)    ON DELETE CASCADE,
    CONSTRAINT fk_cart_artwork_artwork
        FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: orders           (users 1 ── 1 orders)
-- UNIQUE on user_id enforces exactly ONE order per user.
-- =======================================================================
CREATE TABLE orders (
    id           INT            NOT NULL AUTO_INCREMENT,
    user_id      INT            NOT NULL,
    total_amount DECIMAL(12, 2) NOT NULL,
    status       ENUM('pending','paid','shipped','completed','cancelled') NOT NULL DEFAULT 'pending',
    created_at   TIMESTAMP      NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_orders_user (user_id),
    CONSTRAINT fk_orders_user
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =======================================================================
-- TABLE: order_items      (orders 1 ── * order_items)
-- Each order_item references exactly ONE artwork.
-- An artwork can appear in many order_items (across different orders).
-- =======================================================================
CREATE TABLE order_items (
    id         INT            NOT NULL AUTO_INCREMENT,
    order_id   INT            NOT NULL,
    artwork_id INT            NOT NULL,
    quantity   INT            NOT NULL DEFAULT 1,
    price      DECIMAL(12, 2) NOT NULL COMMENT 'Unit price at the time of purchase',
    PRIMARY KEY (id),
    INDEX idx_order_items_order   (order_id),
    INDEX idx_order_items_artwork (artwork_id),
    CONSTRAINT fk_order_item_order
        FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    CONSTRAINT fk_order_item_artwork
        FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- =======================================================================
-- SEED DATA
-- =======================================================================

-- ── Categories ──────────────────────────────────────────────────────────
INSERT INTO categories (id, name, description, cover_image) VALUES
(3, 'Landscape',
 'Mountains, fields and starlit skies — colour-forward landscapes that put nature centre-stage.',
 'assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg'),

(4, 'Portrait',
 'Portraiture that celebrates texture and personality — Mona Lisa, Vermeer''s pearl, Van Gogh''s self.',
 'assets/images/portraits/Mona-Lisa-oil-painting-on-poplar-wood-by-Leonardo-da-Vinci.webp'),

(5, 'Botanical',
 'Florals and still-life botanicals — petals, vines and herbarium studies in classical detail.',
 'assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp'),

(6, 'Gesture',
 'Quick figure studies and life-drawing pieces — capturing movement, posture and expression in a single breath.',
 'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg'),

(7, 'Still Life',
 'Bowls, glass and fruit at quiet rest — masterworks of arrangement, light and patience.',
 'assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg');

-- ── Artists ─────────────────────────────────────────────────────────────
INSERT INTO artists (id, name, bio, profile_image, country) VALUES
(1, 'Leonardo Davinci',
 'Italian polymath of the High Renaissance who was active as a painter, draughtsman, engineer, scientist, theorist, sculptor, and architect.',
 'assets/images/Artists/davinci.jpg', 'Italy'),

(2, 'Rohan Verma',
 'Rohan works between abstraction and portraiture, exploring colour as emotion.',
 'assets/images/Artists/rohan.png', 'India'),

(3, 'Maya Thapa',
 'A landscape painter capturing the Himalayas in lush acrylic strokes.',
 'assets/images/Artists/maya.jpg', 'Nepal'),

(4, 'Luca Moretti',
 'Italian painter fascinated by Mediterranean colour.',
 'assets/images/Artists/Luca.jpg', 'Italy'),

(5, 'Albrecht Dürer',
 'Renaissance master whose botanical studies treated weeds and wildflowers with unprecedented scientific care.',
 'assets/images/Artists/Albrech.jpg', 'Germany'),

(6, 'Jan Brueghel the Elder',
 'Flemish painter known for richly detailed flower garlands and still-life bouquets.',
 'assets/images/Artists/Jan.jpg', 'Belgium'),

(7, 'Martin Johnson Heade',
 'American luminist who paired exotic orchids with hummingbirds in lush tropical scenes.',
 'assets/images/Artists/Martin-johnson-heade.jpg', 'United States'),

(8, 'Jan van Huysum',
 'Dutch master of opulent flower-vase compositions in the late Baroque tradition.',
 'assets/images/Artists/Jan_van_Huysum.jpg', 'Netherlands'),

(9, 'Rachel Ruysch',
 'Dutch Golden Age still-life painter celebrated for woodland-floor floral arrangements.',
 'assets/images/Artists/Rachel_Ruysch.jpg', 'Netherlands'),

(10, 'Egon Schiele',
 'Austrian Expressionist whose taut, angular figure studies redefined gesture drawing in the early 20th century.',
 'assets/images/Artists/Egon_Schiele_photo.jpg', 'Austria'),

(11, 'Edgar Degas',
 'French Impressionist celebrated for his rapid pastel and pencil studies of dancers and bathers in motion.',
 'assets/images/Artists/edgar-degas.jpg', 'France'),

(12, 'Auguste Rodin',
 'French sculptor whose ink-and-watercolour gesture sketches captured the human body in fluid movement.',
 'assets/images/Artists/Auguste_Rodin.jpg', 'France'),

(13, 'Käthe Kollwitz',
 'German printmaker whose charcoal figure studies carry stark emotional weight and bold gestural lines.',
 'assets/images/Artists/Kathe_Kollwit.jpg', 'Germany'),

(14, 'Jenny Saville',
 'British contemporary painter whose large-scale gestural figure work bridges classical drawing and modern flesh.',
 'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg', 'United Kingdom'),

(15, 'Pieter Claesz',
 'Dutch Golden Age master of vanitas still life — skulls, candles and pewter rendered with sober precision.',
 'assets/images/Artists/Pieter.jpg', 'Netherlands'),

(16, 'Floris van Schooten',
 'Dutch still-life painter known for breakfast tables — bread, butter, cheese and glass in soft northern light.',
 'assets/images/Artists/Floris.png', 'Netherlands'),

(17, 'Claude Monet',
 'French Impressionist whose late still-life works captured fruit and flowers in shimmering brushwork.',
 'assets/images/Artists/Claude_Monet_1899_Nadar_crop.jpg', 'France'),

(18, 'Vincent van Gogh',
 'Post-Impressionist Dutch painter whose swirling, emotional landscapes redefined modern art.',
 'assets/images/Artists/Vincent.jpg', 'Netherlands'),

(19, 'Kobit Gurung',
 'Self Taught Watercolor artist.',
 'assets/images/Artists/Kobit.jpg', 'Nepal');

-- ── Artworks (prices in Nepali Rupees) ──────────────────────────────────
INSERT INTO artworks (id, title, description, image_url, price, category_id, artist_id, featured) VALUES
-- Landscape
(3,  'Himalaya, Dawn',
     'A cold pink dawn on the Annapurnas — Maya Thapa''s Nepali high-altitude landscape.',
     'assets/images/landscape/NB_Gurung-9.jpg',                                            13800.00, 3, 3, 1),

(5,  'Coastline, Liguria',
     'Mediterranean blue on terracotta — Luca Moretti''s seaside study.',
     'assets/images/landscape/3a12ecb0e6aac4ee9656b91bfd0eab45.jpg',                       12200.00, 3, 4, 1),

(8,  'Evening Walk',
     'Street scene after rain — atmospheric and quiet.',
     'assets/images/landscape/688030957_10236896616107395_2084544777254968889_n.jpg',       9500.00,  3, 2, 0),

(10, 'Summer Boats',
     'Harbour boats at noon — warm light on still water.',
     'assets/images/landscape/images.jpg',                                                   8800.00,  3, 4, 0),

(31, 'Starry Night',
     'Vincent van Gogh''s swirling night sky over a sleeping village — one of the most iconic landscapes.',
     'assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg',                 24800.00, 3, 18, 1),

(33, 'Yaks of the High Himalaya',
     'A watercolour landscape by Kobit Gurung — a herd of yaks crossing a snow-blanketed Himalayan valley under a brooding sky.',
     'assets/images/landscape/yak.jpg',                                      16800.00, 3, 19, 1),

-- Portrait
(4,  'Mona Lisa',
     'Leonardo da Vinci''s enigmatic Renaissance portrait — the most famous painting in the world.',
     'assets/images/portraits/Mona-Lisa-oil-painting-on-poplar-wood-by-Leonardo-da-Vinci.webp', 28000.00, 4, 1, 1),

(9,  'Girl with a Pearl Earring',
     'Vermeer''s luminous Dutch Golden Age portrait — soft light and quiet poise.',
     'assets/images/portraits/912px-1665_Girl_with_a_Pearl_Earring.jpg',                   24500.00, 4, 3, 0),

(23, 'Self Portrait',
     'Vincent van Gogh''s self-portrait — vivid, restless brushwork over a turquoise ground.',
     'assets/images/portraits/Van_Gogh_Self_Portrait_600x600.jpg',                         22500.00, 4, 18, 1),

(24, 'Man with Sheet Music',
     'A 17th-century portrait of a musician — ruff collar, sheet music, baroque gravity.',
     'assets/images/portraits/man-sheet-music-1633-portrait-600nw-2637337371.webp',        14800.00, 4, 4, 1),

(25, 'Studio Portrait',
     'A contemporary portrait study — quiet warmth in a single sitting.',
     'assets/images/portraits/8a843573553fc6e692350b9e84881223.jpg',                        9800.00,  4, 2, 0),

(32, 'Gurung Traditional dance Ghantu',
     'A watercolour portrait by Kobit Gurung — a meditative figure in ceremonial Nepali adornment, rendered in soft washes of ochre, crimson and gold.',
     'assets/images/portraits/gantu.jpg',                                  15500.00, 4, 19, 1),

-- Botanical
(13, 'Cowslips',
     'Albrecht Dürer''s study of cowslips — a foundational work of Renaissance botanical observation.',
     'assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp',   12000.00, 5, 5, 1),

(14, 'Flower Garland',
     'Jan Brueghel the Elder''s richly composed flower bouquet — a Flemish still-life classic.',
     'assets/images/botanical/Famous-Flower-Paintings-by-Jan-Brueghel.webp',               14500.00, 5, 6, 1),

(15, 'Hummingbirds with Pink Orchid',
     'Martin Johnson Heade pairs fighting hummingbirds with a pink orchid in a tropical setting.',
     'assets/images/botanical/Fighting-Humming-Birds-With-Pink-Orchid-by-Martin-Johnson-Heade-Famous-Flower-Painting.webp',
     13200.00, 5, 7, 0),

(16, 'Flowers in a Vase',
     'Jan van Huysum''s opulent late-Baroque vase of flowers — jewel-bright and luminous.',
     'assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp', 16800.00, 5, 8, 1),

(17, 'Still Life on Woodland Ground',
     'Rachel Ruysch''s woodland-floor floral still life — Dutch Golden Age botanical painting at its finest.',
     'assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp',
     15500.00, 5, 9, 0),

-- Gesture
(18, 'Seated Figure Study',
     'Egon Schiele''s sharp, expressive line capturing tension and emotion in a single seated pose.',
     'assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg',                          9800.00,  6, 10, 1),

(19, 'Dancer in Movement',
     'Edgar Degas''s rapid pastel sketch of a ballerina mid-step — a study of grace in motion.',
     'assets/images/gesture/d0393fce770cb800176835915be548cd.jpg',                         11500.00, 6, 11, 1),

(20, 'Reclining Nude',
     'Auguste Rodin''s fluid ink-and-wash gesture drawing — the body rendered in a single sweeping line.',
     'assets/images/gesture/d35d02035a23d2ff3bcc4de3eb6b1a7d.jpg',                        10200.00, 6, 12, 0),

(21, 'Figure in Charcoal',
     'Käthe Kollwitz''s heavy, mournful charcoal study — gesture drawing as social commentary.',
     'assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg',                          8900.00,  6, 13, 1),

(22, 'Standing Pose, No. 5',
     'Jenny Saville''s contemporary large-scale figure study — bridging anatomical precision and gestural energy.',
     'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg',                         13400.00, 6, 14, 0),

-- Still Life
(26, 'Vanitas Still Life',
     'Pieter Claesz''s sober meditation on impermanence — skull, candle, hourglass and pewter in Dutch realism.',
     'assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg',17800.00, 7, 15, 1),

(27, 'Breakfast Still Life',
     'Floris van Schooten''s breakfast table — bread, butter and cheese in pale northern light.',
     'assets/images/stilllife/Still-Life-with-Glass-Cheese-Butter-and-Cake-Floris-Gerritsz-Van-Schooten-Oil-Painting.jpg',
     15400.00, 7, 16, 1),

(28, 'Still Life with Melon',
     'Monet''s late-Impressionist study of melon and fruit — quick brushwork meets quiet composition.',
     'assets/images/stilllife/Still-life-with-melon-by-one-of-the-famous-still-life-artists-Claude-Monet.webp',
     16200.00, 7, 17, 1),

(29, 'Composition with Fruit',
     'A bright modern still life — bowl of fruit and an open book on a sunlit table.',
     'assets/images/stilllife/6260.jpg',                                                   11900.00, 7, 6, 0),

(30, 'Famous Still Life Study',
     'A reference composition gathered from the canon of European still-life painting.',
     'assets/images/stilllife/Famous-Still-Life-Artists-and-Paintings.jpg',                 9500.00,  7, 8, 0);


-- ── Orders ──────────────────────────────────────────────────────────────
-- NOTE: only ONE order per user is allowed (UNIQUE user_id).
-- The single order for the Test User (id=2) bundles every previously-
-- separate purchase into one consolidated order made up of multiple
-- order_items, each of which can contain multiple artworks.
INSERT INTO orders (id, user_id, total_amount, status, created_at) VALUES
(1, 2, 93100.00, 'completed', '2026-05-01 10:00:00');

-- ── Order items (orders 1 ── * order_items) ─────────────────────────────
-- Five line items make up the single order for the Test User (total 93,100).
INSERT INTO order_items (order_id, artwork_id, quantity, price) VALUES
(1, 3,  1, 13800.00),
(1, 31, 1, 24800.00),
(1, 14, 1, 14500.00),
(1, 13, 1, 12000.00),
(1, 4,  1, 28000.00);


-- =======================================================================
-- QUICK VERIFICATION QUERIES (uncomment after import to check)
-- =======================================================================
-- SELECT 'users'               AS tbl, COUNT(*) AS rows FROM users;
-- SELECT 'categories'          AS tbl, COUNT(*) AS rows FROM categories;
-- SELECT 'artists'             AS tbl, COUNT(*) AS rows FROM artists;
-- SELECT 'artworks'            AS tbl, COUNT(*) AS rows FROM artworks;
-- SELECT 'subscribers'         AS tbl, COUNT(*) AS rows FROM subscribers;
-- SELECT 'carts'               AS tbl, COUNT(*) AS rows FROM carts;
-- SELECT 'cart_artworks'       AS tbl, COUNT(*) AS rows FROM cart_artworks;
-- SELECT 'orders'              AS tbl, COUNT(*) AS rows FROM orders;
-- SELECT 'order_items'         AS tbl, COUNT(*) AS rows FROM order_items;
