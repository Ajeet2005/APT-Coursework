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
    if (!slides.length) return;

    let active = Math.floor(slides.length / 2); // start in the middle
    let autoplay;

    function update() {
        slides.forEach(s => s.classList.remove('is-active'));
        const current = slides[active];
        current.classList.add('is-active');

        // Slide the track so the active slide sits in the centre of the viewport.
        const containerRect = root.getBoundingClientRect();
        const slideRect = current.getBoundingClientRect();
        const currentCenter = (slideRect.left - containerRect.left) + (slideRect.width / 2);
        const viewportCenter = containerRect.width / 2;
        const delta = currentCenter - viewportCenter;

        // Read existing transform, add delta.
        const style = window.getComputedStyle(track);
        const matrix = new DOMMatrixReadOnly(style.transform);
        const currentX = matrix.m41 || 0;
        track.style.transform = `translateX(${currentX - delta}px)`;
    }

    function goTo(i) {
        active = (i + slides.length) % slides.length;
        update();
    }
    function nextSlide() { goTo(active + 1); }
    function prevSlide() { goTo(active - 1); }

    prev && prev.addEventListener('click', () => { prevSlide(); restartAutoplay(); });
    next && next.addEventListener('click', () => { nextSlide(); restartAutoplay(); });

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
        autoplay = setInterval(nextSlide, 4000);
    }
    function restartAutoplay() {
        clearInterval(autoplay);
        startAutoplay();
    }

    // Recompute on resize (slide widths change responsively).
    let resizeTimer;
    window.addEventListener('resize', () => {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(update, 80);
    });

    // Initial layout — wait a frame so images can lay out.
    requestAnimationFrame(() => {
        update();
        startAutoplay();
    });
})();
