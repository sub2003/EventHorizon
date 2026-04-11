<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<%@ page import="com.eventhorizon.service.UserService, com.eventhorizon.service.EventService, com.eventhorizon.service.BookingService" %>
<%
    UserService us = new UserService();
    EventService es = new EventService();
    BookingService bs = new BookingService();
    int totalUsers    = us.getAllCustomers().size();
    int totalEvents   = es.getAllEvents().size();
    int activeEvents  = es.getActiveEvents().size();
    int totalBookings = bs.getAllBookings().size();
    pageContext.setAttribute("totalUsers",    totalUsers);
    pageContext.setAttribute("totalEvents",   totalEvents);
    pageContext.setAttribute("activeEvents",  activeEvents);
    pageContext.setAttribute("totalBookings", totalBookings);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard – EventHorizon</title>
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
    <!-- SIDEBAR -->
    <aside class="sidebar">
        <div class="sidebar-title">Admin Panel</div>
        <a href="dashboard.jsp" class="sidebar-link active"><span>📊</span> Dashboard</a>
        <a href="events.jsp"    class="sidebar-link"><span>🎟️</span> Manage Events</a>
        <a href="bookings.jsp"  class="sidebar-link"><span>📋</span> All Bookings</a>
        <a href="users.jsp"     class="sidebar-link"><span>👥</span> Manage Users</a>
        <a href="addEvent.jsp"  class="sidebar-link"><span>➕</span> Add New Event</a>
    </aside>

    <!-- MAIN CONTENT -->
    <main class="admin-content">
        <div class="page-header">
            <h1 class="page-title">📊 Dashboard</h1>
            <span style="color:var(--text-muted);font-size:0.9rem;">
                Welcome back, <strong>${sessionScope.userName}</strong>
            </span>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon purple">👥</div>
                <div>
                    <div class="stat-value">${totalUsers}</div>
                    <div class="stat-label">Registered Users</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon teal">🎟️</div>
                <div>
                    <div class="stat-value">${totalEvents}</div>
                    <div class="stat-label">Total Events</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon green">✅</div>
                <div>
                    <div class="stat-value">${activeEvents}</div>
                    <div class="stat-label">Active Events</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon pink">📋</div>
                <div>
                    <div class="stat-value">${totalBookings}</div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius);padding:28px;margin-bottom:28px;">
            <h2 style="font-size:1rem;margin-bottom:20px;color:var(--text-muted);text-transform:uppercase;letter-spacing:1px;font-size:0.8rem;">Quick Actions</h2>
            <div style="display:flex;gap:12px;flex-wrap:wrap;">
                <a href="addEvent.jsp" class="btn btn-primary">➕ Add New Event</a>
                <a href="events.jsp"   class="btn btn-outline">🎟️ Manage Events</a>
                <a href="bookings.jsp" class="btn btn-outline">📋 View Bookings</a>
                <a href="users.jsp"    class="btn btn-outline">👥 View Users</a>
            </div>
        </div>

        <!-- Recent Bookings preview -->
        <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius);overflow:hidden;">
            <div style="padding:20px 24px;border-bottom:1px solid var(--border);display:flex;justify-content:space-between;align-items:center;">
                <h2 style="font-size:1rem;font-weight:700;">Recent Bookings</h2>
                <a href="bookings.jsp" style="font-size:0.85rem;color:var(--accent-teal);">View All →</a>
            </div>
            <%
                java.util.List<com.eventhorizon.model.Booking> recentBookings = bs.getAllBookings();
                int showCount = Math.min(5, recentBookings.size());
                pageContext.setAttribute("recentBookings",
                    recentBookings.subList(Math.max(0, recentBookings.size() - showCount), recentBookings.size()));
            %>
            <table>
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Event</th>
                        <th>Tickets</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="b" items="${recentBookings}">
                        <tr>
                            <td style="font-family:'Orbitron',monospace;font-size:0.78rem;color:var(--accent-teal);">${b.bookingId}</td>
                            <td>${b.eventTitle}</td>
                            <td>${b.numberOfTickets}</td>
                            <td>LKR ${b.totalAmount}</td>
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
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentBookings}">
                        <tr><td colspan="5" style="text-align:center;color:var(--text-muted);padding:32px;">No bookings yet.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>
    </main>
</div>

<script src="../js/main.js"></script>
</body>
</html>
