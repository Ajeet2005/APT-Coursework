# Art Gallery — A Plain-English Walkthrough

A complete guide to understanding every file in this project, written for someone learning Java web development for the first time. Read it top to bottom and by the end you'll understand how a real Java website is built.

---

## 1. The big picture — what this project actually is

Imagine a website like Amazon, but for paintings. A user opens their browser, types `http://localhost:8081/art-gallery/categories`, and a page loads showing categories of art (Acrylic, Botanical, Gesture, etc.). They click one and see paintings to buy.

That's this project. The whole thing has four moving pieces:

```
Browser  ───►  Tomcat (web server)  ───►  Java code  ───►  MySQL (database)
   ▲                                                              │
   └──────────────── HTML page comes back ◄───────────────────────┘
```

1. **Browser** — sends a request like "show me /categories"
2. **Tomcat** — receives the request, finds the right Java code to handle it
3. **Java code** — asks the database for data, prepares a page
4. **MySQL** — stores the actual paintings, artists, categories
5. **Page returns** — Tomcat sends the finished HTML back to the browser

---

## 2. The MVC pattern — the most important idea in the whole project

**MVC = Model, View, Controller.** Every modern web app uses this pattern. Once you understand it, you understand the whole project.

| Letter | Name | Job | Real example in this project |
|---|---|---|---|
| **M** | Model | Holds data | `Artwork.java` — has fields like `title`, `price` |
| **V** | View | Shows data to user | `botanical.jsp` — the HTML page |
| **C** | Controller | Connects them | `BotanicalServlet.java` — receives clicks, fetches data, picks a view |

**Why split it up?** So you can change one piece without breaking the others. Want to redesign the page? Edit only the View. Want to change how prices are stored? Edit only the Model.

### A request walked through MVC

When a user visits **`/botanical`** (the Botanical page):

1. **Tomcat** sees the URL `/botanical` and looks for a servlet (Controller) that handles it.
2. **`BotanicalServlet.java`** runs — it's the Controller.
3. The Controller asks **`CategoryDAO`** and **`ArtworkDAO`** (helpers that talk to the database) for data.
4. Those return **`Category` and `Artwork` objects** — these are the Models (just data containers).
5. The Controller hands the Models to **`botanical.jsp`** — the View.
6. The JSP loops over the artworks, generates HTML, and Tomcat sends it back to the browser.

---

## 3. Folder map — everything in this project

```
art-gallery/                              ← Project root
│
├── pom.xml                               ← Maven config: lists dependencies (libraries)
├── README.md                             ← Original project notes
├── LEARN.md                              ← This file
│
└── src/
    └── main/
        │
        ├── java/                         ← All Java source code lives here
        │   └── com/artgallery/
        │       │
        │       ├── model/                ← (M) Data containers (POJOs)
        │       │   ├── Artist.java       ← Just holds: name, bio, country
        │       │   ├── Artwork.java      ← Just holds: title, price, image URL
        │       │   ├── Category.java     ← Just holds: id, name, description
        │       │   └── Subscriber.java   ← Just holds: name, email
        │       │
        │       ├── dao/                  ← Database helpers (Data Access Objects)
        │       │   ├── ArtistDAO.java    ← Gets artists from MySQL
        │       │   ├── ArtworkDAO.java   ← Gets artworks from MySQL (with search!)
        │       │   ├── CategoryDAO.java  ← Gets categories from MySQL
        │       │   └── SubscriberDAO.java← Saves newsletter signups
        │       │
        │       ├── servlet/              ← (C) Controllers — handle URLs
        │       │   ├── HomeServlet.java       ← URL: /home
        │       │   ├── CategoryServlet.java   ← URL: /categories
        │       │   ├── BotanicalServlet.java  ← URL: /botanical
        │       │   ├── GestureServlet.java    ← URL: /gesture
        │       │   ├── ArtServlet.java        ← URL: /art (with search/filter)
        │       │   ├── ArtistServlet.java     ← URL: /artist
        │       │   ├── GalleryServlet.java    ← URL: /gallery
        │       │   └── NewsletterServlet.java ← URL: /newsletter (form POST)
        │       │
        │       └── util/                 ← Utilities
        │           └── DBConnection.java ← Opens connections to MySQL
        │
        ├── resources/
        │   └── schema.sql                ← Creates DB tables + inserts sample data
        │
        └── webapp/                       ← Everything served to the browser
            ├── index.jsp                 ← Tomcat's welcome file
            │
            ├── WEB-INF/
            │   ├── web.xml               ← Tomcat config (welcome page, errors)
            │   └── views/                ← (V) JSP pages — the actual HTML templates
            │       ├── 404.jsp
            │       ├── home.jsp
            │       ├── categories.jsp
            │       ├── botanical.jsp     ← Botanical e-commerce page
            │       ├── gesture.jsp
            │       ├── art.jsp           ← All artworks + search bar
            │       ├── art-detail.jsp
            │       ├── artist.jsp
            │       ├── gallery.jsp
            │       └── includes/
            │           ├── header.jsp    ← Top nav (shared by every page)
            │           └── footer.jsp    ← Footer (shared by every page)
            │
            └── assets/                   ← Static files
                ├── css/style.css         ← All the styling
                ├── js/main.js            ← Slideshow JavaScript
                ├── images/               ← All painting images
                │   ├── botanical/        ← Botanical category images
                │   └── gesture/          ← Gesture category images
                └── videos/               ← Hero video
```

---

## 4. The technologies — one paragraph each

### Java
The programming language. Files end in `.java`. They get compiled into `.class` files, which Tomcat runs.

### Maven
Java's package manager. Like npm for JavaScript or pip for Python. The file `pom.xml` lists all the libraries this project needs (Servlet API, JSTL, MySQL driver). When you run "Build", Maven downloads them automatically.

### Tomcat
The web server. It accepts HTTP requests from browsers and runs your Java servlets. You install Tomcat once on your machine; it runs all your Java web apps.

### MySQL
The database. Stores the actual painting data, artist names, prices, etc. We use XAMPP, which bundles MySQL with a control panel.

### Servlet
A Java class that handles a URL. When the browser requests `/botanical`, Tomcat calls `BotanicalServlet.doGet(...)`. The servlet is the "Controller" in MVC.

### JSP (JavaServer Pages)
HTML files with special tags that let you mix Java/JSTL into them. JSPs are the "View" in MVC. When the browser requests a JSP, Tomcat compiles it into a servlet behind the scenes and runs it.

### JSTL (JSP Standard Tag Library)
A set of tags like `<c:forEach>`, `<c:if>`, `<c:choose>` that let you loop, branch, and output dynamic data inside JSPs without writing raw Java. Cleaner than the old `<% %>` scriptlets.

### JDBC (Java Database Connectivity)
The standard way Java talks to databases. We use it inside the DAOs to send SQL queries to MySQL.

### MVC
A pattern, not a technology. Already explained in section 2.

---

## 5. Walking through a real request — what happens when you click "Botanical"

This is the most important section. If you understand this flow, you understand the project.

### Step 1 — User clicks the Botanical card

In `categories.jsp` line 22:
```jsp
<a class="category-card" href="${catHref}">
```

`${catHref}` is set just above to `/art-gallery/botanical` for the Botanical card specifically. So clicking it sends an HTTP GET to that URL.

### Step 2 — Tomcat finds the right servlet

Tomcat scans every Java class with the `@WebServlet(...)` annotation. It finds `BotanicalServlet.java`:
```java
@WebServlet("/botanical")
public class BotanicalServlet extends HttpServlet {
```

Match! Tomcat calls `BotanicalServlet.doGet(request, response)`.

### Step 3 — The servlet asks the database

Inside `doGet`:
```java
Category botanical = categoryDAO.findById(BOTANICAL_CATEGORY_ID);
List<Artwork> artworks = artworkDAO.findByCategory(BOTANICAL_CATEGORY_ID);
```

Two database calls. The DAOs hide the SQL from us.

### Step 4 — The DAO runs SQL

Inside `ArtworkDAO.java`:
```java
public List<Artwork> findByCategory(int categoryId) {
    return query(BASE_SQL + "WHERE a.category_id = ? ORDER BY a.id DESC", categoryId);
}
```

It builds a SQL query, the `query(...)` helper opens a connection, runs it, and converts each row to an `Artwork` object.

### Step 5 — The servlet attaches data to the request

```java
req.setAttribute("category", botanical);
req.setAttribute("artworks", artworks);
```

Think of `setAttribute` as putting a labeled box into the request that the JSP can pick up later.

### Step 6 — The servlet hands off to the JSP

```java
req.getRequestDispatcher("/WEB-INF/views/botanical.jsp").forward(req, resp);
```

This tells Tomcat: "compile and run `botanical.jsp` using this request, and send the result back to the browser."

### Step 7 — The JSP builds the HTML

Inside `botanical.jsp`:
```jsp
<c:forEach var="art" items="${artworks}">
    <article class="product-card">
        <img src="${art.imageUrl}" alt="${art.title}">
        <h3>${art.title}</h3>
        <p>Rs. <fmt:formatNumber value="${art.price}" .../></p>
        ...
    </article>
</c:forEach>
```

`<c:forEach>` is JSTL: loops over the artworks list. Each `${art.title}` reads the `title` field from the current artwork.

### Step 8 — The browser receives plain HTML

The browser sees `<img>`, `<h3>`, `<p>` — no Java, no JSP. Just normal HTML. The browser draws the page.

That's the whole cycle. Every page in this project follows this exact pattern.

---

## 6. The Java files — what each one does

### Models (`src/main/java/com/artgallery/model/`)

These are POJOs — Plain Old Java Objects. They have private fields and public getters/setters. That's it. No logic.

#### `Category.java`
Holds info about a category like Botanical:
- `id` (int) — primary key in DB
- `name` (String) — "Botanical"
- `description` (String) — short blurb
- `coverImage` (String) — URL of the cover photo

#### `Artwork.java`
Holds info about a single painting:
- `id`, `title`, `description`, `imageUrl`
- `price` (BigDecimal — Java's exact-decimal type for money)
- `categoryId`, `artistId` — foreign keys
- `categoryName`, `artistName` — joined from related tables (set by the DAO)
- `featured` (boolean) — show the "Featured" badge?

#### `Artist.java`
Holds artist info: name, bio, country, profile image.

#### `Subscriber.java`
Holds newsletter signups: first name, last name, email, created timestamp.

### DAOs (`src/main/java/com/artgallery/dao/`)

DAO = Data Access Object. The only place that talks to MySQL. Every database query lives in a DAO. Servlets never write SQL directly — they always call a DAO method.

#### `CategoryDAO.java`
Two methods: `findAll()` (returns all categories) and `findById(int)` (one by id).

#### `ArtworkDAO.java`
The most useful DAO. Methods:
- `findAll()` — every artwork
- `findFeatured()` — only ones with `featured = 1`
- `findByCategory(int)` — all artworks in a category
- `findByArtist(int)` — all artworks by an artist
- `findById(int)` — one artwork
- `search(q, categoryId, sort)` — runs a flexible search with optional filters (used by the search bar on `/art`)

The class shares a `BASE_SQL` constant — a SQL `SELECT` with `LEFT JOIN`s on category and artist so each artwork comes back with its category name and artist name pre-filled.

#### `ArtistDAO.java`
`findAll()` and `findById(int)`.

#### `SubscriberDAO.java`
`save(Subscriber)` — inserts a newsletter signup.

### Servlets (`src/main/java/com/artgallery/servlet/`)

The Controllers. Each one handles ONE URL.

#### `HomeServlet.java` — `/home`
Loads featured artworks for the slideshow and recent ones for the mini gallery, then forwards to `home.jsp`.

#### `CategoryServlet.java` — `/categories`
Lists all categories. If `?id=X` is passed, also loads the artworks in that category (used for non-Botanical/Gesture categories that don't have their own dedicated page).

#### `BotanicalServlet.java` — `/botanical`
Loads category id 5 and its artworks, forwards to `botanical.jsp`.

#### `GestureServlet.java` — `/gesture`
Same idea — category id 6 → `gesture.jsp`.

#### `ArtServlet.java` — `/art`
The most complex servlet. Handles three cases:
1. `?id=X` → show one artwork detail page
2. `?q=...&categoryId=...&sort=...` → run a search and show results
3. No params → show all artworks

#### `ArtistServlet.java` — `/artist`
Lists all artists, or shows one artist's works if `?id=X` passed.

#### `GalleryServlet.java` — `/gallery`
Shows the full mosaic gallery wall.

#### `NewsletterServlet.java` — `/newsletter` (POST)
Handles the newsletter form submission. Validates email, saves to DB.

### Utility (`src/main/java/com/artgallery/util/`)

#### `DBConnection.java`
A single class with one job: open a JDBC connection to MySQL. Reads URL/user/password from environment variables, falls back to defaults (`localhost:3306`, `root`, no password — matches XAMPP).

The `static { ... }` block at the top loads the MySQL JDBC driver class once at startup.

---

## 7. The JSPs — what each one does

JSPs are HTML files with special tags. Lines starting with `<%@ page` and `<%@ taglib` are setup. `${something}` reads a request attribute. `<c:something>` is a JSTL tag.

#### `home.jsp`
The landing page. Has the hero section with a video background, a slideshow of featured artworks (driven by `main.js`), a mosaic of recent works, and the newsletter form.

#### `categories.jsp`
Grid of all categories pulled from the DB. Each card links to its category page. Botanical and Gesture cards are special-cased to link to `/botanical` and `/gesture` instead of `/categories?id=X`.

#### `botanical.jsp`
E-commerce style listing for the Botanical category:
- Hero with trust badges (free shipping, 30-day returns)
- Product count + sort dropdown
- Grid of product cards: image, badges (Featured / Bestseller), title, artist, rating, description, price (Rs. format), Add to Cart button, Quick View link
- Toast notification when adding to cart (handled by inline `<script>`)

#### `gesture.jsp`
Same template as `botanical.jsp` but for Gesture category. Identical structure.

#### `art.jsp`
The main art listing with **search and filter**:
- Search bar (free-text across title, description, artist, category)
- Category filter dropdown
- Sort dropdown (Featured, Newest, Price low→high, Price high→low)
- Reset button (only shown when filters are active)
- Result count line
- Grid of art cards

When the form submits, it sends GET parameters (`?q=...&categoryId=...&sort=...`) which `ArtServlet` reads and forwards to `ArtworkDAO.search(...)`.

#### `art-detail.jsp`
Shows one painting. Big image, title, artist, description, price.

#### `artist.jsp`
Lists all artists or shows one artist's works.

#### `gallery.jsp`
Full gallery wall — every artwork as a tile in a mosaic.

#### `404.jsp`
Shown for missing pages. Configured in `web.xml`.

#### `index.jsp`
The welcome file. Tomcat hits this when you visit `/art-gallery/` with no path. It just redirects to `/home`.

#### `includes/header.jsp`
The top nav (Home, Categories, Art, Artist, Gallery). Included by every page via `<%@ include file="..." %>`. Highlights the active link based on the `activePage` request attribute (set by the servlet).

#### `includes/footer.jsp`
The bottom of every page. Brand, footer links, contact info. Includes `<script src="...main.js">` at the bottom.

---

## 8. The database — `schema.sql`

This file does two things:
1. Creates the database `art_gallery` and 4 tables: `categories`, `artists`, `artworks`, `subscribers`.
2. Inserts seed data — 6 categories, 14 artists, 22+ artworks.

### Tables

#### `categories`
| Column | Type | Notes |
|---|---|---|
| id | INT, PK, AUTO_INCREMENT | unique number |
| name | VARCHAR(80) | "Botanical" |
| description | VARCHAR(400) | shown on cards |
| cover_image | VARCHAR(300) | image URL |

#### `artists`
Similar — id, name, bio, profile_image, country.

#### `artworks`
| Column | Type | Notes |
|---|---|---|
| id | INT, PK | |
| title | VARCHAR(160) | painting name |
| description | TEXT | longer text |
| image_url | VARCHAR(300) | required |
| price | DECIMAL(10,2) | exact decimal money |
| category_id | INT (FK) | links to categories.id |
| artist_id | INT (FK) | links to artists.id |
| featured | TINYINT(1) | 1 = show "Featured" badge |

The `FOREIGN KEY` constraints mean: if you delete a category, the `category_id` in any related artwork is set to NULL (`ON DELETE SET NULL`).

#### `subscribers`
Newsletter signups: first_name, last_name, email (unique), created_at.

### Why `DROP TABLE IF EXISTS ... CREATE TABLE ...` at the top?

So you can run `schema.sql` over and over. Each run wipes the tables clean and re-inserts the seed. That's "re-seeding". Useful when you change seed data and want it reflected.

### To re-seed manually

```powershell
cmd /c '"C:\xampp\mysql\bin\mysql.exe" -u root --default-character-set=utf8mb4 < src\main\resources\schema.sql'
```

---

## 9. Configuration files

### `pom.xml` (Maven)
Tells Maven:
- Project name + version (`art-gallery 1.0-SNAPSHOT`)
- Package as a `.war` file (web archive — what you deploy to Tomcat)
- Java 17, source encoding UTF-8
- Dependencies:
  - `jakarta.servlet-api` — Servlet API (provided by Tomcat at runtime)
  - `jakarta.servlet.jsp-api` — JSP API
  - `jakarta.servlet.jsp.jstl-api` + impl — JSTL tags
  - `mysql-connector-j` — JDBC driver for MySQL

### `web.xml` (Tomcat)
- Sets the welcome file to `index.jsp`
- Sets session timeout to 30 minutes
- Configures the 404 error page to render `404.jsp`

Most servlet wiring is done via `@WebServlet("/path")` annotations directly on the Java classes — `web.xml` doesn't need to list them.

---

## 10. How a typical change works

### "I want to add a new category called Watercolor"

1. **Database** — open `schema.sql`, add a row to `INSERT INTO categories` block. Re-seed.
2. **Image** — drop a cover image into `webapp/assets/images/` and update the path in the new INSERT row.
3. **Refresh page** — visit `/categories`, the new card appears automatically (the JSP loops over all DB categories — no code change needed).

### "I want a dedicated page for Watercolor like Botanical"

1. **Servlet** — copy `BotanicalServlet.java` → `WatercolorServlet.java`, change `@WebServlet("/watercolor")`, change category id, change forward path.
2. **JSP** — copy `botanical.jsp` → `watercolor.jsp`, edit the title and copy text.
3. **Categories card link** — in `categories.jsp`, add another `<c:if>` mapping the Watercolor card to `/watercolor`.
4. **Restart Tomcat** — needed because we added new Java code.

### "I want to change a price"

1. Open `schema.sql`, find the row, change the price number.
2. Re-seed MySQL.
3. Hard refresh the browser (`Ctrl+F5`).

No Java change needed — the JSP reads price live from the DB.

---

## 11. How to run the project

1. **Start MySQL** — open XAMPP Control Panel → MySQL → Start.
2. **Seed the DB** (first time, or after schema changes):
   ```powershell
   cmd /c '"C:\xampp\mysql\bin\mysql.exe" -u root --default-character-set=utf8mb4 < src\main\resources\schema.sql'
   ```
3. **In IntelliJ** — start Tomcat (green play button on the Tomcat run config).
4. Wait for "Artifact is deployed successfully".
5. Open browser → **http://localhost:8081/art-gallery/home**

Default URLs:
- `/art-gallery/home` — landing page
- `/art-gallery/categories` — all categories
- `/art-gallery/botanical` — Botanical e-commerce page
- `/art-gallery/gesture` — Gesture e-commerce page
- `/art-gallery/art` — all art with search + filter
- `/art-gallery/art?id=5` — single artwork detail

---

## 12. Key Java concepts you've now seen

| Concept | Where you saw it | What it means |
|---|---|---|
| Class | Every `.java` file | Blueprint for an object |
| Field | `private int id;` | A variable inside a class |
| Constructor | `public Category(int id, ...)` | Special method to create an object |
| Getter/setter | `getName()`, `setName(...)` | Methods to read/write fields |
| `static` | `DBConnection.getConnection()` | Belongs to the class, not an instance |
| Inheritance | `extends HttpServlet` | Servlet inherits behavior from HttpServlet |
| Annotation | `@WebServlet("/...")` | Metadata Tomcat reads at startup |
| Exception | `throws SQLException` | Signals something can fail |
| try-with-resources | `try (Connection c = ...)` | Auto-closes the connection |
| Generics | `List<Artwork>` | A typed list — only Artworks allowed |
| Interface | `List`, `Connection` | Contract that classes implement |
| Lambda (in JSP `<c:forEach>`) | n/a here, but JSTL is similar | Anonymous mini-function |
| Stream / loop | `<c:forEach>` in JSP, `while (rs.next())` in DAO | Process each item |

---

## 13. Things to learn next

Once you're comfortable with this project:

1. **Add a real shopping cart** — store cart in `HttpSession`, create `CartServlet`.
2. **Add user login** — sessions, password hashing, login/register forms.
3. **Switch JDBC for an ORM** — try Hibernate or JPA instead of raw SQL.
4. **Use a connection pool** — HikariCP. Faster than opening a fresh connection per request.
5. **Add unit tests** — JUnit 5 + Mockito. Test the DAOs first.
6. **Move from JSP to Thymeleaf or React** — JSP is older; modern Java apps usually use Thymeleaf (Spring Boot) or a separate React frontend.
7. **Try Spring Boot** — the modern Java framework. Same ideas (MVC, controllers, models), but way less boilerplate.

---

## 14. Glossary — quick reference

| Term | Meaning |
|---|---|
| **HTTP request** | A message from the browser to the server, like "GET /home" |
| **HTTP response** | The reply — usually HTML |
| **Servlet** | Java class that handles a URL |
| **JSP** | HTML template with Java/JSTL tags |
| **JSTL** | Tags like `<c:forEach>` for use inside JSPs |
| **MVC** | Model-View-Controller separation |
| **POJO** | Plain Old Java Object — just fields + getters/setters |
| **DAO** | Data Access Object — talks to the database |
| **JDBC** | Java's standard database API |
| **PreparedStatement** | A SQL query with `?` placeholders — safe from SQL injection |
| **ResultSet** | Cursor over the rows returned by a query |
| **Connection** | An open link to the database |
| **WAR** | Web Archive — the `.war` file Tomcat deploys |
| **Maven** | Java's build tool / package manager |
| **`pom.xml`** | Maven config |
| **`@WebServlet`** | Annotation that maps a servlet to a URL |
| **`@Override`** | Says "this method overrides a parent method" |
| **`request.setAttribute(name, val)`** | Servlet hands data to JSP |
| **`request.getRequestDispatcher(path).forward(req, resp)`** | Servlet renders a JSP |
| **Context path** | The URL prefix Tomcat adds — for us: `/art-gallery` |

---

That's the entire project. Read this top to bottom once, then open any single file and you'll know exactly where it fits in the puzzle. Good luck!
