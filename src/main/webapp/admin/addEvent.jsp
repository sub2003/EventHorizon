<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect("../login.jsp"); return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event – EventHorizon Admin</title>
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
    <aside class="sidebar">
        <div class="sidebar-title">Admin Panel</div>
        <a href="dashboard.jsp" class="sidebar-link"><span>📊</span> Dashboard</a>
        <a href="events.jsp"    class="sidebar-link"><span>🎟️</span> Manage Events</a>
        <a href="bookings.jsp"  class="sidebar-link"><span>📋</span> All Bookings</a>
        <a href="users.jsp"     class="sidebar-link"><span>👥</span> Manage Users</a>
        <a href="addEvent.jsp"  class="sidebar-link active"><span>➕</span> Add New Event</a>
    </aside>

    <main class="admin-content">
        <div class="page-header">
            <h1 class="page-title">➕ Add New Event</h1>
            <a href="events.jsp" class="btn btn-outline">← Back to Events</a>
        </div>

        <div style="background:var(--bg-card);border:1px solid var(--border);border-radius:var(--radius);padding:36px;max-width:720px;">
            <form action="../event" method="post" class="needs-validation">
                <input type="hidden" name="action" value="add">

                <div style="display:grid;grid-template-columns:1fr 1fr;gap:20px;">
                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label" for="title">Event Title *</label>
                        <input type="text" id="title" name="title"
                               class="form-control" placeholder="e.g. Coldplay World Tour 2026" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="category">Category *</label>
                        <select id="category" name="category" class="form-control" required>
                            <option value="">Select Category</option>
                            <option value="Concert">🎵 Concert</option>
                            <option value="Sports">⚽ Sports</option>
                            <option value="Technology">💻 Technology</option>
                            <option value="Cultural">🎭 Cultural</option>
                            <option value="Theater">🎬 Theater</option>
                            <option value="Comedy">😂 Comedy</option>
                            <option value="Art">🎨 Art</option>
                            <option value="Food">🍽️ Food & Dining</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="venue">Venue *</label>
                        <input type="text" id="venue" name="venue"
                               class="form-control" placeholder="e.g. Colombo Stadium" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="date">Date *</label>
                        <input type="date" id="date" name="date"
                               class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="time">Time *</label>
                        <input type="time" id="time" name="time"
                               class="form-control" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="ticketPrice">Ticket Price (LKR) *</label>
                        <input type="number" id="ticketPrice" name="ticketPrice"
                               class="form-control" placeholder="1500.00"
                               step="0.01" min="0" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="totalSeats">Total Seats *</label>
                        <input type="number" id="totalSeats" name="totalSeats"
                               class="form-control" placeholder="500"
                               min="1" required>
                    </div>

                    <div class="form-group" style="grid-column:1/-1;">
                        <label class="form-label" for="description">Description *</label>
                        <textarea id="description" name="description"
                                  class="form-control" rows="4"
                                  placeholder="Describe the event..." required></textarea>
                    </div>
                </div>

                <div style="display:flex;gap:12px;margin-top:8px;">
                    <button type="submit" class="btn btn-primary">🚀 Create Event</button>
                    <a href="events.jsp" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </main>
</div>

<script src="../js/main.js"></script>
</body>
</html>
