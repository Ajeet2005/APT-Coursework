package com.artgallery.servlet;

import com.artgallery.dao.ArtworkDAO;
import com.artgallery.dao.ArtistDAO;
import com.artgallery.dao.UserDAO;
import com.artgallery.model.Artwork;
import com.artgallery.model.User;
import com.artgallery.model.Artist;
import com.artgallery.model.Category;
import com.artgallery.model.Order;
import com.artgallery.model.OrderItem;
import com.artgallery.dao.CategoryDAO;
import com.artgallery.dao.OrderDAO;
import java.math.BigDecimal;
import java.util.Map;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.List;
import java.util.UUID;

/**
 * Handles GET /admin → render the admin dashboard.
 *
 * The AuthFilter already blocks non-admin users from reaching this URL,
 * but we do a double-check here for defence-in-depth.
 */
@WebServlet({ "/admin", "/admin/*" })
@MultipartConfig(
    maxFileSize = 5 * 1024 * 1024,
    maxRequestSize = 10 * 1024 * 1024
)
public class AdminServlet extends HttpServlet {

    private ArtworkDAO artworkDAO;
    private ArtistDAO artistDAO;
    private UserDAO userDAO;
    private CategoryDAO categoryDAO;
    private OrderDAO orderDAO;

    @Override
    public void init() {
        artworkDAO = new ArtworkDAO();
        artistDAO = new ArtistDAO();
        userDAO = new UserDAO();
        categoryDAO = new CategoryDAO();
        orderDAO = new OrderDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (user == null || !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String pathInfo = req.getPathInfo();
        if (pathInfo == null || pathInfo.equals("/")) {
            showDashboard(req, resp);
        } else if (pathInfo.startsWith("/artworks")) {
            handleArtworks(req, resp);
        } else if (pathInfo.startsWith("/artists")) {
            handleArtists(req, resp);
        } else if (pathInfo.startsWith("/users")) {
            handleUsers(req, resp);
        } else if (pathInfo.startsWith("/categories")) {
            handleCategories(req, resp);
        } else if (pathInfo.startsWith("/orders")) {
            handleOrders(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    private void showDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("totalArtworks", artworkDAO.countAll());
            req.setAttribute("totalArtists", artistDAO.countAll());
            req.setAttribute("totalUsers", userDAO.countAll());
            req.setAttribute("totalOrders", orderDAO.countAll());

            List<Artwork> recent = artworkDAO.findRecent(5);
            req.setAttribute("recentArtworks", recent);

            Map<String, Integer> catMap = artworkDAO.countByCategory();
            StringBuilder labels = new StringBuilder("[");
            StringBuilder data = new StringBuilder("[");
            for (Map.Entry<String, Integer> e : catMap.entrySet()) {
                labels.append("\"").append(e.getKey()).append("\",");
                data.append(e.getValue()).append(",");
            }
            if (labels.length() > 1)
                labels.deleteCharAt(labels.length() - 1);
            if (data.length() > 1)
                data.deleteCharAt(data.length() - 1);
            labels.append("]");
            data.append("]");
            req.setAttribute("categoryLabels", labels.toString());
            req.setAttribute("categoryData", data.toString());

        } catch (SQLException e) {
            e.printStackTrace();
        }

        try {
            Map<String, Integer> orderStats = orderDAO.getOrdersByMonth();
            StringBuilder labels = new StringBuilder("[");
            StringBuilder data = new StringBuilder("[");
            for (Map.Entry<String, Integer> e : orderStats.entrySet()) {
                labels.append("\"").append(e.getKey()).append("\",");
                data.append(e.getValue()).append(",");
            }
            if (labels.length() > 1) labels.deleteCharAt(labels.length() - 1);
            if (data.length() > 1) data.deleteCharAt(data.length() - 1);
            labels.append("]");
            data.append("]");
            req.setAttribute("monthLabels", labels.toString());
            req.setAttribute("ordersData", data.toString());
        } catch (SQLException e) {
            e.printStackTrace();
            req.setAttribute("monthLabels", "[\"Dec\",\"Jan\",\"Feb\",\"Mar\",\"Apr\",\"May\"]");
            req.setAttribute("ordersData", "[4,7,5,12,9,15]");
        }
        req.setAttribute("view", "dashboard");
        req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
    }

    private void handleArtworks(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action) || "edit".equals(action)) {
            try {
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("item", artworkDAO.findById(id));
                }
                req.setAttribute("categories", categoryDAO.findAll());
                req.setAttribute("artists", artistDAO.findAll());
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "artwork_form");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        } else {
            try {
                req.setAttribute("items", artworkDAO.findAll());
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "artworks");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        }
    }

    private void handleArtists(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action) || "edit".equals(action)) {
            try {
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("item", artistDAO.findById(id));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "artist_form");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        } else {
            try {
                req.setAttribute("items", artistDAO.findAll());
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "artists");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        }
    }

    private void handleUsers(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("items", userDAO.findAll());
            req.setAttribute("view", "users");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin");
        }
    }

    private void handleCategories(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("add".equals(action) || "edit".equals(action)) {
            try {
                if ("edit".equals(action)) {
                    int id = Integer.parseInt(req.getParameter("id"));
                    req.setAttribute("item", categoryDAO.findById(id));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "category_form");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        } else {
            try {
                req.setAttribute("items", categoryDAO.findAll());
            } catch (Exception e) {
                e.printStackTrace();
            }
            req.setAttribute("view", "categories");
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        }
    }

    private void handleOrders(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String action = req.getParameter("action");
            if ("view".equals(action)) {
                int id = Integer.parseInt(req.getParameter("id"));
                Order order = orderDAO.findById(id);
                if (order != null) {
                    order.setItems(orderDAO.findItemsByOrderId(id));
                    req.setAttribute("order", order);
                    req.setAttribute("view", "order_detail");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/orders");
                    return;
                }
            } else {
                req.setAttribute("items", orderDAO.findAll());
                req.setAttribute("view", "orders");
            }
            req.getRequestDispatcher("/WEB-INF/views/admin.jsp").forward(req, resp);
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        if (user == null || !user.isAdmin()) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String pathInfo = req.getPathInfo();
        try {
            String redirectPath = "/admin";
            if (pathInfo.startsWith("/artworks")) {
                saveArtwork(req);
                redirectPath = "/admin/artworks";
            } else if (pathInfo.startsWith("/artists")) {
                saveArtist(req);
                redirectPath = "/admin/artists";
            } else if (pathInfo.startsWith("/categories")) {
                saveCategory(req);
                redirectPath = "/admin/categories";
            } else if (pathInfo.startsWith("/delete")) {
                String type = req.getParameter("type");
                handleDelete(req);
                if ("artwork".equals(type))
                    redirectPath = "/admin/artworks";
                else if ("artist".equals(type))
                    redirectPath = "/admin/artists";
                else if ("user".equals(type))
                    redirectPath = "/admin/users";
                else if ("category".equals(type))
                    redirectPath = "/admin/categories";
            }
            resp.sendRedirect(req.getContextPath() + redirectPath);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin?error=1");
        }
    }

    private void saveArtwork(HttpServletRequest req) throws SQLException {
        String idStr = req.getParameter("id");
        Artwork a = new Artwork();
        if (idStr != null && !idStr.isEmpty())
            a.setId(Integer.parseInt(idStr));
        a.setTitle(req.getParameter("title"));
        a.setDescription(req.getParameter("description"));
        a.setImageUrl(req.getParameter("image_url"));
        a.setPrice(new BigDecimal(req.getParameter("price")));
        a.setCategoryId(Integer.parseInt(req.getParameter("category_id")));
        a.setArtistId(Integer.parseInt(req.getParameter("artist_id")));
        a.setFeatured(req.getParameter("featured") != null);

        if (a.getId() > 0)
            artworkDAO.update(a);
        else
            artworkDAO.insert(a);
    }

    private void saveArtist(HttpServletRequest req) throws SQLException, IOException, ServletException {
        String idStr = req.getParameter("id");
        Artist a = new Artist();
        if (idStr != null && !idStr.isEmpty())
            a.setId(Integer.parseInt(idStr));
        a.setName(req.getParameter("name"));
        a.setBio(req.getParameter("bio"));
        a.setCountry(req.getParameter("country"));

        String profileImagePath = handleImageUpload(req, "profile_image_file", "Artists");
        if (profileImagePath != null) {
            a.setProfileImage(profileImagePath);
        } else if (a.getId() > 0) {
            Artist existing = artistDAO.findById(a.getId());
            if (existing != null) a.setProfileImage(existing.getProfileImage());
        }

        if (a.getId() > 0)
            artistDAO.update(a);
        else
            artistDAO.insert(a);
    }

    private void saveCategory(HttpServletRequest req) throws SQLException {
        String idStr = req.getParameter("id");
        Category c = new Category();
        if (idStr != null && !idStr.isEmpty())
            c.setId(Integer.parseInt(idStr));
        c.setName(req.getParameter("name"));
        c.setDescription(req.getParameter("description"));
        c.setCoverImage(req.getParameter("cover_image"));

        if (c.getId() > 0)
            categoryDAO.update(c);
        else
            categoryDAO.insert(c);
    }

    private String handleImageUpload(HttpServletRequest req, String partName, String subfolder)
            throws IOException, ServletException {
        Part filePart = req.getPart(partName);
        if (filePart == null || filePart.getSize() == 0) return null;

        String originalName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
        String ext = "";
        int dot = originalName.lastIndexOf('.');
        if (dot >= 0) ext = originalName.substring(dot).toLowerCase();

        if (!ext.matches("\\.(jpg|jpeg|png|gif|webp)")) return null;

        String uniqueName = UUID.randomUUID().toString().substring(0, 8) + "_" + originalName;
        String relativePath = "assets/images/" + subfolder + "/" + uniqueName;

        String uploadDir = getServletContext().getRealPath("/assets/images/" + subfolder);
        File dir = new File(uploadDir);
        if (!dir.exists()) dir.mkdirs();

        filePart.write(uploadDir + File.separator + uniqueName);
        return relativePath;
    }

    private void handleDelete(HttpServletRequest req) throws SQLException {
        String type = req.getParameter("type");
        int id = Integer.parseInt(req.getParameter("id"));
        switch (type) {
            case "artwork":
                artworkDAO.delete(id);
                break;
            case "artist":
                artistDAO.delete(id);
                break;
            case "user":
                userDAO.delete(id);
                break;
            case "category":
                categoryDAO.delete(id);
                break;
        }
    }
}
