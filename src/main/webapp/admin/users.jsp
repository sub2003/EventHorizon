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
                            String permissionValue = Admin.FULL_ACCESS;
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
                                                    <option value="EVENTS_ONLY" <%= "EVENTS_ONLY".equals(permissionValue) ? "selected" : "" %>>Events only</option>
                                                    <option value="BOOKINGS_ONLY" <%= "BOOKINGS_ONLY".equals(permissionValue) ? "selected" : "" %>>Bookings only</option>
                                                    <option value="EVENTS_BOOKINGS" <%= "EVENTS_BOOKINGS".equals(permissionValue) ? "selected" : "" %>>Events + Bookings</option>
                                                    <option value="FULL_ACCESS" <%= "FULL_ACCESS".equals(permissionValue) ? "selected" : "" %>>Full Access</option>
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
</body>
</html>