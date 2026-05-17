<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="About Us &mdash; Gallery Artisan's" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<%-- About page scoped styles. Kept inline so style.css is untouched. --%>
<style>
    .about-wrap { max-width: 1180px; margin: 0 auto; padding: 0 1.5rem; }

    .about-story {
        display: grid;
        grid-template-columns: 1.1fr 1fr;
        gap: 3.5rem;
        align-items: center;
        padding: 4rem 0 3rem;
    }
    .about-story .about-copy h2 {
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: clamp(2rem, 3.6vw, 2.8rem);
        line-height: 1.15;
        margin: .5rem 0 1.2rem;
    }
    .about-story .about-copy p {
        color: var(--muted, #b6b0c4);
        line-height: 1.75;
        margin: 0 0 1rem;
    }
    .about-story .about-image {
        position: relative;
        aspect-ratio: 4 / 5;
        border-radius: 14px;
        overflow: hidden;
        box-shadow: 0 30px 60px -30px rgba(0,0,0,.6);
    }
    .about-story .about-image img {
        width: 100%; height: 100%;
        object-fit: cover;
        display: block;
    }

    .about-values {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        gap: 1.5rem;
        padding: 1rem 0 4rem;
    }
    .about-card {
        padding: 2rem 1.6rem;
        border-radius: 14px;
        background: rgba(255,255,255,.03);
        border: 1px solid rgba(255,255,255,.06);
        transition: transform .25s ease, border-color .25s ease, background .25s ease;
    }
    .about-card:hover {
        transform: translateY(-4px);
        border-color: rgba(122, 59, 255, .35);
        background: rgba(255,255,255,.05);
    }
    .about-card .about-card-icon {
        width: 44px; height: 44px;
        border-radius: 12px;
        display: flex; align-items: center; justify-content: center;
        background: linear-gradient(135deg, rgba(122,59,255,.25), rgba(122,59,255,.08));
        color: #c8b7ff;
        margin-bottom: 1rem;
    }
    .about-card h3 {
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: 1.45rem;
        margin: 0 0 .6rem;
    }
    .about-card p {
        color: var(--muted, #b6b0c4);
        line-height: 1.6;
        font-size: .95rem;
        margin: 0;
    }

    .about-stats {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 1rem;
        padding: 1.5rem 0 4rem;
        text-align: center;
    }
    .about-stat strong {
        display: block;
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: clamp(2rem, 3vw, 2.6rem);
        color: #c8b7ff;
    }
    .about-stat span {
        display: block;
        font-size: .78rem;
        letter-spacing: .18em;
        text-transform: uppercase;
        color: var(--muted, #b6b0c4);
        margin-top: .3rem;
    }

    .about-team {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
        gap: 1.5rem;
        padding: 1rem 0 4rem;
    }
    .about-member {
        text-align: center;
        padding: 1.5rem;
        border-radius: 14px;
        background: rgba(255,255,255,.025);
        border: 1px solid rgba(255,255,255,.05);
    }
    .about-member .avatar {
        width: 96px; height: 96px;
        border-radius: 50%;
        margin: 0 auto 1rem;
        display: flex; align-items: center; justify-content: center;
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: 2rem;
        color: #fff;
        background: linear-gradient(135deg, #7a3bff, #b48cff);
    }
    .about-member h4 {
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: 1.25rem;
        margin: 0 0 .25rem;
    }
    .about-member .role {
        display: block;
        font-size: .75rem;
        letter-spacing: .18em;
        text-transform: uppercase;
        color: var(--purple-soft, #b48cff);
        margin-bottom: .8rem;
    }
    .about-member p {
        color: var(--muted, #b6b0c4);
        font-size: .9rem;
        line-height: 1.55;
        margin: 0;
    }

    .about-visit {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 3rem;
        align-items: center;
        padding: 3rem 0 5rem;
    }
    .about-visit .visit-card {
        padding: 2.2rem;
        border-radius: 16px;
        background: rgba(122, 59, 255, .08);
        border: 1px solid rgba(122, 59, 255, .25);
    }
    .about-visit h2 {
        font-family: var(--font-display, "Cormorant Garamond", serif);
        font-size: clamp(1.8rem, 3vw, 2.4rem);
        margin: .5rem 0 1rem;
    }
    .about-visit p {
        color: var(--muted, #b6b0c4);
        line-height: 1.7;
        margin: 0 0 1rem;
    }
    .about-visit .visit-line {
        display: flex;
        align-items: flex-start;
        gap: .8rem;
        padding: .6rem 0;
        border-top: 1px solid rgba(255,255,255,.06);
    }
    .about-visit .visit-line:first-of-type { border-top: none; }
    .about-visit .visit-line .icon {
        color: #c8b7ff;
        flex-shrink: 0;
        margin-top: .15rem;
    }
    .about-visit .visit-line strong {
        display: block;
        font-size: .8rem;
        letter-spacing: .15em;
        text-transform: uppercase;
        color: var(--muted, #b6b0c4);
        margin-bottom: .15rem;
    }
    .about-visit .visit-line span { color: #f4f1fb; line-height: 1.5; }

    @media (max-width: 860px) {
        .about-story  { grid-template-columns: 1fr; gap: 2rem; padding: 2.5rem 0; }
        .about-stats  { grid-template-columns: repeat(2, 1fr); }
        .about-visit  { grid-template-columns: 1fr; gap: 2rem; }
    }
</style>

<%-- ========== HERO ========== --%>
<section class="page-hero">
    <span class="eyebrow">Who We Are</span>
    <h1>About Us</h1>
    <p>A small, devoted gallery in the hills of Pokhara &mdash; where colour, craft and quiet storytelling meet the wall.</p>
</section>

<%-- ========== OUR STORY ========== --%>
<section class="about-wrap">
    <div class="about-story">
        <div class="about-copy">
            <span class="eyebrow">Our Story</span>
            <h2>Born from a love of brush, light and patience.</h2>
            <p>
                Gallery Artisan&rsquo;s opened its doors in 2021 with a simple idea:
                that a painting deserves space to breathe, and a story deserves the time
                to be told. We started in a single room above a tea house in Lakeside,
                with eight canvases and a quiet hope.
            </p>
            <p>
                Today we represent painters from across Nepal, India, Italy, the
                Netherlands and beyond &mdash; from Renaissance masters reproduced with
                reverence to contemporary watercolourists capturing yaks crossing
                Himalayan snow. Every piece on our walls is here because somebody on
                our team fell in love with it first.
            </p>
            <p>
                We are not a department store. We are a gallery. We pick slowly,
                price honestly, and stand behind every canvas we sell.
            </p>
        </div>
        <div class="about-image">
            <img src="<%= ctx %>/assets/images/landscape/Van-Gogh.-Starry-Night-469x376_480x480.jpg"
                 alt="A painting from our walls">
        </div>
    </div>
</section>

<%-- ========== VALUES ========== --%>
<section class="about-wrap">
    <div class="section-head">
        <span class="eyebrow">What We Stand For</span>
        <h2>Four quiet promises</h2>
        <p>The things we will not compromise on, no matter how the gallery grows.</p>
    </div>

    <div class="about-values">
        <div class="about-card">
            <div class="about-card-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M12 2l2.4 6.9L21 10l-5.3 4.3L17.5 22 12 18.3 6.5 22l1.8-7.7L3 10l6.6-1.1z"/>
                </svg>
            </div>
            <h3>Curated, not catalogued</h3>
            <p>
                Every painting goes through three sets of eyes before it earns a place
                on our wall. We&rsquo;d rather show fewer pieces, beautifully chosen.
            </p>
        </div>

        <div class="about-card">
            <div class="about-card-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M3 12a9 9 0 1 0 18 0 9 9 0 0 0-18 0z"/>
                    <path d="M3 12h18M12 3a14 14 0 0 1 0 18M12 3a14 14 0 0 0 0 18"/>
                </svg>
            </div>
            <h3>Artists, not algorithms</h3>
            <p>
                We pay fair commissions, talk to painters by name, and never use
                stock-recommendation models to decide what hangs where.
            </p>
        </div>

        <div class="about-card">
            <div class="about-card-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M20 12V8a2 2 0 0 0-2-2h-3l-3-3-3 3H6a2 2 0 0 0-2 2v4M4 12v8a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2v-8"/>
                    <path d="M9 16l2 2 4-4"/>
                </svg>
            </div>
            <h3>Certificate with every canvas</h3>
            <p>
                Every original arrives with a signed certificate of authenticity and
                a short note from the artist explaining what they were chasing.
            </p>
        </div>

        <div class="about-card">
            <div class="about-card-icon">
                <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor"
                     stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">
                    <path d="M3 7h18M5 7v12a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V7M9 7V5a3 3 0 0 1 6 0v2"/>
                </svg>
            </div>
            <h3>30-day quiet returns</h3>
            <p>
                Live with the painting first. If it doesn&rsquo;t belong on your wall,
                send it back within thirty days &mdash; no questions, no restocking fees.
            </p>
        </div>
    </div>
</section>

<%-- ========== STATS ========== --%>
<section class="about-wrap">
    <div class="about-stats">
        <div class="about-stat"><strong>5</strong><span>Years Curating</span></div>
        <div class="about-stat"><strong>19</strong><span>Artists Represented</span></div>
        <div class="about-stat"><strong>200+</strong><span>Pieces Placed in Homes</span></div>
        <div class="about-stat"><strong>7</strong><span>Countries Shipped To</span></div>
    </div>
</section>

<%-- ========== TEAM MEMBERS ========== --%>
<section class="about-wrap">
    <div class="section-head">
        <span class="eyebrow">The People</span>
        <h2>Team Members</h2>
        <p>The five behind the project.</p>
    </div>

    <div class="about-team">
        <div class="about-member">
            <div class="avatar">M</div>
            <h4>Milan Thapa</h4>
            <span class="role">Informatics College Pokhara</span>
            <p>2nd Year BIT</p>
        </div>
        <div class="about-member">
            <div class="avatar">K</div>
            <h4>Kobit Gurung</h4>
            <span class="role">Informatics College Pokhara</span>
            <p>2nd Year BIT</p>
        </div>
        <div class="about-member">
            <div class="avatar">N</div>
            <h4>Nirajan Karki</h4>
            <span class="role">Informatics College Pokhara</span>
            <p>2nd Year BIT</p>
        </div>
        <div class="about-member">
            <div class="avatar">R</div>
            <h4>Rishab</h4>
            <span class="role">Informatics College Pokhara</span>
            <p>2nd Year BIT</p>
        </div>
        <div class="about-member">
            <div class="avatar">A</div>
            <h4>Ajeet Thapa Magar</h4>
            <span class="role">Informatics College Pokhara</span>
            <p>2nd Year BIT</p>
        </div>
    </div>
</section>

<%-- ========== VISIT ========== --%>
<section class="about-wrap">
    <div class="about-visit">
        <div>
            <span class="eyebrow">Visit</span>
            <h2>Come stand in front of one in person.</h2>
            <p>
                Photographs flatten paintings. We&rsquo;ve never met a canvas that didn&rsquo;t
                look better in person &mdash; the texture, the brush direction, the way light
                slides differently across each pigment.
            </p>
            <p>
                Walk in any afternoon. There&rsquo;s usually tea, sometimes biscuits,
                and always someone happy to walk you through the work.
            </p>
            <a href="<%= ctx %>/gallery" class="btn btn-primary">Browse the Gallery</a>
        </div>

        <div class="visit-card">
            <div class="visit-line">
                <svg class="icon" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M12 22s8-7.5 8-13a8 8 0 1 0-16 0c0 5.5 8 13 8 13z"/>
                    <circle cx="12" cy="9" r="2.5"/>
                </svg>
                <div>
                    <strong>Address</strong>
                    <span>Street no. 18, Lakeside<br>Pokhara &middot; Nepal</span>
                </div>
            </div>
            <div class="visit-line">
                <svg class="icon" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                    <circle cx="12" cy="12" r="9"/>
                    <path d="M12 7v5l3 2"/>
                </svg>
                <div>
                    <strong>Hours</strong>
                    <span>Tue &ndash; Sun: 10 AM &ndash; 6 PM<br>Monday: Closed</span>
                </div>
            </div>
            <div class="visit-line">
                <svg class="icon" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                    <rect x="3" y="5" width="18" height="14" rx="2"/>
                    <path d="M3 7l9 6 9-6"/>
                </svg>
                <div>
                    <strong>Email</strong>
                    <span>hello@galleryartisans.example</span>
                </div>
            </div>
            <div class="visit-line">
                <svg class="icon" width="22" height="22" viewBox="0 0 24 24" fill="none"
                     stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M22 16.92V21a1 1 0 0 1-1.1 1 19 19 0 0 1-8.3-3 19 19 0 0 1-6-6A19 19 0 0 1 3.6 4.1 1 1 0 0 1 4.6 3h4.1a1 1 0 0 1 1 .75c.16.96.43 1.9.8 2.78a1 1 0 0 1-.22 1.05L8.6 9.27a16 16 0 0 0 6 6l1.7-1.7a1 1 0 0 1 1.05-.22c.88.37 1.82.64 2.78.8a1 1 0 0 1 .87 1.02z"/>
                </svg>
                <div>
                    <strong>Phone</strong>
                    <span>+977 61 555 0118</span>
                </div>
            </div>
        </div>
    </div>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
