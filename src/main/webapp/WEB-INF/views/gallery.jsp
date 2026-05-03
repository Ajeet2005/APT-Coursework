<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Gallery â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<section class="page-hero">
    <span class="eyebrow">The walls</span>
    <h1>Gallery</h1>
    <p>A full-bleed tour of every painting currently on display.</p>
</section>

<!-- yak-biergarten-style generous masonry wall -->
<section class="gallery-wall">
    <c:choose>
        <c:when test="${not empty artworks}">
            <c:forEach var="art" items="${artworks}" varStatus="loop">
                <a class="wall-item wall-${loop.index % 7}" href="<%= ctx %>/art?id=${art.id}">
                    <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                    <div class="wall-caption">
                        <h3>${art.title}</h3>
                        <p>${art.artistName}</p>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <c:forEach var="i" begin="1" end="12">
                <c:set var="phIdx" value="${((i-1) % 5) + 1}"/>
                <c:choose>
                    <c:when test="${phIdx == 1}"><c:set var="ph" value="Portrait/239cf4bb986b78c100681a1599acefa4.jpg"/></c:when>
                    <c:when test="${phIdx == 2}"><c:set var="ph" value="Portrait/25a09476d9b32d44ff78055c67d28fcd.jpg"/></c:when>
                    <c:when test="${phIdx == 3}"><c:set var="ph" value="Portrait/12a612e740abd1dc969138f5c597b87b.jpg"/></c:when>
                    <c:when test="${phIdx == 4}"><c:set var="ph" value="Portrait/12ea0489b373da12a4208b90bdfd7c28.jpg"/></c:when>
                    <c:otherwise><c:set var="ph" value="Portrait/085f7607b37fc18506186c62ea86b18d.jpg"/></c:otherwise>
                </c:choose>
                <a class="wall-item wall-${(i-1) % 7}" href="#">
                    <img src="<%= ctx %>/assets/images/${ph}" alt="Placeholder ${i}">
                    <div class="wall-caption">
                        <h3>Untitled ${i}</h3>
                        <p>Gallery Artisan&rsquo;s</p>
                    </div>
                </a>
            </c:forEach>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
