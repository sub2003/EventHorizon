<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Events – EventHorizon</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">

    <style>
        .search-panel {
            max-width: 980px;
            margin: 28px auto 36px auto;
            padding: 18px;
            border-radius: 22px;
            background: rgba(20, 20, 58, 0.72);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 0 24px rgba(124, 58, 237, 0.16);
            backdrop-filter: blur(10px);
            animation: fadeSlideDown 0.7s ease;
        }

        .search-form {
            display: flex;
            gap: 14px;
            justify-content: center;
            align-items: center;
            flex-wrap: wrap;
        }

        .search-input,
        .search-select {
            background: rgba(255,255,255,0.04);
            color: white;
            border: 1px solid rgba(255,255,255,0.09);
            border-radius: 14px;
            padding: 14px 16px;
            font-size: 15px;
            outline: none;
            transition: all 0.25s ease;
        }

        .search-input {
            flex: 1;
            min-width: 280px;
            max-width: 430px;
        }

        .search-select {
            min-width: 220px;
            cursor: pointer;
        }

        .search-input:focus,
        .search-select:focus {
            border-color: rgba(34, 211, 238, 0.75);
            box-shadow: 0 0 0 4px rgba(34, 211, 238, 0.10);
            transform: translateY(-1px);
        }

        .search-btn {
            border: none;
            border-radius: 14px;
            padding: 14px 26px;
            font-size: 15px;
            font-weight: 700;
            color: white;
            cursor: pointer;
            background: linear-gradient(90deg, #7c3aed, #9333ea, #06b6d4);
            background-size: 200% 200%;
            transition: transform 0.2s ease, box-shadow 0.25s ease;
            animation: gradientMove 4s ease infinite;
        }

        .search-btn:hover {
            transform: translateY(-2px) scale(1.02);
            box-shadow: 0 10px 24px rgba(124, 58, 237, 0.35);
        }

        .filter-summary {
            text-align: center;
            margin: 0 0 22px 0;
            color: var(--text-muted);
            font-size: 0.95rem;
            animation: fadeIn 0.6s ease;
        }

        .filter-summary strong {
            color: white;
        }

        .clear-link {
            color: var(--accent-teal);
            text-decoration: none;
            font-weight: 600;
            margin-left: 6px;
        }

        .events-grid .card {
            animation: fadeUp 0.6s ease both;
            transition: transform 0.28s ease, box-shadow 0.28s ease;
        }

        .events-grid .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 16px 35px rgba(0,0,0,0.28);
        }

        .card-img-placeholder img,
        .card-img-placeholder div {
            transition: transform 0.4s ease;
        }

        .card:hover .card-img-placeholder img,
        .card:hover .card-img-placeholder div {
            transform: scale(1.04);
        }

        .empty-state {
            animation: fadeIn 0.7s ease;
        }

        @keyframes fadeSlideDown {
            from {
                opacity: 0;
                transform: translateY(-18px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeUp {
            from {
                opacity: 0;
                transform: translateY(24px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to   { opacity: 1; }
        }

        @keyframes gradientMove {
            0%   { background-position: 0% 50%; }
            50%  { background-position: 100% 50%; }
            100% { background-position: 0% 50%; }
        }

        @media (max-width: 768px) {
            .search-panel {
                padding: 14px;
                border-radius: 18px;
            }

            .search-input,
            .search-select,
            .search-btn {
                width: 100%;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/index.jsp" class="navbar-brand">⬡ EVENTHORIZON</a>
    <div class="hamburger"><span></span><span></span><span></span></div>

    <ul class="navbar-links">
        <li><a href="${pageContext.request.contextPath}/index.jsp">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/event?action=list" class="active">Events</a></li>

        <c:choose>
            <c:when test="${not empty sessionScope.userId}">
                <c:if test="${sessionScope.role == 'ADMIN'}">
                    <li><a href="${pageContext.request.contextPath}/event?action=adminList">Admin Panel</a></li>
                </c:if>
                <li><a href="${pageContext.request.contextPath}/booking?action=myBookings">My Bookings</a></li>
                <li><a href="${pageContext.request.contextPath}/profile.jsp">Profile</a></li>
                <li><a href="${pageContext.request.contextPath}/user?action=logout" class="btn-nav">Logout</a></li>
            </c:when>
            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login.jsp">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register.jsp" class="btn-nav">Sign Up</a></li>
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

    <div class="search-panel">
        <form action="${pageContext.request.contextPath}/event" method="get" class="search-form">
            <input type="hidden" name="action" value="list">

            <input type="text"
                   name="keyword"
                   class="search-input"
                   placeholder="Search by title or venue..."
                   value="${keyword}">

            <select name="category" class="search-select">
                <option value="">All Categories</option>
                <option value="Concert" ${category == 'Concert' ? 'selected' : ''}>Concert</option>
                <option value="Sports" ${category == 'Sports' ? 'selected' : ''}>Sports</option>
                <option value="Technology" ${category == 'Technology' ? 'selected' : ''}>Technology</option>
                <option value="Cultural" ${category == 'Cultural' ? 'selected' : ''}>Cultural</option>
                <option value="Theater" ${category == 'Theater' ? 'selected' : ''}>Theater</option>
                <option value="Comedy" ${category == 'Comedy' ? 'selected' : ''}>Comedy</option>
            </select>

            <button type="submit" class="search-btn">🔍 Search</button>
        </form>
    </div>

    <c:if test="${not empty keyword or not empty category}">
        <div class="filter-summary">
            Showing results
            <c:if test="${not empty keyword}">
                for <strong>${keyword}</strong>
            </c:if>
            <c:if test="${not empty category}">
                in <strong>${category}</strong>
            </c:if>
            <a href="${pageContext.request.contextPath}/event?action=list" class="clear-link">Clear Filters</a>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${not empty events}">
            <div class="events-grid">
                <c:forEach var="event" items="${events}" varStatus="status">
                    <div class="card" style="animation-delay:${status.index * 0.08}s;">

                        <div class="card-img-placeholder" style="overflow:hidden;">
                            <c:choose>
                                <c:when test="${not empty event.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${event.imagePath}"
                                         alt="${event.title}"
                                         style="width:100%; height:220px; object-fit:cover; display:block;">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:100%; height:220px; display:flex; align-items:center; justify-content:center; font-size:3rem;">
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
                                </c:otherwise>
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

                            <c:if test="${not empty event.description}">
                                <p style="color:var(--text-muted); margin-top:10px; font-size:0.9rem; line-height:1.5;">
                                    ${event.description}
                                </p>
                            </c:if>

                            <div class="seats-bar">
                                <div class="seats-bar-fill"
                                     data-pct="${(event.availableSeats * 100) / event.totalSeats}">
                                </div>
                            </div>
                        </div>

                        <div class="card-footer">
                            <div class="price">LKR ${event.ticketPrice}</div>
                            <a href="${pageContext.request.contextPath}/event?action=view&id=${event.eventId}"
                               class="btn btn-primary btn-sm">
                                View Details
                            </a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:when>

        <c:otherwise>
            <div class="empty-state">
                <span class="emoji">🔭</span>
                <h3>No Events Found</h3>
                <p>Try a different title, venue, or category.</p>
                <a href="${pageContext.request.contextPath}/event?action=list"
                   class="btn btn-outline"
                   style="margin-top:16px;">
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

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>