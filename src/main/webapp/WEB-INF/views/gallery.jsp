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
                    <img src="${art.imageUrl}" alt="${art.title}">
                    <div class="wall-caption">
                        <h3>${art.title}</h3>
                        <p>${art.artistName}</p>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <c:forEach var="i" begin="1" end="12">
                <a class="wall-item wall-${(i-1) % 7}" href="#">
                    <img src="<%= ctx %>/assets/images/placeholder-${((i-1) % 5) + 1}.jpg" alt="Placeholder ${i}">
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
