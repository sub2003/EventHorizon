<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%@ page import="com.eventhorizon.service.EventService" %>
<%@ page import="com.eventhorizon.service.BookingService" %>
<%@ page import="com.eventhorizon.model.Booking" %>
<%@ page import="java.util.List" %>

<%
    // 🔒 Prevent browser caching (FIX logout issue)
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // 🔒 Admin authentication check
    if (session.getAttribute("userId") == null ||
        !"ADMIN".equals(session.getAttribute("role"))) {

        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    UserService userService = new UserService();
    EventService eventService = new EventService();
    BookingService bookingService = new BookingService();

    int totalUsers = userService.getAllUsers().size();
    int totalEvents = eventService.getAllEvents().size();
    int activeEvents = eventService.getActiveEvents().size();
    List<Booking> recentBookings = bookingService.getAllBookings();
    int totalBookings = recentBookings.size();

    String adminName = (String) session.getAttribute("userName");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard - EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<div class="admin-layout">

    <aside class="admin-sidebar">
        <div class="admin-sidebar-brand">
            <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
        </div>

        <div class="admin-sidebar-section">
            <div class="admin-sidebar-title">ADMIN PANEL</div>

            <a href="${pageContext.request.contextPath}/admin/dashboard.jsp" class="sidebar-link active">
                <span>📊</span> Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link">
                <span>🎟️</span> Manage Events
            </a>

            <a href="${pageContext.request.contextPath}/admin/bookings.jsp" class="sidebar-link">
                <span>📋</span> All Bookings
            </a>

            <a href="${pageContext.request.contextPath}/user?action=list" class="sidebar-link">
                <span>👥</span> Manage Users
            </a>

            <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link">
                <span>➕</span> Add New Event
            </a>
        </div>
    </aside>

    <main class="admin-main">

        <div class="admin-topbar">
            <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-outline btn-sm">← Public Site</a>
            <div style="display:flex; align-items:center; gap:16px;">
                <span style="color:var(--text-muted);">Welcome back, <%= adminName %></span>
                <a href="${pageContext.request.contextPath}/user?action=logout" class="btn btn-primary btn-sm">Logout</a>
            </div>
        </div>

        <div class="section-header" style="align-items:flex-start;">
            <h2 class="section-title">📊 <span>Dashboard</span></h2>
        </div>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-icon">👥</div>
                <div>
                    <div class="stat-number"><%= totalUsers %></div>
                    <div class="stat-label">Registered Users</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">🎟️</div>
                <div>
                    <div class="stat-number"><%= totalEvents %></div>
                    <div class="stat-label">Total Events</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">✅</div>
                <div>
                    <div class="stat-number"><%= activeEvents %></div>
                    <div class="stat-label">Active Events</div>
                </div>
            </div>

            <div class="stat-card">
                <div class="stat-icon">📋</div>
                <div>
                    <div class="stat-number"><%= totalBookings %></div>
                    <div class="stat-label">Total Bookings</div>
                </div>
            </div>
        </div>

        <div class="card" style="padding:24px; margin-bottom:24px;">
            <h3 style="margin-bottom:18px;">QUICK ACTIONS</h3>
            <div style="display:flex; flex-wrap:wrap; gap:12px;">
                <a href="${pageContext.request.contextPath}/event?action=adminList" class="btn btn-primary">
                    ➕ Add New Event
                </a>

                <a href="${pageContext.request.contextPath}/event?action=adminList" class="btn btn-outline">
                    🎟️ Manage Events
                </a>

                <a href="${pageContext.request.contextPath}/admin/bookings.jsp" class="btn btn-outline">
                    📋 View Bookings
                </a>

                <a href="${pageContext.request.contextPath}/user?action=list" class="btn btn-outline">
                    👥 View Users
                </a>
            </div>
        </div>

        <div class="card" style="padding:24px;">
            <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:18px;">
                <h3>Recent Bookings</h3>
                <a href="${pageContext.request.contextPath}/admin/bookings.jsp" class="btn btn-outline btn-sm">View All →</a>
            </div>

            <%
                if (recentBookings != null && !recentBookings.isEmpty()) {
            %>
            <div style="overflow-x:auto;">
                <table class="table" style="width:100%;">
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
                    <%
                        int count = 0;
                        for (Booking booking : recentBookings) {
                            if (count >= 5) break;
                    %>
                    <tr>
                        <td><%= booking.getBookingId() %></td>
                        <td><%= booking.getEventTitle() %></td>
                        <td><%= booking.getNumberOfTickets() %></td>
                        <td>LKR <%= booking.getTotalAmount() %></td>
                        <td>
                            <span class="status-badge"><%= booking.getStatus() %></span>
                        </td>
                    </tr>
                    <%
                            count++;
                        }
                    %>
                    </tbody>
                </table>
            </div>
            <%
                } else {
            %>
            <div class="empty-state">
                <span class="emoji">📭</span>
                <h3>No Bookings Yet</h3>
                <p>Bookings will appear here once customers start booking tickets.</p>
            </div>
            <%
                }
            %>
        </div>

    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>