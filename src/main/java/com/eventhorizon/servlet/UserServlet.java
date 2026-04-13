package com.eventhorizon.servlet;

import com.eventhorizon.model.User;
import com.eventhorizon.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

public class UserServlet extends HttpServlet {

    private final UserService userService = new UserService();

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
            case "requestAdmin":
                handleRequestAdmin(req, resp);
                break;
            case "approveAdminRequest":
                handleApproveAdminRequest(req, resp);
                break;
            case "rejectAdminRequest":
                handleRejectAdminRequest(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("logout".equals(action)) {
            handleLogout(req, resp);
            return;
        }

        if ("list".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            req.setAttribute("users", userService.getAllUsers());
            req.getRequestDispatcher("/admin/users.jsp").forward(req, resp);
            return;
        }

        if ("addAdminForm".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            req.getRequestDispatcher("/admin/addAdmin.jsp").forward(req, resp);
            return;
        }

        if ("listAdminRequests".equals(action)) {
            HttpSession session = req.getSession(false);
            if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }

            req.setAttribute("adminRequests", userService.getPendingAdminRequests());
            req.getRequestDispatcher("/admin/adminRequests.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        if (name != null) name = name.trim();
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();
        if (phone != null) phone = phone.trim();

        boolean created = userService.registerCustomer(name, email, password, phone);

        if (created) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=registered");
        } else {
            resp.sendRedirect(req.getContextPath() + "/register.jsp?error=emailExists");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        String email = req.getParameter("email");
        String password = req.getParameter("password");

        if (email != null) email = email.trim();
        if (password != null) password = password.trim();

        User user = userService.login(email, password);

        if (user != null) {
            HttpSession session = req.getSession(true);

            session.setAttribute("userId", user.getUserId());
            session.setAttribute("userName", user.getName());
            session.setAttribute("userEmail", user.getEmail());
            session.setAttribute("userPhone", user.getPhone());
            session.setAttribute("role", user.getRole());

            session.setMaxInactiveInterval(30 * 60);

            if ("ADMIN".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/event?action=list");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/login.jsp?error=invalid");
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }

        resp.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        resp.setHeader("Pragma", "no-cache");
        resp.setDateHeader("Expires", 0);

        resp.sendRedirect(req.getContextPath() + "/login.jsp?msg=logout");
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String userId = (String) session.getAttribute("userId");
        String name = req.getParameter("name");
        String phone = req.getParameter("phone");
        String password = req.getParameter("password");

        if (name != null) name = name.trim();
        if (phone != null) phone = phone.trim();
        if (password != null) password = password.trim();

        boolean success = userService.updateUser(userId, name, phone, password);

        if (success) {
            session.setAttribute("userName", name);
            session.setAttribute("userPhone", phone);
            resp.sendRedirect(req.getContextPath() + "/profile.jsp?msg=updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/profile.jsp?error=updateFailed");
        }
    }

    private void handleDelete(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String userId = req.getParameter("userId");
        userService.deleteUser(userId);

        resp.sendRedirect(req.getContextPath() + "/user?action=list&msg=deleted");
    }

    private void handleRequestAdmin(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String requesterAdminId = (String) session.getAttribute("userId");
        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String phone = req.getParameter("phone");

        if (name != null) name = name.trim();
        if (email != null) email = email.trim();
        if (password != null) password = password.trim();
        if (phone != null) phone = phone.trim();

        boolean created = userService.submitAdminRequest(
                requesterAdminId, name, email, password, phone
        );

        if (created) {
            resp.sendRedirect(req.getContextPath() + "/admin/addAdmin.jsp?msg=requestSubmitted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/addAdmin.jsp?error=requestFailed");
        }
    }

    private void handleApproveAdminRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String approverAdminId = (String) session.getAttribute("userId");
        String requestId = req.getParameter("requestId");

        boolean approved = userService.approveAdminRequest(requestId, approverAdminId);

        if (approved) {
            resp.sendRedirect(req.getContextPath() + "/user?action=listAdminRequests&msg=approved");
        } else {
            resp.sendRedirect(req.getContextPath() + "/user?action=listAdminRequests&error=approveFailed");
        }
    }

    private void handleRejectAdminRequest(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        HttpSession session = req.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("role"))) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        String approverAdminId = (String) session.getAttribute("userId");
        String requestId = req.getParameter("requestId");

        boolean rejected = userService.rejectAdminRequest(requestId, approverAdminId);

        if (rejected) {
            resp.sendRedirect(req.getContextPath() + "/user?action=listAdminRequests&msg=rejected");
        } else {
            resp.sendRedirect(req.getContextPath() + "/user?action=listAdminRequests&error=rejectFailed");
        }
    }
}