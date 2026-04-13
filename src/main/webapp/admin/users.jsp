<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.eventhorizon.service.UserService, java.util.List, com.eventhorizon.model.User" %>

<%
    // 🔒 Prevent cache (fix logout back-button issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔒 Admin security check
    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">← Public Site</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="admin-wrapper">

    <aside class="sidebar">
        <div class="sidebar-title">Admin Panel</div>

        <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="sidebar-link">
            <span>📊</span> Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link">
            <span>🎟️</span> Manage Events
        </a>

        <a href="${pageContext.request.contextPath}/admin/bookings.jsp" class="sidebar-link">
            <span>📋</span> All Bookings
        </a>

        <a href="${pageContext.request.contextPath}/admin/users.jsp" class="sidebar-link active">
            <span>👥</span> Manage Users
        </a>

        <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link">
            <span>➕</span> Add New Event
        </a>
    </aside>

    <main class="admin-content">

        <div class="page-header">
            <h1 class="page-title">👥 Manage Users</h1>
            <span style="color:var(--text-muted);font-size:0.9rem;">
                Total: <strong>${users.size()}</strong> users
            </span>
        </div>

        <c:if test="${param.msg == 'deleted'}">
            <div class="alert alert-info" data-auto-dismiss>
                🗑️ User deleted successfully.
            </div>
        </c:if>

        <div style="margin-bottom:20px;">
            <input type="text"
                   id="liveSearch"
                   class="form-control"
                   placeholder="🔍 Search by name, email, or ID..."
                   style="max-width:420px;">
        </div>

        <div class="table-wrapper">
            <table class="table" style="width:100%;">
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
                                <c:choose>
                                    <c:when test="${u.userId != sessionScope.userId}">
                                        <form action="${pageContext.request.contextPath}/user"
                                              method="post"
                                              style="display:inline;">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="userId" value="${u.userId}">
                                            <button type="submit"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Delete user ${u.name}?');">
                                                🗑️ Delete
                                            </button>
                                        </form>
                                    </c:when>

                                    <c:otherwise>
                                        <span class="badge badge-success">You</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty users}">
                        <tr>
                            <td colspan="6" style="text-align:center;color:var(--text-muted);padding:48px;">
                                No users found.
                            </td>
                        </tr>
                    </c:if>
                </tbody>

            </table>
        </div>

    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>