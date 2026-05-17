<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
    String active = (String) request.getAttribute("activePage");
    if (active == null) active = "";

    // Retrieve logged-in user from session
    com.artgallery.model.User currentUser =
        (com.artgallery.model.User) session.getAttribute("loggedInUser");
    boolean loggedIn = (currentUser != null);
    boolean isAdmin  = loggedIn && currentUser.isAdmin();

    // Build initials for avatar
    String initials = "";
    if (loggedIn) {
        String[] parts = currentUser.getFullName().trim().split("\\s+");
        initials += Character.toUpperCase(parts[0].charAt(0));
        if (parts.length > 1) initials += Character.toUpperCase(parts[parts.length - 1].charAt(0));
    }

    // Cart count for badge
    int cartCount = 0;
    try {
        cartCount = new com.artgallery.dao.CartDAO().countItems(session.getId());
    } catch (Exception ignore) { /* fall back to 0 */ }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:set var="_defaultTitle">Gallery Artisan's</c:set>
    <title><c:out value="${not empty pageTitle ? pageTitle : _defaultTitle}" /></title>
    <%-- Inline SVG favicon — gallery columns mark in purple --%>
    <link rel="icon" type="image/svg+xml" href="data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'><rect width='32' height='32' rx='6' fill='%237a3bff'/><path d='M5 12L16 6l11 6v2H5z' fill='%23f4f1fb'/><rect x='7' y='14' width='2.5' height='9' fill='%23f4f1fb'/><rect x='12' y='14' width='2.5' height='9' fill='%23f4f1fb'/><rect x='17.5' y='14' width='2.5' height='9' fill='%23f4f1fb'/><rect x='22.5' y='14' width='2.5' height='9' fill='%23f4f1fb'/><rect x='5' y='24' width='22' height='2.5' fill='%23f4f1fb'/></svg>">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    <meta name="theme-color" content="#0b0910">
    <link rel="stylesheet" href="<%= ctx %>/assets/css/style.css">
</head>
<body>

<header class="site-header">
    <div class="nav-inner">
        <a href="<%= ctx %>/home" class="brand">
            <span class="brand-mark">&#127963;</span>
            <span class="brand-name">Gallery Artisan&rsquo;s</span>
        </a>
        <nav class="primary-nav" aria-label="Primary">
            <a href="<%= ctx %>/home"       class="<%= "home".equals(active)       ? "active" : "" %>">Home</a>
            <a href="<%= ctx %>/categories" class="<%= "categories".equals(active) ? "active" : "" %>">Categories</a>
            <a href="<%= ctx %>/art"        class="<%= "art".equals(active)        ? "active" : "" %>">Art</a>
            <a href="<%= ctx %>/artist"     class="<%= "artist".equals(active)     ? "active" : "" %>">Artist</a>
            <a href="<%= ctx %>/gallery"    class="<%= "gallery".equals(active)    ? "active" : "" %>">Gallery</a>
            <% if (isAdmin) { %>
            <a href="<%= ctx %>/admin"
               class="nav-admin <%= "admin".equals(active) ? "active" : "" %>">
                <svg viewBox="0 0 16 16" fill="none" xmlns="http://www.w3.org/2000/svg" aria-hidden="true">
                    <path d="M8 1.5l5.5 2.2v3.8c0 3.2-2.3 6.1-5.5 6.6-3.2-.5-5.5-3.4-5.5-6.6V3.7L8 1.5z"
                          stroke="currentColor" stroke-width="1.4" stroke-linejoin="round" fill="none"/>
                    <path d="M5.8 8.1l1.5 1.5L10.3 6.6"
                          stroke="currentColor" stroke-width="1.4" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                Admin Dashboard
            </a>
            <% } %>
        </nav>

        <div class="nav-actions">

            <%-- ─── Cart icon with badge ────────────────────────────────────── --%>
            <a href="<%= ctx %>/cart" class="nav-cart" aria-label="View cart">
                <svg viewBox="0 0 32 32" xmlns="http://www.w3.org/2000/svg" aria-hidden="true"
                     fill="none" stroke="currentColor" stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                    <path d="M6 2L4 6"/>
                    <path d="M4 6h2.5L9 18h15.5l3.5-12H6.5"/>
                    <line x1="9.5" y1="6" x2="8" y2="18"/>
                    <line x1="14" y1="6" x2="13" y2="18"/>
                    <line x1="18.5" y1="6" x2="17.5" y2="18"/>
                    <line x1="23" y1="6" x2="22.5" y2="18"/>
                    <line x1="7" y1="10" x2="27.5" y2="10"/>
                    <line x1="7.8" y1="14" x2="26.5" y2="14"/>
                    <path d="M9 18c-2 0-3.5 1.8-2.5 3.5h18"/>
                    <circle cx="10" cy="26" r="2.5" fill="currentColor"/><circle cx="22" cy="26" r="2.5" fill="currentColor"/>
                    <circle cx="10" cy="26" r="1" fill="none" stroke="var(--bg, #0b0910)" stroke-width="1.5"/>
                    <circle cx="22" cy="26" r="1" fill="none" stroke="var(--bg, #0b0910)" stroke-width="1.5"/>
                </svg>
                <% if (cartCount > 0) { %>
                <span class="nav-cart-badge has-items" data-cart-badge><%= cartCount %></span>
                <% } %>
            </a>

            <%-- ─── Person / Auth icon ──────────────────────────────────────── --%>
            <div class="auth-avatar-wrap" id="authAvatarWrap">
                <% if (!loggedIn) { %>
                    <%-- Not logged in: person icon links to /login --%>
                    <a href="<%= ctx %>/login"
                       class="auth-avatar auth-avatar--guest"
                       id="authAvatarBtn"
                       aria-label="Sign in to your account"
                       title="Sign In">
                        <svg viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg"
                             aria-hidden="true" class="avatar-svg">
                            <circle cx="20" cy="20" r="19" stroke="currentColor" stroke-width="2"/>
                            <circle cx="20" cy="15" r="6" fill="currentColor" opacity="0.85"/>
                            <path d="M6 35c0-7.732 6.268-14 14-14s14 6.268 14 14"
                                  stroke="currentColor" stroke-width="2" stroke-linecap="round" fill="none" opacity="0.85"/>
                        </svg>
                    </a>
                <% } else { %>
                    <%-- Logged in: avatar circle with initials, hover dropdown --%>
                    <button class="auth-avatar auth-avatar--user<%= isAdmin ? " auth-avatar--admin" : "" %>"
                            id="authAvatarBtn"
                            aria-label="Account menu"
                            aria-expanded="false"
                            aria-haspopup="true">
                        <span class="avatar-initials"><%= initials %></span>
                    </button>
                    <div class="auth-dropdown" id="authDropdown" role="menu">
                        <div class="auth-dropdown-header">
                            <span class="auth-dropdown-name"><%= currentUser.getFullName() %></span>
                            <span class="auth-dropdown-role"><%= isAdmin ? "Administrator" : "Member" %></span>
                        </div>
                        <div class="auth-dropdown-divider"></div>
                        <a href="<%= ctx %>/profile" class="auth-dropdown-item" role="menuitem">
                            <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" width="16" height="16">
                                <path d="M13.586 3.586a2 2 0 1 1 2.828 2.828l-8.793 8.793-3.536.707.707-3.536 8.793-8.793z" stroke="currentColor" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Edit Profile
                        </a>
                        <% if (isAdmin) { %>
                        <a href="<%= ctx %>/admin" class="auth-dropdown-item" role="menuitem">
                            <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" width="16" height="16">
                                <path d="M10 2a8 8 0 1 0 0 16A8 8 0 0 0 10 2zm0 3a1.5 1.5 0 1 1 0 3 1.5 1.5 0 0 1 0-3zm0 9.5a5.5 5.5 0 0 1-4.58-2.46c.023-1.52 3.053-2.354 4.58-2.354 1.52 0 4.556.834 4.58 2.354A5.5 5.5 0 0 1 10 14.5z" fill="currentColor"/>
                            </svg>
                            Admin Dashboard
                        </a>
                        <% } %>
                        <a href="<%= ctx %>/logout" class="auth-dropdown-item auth-dropdown-item--logout" role="menuitem">
                            <svg viewBox="0 0 20 20" fill="none" xmlns="http://www.w3.org/2000/svg" width="16" height="16">
                                <path d="M7 17H3a1 1 0 0 1-1-1V4a1 1 0 0 1 1-1h4M14 13l3-3-3-3M17 10H8" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round"/>
                            </svg>
                            Sign Out
                        </a>
                    </div>
                <% } %>
            </div>
        </div>

        <button class="nav-toggle" aria-label="Menu" onclick="document.body.classList.toggle('nav-open')">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>

<%-- ── Flash message (shown once after register / future actions) ── --%>
<%
    String flashMsg = (String) session.getAttribute("flashMessage");
    if (flashMsg != null) {
        session.removeAttribute("flashMessage");
%>
<div class="flash-banner" id="flashBanner" role="alert">
    <svg width="18" height="18" viewBox="0 0 18 18" fill="none" aria-hidden="true">
        <circle cx="9" cy="9" r="8" stroke="#7abf7a" stroke-width="1.5"/>
        <path d="M5.5 9l2.5 2.5 4-5" stroke="#7abf7a" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <span><%= flashMsg %></span>
    <button onclick="this.parentElement.remove()" aria-label="Close flash message">&times;</button>
</div>
<%
    }
%>

<main class="site-main">

<script>
(function() {
    var btn = document.getElementById('authAvatarBtn');
    var drop = document.getElementById('authDropdown');
    if (!btn || !drop) return;

    btn.addEventListener('click', function(e) {
        e.stopPropagation();
        var open = drop.classList.toggle('open');
        btn.setAttribute('aria-expanded', open ? 'true' : 'false');
    });

    document.addEventListener('click', function() {
        drop.classList.remove('open');
        btn.setAttribute('aria-expanded', 'false');
    });

    drop.addEventListener('click', function(e) { e.stopPropagation(); });
})();

// Auto-dismiss flash banner after 4 seconds
(function() {
    var flash = document.getElementById('flashBanner');
    if (!flash) return;
    setTimeout(function() {
        flash.style.transition = 'opacity .4s ease, transform .4s ease';
        flash.style.opacity = '0';
        flash.style.transform = 'translateY(-10px)';
        setTimeout(function() { flash.remove(); }, 400);
    }, 4000);
})();
</script>
