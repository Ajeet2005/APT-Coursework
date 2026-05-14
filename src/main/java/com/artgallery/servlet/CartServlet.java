package com.artgallery.servlet;

import com.artgallery.dao.CartDAO;
import com.artgallery.model.CartItem;
import com.artgallery.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.sql.SQLException;
import java.util.List;

/**
 * Handles the shopping cart.
 *
 * Routes
 * ──────
 * GET  /cart                   → cart page (cart.jsp)
 * POST /cart  action=add       → add an artwork (AJAX, returns JSON)
 * POST /cart  action=remove    → remove a cart row (returns JSON)
 * POST /cart  action=update    → set quantity for a cart row (returns JSON)
 * POST /cart  action=clear     → empty the cart (returns JSON)
 *
 * The cart is tied to the HttpSession's id (NOT the user). That way an
 * anonymous visitor can build a cart before signing in; on login we just
 * attach the existing session-id cart to their user id.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private final CartDAO cartDAO = new CartDAO();

    // ── GET — show the cart page ─────────────────────────────────────────────
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(true);
        String sid = session.getId();

        try {
            List<CartItem> items = cartDAO.findBySession(sid);
            BigDecimal subtotal = cartDAO.subtotal(sid);

            req.setAttribute("cartItems", items);
            req.setAttribute("subtotal",  subtotal);
            req.setAttribute("activePage", "cart");
            req.getRequestDispatcher("/WEB-INF/views/cart.jsp").forward(req, resp);
        } catch (SQLException e) {
            throw new ServletException("Failed to load cart", e);
        }
    }

    // ── POST — JSON API for AJAX add/remove/update/clear ─────────────────────
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = trim(req.getParameter("action"));
        HttpSession session = req.getSession(true);
        String sid = session.getId();

        User user = (User) session.getAttribute("loggedInUser");
        Integer userId = (user != null) ? user.getId() : null;

        // Require login for add — keep the cart tied to real accounts.
        // (If you'd rather allow anonymous carts, drop this check.)
        if ("add".equals(action) && user == null) {
            writeJson(resp, 401,
                "{\"ok\":false,\"requiresLogin\":true,\"loginUrl\":\""
                    + req.getContextPath() + "/login\"}");
            return;
        }

        try {
            switch (action) {
                case "add": {
                    int artworkId = parseInt(req.getParameter("artworkId"));
                    if (artworkId <= 0) { writeJson(resp, 400, "{\"ok\":false,\"error\":\"bad_artwork\"}"); return; }
                    cartDAO.addItem(sid, userId, artworkId);
                    break;
                }
                case "remove": {
                    int itemId = parseInt(req.getParameter("itemId"));
                    if (itemId > 0) cartDAO.removeItem(sid, itemId);
                    break;
                }
                case "update": {
                    int itemId = parseInt(req.getParameter("itemId"));
                    int qty    = parseInt(req.getParameter("quantity"));
                    if (itemId > 0) cartDAO.updateQuantity(sid, itemId, qty);
                    break;
                }
                case "clear":
                    cartDAO.clearSession(sid);
                    break;
                default:
                    writeJson(resp, 400, "{\"ok\":false,\"error\":\"unknown_action\"}");
                    return;
            }

            int count = cartDAO.countItems(sid);
            BigDecimal subtotal = cartDAO.subtotal(sid);
            writeJson(resp, 200,
                "{\"ok\":true,\"count\":" + count +
                ",\"subtotal\":\"" + subtotal.toPlainString() + "\"}");

        } catch (SQLException e) {
            e.printStackTrace();
            writeJson(resp, 500, "{\"ok\":false,\"error\":\"db_error\"}");
        }
    }

    // ── helpers ──────────────────────────────────────────────────────────────
    private static void writeJson(HttpServletResponse resp, int status, String body)
            throws IOException {
        resp.setStatus(status);
        resp.setContentType("application/json");
        resp.setCharacterEncoding("UTF-8");
        try (PrintWriter w = resp.getWriter()) {
            w.write(body);
        }
    }

    private static String trim(String s) { return s == null ? "" : s.trim(); }

    private static int parseInt(String s) {
        try { return Integer.parseInt(trim(s)); } catch (Exception e) { return 0; }
    }
}
