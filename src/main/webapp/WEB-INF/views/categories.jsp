<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Categories â€” Gallery Artisanâ€™s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>
<section class="page-hero">
    <span class="eyebrow">Browse</span>
    <h1>Categories</h1>
    <p>From vibrant acrylic to quiet abstraction â€” pick a mood and step inside.</p>
</section>

<section class="category-grid">
    <c:choose>
        <c:when test="${not empty categories}">
            <c:forEach var="cat" items="${categories}">
                <c:set var="catHref" value="${pageContext.request.contextPath}/categories?id=${cat.id}" />
                <c:if test="${cat.name eq 'Botanical'}">
                    <c:set var="catHref" value="${pageContext.request.contextPath}/botanical" />
                </c:if>
                <c:if test="${cat.name eq 'Gesture'}">
                    <c:set var="catHref" value="${pageContext.request.contextPath}/gesture" />
                </c:if>
                <c:if test="${cat.name eq 'Portrait'}">
                    <c:set var="catHref" value="${pageContext.request.contextPath}/portrait" />
                </c:if>
                <c:if test="${cat.name eq 'Still Life'}">
                    <c:set var="catHref" value="${pageContext.request.contextPath}/stilllife" />
                </c:if>
                <c:if test="${cat.name eq 'Landscape'}">
                    <c:set var="catHref" value="${pageContext.request.contextPath}/landscape" />
                </c:if>
                <a class="category-card" href="${catHref}">
                    <div class="category-image">
                        <img src="<%= ctx %>/${cat.coverImage}" alt="${cat.name}">
                    </div>
                    <div class="category-body">
                        <h3>${cat.name}</h3>
                        <p>${cat.description}</p>
                        <span class="arrow">View works &rarr;</span>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="empty">No categories yet â€” once your database is seeded you&rsquo;ll see them here.</p>
        </c:otherwise>
    </c:choose>
</section>

<c:if test="${not empty selectedCategory}">
    <section class="section-head">
        <span class="eyebrow">${selectedCategory.name}</span>
        <h2>Works in this category</h2>
    </section>
    <section class="art-grid">
        <c:forEach var="art" items="${artworks}">
            <a class="art-card" href="<%= ctx %>/art?id=${art.id}">
                <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                <div class="art-card-body">
                    <h3>${art.title}</h3>
                    <p>${art.artistName}</p>
                </div>
            </a>
        </c:forEach>
    </section>
</c:if>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
