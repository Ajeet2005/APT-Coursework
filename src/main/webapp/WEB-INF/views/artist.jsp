<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Artists â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<c:choose>
    <%-- ============ DETAIL VIEW: a specific artist was clicked ============ --%>
    <c:when test="${not empty selectedArtist}">
        <section class="page-hero">
            <span class="eyebrow">
                <a href="<%= ctx %>/artist" style="color:inherit;text-decoration:none;">&larr; All artists</a>
            </span>
            <h1>${selectedArtist.name}</h1>
            <p>${selectedArtist.country}</p>
        </section>

        <section class="artist-detail">
            <div class="artist-detail-portrait">
                <img src="<%= ctx %>/${selectedArtist.profileImage}" alt="${selectedArtist.name}">
            </div>
            <div class="artist-detail-body">
                <span class="eyebrow">${selectedArtist.country}</span>
                <h2>${selectedArtist.name}</h2>
                <p>${selectedArtist.bio}</p>
            </div>
        </section>

        <section class="section-head">
            <h2>Works by ${selectedArtist.name}</h2>
            <p>
                <strong><c:out value="${not empty artworks ? artworks.size() : 0}"/></strong>
                piece<c:if test="${empty artworks or artworks.size() != 1}">s</c:if> in the gallery
            </p>
        </section>

        <section class="art-grid">
            <c:choose>
                <c:when test="${not empty artworks}">
                    <c:forEach var="art" items="${artworks}">
                        <a class="art-card" href="<%= ctx %>/art?id=${art.id}">
                            <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                            <div class="art-card-body">
                                <h3>${art.title}</h3>
                                <p class="muted">${art.categoryName}</p>
                                <c:if test="${art.price != null}">
                                    <p class="price">Rs.&nbsp;${art.price}</p>
                                </c:if>
                            </div>
                        </a>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <p class="empty">No works by ${selectedArtist.name} in the gallery yet.</p>
                </c:otherwise>
            </c:choose>
        </section>
    </c:when>

    <%-- ============ INDEX VIEW: list all artists ============ --%>
    <c:otherwise>
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
                                <img src="<%= ctx %>/${ar.profileImage}" alt="${ar.name}">
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
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
