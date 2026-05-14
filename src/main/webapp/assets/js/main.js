/* ============================================================
   Gallery Artisan's — frontend interactions.
   Slideshow: the centered slide stays in full colour, the rest
   fade to grayscale (handled by .is-active + CSS).
   ============================================================ */

(function () {
    const root = document.querySelector('[data-slideshow]');
    if (!root) return;

    const track  = root.querySelector('.slide-track');
    const slides = Array.from(root.querySelectorAll('.slide'));
    const prev   = root.querySelector('.slide-arrow.prev');
    const next   = root.querySelector('.slide-arrow.next');
    if (!slides.length || !track) return;

    let active = Math.floor(slides.length / 2); // start in the middle
    let autoplay;
    let currentX = 0;

    function update() {
        // Reset transform first so we measure the un-shifted layout positions.
        // Using offsetLeft + offsetWidth avoids the scaled bounding box from
        // .is-active { transform: scale(1.05) } and gives consistent math.
        slides.forEach(s => s.classList.remove('is-active'));
        const current = slides[active];

        const slideCenter = current.offsetLeft + (current.offsetWidth / 2);
        const viewportCenter = root.clientWidth / 2;
        currentX = viewportCenter - slideCenter;

        track.style.transform = `translateX(${currentX}px)`;

        // Apply active class AFTER the transform update so the scale animation
        // runs in parallel with the slide.
        current.classList.add('is-active');
    }

    function goTo(i) {
        active = (i + slides.length) % slides.length;
        update();
    }
    function nextSlide() { goTo(active + 1); }
    function prevSlide() { goTo(active - 1); }

    if (prev) prev.addEventListener('click', (e) => { e.preventDefault(); prevSlide(); restartAutoplay(); });
    if (next) next.addEventListener('click', (e) => { e.preventDefault(); nextSlide(); restartAutoplay(); });

    // Click a non-active slide to bring it to center.
    slides.forEach((slide, idx) => {
        slide.addEventListener('click', () => { goTo(idx); restartAutoplay(); });
    });

    // Keyboard support
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowRight') { nextSlide(); restartAutoplay(); }
        if (e.key === 'ArrowLeft')  { prevSlide(); restartAutoplay(); }
    });

    function startAutoplay() {
        autoplay = setInterval(nextSlide, 4500);
    }
    function restartAutoplay() {
        clearInterval(autoplay);
        startAutoplay();
    }

    // Pause autoplay on hover.
    root.addEventListener('mouseenter', () => clearInterval(autoplay));
    root.addEventListener('mouseleave', () => startAutoplay());

    // Recompute on resize (slide widths change responsively).
    let resizeTimer;
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(update, 80);
    });

    // Initial layout — wait for images so widths are correct.
    function init() {
        update();
        startAutoplay();
    }

    const imgs = root.querySelectorAll('img');
    let pending = imgs.length;
    if (pending === 0) {
        requestAnimationFrame(init);
    } else {
        imgs.forEach(img => {
            if (img.complete) {
                if (--pending === 0) requestAnimationFrame(init);
            } else {
                img.addEventListener('load',  () => { if (--pending === 0) requestAnimationFrame(init); });
                img.addEventListener('error', () => { if (--pending === 0) requestAnimationFrame(init); });
            }
        });
        // Fallback in case load events never fire.
        setTimeout(() => { if (pending > 0) { pending = 0; requestAnimationFrame(init); } }, 1500);
    }
})();
