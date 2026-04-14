<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Event" %>
<%
    Object roleObj = session.getAttribute("role");
    if (roleObj == null || !"ADMIN".equals(roleObj.toString())) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Event> events = (List<Event>) request.getAttribute("events");
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Events - EventHorizon Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-primary: #0b1020;
            --bg-secondary: #121a2f;
            --bg-card: rgba(18, 26, 47, 0.92);
            --bg-card-2: rgba(14, 22, 41, 0.92);
            --bg-hover: rgba(255, 255, 255, 0.03);
            --border: rgba(255, 255, 255, 0.08);
            --border-strong: rgba(255, 255, 255, 0.15);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --text-muted: #64748b;
            --accent: #4f46e5;
            --accent-light: #6366f1;
            --accent-soft: rgba(99, 102, 241, 0.18);
            --cyan: #06b6d4;
            --cyan-soft: rgba(6, 182, 212, 0.18);
            --success: #10b981;
            --success-soft: rgba(16, 185, 129, 0.18);
            --danger: #ef4444;
            --danger-soft: rgba(239, 68, 68, 0.16);
            --warning: #f59e0b;
            --warning-soft: rgba(245, 158, 11, 0.16);
            --shadow: 0 20px 45px rgba(0, 0, 0, 0.35);
            --radius-xl: 26px;
            --radius-lg: 22px;
            --radius-md: 16px;
            --radius-sm: 12px;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-primary);
            background:
                radial-gradient(circle at top left, rgba(79, 70, 229, 0.22), transparent 28%),
                radial-gradient(circle at top right, rgba(6, 182, 212, 0.12), transparent 22%),
                linear-gradient(135deg, #090d1a 0%, #0f172a 45%, #111827 100%);
            min-height: 100vh;
        }

        .page {
            max-width: 1550px;
            margin: 0 auto;
            padding: 34px 24px 48px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 20px;
            flex-wrap: wrap;
            margin-bottom: 28px;
        }

        .title-block h1 {
            font-size: 42px;
            font-weight: 800;
            line-height: 1.1;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #ffffff;
        }

        .title-block p {
            font-size: 19px;
            color: var(--text-secondary);
        }

        .header-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
        }

        .btn,
        button {
            border: none;
            outline: none;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 18px;
            border-radius: 14px;
            font-size: 14px;
            font-weight: 700;
            transition: 0.25s ease;
        }

        .btn-outline {
            color: var(--text-primary);
            background: rgba(255, 255, 255, 0.05);
            border: 1px solid var(--border-strong);
            backdrop-filter: blur(12px);
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
            transform: translateY(-1px);
        }

        .btn-primary {
            color: white;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(79, 70, 229, 0.35);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
            box-shadow: 0 18px 34px rgba(79, 70, 229, 0.45);
        }

        .panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow);
            backdrop-filter: blur(16px);
            overflow: hidden;
            margin-bottom: 24px;
        }

        .panel-head {
            padding: 22px 24px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.02);
        }

        .panel-head h2 {
            font-size: 24px;
            font-weight: 800;
            color: #ffffff;
        }

        .panel-head p {
            margin-top: 6px;
            color: var(--text-secondary);
            font-size: 15px;
        }

        .panel-body {
            padding: 24px;
        }

        .alert-wrap {
            margin-bottom: 18px;
        }

        .alert {
            border-radius: 16px;
            padding: 16px 18px;
            font-size: 15px;
            font-weight: 700;
            border: 1px solid transparent;
            margin-bottom: 12px;
        }

        .alert-success {
            background: var(--success-soft);
            color: #a7f3d0;
            border-color: rgba(16, 185, 129, 0.35);
        }

        .alert-error {
            background: var(--danger-soft);
            color: #fecaca;
            border-color: rgba(239, 68, 68, 0.35);
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(3, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .form-group.span-2 {
            grid-column: span 2;
        }

        .form-group.span-3 {
            grid-column: span 3;
        }

        .form-group label {
            font-size: 13px;
            font-weight: 800;
            color: #cbd5e1;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .form-group input,
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 13px 14px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(7, 13, 28, 0.9);
            color: white;
            font-size: 14px;
            outline: none;
            transition: 0.25s ease;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            border-color: rgba(99, 102, 241, 0.6);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .form-group input::placeholder,
        .form-group textarea::placeholder {
            color: #64748b;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
        }

        .btn-save {
            color: white;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(79, 70, 229, 0.28);
        }

        .btn-save:hover {
            transform: translateY(-1px);
        }

        .toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            padding: 22px 24px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.02);
        }

        .search-group {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            flex: 1;
        }

        .search-box {
            flex: 1;
            min-width: 280px;
        }

        .search-input,
        .filter-select {
            width: 100%;
            padding: 14px 16px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.1);
            background: rgba(7, 13, 28, 0.9);
            color: white;
            font-size: 14px;
            outline: none;
            transition: 0.25s ease;
        }

        .filter-select {
            min-width: 180px;
        }

        .search-input:focus,
        .filter-select:focus {
            border-color: rgba(99, 102, 241, 0.6);
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .result-count {
            font-size: 14px;
            color: var(--text-secondary);
            font-weight: 700;
            white-space: nowrap;
        }

        .table-wrap {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1380px;
        }

        thead th {
            text-align: left;
            padding: 22px 18px;
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #cbd5e1;
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid var(--border);
        }

        tbody td {
            padding: 22px 18px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            vertical-align: middle;
            color: var(--text-primary);
        }

        tbody tr.data-row {
            transition: 0.25s ease;
        }

        tbody tr.data-row:hover {
            background: var(--bg-hover);
        }

        .event-title {
            font-weight: 800;
            color: #ffffff;
            line-height: 1.45;
        }

        .event-meta {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 4px;
        }

        .muted {
            color: #cbd5e1;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 7px 12px;
            border-radius: 999px;
            font-size: 12px;
            font-weight: 800;
            letter-spacing: 0.4px;
            text-transform: uppercase;
        }

        .status-active {
            color: #a7f3d0;
            background: rgba(16, 185, 129, 0.18);
            border: 1px solid rgba(16, 185, 129, 0.28);
        }

        .status-cancelled {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.18);
            border: 1px solid rgba(239, 68, 68, 0.28);
        }

        .action-group {
            display: flex;
            align-items: center;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-edit {
            color: #67e8f9;
            background: rgba(6, 182, 212, 0.14);
            border: 1px solid rgba(6, 182, 212, 0.28);
            min-width: 90px;
        }

        .btn-edit:hover {
            background: rgba(6, 182, 212, 0.24);
        }

        .btn-cancel-event {
            color: #fde68a;
            background: rgba(245, 158, 11, 0.12);
            border: 1px solid rgba(245, 158, 11, 0.28);
            min-width: 90px;
        }

        .btn-cancel-event:hover {
            background: rgba(245, 158, 11, 0.22);
        }

        .btn-delete {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.16);
            border: 1px solid rgba(239, 68, 68, 0.28);
            min-width: 90px;
        }

        .btn-delete:hover {
            background: rgba(239, 68, 68, 0.26);
        }

        .empty-state,
        .no-results {
            padding: 34px 24px;
            text-align: center;
            color: var(--text-secondary);
            font-size: 17px;
        }

        .no-results {
            display: none;
            border-top: 1px solid var(--border);
        }

        @media (max-width: 1100px) {
            .form-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }

            .form-group.span-2,
            .form-group.span-3 {
                grid-column: span 2;
            }
        }

        @media (max-width: 720px) {
            .page {
                padding: 24px 14px 34px;
            }

            .title-block h1 {
                font-size: 32px;
            }

            .title-block p {
                font-size: 16px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

            .form-group.span-2,
            .form-group.span-3 {
                grid-column: span 1;
            }

            .toolbar {
                flex-direction: column;
                align-items: stretch;
            }

            .result-count {
                text-align: left;
            }
        }
    </style>

    <script>
        function filterEvents() {
            var searchValue = document.getElementById("eventSearch").value.toLowerCase().trim();
            var categoryValue = document.getElementById("categoryFilter").value.toLowerCase();
            var statusValue = document.getElementById("statusFilter").value.toLowerCase();

            var rows = document.querySelectorAll(".data-row");
            var visibleCount = 0;

            rows.forEach(function(row) {
                var title = (row.getAttribute("data-title") || "").toLowerCase();
                var category = (row.getAttribute("data-category") || "").toLowerCase();
                var date = (row.getAttribute("data-date") || "").toLowerCase();
                var time = (row.getAttribute("data-time") || "").toLowerCase();
                var venue = (row.getAttribute("data-venue") || "").toLowerCase();
                var status = (row.getAttribute("data-status") || "").toLowerCase();
                var eventId = (row.getAttribute("data-event-id") || "").toLowerCase();

                var matchesSearch =
                    title.includes(searchValue) ||
                    category.includes(searchValue) ||
                    date.includes(searchValue) ||
                    time.includes(searchValue) ||
                    venue.includes(searchValue) ||
                    status.includes(searchValue) ||
                    eventId.includes(searchValue);

                var matchesCategory = (categoryValue === "all" || category === categoryValue);
                var matchesStatus = (statusValue === "all" || status === statusValue);

                if (matchesSearch && matchesCategory && matchesStatus) {
                    row.style.display = "";
                    visibleCount++;
                } else {
                    row.style.display = "none";
                }
            });

            document.getElementById("resultCount").innerText = visibleCount + " event(s) found";

            var noResults = document.getElementById("noResults");
            noResults.style.display = visibleCount === 0 ? "block" : "none";
        }

        function clearFilters() {
            document.getElementById("eventSearch").value = "";
            document.getElementById("categoryFilter").value = "all";
            document.getElementById("statusFilter").value = "all";
            filterEvents();
        }

        function confirmDelete(title) {
            return confirm("Delete event: " + title + " ?");
        }

        function confirmCancel(title) {
            return confirm("Cancel event: " + title + " ?");
        }

        window.addEventListener("DOMContentLoaded", function() {
            filterEvents();
        });
    </script>
</head>
<body>
<div class="page">

    <div class="header">
        <div class="title-block">
            <h1>Manage Events</h1>
            <p>Add, search, edit, cancel, and delete events from one place</p>
        </div>

        <div class="header-actions">
            <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn btn-outline">Dashboard</a>
            <a href="<%=request.getContextPath()%>/event?action=adminList" class="btn btn-primary">Refresh</a>
        </div>
    </div>

    <div class="alert-wrap">
        <% if ("added".equals(msg)) { %>
            <div class="alert alert-success">Event added successfully.</div>
        <% } else if ("updated".equals(msg)) { %>
            <div class="alert alert-success">Event updated successfully.</div>
        <% } else if ("deleted".equals(msg)) { %>
            <div class="alert alert-success">Event deleted successfully.</div>
        <% } else if ("cancelled".equals(msg)) { %>
            <div class="alert alert-success">Event cancelled successfully.</div>
        <% } %>

        <% if ("addFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to add event. Check all required fields.</div>
        <% } else if ("updateFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to update event.</div>
        <% } else if ("deleteFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to delete event.</div>
        <% } else if ("cancelFailed".equals(error)) { %>
            <div class="alert alert-error">Failed to cancel event.</div>
        <% } %>
    </div>

    <div class="panel">
        <div class="panel-head">
            <h2>Add New Event</h2>
            <p>Create a new event using the same premium admin style</p>
        </div>

        <div class="panel-body">
            <form action="<%=request.getContextPath()%>/event" method="post">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required placeholder="Enter event title">
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" required>
                            <option value="">Select Category</option>
                            <option value="Concert">Concert</option>
                            <option value="Technology">Technology</option>
                            <option value="Sports">Sports</option>
                            <option value="Cultural">Cultural</option>
                            <option value="Music">Music</option>
                            <option value="Conference">Conference</option>
                            <option value="Workshop">Workshop</option>
                            <option value="Exhibition">Exhibition</option>
                            <option value="Festival">Festival</option>
                            <option value="Seminar">Seminar</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" name="date" required>
                    </div>

                    <div class="form-group">
                        <label>Time</label>
                        <input type="time" name="time" required>
                    </div>

                    <div class="form-group">
                        <label>Venue</label>
                        <input type="text" name="venue" required placeholder="Enter venue">
                    </div>

                    <div class="form-group">
                        <label>Price</label>
                        <input type="number" name="price" step="0.01" min="0" required placeholder="0.00">
                    </div>

                    <div class="form-group">
                        <label>Total Seats</label>
                        <input type="number" name="totalSeats" min="1" required placeholder="Enter seat count">
                    </div>

                    <div class="form-group">
                        <label>Available Seats</label>
                        <input type="number" name="availableSeats" min="0" required placeholder="Enter available seats">
                    </div>

                    <div class="form-group span-3">
                        <label>Description</label>
                        <textarea name="description" required placeholder="Write the event description"></textarea>
                    </div>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-save">Add Event</button>
                </div>
            </form>
        </div>
    </div>

    <div class="panel">
        <div class="toolbar">
            <div class="search-group">
                <div class="search-box">
                    <input
                        type="text"
                        id="eventSearch"
                        class="search-input"
                        placeholder="Search by title, category, venue, date, time, status, or event ID..."
                        onkeyup="filterEvents()">
                </div>

                <select id="categoryFilter" class="filter-select" onchange="filterEvents()">
                    <option value="all">All Categories</option>
                    <option value="Concert">Concert</option>
                    <option value="Technology">Technology</option>
                    <option value="Sports">Sports</option>
                    <option value="Cultural">Cultural</option>
                    <option value="Music">Music</option>
                    <option value="Conference">Conference</option>
                    <option value="Workshop">Workshop</option>
                    <option value="Exhibition">Exhibition</option>
                    <option value="Festival">Festival</option>
                    <option value="Seminar">Seminar</option>
                </select>

                <select id="statusFilter" class="filter-select" onchange="filterEvents()">
                    <option value="all">All Status</option>
                    <option value="ACTIVE">Active</option>
                    <option value="CANCELLED">Cancelled</option>
                </select>

                <button type="button" class="btn btn-outline" onclick="clearFilters()">Clear</button>
            </div>

            <div class="result-count" id="resultCount">0 event(s) found</div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Venue</th>
                    <th>Price</th>
                    <th>Total Seats</th>
                    <th>Available</th>
                    <th>Status</th>
                    <th style="min-width: 230px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (events == null || events.isEmpty()) { %>
                    <tr>
                        <td colspan="10">
                            <div class="empty-state">No events found.</div>
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Event event : events) { %>
                        <tr class="data-row"
                            data-event-id="<%= event.getEventId() %>"
                            data-title="<%= event.getTitle() %>"
                            data-category="<%= event.getCategory() %>"
                            data-date="<%= event.getDate() %>"
                            data-time="<%= event.getTime() %>"
                            data-venue="<%= event.getVenue() %>"
                            data-status="<%= event.getStatus() %>">

                            <td>
                                <div class="event-title"><%= event.getTitle() %></div>
                                <div class="event-meta"><%= event.getEventId() %></div>
                            </td>

                            <td class="muted"><%= event.getCategory() %></td>
                            <td class="muted"><%= event.getDate() %></td>
                            <td class="muted"><%= event.getTime() %></td>
                            <td class="muted"><%= event.getVenue() %></td>
                            <td class="muted">LKR <%= event.getPrice() %></td>
                            <td class="muted"><%= event.getTotalSeats() %></td>
                            <td class="muted"><%= event.getAvailableSeats() %></td>

                            <td>
                                <% if ("ACTIVE".equalsIgnoreCase(event.getStatus())) { %>
                                    <span class="status-badge status-active">Active</span>
                                <% } else { %>
                                    <span class="status-badge status-cancelled"><%= event.getStatus() %></span>
                                <% } %>
                            </td>

                            <td>
                                <div class="action-group">
                                    <a class="btn btn-edit"
                                       href="<%=request.getContextPath()%>/admin/editEvent.jsp?eventId=<%= event.getEventId() %>">
                                        Edit
                                    </a>

                                    <form method="post"
                                          action="<%=request.getContextPath()%>/event"
                                          style="margin:0;"
                                          onsubmit="return confirmCancel('<%= event.getTitle().replace(\"'\", \"\\\\'\") %>');">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                        <button type="submit" class="btn btn-cancel-event">Cancel</button>
                                    </form>

                                    <form method="post"
                                          action="<%=request.getContextPath()%>/event"
                                          style="margin:0;"
                                          onsubmit="return confirmDelete('<%= event.getTitle().replace(\"'\", \"\\\\'\") %>');">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                        <button type="submit" class="btn btn-delete">Delete</button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    <% } %>
                <% } %>
                </tbody>
            </table>
        </div>

        <div id="noResults" class="no-results">
            No matching events found for your search.
        </div>
    </div>
</div>
</body>
</html>