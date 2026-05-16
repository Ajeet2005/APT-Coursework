# Gallery Artisan's — A Beginner's Walkthrough

A complete, plain-English guide to **how this art gallery website is built**, written for someone learning Java web development for the first time. Read it top to bottom and by the end you will understand every file in the project.

---

## Table of contents

1. [What is this project?](#1-what-is-this-project)
2. [The technologies — what each tool does](#2-the-technologies--what-each-tool-does)
3. [The big picture — how a web request flows](#3-the-big-picture--how-a-web-request-flow)
4. [The MVC pattern — the most important idea](#4-the-mvc-pattern--the-most-important-idea)
5. [The folder structure, explained](#5-the-folder-structure-explained)
6. [The database — what's stored and how](#6-the-database--whats-stored-and-how)
7. [Models — Java objects that mirror database tables](#7-models--java-objects-that-mirror-database-tables)
8. [DAOs — the database talkers](#8-daos--the-database-talkers)
9. [Servlets — the brain of every page](#9-servlets--the-brain-of-every-page)
10. [JSPs — the HTML factories](#10-jsps--the-html-factories)
11. [The AuthFilter — the security guard](#11-the-authfilter--the-security-guard)
12. [Authentication — how login/register actually works](#12-authentication--how-loginregister-actually-works)
13. [Admin vs regular user](#13-admin-vs-regular-user)
14. [File uploads — how images get onto the server](#14-file-uploads--how-images-get-onto-the-server)
15. [Static assets — CSS, JS, images](#15-static-assets--css-js-images)
16. [How the project boots up](#16-how-the-project-boots-up)
17. [Running it yourself](#17-running-it-yourself)
18. [Adding a new feature — a step-by-step example](#18-adding-a-new-feature--a-step-by-step-example)
19. [Glossary](#19-glossary)

---

## 1. What is this project?

**Gallery Artisan's** is a website that displays and sells paintings online. Think of it as a tiny Amazon, but for art.

A visitor can:

- Browse paintings on the home page, with a featured slideshow and a mosaic of recent works
- Click through to specific categories (Portrait, Landscape, Still Life, Botanical, Gesture)
- View an artwork's full detail page (image, title, artist, price)
- Read about the artists
- Register an account, log in, edit their profile
- Sign up as an **admin** to manage the gallery — add/edit/delete artworks, artists, categories, view users and orders

The site has two kinds of users: **regular members** (browse + buy) and **admins** (manage everything).

---

## 2. The technologies — what each tool does

This stack might feel intimidating, but each tool has a single, simple job. Here is the whole list:

| Tool | What it actually does | Plain analogy |
|---|---|---|
| **Java 17** | The programming language we write our code in | The language we speak |
| **Maven** | Downloads libraries we need, compiles the code, packages it for deployment | A grocery delivery + chef rolled into one |
| **Apache Tomcat 10.1** | The web server that runs our Java code | The kitchen that cooks the meal a customer ordered |
| **Jakarta Servlets** | Java classes that handle HTTP requests | A waiter who takes the order and brings the food |
| **JSP (Jakarta Server Pages)** | Files that mix HTML + Java to generate web pages | A template with blanks the chef fills in |
| **JSTL (Jakarta Standard Tag Library)** | Cleaner tags inside JSP for loops/conditionals (`<c:forEach>`, `<c:if>`) | Shortcuts inside the template language |
| **MySQL 8** | The database that stores users, artworks, orders | A filing cabinet |
| **JDBC** | Java's API for talking to a database | The phone line between Java and MySQL |
| **MySQL Connector/J** | The actual JDBC driver — Java's plug for the MySQL socket | The specific phone cable that fits MySQL's port |
| **BCrypt (jbcrypt 0.4)** | Hashes passwords so they're not stored in plain text | A shredder for sensitive info |
| **HTML/CSS/JavaScript** | What the browser actually sees and renders | The plate the customer eats from |

You don't have to memorize all of this. Just remember:

- **Java** does the thinking
- **Tomcat** runs the Java when someone visits a URL
- **MySQL** remembers things
- **JSP** generates the HTML the browser sees

---

## 3. The big picture — how a web request flows

When you type `http://localhost:8081/art-gallery/home` into your browser and press Enter, here is what happens, step by step:

```
   ┌──────────┐   1. GET /home               ┌──────────────┐
   │ Browser  ├─────────────────────────────►│  Tomcat       │
   └────▲─────┘                              │ (web server)  │
        │                                    └───────┬───────┘
        │                                            │ 2. routes /home
        │                                            ▼
        │                                    ┌──────────────┐
        │                                    │ HomeServlet  │  ← Controller
        │                                    │ .java        │
        │                                    └───────┬──────┘
        │                                            │ 3. fetch data
        │                                            ▼
        │                                    ┌──────────────┐
        │                                    │ ArtworkDAO   │  ← talks to DB
        │                                    └───────┬──────┘
        │                                            │ 4. SELECT ...
        │                                            ▼
        │                                    ┌──────────────┐
        │                                    │   MySQL      │
        │                                    └───────┬──────┘
        │                                            │ 5. rows back
        │                                            ▼
        │                                    ┌──────────────┐
        │                                    │ HomeServlet  │ 6. put data on request,
        │                                    │              │    forward to JSP
        │                                    └───────┬──────┘
        │                                            ▼
        │                                    ┌──────────────┐
        │                                    │ home.jsp     │ 7. generates HTML
        │                                    └───────┬──────┘
        │                                            │
        │           8. HTML response                 │
        └────────────────────────────────────────────┘
```

That's it. Every page in the app follows this same pattern. Once you understand it, you understand the whole thing.

---

## 4. The MVC pattern — the most important idea

**MVC = Model, View, Controller.** It's not a Java thing, it's not a Tomcat thing — it's just a way of organizing code so different jobs live in different files.

| Letter | Name | Job | Example in this project |
|---|---|---|---|
| **M** | **Model** | Holds data only — no logic | `Artwork.java` has fields like `title`, `price` |
| **V** | **View** | Shows data to the user — no logic | `botanical.jsp` is the HTML page |
| **C** | **Controller** | The glue — receives the click, asks for data, picks a view | `BotanicalServlet.java` |

**Why bother splitting?** So changing one piece doesn't break the others.

- Want to redesign the page? Edit only the **View** (the `.jsp`).
- Want to change how prices are stored? Edit only the **Model** (the `.java` POJO) and the **DAO**.
- Want a page to fetch new data? Edit only the **Controller** (the servlet).

There's a fourth layer that isn't part of the MVC name but is just as important:

- **DAO** (Data Access Object) — the file that actually runs SQL queries. Sits between the Controller and the database.

So really, the data path is:

```
JSP (View)  ◄──  Servlet (Controller)  ◄──  DAO  ◄──  MySQL
```

---

## 5. The folder structure, explained

```
APT-Coursework/
├── pom.xml                       ← Maven config — lists every library we use
├── README.md                     ← Quick install instructions
├── LEARN.md                      ← THIS file — the deep-dive
└── src/
    └── main/
        ├── java/com/artgallery/  ← All Java code lives here
        │   ├── model/            ← Plain-Old Java Objects (POJOs)
        │   │   ├── User.java
        │   │   ├── Artwork.java
        │   │   ├── Artist.java
        │   │   ├── Category.java
        │   │   ├── Order.java
        │   │   └── OrderItem.java
        │   ├── dao/              ← Database access — runs SQL queries
        │   │   ├── UserDAO.java
        │   │   ├── ArtworkDAO.java
        │   │   ├── ArtistDAO.java
        │   │   ├── CategoryDAO.java
        │   │   └── OrderDAO.java
        │   ├── servlet/          ← Controllers — one per URL
        │   │   ├── HomeServlet.java       → /home
        │   │   ├── CategoryServlet.java   → /categories
        │   │   ├── ArtServlet.java        → /art
        │   │   ├── ArtistServlet.java     → /artist
        │   │   ├── GalleryServlet.java    → /gallery
        │   │   ├── BotanicalServlet.java  → /botanical
        │   │   ├── PortraitServlet.java   → /portrait
        │   │   ├── LandscapeServlet.java  → /landscape
        │   │   ├── StillLifeServlet.java  → /stilllife
        │   │   ├── GestureServlet.java    → /gesture
        │   │   ├── LoginServlet.java      → /login
        │   │   ├── RegisterServlet.java   → /register
        │   │   ├── LogoutServlet.java     → /logout
        │   │   ├── ProfileServlet.java    → /profile
        │   │   └── AdminServlet.java      → /admin and /admin/*
        │   ├── filter/           ← Code that runs BEFORE every request
        │   │   └── AuthFilter.java        ← blocks non-admins from /admin
        │   └── util/             ← Helpers
        │       └── DBConnection.java      ← single source for DB connections
        ├── resources/
        │   └── schema.sql        ← Database schema + sample seed data
        └── webapp/
            ├── index.jsp         ← Redirects "/" to "/home"
            ├── WEB-INF/
            │   ├── web.xml       ← Tomcat deployment config (welcome file, 404 page)
            │   └── views/        ← All JSP files — the Views
            │       ├── includes/
            │       │   ├── header.jsp     ← site navbar (included on every page)
            │       │   └── footer.jsp
            │       ├── home.jsp
            │       ├── categories.jsp
            │       ├── art.jsp, art-detail.jsp
            │       ├── artist.jsp
            │       ├── gallery.jsp
            │       ├── botanical.jsp, portrait.jsp, landscape.jsp,
            │       ├── stilllife.jsp, gesture.jsp
            │       ├── login.jsp, register.jsp, profile.jsp
            │       ├── admin.jsp
            │       └── 404.jsp
            └── assets/           ← Static files served directly to the browser
                ├── css/style.css
                ├── js/main.js
                ├── images/...     ← Paintings, artists, hero, etc.
                └── videos/hero.mp4
```

**Key rule:** files inside `WEB-INF/` are *not* reachable directly from the browser. A visitor can never type `/views/home.jsp` and get the file — they must go through a servlet, which then forwards to the JSP. This is a security guarantee from the Servlet spec.

---

## 6. The database — what's stored and how

The database is called **`art_gallery`** and has **7 tables**. Here is what each one holds and how they connect:

```
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   users      │         │ categories   │         │   artists    │
│──────────────│         │──────────────│         │──────────────│
│ id           │         │ id           │         │ id           │
│ full_name    │         │ name         │         │ name         │
│ email (uniq) │         │ description  │         │ bio          │
│ password_hash│         │ cover_image  │         │ portrait_url │
│ role         │         └──────┬───────┘         └──────┬───────┘
│ created_at   │                │ 1                      │ 1
└──────┬───────┘                │                        │
       │ 1                      │ *                      │ *
       │                ┌───────▼────────────────────────▼───────┐
       │                │            artworks                    │
       │                │────────────────────────────────────────│
       │                │ id, title, description, image_url      │
       │                │ price, category_id (FK), artist_id (FK)│
       │                │ featured                               │
       │                └───────┬────────────────────────────────┘
       │                        │ 1
       │                        │
       │ 1                      │ *
       ▼                ┌───────▼───────┐
┌──────────┐            │  order_items  │
│  carts   │            │───────────────│
│──────────│            │ id            │
│ id       │            │ order_id (FK) │
│ user_id  │            │ artwork_id    │
│ artwork_id            │ quantity      │
│ added_at │            │ price         │
└──────────┘            └───────▲───────┘
                                │ *
                                │
                                │ 1
                        ┌───────┴───────┐
                        │     orders    │
                        │───────────────│
                        │ id            │
                        │ user_id (FK)  │
                        │ total_amount  │
                        │ status        │
                        │ created_at    │
                        └───────────────┘
```

**Relationships in words:**

- One **user** can have many **carts** entries (items in their shopping cart).
- One **user** can have many **orders** (their order history).
- One **category** (e.g. "Portrait") has many **artworks**.
- One **artist** has many **artworks**.
- One **order** has many **order_items** (the lines on the receipt).
- Each **order_item** references exactly one **artwork**.

**Seed data** is included in `schema.sql` — when you run it, you get a starter admin account and a regular user account:

| Role  | Email                  | Password |
|-------|------------------------|----------|
| admin | admin@artgallery.com   | password |
| user  | user@artgallery.com    | password |

Passwords are stored as **BCrypt hashes** — 60-character strings that can't be reversed. When you log in, the entered password is hashed and compared to the stored hash.

---

## 7. Models — Java objects that mirror database tables

A **Model** (also called a POJO — Plain Old Java Object) is a Java class with private fields and getters/setters. Nothing fancy — no logic, no database, just a bucket of data.

**Example: [`User.java`](src/main/java/com/artgallery/model/User.java)**

```java
public class User {
    private int id;
    private String fullName;
    private String email;
    private String passwordHash;   // BCrypt 60-char hash
    private String role;           // "user" or "admin"
    private LocalDateTime createdAt;

    // getters and setters for each field...

    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }
}
```

Notice the **fields match the columns** in the `users` table from `schema.sql`. That's the whole point — one row in the database becomes one `User` object in Java.

Same for `Artwork`, `Artist`, `Category`, `Order`, `OrderItem`. Each one is a mirror of its database table.

`Artwork` is slightly special — it has two extra fields, `categoryName` and `artistName`, which come from **JOINing** the related tables. So when the DAO fetches an artwork, it pulls in the artist's name in one go.

---

## 8. DAOs — the database talkers

A **DAO** (Data Access Object) is a Java class that wraps SQL. The rest of the code never writes SQL directly — it calls DAO methods.

**Example: [`CategoryDAO.java`](src/main/java/com/artgallery/dao/CategoryDAO.java)**

```java
public List<Category> findAll() {
    List<Category> list = new ArrayList<>();
    String sql = "SELECT id, name, description, cover_image " +
                 "FROM categories ORDER BY name";

    try (Connection c = DBConnection.getConnection();
         PreparedStatement ps = c.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {

        while (rs.next()) {
            list.add(map(rs));     // converts a row → Category object
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
```

Breaking this down:

1. **`DBConnection.getConnection()`** — get a fresh database connection (more on this below).
2. **`PreparedStatement`** — a safe way to send SQL. Always use this instead of building SQL strings with `+`, because it prevents SQL injection attacks.
3. **`ResultSet`** — what comes back from a `SELECT`. Loop over its rows with `rs.next()`.
4. **`map(rs)`** — a small helper that turns a row's columns into a fresh `Category` object.
5. **try-with-resources `try (...)`** — automatically closes the connection, statement, and resultset when the block ends. Critical, because if you don't close them, you leak DB connections and the server eventually grinds to a halt.

The DAOs in this project:

| DAO | What it does |
|---|---|
| `UserDAO` | `register`, `login`, `findById`, `updateProfile`, `updatePassword`, `emailExists` |
| `ArtworkDAO` | `findAll`, `findFeatured`, `findByCategory`, `findByArtist`, `findById`, `search`, `insert`, `update`, `delete` |
| `ArtistDAO` | List, find, insert, update, delete artists |
| `CategoryDAO` | List, find, insert, update, delete categories |
| `OrderDAO` | List, find, create orders + order items |

**The single source of truth for database connections** is [`DBConnection.java`](src/main/java/com/artgallery/util/DBConnection.java):

```java
public static Connection getConnection() throws SQLException {
    String url  = System.getenv().getOrDefault("DB_URL",  DEFAULT_URL);
    String user = System.getenv().getOrDefault("DB_USER", DEFAULT_USER);
    String pass = System.getenv().getOrDefault("DB_PASSWORD", DEFAULT_PASSWORD);
    return DriverManager.getConnection(url, user, pass);
}
```

It first looks for environment variables (`DB_URL`, `DB_USER`, `DB_PASSWORD`). If they're not set, it falls back to defaults (`localhost`, `root`, empty password). This means you don't have to edit Java code to change DB credentials in production.

---

## 9. Servlets — the brain of every page

A **Servlet** is a Java class that handles one URL pattern. It extends `HttpServlet` and overrides `doGet` (for GET requests) and/or `doPost` (for POST requests, like form submissions).

**Example: [`BotanicalServlet.java`](src/main/java/com/artgallery/servlet/BotanicalServlet.java)** — the controller for the `/botanical` page.

```java
@WebServlet("/botanical")
public class BotanicalServlet extends HttpServlet {

    private static final int BOTANICAL_CATEGORY_ID = 5;

    private final CategoryDAO categoryDAO = new CategoryDAO();
    private final ArtworkDAO  artworkDAO  = new ArtworkDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Category botanical    = categoryDAO.findById(BOTANICAL_CATEGORY_ID);
        List<Artwork> artworks = artworkDAO.findByCategory(BOTANICAL_CATEGORY_ID);

        req.setAttribute("category",   botanical);
        req.setAttribute("artworks",   artworks);
        req.setAttribute("activePage", "botanical");

        req.getRequestDispatcher("/WEB-INF/views/botanical.jsp")
           .forward(req, resp);
    }
}
```

Reading this top to bottom:

- **`@WebServlet("/botanical")`** — tells Tomcat "this servlet handles the URL `/botanical`". No web.xml registration needed; the annotation is enough.
- The servlet creates two DAOs as fields (one per database area).
- `doGet` runs on every GET request.
- It fetches the Category and the Artworks belonging to that category.
- **`req.setAttribute(name, value)`** — stuffs the data onto the request so the JSP can read it.
- **`req.getRequestDispatcher(...).forward(...)`** — hands the request off to a JSP. The JSP renders HTML using the attributes we just set, and Tomcat sends that HTML to the browser.

That's the entire pattern. Every servlet in this project does roughly the same thing: fetch data via DAOs, stuff it on the request, forward to a JSP.

**URL → Servlet map** (the actual routes the app exposes):

| URL                  | Servlet               | What it does |
|----------------------|-----------------------|--------------|
| `/`                  | (index.jsp)           | Redirects to `/home` |
| `/home`              | `HomeServlet`         | Featured slideshow + mosaic |
| `/categories`        | `CategoryServlet`     | Grid of all categories |
| `/categories?id=N`   | `CategoryServlet`     | Single category + its artworks |
| `/art`               | `ArtServlet`          | All artworks (search + filter) |
| `/art?id=N`          | `ArtServlet`          | Detail page for one artwork |
| `/artist`            | `ArtistServlet`       | All artists |
| `/artist?id=N`       | `ArtistServlet`       | One artist + their works |
| `/gallery`           | `GalleryServlet`      | Full-wall image mosaic |
| `/botanical`         | `BotanicalServlet`    | Category-specific page |
| `/portrait`          | `PortraitServlet`     | Category-specific page |
| `/landscape`         | `LandscapeServlet`    | Category-specific page |
| `/stilllife`         | `StillLifeServlet`    | Category-specific page |
| `/gesture`           | `GestureServlet`      | Category-specific page |
| `/login`             | `LoginServlet`        | GET: form. POST: verify + session |
| `/register`          | `RegisterServlet`     | GET: form. POST: create user + session |
| `/logout`            | `LogoutServlet`       | Invalidate session, redirect to /home |
| `/profile`           | `ProfileServlet`      | GET: view + edit. POST: save changes |
| `/admin`             | `AdminServlet`        | Admin dashboard (admins only) |
| `/admin/artworks`    | `AdminServlet`        | Manage artworks |
| `/admin/artists`     | `AdminServlet`        | Manage artists |
| `/admin/categories`  | `AdminServlet`        | Manage categories |
| `/admin/users`       | `AdminServlet`        | View users |
| `/admin/orders`      | `AdminServlet`        | View orders |

---

## 10. JSPs — the HTML factories

A **JSP** (Jakarta Server Page) is a file that looks like HTML but has Java/EL/JSTL sprinkled in. When Tomcat serves it, the Java parts get evaluated and the file becomes pure HTML.

**Example slice from [`botanical.jsp`](src/main/webapp/WEB-INF/views/botanical.jsp):**

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<h1>${category.name}</h1>
<p>${category.description}</p>

<div class="grid">
    <c:forEach var="art" items="${artworks}">
        <a href="${pageContext.request.contextPath}/art?id=${art.id}">
            <img src="${pageContext.request.contextPath}/${art.imageUrl}"
                 alt="${art.title}">
            <h3>${art.title}</h3>
            <p>${art.artistName}</p>
        </a>
    </c:forEach>
</div>
```

What's happening:

- **`${category.name}`** — Expression Language (EL). Pulls the `category` attribute the servlet set, then calls `.getName()`. EL is just a shortcut for getter calls.
- **`<c:forEach>`** — a JSTL tag that loops over a list. `var="art"` names each item, `items="${artworks}"` is the list to iterate.
- **`${pageContext.request.contextPath}`** — the app's deployment path (e.g., `/art-gallery`). Always prepend this to internal URLs so links work whether the app is deployed at `/` or `/something`.

**Shared layout via includes**: both `header.jsp` (navbar) and `footer.jsp` live in `WEB-INF/views/includes/`. Each page starts with:

```jsp
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
```

…and ends with:

```jsp
<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
```

The header reads `currentUser` from the session to decide whether to show the "Sign In" icon or the user's avatar dropdown.

---

## 11. The AuthFilter — the security guard

A **Filter** runs *before* a servlet on every matching request. Think of it as a doorman who checks who is allowed in.

**Our [`AuthFilter.java`](src/main/java/com/artgallery/filter/AuthFilter.java)** is registered for `/*` (all URLs) and enforces two rules:

1. **`/admin/*` requires admin role** — non-admins get redirected to `/home`, unauthenticated visitors to `/login`.
2. **`/profile` requires being logged in** — anyone not logged in goes to `/login`.

Everything else is public. Static assets (`/assets/*`, `/favicon`) skip filter logic entirely so images and CSS load fast.

```java
if (path.startsWith("/admin")) {
    if (!loggedIn) {
        saveRedirectTarget(session, req, requestURI);
        resp.sendRedirect(contextPath + "/login");
        return;
    }
    if (!user.isAdmin()) {
        resp.sendRedirect(contextPath + "/home");
        return;
    }
    chain.doFilter(request, response);   // allow through
    return;
}
```

The filter is annotated with `@WebFilter(urlPatterns = "/*")`, so Tomcat picks it up automatically — no XML registration needed.

---

## 12. Authentication — how login/register actually works

Logging a user in is a four-step dance:

### Step 1 — Register a new account

User submits `/register` with name, email, password. **`RegisterServlet`** validates fields, then calls **`UserDAO.registerWithRole(...)`**.

Inside `UserDAO`:

```java
String hash = BCrypt.hashpw(plainPassword, BCrypt.gensalt(12));
```

The plaintext password is hashed with **BCrypt** (cost factor 12 — takes ~250ms, deliberately slow to thwart brute-force attacks). Only the hash is stored. Even if someone steals the database, they cannot recover the original password.

A row is INSERTed into `users` with the hash and role (`user` or `admin`).

### Step 2 — Auto-login after register, or visit `/login`

`RegisterServlet` creates a fresh session and stuffs the new `User` object into it:

```java
session.setAttribute("loggedInUser", newUser);
```

For `/login`, **`LoginServlet`** does the same after verifying credentials via `UserDAO.login(email, password)`, which does:

```java
BCrypt.checkpw(plainPassword, storedHash)
```

`checkpw` re-hashes the plaintext with the salt embedded in the stored hash and compares — in constant time, so attackers can't measure timing differences to leak info.

### Step 3 — Session lives in HTTP cookies

Tomcat hands the browser a `JSESSIONID` cookie. On every subsequent request, the browser sends it back, and Tomcat looks up the matching session. Our session holds the `loggedInUser` attribute, which the header.jsp and the AuthFilter both read.

Session timeout is 30 minutes (set in `web.xml` and reaffirmed in code).

### Step 4 — Logout

`/logout` is handled by **`LogoutServlet`**, which simply calls `session.invalidate()` and redirects to `/home`. The JSESSIONID cookie is now meaningless — the user is anonymous again.

**Bonus: "Remember me"** — the login form has a checkbox. If checked, the LoginServlet sets a `rememberedEmail` cookie that lives 30 days, so the email field pre-fills next time. (Note: this remembers only the email, not the password.)

---

## 13. Admin vs regular user

The difference is one column: `users.role` is either `'user'` or `'admin'`.

In Java, `User.isAdmin()` returns `true` when the role is `"admin"`.

**Where admin status changes behavior:**

| Place | Behavior for admin |
|---|---|
| `AuthFilter` | Can access `/admin/*` (regular users are bounced to `/home`) |
| `header.jsp` navbar | Shows the purple "Admin Dashboard" pill in the nav |
| `header.jsp` avatar | Avatar has the `auth-avatar--admin` class (different colour) |
| Avatar dropdown | Shows both "Edit Profile" and "Admin Dashboard" entries |
| `LoginServlet` | After successful login, admins go to `/admin`; users go to `/home` |
| `RegisterServlet` | Has a role selector tab (user/admin) — anyone can self-register as admin in this learning project |

The admin dashboard lives in **`AdminServlet`** and handles many subroutes (`/admin/artworks`, `/admin/artists`, `/admin/categories`, `/admin/users`, `/admin/orders`) — all of them re-dispatch to the same `admin.jsp` with a `view` attribute that tells the JSP which section to render. So `admin.jsp` is one big switch-case rendering different forms/tables.

---

## 14. File uploads — how images get onto the server

Instead of pasting image URLs, admin users can upload image files directly from their computer. This section walks through how file uploads work in Jakarta Servlets.

### The problem

A normal HTML form sends data as text — field names and values. But a file is binary data (raw bytes of a JPEG, for example). Text encoding can't carry that. So HTML has a special form encoding: **`multipart/form-data`**, which packages each field as a separate "part" — text parts for regular fields, binary parts for files.

### Step 1 — Tell the servlet to accept files

Jakarta Servlets have built-in multipart support. You just add an annotation:

```java
@WebServlet({ "/admin", "/admin/*" })
@MultipartConfig(
    maxFileSize   = 5 * 1024 * 1024,   // 5 MB per file
    maxRequestSize = 10 * 1024 * 1024   // 10 MB total
)
public class AdminServlet extends HttpServlet { ... }
```

**`@MultipartConfig`** tells Tomcat: "this servlet can receive file uploads." Without it, calling `req.getPart(...)` throws an exception. The size limits protect the server from someone uploading a 2 GB file.

### Step 2 — Update the HTML form

The form needs `enctype="multipart/form-data"` and a file input:

```html
<form action="/admin/artists" method="POST" enctype="multipart/form-data">
    <input type="text" name="name" required>
    <input type="file" name="profile_image_file" accept=".jpg,.jpeg,.png,.gif,.webp">
    <button type="submit">Save</button>
</form>
```

- **`enctype="multipart/form-data"`** — switches the form from text mode to multipart mode.
- **`accept=".jpg,.jpeg,.png,.gif,.webp"`** — tells the browser's file picker to filter for image files (the server still validates too).

### Step 3 — Read the file in the servlet

In the `saveArtist` method, we extract the uploaded file using `req.getPart(...)`:

```java
private String handleImageUpload(HttpServletRequest req,
                                  String partName,
                                  String subfolder)
        throws IOException, ServletException {

    Part filePart = req.getPart(partName);
    if (filePart == null || filePart.getSize() == 0)
        return null;  // no file was selected

    // Get the original filename safely
    String originalName = Paths.get(filePart.getSubmittedFileName())
                               .getFileName().toString();

    // Validate the extension
    String ext = "";
    int dot = originalName.lastIndexOf('.');
    if (dot >= 0) ext = originalName.substring(dot).toLowerCase();
    if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)"))
        return null;  // reject non-image files

    // Generate a unique filename to avoid collisions
    String uniqueName = UUID.randomUUID().toString().substring(0, 8)
                        + "_" + originalName;

    // Build the destination path on disk
    String uploadDir = getServletContext()
                        .getRealPath("/assets/images/" + subfolder);
    File dir = new File(uploadDir);
    if (!dir.exists()) dir.mkdirs();

    // Write the file
    filePart.write(uploadDir + File.separator + uniqueName);

    // Return the relative path to store in the database
    return "assets/images/" + subfolder + "/" + uniqueName;
}
```

Breaking this down:

- **`req.getPart("profile_image_file")`** — retrieves the uploaded file part by its form field name.
- **`filePart.getSubmittedFileName()`** — the original filename the user had on their computer (e.g., `photo.jpg`).
- **`Paths.get(...).getFileName()`** — strips any directory path, as a security precaution (some browsers send the full path).
- **Extension validation** — only allows known image formats. Never trust the browser's `accept` attribute alone — always validate server-side.
- **`UUID.randomUUID()`** — generates a unique prefix so two users uploading `photo.jpg` don't overwrite each other.
- **`getServletContext().getRealPath(...)`** — translates a web-app-relative path to an absolute filesystem path where Tomcat deployed the app.
- **`filePart.write(...)`** — saves the bytes to disk. That's all it takes.

The method returns the relative path (like `assets/images/Artists/a1b2c3d4_photo.jpg`), which gets stored in the `profile_image` column of the `artists` table — the same format existing artist images use.

### Step 4 — Handle edits (keep old image if no new upload)

When editing an existing artist, the admin might change the name but not upload a new image. The code handles this:

```java
String profileImagePath = handleImageUpload(req, "profile_image_file", "Artists");
if (profileImagePath != null) {
    a.setProfileImage(profileImagePath);     // new file uploaded
} else if (a.getId() > 0) {
    Artist existing = artistDAO.findById(a.getId());
    if (existing != null)
        a.setProfileImage(existing.getProfileImage());  // keep old
}
```

### The drag-and-drop UI

The form uses a custom **drop zone** instead of the browser's plain file input. It's built with:

- A hidden `<input type="file">` — the actual form element that carries the file data.
- A styled `<div class="drop-zone">` — the visible area the user interacts with.
- JavaScript event listeners for `dragover`, `dragleave`, `drop`, and `click`.

When a file is dragged onto the zone (or selected via the "Browse Files" button), JavaScript reads it with `FileReader` and shows an instant preview thumbnail — all client-side, before the form is even submitted.

```
┌─────────────────────────────────┐
│                                 │
│      ⬆ Drag & drop image here  │
│              or                 │
│        [ Browse Files ]         │
│   JPG, PNG, GIF, WebP • Max 5MB│
│                                 │
└─────────────────────────────────┘
         ↓  user drops a file
┌─────────────────────────────────┐
│ ┌──────┐                        │
│ │ IMG  │  photo.jpg        ✕   │
│ │      │  1.2 MB               │
│ └──────┘                        │
└─────────────────────────────────┘
```

The key JavaScript trick is setting the hidden input's files:

```javascript
zone.addEventListener('drop', function(e) {
    e.preventDefault();
    var files = e.dataTransfer.files;
    if (files.length > 0 && files[0].type.startsWith('image/')) {
        input.files = files;   // links the dropped file to the form input
        showPreview(files[0]); // reads + displays a thumbnail
    }
});
```

`input.files = files` is the critical line — it makes the dropped file behave exactly as if the user had clicked "Choose File" and picked it. When the form submits, the file travels to the server as a multipart part.

---

## 15. Static assets — CSS, JS, images

Anything inside `src/main/webapp/assets/` is served directly by Tomcat with no Java involvement. URLs look like:

- `/art-gallery/assets/css/style.css` — the entire site's stylesheet
- `/art-gallery/assets/js/main.js` — the slideshow JavaScript on the home page
- `/art-gallery/assets/images/portraits/foo.jpg` — paintings
- `/art-gallery/assets/videos/hero.mp4` — the home-page hero video

**`style.css`** holds the whole design system — colour variables (`--purple`, `--bg`, `--ink`), typography (Cormorant Garamond display + Inter sans), buttons, nav, slideshow, mosaic, admin dashboard tables, etc.

**`main.js`** powers the highlight slideshow on `/home` — the central slide stays in colour, the neighbours fade to grayscale, arrow buttons cycle, autoplay pauses on hover.

---

## 16. How the project boots up

When Tomcat starts up with this WAR deployed, here is the order of events:

1. **Tomcat reads `WEB-INF/web.xml`** — finds the welcome file (`index.jsp`), session timeout (30 min), and 404 page (`WEB-INF/views/404.jsp`).
2. **Tomcat scans annotated classes** — finds every `@WebServlet` and `@WebFilter` and registers them.
3. **Tomcat warms up** — JSPs are *not* compiled until the first request that touches them. The first hit to `/home` will be slightly slow because `home.jsp` compiles into a real servlet (`home_jsp.java` behind the scenes).
4. **First request arrives** — the browser hits `/art-gallery/`. `index.jsp` redirects to `/home`. `AuthFilter.doFilter` runs (allows public traffic). `HomeServlet.doGet` runs, fetches data, forwards to `home.jsp`. JSP renders HTML. Browser receives it. Done.

No bootstrap class, no Spring container, no manual wiring. The Servlet API does everything.

---

## 17. Running it yourself

**Prerequisites:**

- JDK 17+
- Apache Maven 3.8+
- MySQL 8.x
- Apache Tomcat 10.1.x
- An IDE (IntelliJ IDEA Ultimate has built-in Tomcat support; Community + Smart Tomcat plugin works too)

**Steps:**

1. **Create the database:**
   ```bash
   mysql -u root -p < src/main/resources/schema.sql
   ```
   This creates the `art_gallery` schema, all 7 tables, and seed data including the admin and user accounts.

2. **Configure DB credentials** (optional — defaults are `root` / no password). Either edit `DBConnection.java` or export env vars before starting Tomcat:
   ```
   DB_URL=jdbc:mysql://localhost:3306/art_gallery?useSSL=false&serverTimezone=UTC
   DB_USER=root
   DB_PASSWORD=yourpassword
   ```

3. **Build the WAR:**
   ```bash
   mvn clean package
   ```
   Produces `target/art-gallery.war`. Maven also creates an "exploded" deployment under `target/art-gallery/` which IntelliJ uses for hot deployment.

4. **Run via IntelliJ:**
   - File → Open → select the project folder
   - Run → Edit Configurations → + → Tomcat Server → Local
   - Application server: point to your Tomcat 10.1
   - Deployment tab: + → Artifact → `art-gallery:war exploded`, context `/art-gallery`
   - Server tab: URL `http://localhost:8080/art-gallery/`
   - Click the green play button

5. **Or run manually:**
   - Copy `target/art-gallery.war` into Tomcat's `webapps/`
   - Start Tomcat (`bin/startup.sh` or `bin/startup.bat`)
   - Visit `http://localhost:8080/art-gallery/`

6. **Test logins:**
   - User: `user@artgallery.com` / `password`
   - Admin: `admin@artgallery.com` / `password`

---

## 18. Adding a new feature — a step-by-step example

Let's say you want to add an **"About Us"** page. Here is what you do, end to end:

### Step 1 — Decide on a URL and a JSP name

URL: `/about`. JSP: `about.jsp`.

### Step 2 — Create the servlet (Controller)

`src/main/java/com/artgallery/servlet/AboutServlet.java`:

```java
package com.artgallery.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/about")
public class AboutServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setAttribute("activePage", "about");
        req.getRequestDispatcher("/WEB-INF/views/about.jsp").forward(req, resp);
    }
}
```

(For static content you could skip the servlet and place the JSP outside `WEB-INF/`, but routing through a servlet is the consistent pattern.)

### Step 3 — Create the JSP (View)

`src/main/webapp/WEB-INF/views/about.jsp`:

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<c:set var="pageTitle" value="About — Gallery Artisan's" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="about-wrap">
    <h1>About Gallery Artisan's</h1>
    <p>We curate vivid acrylic artworks from emerging artists worldwide.</p>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
```

### Step 4 — Add a navbar link

In `src/main/webapp/WEB-INF/views/includes/header.jsp`, add:

```jsp
<a href="<%= ctx %>/about" class="<%= "about".equals(active) ? "active" : "" %>">About</a>
```

### Step 5 — Add styling (optional)

In `src/main/webapp/assets/css/style.css`, add an `.about-wrap` rule.

### Step 6 — Rebuild + reload

If running via IntelliJ, save the files and Tomcat auto-redeploys. If using a built WAR, `mvn package` again and replace the file in `webapps/`.

Visit `http://localhost:8080/art-gallery/about` — the page should appear.

**That's the same recipe for every feature**: servlet for the controller, JSP for the view, optional DAO if you need data, optional CSS for styling.

---

## 19. Glossary

| Term | Meaning |
|---|---|
| **Servlet** | A Java class handling HTTP requests; lives at a URL pattern |
| **JSP** | Jakarta Server Page — HTML file with Java/EL/JSTL mixed in |
| **DAO** | Data Access Object — wraps SQL into Java methods |
| **POJO** | Plain Old Java Object — a model class with just fields + getters/setters |
| **JDBC** | Java's API for talking to relational databases |
| **MVC** | Model-View-Controller — the pattern this app uses |
| **EL** | Expression Language — the `${...}` syntax in JSPs |
| **JSTL** | Jakarta Standard Tag Library — the `<c:forEach>`, `<c:if>` tags |
| **Filter** | Code that runs before/after servlets, for cross-cutting concerns like auth |
| **Session** | Per-user state stored on the server, keyed by a JSESSIONID cookie |
| **BCrypt** | A password-hashing algorithm — slow and salted by design |
| **WAR** | Web Application Archive — a `.zip` of compiled Java + web resources |
| **Context path** | The URL prefix where the app is deployed (e.g., `/art-gallery`) |
| **PreparedStatement** | A safe way to send parameterized SQL; prevents injection |
| **`@WebServlet`** | Annotation that registers a class as a servlet at a URL |
| **`request.setAttribute`** | Stuff data on the request so the JSP can read it |
| **`request.getParameter`** | Read a query string or form field |
| **`request.getRequestDispatcher(...).forward(...)`** | Hand control of the request to a JSP |
| **`response.sendRedirect(...)`** | Send the browser a 302 to a new URL |
| **`@MultipartConfig`** | Annotation that enables a servlet to accept file uploads |
| **`Part`** | A Jakarta Servlet object representing one piece of a multipart request (a file or a form field) |
| **`enctype="multipart/form-data"`** | HTML form attribute that switches encoding from text to multipart, required for file uploads |
| **Drag and drop** | A browser API (`dragover`, `drop` events) that lets users drop files from their desktop onto a web page |

---

## You did it

If you read this from top to bottom and understood it, you now know:

- How a Java web app is structured
- How the MVC pattern keeps code organized
- How servlets, JSPs, and DAOs cooperate
- How sessions and password hashing secure logins
- How filters guard restricted areas
- How to add your own features

The same patterns scale up to enormous real-world Java applications. Frameworks like Spring add convenience and conventions on top, but underneath every Spring Boot app, the same servlet/filter/JSP machinery is running. Master the basics here and Spring will feel like a luxury car instead of a foreign language.

Happy building.
