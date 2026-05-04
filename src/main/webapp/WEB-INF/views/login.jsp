<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — Gallery Artisan's</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Inter:wght@300;400;500&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --clr-bg:       #0d0b14;
            --clr-panel:    #13101e;
            --clr-border:   rgba(255,255,255,0.08);
            --clr-accent:   #b89a6f;
            --clr-accent2:  #d4b896;
            --clr-text:     #e8e0d5;
            --clr-muted:    #7a7086;
            --clr-error:    #e07070;
            --clr-input-bg: rgba(255,255,255,0.04);
            --radius:       12px;
            --transition:   0.35s cubic-bezier(.4,0,.2,1);
        }

        html, body {
            height: 100%;
            font-family: 'Inter', sans-serif;
            background: var(--clr-bg);
            color: var(--clr-text);
            overflow: hidden;
        }

        /* ── Layout ──────────────────────────────────────────── */
        .auth-shell {
            display: flex;
            height: 100vh;
        }

        /* ── LEFT: Image Slideshow ───────────────────────────── */
        .auth-visual {
            flex: 1;
            position: relative;
            overflow: hidden;
            display: none;
        }
        @media (min-width: 900px) { .auth-visual { display: block; } }

        .slide {
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity 0.9s ease, transform 1.2s ease;
            transform: scale(1.04);
        }
        .slide.active {
            opacity: 1;
            transform: scale(1);
            z-index: 1;
        }
        .slide img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
        }

        /* Dark overlay + gradient */
        .slide::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                135deg,
                rgba(13,11,20,0.55) 0%,
                rgba(13,11,20,0.2)  50%,
                rgba(13,11,20,0.7)  100%
            );
        }

        /* Slide caption */
        .slide-caption {
            position: absolute;
            bottom: 48px;
            left: 48px;
            z-index: 2;
            opacity: 0;
            transform: translateY(12px);
            transition: opacity 0.6s ease 0.5s, transform 0.6s ease 0.5s;
        }
        .slide.active .slide-caption {
            opacity: 1;
            transform: translateY(0);
        }
        .slide-caption h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(1.6rem, 2.5vw, 2.4rem);
            font-weight: 300;
            font-style: italic;
            color: #fff;
            text-shadow: 0 2px 20px rgba(0,0,0,0.5);
            line-height: 1.2;
        }
        .slide-caption p {
            font-size: 0.8rem;
            color: var(--clr-accent2);
            letter-spacing: 0.12em;
            text-transform: uppercase;
            margin-top: 6px;
        }

        /* Gallery branding top-left */
        .visual-brand {
            position: absolute;
            top: 36px;
            left: 48px;
            z-index: 3;
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.5rem;
            font-weight: 600;
            color: #fff;
            text-decoration: none;
            letter-spacing: 0.04em;
        }

        /* Dot indicators */
        .slide-dots {
            position: absolute;
            bottom: 48px;
            right: 48px;
            z-index: 3;
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        .dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: rgba(255,255,255,0.3);
            cursor: pointer;
            transition: background var(--transition), transform var(--transition);
        }
        .dot.active {
            background: var(--clr-accent);
            transform: scale(1.4);
        }

        /* Drag hint */
        .drag-hint {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 3;
            font-size: 0.68rem;
            color: rgba(255,255,255,0.35);
            letter-spacing: 0.1em;
            text-transform: uppercase;
            pointer-events: none;
        }

        /* ── RIGHT: Auth Form ────────────────────────────────── */
        .auth-form-wrap {
            width: 100%;
            max-width: 480px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 48px 40px;
            background: var(--clr-panel);
            overflow-y: auto;
            position: relative;
        }

        /* Mobile branding (hidden on desktop) */
        .mobile-brand {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--clr-accent);
            text-align: center;
            margin-bottom: 32px;
        }
        @media (min-width: 900px) { .mobile-brand { display: none; } }

        .form-header { text-align: center; margin-bottom: 36px; }
        .form-header h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.2rem;
            font-weight: 300;
            color: var(--clr-text);
        }
        .form-header p {
            color: var(--clr-muted);
            font-size: 0.875rem;
            margin-top: 8px;
        }

        /* Divider */
        .role-tabs {
            display: flex;
            gap: 0;
            margin-bottom: 28px;
            border: 1px solid var(--clr-border);
            border-radius: 8px;
            overflow: hidden;
            width: 100%;
        }
        .role-tab {
            flex: 1;
            padding: 10px;
            text-align: center;
            font-size: 0.8rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            cursor: pointer;
            color: var(--clr-muted);
            background: transparent;
            border: none;
            transition: background var(--transition), color var(--transition);
        }
        .role-tab.selected {
            background: var(--clr-accent);
            color: var(--clr-bg);
            font-weight: 500;
        }

        /* Form fields */
        .field { margin-bottom: 20px; }
        .field label {
            display: block;
            font-size: 0.75rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--clr-muted);
            margin-bottom: 8px;
        }
        .field input {
            width: 100%;
            background: var(--clr-input-bg);
            border: 1px solid var(--clr-border);
            border-radius: 8px;
            padding: 13px 16px;
            font-size: 0.95rem;
            color: var(--clr-text);
            font-family: 'Inter', sans-serif;
            outline: none;
            transition: border-color var(--transition), box-shadow var(--transition);
        }
        .field input:focus {
            border-color: var(--clr-accent);
            box-shadow: 0 0 0 3px rgba(184,154,111,0.15);
        }

        /* Error banner */
        .error-banner {
            width: 100%;
            background: rgba(224,112,112,0.12);
            border: 1px solid rgba(224,112,112,0.35);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.875rem;
            color: var(--clr-error);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }
        .error-banner svg { flex-shrink: 0; }

        /* Submit button */
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: var(--clr-accent);
            color: var(--clr-bg);
            border: none;
            border-radius: 8px;
            font-family: 'Inter', sans-serif;
            font-size: 0.875rem;
            font-weight: 500;
            letter-spacing: 0.08em;
            text-transform: uppercase;
            cursor: pointer;
            transition: background var(--transition), transform 0.15s;
            margin-top: 4px;
        }
        .btn-primary:hover { background: var(--clr-accent2); }
        .btn-primary:active { transform: scale(0.99); }

        /* Footer link */
        .form-footer {
            margin-top: 28px;
            text-align: center;
            font-size: 0.85rem;
            color: var(--clr-muted);
        }
        .form-footer a {
            color: var(--clr-accent);
            text-decoration: none;
            font-weight: 500;
            transition: color var(--transition);
        }
        .form-footer a:hover { color: var(--clr-accent2); }

        /* Hidden role field */
        #roleInput { display: none; }

        /* Subtle decorative line */
        .ornament {
            width: 40px;
            height: 1px;
            background: var(--clr-accent);
            margin: 0 auto 20px;
            opacity: 0.5;
        }
    </style>
</head>
<body>

<div class="auth-shell">

    <!-- ═══════════════════════════════════════════════════
         LEFT PANEL — rotating artwork slideshow
    ════════════════════════════════════════════════════ -->
    <div class="auth-visual" id="slideshow">

        <a class="visual-brand" href="${pageContext.request.contextPath}/home">Gallery Artisan's</a>

        <!-- Slides: using existing images from the project's images folder -->
        <div class="slide active" data-title="Botanical Collection" data-subtitle="Acrylic on Canvas">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-1.jpg"
                 alt="Artwork 1" draggable="false">
            <div class="slide-caption">
                <h2>Where colour breathes</h2>
                <p>Botanical Collection</p>
            </div>
        </div>

        <div class="slide" data-title="Gesture Series" data-subtitle="Expressive Movement">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-2.jpg"
                 alt="Artwork 2" draggable="false">
            <div class="slide-caption">
                <h2>Motion frozen in time</h2>
                <p>Gesture Series</p>
            </div>
        </div>

        <div class="slide" data-title="Gallery Wall" data-subtitle="Curated Exhibition">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-3.jpg"
                 alt="Artwork 3" draggable="false">
            <div class="slide-caption">
                <h2>Art lives in every corner</h2>
                <p>Curated Exhibition</p>
            </div>
        </div>

        <div class="slide-dots" id="dotContainer"></div>
        <div class="drag-hint">drag to browse</div>
    </div>

    <!-- ═══════════════════════════════════════════════════
         RIGHT PANEL — login form
    ════════════════════════════════════════════════════ -->
    <div class="auth-form-wrap">

        <div class="mobile-brand">Gallery Artisan's</div>

        <div class="form-header">
            <h1>Welcome back</h1>
            <p>Sign in to your account to continue</p>
        </div>

        <div class="ornament"></div>

        <!-- Role selector -->
        <div class="role-tabs">
            <button type="button" class="role-tab selected" id="tabUser"
                    onclick="selectRole('user')">User</button>
            <button type="button" class="role-tab" id="tabAdmin"
                    onclick="selectRole('admin')">Admin</button>
        </div>

        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="error-banner">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none">
                    <circle cx="8" cy="8" r="7" stroke="#e07070" stroke-width="1.5"/>
                    <path d="M8 4.5v4" stroke="#e07070" stroke-width="1.5" stroke-linecap="round"/>
                    <circle cx="8" cy="11" r="0.75" fill="#e07070"/>
                </svg>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Login form -->
        <form action="${pageContext.request.contextPath}/login" method="post" style="width:100%">
            <input type="hidden" name="role" id="roleInput" value="user">

            <div class="field">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       value="${emailValue}"
                       placeholder="you@example.com"
                       required autocomplete="email">
            </div>

            <div class="field">
                <label for="password">Password</label>
                <input type="password" id="password" name="password"
                       placeholder="••••••••"
                       required autocomplete="current-password">
            </div>

            <button type="submit" class="btn-primary">Sign In</button>
        </form>

        <div class="form-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Create one</a>
        </div>
    </div>

</div>

<script>
    // ── Role tab toggle ──────────────────────────────────────────────────────
    function selectRole(role) {
        document.getElementById('roleInput').value = role;
        document.getElementById('tabUser').classList.toggle('selected', role === 'user');
        document.getElementById('tabAdmin').classList.toggle('selected', role === 'admin');
    }

    // ── Slideshow ────────────────────────────────────────────────────────────
    const slides     = document.querySelectorAll('.slide');
    const dotWrap    = document.getElementById('dotContainer');
    let   current    = 0;
    let   timer      = null;
    let   dragStartX = null;

    // Build dots
    slides.forEach((_, i) => {
        const d = document.createElement('div');
        d.className = 'dot' + (i === 0 ? ' active' : '');
        d.addEventListener('click', () => goTo(i));
        dotWrap.appendChild(d);
    });

    function goTo(index) {
        slides[current].classList.remove('active');
        dotWrap.children[current].classList.remove('active');
        current = (index + slides.length) % slides.length;
        slides[current].classList.add('active');
        dotWrap.children[current].classList.add('active');
        resetTimer();
    }

    function next() { goTo(current + 1); }

    function resetTimer() {
        clearInterval(timer);
        timer = setInterval(next, 5000);
    }

    resetTimer();

    // Drag / swipe support
    const visual = document.getElementById('slideshow');

    visual.addEventListener('mousedown',  e => { dragStartX = e.clientX; });
    visual.addEventListener('touchstart', e => { dragStartX = e.touches[0].clientX; }, { passive: true });

    visual.addEventListener('mouseup', e => {
        if (dragStartX === null) return;
        const diff = dragStartX - e.clientX;
        if (Math.abs(diff) > 40) goTo(diff > 0 ? current + 1 : current - 1);
        dragStartX = null;
    });
    visual.addEventListener('touchend', e => {
        if (dragStartX === null) return;
        const diff = dragStartX - e.changedTouches[0].clientX;
        if (Math.abs(diff) > 40) goTo(diff > 0 ? current + 1 : current - 1);
        dragStartX = null;
    });
</script>

</body>
</html>
