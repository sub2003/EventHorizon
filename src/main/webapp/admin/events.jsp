<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="index.jsp">Home</a></li>
        <li><a href="event?action=list" class="active">Events</a></li>
        <c:choose>
            <c:when test="${not empty sessionScope.userId}">
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <li><a href="admin/dashboard.jsp">Admin Panel</a></li>
                </c:if>
                <li><a href="booking?action=myBookings">My Bookings</a></li>
                <li><a href="profile.jsp">Profile</a></li>
                <li><a href="user?action=logout" class="btn-nav">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="login.jsp">Login</a></li>
                <li><a href="register.jsp" class="btn-nav">Sign Up</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<div class="container">
    <div class="section-header">
        <h2 class="section-title">Upcoming <span>Events</span></h2>
        <div class="section-divider"></div>
        <p style="color:var(--text-muted);margin-top:12px;font-size:0.95rem;">
            Browse and book tickets for the hottest events in Sri Lanka
        </p>
    </div>

    <!-- Search Bar -->
    <form action="event" method="get" class="search-bar">
        <input type="hidden" name="action" value="search">
        <input type="text" name="q" placeholder="Search by title, category, venue..."
               value="${keyword}" id="liveSearch">
        <button type="submit">🔍 Search</button>
    </form>

    <c:choose>
        <c:when test="${not empty events}">
            <div class="events-grid">
                <c:forEach var="event" items="${events}">
                    <div class="card">
                        <!-- Category icon placeholder -->
                        <div class="card-img-placeholder">
                            <c:choose>
                                <c:when test="${event.category == 'Concert'}">🎵</c:when>
                                <c:when test="${event.category == 'Sports'}">⚽</c:when>
                                <c:when test="${event.category == 'Technology'}">💻</c:when>
                                <c:when test="${event.category == 'Cultural'}">🎭</c:when>
                                <c:when test="${event.category == 'Theater'}">🎬</c:when>
                                <c:when test="${event.category == 'Comedy'}">😂</c:when>
                                <c:otherwise>🎟️</c:otherwise>
                            </c:choose>
                        </div>
                        <div class="card-body">
                            <div class="card-category">${event.category}</div>
                            <div class="card-title">${event.title}</div>
                            <div class="card-meta">
                                <span>📅 ${event.date} at ${event.time}</span>
                                <span>📍 ${event.venue}</span>
                                <span>💺 ${event.availableSeats} seats left</span>
                            </div>
                            <!-- Seats availability bar -->
                            <div class="seats-bar">
                                <div class="seats-bar-fill"
                                     data-pct="${(event.availableSeats * 100) / event.totalSeats}">
                                </div>
                            </div>
                        </div>
                        <div class="card-footer">
                            <div class="price">LKR ${event.ticketPrice}</div>
                            <a href="event?action=view&id=${event.eventId}"
                               class="btn btn-primary btn-sm">View Details</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>
        <c:otherwise>
            <div class="empty-state">
                <span class="emoji">🔭</span>
                <h3>No Events Found</h3>
                <p>Try a different search term or check back later.</p>
                <a href="event?action=list" class="btn btn-outline" style="margin-top:16px;">
                    Show All Events
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
