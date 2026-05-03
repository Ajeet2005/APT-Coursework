# Gallery Artisan's

A minimal, colour-forward art gallery website — JSP + Servlet + DAO, MVC, Maven, MySQL, built for **Tomcat 10.1 (Jakarta EE 10)** on **Java 17**.

---

## 1. Project layout (MVC)

```
art-gallery/
├── pom.xml
├── README.md
└── src/
    └── main/
        ├── java/
        │   └── com/artgallery/
        │       ├── model/       # POJOs: Artist, Artwork, Category, Subscriber
        │       ├── dao/         # JDBC DAOs for each model
        │       ├── servlet/     # Controllers: Home, Category, Art, Artist, Gallery, Newsletter
        │       └── util/        # DBConnection
        ├── resources/
        │   └── schema.sql       # MySQL schema + seed data
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml
            │   └── views/       # JSPs (not directly routable)
            │       ├── includes/ (header.jsp, footer.jsp)
            │       ├── home.jsp, categories.jsp, art.jsp, artist.jsp, gallery.jsp,
            │       ├── art-detail.jsp, 404.jsp
            ├── assets/
            │   ├── css/style.css
            │   ├── js/main.js
            │   ├── images/      # drop placeholder-1.jpg .. placeholder-5.jpg, artist-*.jpg, gallery-wall.jpg, hero-poster.jpg here
            │   └── videos/      # drop hero.mp4 (b-roll of painting) here
            └── index.jsp        # redirects to /home
```

---

## 2. Prerequisites

- **JDK 17**
- **Apache Maven 3.8+**
- **MySQL 8.x**
- **Apache Tomcat 10.1.x** (Jakarta EE 10)
- **IntelliJ IDEA Ultimate** (Community doesn't ship Tomcat integration — Ultimate or the `Smart Tomcat` plugin is needed)

---

## 3. Database setup

```bash
mysql -u root -p < src/main/resources/schema.sql
```

This creates the `art_gallery` database, tables (`categories`, `artists`, `artworks`, `subscribers`), and seeds sample content.

If your MySQL credentials differ from `root / root`, either edit `com.artgallery.util.DBConnection` or set environment variables before Tomcat starts:

```
DB_URL=jdbc:mysql://localhost:3306/art_gallery?useSSL=false&serverTimezone=UTC
DB_USER=<user>
DB_PASSWORD=<password>
```

---

## 4. Running in IntelliJ IDEA

1. `File → Open…` → select the `art-gallery` folder (the one with `pom.xml`).
2. Let Maven import. You should see dependencies for `jakarta.servlet-api`, `jstl`, and `mysql-connector-j`.
3. `Run → Edit Configurations… → + → Tomcat Server → Local`.
4. **Application server**: point to your Tomcat 10.1 installation.
5. Switch to the **Deployment** tab → `+` → **Artifact…** → `art-gallery:war exploded`.
   - Set **Application context** to `/art-gallery`.
6. On the **Server** tab, set **URL** to `http://localhost:8080/art-gallery/`.
7. Click **Run** (green play). Tomcat will start and open the browser to the home page.

> If you use Community Edition, install the **Smart Tomcat** plugin; the configuration is similar.

---

## 5. Build a WAR from the command line

```bash
mvn clean package
```

Outputs `target/art-gallery.war`. Drop it in your Tomcat's `webapps/` and restart.

---

## 6. Where to put your own content

| Thing              | Path                                          |
| ------------------ | --------------------------------------------- |
| Hero b-roll video  | `src/main/webapp/assets/videos/hero.mp4`      |
| Hero poster frame  | `src/main/webapp/assets/images/hero-poster.jpg` |
| Painting images    | `src/main/webapp/assets/images/placeholder-1.jpg` … `placeholder-5.jpg` (referenced in `schema.sql`) |
| Artist portraits   | `src/main/webapp/assets/images/artist-1.jpg` … `artist-4.jpg` |
| Gallery-wall strip | `src/main/webapp/assets/images/gallery-wall.jpg` (shown under the newsletter) |

You can replace the placeholder file names in `schema.sql` with whatever paths you actually upload.

---

## 7. Routes

| URL                     | Servlet             | View                             |
| ----------------------- | ------------------- | -------------------------------- |
| `/` or `/home`          | `HomeServlet`       | `home.jsp`                       |
| `/categories`           | `CategoryServlet`   | `categories.jsp`                 |
| `/categories?id={id}`   | `CategoryServlet`   | `categories.jsp` + artworks list |
| `/art`                  | `ArtServlet`        | `art.jsp`                        |
| `/art?id={id}`          | `ArtServlet`        | `art-detail.jsp`                 |
| `/artist`               | `ArtistServlet`     | `artist.jsp`                     |
| `/artist?id={id}`       | `ArtistServlet`     | `artist.jsp` + works list        |
| `/gallery`              | `GalleryServlet`    | `gallery.jsp` (full wall)        |
| `/newsletter` (POST)    | `NewsletterServlet` | forwards back to `/home`         |

---

## 8. Theme notes

- Dark/purple gradient theme matching the uploaded mockup.
- **Cormorant Garamond** (display) + **Inter** (UI) via Google Fonts.
- The highlighted-slideshow effect (colour only in centre, grayscale for neighbours) is driven by the `.is-active` class that `assets/js/main.js` toggles; the CSS rules live in `assets/css/style.css` under `.slide` / `.slide.is-active`.
- The mini gallery + full gallery use asymmetric grid rhythms (yak-biergarten style).

Enjoy building on top of it.
