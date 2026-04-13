<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.eventhorizon.service.EventService, com.eventhorizon.model.Event" %>

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

    String eventId = request.getParameter("id");
    EventService es = new EventService();
    Event event = es.getEventById(eventId);

    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/event?action=adminList");
        return;
    }

    pageContext.setAttribute("ev", event);
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event – EventHorizon Admin</title>
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

        <a href="${pageContext.request.contextPath}/event?action=adminList" class="sidebar-link active">
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
    </aside>

    <main class="admin-content">
        <div class="page-header">
            <h1 class="page-title">✏️ Edit Event</h1>
            <a href="${pageContext.request.contextPath}/event?action=adminList" class="btn btn-outline">
                ← Back to Events
            </a>
        </div>

        <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius);padding:36px;max-width:720px;">

            <form action="${pageContext.request.contextPath}/event"
                  method="post"
                  enctype="multipart/form-data"
                  class="needs-validation">

                <input type="hidden" name="action" value="update">
                <input type="hidden" name="eventId" value="${ev.eventId}">

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">

                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label" for="title">Event Title *</label>
                        <input type="text"
                               id="title"
                               name="title"
                               class="form-control"
                               value="${ev.title}"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="category">Category *</label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="Concert" ${ev.category=='Concert' ? 'selected' : ''}>Concert</option>
                            <option value="Sports" ${ev.category=='Sports' ? 'selected' : ''}>Sports</option>
                            <option value="Technology" ${ev.category=='Technology' ? 'selected' : ''}>Technology</option>
                            <option value="Cultural" ${ev.category=='Cultural' ? 'selected' : ''}>Cultural</option>
                            <option value="Theater" ${ev.category=='Theater' ? 'selected' : ''}>Theater</option>
                            <option value="Comedy" ${ev.category=='Comedy' ? 'selected' : ''}>Comedy</option>
                            <option value="Art" ${ev.category=='Art' ? 'selected' : ''}>Art</option>
                            <option value="Food" ${ev.category=='Food' ? 'selected' : ''}>Food & Dining</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="venue">Venue *</label>
                        <input type="text"
                               id="venue"
                               name="venue"
                               class="form-control"
                               value="${ev.venue}"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="date">Date *</label>
                        <input type="date"
                               id="date"
                               name="date"
                               class="form-control"
                               value="${ev.date}"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="time">Time *</label>
                        <input type="time"
                               id="time"
                               name="time"
                               class="form-control"
                               value="${ev.time}"
                               required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="ticketPrice">Ticket Price (LKR) *</label>
                        <input type="number"
                               id="ticketPrice"
                               name="ticketPrice"
                               class="form-control"
                               value="${ev.ticketPrice}"
                               step="0.01"
                               min="0"
                               required>
                    </div>

                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label">Current Image</label>
                        <div style="margin-top:8px;">
                            <c:choose>
                                <c:when test="${not empty ev.imagePath}">
                                    <img src="${pageContext.request.contextPath}/${ev.imagePath}"
                                         alt="${ev.title}"
                                         style="width:220px;height:140px;object-fit:cover;border-radius:10px;border:1px solid var(--border);">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:220px;height:140px;display:flex;align-items:center;justify-content:center;border:1px solid var(--border);border-radius:10px;background:rgba(255,255,255,0.03);font-size:2rem;">
                                        🎟️
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label" for="eventImage">Replace Image (optional)</label>
                        <input type="file"
                               id="eventImage"
                               name="eventImage"
                               class="form-control"
                               accept="image/*">
                    </div>

                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label" for="description">Description *</label>
                        <textarea id="description"
                                  name="description"
                                  class="form-control"
                                  rows="4"
                                  required>${ev.description}</textarea>
                    </div>
                </div>

                <div style="background:rgba(6,182,212,0.08);border:1px solid rgba(6,182,212,0.2);border-radius:8px;padding:14px;margin-bottom:20px;">
                    <span style="font-size:0.85rem;color:var(--text-muted);">
                        💺 Current seats:
                        <strong style="color:var(--accent-teal);">
                            ${ev.availableSeats} available / ${ev.totalSeats} total
                        </strong>
                        &nbsp;|&nbsp;
                        Status: <strong>${ev.status}</strong>
                    </span>
                </div>

                <div style="display:flex;gap:12px;">
                    <button type="submit" class="btn btn-primary">💾 Save Changes</button>
                    <a href="${pageContext.request.contextPath}/event?action=adminList" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="${pageContext.request.contextPath}/js/main.js"></script>
</body>
</html>