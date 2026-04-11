<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp"); return;
    }
%>
<%@ page import="com.eventhorizon.service.UserService, java.util.List, com.eventhorizon.model.User" %>
<%
    UserService us = new UserService();
    List<User> allUsers = us.getAllUsers();
    pageContext.setAttribute("users", allUsers);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users – EventHorizon Admin</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="../index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <ul class="navbar-links">
        <li><a href="../index.jsp">← Public Site</a></li>
        <li><a href="../user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="admin-wrapper">
    <aside class="sidebar">
        <div class="sidebar-title">Admin Panel</div>
        <a href="dashboard.jsp" class="sidebar-link"><span>📊</span> Dashboard</a>
        <a href="events.jsp"    class="sidebar-link"><span>🎟️</span> Manage Events</a>
        <a href="bookings.jsp"  class="sidebar-link"><span>📋</span> All Bookings</a>
        <a href="users.jsp"     class="sidebar-link active"><span>👥</span> Manage Users</a>
        <a href="addEvent.jsp"  class="sidebar-link"><span>➕</span> Add New Event</a>
    </aside>

    <main class="admin-content">
        <div class="page-header">
            <h1 class="page-title">👥 Manage Users</h1>
            <span style="color:var(--text-muted);font-size:0.9rem;">
                Total: <strong>${users.size()}</strong> users
            </span>
        </div>

        <% if ("deleted".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info" data-auto-dismiss>🗑️ User deleted successfully.</div>
        <% } %>

        <div style="margin-bottom:20px;">
            <input type="text" id="liveSearch" class="form-control"
                   placeholder="🔍 Search by name, email, or ID..."
                   style="max-width:420px;">
        </div>

        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <th>User ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Role</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="u" items="${users}">
                        <tr data-search-row>
                            <td data-searchable="${u.userId} ${u.name} ${u.email}"
                                style="font-family:'Orbitron',monospace;font-size:0.75rem;color:var(--accent-teal);">
                                ${u.userId}
                            </td>
                            <td style="font-weight:600;">${u.name}</td>
                            <td style="color:var(--text-muted);">${u.email}</td>
                            <td>${u.phone}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${u.role == 'ADMIN'}">
                                        <span class="badge badge-purple">ADMIN</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-info">CUSTOMER</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:if test="${u.userId != sessionScope.userId}">
                                    <form action="../user" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="${u.userId}">
                                        <button type="submit" class="btn btn-danger btn-sm"
                                                data-confirm-delete="Delete user ${u.name}?">
                                            🗑️ Delete
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${u.userId == sessionScope.userId}">
                                    <span class="badge badge-success">You</span>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty users}">
                        <tr><td colspan="6" style="text-align:center;color:var(--text-muted);padding:48px;">
                            No users found.
                        </td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="../js/main.js"></script>
</body>
</html>
