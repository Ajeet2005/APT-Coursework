<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Gallery Artisan's</title>
    <meta name="description" content="Sign in to Gallery Artisan's to browse, collect, and purchase original acrylic artworks.">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:ital,wght@0,300;0,400;0,600;1,300;1,400&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --clr-bg:        #0d0b14;
            --clr-panel:     #13101e;
            --clr-border:    rgba(255,255,255,0.08);
            --clr-accent:    #b89a6f;
            --clr-accent2:   #d4b896;
            --clr-purple:    #9b59b6;
            --clr-purple2:   #c39bd3;
            --clr-text:      #e8e0d5;
            --clr-muted:     #7a7086;
            --clr-error:     #e07070;
            --clr-success:   #7abf7a;
            --clr-input-bg:  rgba(255,255,255,0.04);
            --radius:        12px;
            --transition:    0.35s cubic-bezier(.4,0,.2,1);
        }

        html, body {
            height: 100%;
            font-family: 'Inter', sans-serif;
            background: var(--clr-bg);
            color: var(--clr-text);
            overflow: hidden;
        }

        /* ── Layout ─────────────────────────────────────────────── */
        .auth-shell {
            display: flex;
            height: 100vh;
        }

        /* ── LEFT: Image Slideshow ──────────────────────────────── */
        .auth-visual {
            flex: 1;
            position: relative;
            overflow: hidden;
            display: none;
            cursor: grab;
        }
        .auth-visual:active { cursor: grabbing; }
        @media (min-width: 860px) { .auth-visual { display: block; } }

        .slide {
            position: absolute;
            inset: 0;
            opacity: 0;
            transition: opacity 1s ease, transform 1.4s ease;
            transform: scale(1.06);
            user-select: none;
        }
        .slide.active {
            opacity: 1;
            transform: scale(1);
            z-index: 1;
        }
        .slide.leaving {
            opacity: 0;
            transform: scale(0.98);
            z-index: 0;
        }
        .slide img {
            width: 100%; height: 100%;
            object-fit: cover;
            display: block;
            pointer-events: none;
        }

        /* Gradient overlay */
        .slide::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(
                135deg,
                rgba(13,11,20,0.65) 0%,
                rgba(13,11,20,0.15) 45%,
                rgba(13,11,20,0.75) 100%
            );
            z-index: 1;
        }

        /* Slide caption */
        .slide-caption {
            position: absolute;
            bottom: 56px;
            left: 52px;
            z-index: 2;
            opacity: 0;
            transform: translateY(16px);
            transition: opacity 0.7s ease 0.6s, transform 0.7s ease 0.6s;
        }
        .slide.active .slide-caption {
            opacity: 1;
            transform: translateY(0);
        }
        .slide-caption h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(1.7rem, 2.8vw, 2.6rem);
            font-weight: 300;
            font-style: italic;
            color: #fff;
            text-shadow: 0 2px 24px rgba(0,0,0,0.6);
            line-height: 1.2;
        }
        .slide-caption p {
            font-size: 0.78rem;
            color: var(--clr-accent2);
            letter-spacing: 0.14em;
            text-transform: uppercase;
            margin-top: 8px;
        }

        /* Gallery branding */
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
            text-shadow: 0 2px 12px rgba(0,0,0,0.4);
        }

        /* Progress bar at top */
        .slide-progress {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 2px;
            z-index: 4;
            display: flex;
            gap: 3px;
        }
        .progress-seg {
            flex: 1;
            height: 100%;
            background: rgba(255,255,255,0.2);
            border-radius: 2px;
            overflow: hidden;
        }
        .progress-seg-fill {
            height: 100%;
            background: var(--clr-accent);
            width: 0%;
            border-radius: 2px;
            transition: width 5s linear;
        }
        .progress-seg.active .progress-seg-fill { width: 100%; }

        /* Dot indicators */
        .slide-dots {
            position: absolute;
            bottom: 56px;
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
            border: none;
            padding: 0;
        }
        .dot.active {
            background: var(--clr-accent);
            transform: scale(1.5);
        }
        .dot:hover:not(.active) { background: rgba(255,255,255,0.6); }

        /* Drag hint */
        .drag-hint {
            position: absolute;
            bottom: 18px;
            left: 50%;
            transform: translateX(-50%);
            z-index: 3;
            font-size: 0.65rem;
            color: rgba(255,255,255,0.3);
            letter-spacing: 0.12em;
            text-transform: uppercase;
            pointer-events: none;
            display: flex;
            align-items: center;
            gap: 6px;
        }
        .drag-hint::before,
        .drag-hint::after {
            content: '';
            display: inline-block;
            width: 20px;
            height: 1px;
            background: rgba(255,255,255,0.2);
        }

        /* ── RIGHT: Auth Form ─────────────────────────────────── */
        .auth-form-wrap {
            width: 100%;
            max-width: 460px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 52px 44px;
            background: var(--clr-panel);
            overflow-y: auto;
            position: relative;
            flex-shrink: 0;
        }

        /* Mobile branding */
        .mobile-brand {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.7rem;
            font-weight: 600;
            color: var(--clr-accent);
            text-align: center;
            margin-bottom: 36px;
        }
        @media (min-width: 860px) { .mobile-brand { display: none; } }

        .form-header { text-align: center; margin-bottom: 32px; }
        .form-header h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.4rem;
            font-weight: 300;
            color: var(--clr-text);
            letter-spacing: -0.01em;
        }
        .form-header p {
            color: var(--clr-muted);
            font-size: 0.875rem;
            margin-top: 8px;
            line-height: 1.5;
        }

        /* Ornament */
        .ornament {
            width: 40px;
            height: 1px;
            background: linear-gradient(90deg, transparent, var(--clr-accent), transparent);
            margin: 0 auto 28px;
        }

        /* Role selector tabs */
        .role-tabs {
            display: flex;
            gap: 0;
            margin-bottom: 28px;
            border: 1px solid var(--clr-border);
            border-radius: 10px;
            overflow: hidden;
            width: 100%;
        }
        .role-tab {
            flex: 1;
            padding: 11px 16px;
            text-align: center;
            font-size: 0.78rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            cursor: pointer;
            color: var(--clr-muted);
            background: transparent;
            border: none;
            font-family: 'Inter', sans-serif;
            font-weight: 500;
            transition: background var(--transition), color var(--transition);
        }
        .role-tab.selected {
            background: var(--clr-accent);
            color: var(--clr-bg);
        }
        .role-tab:not(.selected):hover {
            background: rgba(255,255,255,0.04);
            color: var(--clr-text);
        }

        /* Admin tab uses purple when selected */
        #tabAdmin.selected {
            background: var(--clr-purple);
            color: #fff;
        }

        /* Form fields */
        .field { margin-bottom: 20px; width: 100%; }
        .field label {
            display: block;
            font-size: 0.72rem;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            color: var(--clr-muted);
            margin-bottom: 8px;
            font-weight: 500;
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
        .field input::placeholder { color: rgba(255,255,255,0.2); }

        /* Error banner */
        .error-banner {
            width: 100%;
            background: rgba(224,112,112,0.1);
            border: 1px solid rgba(224,112,112,0.3);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.875rem;
            color: var(--clr-error);
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            animation: shake 0.4s ease;
        }
        @keyframes shake {
            0%,100% { transform: translateX(0); }
            20%      { transform: translateX(-5px); }
            60%      { transform: translateX(5px); }
        }

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
            font-weight: 600;
            letter-spacing: 0.1em;
            text-transform: uppercase;
            cursor: pointer;
            transition: background var(--transition), transform 0.15s, box-shadow var(--transition);
            margin-top: 6px;
        }
        .btn-primary:hover {
            background: var(--clr-accent2);
            box-shadow: 0 4px 20px rgba(184,154,111,0.3);
        }
        .btn-primary:active { transform: scale(0.985); }

        /* Admin submit uses purple */
        .btn-primary.admin-mode {
            background: var(--clr-purple);
        }
        .btn-primary.admin-mode:hover {
            background: var(--clr-purple2);
            box-shadow: 0 4px 20px rgba(155,89,182,0.35);
        }

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
            font-weight: 600;
            transition: color var(--transition);
        }
        .form-footer a:hover { color: var(--clr-accent2); }

        /* Back to home */
        .back-home {
            position: absolute;
            top: 24px;
            left: 24px;
            font-size: 0.75rem;
            color: var(--clr-muted);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 6px;
            transition: color var(--transition);
        }
        .back-home:hover { color: var(--clr-accent); }
        .back-home svg { width: 14px; height: 14px; }
    </style>
</head>
<body>

<div class="auth-shell">

    <!-- ══════════════════════════════════════════════════════════
         LEFT PANEL — rotating artwork slideshow with real images
    ═══════════════════════════════════════════════════════════ -->
    <div class="auth-visual" id="slideshow">

        <!-- Progress bar segments -->
        <div class="slide-progress" id="slideProgress"></div>

        <a class="visual-brand" href="<%= ctx %>/home">Gallery Artisan's</a>

        <!-- Slide 1: Botanical -->
        <div class="slide active">
            <img src="<%= ctx %>/assets/images/botanical/Famous-Flower-Paintings-Cowslips-by-Albrecht-Durer.webp"
                 alt="Botanical artwork — Cowslips by Albrecht Dürer" draggable="false">
            <div class="slide-caption">
                <h2>Where colour breathes<br>and nature blooms</h2>
                <p>Botanical Collection · Acrylic on Canvas</p>
            </div>
        </div>

        <!-- Slide 2: Gesture / Movement -->
        <div class="slide">
            <img src="<%= ctx %>/assets/images/gesture/f20d1ab0d509292808e33f6ef68f1fad.jpg"
                 alt="Gesture painting — expressive movement" draggable="false">
            <div class="slide-caption">
                <h2>Motion frozen<br>in a single breath</h2>
                <p>Gesture Series · Expressive Movement</p>
            </div>
        </div>

        <!-- Slide 3: Landscape -->
        <div class="slide">
            <img src="<%= ctx %>/assets/images/landscape/NB_Gurung-9.jpg"
                 alt="Landscape painting" draggable="false">
            <div class="slide-caption">
                <h2>Horizons that stretch<br>beyond the canvas</h2>
                <p>Landscape Collection · Oil & Acrylic</p>
            </div>
        </div>

        <!-- Slide 4: Portrait -->
        <div class="slide">
            <img src="<%= ctx %>/assets/images/portraits/912px-1665_Girl_with_a_Pearl_Earring.jpg"
                 alt="Portrait — Girl with a Pearl Earring" draggable="false">
            <div class="slide-caption">
                <h2>Eyes that hold<br>a thousand stories</h2>
                <p>Portrait Series · Masters Collection</p>
            </div>
        </div>

        <!-- Slide 5: Still Life -->
        <div class="slide">
            <img src="<%= ctx %>/assets/images/stilllife/Pieter_Claesz_-_Vanitas_Still_Life_-_943_-_Mauritshuis.jpg"
                 alt="Vanitas Still Life" draggable="false">
            <div class="slide-caption">
                <h2>Every object holds<br>a quiet poetry</h2>
                <p>Still Life · Golden Age Masters</p>
            </div>
        </div>

        <div class="slide-dots" id="dotContainer"></div>
        <div class="drag-hint">drag to explore</div>
    </div>

    <!-- ══════════════════════════════════════════════════════════
         RIGHT PANEL — login form
    ═══════════════════════════════════════════════════════════ -->
    <div class="auth-form-wrap">

        <a class="back-home" href="<%= ctx %>/home">
            <svg viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 1L3 7l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Back to Gallery
        </a>

        <div class="mobile-brand">Gallery Artisan's</div>

        <div class="form-header">
            <h1>Welcome back</h1>
            <p>Sign in to continue your art journey</p>
        </div>

        <div class="ornament"></div>

        <!-- Role selector -->
        <div class="role-tabs" role="tablist" aria-label="Login as">
            <button type="button" class="role-tab selected" id="tabUser"
                    role="tab" aria-selected="true"
                    onclick="selectRole('user')">User</button>
            <button type="button" class="role-tab" id="tabAdmin"
                    role="tab" aria-selected="false"
                    onclick="selectRole('admin')">Admin</button>
        </div>

        <!-- Error message -->
        <c:if test="${not empty error}">
            <div class="error-banner" role="alert">
                <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                    <circle cx="8" cy="8" r="7" stroke="#e07070" stroke-width="1.5"/>
                    <path d="M8 4.5v4" stroke="#e07070" stroke-width="1.5" stroke-linecap="round"/>
                    <circle cx="8" cy="11" r="0.75" fill="#e07070"/>
                </svg>
                <span>${error}</span>
            </div>
        </c:if>

        <!-- Login form -->
        <form action="${pageContext.request.contextPath}/login" method="post"
              style="width:100%" id="loginForm" autocomplete="on" novalidate>
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

            <button type="submit" class="btn-primary" id="submitBtn">Login</button>
        </form>

        <div class="form-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Sign Up</a>
        </div>
    </div>

</div>

<script>
    // ── Role tab toggle ──────────────────────────────────────────────────────
    var currentRole = 'user';

    function selectRole(role) {
        currentRole = role;
        document.getElementById('roleInput').value = role;

        var tabUser  = document.getElementById('tabUser');
        var tabAdmin = document.getElementById('tabAdmin');
        var submitBtn = document.getElementById('submitBtn');

        if (role === 'user') {
            tabUser.classList.add('selected');
            tabUser.setAttribute('aria-selected', 'true');
            tabAdmin.classList.remove('selected');
            tabAdmin.setAttribute('aria-selected', 'false');
            submitBtn.classList.remove('admin-mode');
        } else {
            tabAdmin.classList.add('selected');
            tabAdmin.setAttribute('aria-selected', 'true');
            tabUser.classList.remove('selected');
            tabUser.setAttribute('aria-selected', 'false');
            submitBtn.classList.add('admin-mode');
        }
    }

    // Pre-select role if an error was returned (keep it consistent)
    (function() {
        var roleVal = document.getElementById('roleInput').value;
        if (roleVal === 'admin') selectRole('admin');
    })();

    // ── Slideshow ────────────────────────────────────────────────────────────
    var slides    = document.querySelectorAll('.slide');
    var dotWrap   = document.getElementById('dotContainer');
    var progWrap  = document.getElementById('slideProgress');
    var current   = 0;
    var timer     = null;
    var dragStart = null;
    var INTERVAL  = 5000;

    // Build dots and progress segments
    slides.forEach(function(_, i) {
        // Dot
        var d = document.createElement('button');
        d.className = 'dot' + (i === 0 ? ' active' : '');
        d.setAttribute('aria-label', 'Go to slide ' + (i + 1));
        d.addEventListener('click', function() { goTo(i); });
        dotWrap.appendChild(d);

        // Progress segment
        var seg = document.createElement('div');
        seg.className = 'progress-seg' + (i === 0 ? ' active' : '');
        var fill = document.createElement('div');
        fill.className = 'progress-seg-fill';
        seg.appendChild(fill);
        progWrap.appendChild(seg);
    });

    function goTo(index) {
        slides[current].classList.remove('active');
        slides[current].classList.add('leaving');
        dotWrap.children[current].classList.remove('active');
        progWrap.children[current].classList.remove('active');

        // Reset leaving class after transition
        (function(prev) {
            setTimeout(function() {
                slides[prev].classList.remove('leaving');
            }, 1400);
        })(current);

        current = (index + slides.length) % slides.length;
        slides[current].classList.add('active');
        dotWrap.children[current].classList.add('active');
        progWrap.children[current].classList.add('active');
        resetTimer();
    }

    function next() { goTo(current + 1); }

    function resetTimer() {
        clearInterval(timer);
        // Reset all progress fills
        var fills = progWrap.querySelectorAll('.progress-seg-fill');
        fills.forEach(function(f) { f.style.transition = 'none'; f.style.width = '0%'; });
        // Activate current
        var currentFill = progWrap.children[current].querySelector('.progress-seg-fill');
        setTimeout(function() {
            currentFill.style.transition = 'width ' + INTERVAL + 'ms linear';
            currentFill.style.width = '100%';
        }, 50);
        timer = setInterval(next, INTERVAL);
    }

    resetTimer();

    // ── Drag / swipe support ─────────────────────────────────────────────────
    var visual = document.getElementById('slideshow');

    visual.addEventListener('mousedown',  function(e) { dragStart = e.clientX; });
    visual.addEventListener('touchstart', function(e) { dragStart = e.touches[0].clientX; }, { passive: true });

    visual.addEventListener('mouseup', function(e) {
        if (dragStart === null) return;
        var diff = dragStart - e.clientX;
        if (Math.abs(diff) > 40) goTo(diff > 0 ? current + 1 : current - 1);
        dragStart = null;
    });
    visual.addEventListener('touchend', function(e) {
        if (dragStart === null) return;
        var diff = dragStart - e.changedTouches[0].clientX;
        if (Math.abs(diff) > 40) goTo(diff > 0 ? current + 1 : current - 1);
        dragStart = null;
    });

    // Keyboard navigation
    visual.addEventListener('keydown', function(e) {
        if (e.key === 'ArrowRight') goTo(current + 1);
        if (e.key === 'ArrowLeft')  goTo(current - 1);
    });
</script>

</body>
</html>
