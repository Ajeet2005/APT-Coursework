<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Gallery Artisanâ€™s â€” Home" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<!-- ========== HERO WITH VIDEO ========== -->
<section class="hero">
    <div class="hero-video">
        <!--
            Drop your own b-roll file at webapp/assets/videos/hero.mp4
            (acrylic pouring, brush strokes, gallery b-roll, etc.).
            The <video> tag auto-plays muted on loop.
        -->
        <video autoplay muted loop playsinline poster="<%= ctx %>/assets/images/hero-poster.jpg">
            <source src="<%= ctx %>/assets/videos/hero.mp4" type="video/mp4">
        </video>
        <div class="hero-overlay"></div>
    </div>
    <div class="hero-content">
        <span class="eyebrow">Acrylic Â· Colour Â· Craft</span>
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
        <p>Only the centre piece stays in colour â€” step through to see each painting come alive.</p>
    </div>

    <div class="slideshow" data-slideshow>
        <button class="slide-arrow prev" aria-label="Previous">&larr;</button>
        <div class="slide-track">
            <c:choose>
                <c:when test="${not empty featured}">
                    <c:forEach var="art" items="${featured}" varStatus="loop">
                        <figure class="slide" data-index="${loop.index}">
                            <img src="${art.imageUrl}" alt="${art.title}">
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
                        <figure class="slide" data-index="${i - 1}">
                            <img src="<%= ctx %>/assets/images/placeholder-${i}.jpg" alt="Placeholder painting ${i}">
                            <figcaption>
                                <h3>Untitled #${i}</h3>
                                <p>Gallery Artisan&rsquo;s</p>
                            </figcaption>
                        </figure>
                    </c:forEach>
                </c:otherwise>
            </c:choose>
        </div>
        <button class="slide-arrow next" aria-label="Next">&rarr;</button>
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
                            <img src="${art.imageUrl}" alt="${art.title}">
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
                    <a class="mosaic-item m-${(i - 1) % 8}" href="<%= ctx %>/gallery">
                        <img src="<%= ctx %>/assets/images/placeholder-${((i-1) % 5) + 1}.jpg" alt="Placeholder ${i}">
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

<!-- ========== NEWSLETTER (matches the uploaded mockup) ========== -->
<section class="newsletter" id="newsletter">
    <div class="newsletter-card">
        <span class="eyebrow">Newsletter</span>
        <h2>Sign up for <span class="brand-mark">&#127963;</span> Gallery Artisan&rsquo;s Newsletter</h2>
        <p>
            Always stay informed about Gallery Artisan&rsquo;s latest dates, exhibitions and most exciting projects.
            Sign up for the newsletter and become part of a vibrant community that celebrates art, creativity and inspiration.
        </p>

        <c:if test="${not empty newsletterSuccess}">
            <div class="form-banner success">${newsletterSuccess}</div>
        </c:if>
        <c:if test="${not empty newsletterError}">
            <div class="form-banner error">${newsletterError}</div>
        </c:if>

        <form class="newsletter-form" action="<%= ctx %>/newsletter" method="post">
            <div class="field-row">
                <input type="text" name="firstName" placeholder="First Name" required>
                <input type="text" name="lastName" placeholder="Last Name">
            </div>
            <div class="field-row">
                <input type="email" name="email" placeholder="Enter your email" required>
                <button type="submit" class="btn btn-primary">Submit &rarr;</button>
            </div>
            <label class="consent">
                <input type="checkbox" name="consent" value="1" required>
                I Confirm The Privacy Policy
            </label>
        </form>
    </div>

    <div class="newsletter-strip">
        <!-- gallery wall strip image -->
        <img src="<%= ctx %>/assets/images/gallery-wall.jpg" alt="Gallery wall">
    </div>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
