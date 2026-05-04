<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Admin Dashboard &mdash; Gallery Artisan&rsquo;s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="page-hero botanical-hero">
    <span class="eyebrow">Administration</span>
    <h1>Admin Dashboard</h1>
    <p>Welcome, <%= currentUser.getFullName() %>. You are signed in as an administrator.</p>
</section>

<section style="max-width: 900px; margin: 48px auto; padding: 0 24px;">

    <div style="background: rgba(155,89,182,0.08); border: 1px solid rgba(155,89,182,0.25);
                border-radius: 12px; padding: 36px 40px; text-align: center;">
        <svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg"
             style="margin-bottom: 16px; opacity: 0.7;">
            <circle cx="24" cy="24" r="22" stroke="#9b59b6" stroke-width="2"/>
            <path d="M24 12v10l6 4" stroke="#9b59b6" stroke-width="2.5" stroke-linecap="round" stroke-linejoin="round"/>
        </svg>
        <h2 style="font-family: 'Cormorant Garamond', serif; font-size: 1.8rem; font-weight: 400;
                   color: #e8e0d5; margin-bottom: 10px;">
            Dashboard Coming Soon
        </h2>
        <p style="color: #7a7086; font-size: 0.95rem; line-height: 1.6; max-width: 500px; margin: 0 auto;">
            The admin dashboard is under construction. You'll be able to manage artworks,
            categories, artists, orders, and user accounts from here.
        </p>
    </div>

    <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
                gap: 20px; margin-top: 32px;">

        <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
                    border-radius: 10px; padding: 28px 24px; text-align: center;">
            <div style="font-size: 2rem; margin-bottom: 8px;">&#128444;</div>
            <h3 style="font-family: 'Cormorant Garamond', serif; font-size: 1.15rem;
                       color: #e8e0d5; margin-bottom: 4px;">Artworks</h3>
            <p style="font-size: 0.78rem; color: #7a7086;">Manage gallery inventory</p>
        </div>

        <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
                    border-radius: 10px; padding: 28px 24px; text-align: center;">
            <div style="font-size: 2rem; margin-bottom: 8px;">&#128101;</div>
            <h3 style="font-family: 'Cormorant Garamond', serif; font-size: 1.15rem;
                       color: #e8e0d5; margin-bottom: 4px;">Users</h3>
            <p style="font-size: 0.78rem; color: #7a7086;">Manage accounts & roles</p>
        </div>

        <div style="background: rgba(255,255,255,0.03); border: 1px solid rgba(255,255,255,0.08);
                    border-radius: 10px; padding: 28px 24px; text-align: center;">
            <div style="font-size: 2rem; margin-bottom: 8px;">&#128230;</div>
            <h3 style="font-family: 'Cormorant Garamond', serif; font-size: 1.15rem;
                       color: #e8e0d5; margin-bottom: 4px;">Orders</h3>
            <p style="font-size: 0.78rem; color: #7a7086;">Track purchases & shipping</p>
        </div>

    </div>

</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
