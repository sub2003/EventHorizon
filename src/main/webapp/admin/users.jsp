<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.User" %>
<%
    Object roleObj = session.getAttribute("role");
    if (roleObj == null || !"ADMIN".equals(roleObj.toString())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<User> users = (List<User>) request.getAttribute("users");
    String currentAdminId = (String) session.getAttribute("userId");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Users - EventHorizon</title>
    <style>
        * { box-sizing: border-box; }
        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f4f7fb;
            color: #1f2937;
        }
        .page {
            max-width: 1250px;
            margin: 0 auto;
            padding: 24px;
        }
        .topbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
            flex-wrap: wrap;
        }
        .title h1 {
            margin: 0;
            font-size: 28px;
        }
        .title p {
            margin: 6px 0 0;
            color: #6b7280;
        }
        .actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }
        .btn, button {
            border: none;
            border-radius: 10px;
            padding: 10px 16px;
            cursor: pointer;
            text-decoration: none;
            font-weight: 600;
        }
        .btn-dark { background: #111827; color: white; }
        .btn-light { background: white; color: #111827; border: 1px solid #d1d5db; }
        .btn-blue { background: #2563eb; color: white; }
        .btn-red { background: #dc2626; color: white; }
        .btn-green { background: #059669; color: white; }

        .alert {
            padding: 14px 16px;
            border-radius: 10px;
            margin-bottom: 18px;
            font-weight: 600;
        }
        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }
        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .card {
            background: white;
            border-radius: 18px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.06);
            overflow: hidden;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1000px;
        }

        th, td {
            padding: 16px;
            border-bottom: 1px solid #e5e7eb;
            text-align: left;
            vertical-align: top;
        }

        th {
            background: #f9fafb;
            font-size: 14px;
            text-transform: uppercase;
            letter-spacing: 0.4px;
            color: #6b7280;
        }

        .role-badge {
            display: inline-block;
            padding: 6px 10px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 700;
        }

        .role-admin {
            background: #dbeafe;
            color: #1d4ed8;
        }

        .role-customer {
            background: #dcfce7;
            color: #15803d;
        }

        .row-actions {
            display: flex;
            gap: 8px;
            flex-wrap: wrap;
        }

        .edit-panel {
            display: none;
            background: #f9fafb;
            padding: 18px;
            border-top: 1px solid #e5e7eb;
        }

        .edit-panel.active {
            display: block;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 14px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 700;
            color: #374151;
        }

        .form-group input,
        .form-group select {
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            font-size: 14px;
            width: 100%;
        }

        .edit-actions {
            margin-top: 16px;
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .danger-note {
            font-size: 12px;
            color: #991b1b;
            margin-top: 6px;
        }

        @media (max-width: 900px) {
            .form-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
    <script>
        function toggleEditPanel(userId) {
            var panel = document.getElementById("edit-" + userId);
            if (panel.classList.contains("active")) {
                panel.classList.remove("active");
            } else {
                var panels = document.querySelectorAll(".edit-panel");
                panels.forEach(function (p) { p.classList.remove("active"); });
                panel.classList.add("active");
            }
        }

        function confirmDelete(userId) {
            return confirm("Are you sure you want to delete user " + userId + "?");
        }
    </script>
</head>
<body>
<div class="page">
    <div class="topbar">
        <div class="title">
            <h1>Manage Users</h1>
            <p>View, edit, and remove system users</p>
        </div>
        <div class="actions">
            <a class="btn btn-light" href="<%=request.getContextPath()%>/admin/dashboard.jsp">Dashboard</a>
            <a class="btn btn-dark" href="<%=request.getContextPath()%>/user?action=listAdminRequests">Admin Requests</a>
        </div>
    </div>

    <% if ("updated".equals(msg)) { %>
        <div class="alert alert-success">User updated successfully.</div>
    <% } else if ("deleted".equals(msg)) { %>
        <div class="alert alert-success">User deleted successfully.</div>
    <% } %>

    <% if ("updateFailed".equals(error)) { %>
        <div class="alert alert-error">Failed to update user. Check email uniqueness and required fields.</div>
    <% } else if ("deleteFailed".equals(error)) { %>
        <div class="alert alert-error">Failed to delete user. The system blocked the operation or related data caused an issue.</div>
    <% } %>

    <div class="card">
        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>User ID</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Role</th>
                    <th style="width: 260px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (users == null || users.isEmpty()) { %>
                    <tr>
                        <td colspan="6">No users found.</td>
                    </tr>
                <% } else { %>
                    <% for (User user : users) { %>
                        <tr>
                            <td><strong><%= user.getUserId() %></strong></td>
                            <td><%= user.getName() %></td>
                            <td><%= user.getEmail() %></td>
                            <td><%= user.getPhone() %></td>
                            <td>
                                <% if ("ADMIN".equals(user.getRole())) { %>
                                    <span class="role-badge role-admin">ADMIN</span>
                                <% } else { %>
                                    <span class="role-badge role-customer">CUSTOMER</span>
                                <% } %>
                            </td>
                            <td>
                                <div class="row-actions">
                                    <button type="button" class="btn btn-blue"
                                            onclick="toggleEditPanel('<%= user.getUserId() %>')">
                                        Edit
                                    </button>

                                    <form method="post" action="<%=request.getContextPath()%>/user" style="margin:0;"
                                          onsubmit="return confirmDelete('<%= user.getUserId() %>');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= user.getUserId() %>">
                                        <button type="submit" class="btn btn-red"
                                            <%= user.getUserId().equals(currentAdminId) ? "disabled title='You cannot delete your own account.'" : "" %>>
                                            Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>

                        <tr id="edit-<%= user.getUserId() %>" class="edit-panel">
                            <td colspan="6">
                                <form method="post" action="<%=request.getContextPath()%>/user">
                                    <input type="hidden" name="action" value="adminUpdate">
                                    <input type="hidden" name="userId" value="<%= user.getUserId() %>">

                                    <div class="form-grid">
                                        <div class="form-group">
                                            <label>Name</label>
                                            <input type="text" name="name" value="<%= user.getName() %>" required>
                                        </div>

                                        <div class="form-group">
                                            <label>Email</label>
                                            <input type="email" name="email" value="<%= user.getEmail() %>" required>
                                        </div>

                                        <div class="form-group">
                                            <label>Phone</label>
                                            <input type="text" name="phone" value="<%= user.getPhone() %>" required>
                                        </div>

                                        <div class="form-group">
                                            <label>New Password</label>
                                            <input type="text" name="password" placeholder="Leave blank to keep current password">
                                        </div>

                                        <div class="form-group">
                                            <label>Role</label>
                                            <select name="role" required
                                                <%= user.getUserId().equals(currentAdminId) ? "disabled" : "" %>>
                                                <option value="ADMIN" <%= "ADMIN".equals(user.getRole()) ? "selected" : "" %>>ADMIN</option>
                                                <option value="CUSTOMER" <%= "CUSTOMER".equals(user.getRole()) ? "selected" : "" %>>CUSTOMER</option>
                                            </select>
                                            <% if (user.getUserId().equals(currentAdminId)) { %>
                                                <input type="hidden" name="role" value="ADMIN">
                                            <% } %>
                                        </div>
                                    </div>

                                    <div class="edit-actions">
                                        <button type="submit" class="btn btn-green">Save Changes</button>
                                        <button type="button" class="btn btn-light"
                                                onclick="toggleEditPanel('<%= user.getUserId() %>')">
                                            Cancel
                                        </button>
                                    </div>

                                    <% if (user.getUserId().equals(currentAdminId)) { %>
                                        <div class="danger-note">Your own account cannot be downgraded from ADMIN here.</div>
                                    <% } %>
                                </form>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
</html>