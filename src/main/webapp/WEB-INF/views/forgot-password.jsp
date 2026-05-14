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
    <title>Reset Password — Gallery Artisan's</title>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap"
          rel="stylesheet">

    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --bg:           #0b0910;
            --bg-alt:       #120d1c;
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

        .auth-shell {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 24px;
            background:
                radial-gradient(ellipse at top, rgba(122,59,255,.15) 0%, transparent 60%),
                radial-gradient(ellipse at bottom right, rgba(75,29,159,.18) 0%, transparent 50%),
                var(--bg);
        }

        .auth-form-wrap {
            width: 100%;
            max-width: 460px;
            padding: 48px 44px;
            background: var(--bg-alt);
            border: 1px solid var(--line);
            border-radius: 16px;
            position: relative;
            animation: fadeInUp 0.7s cubic-bezier(.4,0,.2,1);
            box-shadow: 0 30px 80px -30px rgba(122, 59, 255, 0.35);
        }

        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(10px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .brand {
            font-family: var(--font-display);
            font-size: 1.6rem;
            font-weight: 600;
            color: var(--ink);
            text-align: center;
            margin-bottom: 28px;
            display: flex; align-items: center; justify-content: center; gap: 8px;
        }

        .form-header { text-align: center; margin-bottom: 24px; }
        .form-header h1 {
            font-family: var(--font-display);
            font-size: 2.4rem;
            font-weight: 500;
            color: var(--ink);
            line-height: 1.1;
            letter-spacing: -0.01em;
        }
        .form-header h1 em {
            font-style: italic;
            color: var(--purple-soft);
            font-weight: 400;
        }
        .form-header p {
            color: var(--muted);
            font-size: 0.9rem;
            margin-top: 12px;
        }

        .ornament {
            width: 40px; height: 1px;
            background: linear-gradient(90deg, transparent, var(--purple-soft), transparent);
            margin: 0 auto 28px;
        }

        .field { margin-bottom: 18px; width: 100%; position: relative; }
        .field label {
            display: block;
            font-size: 0.7rem;
            letter-spacing: 0.18em;
            text-transform: uppercase;
            color: var(--muted);
            margin-bottom: 8px;
            font-weight: 500;
        }
        .field input {
            width: 100%;
            background: var(--input-bg);
            border: 1px solid var(--line);
            border-radius: 8px;
            padding: 13px 16px;
            font-size: 0.95rem;
            color: var(--ink);
            font-family: var(--font-sans);
            outline: none;
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

        .error-banner {
            background: rgba(224,112,112,0.1);
            border: 1px solid rgba(224,112,112,0.3);
            border-radius: 8px;
            padding: 12px 16px;
            font-size: 0.875rem;
            color: var(--error);
            margin-bottom: 18px;
            display: flex; align-items: center; gap: 10px;
            animation: shake 0.4s ease;
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
            font-family: var(--font-sans);
            font-size: 0.85rem;
            font-weight: 600;
            letter-spacing: 0.12em;
            text-transform: uppercase;
            cursor: pointer;
            margin-top: 6px;
            transition: background var(--transition), transform 0.15s, box-shadow var(--transition), color var(--transition);
        }
        .btn-primary:hover {
            background: var(--purple);
            color: #fff;
            box-shadow: 0 8px 28px rgba(122, 59, 255, 0.4);
            transform: translateY(-1px);
        }
        .btn-primary:active { transform: translateY(0) scale(0.985); }

        .form-footer {
            margin-top: 22px;
            text-align: center;
            font-size: 0.88rem;
            color: var(--muted);
        }
        .form-footer a {
            color: var(--purple-soft);
            text-decoration: none;
            font-weight: 600;
            transition: color var(--transition);
        }
        .form-footer a:hover { color: #fff; }

        .info-note {
            background: rgba(122, 59, 255, 0.08);
            border: 1px solid rgba(201, 182, 255, 0.2);
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 22px;
            font-size: 0.82rem;
            color: var(--purple-soft);
            display: flex;
            gap: 10px;
            align-items: flex-start;
        }
        .info-note svg { flex-shrink: 0; margin-top: 1px; }

        .back-home {
            position: absolute; top: 18px; left: 18px;
            font-size: 0.75rem; color: var(--muted);
            text-decoration: none; display: flex; align-items: center; gap: 6px;
            transition: color var(--transition);
        }
        .back-home:hover { color: var(--purple-soft); }
        .back-home svg { width: 14px; height: 14px; }
    </style>
</head>
<body>

<div class="auth-shell">
    <div class="auth-form-wrap">

        <a class="back-home" href="<%= ctx %>/login">
            <svg viewBox="0 0 14 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <path d="M9 1L3 7l6 6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
            </svg>
            Back to Login
        </a>

        <div class="brand">
            <span>&#127963;</span>
            <span>Gallery Artisan's</span>
        </div>

        <div class="form-header">
            <h1>Reset <em>password</em></h1>
            <p>Enter your email and a new password to regain access.</p>
        </div>

        <div class="ornament"></div>

        <div class="info-note">
            <svg width="16" height="16" viewBox="0 0 16 16" fill="none" aria-hidden="true">
                <circle cx="8" cy="8" r="7" stroke="currentColor" stroke-width="1.4"/>
                <path d="M8 5v4" stroke="currentColor" stroke-width="1.4" stroke-linecap="round"/>
                <circle cx="8" cy="11.5" r="0.7" fill="currentColor"/>
            </svg>
            <span>Provide the email used to register and choose a new password.</span>
        </div>

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

        <form action="<%= ctx %>/forgot-password" method="post" id="resetForm">
            <div class="field">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       value="${emailValue}"
                       placeholder="you@example.com"
                       required autocomplete="email">
            </div>

            <div class="field field-with-icon">
                <label for="newPassword">New Password</label>
                <input type="password" id="newPassword" name="newPassword"
                       placeholder="Min. 8 characters"
                       required minlength="8" autocomplete="new-password">
                <button type="button" class="pw-toggle" data-toggle="newPassword" aria-label="Show password">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                </button>
            </div>

            <div class="field field-with-icon">
                <label for="confirmPassword">Confirm New Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       placeholder="••••••••"
                       required autocomplete="new-password">
                <button type="button" class="pw-toggle" data-toggle="confirmPassword" aria-label="Show password">
                    <svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                        <path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                        <circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>
                    </svg>
                </button>
            </div>

            <button type="submit" class="btn-primary">Reset Password</button>
        </form>

        <div class="form-footer">
            Remembered your password?
            <a href="<%= ctx %>/login">Sign in</a>
        </div>
    </div>
</div>

<script>
    // Password visibility toggles
    (function() {
        var eyeOpen = '<path d="M2 12s3.5-7 10-7 10 7 10 7-3.5 7-10 7S2 12 2 12z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/><circle cx="12" cy="12" r="3" stroke="currentColor" stroke-width="1.5"/>';
        var eyeOff  = '<path d="M3 3l18 18M10.6 10.6a3 3 0 0 0 4.2 4.2M9.4 5.2A10 10 0 0 1 12 5c6.5 0 10 7 10 7a17 17 0 0 1-2.9 3.6M6.1 6.1A17 17 0 0 0 2 12s3.5 7 10 7c1.7 0 3.2-.4 4.5-1" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>';

        var toggles = document.querySelectorAll('.pw-toggle');
        toggles.forEach(function(btn) {
            btn.addEventListener('click', function() {
                var targetId = btn.getAttribute('data-toggle');
                var input = document.getElementById(targetId);
                var svg = btn.querySelector('svg');
                if (!input || !svg) return;
                var isPw = input.type === 'password';
                input.type = isPw ? 'text' : 'password';
                svg.innerHTML = isPw ? eyeOff : eyeOpen;
                btn.setAttribute('aria-label', isPw ? 'Hide password' : 'Show password');
            });
        });
    })();

    // Client-side match check
    document.getElementById('resetForm').addEventListener('submit', function(e) {
        var pw1 = document.getElementById('newPassword').value;
        var pw2 = document.getElementById('confirmPassword').value;
        if (pw1 !== pw2) {
            e.preventDefault();
            var confirmInput = document.getElementById('confirmPassword');
            confirmInput.setCustomValidity('Passwords do not match');
            confirmInput.reportValidity();
        }
    });
    document.getElementById('confirmPassword').addEventListener('input', function() {
        this.setCustomValidity('');
    });
</script>

</body>
</html>
