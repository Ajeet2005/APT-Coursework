/* ============================================================
   Gallery Artisan's — frontend interactions.
   Slideshow: the centered slide stays in full colour, the rest
   fade to grayscale (handled by .is-active + CSS).
   ============================================================ */

(function () {
    function initSlideshow() {
        var root = document.querySelector('[data-slideshow]');
        if (!root) return;

        var track  = root.querySelector('.slide-track');
        var slides = Array.prototype.slice.call(root.querySelectorAll('.slide'));
        var prev   = root.querySelector('.slide-arrow.prev');
        var next   = root.querySelector('.slide-arrow.next');
        if (!slides.length || !track) return;

        var active = Math.floor(slides.length / 2); // start in the middle
        var autoplay = null;
        var INTERVAL = 4500;

        function update() {
            slides.forEach(function (s) { s.classList.remove('is-active'); });
            var current = slides[active];
            if (!current) return;

            // Use offsetLeft/offsetWidth so the scale(1.05) transform on the
            // active slide doesn't inflate our math.
            var slideCenter    = current.offsetLeft + (current.offsetWidth / 2);
            var viewportCenter = root.clientWidth / 2;
            var x              = viewportCenter - slideCenter;

            track.style.transform = 'translateX(' + x + 'px)';
            current.classList.add('is-active');
        }

        function goTo(i) {
            active = (i + slides.length) % slides.length;
            update();
        }
        function nextSlide() { goTo(active + 1); }
        function prevSlide() { goTo(active - 1); }

        function startAutoplay() {
            stopAutoplay();
            autoplay = setInterval(nextSlide, INTERVAL);
        }
        function stopAutoplay() {
            if (autoplay) { clearInterval(autoplay); autoplay = null; }
        }
        function restartAutoplay() {
            stopAutoplay();
            startAutoplay();
        }

        // Arrow + slide clicks
        if (prev) prev.addEventListener('click', function (e) { e.preventDefault(); prevSlide(); restartAutoplay(); });
        if (next) next.addEventListener('click', function (e) { e.preventDefault(); nextSlide(); restartAutoplay(); });

        slides.forEach(function (slide, idx) {
            slide.addEventListener('click', function () { goTo(idx); restartAutoplay(); });
        });

        // Keyboard
        document.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowRight') { nextSlide(); restartAutoplay(); }
            if (e.key === 'ArrowLeft')  { prevSlide(); restartAutoplay(); }
        });

        // Pause on hover, resume on leave
        root.addEventListener('mouseenter', stopAutoplay);
        root.addEventListener('mouseleave', startAutoplay);

        // Pause when the tab is hidden (saves CPU + battery) and resume on return
        document.addEventListener('visibilitychange', function () {
            if (document.hidden) stopAutoplay();
            else                 startAutoplay();
        });

        // Recompute on resize
        var resizeTimer;
        window.addEventListener('resize', function () {
            clearTimeout(resizeTimer);
            resizeTimer = setTimeout(update, 80);
        });

        // ── Kick things off immediately ─────────────────────────────────────
        // Don't wait for every image — start autoplay right away so the user
        // sees movement. We'll re-run update() when each image finishes loading
        // so the centering stays accurate as widths firm up.
        update();
        startAutoplay();

        // Re-run update() whenever an image finishes loading (or fails).
        // This keeps the active slide centered even if image dimensions only
        // arrive after the initial paint.
        var imgs = root.querySelectorAll('img');
        imgs.forEach(function (img) {
            if (img.complete) return;
            img.addEventListener('load',  update, { once: true });
            img.addEventListener('error', update, { once: true });
        });

        // Also re-center once everything is fully loaded as a final safety net.
        if (document.readyState !== 'complete') {
            window.addEventListener('load', update, { once: true });
        }
    }

    // Run as soon as the DOM is ready (don't wait for images).
    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initSlideshow);
    } else {
        initSlideshow();
    }
})();
