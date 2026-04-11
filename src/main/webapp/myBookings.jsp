<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%-- Security: redirect if not logged in --%>
<%
    if (session.getAttribute("userId") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="event?action=list">Events</a></li>
        <li><a href="booking?action=myBookings" class="active">My Bookings</a></li>
        <li><a href="profile.jsp">Profile</a></li>
        <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="container">
    <div class="page-header">
        <h1 class="page-title">🎟️ My Bookings</h1>
        <a href="event?action=list" class="btn btn-outline">Browse More Events</a>
    </div>

    <% if ("booked".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-success" data-auto-dismiss>
            ✅ Booking confirmed! Your tickets are reserved.
        </div>
    <% } %>
    <% if ("cancelled".equals(request.getParameter("msg"))) { %>
        <div class="alert alert-info" data-auto-dismiss>
            🔄 Booking has been cancelled successfully.
        </div>
    <% } %>

    <c:choose>
        <c:when test="${not empty bookings}">
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>Booking ID</th>
                            <th>Event</th>
                            <th>Tickets</th>
                            <th>Total Paid</th>
                            <th>Date</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                            <tr>
                                <td style="font-family:'Orbitron',monospace;font-size:0.8rem;color:var(--accent-teal);">
                                    ${b.bookingId}
                                </td>
                                <td style="font-weight:600;">${b.eventTitle}</td>
                                <td>${b.numberOfTickets}</td>
                                <td style="font-weight:600;color:var(--accent-teal);">
                                    LKR ${b.totalAmount}
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
                                    <c:if test="${b.status == 'CONFIRMED'}">
                                        <form action="booking" method="post"
                                              style="display:inline;">
                                            <input type="hidden" name="action" value="cancel">
                                            <input type="hidden" name="bookingId" value="${b.bookingId}">
                                            <button type="submit" class="btn btn-danger btn-sm"
                                                    data-confirm-delete="Cancel this booking?">
                                                Cancel
                                            </button>
                                        </form>
                                    </c:if>
                                    <c:if test="${b.status == 'CANCELLED'}">
                                        <span style="color:var(--text-muted);font-size:0.8rem;">—</span>
                                    </c:if>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <span class="emoji">🎭</span>
                <h3>No Bookings Yet</h3>
                <p>You haven't booked any tickets. Explore our events!</p>
                <a href="event?action=list" class="btn btn-primary" style="margin-top:16px;">
                    Browse Events
                </a>
            </div>
        </c:otherwise>
    </c:choose>
</div>

<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
