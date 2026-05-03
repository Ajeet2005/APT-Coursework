<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Your Cart &mdash; Gallery Artisan&rsquo;s" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<section class="page-hero">
    <span class="eyebrow">Checkout</span>
    <h1>Your Cart</h1>
    <p>Review your selection before checkout. All prices in Nepali Rupees.</p>
</section>

<section class="cart-page">
    <c:choose>
        <c:when test="${not empty cartItems}">
            <div class="cart-list">
                <c:forEach var="item" items="${cartItems}">
                    <article class="cart-row">
                        <a class="cart-thumb" href="<%= ctx %>/art?id=${item.artworkId}">
                            <img src="<%= ctx %>/${item.imageUrl}" alt="${item.title}">
                        </a>

                        <div class="cart-info">
                            <h3>
                                <a href="<%= ctx %>/art?id=${item.artworkId}">${item.title}</a>
                            </h3>
                            <p class="cart-artist">${item.artistName}</p>
                            <p class="cart-unit-price">
                                Rs.&nbsp;<fmt:formatNumber value="${item.price}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                                <span class="cart-unit-label">each</span>
                            </p>
                        </div>

                        <form class="cart-qty-form" method="post" action="<%= ctx %>/cart">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="artworkId" value="${item.artworkId}">
                            <label>
                                Qty
                                <input type="number" name="quantity" min="1" max="99"
                                       value="${item.quantity}"
                                       onchange="this.form.submit()">
                            </label>
                        </form>

                        <p class="cart-subtotal">
                            Rs.&nbsp;<fmt:formatNumber value="${item.subtotal}" type="number" maxFractionDigits="0" groupingUsed="true"/>
                        </p>

                        <form method="post" action="<%= ctx %>/cart" class="cart-remove-form">
                            <input type="hidden" name="action" value="remove">
                            <input type="hidden" name="artworkId" value="${item.artworkId}">
                            <button type="submit" class="cart-remove" title="Remove">&times;</button>
                        </form>
                    </article>
                </c:forEach>
            </div>

            <aside class="cart-summary">
                <h2>Order Summary</h2>

                <div class="cart-summary-row">
                    <span>Subtotal</span>
                    <span>Rs.&nbsp;<fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0" groupingUsed="true"/></span>
                </div>
                <div class="cart-summary-row muted">
                    <span>Shipping</span>
                    <c:choose>
                        <c:when test="${cartTotal >= 100000}">
                            <span class="cart-shipping-free">FREE</span>
                        </c:when>
                        <c:otherwise>
                            <span>Calculated at checkout</span>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="cart-summary-divider"></div>
                <div class="cart-summary-row total">
                    <span>Total</span>
                    <span>Rs.&nbsp;<fmt:formatNumber value="${cartTotal}" type="number" maxFractionDigits="0" groupingUsed="true"/></span>
                </div>

                <c:if test="${cartTotal < 100000}">
                    <p class="cart-shipping-hint">
                        Add Rs. <fmt:formatNumber value="${100000 - cartTotal}" type="number" maxFractionDigits="0" groupingUsed="true"/> more for free shipping.
                    </p>
                </c:if>

                <button type="button" class="btn btn-primary cart-checkout"
                        onclick="alert('Checkout flow not implemented yet — this is a demo.')">
                    Proceed to Checkout
                </button>

                <a class="btn btn-ghost cart-continue" href="<%= ctx %>/categories">Continue Shopping</a>

                <form method="post" action="<%= ctx %>/cart" class="cart-clear-form"
                      onsubmit="return confirm('Empty your cart?');">
                    <input type="hidden" name="action" value="clear">
                    <button type="submit" class="link-button">Clear cart</button>
                </form>
            </aside>
        </c:when>

        <c:otherwise>
            <div class="cart-empty">
                <span class="cart-empty-icon" aria-hidden="true">&#128722;</span>
                <h2>Your cart is empty</h2>
                <p>Browse the collection and add a piece you love.</p>
                <a class="btn btn-primary" href="<%= ctx %>/categories">Browse Categories</a>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
