<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Art &mdash; Gallery Artisan&rsquo;s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="page-hero">
    <span class="eyebrow">Collection</span>
    <h1>Art</h1>
    <p>Every piece currently on our walls &mdash; colour, texture, and story.</p>
</section>

<!-- ========== SEARCH + FILTER BAR ========== -->
<form class="search-bar" method="get" action="<%= ctx %>/art" role="search">
    <div class="search-bar-inner">
        <div class="search-input-wrap">
            <svg class="search-icon" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="7"/>
                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <input type="search"
                   name="q"
                   value="${q}"
                   placeholder="Search by title, artist, or category…"
                   aria-label="Search artworks"
                   autocomplete="off">
            <c:if test="${not empty q}">
                <button type="button" class="search-clear-inline"
                        onclick="this.previousElementSibling.value=''; this.form.submit();"
                        aria-label="Clear search">&times;</button>
            </c:if>
        </div>

        <div class="filter-select-wrap">
            <select name="categoryId" class="filter-select" aria-label="Filter by category"
                    onchange="this.form.submit()">
                <option value="">All categories</option>
                <c:forEach var="cat" items="${categories}">
                    <option value="${cat.id}"
                            <c:if test="${selectedCategoryId == cat.id}">selected</c:if>>
                        ${cat.name}
                    </option>
                </c:forEach>
            </select>
            <svg class="filter-chevron" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="6 9 12 15 18 9"/>
            </svg>
        </div>

        <div class="filter-select-wrap">
            <select name="sort" class="filter-select" aria-label="Sort by"
                    onchange="this.form.submit()">
                <option value=""           <c:if test="${sort == ''}">selected</c:if>>Featured</option>
                <option value="newest"     <c:if test="${sort == 'newest'}">selected</c:if>>Newest</option>
                <option value="price_asc"  <c:if test="${sort == 'price_asc'}">selected</c:if>>Price ↑ low to high</option>
                <option value="price_desc" <c:if test="${sort == 'price_desc'}">selected</c:if>>Price ↓ high to low</option>
            </select>
            <svg class="filter-chevron" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                <polyline points="6 9 12 15 18 9"/>
            </svg>
        </div>

        <button type="submit" class="btn-search">
            <svg class="btn-search-icon" aria-hidden="true" xmlns="http://www.w3.org/2000/svg"
                 viewBox="0 0 24 24" fill="none" stroke="currentColor"
                 stroke-width="2.2" stroke-linecap="round" stroke-linejoin="round">
                <circle cx="11" cy="11" r="7"/>
                <line x1="21" y1="21" x2="16.65" y2="16.65"/>
            </svg>
            <span>Search</span>
        </button>
    </div>

    <!-- search hints -->
    <p class="search-hint">
        Try:
        <a href="<%= ctx %>/art?q=van+gogh">Van Gogh</a>
        <a href="<%= ctx %>/art?q=botanical">botanical</a>
        <a href="<%= ctx %>/art?q=portrait">portraits</a>
        <a href="<%= ctx %>/art?q=still+life">still life</a>
    </p>
</form>

<!-- ========== ACTIVE FILTERS / RESULT COUNT ========== -->
<div class="search-summary">
    <span class="result-count">
        <strong><c:out value="${not empty artworks ? artworks.size() : 0}"/></strong>
        result<c:if test="${empty artworks or artworks.size() != 1}">s</c:if>
    </span>

    <c:if test="${not empty q or not empty selectedCategoryId or not empty sort}">
        <span class="active-filters">
            <c:if test="${not empty q}">
                <c:url var="removeQ" value="/art">
                    <c:if test="${not empty selectedCategoryId}"><c:param name="categoryId" value="${selectedCategoryId}"/></c:if>
                    <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                </c:url>
                <a class="filter-pill" href="${removeQ}" title="Remove search">
                    <span class="filter-pill-label">Search:</span>
                    <span class="filter-pill-value">${q}</span>
                    <span class="filter-pill-x">&times;</span>
                </a>
            </c:if>

            <c:if test="${not empty selectedCategoryId}">
                <c:url var="removeCat" value="/art">
                    <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
                    <c:if test="${not empty sort}"><c:param name="sort" value="${sort}"/></c:if>
                </c:url>
                <c:forEach var="cat" items="${categories}">
                    <c:if test="${cat.id == selectedCategoryId}">
                        <a class="filter-pill" href="${removeCat}" title="Remove category filter">
                            <span class="filter-pill-label">Category:</span>
                            <span class="filter-pill-value">${cat.name}</span>
                            <span class="filter-pill-x">&times;</span>
                        </a>
                    </c:if>
                </c:forEach>
            </c:if>

            <c:if test="${not empty sort}">
                <c:url var="removeSort" value="/art">
                    <c:if test="${not empty q}"><c:param name="q" value="${q}"/></c:if>
                    <c:if test="${not empty selectedCategoryId}"><c:param name="categoryId" value="${selectedCategoryId}"/></c:if>
                </c:url>
                <a class="filter-pill" href="${removeSort}" title="Remove sort">
                    <span class="filter-pill-label">Sort:</span>
                    <span class="filter-pill-value">
                        <c:choose>
                            <c:when test="${sort == 'newest'}">Newest</c:when>
                            <c:when test="${sort == 'price_asc'}">Price ↑</c:when>
                            <c:when test="${sort == 'price_desc'}">Price ↓</c:when>
                            <c:otherwise>${sort}</c:otherwise>
                        </c:choose>
                    </span>
                    <span class="filter-pill-x">&times;</span>
                </a>
            </c:if>

            <a class="filter-clear-all" href="<%= ctx %>/art">Clear all</a>
        </span>
    </c:if>
</div>

<!-- ========== RESULTS GRID ========== -->
<section class="art-grid">
    <c:choose>
        <c:when test="${not empty artworks}">
            <c:forEach var="art" items="${artworks}">
                <a class="art-card" href="<%= ctx %>/art?id=${art.id}">
                    <img src="<%= ctx %>/${art.imageUrl}" alt="${art.title}">
                    <div class="art-card-body">
                        <h3>${art.title}</h3>
                        <p class="muted">${art.artistName} &middot; ${art.categoryName}</p>
                        <c:if test="${art.price != null}">
                            <p class="price">Rs.&nbsp;<fmt:formatNumber value="${art.price}" type="number" maxFractionDigits="0" groupingUsed="true"/></p>
                        </c:if>
                    </div>
                </a>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="empty">
                <c:choose>
                    <c:when test="${not empty q or not empty selectedCategoryId}">
                        No artworks matched your search. Try clearing filters or a different keyword.
                    </c:when>
                    <c:otherwise>
                        Once the database is seeded, artworks will appear here.
                    </c:otherwise>
                </c:choose>
            </p>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
