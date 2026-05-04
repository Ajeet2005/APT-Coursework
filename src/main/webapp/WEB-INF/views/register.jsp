<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — Gallery Artisan's</title>
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
        }

        .auth-shell {
            display: flex;
            min-height: 100vh;
        }

        /* LEFT image panel */
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
        .slide.active { opacity: 1; transform: scale(1); z-index: 1; }
        .slide img { width:100%; height:100%; object-fit:cover; display:block; }
        .slide::after {
            content: '';
            position: absolute; inset: 0;
            background: linear-gradient(135deg,rgba(13,11,20,.55) 0%,rgba(13,11,20,.2) 50%,rgba(13,11,20,.7) 100%);
        }

        .slide-caption {
            position: absolute;
            bottom: 48px; left: 48px;
            z-index: 2;
            opacity: 0; transform: translateY(12px);
            transition: opacity 0.6s ease 0.5s, transform 0.6s ease 0.5s;
        }
        .slide.active .slide-caption { opacity: 1; transform: translateY(0); }
        .slide-caption h2 {
            font-family: 'Cormorant Garamond', serif;
            font-size: clamp(1.6rem, 2.5vw, 2.4rem);
            font-weight: 300; font-style: italic; color: #fff;
            text-shadow: 0 2px 20px rgba(0,0,0,0.5); line-height: 1.2;
        }
        .slide-caption p {
            font-size: 0.8rem; color: var(--clr-accent2);
            letter-spacing: 0.12em; text-transform: uppercase; margin-top: 6px;
        }

        .visual-brand {
            position: absolute; top:36px; left:48px; z-index:3;
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.5rem; font-weight: 600; color:#fff;
            text-decoration: none; letter-spacing: 0.04em;
        }

        .slide-dots {
            position: absolute; bottom:48px; right:48px; z-index:3;
            display: flex; flex-direction: column; gap: 8px;
        }
        .dot {
            width:6px; height:6px; border-radius:50%;
            background:rgba(255,255,255,0.3); cursor:pointer;
            transition: background var(--transition), transform var(--transition);
        }
        .dot.active { background:var(--clr-accent); transform:scale(1.4); }

        /* RIGHT form panel */
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
        }

        .mobile-brand {
            font-family: 'Cormorant Garamond', serif;
            font-size: 1.6rem; font-weight: 600;
            color: var(--clr-accent); text-align: center; margin-bottom: 32px;
        }
        @media (min-width:900px) { .mobile-brand { display:none; } }

        .form-header { text-align:center; margin-bottom:28px; }
        .form-header h1 {
            font-family: 'Cormorant Garamond', serif;
            font-size: 2.2rem; font-weight: 300; color: var(--clr-text);
        }
        .form-header p { color:var(--clr-muted); font-size:0.875rem; margin-top:8px; }

        .ornament { width:40px; height:1px; background:var(--clr-accent); margin:0 auto 24px; opacity:0.5; }

        .field { margin-bottom: 18px; width:100%; }
        .field label {
            display:block; font-size:0.75rem; letter-spacing:0.1em;
            text-transform:uppercase; color:var(--clr-muted); margin-bottom:8px;
        }
        .field input {
            width:100%; background:var(--clr-input-bg);
            border:1px solid var(--clr-border); border-radius:8px;
            padding:13px 16px; font-size:0.95rem; color:var(--clr-text);
            font-family:'Inter',sans-serif; outline:none;
            transition:border-color var(--transition), box-shadow var(--transition);
        }
        .field input:focus {
            border-color:var(--clr-accent);
            box-shadow:0 0 0 3px rgba(184,154,111,0.15);
        }
        .field input.invalid { border-color:var(--clr-error); }

        .field-hint {
            font-size: 0.72rem; color:var(--clr-muted); margin-top:5px;
        }

        .password-strength {
            margin-top: 6px;
            display: flex; gap: 4px;
        }
        .strength-bar {
            height: 3px; flex:1; border-radius:4px;
            background: rgba(255,255,255,0.08);
            transition: background 0.3s;
        }

        .error-banner {
            width:100%;
            background:rgba(224,112,112,0.12);
            border:1px solid rgba(224,112,112,0.35);
            border-radius:8px; padding:12px 16px;
            font-size:0.875rem; color:var(--clr-error);
            margin-bottom:18px; display:flex; align-items:center; gap:10px;
        }

        .btn-primary {
            width:100%; padding:14px;
            background:var(--clr-accent); color:var(--clr-bg);
            border:none; border-radius:8px;
            font-family:'Inter',sans-serif; font-size:0.875rem;
            font-weight:500; letter-spacing:0.08em; text-transform:uppercase;
            cursor:pointer; transition:background var(--transition), transform 0.15s;
            margin-top:6px;
        }
        .btn-primary:hover { background:var(--clr-accent2); }
        .btn-primary:active { transform:scale(0.99); }

        .form-footer {
            margin-top:24px; text-align:center;
            font-size:0.85rem; color:var(--clr-muted);
        }
        .form-footer a {
            color:var(--clr-accent); text-decoration:none;
            font-weight:500; transition:color var(--transition);
        }
        .form-footer a:hover { color:var(--clr-accent2); }
    </style>
</head>
<body>

<div class="auth-shell">

    <!-- LEFT PANEL — same slideshow -->
    <div class="auth-visual" id="slideshow">
        <a class="visual-brand" href="${pageContext.request.contextPath}/home">Gallery Artisan's</a>

        <div class="slide active">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-2.jpg" alt="Art" draggable="false">
            <div class="slide-caption">
                <h2>Every great collection<br>begins here</h2>
                <p>Discover Originals</p>
            </div>
        </div>
        <div class="slide">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-4.jpg" alt="Art" draggable="false">
            <div class="slide-caption">
                <h2>Colour speaks where<br>words cannot</h2>
                <p>Gesture Series</p>
            </div>
        </div>
        <div class="slide">
            <img src="${pageContext.request.contextPath}/assets/images/placeholder-5.jpg" alt="Art" draggable="false">
            <div class="slide-caption">
                <h2>Own a piece of<br>someone's soul</h2>
                <p>Featured Artworks</p>
            </div>
        </div>

        <div class="slide-dots" id="dotContainer"></div>
    </div>

    <!-- RIGHT PANEL — registration form -->
    <div class="auth-form-wrap">

        <div class="mobile-brand">Gallery Artisan's</div>

        <div class="form-header">
            <h1>Create account</h1>
            <p>Join the gallery. It's free.</p>
        </div>

        <div class="ornament"></div>

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

        <form action="${pageContext.request.contextPath}/register" method="post" style="width:100%" id="regForm" novalidate>

            <div class="field">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName"
                       value="${fullNameValue}"
                       placeholder="Jane Doe"
                       required minlength="2" maxlength="120"
                       autocomplete="name">
            </div>

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
                       placeholder="Min. 8 characters"
                       required minlength="8"
                       autocomplete="new-password"
                       oninput="updateStrength(this.value)">
                <div class="password-strength">
                    <div class="strength-bar" id="bar1"></div>
                    <div class="strength-bar" id="bar2"></div>
                    <div class="strength-bar" id="bar3"></div>
                    <div class="strength-bar" id="bar4"></div>
                </div>
                <div class="field-hint" id="strengthLabel" style="min-height:1.2em;"></div>
            </div>

            <div class="field">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       placeholder="••••••••"
                       required autocomplete="new-password">
            </div>

            <button type="submit" class="btn-primary">Create Account</button>
        </form>

        <div class="form-footer">
            Already have an account?
            <a href="${pageContext.request.contextPath}/login">Sign in</a>
        </div>
    </div>

</div>

<script>
    // ── Slideshow ────────────────────────────────────────────────────────────
    const slides   = document.querySelectorAll('.slide');
    const dotWrap  = document.getElementById('dotContainer');
    let   current  = 0, timer = null, dragStartX = null;

    slides.forEach((_, i) => {
        const d = document.createElement('div');
        d.className = 'dot' + (i === 0 ? ' active' : '');
        d.addEventListener('click', () => goTo(i));
        dotWrap.appendChild(d);
    });

    function goTo(i) {
        slides[current].classList.remove('active');
        dotWrap.children[current].classList.remove('active');
        current = (i + slides.length) % slides.length;
        slides[current].classList.add('active');
        dotWrap.children[current].classList.add('active');
        clearInterval(timer);
        timer = setInterval(() => goTo(current + 1), 5000);
    }
    timer = setInterval(() => goTo(current + 1), 5000);

    const vis = document.getElementById('slideshow');
    vis.addEventListener('mousedown',  e => dragStartX = e.clientX);
    vis.addEventListener('touchstart', e => dragStartX = e.touches[0].clientX, {passive:true});
    vis.addEventListener('mouseup',    e => { if(dragStartX!==null){ const d=dragStartX-e.clientX; if(Math.abs(d)>40) goTo(d>0?current+1:current-1); dragStartX=null; }});
    vis.addEventListener('touchend',   e => { if(dragStartX!==null){ const d=dragStartX-e.changedTouches[0].clientX; if(Math.abs(d)>40) goTo(d>0?current+1:current-1); dragStartX=null; }});

    // ── Password strength indicator ──────────────────────────────────────────
    const colors  = ['#e07070','#e0a070','#b89a6f','#7abf7a'];
    const labels  = ['Too short','Fair','Good','Strong'];

    function updateStrength(pw) {
        let score = 0;
        if (pw.length >= 8)  score++;
        if (/[A-Z]/.test(pw)) score++;
        if (/[0-9]/.test(pw)) score++;
        if (/[^A-Za-z0-9]/.test(pw)) score++;

        const bars  = [bar1, bar2, bar3, bar4];
        const color = colors[Math.max(0, score - 1)] || 'transparent';
        bars.forEach((b, i) => {
            b.style.background = i < score ? color : 'rgba(255,255,255,0.08)';
        });
        document.getElementById('strengthLabel').textContent = pw.length ? labels[Math.max(0,score-1)] : '';
        document.getElementById('strengthLabel').style.color = color;
    }

    // ── Client-side match check ──────────────────────────────────────────────
    document.getElementById('regForm').addEventListener('submit', function(e) {
        const pw  = document.getElementById('password').value;
        const pw2 = document.getElementById('confirmPassword').value;
        if (pw !== pw2) {
            e.preventDefault();
            document.getElementById('confirmPassword').classList.add('invalid');
            document.getElementById('confirmPassword').focus();
        }
    });
</script>

</body>
</html>
