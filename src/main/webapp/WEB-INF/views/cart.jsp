<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c"   uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Your Cart — Gallery Artisan's" scope="request"/>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<style>
    .cart-wrap {
        max-width: 1100px;
        margin: 3rem auto;
        padding: 0 1.5rem;
    }
    .cart-wrap h1 {
        font-family: var(--font-display);
        font-size: 2.5rem;
        font-weight: 500;
        margin-bottom: .5rem;
    }
    .cart-wrap > p { color: var(--muted); margin-bottom: 2rem; }

    .cart-grid {
        display: grid;
        grid-template-columns: 1fr 320px;
        gap: 2rem;
    }
    @media (max-width: 860px) {
        .cart-grid { grid-template-columns: 1fr; }
    }

    .cart-list {
        list-style: none;
        padding: 0;
        margin: 0;
        display: flex;
        flex-direction: column;
        gap: 1rem;
    }
    .cart-row {
        display: grid;
        grid-template-columns: 110px 1fr auto;
        gap: 1.2rem;
        align-items: center;
        padding: 1rem;
        background: var(--surface);
        border: 1px solid var(--line);
        border-radius: var(--radius);
    }
    .cart-row img {
        width: 110px;
        height: 110px;
        object-fit: cover;
        border-radius: var(--radius-sm);
    }
    .cart-row .title {
        font-family: var(--font-display);
        font-size: 1.2rem;
        margin-bottom: .15rem;
    }
    .cart-row .artist { color: var(--muted); font-size: .85rem; }
    .cart-row .price { color: var(--purple-soft); margin-top: .35rem; font-weight: 500; }

    .qty-controls {
        display: flex; align-items: center; gap: .5rem;
        margin-top: .6rem;
    }
    .qty-controls button {
        width: 28px; height: 28px;
        border-radius: 50%;
        border: 1px solid var(--line);
        background: var(--bg-alt);
        color: var(--ink);
        cursor: pointer;
        transition: background .2s ease;
    }
    .qty-controls button:hover { background: var(--purple-deep); }
    .qty-controls .qty { min-width: 24px; text-align: center; }

    .remove-btn {
        background: transparent; border: none; color: var(--muted);
        cursor: pointer; font-size: .85rem;
        transition: color .2s ease;
    }
    .remove-btn:hover { color: #e07070; }

    .cart-summary {
        position: sticky; top: 100px;
        align-self: start;
        padding: 1.5rem;
        background: var(--surface);
        border: 1px solid var(--line);
        border-radius: var(--radius);
    }
    .cart-summary h2 {
        font-family: var(--font-display);
        font-size: 1.4rem;
        margin-bottom: 1rem;
    }
    .summary-row {
        display: flex; justify-content: space-between;
        padding: .6rem 0;
        color: var(--muted);
    }
    .summary-row.total {
        border-top: 1px solid var(--line);
        margin-top: .5rem;
        padding-top: 1rem;
        color: var(--ink);
        font-size: 1.1rem;
        font-weight: 500;
    }
    .summary-row.total span:last-child { color: var(--purple-soft); }
    .checkout-btn {
        width: 100%;
        margin-top: 1rem;
        padding: .9rem;
        background: var(--purple);
        color: #fff;
        border: none;
        border-radius: 999px;
        font-weight: 600; letter-spacing: .1em; text-transform: uppercase;
        font-size: .82rem;
        cursor: pointer;
        transition: background .2s ease, box-shadow .2s ease, transform .15s ease;
    }
    .checkout-btn:hover {
        background: var(--purple-deep);
        box-shadow: 0 8px 28px rgba(122,59,255,.4);
    }
    .checkout-btn:active { transform: scale(.98); }

    .empty-state {
        text-align: center;
        padding: 4rem 2rem;
        background: var(--surface);
        border: 1px solid var(--line);
        border-radius: var(--radius);
    }
    .empty-state h2 {
        font-family: var(--font-display);
        font-size: 1.8rem;
        margin-bottom: .5rem;
    }
    .empty-state p { color: var(--muted); margin-bottom: 1.5rem; }
    .empty-state a {
        display: inline-block;
        padding: .8rem 1.6rem;
        background: var(--ink); color: var(--bg);
        border-radius: 999px;
        font-weight: 500;
    }
</style>

<section class="cart-wrap">
    <h1>Your Cart</h1>
    <p>Review your selections before checkout.</p>

    <c:choose>
        <c:when test="${empty cartItems}">
            <div class="empty-state">
                <h2>Your cart is empty</h2>
                <p>Browse the gallery and add a few pieces.</p>
                <a href="<%= ctx %>/gallery">Explore the gallery</a>
            </div>
        </c:when>
        <c:otherwise>
            <div class="cart-grid">
                <ul class="cart-list">
                    <c:forEach var="item" items="${cartItems}">
                        <li class="cart-row" data-item-id="${item.id}">
                            <img src="<%= ctx %>/${item.imageUrl}" alt="${item.title}">
                            <div>
                                <div class="title">${item.title}</div>
                                <div class="artist">${item.artistName}</div>
                                <div class="price">
                                    <fmt:formatNumber value="${item.price}" type="currency" currencySymbol="Rs."/>
                                </div>
                                <div class="qty-controls">
                                    <button type="button" onclick="changeQty(${item.id}, ${item.quantity - 1})">−</button>
                                    <span class="qty">${item.quantity}</span>
                                    <button type="button" onclick="changeQty(${item.id}, ${item.quantity + 1})">+</button>
                                </div>
                            </div>
                            <div style="text-align:right">
                                <div style="color:var(--ink);font-weight:500;margin-bottom:.5rem">
                                    <fmt:formatNumber value="${item.lineTotal}" type="currency" currencySymbol="Rs."/>
                                </div>
                                <button type="button" class="remove-btn" onclick="removeItem(${item.id})">Remove</button>
                            </div>
                        </li>
                    </c:forEach>
                </ul>

                <aside class="cart-summary">
                    <h2>Order Summary</h2>
                    <div class="summary-row">
                        <span>Subtotal</span>
                        <span><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="Rs."/></span>
                    </div>
                    <div class="summary-row">
                        <span>Shipping</span>
                        <span>Calculated at checkout</span>
                    </div>
                    <div class="summary-row total">
                        <span>Total</span>
                        <span><fmt:formatNumber value="${subtotal}" type="currency" currencySymbol="Rs."/></span>
                    </div>
                    <button type="button" class="checkout-btn" onclick="alert('Checkout coming soon!')">
                        Proceed to Checkout
                    </button>
                </aside>
            </div>
        </c:otherwise>
    </c:choose>
</section>

<script>
    var ctx = '<%= ctx %>';

    function postCart(params) {
        var body = new URLSearchParams();
        for (var k in params) body.append(k, params[k]);
        return fetch(ctx + '/cart', {
            method: 'POST',
            headers: {
                'X-Requested-With': 'XMLHttpRequest',
                'Content-Type': 'application/x-www-form-urlencoded'
            },
            body: body.toString()
        }).then(function(r) { return r.json(); });
    }

    function changeQty(itemId, newQty) {
        postCart({ action: 'update', itemId: itemId, quantity: newQty })
            .then(function(data) { if (data.ok) window.location.reload(); });
    }

    function removeItem(itemId) {
        postCart({ action: 'remove', itemId: itemId })
            .then(function(data) { if (data.ok) window.location.reload(); });
    }
</script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
