<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>
<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-brand">
            <span class="brand-mark">&#127963;</span>
            <span class="brand-name">Gallery Artisan&rsquo;s</span>
            <p>A curated home for acrylic &amp; colour-forward painting.</p>
        </div>
        <div class="footer-links">
            <h4>Explore</h4>
            <a href="<%= ctx %>/home">Home</a>
            <a href="<%= ctx %>/categories">Categories</a>
            <a href="<%= ctx %>/art">Art</a>
            <a href="<%= ctx %>/artist">Artist</a>
            <a href="<%= ctx %>/gallery">Gallery</a>
        </div>
        <div class="footer-contact">
            <h4>Visit</h4>
            <p>Street no. 18<br>
                <br>Lakeside-Pokhara, Nepal</p>
            <p>hello@galleryartisans.example</p>
        </div>
    </div>
    <div class="footer-bottom">
        <small>&copy; 2026 Gallery Artisan&rsquo;s. All rights reserved.</small>
    </div>
</footer>

<%-- Scroll-to-top button — shown when user scrolls past the fold --%>
<button type="button" class="scroll-top" id="scrollTop" aria-label="Back to top">
    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
        <path d="M6 14l6-6 6 6" stroke="currentColor" stroke-width="2"
              stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
</button>

<script src="<%= ctx %>/assets/js/main.js"></script>
</body>
</html>
