<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="jakarta.servlet.http.Cookie" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%
    String ctx = request.getContextPath();

    String rememberedEmail = "";
    String rememberMeChecked = "";

    Cookie[] cookies = request.getCookies();

    if (cookies != null) {
        for (Cookie c : cookies) {

            if ("rememberedEmail".equals(c.getName())) {
                rememberedEmail = c.getValue();
            }

            if ("rememberMe".equals(c.getName())
                    && "true".equals(c.getValue())) {
                rememberMeChecked = "checked";
            }
        }
    }

    String emailValue =
            (request.getAttribute("emailValue") != null)
                    ? request.getAttribute("emailValue").toString()
                    : rememberedEmail;
%>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In — Gallery Artisan's</title>

    <meta name="description"
          content="Sign in to Gallery Artisan's to browse, collect, and purchase original acrylic artworks.">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>

    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:           #0b0910;
            --bg-alt:       #120d1c;
            --surface:      #1a1326;
            --surface-2:    #241a36;
            --purple:       #7a3bff;
            --purple-deep:  #4b1d9f;
            --purple-soft:  #c9b6ff;
            --ink:          #f4f1fb;
            --muted:        #a89ebe;
            --line:         rgba(255, 255, 255, 0.08);
            --error:        #e07070;
            --input-bg:     rgba(255, 255, 255, 0.04);

            --font-display: "Cormorant Garamond", "Times New Roman", serif;
            --font-sans:    "Inter", system-ui, -apple-system, sans-serif;
            --transition:   0.35s cubic-bezier(.4,0,.2,1);
        }

        html, body {
            font-family: var(--font-sans);
            background: var(--bg);
            color: var(--ink);
            min-height: 100vh;
            -webkit-font-smoothing: antialiased;
        }

        /* ── Layout ─────────────────────────────────────────────── */
        .auth-shell {
            display: flex;
            min-height: 100vh;
        }

        /* ── LEFT image panel ───────────────────────────────────── */
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
        .slide img { width: 100%; height: 100%; object-fit: cover; display: block; pointer-events: none; }

        .slide::after {
            content: '';
            position: absolute;
            inset: 0;
            background: linear-gradient(135deg, rgba(11,9,16,.7) 0%, rgba(53,21,95,.25) 45%, rgba(11,9,16,.85) 100%);
            z-index: 1;
        }

        .slide-caption {
            position: absolute;
            bottom: 56px; left: 52px;
            z-index: 2;
            opacity: 0; transform: translateY(16px);
            transition: opacity 0.7s ease 0.6s, transform 0.7s ease 0.6s;
        }
        .slide.active .slide-caption { opacity: 1; transform: translateY(0); }

        .slide-caption h2 {
            font-family: var(--font-display);
            font-size: clamp(1.8rem, 2.8vw, 2.6rem);
            font-weight: 500; color: #fff;
            text-shadow: 0 2px 24px rgba(0,0,0,0.6); line-height: 1.15;
            letter-spacing: -0.01em;
        }
        .slide-caption h2 em {
            font-style: italic;
            color: var(--purple-soft);
            font-weight: 400;
        }
        .slide-caption p {
            font-size: 0.72rem; color: var(--purple-soft);
            letter-spacing: 0.25em; text-transform: uppercase; margin-top: 10px;
            font-family: var(--font-sans);
        }

        .visual-brand {
            position: absolute; top: 36px; left: 48px; z-index: 3;
            font-family: var(--font-display);
            font-size: 1.5rem; font-weight: 600; color: #fff;
            text-decoration: none; letter-spacing: 0.01em;
            text-shadow: 0 2px 12px rgba(0,0,0,0.4);
            display: flex; align-items: center; gap: 8px;
        }
        .visual-brand .brand-mark { font-size: 1.3rem; }

        /* Progress bar */
        .slide-progress {
            position: absolute; top: 0; left: 0; right: 0; height: 2px;
            z-index: 4; display: flex; gap: 3px;
        }
        .progress-seg { flex: 1; height: 100%; background: rgba(255,255,255,0.18); border-radius: 2px; overflow: hidden; }
        .progress-seg-fill { height: 100%; background: var(--purple-soft); width: 0%; border-radius: 2px; transition: width 5s linear; }
        .progress-seg.active .progress-seg-fill { width: 100%; }

        /* Dots */
        .slide-dots {
            position: absolute; bottom: 56px; right: 48px; z-index: 3;
            display: flex; flex-direction: column; gap: 8px;
        }
        .dot {
            width: 6px; height: 6px; border-radius: 50%;
            background: rgba(255,255,255,0.3); cursor: pointer;
            transition: background var(--transition), transform var(--transition);
            border: none; padding: 0;
        }
        .dot.active { background: var(--purple-soft); transform: scale(1.5); }
        .dot:hover:not(.active) { background: rgba(255,255,255,0.6); }

        /* ── RIGHT form panel ───────────────────────────────────── */
        .auth-form-wrap {
            width: 100%;
            max-width: 460px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 48px 44px;
            background: var(--bg-alt);
            overflow-y: auto;
            position: relative;
            flex-shrink: 0;
            animation: fadeInUp 0.7s cubic-bezier(.4,0,.2,1);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .mobile-brand {
            font-family: var(--font-display);
            font-size: 1.8rem; font-weight: 600;
            color: var(--ink); text-align: center; margin-bottom: 36px;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }
        @media (min-width: 860px) { .mobile-brand { display: none; } }

        .form-header { text-align: center; margin-bottom: 28px; }
        .form-header h1 {
            font-family: var(--font-display);
            font-size: 2.6rem; font-weight: 500; color: var(--ink);
            line-height: 1.05;
            letter-spacing: -0.01em;
        }
        .form-header h1 em {
            font-style: italic;
            color: var(--purple-soft);
            font-weight: 400;
        }
        .form-header p {
            color: var(--muted); font-size: 0.9rem; margin-top: 12px;
            font-family: var(--font-sans);
        }

        .ornament {
            width: 40px; height: 1px;
            background: linear-gradient(90deg, transparent, var(--purple-soft), transparent);
            margin: 0 auto 28px;
        }

        .field { margin-bottom: 18px; width: 100%; position: relative; }
        .field label {
            display: block; font-size: 0.7rem; letter-spacing: 0.18em;
            text-transform: uppercase; color: var(--muted); margin-bottom: 8px;
            font-weight: 500;
            font-family: var(--font-sans);
        }
        .field input {
            width: 100%; background: var(--input-bg);
            border: 1px solid var(--line); border-radius: 8px;
            padding: 13px 16px; font-size: 0.95rem; color: var(--ink);
            font-family: var(--font-sans); outline: none;
            transition: border-color var(--transition), box-shadow var(--transition), background var(--transition);
        }
        .field input:focus {
            border-color: var(--purple);
            box-shadow: 0 0 0 3px rgba(122, 59, 255, 0.18);
            background: rgba(255,255,255,0.06);
        }
        .field input::placeholder { color: rgba(255,255,255,0.2); }

        .field-with-icon input { padding-right: 44px; }
        .pw-toggle {
            position: absolute;
            right: 12px;
            top: 34px;
            background: transparent;
            border: none;
            color: var(--muted);
            cursor: pointer;
            padding: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: color var(--transition);
        }
        .pw-toggle:hover { color: var(--purple-soft); }
        .pw-toggle svg { width: 18px; height: 18px; }

        .row-between {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
            width: 100%;
        }

        .remember-me {
            display: flex; align-items: center; gap: 8px;
            color: var(--muted); font-size: 0.82rem;
            cursor: pointer;
            user-select: none;
            font-family: var(--font-sans);
        }
        .remember-me input {
            appearance: none;
            -webkit-appearance: none;
            width: 16px; height: 16px;
            border: 1px solid var(--line);
            border-radius: 4px;
            background: var(--input-bg);
            cursor: pointer;
            position: relative;
            transition: background var(--transition), border-color var(--transition);
        }
        .remember-me input:checked {
            background: var(--purple);
            border-color: var(--purple);
        }
        .remember-me input:checked::after {
            content: '';
            position: absolute;
            left: 4px; top: 1px;
            width: 5px; height: 9px;
            border: solid #fff;
            border-width: 0 2px 2px 0;
            transform: rotate(45deg);
        }

        .forgot-link {
            font-size: 0.8rem;
            color: var(--purple-soft);
            text-decoration: none;
            transition: color var(--transition);
            font-family: var(--font-sans);
        }
        .forgot-link:hover { color: #fff; }

        .error-banner {
            width: 100%;
            background: rgba(224,112,112,0.1);
            border: 1px solid rgba(224,112,112,0.3);
            border-radius: 8px; padding: 12px 16px;
            font-size: 0.875rem; color: var(--error);
            margin-bottom: 18px; display: flex; align-items: center; gap: 10px;
            animation: shake 0.4s ease;
            font-family: var(--font-sans);
        }
        @keyframes shake {
            0%,100% { transform: translateX(0); }
            20%      { transform: translateX(-5px); }
            60%      { transform: translateX(5px); }
        }

        .btn-primary {
            width: 100%; padding: 14px;
            background: var(--ink); color: #120819;
            border: none; border-radius: 999px;
            font-family: var(--font-sans); font-size: 0.85rem;
            font-weight: 600; letter-spacing: 0.12em; text-transform: uppercase;
            cursor: pointer;
            transition: background var(--transition), transform 0.15s, box-shadow var(--transition), color var(--transition);
        }
        .btn-primary:hover {
            background: var(--purple);
            color: #fff;
            box-shadow: 0 8px 28px rgba(122, 59, 255, 0.4);
            transform: translateY(-1px);
        }
        .btn-primary:active { transform: translateY(0) scale(0.985); }

        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 24px 0 20px;
            width: 100%;
            color: var(--muted);
            font-size: 0.7rem;
            letter-spacing: 0.25em;
            text-transform: uppercase;
            font-family: var(--font-sans);
        }
        .divider::before, .divider::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--line);
        }

        .form-footer {
            margin-top: 4px; text-align: center;
            font-size: 0.88rem; color: var(--muted);
            font-family: var(--font-sans);
        }
        .form-footer a {
            color: var(--purple-soft); text-decoration: none;
            font-weight: 600; transition: color var(--transition);
        }
        .form-footer a:hover { color: #fff; }

        /* Back link */
        .back-home {
            position: absolute; top: 24px; left: 24px;
            font-size: 0.75rem; color: var(--muted);
            text-decoration: none; display: flex; align-items: center; gap: 6px;
            transition: color var(--transition);
            font-family: var(--font-sans);
        }
        .back-home:hover { color: var(--purple-soft); }
        .back-home svg { width: 14px; height: 14px; }

        /* Security badge */
        .security-note {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.72rem;
            color: rgba(255,255,255,0.3);
            margin-top: 22px;
            font-family: var(--font-sans);
        }
        .security-note svg { flex-shrink: 0; opacity: 0.5; }
    </style>
</head>

<body>

<div class="auth-shell">

    <!-- LEFT PANEL — slideshow -->
    <div class="auth-visual" id="slideshow">
        <div class="slide-progress" id="slideProgress"></div>
        <a class="visual-brand" href="<%= ctx %>/home">
            <span class="brand-mark">&#127963;</span>
            <span>Gallery Artisan's</span>
        </a>

        <div class="slide active">
            <img src="<%= ctx %>/assets/images/landscape/NB_Gurung-9.jpg"
                 alt="Landscape artwork" draggable="false">
            <div class="slide-caption">
                <h2>Horizons that stretch<br><em>beyond the canvas</em></h2>
                <p>Landscape Collection</p>
            </div>
        </div>

        <div class="slide">
            <img src="<%= ctx %>/assets/images/portraits/Mona-Lisa-oil-painting-on-poplar-wood-by-Leonardo-da-Vinci.webp"
                 alt="Portrait artwork" draggable="false">
            <div class="slide-caption">
                <h2>Faces that remember<br><em>centuries of light</em></h2>
                <p>Portrait Masters</p>
            </div>
        </div>

        <div class="slide">
            <img src="<%= ctx %>/assets/images/botanical/Still-Life-of-Flowers-on-Woodland-Ground-by-Rachel-Ruysch-Famous-Flower-Painting.webp"
                 alt="Botanical artwork" draggable="false">
            <div class="slide-caption">
                <h2>Quiet blooms,<br><em>endless stories</em></h2>
                <p>Botanical Collection</p>
            </div>
        </div>

        <div class="slide-dots" id="dotContainer"></div>
    </div>

    <!-- RIGHT PANEL — login form -->
    <div class="auth-form-wrap">

        <a class="back-home" href="<%= ctx %>/home">
            <svg viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 1L3 7l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Back to Gallery
        </a>

        <div class="mobile-brand">
            <span>&#127963;</span>
            <span>Gallery Artisan's</span>
        </div>

        <div class="form-header">
            <h1>Welcome <em>back</em></h1>
            <p>Sign in to continue your collection</p>
        </div>

        <div class="ornament"></div>

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

        <form action="${pageContext.request.contextPath}/login"
              method="post"
              id="loginForm"
              autocomplete="on"
              style="width:100%">

            <div class="field">
                <label for="email">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       value="<%= emailValue %>"
                       placeholder="you@example.com"
                       required
                       autocomplete="email">
            </div>

            <div class="field field-with-icon">
                <label for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       placeholder="••••••••"
                       required
                       autocomplete="current-password">
                <button type="button" class="pw-toggle" id="pwToggle" aria-label="Show password">
                    <svg id="eyeIcon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                </button>
            </div>

            <div class="row-between">
                <label class="remember-me">
                    <input type="checkbox"
                           name="rememberMe"
                           <%= rememberMeChecked %>>
                    <span>Remember me</span>
                </label>
                <a href="#" class="forgot-link">Forgot password?</a>
            </div>

            <button type="submit" class="btn-primary">Sign In</button>
        </form>

        <div class="divider">or</div>

        <div class="form-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Create one</a>
        </div>

        <div class="security-note">
            <svg width="14" height="14" viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                <path d="M7 1L2 3.5v4C2 10.2 4.2 12.8 7 13c2.8-.2 5-2.8 5-5.5v-4L7 1z" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
                <path d="M5 7l1.5 1.5L9 5.5" stroke="currentColor" stroke-width="1.2" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Secured with BCrypt encryption
        </div>
    </div>

</div>

<script>
    // ── Slideshow ────────────────────────────────────────────────────────────
    (function() {
        var slides   = document.querySelectorAll('.slide');
        var dotWrap  = document.getElementById('dotContainer');
        var progWrap = document.getElementById('slideProgress');
        if (!slides.length) return;
        var current = 0, timer = null, dragStart = null;
        var INTERVAL = 5000;

        slides.forEach(function(_, i) {
            var d = document.createElement('button');
            d.className = 'dot' + (i === 0 ? ' active' : '');
            d.setAttribute('aria-label', 'Slide ' + (i + 1));
            d.addEventListener('click', function() { goTo(i); });
            dotWrap.appendChild(d);

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

            (function(prev) {
                setTimeout(function() { slides[prev].classList.remove('leaving'); }, 1400);
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
            var fills = progWrap.querySelectorAll('.progress-seg-fill');
            fills.forEach(function(f) { f.style.transition = 'none'; f.style.width = '0%'; });
            var fill = progWrap.children[current].querySelector('.progress-seg-fill');
            setTimeout(function() {
                fill.style.transition = 'width ' + INTERVAL + 'ms linear';
                fill.style.width = '100%';
            }, 50);
            timer = setInterval(next, INTERVAL);
        }

        resetTimer();

        var vis = document.getElementById('slideshow');
        vis.addEventListener('mousedown',  function(e) { dragStart = e.clientX; });
        vis.addEventListener('touchstart', function(e) { dragStart = e.touches[0].clientX; }, { passive: true });
        vis.addEventListener('mouseup',    function(e) {
            if (dragStart === null) return;
            var d = dragStart - e.clientX;
            if (Math.abs(d) > 40) goTo(d > 0 ? current + 1 : current - 1);
            dragStart = null;
        });
        vis.addEventListener('touchend', function(e) {
            if (dragStart === null) return;
            var d = dragStart - e.changedTouches[0].clientX;
            if (Math.abs(d) > 40) goTo(d > 0 ? current + 1 : current - 1);
            dragStart = null;
        });
    })();

    // ── Password visibility toggle ──────────────────────────────────────────
    (function() {
        var btn = document.getElementById('pwToggle');
        var input = document.getElementById('password');
        var icon = document.getElementById('eyeIcon');
        if (!btn || !input) return;

        var eyeOpen = '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>';
        var eyeOff  = '<path d="M3 3l18 18M10.6 10.6a3 3 0 0 0 4.2 4.2M9.4 5.2A10 10 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-2.9 3.6M6.1 6.1A17 17 0 0 0 2 12s3.5 7 10 7c1.7 0 3.2-.4 4.5-1" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>';

        btn.addEventListener('click', function() {
            var isPw = input.type === 'password';
            input.type = isPw ? 'text' : 'password';
            icon.innerHTML = isPw ? eyeOff : eyeOpen;
            btn.setAttribute('aria-label', isPw ? 'Hide password' : 'Show password');
        });
    })();
</script>

</body>
</html>
