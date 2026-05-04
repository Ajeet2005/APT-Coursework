/**
 * cart-guard.js
 * ─────────────────────────────────────────────────────────────────
 * Intercepts any "Add to Cart" button click on the front-end.
 * If the user is NOT logged in, it redirects them to /login
 * instead of proceeding, so the cart action is gated behind auth.
 *
 * HOW TO USE
 * ──────────
 * 1. Include this script in your JSP pages that have an "Add to Cart"
 *    button — typically art-detail.jsp, botanical.jsp, gesture.jsp.
 *
 *    <script src="${pageContext.request.contextPath}/assets/js/cart-guard.js"></script>
 *
 * 2. Make sure every "Add to Cart" button / link has the class
 *    "add-to-cart-btn"  (add it alongside your existing classes).
 *
 * 3. Set the data attribute on <body> from a JSTL expression:
 *
 *    <body data-logged-in="${not empty sessionScope.loggedInUser}"
 *          data-login-url="${pageContext.request.contextPath}/login">
 *
 * That's it. The server-side AuthFilter is the authoritative guard;
 * this script is purely a UX improvement (no page reload for guests).
 */

(function () {
    'use strict';

    document.addEventListener('DOMContentLoaded', function () {

        const body       = document.body;
        const isLoggedIn = body.dataset.loggedIn === 'true';
        const loginUrl   = body.dataset.loginUrl  || '/login';

        if (isLoggedIn) return;   // logged in → nothing to intercept

        // Find all add-to-cart triggers
        const buttons = document.querySelectorAll(
            '.add-to-cart-btn, [data-action="addToCart"], form.add-to-cart-form'
        );

        buttons.forEach(function (el) {

            const isForm = el.tagName === 'FORM';

            el.addEventListener(isForm ? 'submit' : 'click', function (e) {
                e.preventDefault();
                e.stopImmediatePropagation();

                // Show a brief inline toast before redirecting
                showToast('Please sign in to add items to your cart.', loginUrl);
            });
        });
    });

    function showToast(message, loginUrl) {
        // Remove any existing toast
        const old = document.getElementById('cart-guard-toast');
        if (old) old.remove();

        const toast = document.createElement('div');
        toast.id = 'cart-guard-toast';
        toast.innerHTML = `
            <span>${message}</span>
            <a href="${loginUrl}" style="
                color:#b89a6f; font-weight:500;
                margin-left:12px; text-decoration:none;
                border-bottom:1px solid rgba(184,154,111,0.4);
            ">Sign In →</a>
        `;

        Object.assign(toast.style, {
            position:        'fixed',
            bottom:          '28px',
            left:            '50%',
            transform:       'translateX(-50%) translateY(10px)',
            background:      '#1a1628',
            border:          '1px solid rgba(184,154,111,0.3)',
            borderRadius:    '10px',
            padding:         '14px 22px',
            color:           '#e8e0d5',
            fontSize:        '0.875rem',
            display:         'flex',
            alignItems:      'center',
            boxShadow:       '0 8px 32px rgba(0,0,0,0.5)',
            zIndex:          '9999',
            opacity:         '0',
            transition:      'opacity 0.3s ease, transform 0.3s ease',
            whiteSpace:      'nowrap',
        });

        document.body.appendChild(toast);

        // Animate in
        requestAnimationFrame(() => {
            toast.style.opacity   = '1';
            toast.style.transform = 'translateX(-50%) translateY(0)';
        });

        // Auto-redirect after 2.5 s
        setTimeout(() => {
            window.location.href = loginUrl;
        }, 2500);
    }

}());
