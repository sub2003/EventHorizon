<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.eventhorizon.service.EventService" %>
<%@ page import="com.eventhorizon.model.Event" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role"))) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String eventId = request.getParameter("eventId");
    if (eventId == null || eventId.trim().isEmpty()) {
        eventId = request.getParameter("id");
    }

    EventService eventService = new EventService();
    Event event = eventService.getEventById(eventId);

    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/event?action=adminList");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Event - EventHorizon Admin</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        :root {
            --bg-primary: #0b1020;
            --bg-card: rgba(18, 26, 47, 0.94);
            --border: rgba(255, 255, 255, 0.08);
            --border-strong: rgba(255, 255, 255, 0.16);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent: #6d28d9;
            --accent-light: #8b5cf6;
            --cyan: #06b6d4;
            --shadow: 0 20px 45px rgba(0, 0, 0, 0.35);
            --radius-xl: 26px;
        }

        body {
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
            color: var(--text-primary);
            background:
                radial-gradient(circle at top left, rgba(109, 40, 217, 0.22), transparent 28%),
                radial-gradient(circle at top right, rgba(6, 182, 212, 0.12), transparent 24%),
                linear-gradient(135deg, #060914 0%, #0b1120 45%, #101826 100%);
            min-height: 100vh;
        }

        .page {
            max-width: 1100px;
            margin: 0 auto;
            padding: 32px 22px 48px;
        }

        .hero {
            margin-bottom: 24px;
        }

        .hero h1 {
            font-size: 38px;
            font-weight: 800;
            margin-bottom: 8px;
        }

        .hero p {
            color: var(--text-secondary);
            font-size: 17px;
        }

        .actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 18px;
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
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.1);
        }

        .btn-primary {
            color: white;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(109, 40, 217, 0.35);
        }

        .btn-primary:hover {
            transform: translateY(-1px);
        }

        .panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow);
            overflow: hidden;
        }

        .panel-head {
            padding: 22px 24px;
            border-bottom: 1px solid var(--border);
            background: rgba(255, 255, 255, 0.02);
        }

        .panel-head h2 {
            font-size: 24px;
            font-weight: 800;
        }

        .panel-body {
            padding: 24px;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 18px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .span-2 {
            grid-column: span 2;
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
            border: 1px solid rgba(255, 255, 255, 0.10);
            background: rgba(7, 13, 28, 0.92);
            color: white;
            font-size: 14px;
            outline: none;
        }

        .form-group textarea {
            min-height: 120px;
            resize: vertical;
        }

        .current-image {
            width: 240px;
            height: 150px;
            object-fit: cover;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            display: block;
        }

        .placeholder {
            width: 240px;
            height: 150px;
            border-radius: 14px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            display: flex;
            align-items: center;
            justify-content: center;
            color: #94a3b8;
            font-weight: 700;
        }

        .preview-note {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 6px;
        }

        .info-box {
            margin-top: 20px;
            background: rgba(6,182,212,0.08);
            border: 1px solid rgba(6,182,212,0.2);
            border-radius: 12px;
            padding: 14px;
            color: var(--text-secondary);
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        @media (max-width: 720px) {
            .form-grid {
                grid-template-columns: 1fr;
            }

            .span-2 {
                grid-column: span 1;
            }

            .current-image,
            .placeholder {
                width: 100%;
                max-width: 240px;
            }
        }
    </style>

    <script>
        function previewSelectedImage(input) {
            const preview = document.getElementById("selectedImagePreview");
            const placeholder = document.getElementById("selectedImagePlaceholder");

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = "block";
                    placeholder.style.display = "none";
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = "none";
                placeholder.style.display = "flex";
            }
        }
    </script>
</head>
<body>
<div class="page">
    <div class="hero">
        <h1>Edit Event</h1>
        <p>Update event details with the same admin dashboard style.</p>

        <div class="actions">
            <a href="<%=request.getContextPath()%>/event?action=adminList" class="btn btn-outline">Back to Events</a>
            <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn btn-outline">Dashboard</a>
        </div>
    </div>

    <div class="panel">
        <div class="panel-head">
            <h2>Edit <%= event.getTitle() %></h2>
        </div>

        <div class="panel-body">
            <form action="<%=request.getContextPath()%>/event" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="eventId" value="<%= event.getEventId() %>">

                <div class="form-grid">
                    <div class="form-group span-2">
                        <label>Event Title</label>
                        <input type="text" name="title" value="<%= event.getTitle() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" required>
                            <option value="Concert" <%= "Concert".equals(event.getCategory()) ? "selected" : "" %>>Concert</option>
                            <option value="Sports" <%= "Sports".equals(event.getCategory()) ? "selected" : "" %>>Sports</option>
                            <option value="Technology" <%= "Technology".equals(event.getCategory()) ? "selected" : "" %>>Technology</option>
                            <option value="Cultural" <%= "Cultural".equals(event.getCategory()) ? "selected" : "" %>>Cultural</option>
                            <option value="Music" <%= "Music".equals(event.getCategory()) ? "selected" : "" %>>Music</option>
                            <option value="Conference" <%= "Conference".equals(event.getCategory()) ? "selected" : "" %>>Conference</option>
                            <option value="Workshop" <%= "Workshop".equals(event.getCategory()) ? "selected" : "" %>>Workshop</option>
                            <option value="Exhibition" <%= "Exhibition".equals(event.getCategory()) ? "selected" : "" %>>Exhibition</option>
                            <option value="Festival" <%= "Festival".equals(event.getCategory()) ? "selected" : "" %>>Festival</option>
                            <option value="Seminar" <%= "Seminar".equals(event.getCategory()) ? "selected" : "" %>>Seminar</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label>Venue</label>
                        <input type="text" name="venue" value="<%= event.getVenue() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Date</label>
                        <input type="date" name="date" value="<%= event.getDate() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Time</label>
                        <input type="time" name="time" value="<%= event.getTime() %>" required>
                    </div>

                    <div class="form-group">
                        <label>Ticket Price</label>
                        <input type="number" name="ticketPrice" value="<%= event.getTicketPrice() %>" step="0.01" min="0" required>
                    </div>

                    <div class="form-group span-2">
                        <label>Current Image</label>

                        <img
                            src="<%=request.getContextPath()%>/event?action=image&id=<%= event.getEventId() %>"
                            alt="Current event image"
                            class="current-image"
                            onerror="this.style.display='none'; document.getElementById('currentImagePlaceholder').style.display='flex';">

                        <div id="currentImagePlaceholder" class="placeholder" style="display:none;">
                            No Image
                        </div>

                        <div class="preview-note">This image is loaded from the database.</div>
                    </div>

                    <div class="form-group span-2">
                        <label>Replace Image</label>
                        <input type="file" name="eventImage" accept="image/*" onchange="previewSelectedImage(this)">

                        <img id="selectedImagePreview" class="current-image" style="display:none; margin-top:12px;" alt="Selected image preview">
                        <div id="selectedImagePlaceholder" class="preview-note">Choose a new image only if you want to replace the current one.</div>
                    </div>

                    <div class="form-group span-2">
                        <label>Description</label>
                        <textarea name="description" required><%= event.getDescription() == null ? "" : event.getDescription() %></textarea>
                    </div>
                </div>

                <div class="info-box">
                    Current seats: <strong><%= event.getAvailableSeats() %> available / <%= event.getTotalSeats() %> total</strong>
                    &nbsp;|&nbsp;
                    Status: <strong><%= event.getStatus() %></strong>
                </div>

                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Save Changes</button>
                    <a href="<%=request.getContextPath()%>/event?action=adminList" class="btn btn-outline">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>