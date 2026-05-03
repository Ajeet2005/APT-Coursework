<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Artists â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<section class="page-hero">
    <span class="eyebrow">The makers</span>
    <h1>Artists</h1>
    <p>The hands and minds behind every canvas on our walls.</p>
</section>

<section class="artist-grid">
    <c:choose>
        <c:when test="${not empty artists}">
            <c:forEach var="ar" items="${artists}">
                <a class="artist-card" href="<%= ctx %>/artist?id=${ar.id}">
                    <div class="artist-portrait">
                        <img src="${ar.profileImage}" alt="${ar.name}">
                    </div>
                    <h3>${ar.name}</h3>
                    <p class="muted">${ar.country}</p>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="empty">Artists will appear here once the database is seeded.</p>
        </c:otherwise>
    </c:choose>
</section>

<c:if test="${not empty selectedArtist}">
    <section class="artist-detail">
        <div class="artist-detail-portrait">
            <img src="${selectedArtist.profileImage}" alt="${selectedArtist.name}">
        </div>
        <div class="artist-detail-body">
            <span class="eyebrow">${selectedArtist.country}</span>
            <h2>${selectedArtist.name}</h2>
            <p>${selectedArtist.bio}</p>
        </div>
    </section>
    <section class="section-head">
        <h2>Works by ${selectedArtist.name}</h2>
    </section>
    <section class="art-grid">
        <c:forEach var="art" items="${artworks}">
            <a class="art-card" href="<%= ctx %>/art?id=${art.id}">
                <img src="${art.imageUrl}" alt="${art.title}">
                <div class="art-card-body">
                    <h3>${art.title}</h3>
                    <p class="muted">${art.categoryName}</p>
                </div>
            </a>
        </c:forEach>
    </section>
</c:if>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
