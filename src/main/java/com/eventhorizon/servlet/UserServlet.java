package com.eventhorizon.servlet;

import com.eventhorizon.model.User;
import com.eventhorizon.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import java.io.IOException;

/**
 * UserServlet - Handles all user-related HTTP requests.
 *
 * URL Mappings (action parameter):
 *   POST /user?action=register  -> Register new customer
 *   POST /user?action=login     -> Login
 *   POST /user?action=logout    -> Logout
 *   POST /user?action=update    -> Update profile
 *   POST /user?action=delete    -> Delete user (Admin only)
 *   GET  /user?action=list      -> List all users (Admin only)
 */
public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();

    // ==================== POST - Write Operations ====================
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        switch (action == null ? "" : action) {
            case "register":
                handleRegister(req, resp);
                break;
            case "login":
                handleLogin(req, resp);
                break;
            case "logout":
                handleLogout(req, resp);
                break;
            case "update":
                handleUpdate(req, resp);
                break;
            case "delete":
                handleDelete(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    // ==================== GET - Read Operations ====================
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("list".equals(action)) {
            // Admin: list all users
            HttpSession session = req.getSession(false);
            if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendRedirect("login.jsp");
                return;
            }
            req.setAttribute("users", userService.getAllUsers());
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
        } else {
            resp.sendRedirect("index.jsp");
        }
    }

    // -------------------- Register --------------------
    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        String name     = req.getParameter("name");
        String email    = req.getParameter("email");
        String password = req.getParameter("password");
        String phone    = req.getParameter("phone");

        boolean success = userService.registerCustomer(name, email, password, phone);

        if (success) {
            resp.sendRedirect("login.jsp?msg=registered");
        } else {
            resp.sendRedirect("register.jsp?error=emailExists");
        }
    }

    // -------------------- Login --------------------
    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, ServletException {
        String email    = req.getParameter("email");
        String password = req.getParameter("password");

        User user = userService.login(email, password);

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("userId",   user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail",user.getEmail());
            session.setAttribute("role",     user.getRole());

            // Redirect based on role (POLYMORPHISM in action)
            if ("ADMIN".equals(user.getRole())) {
                resp.sendRedirect("admin/dashboard.jsp");
            } else {
                resp.sendRedirect("events.jsp");
            }
        } else {
            resp.sendRedirect("login.jsp?error=invalid");
        }
    }

    // -------------------- Logout --------------------
    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) session.invalidate();
        resp.sendRedirect("index.jsp");
    }

    // -------------------- Update Profile --------------------
    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null) { resp.sendRedirect("login.jsp"); return; }

        String userId   = (String) session.getAttribute("userId");
        String name     = req.getParameter("name");
        String phone    = req.getParameter("phone");
        String password = req.getParameter("password");

        boolean success = userService.updateUser(userId, name, phone, password);

        if (success) {
            session.setAttribute("userName", name);   // Update session name
            resp.sendRedirect("profile.jsp?msg=updated");
        } else {
            resp.sendRedirect("profile.jsp?error=updateFailed");
        }
    }

    // -------------------- Delete User (Admin) --------------------
    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect("login.jsp");
            return;
        }

        String userId = req.getParameter("userId");
        userService.deleteUser(userId);
        resp.sendRedirect("user?action=list&msg=deleted");
    }
}
