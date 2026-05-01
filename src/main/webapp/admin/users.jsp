<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.User" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    Object roleObj = session.getAttribute("role");
    if (roleObj == null || !"ADMIN".equals(roleObj.toString())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");

    if (users == null) {
        UserService userService = new UserService();
        users = userService.getAllUsers();
    }

    String currentAdminId = (String) session.getAttribute("userId");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - EventHorizon Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-primary: #0b1020;
            --bg-secondary: #121a2f;
            --bg-card: rgba(18, 26, 47, 0.92);
            --bg-card-hover: rgba(24, 34, 60, 0.98);
            --border: rgba(255, 255, 255, 0.08);
            --border-strong: rgba(255, 255, 255, 0.15);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --accent: #4f46e5;
            --accent-light: #6366f1;
            --success: #10b981;
            --success-soft: rgba(16, 185, 129, 0.18);
            --danger: #ef4444;
            --danger-soft: rgba(239, 68, 68, 0.16);
            --warning-soft: rgba(245, 158, 11, 0.16);
            --warning-text: #fde68a;
            --shadow: 0 20px 45px rgba(0, 0, 0, 0.35);
            --radius-lg: 24px;
            --radius-md: 16px;
            --radius-sm: 12px;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-primary);
            background:
                radial-gradient(circle at top left, rgba(79, 70, 229, 0.22), transparent 28%),
                radial-gradient(circle at top right, rgba(16, 185, 129, 0.12), transparent 22%),
                linear-gradient(135deg, #090d1a 0%, #0f172a 45%, #111827 100%);
            min-height: 100vh;
        }

        .page {
            max-width: 1500px;
            margin: 0 auto;
            padding: 32px 26px 48px;
        }

        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 28px;
        }

        .title-block h1 {
            font-size: 42px;
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #ffffff;
        }

        .title-block p {
            font-size: 20px;
            color: var(--text-secondary);
        }

        .top-actions {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .btn,
        button {
            border: none;
            outline: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 20px;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 700;
            transition: 0.25s ease;
        }

        .btn-outline {
            color: var(--text-primary);
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-strong);
            backdrop-filter: blur(12px);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-1px);
        }

        .btn-primary {
            color: white;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(79, 70, 229, 0.35);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 34px rgba(79, 70, 229, 0.45);
        }

        .panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            box-shadow: var(--shadow);
            backdrop-filter: blur(16px);
            overflow: hidden;
        }

        .alert-wrap {
            margin-bottom: 20px;
        }

        .alert {
            border-radius: 16px;
            padding: 16px 18px;
            font-size: 15px;
            font-weight: 700;
            border: 1px solid transparent;
        }

        .alert-success {
            background: var(--success-soft);
            color: #a7f3d0;
            border-color: rgba(16, 185, 129, 0.35);
        }

        .alert-error {
            background: var(--danger-soft);
            color: #fecaca;
            border-color: rgba(239, 68, 68, 0.35);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            padding: 22px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.02);
        }

        .search-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            flex: 1;
        }

        .search-box {
            flex: 1;
            min-width: 280px;
        }

        .search-input,
        .filter-select,
        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 16px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(7, 13, 28, 0.9);
            color: white;
            font-size: 14px;
            outline: none;
            transition: 0.25s ease;
        }

        .filter-select {
            min-width: 180px;
        }

        .search-input:focus,
        .filter-select:focus,
        .form-group input:focus,
        .form-group select:focus {
            border-color: rgba(99, 102, 241, 0.6);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .search-input::placeholder,
        .form-group input::placeholder {
            color: #64748b;
        }

        .result-count {
            font-size: 14px;
            color: var(--text-secondary);
            font-weight: 700;
            white-space: nowrap;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1320px;
        }

        thead th {
            text-align: left;
            padding: 22px 20px;
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #cbd5e1;
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid var(--border);
        }

        tbody td {
            padding: 22px 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            vertical-align: middle;
            color: var(--text-primary);
        }

        tbody tr.data-row {
            transition: 0.25s ease;
        }

        tbody tr.data-row:hover {
            background: rgba(255, 255, 255, 0.03);
        }

        tbody tr:last-child td {
            border-bottom: none;
        }

        .user-id {
            font-weight: 800;
            color: #ffffff;
            letter-spacing: 0.3px;
        }

        .user-name {
            font-weight: 700;
            color: #f8fafc;
        }

        .user-email,
        .user-phone {
            color: #cbd5e1;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .badge-admin {
            color: #c7d2fe;
            background: rgba(79, 70, 229, 0.2);
            border: 1px solid rgba(99, 102, 241, 0.3);
        }

        .badge-customer {
            color: #a7f3d0;
            background: rgba(16, 185, 129, 0.18);
            border: 1px solid rgba(16, 185, 129, 0.28);
        }

        .permission-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.3px;
            color: var(--warning-text);
            background: var(--warning-soft);
            border: 1px solid rgba(245, 158, 11, 0.28);
        }

        .permission-muted {
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 600;
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-edit {
            color: #dbeafe;
            background: rgba(37, 99, 235, 0.18);
            border: 1px solid rgba(59, 130, 246, 0.28);
            min-width: 92px;
        }

        .btn-delete {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.18);
            border: 1px solid rgba(239, 68, 68, 0.3);
            min-width: 92px;
        }

        .btn-delete:disabled {
            opacity: 0.45;
            cursor: not-allowed;
        }

        .edit-row {
            display: none;
            background: rgba(255, 255, 255, 0.025);
        }

        .edit-row.active {
            display: table-row;
        }

        .edit-cell {
            padding: 0 !important;
        }

        .edit-box {
            padding: 24px;
            border-top: 1px solid var(--border);
            background: linear-gradient(180deg, rgba(255,255,255,0.02), rgba(255,255,255,0.01));
        }

        .edit-title {
            font-size: 18px;
            font-weight: 800;
            margin-bottom: 18px;
            color: #ffffff;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-size: 13px;
            font-weight: 800;
            color: #cbd5e1;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .btn-save {
            color: white;
            background: linear-gradient(135deg, #059669, #10b981);
        }

        .btn-cancel {
            color: var(--text-primary);
            background: rgba(255,255,255,0.05);
            border: 1px solid var(--border-strong);
        }

        .note {
            margin-top: 12px;
            font-size: 13px;
            color: #fca5a5;
            font-weight: 600;
        }

        .empty-state {
            padding: 36px 24px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 17px;
        }

        .no-results {
            display: none;
            padding: 28px 24px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 16px;
            border-top: 1px solid var(--border);
        }

        .permission-group {
            display: block;
        }

        @media (max-width: 1100px) {
            .form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 720px) {
            .page {
                padding: 22px 14px 32px;
            }

            .title-block h1 {
                font-size: 32px;
            }

            .title-block p {
                font-size: 16px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .top-actions {
                width: 100%;
            }

            .top-actions a {
                flex: 1;
            }

            .toolbar {
                flex-direction: column;
                align-items: stretch;
            }

            .result-count {
                text-align: left;
            }
        }
    </style>

    <script>
        function toggleEditPanel(userId) {
            var target = document.getElementById("edit-" + userId);
            var allPanels = document.querySelectorAll(".edit-row");

            allPanels.forEach(function(panel) {
                if (panel !== target) {
                    panel.classList.remove("active");
                }
            });

            if (target) {
                target.classList.toggle("active");
            }
        }

        function confirmDelete(userId) {
            return confirm("Are you sure you want to delete user " + userId + "?");
        }

        function filterUsers() {
            var searchValue = document.getElementById("userSearch").value.toLowerCase().trim();
            var roleValue = document.getElementById("roleFilter").value.toLowerCase();
            var rows = document.querySelectorAll(".data-row");
            var visibleCount = 0;

            rows.forEach(function(row) {
                var userId = (row.getAttribute("data-user-id") || "").toLowerCase();
                var name = (row.getAttribute("data-name") || "").toLowerCase();
                var email = (row.getAttribute("data-email") || "").toLowerCase();
                var phone = (row.getAttribute("data-phone") || "").toLowerCase();
                var role = (row.getAttribute("data-role") || "").toLowerCase();

                var matchesSearch =
                    userId.includes(searchValue) ||
                    name.includes(searchValue) ||
                    email.includes(searchValue) ||
                    phone.includes(searchValue);

                var matchesRole = (roleValue === "all" || role === roleValue);

                var editRow = document.getElementById("edit-" + row.getAttribute("data-user-id"));

                if (matchesSearch && matchesRole) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                    if (editRow) {
                        editRow.style.display = "none";
                        editRow.classList.remove("active");
                    }
                }
            });

            document.getElementById("resultCount").innerText = visibleCount + " user(s) found";

            var noResults = document.getElementById("noResults");
            noResults.style.display = visibleCount === 0 ? "block" : "none";
        }

        function clearFilters() {
            document.getElementById("userSearch").value = "";
            document.getElementById("roleFilter").value = "all";
            filterUsers();
        }

        function togglePermissionField(userId) {
            var roleSelect = document.getElementById("role-" + userId);
            var permissionWrap = document.getElementById("permission-wrap-" + userId);

            if (!roleSelect || !permissionWrap) return;

            if (roleSelect.value === "ADMIN") {
                permissionWrap.style.display = "block";
            } else {
                permissionWrap.style.display = "none";
            }
        }

        window.addEventListener("DOMContentLoaded", function() {
            filterUsers();

            var roleSelects = document.querySelectorAll(".role-select");
            roleSelects.forEach(function(select) {
                var userId = select.getAttribute("data-user-id");
                togglePermissionField(userId);
            });
        });
    </script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
<div class="page">

    <div class="topbar">
        <div class="title-block">
            <h1>Manage Users</h1>
            <p>View, search, edit, and manage all registered system users</p>
        </div>

        <div class="top-actions">
            <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn btn-outline">Dashboard</a>
            <a href="<%=request.getContextPath()%>/user?action=listAdminRequests" class="btn btn-primary">Admin Requests</a>
        </div>
    </div>

    <div class="alert-wrap">
        <% if ("updated".equals(msg)) { %>
            <div class="alert alert-success">User updated successfully.</div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-success">User deleted successfully.</div>
        <% } %>

        <% if ("updateFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to update user. Check required fields and email uniqueness.</div>
        <% } else if ("deleteFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to delete user. The system blocked the operation or related data caused an issue.</div>
        <% } %>
    </div>

    <div class="panel">
        <div class="toolbar">
            <div class="search-group">
                <div class="search-box">
                    <input
                        type="text"
                        id="userSearch"
                        class="search-input"
                        placeholder="Search by User ID, name, email, or phone..."
                        onkeyup="filterUsers()">
                </div>

                <div class="filter-box">
                    <select id="roleFilter" class="filter-select" onchange="filterUsers()">
                        <option value="all">All Roles</option>
                        <option value="admin">Admins Only</option>
                        <option value="customer">Customers Only</option>
                    </select>
                </div>

                <button type="button" class="btn btn-outline" onclick="clearFilters()">Clear</button>
            </div>

            <div class="result-count" id="resultCount">0 user(s) found</div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th>Permission</th>
                    <th style="min-width: 220px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (users == null || users.isEmpty()) { %>
                    <tr>
                        <td colspan="7">
                            <div class="empty-state">No users found.</div>
                        </td>
                    </tr>
                <% } else { %>
                    <% for (User user : users) { %>
                        <%
                            boolean isAdmin = "ADMIN".equals(user.getRole());
                            String permissionValue = Admin.CORE_ADMIN;
                            String permissionLabel = "Not Applicable";

                            if (isAdmin && user instanceof Admin) {
                                Admin adminUser = (Admin) user;
                                permissionValue = adminUser.getAdminPermission();
                                permissionLabel = adminUser.getPermissionLabel();
                            }
                        %>

                        <tr class="data-row"
                            data-user-id="<%= user.getUserId() %>"
                            data-name="<%= user.getName() %>"
                            data-email="<%= user.getEmail() %>"
                            data-phone="<%= user.getPhone() %>"
                            data-role="<%= user.getRole() %>">
                            <td class="user-id"><%= user.getUserId() %></td>
                            <td class="user-name"><%= user.getName() %></td>
                            <td class="user-email"><%= user.getEmail() %></td>
                            <td class="user-phone"><%= user.getPhone() %></td>
                            <td>
                                <% if (isAdmin) { %>
                                    <span class="badge badge-admin">Admin</span>
                                <% } else { %>
                                    <span class="badge badge-customer">Customer</span>
                                <% } %>
                            </td>
                            <td>
                                <% if (isAdmin) { %>
                                    <span class="permission-badge"><%= permissionLabel %></span>
                                <% } else { %>
                                    <span class="permission-muted">Not Applicable</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="action-group">
                                    <button type="button"
                                            class="btn btn-edit"
                                            onclick="toggleEditPanel('<%= user.getUserId() %>')">
                                        Edit
                                    </button>

                                    <form method="post"
                                          action="<%=request.getContextPath()%>/user"
                                          style="margin:0;"
                                          onsubmit="return confirmDelete('<%= user.getUserId() %>');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <button type="submit"
                                                class="btn btn-delete"
                                                <%= user.getUserId().equals(currentAdminId) ? "disabled title='You cannot delete your own account.'" : "" %>>
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>

                        <tr id="edit-<%= user.getUserId() %>" class="edit-row">
                            <td colspan="7" class="edit-cell">
                                <div class="edit-box">
                                    <div class="edit-title">Edit User - <%= user.getUserId() %></div>

                                    <form method="post" action="<%=request.getContextPath()%>/user">
                                        <input type="hidden" name="action" value="adminUpdate">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                                        <div class="form-grid">
                                            <div class="form-group">
                                                <label>Name</label>
                                                <input type="text"
                                                       name="name"
                                                       value="<%= user.getName() %>"
                                                       required>
                                            </div>

                                            <div class="form-group">
                                                <label>Email</label>
                                                <input type="email"
                                                       name="email"
                                                       value="<%= user.getEmail() %>"
                                                       required>
                                            </div>

                                            <div class="form-group">
                                                <label>Phone</label>
                                                <input type="text"
                                                       name="phone"
                                                       value="<%= user.getPhone() %>"
                                                       required>
                                            </div>

                                            <div class="form-group">
                                                <label>New Password</label>
                                                <input type="text"
                                                       name="password"
                                                       placeholder="Leave blank to keep current password">
                                            </div>

                                            <div class="form-group">
                                                <label>Role</label>
                                                <select name="role"
                                                        id="role-<%= user.getUserId() %>"
                                                        class="role-select"
                                                        data-user-id="<%= user.getUserId() %>"
                                                        onchange="togglePermissionField('<%= user.getUserId() %>')"
                                                        required
                                                    <%= user.getUserId().equals(currentAdminId) ? "disabled" : "" %>>
                                                    <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN</option>
                                                    <option value="CUSTOMER" <%= "CUSTOMER".equals(user.getRole()) ? "selected" : "" %>>CUSTOMER</option>
                                                </select>

                                                <% if (user.getUserId().equals(currentAdminId)) { %>
                                                    <input type="hidden" name="role" value="ADMIN">
                                                <% } %>
                                            </div>

                                            <div class="form-group permission-group"
                                                 id="permission-wrap-<%= user.getUserId() %>"
                                                 style="<%= isAdmin ? "display:block;" : "display:none;" %>">
                                                <label>Admin Permission</label>
                                                <select name="adminPermission"
                                                        <%= ("CUSTOMER".equals(user.getRole())) ? "" : "" %>>
                                                    <option value="CORE_ADMIN" <%= "CORE_ADMIN".equals(permissionValue) ? "selected" : "" %>>Core Admin</option>
                                                    <option value="EVENTS_BOOKINGS_REQUEST_ADMIN" <%= "EVENTS_BOOKINGS_REQUEST_ADMIN".equals(permissionValue) ? "selected" : "" %>>Events + Bookings + New Admin Requests</option>
                                                    <option value="EVENTS_ONLY" <%= "EVENTS_ONLY".equals(permissionValue) ? "selected" : "" %>>Events only</option>
                                                    <option value="BOOKINGS_ONLY" <%= "BOOKINGS_ONLY".equals(permissionValue) ? "selected" : "" %>>Bookings only</option>
                                                </select>
                                            </div>
                                        </div>

                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-save">Save Changes</button>
                                            <button type="button"
                                                    class="btn btn-cancel"
                                                    onclick="toggleEditPanel('<%= user.getUserId() %>')">
                                                Cancel
                                            </button>
                                        </div>

                                        <% if (user.getUserId().equals(currentAdminId)) { %>
                                            <div class="note">
                                                Your own admin account cannot be downgraded or deleted from this page.
                                            </div>
                                        <% } %>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>

        <div id="noResults" class="no-results">
            No matching users found for your search.
        </div>
    </div>
</div>
<!-- EVENTHORIZON ADMIN LIGHT RETHEME OVERRIDE - paste-safe, logic-safe -->
<style>
    :root {
        --eh-linen: #FAF8F4 !important;
        --eh-paper: #FFFFFF !important;
        --eh-forest: #1E4A3A !important;
        --eh-forest-dark: #123528 !important;
        --eh-forest-soft: #E8F1EC !important;
        --eh-sage: #72887A !important;
        --eh-text: #18251F !important;
        --eh-text-soft: #52635A !important;
        --eh-muted: #6F7F76 !important;
        --eh-border: rgba(30, 74, 58, 0.16) !important;
        --eh-border-strong: rgba(30, 74, 58, 0.30) !important;
        --eh-success-bg: #E8F6EE !important;
        --eh-success-text: #176B3B !important;
        --eh-warning-bg: #FFF7E3 !important;
        --eh-warning-text: #76520F !important;
        --eh-danger-bg: #FFF0EC !important;
        --eh-danger-text: #A23A27 !important;
        --eh-info-bg: #E8F1EC !important;
        --eh-info-text: #123528 !important;
        --eh-shadow-soft: 0 18px 50px rgba(24, 37, 31, 0.09) !important;
        --eh-shadow-premium: 0 30px 90px rgba(24, 37, 31, 0.15) !important;
        --bg: #FAF8F4 !important;
        --surface: #FFFFFF !important;
        --card: #FFFFFF !important;
        --text: #18251F !important;
        --text-primary: #18251F !important;
        --text-secondary: #52635A !important;
        --text-muted: #52635A !important;
        --muted: #52635A !important;
        --border: rgba(30, 74, 58, 0.16) !important;
        --accent: #1E4A3A !important;
        --accent-light: #2E6B55 !important;
        --accent-purple: #1E4A3A !important;
        --accent-teal: #1E4A3A !important;
        --accent-blue: #1E4A3A !important;
        --success: #176B3B !important;
        --success-soft: #E8F6EE !important;
        --danger: #A23A27 !important;
        --danger-soft: #FFF0EC !important;
        --warn: #76520F !important;
        --warning-text: #76520F !important;
        --warning-soft: #FFF7E3 !important;
    }

    html { scroll-behavior: smooth !important; }

    body {
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif !important;
        background:
            radial-gradient(circle at top left, rgba(30, 74, 58, 0.08), transparent 32%),
            radial-gradient(circle at top right, rgba(176, 141, 101, 0.10), transparent 30%),
            linear-gradient(180deg, #ffffff 0%, #FAF8F4 48%, #F7F3EA 100%) !important;
        color: var(--eh-text) !important;
        min-height: 100vh !important;
        line-height: 1.6 !important;
        overflow-x: hidden !important;
        -webkit-font-smoothing: antialiased !important;
    }

    body::before {
        content: "" !important;
        position: fixed !important;
        inset: 0 !important;
        z-index: -10 !important;
        pointer-events: none !important;
        background-image:
            radial-gradient(circle at 1px 1px, rgba(30, 74, 58, 0.10) 1.2px, transparent 1.4px),
            linear-gradient(135deg, rgba(30, 74, 58, 0.035) 25%, transparent 25%),
            linear-gradient(45deg, rgba(176, 141, 101, 0.035) 25%, transparent 25%) !important;
        background-size: 34px 34px, 88px 88px, 88px 88px !important;
        background-position: 0 0, 0 0, 44px 44px !important;
        opacity: 0.72 !important;
    }

    a { text-decoration: none !important; }

    .admin-shell,
    .admin-wrapper {
        background: transparent !important;
        color: var(--eh-text) !important;
        min-height: 100vh !important;
    }

    .sidebar {
        background: rgba(255, 255, 255, 0.97) !important;
        color: var(--eh-text) !important;
        border-right: 1px solid var(--eh-border) !important;
        box-shadow: 16px 0 45px rgba(24, 37, 31, 0.06) !important;
    }

    .brand,
    .sidebar-title,
    .navbar-brand,
    .brand h2,
    .brand-text h2,
    .sidebar .brand h2,
    .sidebar-title {
        color: var(--eh-forest-dark) !important;
        font-weight: 900 !important;
        letter-spacing: 1.4px !important;
    }

    .brand p,
    .brand-text p,
    .sidebar .brand p,
    .sidebar-footer,
    .sidebar-footer div,
    .sidebar-footer strong {
        color: var(--eh-text-soft) !important;
    }

    .brand-icon {
        width: 42px !important;
        height: 42px !important;
        border-radius: 14px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
        border: none !important;
        font-size: 0 !important;
        flex-shrink: 0 !important;
    }

    .brand-icon::before {
        content: "\f06c" !important;
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900 !important;
        font-size: 1rem !important;
        color: #ffffff !important;
    }

    .brand-icon i { color: #ffffff !important; font-size: 1rem !important; }

    .nav-links a,
    .sidebar-link,
    .navbar-links a,
    .navbar a:not(.btn-nav),
    .back-site,
    .logout-btn {
        color: var(--eh-text-soft) !important;
        background: transparent !important;
        border: 1px solid transparent !important;
        box-shadow: none !important;
        font-weight: 850 !important;
    }

    .nav-links a i,
    .sidebar-link i,
    .back-site i,
    .logout-btn i,
    .navbar-links a i {
        color: var(--eh-forest) !important;
    }

    .nav-links a:hover,
    .nav-links a.active,
    .sidebar-link:hover,
    .sidebar-link.active,
    .navbar-links a:hover,
    .navbar-links a.active,
    .back-site:hover {
        color: var(--eh-forest-dark) !important;
        background: var(--eh-forest-soft) !important;
        border-color: var(--eh-border-strong) !important;
        box-shadow: 0 8px 18px rgba(24, 37, 31, 0.06) !important;
    }

    .logout-btn:hover {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border-color: rgba(162, 58, 39, 0.26) !important;
    }

    .sidebar-footer > div,
    .topbar-badge,
    .topbar-user,
    [style*="rgba(255,255,255,0.04)"],
    [style*="rgba(255, 255, 255, 0.04)"],
    [style*="rgba(255,255,255,0.05)"],
    [style*="background:rgba(255,255,255"] {
        background: #ffffff !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: none !important;
    }

    .main-content,
    .admin-content {
        background: transparent !important;
        color: var(--eh-text) !important;
    }

    .topbar {
        background: rgba(255,255,255,0.86) !important;
        border: 1px solid var(--eh-border) !important;
        border-radius: 24px !important;
        padding: 22px 24px !important;
        margin-bottom: 24px !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    .eyebrow,
    .subtitle,
    .topbar p,
    .topbar-badge,
    .topbar-user {
        color: var(--eh-text-soft) !important;
    }

    .navbar {
        background: rgba(250, 248, 244, 0.96) !important;
        border-bottom: 1px solid var(--eh-border) !important;
        box-shadow: 0 10px 28px rgba(24, 37, 31, 0.05) !important;
        backdrop-filter: blur(18px) !important;
        -webkit-backdrop-filter: blur(18px) !important;
    }

    .navbar-brand {
        display: inline-flex !important;
        align-items: center !important;
        gap: 10px !important;
        color: var(--eh-forest-dark) !important;
        font-weight: 900 !important;
        letter-spacing: 1.4px !important;
        text-transform: uppercase !important;
    }

    .navbar-brand::before {
        content: "\f06c" !important;
        width: 42px !important;
        height: 42px !important;
        border-radius: 14px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900 !important;
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
    }

    .btn-nav {
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        border: none !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
    }

    .content-card,
    .card,
    .panel,
    .panel-body,
    .table-wrap,
    .booking-table-wrap,
    .scan-card,
    .scanner-card,
    .filter-bar,
    .filters,
    .filter-panel,
    .stat-card,
    .metric-card,
    .summary-card,
    .issue-card,
    .detail-card,
    .reply-card,
    .quick-status-card,
    .ticket-card,
    .notice-box,
    .form-panel,
    .side-panel,
    .event-form,
    .event-panel,
    .user-card,
    .modal-content,
    .empty-state,
    .empty-box {
        background: rgba(255, 255, 255, 0.97) !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    .content-card,
    .card,
    .panel,
    .table-wrap,
    .booking-table-wrap,
    .scan-card,
    .filter-bar,
    .stat-card,
    .detail-card,
    .quick-status-card,
    .notice-box {
        border-radius: 24px !important;
    }

    h1, h2, h3, h4, h5, h6,
    .page-title,
    .section-title,
    .content-card h2,
    .card-title,
    .panel-title,
    .ticket-title,
    .stat-val,
    .stat-number,
    .title,
    .detail-title,
    .bank-value,
    .summary-title,
    .total-amount,
    .topbar h1,
    .modal-title {
        color: var(--eh-forest-dark) !important;
        text-shadow: none !important;
        font-weight: 900 !important;
    }

    p, li, label, small,
    .content-card > p,
    .stat-lbl,
    .muted,
    .subtitle,
    .card-subtitle,
    .meta-item small,
    .booking-label,
    .payment-label,
    .field label,
    .form-label,
    .empty-text,
    .hint,
    .note,
    .qr-note,
    .filter-bar label,
    .modal-note,
    .table-note,
    [style*="color:#cbd5e1"],
    [style*="color: #cbd5e1"],
    [style*="color:#aab4d6"],
    [style*="color:#94a3b8"],
    [style*="color:#5a6a9a"],
    [style*="color:var(--muted)"] {
        color: var(--eh-text-soft) !important;
        text-shadow: none !important;
    }

    strong,
    .value,
    .booking-value,
    .payment-value,
    .meta-item span,
    .detail-value,
    .s-value,
    .bank-value,
    .issue-title,
    .reply-text,
    td strong,
    .table-title,
    .card strong {
        color: var(--eh-text) !important;
        font-weight: 900 !important;
    }

    input,
    select,
    textarea,
    .form-control,
    .search-input,
    .search-select,
    .field input,
    .field select,
    .filter-bar select,
    .filter-bar input {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif !important;
    }

    input::placeholder,
    textarea::placeholder,
    .field input::placeholder {
        color: #7E9086 !important;
        opacity: 1 !important;
    }

    input:focus,
    select:focus,
    textarea:focus,
    .form-control:focus,
    .field input:focus,
    .field select:focus,
    .filter-bar select:focus,
    .filter-bar input:focus {
        border-color: rgba(30, 74, 58, 0.52) !important;
        box-shadow: 0 0 0 4px rgba(30, 74, 58, 0.10) !important;
        outline: none !important;
    }

    select option {
        background: #ffffff !important;
        color: var(--eh-text) !important;
    }

    table,
    .data-table,
    .booking-table,
    .payment-table {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border-collapse: separate !important;
        border-spacing: 0 !important;
    }

    thead th,
    .data-table thead th,
    .booking-table thead th,
    .payment-table th,
    table th {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border-bottom: 1px solid var(--eh-border-strong) !important;
        font-weight: 900 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
    }

    tbody td,
    .data-table tbody td,
    .booking-table tbody td,
    .payment-table td,
    table td {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border-bottom: 1px solid rgba(30, 74, 58, 0.12) !important;
        font-weight: 700 !important;
    }

    tbody tr:hover td,
    .data-table tbody tr:hover,
    .booking-table tbody tr:hover td,
    .payment-table tbody tr:hover td,
    tbody tr.data-row:hover td {
        background: #FAF8F4 !important;
        color: var(--eh-text) !important;
    }

    .btn,
    .primary-btn,
    .btn-primary,
    .btn-save,
    .search-btn,
    .btn-filter,
    .approve-btn,
    .btn-add-type,
    button[type="submit"].primary-btn,
    button[type="submit"].btn-primary {
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        border: 1px solid transparent !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
        font-weight: 900 !important;
    }

    .btn:hover,
    .primary-btn:hover,
    .btn-primary:hover,
    .btn-save:hover,
    .search-btn:hover,
    .btn-filter:hover,
    .approve-btn:hover,
    .btn-add-type:hover {
        transform: translateY(-1px) !important;
        box-shadow: 0 18px 42px rgba(30, 74, 58, 0.30) !important;
        opacity: 1 !important;
    }

    .secondary-btn,
    .btn-secondary,
    .btn-outline,
    .btn-reset,
    .btn-view,
    .btn-edit,
    .action-link,
    .back-link,
    .btn-cancel,
    .qs-btn {
        background: #ffffff !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .secondary-btn:hover,
    .btn-secondary:hover,
    .btn-outline:hover,
    .btn-reset:hover,
    .btn-view:hover,
    .btn-edit:hover,
    .back-link:hover,
    .qs-btn:hover,
    .qs-btn.active {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border-color: rgba(30, 74, 58, 0.42) !important;
    }

    .reject-btn,
    .delete-btn,
    .btn-delete,
    .btn-remove-type,
    .cancel-btn,
    .btn-cancel-event,
    .danger-btn,
    .btn-danger {
        background: #ffffff !important;
        color: var(--eh-danger-text) !important;
        border: 1px solid rgba(162, 58, 39, 0.30) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .reject-btn:hover,
    .delete-btn:hover,
    .btn-delete:hover,
    .btn-remove-type:hover,
    .cancel-btn:hover,
    .btn-cancel-event:hover,
    .danger-btn:hover,
    .btn-danger:hover {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border-color: rgba(162, 58, 39, 0.45) !important;
    }

    button:disabled,
    .btn:disabled {
        background: #F1F3F1 !important;
        color: #87928C !important;
        border-color: #DDE4DF !important;
        box-shadow: none !important;
        cursor: not-allowed !important;
    }

    .alert,
    .alert-box,
    .alert-info,
    .info-box {
        background: var(--eh-info-bg) !important;
        color: var(--eh-info-text) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
    }

    .alert-success,
    .alert-success-box,
    .success-box,
    .status-approved,
    .payment-approved,
    .badge-success,
    .valid,
    .unused,
    .approved:not(.status-box),
    .badge-available {
        background: var(--eh-success-bg) !important;
        color: var(--eh-success-text) !important;
        border: 1px solid rgba(23, 107, 59, 0.22) !important;
    }

    .alert-danger,
    .alert-error,
    .alert-error-box,
    .error-box,
    .status-rejected,
    .payment-rejected,
    .badge-danger,
    .invalid,
    .not-approved,
    .wrong,
    .badge-soldout {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border: 1px solid rgba(162, 58, 39, 0.22) !important;
    }

    .alert-warning,
    .payment-pending,
    .status-pending,
    .badge-warning,
    .used,
    .qs-in-progress,
    .badge-progress {
        background: var(--eh-warning-bg) !important;
        color: var(--eh-warning-text) !important;
        border: 1px solid rgba(138, 90, 0, 0.22) !important;
    }

    .badge,
    .chip,
    .type-pill,
    .ticket-type-pill,
    .role-pill,
    .status-pill,
    .ticket-badge,
    .bank-badge,
    .category-pill,
    .permission-pill {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .status-box.approved,
    .approved.status-box {
        background: var(--eh-success-bg) !important;
        color: var(--eh-success-text) !important;
        border: 2px solid rgba(23, 107, 59, 0.24) !important;
    }

    .status-box.not-approved,
    .not-approved.status-box {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border: 2px solid rgba(162, 58, 39, 0.24) !important;
    }

    .p-high { background: var(--eh-danger-text) !important; }
    .p-medium { background: #C2882E !important; }
    .p-low { background: var(--eh-success-text) !important; }

    .badge-open { background: var(--eh-danger-bg) !important; color: var(--eh-danger-text) !important; border-color: rgba(162,58,39,0.22) !important; }
    .badge-progress { background: var(--eh-warning-bg) !important; color: var(--eh-warning-text) !important; border-color: rgba(138,90,0,0.22) !important; }
    .badge-resolved { background: var(--eh-success-bg) !important; color: var(--eh-success-text) !important; border-color: rgba(23,107,59,0.22) !important; }

    #reader,
    .qr-box,
    .scan-result,
    .result-box {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    video,
    canvas {
        background: #ffffff !important;
        border-radius: 16px !important;
    }

    .note {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid rgba(30, 74, 58, 0.22) !important;
    }

    .fa-solid,
    .fa-regular,
    .card-title i,
    .content-card h2 i,
    .topbar i,
    .stat-card i,
    .empty-state i,
    .btn-edit i,
    .btn-view i {
        color: var(--eh-forest) !important;
    }

    .primary-btn i,
    .btn-primary i,
    .approve-btn i,
    .btn-filter i,
    .btn-save i,
    .search-btn i,
    .btn-nav i {
        color: #ffffff !important;
    }

    [style*="#7c5cff"],
    [style*="#6c5ce7"],
    [style*="#2bc0ff"],
    [style*="#00cec9"],
    [style*="color:#ffffff"],
    [style*="color: #ffffff"],
    [style*="color:white"],
    [style*="color: white"] {
        color: var(--eh-forest-dark) !important;
    }

    [style*="background:rgba(43,192,255"],
    [style*="background:rgba(6,182,212"],
    [style*="background: rgba(43,192,255"],
    [style*="background: rgba(6, 182, 212"],
    [style*="background:rgba(124,92,255"],
    [style*="background: rgba(124, 92, 255"],
    [style*="background:rgba(91, 33, 182"],
    [style*="background: rgba(91, 33, 182"] {
        background: var(--eh-forest-soft) !important;
        border-color: var(--eh-border-strong) !important;
        color: var(--eh-forest-dark) !important;
    }

    .primary-btn,
    .btn-primary,
    .btn-save,
    .search-btn,
    .btn-filter,
    .approve-btn,
    .btn-nav,
    .primary-btn *,
    .btn-primary *,
    .btn-save *,
    .search-btn *,
    .btn-filter *,
    .approve-btn *,
    .btn-nav * {
        color: #ffffff !important;
    }

    @media (max-width: 900px) {
        .admin-shell,
        .admin-wrapper { display: block !important; }
        .sidebar {
            position: relative !important;
            width: 100% !important;
            min-height: auto !important;
            border-right: none !important;
            border-bottom: 1px solid var(--eh-border) !important;
        }
        .nav-links,
        .navbar-links { justify-content: center !important; }
    }
</style>

</body>
</html>