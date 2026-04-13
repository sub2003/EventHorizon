<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%
    // Prevent browser cache after logout
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    // User must be logged in
    if (session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Bookings – EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>

    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list">Events</a></li>
        <li><a href="${pageContext.request.contextPath}/booking?action=myBookings" class="active">My Bookings</a></li>
        <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
        <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
    </ul>
</nav>

<div class="container">
    <div class="page-header">
        <h1 class="page-title">🎟️ My Bookings</h1>
        <a href="${pageContext.request.contextPath}/event?action=list" class="btn btn-outline">
            Browse More Events
        </a>
    </div>

    <c:if test="${param.msg == 'booked'}">
        <div class="alert alert-success" data-auto-dismiss>
            ✅ Booking confirmed! Your tickets are reserved.
        </div>
    </c:if>

    <c:if test="${param.msg == 'cancelled'}">
        <div class="alert alert-info" data-auto-dismiss>
            🔄 Booking has been cancelled successfully.
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty bookings}">
            <div class="table-wrapper">
                <table class="table" style="width:100%;">
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

                                <td style="font-weight:600;">
                                    ${b.eventTitle}
                                </td>

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
                                    <c:choose>
                                        <c:when test="${b.status == 'CONFIRMED'}">
                                            <form action="${pageContext.request.contextPath}/booking"
                                                  method="post"
                                                  style="display:inline;">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="bookingId" value="${b.bookingId}">
                                                <button type="submit"
                                                        class="btn btn-danger btn-sm"
                                                        onclick="return confirm('Cancel this booking?');">
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
                    </tbody>
                </table>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-state">
                <span class="emoji">🎭</span>
                <h3>No Bookings Yet</h3>
                <p>You haven't booked any tickets. Explore our events!</p>
                <a href="${pageContext.request.contextPath}/event?action=list"
                   class="btn btn-primary"
                   style="margin-top:16px;">
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

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>