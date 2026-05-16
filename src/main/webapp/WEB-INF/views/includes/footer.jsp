<%@ page contentType="text/html;charset=UTF-8" language="java" %>
</main>
<footer class="site-footer">
    <div class="footer-inner">
        <div class="footer-brand">
            <span class="brand-mark">&#127963;</span>
            <span class="brand-name">Gallery Artisan&rsquo;s</span>
            <p>A curated home for acrylic &amp; colour-forward painting.</p>
            <div class="footer-social">
                <a href="#" aria-label="Instagram">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="5"/><circle cx="17.5" cy="6.5" r="1.2" fill="currentColor" stroke="none"/>
                    </svg>
                </a>
                <a href="#" aria-label="Facebook">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M18 2h-3a5 5 0 0 0-5 5v3H7v4h3v8h4v-8h3l1-4h-4V7a1 1 0 0 1 1-1h3z"/>
                    </svg>
                </a>
                <a href="#" aria-label="Twitter">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <path d="M4 4l11.7 16h4.3L8.3 4H4zm0 16L20 4"/>
                    </svg>
                </a>
                <a href="#" aria-label="Pinterest">
                    <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8" stroke-linecap="round" stroke-linejoin="round">
                        <circle cx="12" cy="12" r="10"/><path d="M8 11.8c0-3 2.5-4.8 5-4.8 2.2 0 4 1.6 4 3.8 0 2.8-1.8 5.2-4 5.2-1 0-1.8-.7-1.5-1.8l1-4c.2-.9-.3-1.6-1.2-1.6-1.3 0-2.3 1.4-2.3 3 0 1 .3 1.7.3 1.7l-1.5 6"/>
                    </svg>
                </a>
            </div>
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
            <p>Street no. 18<br>Lakeside-Pokhara, Nepal</p>
            <p>hello@galleryartisans.example</p>
            <h4 style="margin-top: 1.5rem;">Hours</h4>
            <p>Tue &ndash; Sun: 10 AM &ndash; 6 PM<br>Monday: Closed</p>
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
