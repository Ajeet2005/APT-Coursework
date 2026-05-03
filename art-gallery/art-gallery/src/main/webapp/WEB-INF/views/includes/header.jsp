<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    String ctx = request.getContextPath();
    String active = (String) request.getAttribute("activePage");
    if (active == null) active = "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <c:set var="_defaultTitle">Gallery Artisan's</c:set>
    <title><c:out value="${not empty pageTitle ? pageTitle : _defaultTitle}" /></title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=Inter:wght@300;400;500;600&display=swap" rel="stylesheet">
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
        </nav>
        <a href="<%= ctx %>/cart"
           class="cart-link <%= "cart".equals(active) ? "active" : "" %>"
           aria-label="View cart">
            <svg class="cart-icon" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <!-- handle + cart body -->
                <path d="M2.5 3h2.5l1.6 3H22l-2.4 8.4a1.6 1.6 0 0 1-1.55 1.1H9.05a1.6 1.6 0 0 1-1.55-1.2L4.7 4.5"/>
                <!-- plus inside cart -->
                <line x1="13" y1="8.5" x2="13" y2="12.5"/>
                <line x1="11" y1="10.5" x2="15" y2="10.5"/>
                <!-- wheels -->
                <circle cx="9"  cy="20" r="1.5"/>
                <circle cx="17" cy="20" r="1.5"/>
            </svg>
            <%
                Integer cartItemCount = (Integer) request.getAttribute("cartItemCount");
                if (cartItemCount == null) cartItemCount = 0;
            %>
            <span class="cart-badge <%= cartItemCount > 0 ? "has-items" : "" %>"
                  data-cart-badge><%= cartItemCount %></span>
        </a>
        <button class="nav-toggle" aria-label="Menu" onclick="document.body.classList.toggle('nav-open')">
            <span></span><span></span><span></span>
        </button>
    </div>
</header>
<main class="site-main">
