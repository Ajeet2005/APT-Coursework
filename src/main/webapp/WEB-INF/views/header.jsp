<%--
  ════════════════════════════════════════════════════════════════════
  header.jsp  —  AUTH-AWARE VERSION
  ════════════════════════════════════════════════════════════════════
  Drop this file into:  src/main/webapp/WEB-INF/views/includes/header.jsp
  replacing your existing header.jsp entirely.

  Key additions vs the original:
    • "Sign In" / "Sign Up" links when no session exists
    • User's name + "Sign Out" link when logged in as user
    • "Admin Dashboard" + "Sign Out" links when logged in as admin
    • Flash-message banner (used by RegisterServlet after account creation)
  ════════════════════════════════════════════════════════════════════
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<%-- Retrieve the logged-in user from the session (null = not logged in) --%>
<c:set var="currentUser" value="${sessionScope.loggedInUser}" />

<header class="site-header">
    <div class="header-inner">

        <!-- Brand -->
        <a class="brand" href="${pageContext.request.contextPath}/home">Gallery Artisan's</a>

        <!-- Primary nav -->
        <nav class="primary-nav">
            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/categories">Categories</a>
            <a href="${pageContext.request.contextPath}/art">Art</a>
            <a href="${pageContext.request.contextPath}/artist">Artists</a>
            <a href="${pageContext.request.contextPath}/gallery">Gallery</a>
        </nav>

        <!-- Auth controls -->
        <div class="header-auth">
            <c:choose>

                <%-- ── NOT logged in ─────────────────────────────────────── --%>
                <c:when test="${empty currentUser}">
                    <a class="auth-link" href="${pageContext.request.contextPath}/login">Sign In</a>
                    <a class="auth-btn"  href="${pageContext.request.contextPath}/register">Sign Up</a>
                </c:when>

                <%-- ── Admin ──────────────────────────────────────────────── --%>
                <c:when test="${currentUser.admin}">
                    <a class="auth-link" href="${pageContext.request.contextPath}/admin">
                        ⚙ Dashboard
                    </a>
                    <span class="auth-name">
                        ${currentUser.fullName}
                    </span>
                    <a class="auth-link auth-logout" href="${pageContext.request.contextPath}/logout">Sign Out</a>
                </c:when>

                <%-- ── Regular user ────────────────────────────────────────── --%>
                <c:otherwise>
                    <span class="auth-name">
                        ${currentUser.fullName}
                    </span>
                    <a class="auth-link auth-logout" href="${pageContext.request.contextPath}/logout">Sign Out</a>
                </c:otherwise>

            </c:choose>
        </div>

        <!-- Mobile hamburger (keep whatever you already had) -->
        <button class="nav-toggle" aria-label="Toggle navigation">
            <span></span><span></span><span></span>
        </button>

    </div>
</header>

<%-- ── Flash message (shown once after register / future actions) ── --%>
<c:if test="${not empty sessionScope.flashMessage}">
    <div class="flash-banner" id="flashBanner">
        <span>${sessionScope.flashMessage}</span>
        <button onclick="this.parentElement.remove()" aria-label="Close">✕</button>
    </div>
    <%-- Remove it from the session so it shows only once --%>
    <c:remove var="flashMessage" scope="session"/>
</c:if>


<%--
  ════════════════════════════════════════════════════════════════════
  ADD THESE CSS RULES to your existing assets/css/style.css
  (or paste them inside a <style> tag here if you prefer)
  ════════════════════════════════════════════════════════════════════

.header-auth {
    display: flex;
    align-items: center;
    gap: 12px;
    flex-shrink: 0;
}

.auth-link {
    font-size: 0.8rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    color: var(--clr-muted, #7a7086);
    text-decoration: none;
    transition: color 0.2s;
}
.auth-link:hover { color: var(--clr-accent, #b89a6f); }

.auth-btn {
    font-size: 0.78rem;
    letter-spacing: 0.08em;
    text-transform: uppercase;
    padding: 7px 16px;
    border: 1px solid var(--clr-accent, #b89a6f);
    border-radius: 6px;
    color: var(--clr-accent, #b89a6f);
    text-decoration: none;
    transition: background 0.2s, color 0.2s;
}
.auth-btn:hover {
    background: var(--clr-accent, #b89a6f);
    color: var(--clr-bg, #0d0b14);
}

.auth-name {
    font-size: 0.82rem;
    color: var(--clr-text, #e8e0d5);
    font-style: italic;
    font-family: 'Cormorant Garamond', serif;
    font-size: 1rem;
}

.auth-logout { color: var(--clr-muted, #7a7086); }

/* Flash banner */
.flash-banner {
    background: rgba(184,154,111,0.12);
    border-bottom: 1px solid rgba(184,154,111,0.25);
    padding: 12px 24px;
    display: flex;
    align-items: center;
    justify-content: space-between;
    font-size: 0.875rem;
    color: #d4b896;
    animation: slideDown 0.4s ease;
}
.flash-banner button {
    background: none; border: none;
    color: inherit; cursor: pointer;
    font-size: 1rem; opacity: 0.6;
}
.flash-banner button:hover { opacity: 1; }

@keyframes slideDown {
    from { opacity:0; transform:translateY(-8px); }
    to   { opacity:1; transform:translateY(0); }
}

════════════════════════════════════════════════════════════════════ --%>
