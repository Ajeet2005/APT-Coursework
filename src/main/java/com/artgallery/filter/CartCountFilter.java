package com.artgallery.filter;

import com.artgallery.dao.CartDAO;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * Runs before every request — looks up how many items are in the user's cart
 * and exposes it as a request attribute so header.jsp can show a badge.
 */
@WebFilter("/*")
public class CartCountFilter implements Filter {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        if (request instanceof HttpServletRequest req) {
            // Skip static asset requests — no need to hit DB for css/js/images
            String uri = req.getRequestURI();
            boolean isAsset = uri.contains("/assets/") || uri.endsWith(".css")
                          || uri.endsWith(".js")  || uri.endsWith(".png")
                          || uri.endsWith(".jpg") || uri.endsWith(".jpeg")
                          || uri.endsWith(".webp") || uri.endsWith(".ico");

            if (!isAsset) {
                try {
                    HttpSession session = req.getSession(true);
                    int cartId = cartDAO.getOrCreateCart(session.getId());
                    int count = cartDAO.getItemCount(cartId);
                    req.setAttribute("cartItemCount", count);
                } catch (Exception ignored) {
                    // never break the request because we couldn't get cart count
                }
            }
        }

        chain.doFilter(request, response);
    }
}
