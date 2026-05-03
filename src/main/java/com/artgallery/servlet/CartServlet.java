package com.artgallery.servlet;

import com.artgallery.dao.CartDAO;
import com.artgallery.model.CartItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.util.List;

/**
 * Single servlet for all cart operations.
 *
 * GET  /cart                           → render cart.jsp
 * POST /cart  action=add     artworkId → add to cart, return JSON {ok, count, message}
 * POST /cart  action=remove  artworkId → remove from cart, redirect back to /cart
 * POST /cart  action=update  artworkId qty → set quantity, redirect back to /cart
 * POST /cart  action=clear              → empty cart, redirect back to /cart
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int cartId = cartIdFor(req);
        List<CartItem> items = cartDAO.getItems(cartId);
        BigDecimal total = cartDAO.getCartTotal(cartId);

        req.setAttribute("cartItems", items);
        req.setAttribute("cartTotal", total);
        req.setAttribute("activePage", "cart");

        req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");
        if (action == null) action = "";

        int cartId = cartIdFor(req);

        switch (action) {
            case "add" -> {
                int artworkId = parseInt(req.getParameter("artworkId"));
                if (artworkId > 0) cartDAO.addItem(cartId, artworkId);

                // AJAX call from the product pages expects JSON back
                if (isAjax(req)) {
                    int count = cartDAO.getItemCount(cartId);
                    writeJson(resp, "{\"ok\":true,\"count\":" + count + "}");
                    return;
                }
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            case "remove" -> {
                int artworkId = parseInt(req.getParameter("artworkId"));
                if (artworkId > 0) cartDAO.removeItem(cartId, artworkId);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            case "update" -> {
                int artworkId = parseInt(req.getParameter("artworkId"));
                int qty = parseInt(req.getParameter("quantity"));
                if (artworkId > 0) cartDAO.updateQuantity(cartId, artworkId, qty);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            case "clear" -> {
                cartDAO.clearCart(cartId);
                resp.sendRedirect(req.getContextPath() + "/cart");
            }
            default -> resp.sendRedirect(req.getContextPath() + "/cart");
        }
    }

    /** Return the cart id for the current browser session, creating one if needed. */
    private int cartIdFor(HttpServletRequest req) {
        HttpSession session = req.getSession(true);
        return cartDAO.getOrCreateCart(session.getId());
    }

    private static int parseInt(String s) {
        if (s == null) return 0;
        try { return Integer.parseInt(s); } catch (NumberFormatException e) { return 0; }
    }

    private static boolean isAjax(HttpServletRequest req) {
        String h = req.getHeader("X-Requested-With");
        return h != null && h.equalsIgnoreCase("XMLHttpRequest");
    }

    private static void writeJson(HttpServletResponse resp, String json) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        try (PrintWriter w = resp.getWriter()) {
            w.write(json);
        }
    }
}
