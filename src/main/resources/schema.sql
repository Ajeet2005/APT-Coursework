-- =============================================================
-- Gallery Artisan's — MySQL schema + seed data
-- Run once to create the database and populate starter content.
-- =============================================================

CREATE DATABASE IF NOT EXISTS art_gallery
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;
USE art_gallery;

-- ---------- categories ----------
DROP TABLE IF EXISTS cart_items;
DROP TABLE IF EXISTS carts;
DROP TABLE IF EXISTS artworks;
DROP TABLE IF EXISTS artists;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS subscribers;
DROP TABLE IF EXISTS users;


-- ---------- users / authentication ----------
CREATE TABLE users (
    id            INT          NOT NULL AUTO_INCREMENT,
    full_name     VARCHAR(120) NOT NULL,
    email         VARCHAR(200) NOT NULL,
    password_hash VARCHAR(60)  NOT NULL,
    role          ENUM('user','admin') NOT NULL DEFAULT 'user',
    created_at    DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_users_email (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Seed auth users.
-- Both accounts use password: password
INSERT INTO users (full_name, email, password_hash, role) VALUES
('Gallery Admin', 'admin@artgallery.com', '$2a$12$An0z0/8pUslVOqwXD8QRB.mdq6L1LCcA.zVXP5vzOnkWzRXcGP4nK', 'admin'),
('Test User',     'user@artgallery.com',  '$2a$12$7OTu69pfuEHdtOeNsXymv.qIcWE5DSQ.ZE3irkuuqhvKGdE2mGCkG',  'user');

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

-- ---------- carts (one per browser session) ----------
CREATE TABLE carts (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    session_id VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- ---------- cart_items (artworks added to a cart) ----------
CREATE TABLE cart_items (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    cart_id    INT NOT NULL,
    artwork_id INT NOT NULL,
    quantity   INT NOT NULL DEFAULT 1,
    added_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_item_cart    FOREIGN KEY (cart_id)    REFERENCES carts(id)    ON DELETE CASCADE,
    CONSTRAINT fk_cart_item_artwork FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE,
    UNIQUE KEY ux_cart_artwork (cart_id, artwork_id)
) ENGINE=InnoDB;

-- =============================================================
-- SEED DATA (placeholders — swap image paths with your own files
-- dropped into webapp/assets/images/)
-- =============================================================

INSERT INTO categories (id, name, description, cover_image) VALUES
 (3, 'Landscape',  'Mountains, fields and starlit skies — colour-forward landscapes that put nature centre-stage.',
                   'assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg'),
 (4, 'Portrait',   'Portraiture that celebrates texture and personality — Mona Lisa, Vermeer''s pearl, Van Gogh''s self.',
                   'assets/images/portraits/Mona-Lisa-oil-painting-on-poplar-wood-by-Leonardo-da-Vinci.webp'),
 (5, 'Botanical',  'Florals and still-life botanicals — petals, vines and herbarium studies in classical detail.',
                   'assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp'),
 (6, 'Gesture',    'Quick figure studies and life-drawing pieces — capturing movement, posture and expression in a single breath.',
                   'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg'),
 (7, 'Still Life', 'Bowls, glass and fruit at quiet rest — masterworks of arrangement, light and patience.',
                   'assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg');

INSERT INTO artists (name, bio, profile_image, country) VALUES
 ('Anika Sharma',
  'Anika is an acrylic painter known for saturated palettes and layered brushwork.',
  'assets/images/portraits/8a843573553fc6e692350b9e84881223.jpg', 'Nepal'),
 ('Rohan Verma',
  'Rohan works between abstraction and portraiture, exploring colour as emotion.',
  'assets/images/portraits/912px-1665_Girl_with_a_Pearl_Earring.jpg', 'India'),
 ('Maya Thapa',
  'A landscape painter capturing the Himalayas in lush acrylic strokes.',
  'assets/images/portraits/Van_Gogh_Self_Portrait_600x600.jpg', 'Nepal'),
 ('Luca Moretti',
  'Italian painter fascinated by Mediterranean colour.',
  'assets/images/portraits/man-sheet-music-1633-portrait-600nw-2637337371.webp', 'Italy'),
 ('Albrecht Durer',
  'Renaissance master whose botanical studies treated weeds and wildflowers with unprecedented scientific care.',
  'assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp', 'Germany'),
 ('Jan Brueghel the Elder',
  'Flemish painter known for richly detailed flower garlands and still-life bouquets.',
  'assets/images/botanical/Famous-Flower-Paintings-by-Jan-Brueghel.webp', 'Belgium'),
 ('Martin Johnson Heade',
  'American luminist who paired exotic orchids with hummingbirds in lush tropical scenes.',
  'assets/images/botanical/Fighting-Humming-Birds-With-Pink-Orchid-by-Martin-Johnson-Heade-Famous-Flower-Painting.webp', 'United States'),
 ('Jan van Huysum',
  'Dutch master of opulent flower-vase compositions in the late Baroque tradition.',
  'assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp', 'Netherlands'),
 ('Rachel Ruysch',
  'Dutch Golden Age still-life painter celebrated for woodland-floor floral arrangements.',
  'assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp', 'Netherlands'),
 ('Egon Schiele',
  'Austrian Expressionist whose taut, angular figure studies redefined gesture drawing in the early 20th century.',
  'assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg', 'Austria'),
 ('Edgar Degas',
  'French Impressionist celebrated for his rapid pastel and pencil studies of dancers and bathers in motion.',
  'assets/images/gesture/d0393fce770cb800176835915be548cd.jpg', 'France'),
 ('Auguste Rodin',
  'French sculptor whose ink-and-watercolour gesture sketches captured the human body in fluid movement.',
  'assets/images/gesture/d35d02035a23d2ff3bcc4de3eb6b1a7d.jpg', 'France'),
 ('Kathe Kollwitz',
  'German printmaker whose charcoal figure studies carry stark emotional weight and bold gestural lines.',
  'assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg', 'Germany'),
 ('Jenny Saville',
  'British contemporary painter whose large-scale gestural figure work bridges classical drawing and modern flesh.',
  'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg', 'United Kingdom'),
 ('Pieter Claesz',
  'Dutch Golden Age master of vanitas still life — skulls, candles and pewter rendered with sober precision.',
  'assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg', 'Netherlands'),
 ('Floris van Schooten',
  'Dutch still-life painter known for breakfast tables — bread, butter, cheese and glass arranged in soft northern light.',
  'assets/images/stilllife/Still-Life-with-Glass-Cheese-Butter-and-Cake-Floris-Gerritsz-Van-Schooten-Oil-Painting.jpg', 'Netherlands'),
 ('Claude Monet',
  'French Impressionist whose late still-life works captured fruit and flowers in shimmering brushwork.',
  'assets/images/stilllife/Still-life-with-melon-by-one-of-the-famous-still-life-artists-Claude-Monet.webp', 'France'),
 ('Vincent van Gogh',
  'Post-Impressionist Dutch painter whose swirling, emotional landscapes redefined modern art.',
  'assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg', 'Netherlands');


INSERT INTO `artworks` (`id`, `title`, `description`, `image_url`, `price`, `category_id`, `artist_id`, `featured`) VALUES
(3, 'Himalaya, Dawn', 'A cold pink dawn on the Annapurnas — Maya Thapa''s Nepali high-altitude landscape.', 'assets/images/landscape/NB_Gurung-9.jpg', 13800.00, 3, 3, 1),
(4, 'Mona Lisa', 'Leonardo da Vinci''s enigmatic Renaissance portrait — the most famous painting in the world.', 'assets/images/portraits/Mona-Lisa-oil-painting-on-poplar-wood-by-Leonardo-da-Vinci.webp', 28000.00, 4, 1, 1),
(5, 'Coastline, Liguria', 'Mediterranean blue on terracotta — Luca Moretti''s seaside study.', 'assets/images/landscape/3a12ecb0e6aac4ee9656b91bfd0eab45.jpg', 12200.00, 3, 4, 1),
(8, 'Evening Walk', 'Street scene after rain — atmospheric and quiet.', 'assets/images/landscape/688030957_10236896616107395_2084544777254968889_n.jpg', 9500.00, 3, 2, 0),
(9, 'Girl with a Pearl Earring', 'Vermeer''s luminous Dutch Golden Age portrait — soft light and quiet poise.', 'assets/images/portraits/912px-1665_Girl_with_a_Pearl_Earring.jpg', 24500.00, 4, 3, 0),
(10, 'Summer Boats', 'Harbour boats at noon — warm light on still water.', 'assets/images/landscape/images.jpg', 8800.00, 3, 4, 0),
(13, 'Cowslips', 'Albrecht Durer\'s study of cowslips — a foundational work of Renaissance botanical observation.', 'assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp', 12000.00, 5, 5, 1),
(14, 'Flower Garland', 'Jan Brueghel the Elder\'s richly composed flower bouquet, a Flemish still-life classic.', 'assets/images/botanical/Famous-Flower-Paintings-by-Jan-Brueghel.webp', 14500.00, 5, 6, 1),
(15, 'Hummingbirds with Pink Orchid', 'Martin Johnson Heade pairs fighting hummingbirds with a pink orchid in a tropical setting.', 'assets/images/botanical/Fighting-Humming-Birds-With-Pink-Orchid-by-Martin-Johnson-Heade-Famous-Flower-Painting.webp', 13200.00, 5, 7, 0),
(16, 'Flowers in a Vase', 'Jan van Huysum\'s opulent late-Baroque vase of flowers, jewel-bright and luminous.', 'assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp', 16800.00, 5, 8, 1),
(17, 'Still Life on Woodland Ground', 'Rachel Ruysch\'s woodland-floor floral still life — Dutch Golden Age botanical painting at its finest.', 'assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp', 15500.00, 5, 9, 0),
(18, 'Seated Figure Study', 'Egon Schiele\'s sharp, expressive line capturing tension and emotion in a single seated pose.', 'assets/images/gesture/384554027b97b51617d5168521a56bf6.jpg', 9800.00, 6, 10, 1),
(19, 'Dancer in Movement', 'Edgar Degas\'s rapid pastel sketch of a ballerina mid-step — a study of grace in motion.', 'assets/images/gesture/d0393fce770cb800176835915be548cd.jpg', 11500.00, 6, 11, 1),
(20, 'Reclining Nude', 'Auguste Rodin\'s fluid ink-and-wash gesture drawing — the body rendered in a single sweeping line.', 'assets/images/gesture/d35d02035a23d2ff3bcc4de3eb6b1a7d.jpg', 10200.00, 6, 12, 0),
(21, 'Figure in Charcoal', 'Kathe Kollwitz\'s heavy, mournful charcoal study — gesture drawing as social commentary.', 'assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg', 8900.00, 6, 13, 1),
(22, 'Standing Pose, No. 5', 'Jenny Saville\'s contemporary large-scale figure study — bridging anatomical precision and gestural energy.', 'assets/images/gesture/fa0afd5cd201b416416d21cae52f58ae.jpg', 13400.00, 6, 14, 0),
(23, 'Self Portrait', 'Vincent van Gogh''s self-portrait — vivid, restless brushwork over a turquoise ground.', 'assets/images/portraits/Van_Gogh_Self_Portrait_600x600.jpg', 22500.00, 4, 18, 1),
(24, 'Man with Sheet Music', 'A 17th-century portrait of a musician — ruff collar, sheet music, baroque gravity.', 'assets/images/portraits/man-sheet-music-1633-portrait-600nw-2637337371.webp', 14800.00, 4, 4, 1),
(25, 'Studio Portrait', 'A contemporary contemporary portrait study — quiet warmth in a single sitting.', 'assets/images/portraits/8a843573553fc6e692350b9e84881223.jpg', 9800.00, 4, 2, 0),
(26, 'Vanitas Still Life', 'Pieter Claesz''s sober meditation on impermanence — skull, candle, hourglass and pewter rendered in masterful Dutch realism.', 'assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg', 17800.00, 7, 15, 1),
(27, 'Breakfast Still Life', 'Floris van Schooten''s breakfast table — bread, butter and cheese caught in pale northern light.', 'assets/images/stilllife/Still-Life-with-Glass-Cheese-Butter-and-Cake-Floris-Gerritsz-Van-Schooten-Oil-Painting.jpg', 15400.00, 7, 16, 1),
(28, 'Still Life with Melon', 'Monet''s late-Impressionist study of melon and fruit — quick brushwork meets quiet composition.', 'assets/images/stilllife/Still-life-with-melon-by-one-of-the-famous-still-life-artists-Claude-Monet.webp', 16200.00, 7, 17, 1),
(29, 'Composition with Fruit', 'A bright modern still life — bowl of fruit and an open book on a sunlit table.', 'assets/images/stilllife/6260.jpg', 11900.00, 7, 6, 0),
(30, 'Famous Still Life Study', 'A reference composition gathered from the canon of European still-life painting.', 'assets/images/stilllife/Famous-Still-Life-Artists-and-Paintings.jpg', 9500.00, 7, 8, 0),
(31, 'Starry Night', 'Vincent van Gogh''s swirling night sky over a sleeping village — one of the most iconic landscapes in Western art.', 'assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg', 24800.00, 3, 18, 1);
