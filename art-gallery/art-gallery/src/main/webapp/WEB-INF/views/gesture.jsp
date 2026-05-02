<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Gesture Shop &mdash; Gallery Artisan&rsquo;s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="page-hero botanical-hero">
    <span class="eyebrow">Shop &middot; Figure &amp; Movement</span>
    <h1>Gesture Collection</h1>
    <p>
        <c:choose>
            <c:when test="${not empty category and not empty category.description}">
                ${category.description}
            </c:when>
            <c:otherwise>
                Quick figure studies and life-drawing pieces &mdash; capturing movement, posture and expression in a single breath.
            </c:otherwise>
        </c:choose>
    </p>
    <div class="botanical-trust">
        <span>&#10004; Free shipping across Nepal over Rs. 1,00,000</span>
        <span>&#10004; 30-day return guarantee</span>
        <span>&#10004; Certificate of authenticity</span>
    </div>
</section>

<section class="shop-toolbar">
    <div class="shop-toolbar-left">
        <strong><c:out value="${not empty artworks ? artworks.size() : 0}"/></strong> products
    </div>
    <div class="shop-toolbar-right">
        <label>Sort by
            <select onchange="return false" disabled>
                <option>Featured</option>
                <option>Price &mdash; low to high</option>
                <option>Price &mdash; high to low</option>
                <option>Newest</option>
            </select>
        </label>
    </div>
</section>

<section class="product-grid">
    <c:choose>
        <c:when test="${not empty artworks}">
            <c:forEach var="art" items="${artworks}" varStatus="loop">
                <article class="product-card">
                    <div class="product-image">
                        <c:if test="${art.featured}">
                            <span class="badge badge-featured">Featured</span>
                        </c:if>
                        <c:if test="${loop.first}">
                            <span class="badge badge-bestseller">Bestseller</span>
                        </c:if>
                        <a href="<%= ctx %>/art?id=${art.id}" class="product-image-link">
                            <img src="${art.imageUrl}" alt="${art.title}" loading="lazy">
                        </a>
                        <button type="button" class="btn-wishlist" aria-label="Save for later" onclick="toggleWishlist(this)">
                            <span class="heart">&#9825;</span>
                        </button>
                    </div>

                    <div class="product-body">
                        <p class="product-artist">${art.artistName}</p>
                        <h3 class="product-title">
                            <a href="<%= ctx %>/art?id=${art.id}">${art.title}</a>
                        </h3>
                        <div class="product-rating" aria-label="Rated 4.8 out of 5">
                            <span class="stars">&#9733;&#9733;&#9733;&#9733;&#9733;</span>
                            <span class="rating-count">(4.8 &middot; 124)</span>
                        </div>
                        <c:if test="${not empty art.description}">
                            <p class="product-blurb">${art.description}</p>
                        </c:if>

                        <div class="product-price-row">
                            <c:choose>
                                <c:when test="${not empty art.price}">
                                    <span class="price">
                                        Rs.&nbsp;<fmt:formatNumber value="${art.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                                    </span>
                                </c:when>
                                <c:otherwise>
                                    <span class="price">Price on request</span>
                                </c:otherwise>
                            </c:choose>
                            <span class="stock in-stock">In stock</span>
                        </div>

                        <div class="product-actions">
                            <button type="button" class="btn btn-primary btn-cart"
                                    data-id="${art.id}" data-title="${art.title}"
                                    onclick="addToCart(this)">
                                Add to Cart
                            </button>
                            <a class="btn btn-ghost btn-view" href="<%= ctx %>/art?id=${art.id}">Quick view</a>
                        </div>
                    </div>
                </article>
            </c:forEach>
        </c:when>
        <c:otherwise>
            <p class="empty">No products yet &mdash; once your database has artworks in the Gesture category they&rsquo;ll appear here.</p>
        </c:otherwise>
    </c:choose>
</section>

<aside id="cart-toast" class="cart-toast" role="status" aria-live="polite"></aside>

<script>
    (function () {
        var cartCount = 0;
        var toast = document.getElementById('cart-toast');

        window.addToCart = function (btn) {
            cartCount += 1;
            var title = btn.getAttribute('data-title') || 'Item';
            btn.classList.add('added');
            btn.textContent = 'Added ✓';
            showToast('"' + title + '" added to cart — ' + cartCount + ' item' + (cartCount === 1 ? '' : 's'));
            setTimeout(function () {
                btn.classList.remove('added');
                btn.textContent = 'Add to Cart';
            }, 1800);
        };

        window.toggleWishlist = function (btn) {
            btn.classList.toggle('saved');
            var heart = btn.querySelector('.heart');
            if (btn.classList.contains('saved')) {
                heart.innerHTML = '&#9829;';
                showToast('Saved to wishlist');
            } else {
                heart.innerHTML = '&#9825;';
            }
        };

        function showToast(msg) {
            if (!toast) return;
            toast.textContent = msg;
            toast.classList.add('show');
            clearTimeout(showToast._t);
            showToast._t = setTimeout(function () {
                toast.classList.remove('show');
            }, 2200);
        }
    })();
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
