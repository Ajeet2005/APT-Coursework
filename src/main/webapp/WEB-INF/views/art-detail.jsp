<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${artwork != null ? artwork.title : 'Artwork'} â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<c:choose>
    <c:when test="${artwork != null}">
        <section class="art-detail">
            <div class="art-detail-img">
                <img src="<%= ctx %>/${artwork.imageUrl}" alt="${artwork.title}">
            </div>
            <div class="art-detail-body">
                <span class="eyebrow">${artwork.categoryName}</span>
                <h1>${artwork.title}</h1>
                <p class="muted">By <a href="<%= ctx %>/artist?id=${artwork.artistId}">${artwork.artistName}</a></p>
                <p>${artwork.description}</p>
                <c:if test="${artwork.price != null}">
                    <p class="price">Rs.&nbsp;<fmt:formatNumber value="${artwork.price}" type="number" maxFractionDigits="0" groupingUsed="true"/></p>
                </c:if>
                <a class="btn btn-primary" href="<%= ctx %>/gallery">Back to Gallery</a>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <section class="page-hero"><h1>Artwork not found</h1></section>
    </c:otherwise>
</c:choose>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
