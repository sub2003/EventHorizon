<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>EventHorizon – Book Your Experience</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<!-- ===== NAVBAR ===== -->
<nav class="navbar">
    <a href="index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>
    <ul class="navbar-links">
        <li><a href="index.jsp" class="active">Home</a></li>
        <li><a href="event?action=list">Events</a></li>
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

<!-- ===== HERO ===== -->
<section class="hero">
    <h1 class="hero-title">Experience the<br>Extraordinary</h1>
    <p class="hero-subtitle">
        Discover concerts, sports events, tech summits and cultural shows.
        Book your tickets in seconds.
    </p>
    <div class="hero-actions">
        <a href="event?action=list" class="btn btn-primary">🎟️ Browse Events</a>
        <c:if test="${empty sessionScope.userId}">
            <a href="register.jsp" class="btn btn-outline">Create Account</a>
        </c:if>
    </div>
</section>

<!-- ===== FEATURES ===== -->
<section style="padding: 60px 0; background: rgba(255,255,255,0.02);">
    <div class="container">
        <div class="section-header">
            <h2 class="section-title">Why <span>EventHorizon?</span></h2>
            <div class="section-divider"></div>
        </div>
        <div style="display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:24px;margin-top:40px;">
            <div class="card" style="padding:28px;text-align:center;">
                <div style="font-size:2.5rem;margin-bottom:14px;">⚡</div>
                <h3 style="margin-bottom:8px;font-size:1.1rem;">Instant Booking</h3>
                <p style="color:var(--text-muted);font-size:0.9rem;">Reserve your seat in real-time. No waiting, no delays.</p>
            </div>
            <div class="card" style="padding:28px;text-align:center;">
                <div style="font-size:2.5rem;margin-bottom:14px;">🔒</div>
                <h3 style="margin-bottom:8px;font-size:1.1rem;">Secure & Safe</h3>
                <p style="color:var(--text-muted);font-size:0.9rem;">Your data is encrypted and your bookings are guaranteed.</p>
            </div>
            <div class="card" style="padding:28px;text-align:center;">
                <div style="font-size:2.5rem;margin-bottom:14px;">🎭</div>
                <h3 style="margin-bottom:8px;font-size:1.1rem;">All Categories</h3>
                <p style="color:var(--text-muted);font-size:0.9rem;">Concerts, sports, tech, culture – something for everyone.</p>
            </div>
            <div class="card" style="padding:28px;text-align:center;">
                <div style="font-size:2.5rem;margin-bottom:14px;">📱</div>
                <h3 style="margin-bottom:8px;font-size:1.1rem;">Easy to Use</h3>
                <p style="color:var(--text-muted);font-size:0.9rem;">Clean interface that works beautifully on any device.</p>
            </div>
        </div>
    </div>
</section>

<!-- ===== FOOTER ===== -->
<footer class="footer">
    <div class="footer-brand">⬡ EVENTHORIZON</div>
    <p>SE1020 – Object Oriented Programming Project &copy; 2026</p>
</footer>

<script src="js/main.js"></script>
</body>
</html>
