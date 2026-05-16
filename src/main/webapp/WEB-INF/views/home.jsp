<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Gallery Artisan's — Home" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<!-- ========== HERO WITH VIDEO ========== -->
<section class="hero">
    <div class="hero-video">
        <!--
            Drop your own b-roll file at webapp/assets/videos/hero.mp4
            (acrylic pouring, brush strokes, gallery b-roll, etc.).
            The <video> tag auto-plays muted on loop.
        -->
        <video autoplay muted loop playsinline poster="<%= ctx %>/assets/images/botanical/Flowers-in-a-Vase-by-Jan-Van-Huysum-Famous-Flower-Painting-1.webp">
            <source src="<%= ctx %>/assets/videos/hero.mp4" type="video/mp4">
        </video>
        <div class="hero-overlay"></div>
    </div>
    <div class="hero-content">
        <span class="eyebrow">Acrylic · Colour · Craft</span>
        <h1>Where every brushstroke <em>becomes a story.</em></h1>
        <p class="lede">
            Gallery Artisan&rsquo;s is a curated home for vivid acrylic paintings
            and colour-forward contemporary art from around the world.
        </p>
        <div class="hero-cta">
            <a href="<%= ctx %>/gallery" class="btn btn-primary">Explore the Gallery</a>
            <a href="<%= ctx %>/artist" class="btn btn-ghost">Meet the Artists</a>
        </div>
    </div>
</section>

<!-- ========== HIGHLIGHT SLIDESHOW ========== -->
<!-- The centered slide stays in full colour; the neighbours fade to grayscale. -->
<section class="highlight-section">
    <div class="section-head">
        <span class="eyebrow">Featured This Month</span>
        <h2>Highlighted Works</h2>
        <p>Only the centre piece stays in colour — step through to see each painting come alive.</p>
    </div>

    <div class="slideshow" data-slideshow>
        <button type="button" class="slide-arrow prev" aria-label="Previous slide">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path d="M15 6l-6 6 6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </button>
        <div class="slide-track">
            <c:choose>
                <c:when test="${not empty featured}">
                    <c:forEach var="art" items="${featured}" varStatus="loop">
                        <figure class="slide" data-index="${loop.index}">
                            <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                            <figcaption>
                                <h3>${art.title}</h3>
                                <p>${art.artistName}</p>
                            </figcaption>
                        </figure>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- Placeholder slides so the slideshow still demos before DB is connected -->
                    <c:forEach var="i" begin="1" end="5">
                        <c:choose>
                            <c:when test="${i == 1}"><c:set var="ph" value="Portrait/239cf4bb986b78c100681a1599acefa4.jpg"/></c:when>
                            <c:when test="${i == 2}"><c:set var="ph" value="Portrait/25a09476d9b32d44ff78055c67d28fcd.jpg"/></c:when>
                            <c:when test="${i == 3}"><c:set var="ph" value="Portrait/12a612e740abd1dc969138f5c597b87b.jpg"/></c:when>
                            <c:when test="${i == 4}"><c:set var="ph" value="Portrait/12ea0489b373da12a4208b90bdfd7c28.jpg"/></c:when>
                            <c:otherwise><c:set var="ph" value="Portrait/085f7607b37fc18506186c62ea86b18d.jpg"/></c:otherwise>
                        </c:choose>
                        <figure class="slide" data-index="${i - 1}">
                            <img src="<%= ctx %>/assets/images/${ph}" alt="Placeholder painting ${i}">
                            <figcaption>
                                <h3>Untitled #${i}</h3>
                                <p>Gallery Artisan&rsquo;s</p>
                            </figcaption>
                        </figure>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <button type="button" class="slide-arrow next" aria-label="Next slide">
            <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path d="M9 6l6 6-6 6" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
        </button>
    </div>
</section>

<!-- ========== SMALL GALLERY (yak-biergarten style mosaic) ========== -->
<section class="mini-gallery">
    <div class="section-head">
        <span class="eyebrow">Little Gallery</span>
        <h2>A glimpse of the walls</h2>
    </div>

    <div class="mosaic">
        <c:choose>
            <c:when test="${not empty latest}">
                <c:forEach var="art" items="${latest}" varStatus="loop">
                    <c:if test="${loop.index < 8}">
                        <a class="mosaic-item m-${loop.index % 8}" href="<%= ctx %>/art?id=${art.id}">
                            <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                            <span class="mosaic-caption">
                                <strong>${art.title}</strong>
                                <em>${art.artistName}</em>
                            </span>
                        </a>
                    </c:if>
                </c:forEach>
            </c:when>
            <c:otherwise>
                <c:forEach var="i" begin="1" end="8">
                    <c:set var="phIdx" value="${((i-1) % 5) + 1}"/>
                    <c:choose>
                        <c:when test="${phIdx == 1}"><c:set var="ph" value="Portrait/239cf4bb986b78c100681a1599acefa4.jpg"/></c:when>
                        <c:when test="${phIdx == 2}"><c:set var="ph" value="Portrait/25a09476d9b32d44ff78055c67d28fcd.jpg"/></c:when>
                        <c:when test="${phIdx == 3}"><c:set var="ph" value="Portrait/12a612e740abd1dc969138f5c597b87b.jpg"/></c:when>
                        <c:when test="${phIdx == 4}"><c:set var="ph" value="Portrait/12ea0489b373da12a4208b90bdfd7c28.jpg"/></c:when>
                        <c:otherwise><c:set var="ph" value="Portrait/085f7607b37fc18506186c62ea86b18d.jpg"/></c:otherwise>
                    </c:choose>
                    <a class="mosaic-item m-${(i - 1) % 8}" href="<%= ctx %>/gallery">
                        <img src="<%= ctx %>/assets/images/${ph}" alt="Placeholder ${i}">
                        <span class="mosaic-caption">
                            <strong>Untitled ${i}</strong>
                            <em>Gallery Artisan&rsquo;s</em>
                        </span>
                    </a>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</section>

<!-- ========== NEWSLETTER CTA ========== -->
<section class="newsletter-cta">
    <div class="section-head">
        <span class="eyebrow">Stay Inspired</span>
        <h2>Join the Gallery Circle</h2>
        <p>Get early access to new arrivals, artist features, and exclusive invites to gallery openings.</p>
    </div>
    <form class="newsletter-form-inline" onsubmit="return handleNewsletter(event)">
        <input type="email" placeholder="your@email.com" required aria-label="Email address">
        <button type="submit" class="btn btn-primary">Subscribe</button>
    </form>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
