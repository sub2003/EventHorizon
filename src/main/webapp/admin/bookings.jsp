<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.eventhorizon.service.BookingService, java.util.List, com.eventhorizon.model.Booking" %>

<%
    // Prevent browser cache after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // Admin security check
    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookingService bs = new BookingService();
    List<Booking> allBookings = bs.getAllBookings();
    pageContext.setAttribute("bookings", allBookings);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Bookings – EventHorizon Admin</title>
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

        <a href="${pageContext.request.contextPath}/admin/bookings.jsp" class="sidebar-link active">
            <span>📋</span> All Bookings
        </a>

        <a href="${pageContext.request.contextPath}/admin/users.jsp" class="sidebar-link">
            <span>👥</span> Manage Users
        </a>

        <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link">
            <span>➕</span> Add New Event
        </a>
    </aside>

    <main class="admin-content">
        <div class="page-header">
            <h1 class="page-title">📋 All Bookings</h1>
            <span style="color:var(--text-muted);font-size:0.9rem;">
                Total: <strong>${bookings.size()}</strong> bookings
            </span>
        </div>

        <c:if test="${param.msg == 'cancelled'}">
            <div class="alert alert-info" data-auto-dismiss>
                🔄 Booking cancelled &amp; seats restored.
            </div>
        </c:if>

        <div style="margin-bottom:20px;">
            <input type="text"
                   id="liveSearch"
                   class="form-control"
                   placeholder="🔍 Search by booking ID, event, or customer..."
                   style="max-width:420px;">
        </div>

        <div class="table-wrapper">
            <table class="table" style="width:100%;">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer ID</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Total (LKR)</th>
                        <th>Date</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr data-search-row>
                            <td data-searchable="${b.bookingId} ${b.eventTitle} ${b.customerId}"
                                style="font-family:'Orbitron',monospace;font-size:0.75rem;color:var(--accent-teal);">
                                ${b.bookingId}
                            </td>

                            <td style="font-size:0.85rem;color:var(--text-muted);">
                                ${b.customerId}
                            </td>

                            <td style="font-weight:600;">
                                ${b.eventTitle}
                            </td>

                            <td>${b.numberOfTickets}</td>

                            <td style="color:var(--accent-teal);font-weight:600;">
                                ${b.totalAmount}
                            </td>

                            <td>${b.bookingDate}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'CONFIRMED'}">
                                        <span class="badge badge-success">CONFIRMED</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">CANCELLED</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${b.status == 'CONFIRMED'}">
                                        <form action="${pageContext.request.contextPath}/booking"
                                              method="post"
                                              style="display:inline;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                            <button type="submit"
                                                    class="btn btn-danger btn-sm"
                                                    onclick="return confirm('Cancel this booking and restore seats?');">
                                                Cancel
                                            </button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color:var(--text-muted);font-size:0.8rem;">—</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>

                    <c:if test="${empty bookings}">
                        <tr>
                            <td colspan="8" style="text-align:center;color:var(--text-muted);padding:48px;">
                                No bookings found.
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