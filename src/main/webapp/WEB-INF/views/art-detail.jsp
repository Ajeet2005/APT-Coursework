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
                    <p class="price" style="font-size:1.6rem;margin:1rem 0;">Rs.&nbsp;<fmt:formatNumber value="${artwork.price}" type="number" maxFractionDigits="0" groupingUsed="true"/></p>
                </c:if>
                <div style="display:flex;gap:1rem;flex-wrap:wrap;margin-top:1.5rem;">
                    <button type="button" class="btn btn-primary btn-cart" onclick="addToCart(${artwork.id}, this)">
                        <svg class="btn-cart-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.6" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M2 3h2.5l1 2"/><path d="M5.5 5h16l-2.5 9H8z"/>
                            <path d="M8.5 8.5h10M9 11.5h8.5"/><path d="M8 14l-1.5 3h13"/>
                            <circle cx="9.5" cy="20" r="1.5"/><circle cx="18" cy="20" r="1.5"/>
                        </svg>
                        <span>Add to Cart</span>
                    </button>
                    <a class="btn btn-ghost" href="<%= ctx %>/gallery">Back to Gallery</a>
                </div>
            </div>
        </section>
    </c:when>
    <c:otherwise>
        <section class="page-hero"><h1>Artwork not found</h1></section>
    </c:otherwise>
</c:choose>

<script>
function addToCart(artworkId, btn) {
    btn.classList.add('loading');
    var body = new URLSearchParams();
    body.append('action', 'add');
    body.append('artworkId', artworkId);
    body.append('quantity', '1');
    fetch('<%= ctx %>/cart', {
        method: 'POST',
        headers: { 'X-Requested-With': 'XMLHttpRequest', 'Content-Type': 'application/x-www-form-urlencoded' },
        body: body.toString()
    })
    .then(function(r) { return r.json(); })
    .then(function(data) {
        btn.classList.remove('loading');
        if (data.ok) {
            btn.classList.add('added');
            btn.innerHTML = '<svg class="btn-cart-icon" viewBox="0 0 20 20" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M5 10l4 4 6-8"/></svg><span>Added!</span>';
            if (window.showToast) window.showToast('Added to your cart', 'success');
            var badge = document.querySelector('[data-cart-badge]');
            if (badge) {
                var count = parseInt(badge.textContent || '0') + 1;
                badge.textContent = count;
                badge.classList.add('has-items');
            }
        } else {
            if (window.showToast) window.showToast(data.message || 'Could not add to cart', 'error');
        }
    })
    .catch(function() {
        btn.classList.remove('loading');
        if (window.showToast) window.showToast('Something went wrong', 'error');
    });
}
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
