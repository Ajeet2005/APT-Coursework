<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Art â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<section class="page-hero">
    <span class="eyebrow">Collection</span>
    <h1>Art</h1>
    <p>Every piece currently on our walls â€” colour, texture, and story.</p>
</section>

<section class="art-grid">
    <c:choose>
        <c:when test="${not empty artworks}">
            <c:forEach var="art" items="${artworks}">
                <a class="art-card" href="<%= ctx %>/art?id=${art.id}">
                    <img src="${art.imageUrl}" alt="${art.title}">
                    <div class="art-card-body">
                        <h3>${art.title}</h3>
                        <p class="muted">${art.artistName} &middot; ${art.categoryName}</p>
                        <c:if test="${art.price != null}">
                            <p class="price"><fmt:formatNumber value="${art.price}" type="currency" currencySymbol="$"/></p>
                        </c:if>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="empty">Once the database is seeded, artworks will appear here.</p>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
