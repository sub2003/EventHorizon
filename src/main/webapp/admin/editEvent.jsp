<!-- editEvent.jsp -->
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Admin" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%@ page import="com.eventhorizon.service.EventService" %>
<%@ page import="com.eventhorizon.service.EventTicketTypeService" %>
<%@ page import="com.eventhorizon.model.Event" %>
<%@ page import="com.eventhorizon.model.EventTicketType" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String adminPermission = (String) session.getAttribute("adminPermission");
    if (adminPermission == null || adminPermission.trim().isEmpty()) adminPermission = Admin.CORE_ADMIN;

    if (session.getAttribute("userId") == null || !"ADMIN".equals(session.getAttribute("role")) || !UserService.hasEventAccess(adminPermission)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String eventId = request.getParameter("eventId");
    if (eventId == null || eventId.trim().isEmpty()) {
        eventId = request.getParameter("id");
    }

    EventService eventService = new EventService();
    EventTicketTypeService eventTicketTypeService = new EventTicketTypeService();

    Event event = eventService.getEventById(eventId);
    if (event == null) {
        response.sendRedirect(request.getContextPath() + "/event?action=adminList");
        return;
    }

    List<EventTicketType> ticketTypes = eventTicketTypeService.getByEvent(eventId);
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
            --danger: #ef4444;
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
            max-width: 1180px;
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
            font-size: 16px;
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
            background: rgba(255, 255, 255, 0.10);
        }

        .btn-primary {
            color: #fff;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(109, 40, 217, 0.35);
        }

        .btn-add-type {
            color: white;
            background: linear-gradient(135deg, #0891b2, #06b6d4);
            box-shadow: 0 10px 24px rgba(6, 182, 212, 0.25);
        }

        .btn-remove-type {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.16);
            border: 1px solid rgba(239, 68, 68, 0.28);
            padding: 11px 14px;
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

        .ticket-types-box {
            margin-top: 8px;
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 18px;
            background: rgba(255,255,255,0.02);
            overflow: hidden;
        }

        .ticket-types-head {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 12px;
            padding: 18px 18px 14px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            background: rgba(255,255,255,0.015);
            flex-wrap: wrap;
        }

        .ticket-types-title {
            font-size: 16px;
            font-weight: 800;
            color: #ffffff;
        }

        .ticket-types-sub {
            font-size: 13px;
            color: var(--text-secondary);
            margin-top: 4px;
        }

        .ticket-type-list {
            padding: 18px;
            display: flex;
            flex-direction: column;
            gap: 14px;
        }

        .ticket-row {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr auto;
            gap: 12px;
            align-items: end;
            padding: 14px;
            border-radius: 16px;
            background: rgba(255,255,255,0.025);
            border: 1px solid rgba(255,255,255,0.06);
        }

        .ticket-row .mini-group {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }

        .ticket-row .mini-group label {
            font-size: 12px;
            font-weight: 800;
            color: #cbd5e1;
            text-transform: uppercase;
            letter-spacing: 0.4px;
        }

        .ticket-row .mini-group input {
            width: 100%;
            padding: 12px 13px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.10);
            background: rgba(7, 13, 28, 0.92);
            color: white;
            font-size: 14px;
            outline: none;
        }

        .ticket-actions {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100%;
        }

        .summary-bar {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 14px;
            margin-top: 16px;
        }

        .summary-card {
            border-radius: 16px;
            padding: 16px 18px;
            background: rgba(255,255,255,0.025);
            border: 1px solid rgba(255,255,255,0.06);
        }

        .summary-label {
            color: var(--text-secondary);
            font-size: 12px;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .summary-value {
            color: #ffffff;
            font-size: 24px;
            font-weight: 800;
        }

        .info-box {
            margin-top: 20px;
            background: rgba(6,182,212,0.08);
            border: 1px solid rgba(6,182,212,0.2);
            border-radius: 12px;
            padding: 14px;
            color: var(--text-secondary);
            line-height: 1.65;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 22px;
        }

        @media (max-width: 900px) {
            .ticket-row {
                grid-template-columns: 1fr;
            }

            .ticket-actions {
                justify-content: flex-start;
            }
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

            .summary-bar {
                grid-template-columns: 1fr;
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

        function addTicketTypeRow(defaultName, defaultPrice, defaultSeats) {
            const list = document.getElementById("ticketTypeList");
            const row = document.createElement("div");
            row.className = "ticket-row";

            row.innerHTML =
                '<div class="mini-group">' +
                    '<label>Type Name</label>' +
                    '<input type="text" name="typeName" required placeholder="e.g. VIP, Standard, Gold" value="' + (defaultName || '') + '">' +
                '</div>' +
                '<div class="mini-group">' +
                    '<label>Price (LKR)</label>' +
                    '<input type="number" name="typePrice" step="0.01" min="0" required placeholder="0.00" value="' + (defaultPrice || '') + '">' +
                '</div>' +
                '<div class="mini-group">' +
                    '<label>Total Seats</label>' +
                    '<input type="number" name="typeSeats" min="1" required placeholder="Enter seats" value="' + (defaultSeats || '') + '">' +
                '</div>' +
                '<div class="ticket-actions">' +
                    '<button type="button" class="btn btn-remove-type" onclick="removeTicketTypeRow(this)">Remove</button>' +
                '</div>';

            list.appendChild(row);
            updateTicketSummary();
        }

        function removeTicketTypeRow(button) {
            const rows = document.querySelectorAll("#ticketTypeList .ticket-row");
            if (rows.length <= 1) {
                alert("At least one ticket type is required.");
                return;
            }
            button.closest(".ticket-row").remove();
            updateTicketSummary();
        }

        function updateTicketSummary() {
            const priceInputs = document.querySelectorAll('input[name="typePrice"]');
            const seatInputs = document.querySelectorAll('input[name="typeSeats"]');

            let minPrice = 0;
            let totalSeats = 0;
            let foundPrice = false;

            priceInputs.forEach(function(input) {
                const val = parseFloat(input.value || "0");
                if (!isNaN(val) && val >= 0) {
                    if (!foundPrice || val < minPrice) {
                        minPrice = val;
                    }
                    foundPrice = true;
                }
            });

            seatInputs.forEach(function(input) {
                const val = parseInt(input.value || "0", 10);
                if (!isNaN(val) && val > 0) {
                    totalSeats += val;
                }
            });

            document.getElementById("summaryMinPrice").innerText = "LKR " + minPrice.toFixed(2);
            document.getElementById("summaryTotalSeats").innerText = totalSeats;
        }

        document.addEventListener("input", function (e) {
            if (e.target && (e.target.name === "typePrice" || e.target.name === "typeSeats")) {
                updateTicketSummary();
            }
        });

        window.onload = function () {
            updateTicketSummary();
        };
    </script>

<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT,WONK@9..144,600..900,40,0..1&family=Inter:wght@400;500;600;700;800;900&display=swap" rel="stylesheet">

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>
<div class="page">
    <div class="hero">
        <h1>Edit Event</h1>
        <p>Update event details and ticket types with the same admin dashboard style.</p>

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

                    <div class="form-group span-2">
                        <label>Ticket Types</label>

                        <div class="ticket-types-box">
                            <div class="ticket-types-head">
                                <div>
                                    <div class="ticket-types-title">Per-event ticket categories</div>
                                    <div class="ticket-types-sub">Update your VIP, Standard, Gold, Early Bird, or other ticket type rows here.</div>
                                </div>

                                <button type="button" class="btn btn-add-type" onclick="addTicketTypeRow('', '', '')">
                                    + Add Ticket Type
                                </button>
                            </div>

                            <div id="ticketTypeList" class="ticket-type-list">
                                <% if (ticketTypes != null && !ticketTypes.isEmpty()) { %>
                                    <% for (EventTicketType type : ticketTypes) { %>
                                        <div class="ticket-row">
                                            <div class="mini-group">
                                                <label>Type Name</label>
                                                <input type="text" name="typeName" required value="<%= type.getTypeName() %>" placeholder="e.g. VIP, Standard, Gold">
                                            </div>
                                            <div class="mini-group">
                                                <label>Price (LKR)</label>
                                                <input type="number" name="typePrice" step="0.01" min="0" required value="<%= String.format("%.2f", type.getPrice()) %>" placeholder="0.00">
                                            </div>
                                            <div class="mini-group">
                                                <label>Total Seats</label>
                                                <input type="number" name="typeSeats" min="1" required value="<%= type.getTotalSeats() %>" placeholder="Enter seats">
                                            </div>
                                            <div class="ticket-actions">
                                                <button type="button" class="btn btn-remove-type" onclick="removeTicketTypeRow(this)">Remove</button>
                                            </div>
                                        </div>
                                    <% } %>
                                <% } else { %>
                                    <div class="ticket-row">
                                        <div class="mini-group">
                                            <label>Type Name</label>
                                            <input type="text" name="typeName" required value="Standard" placeholder="e.g. VIP, Standard, Gold">
                                        </div>
                                        <div class="mini-group">
                                            <label>Price (LKR)</label>
                                            <input type="number" name="typePrice" step="0.01" min="0" required value="<%= String.format("%.2f", event.getTicketPrice()) %>" placeholder="0.00">
                                        </div>
                                        <div class="mini-group">
                                            <label>Total Seats</label>
                                            <input type="number" name="typeSeats" min="1" required value="<%= event.getTotalSeats() %>" placeholder="Enter seats">
                                        </div>
                                        <div class="ticket-actions">
                                            <button type="button" class="btn btn-remove-type" onclick="removeTicketTypeRow(this)">Remove</button>
                                        </div>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <div class="summary-bar">
                            <div class="summary-card">
                                <div class="summary-label">Lowest Ticket Price</div>
                                <div class="summary-value" id="summaryMinPrice">LKR 0.00</div>
                            </div>
                            <div class="summary-card">
                                <div class="summary-label">Total Seats Across Types</div>
                                <div class="summary-value" id="summaryTotalSeats">0</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="info-box">
                    Current event summary: <strong><%= event.getAvailableSeats() %> available / <%= event.getTotalSeats() %> total</strong>
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
<!-- EVENTHORIZON ADMIN LIGHT RETHEME OVERRIDE - paste-safe, logic-safe -->
<style>
    :root {
        --eh-linen: #FAF8F4 !important;
        --eh-paper: #FFFFFF !important;
        --eh-forest: #1E4A3A !important;
        --eh-forest-dark: #123528 !important;
        --eh-forest-soft: #E8F1EC !important;
        --eh-sage: #72887A !important;
        --eh-text: #18251F !important;
        --eh-text-soft: #52635A !important;
        --eh-muted: #6F7F76 !important;
        --eh-border: rgba(30, 74, 58, 0.16) !important;
        --eh-border-strong: rgba(30, 74, 58, 0.30) !important;
        --eh-success-bg: #E8F6EE !important;
        --eh-success-text: #176B3B !important;
        --eh-warning-bg: #FFF7E3 !important;
        --eh-warning-text: #76520F !important;
        --eh-danger-bg: #FFF0EC !important;
        --eh-danger-text: #A23A27 !important;
        --eh-info-bg: #E8F1EC !important;
        --eh-info-text: #123528 !important;
        --eh-shadow-soft: 0 18px 50px rgba(24, 37, 31, 0.09) !important;
        --eh-shadow-premium: 0 30px 90px rgba(24, 37, 31, 0.15) !important;
        --bg: #FAF8F4 !important;
        --surface: #FFFFFF !important;
        --card: #FFFFFF !important;
        --text: #18251F !important;
        --text-primary: #18251F !important;
        --text-secondary: #52635A !important;
        --text-muted: #52635A !important;
        --muted: #52635A !important;
        --border: rgba(30, 74, 58, 0.16) !important;
        --accent: #1E4A3A !important;
        --accent-light: #2E6B55 !important;
        --accent-purple: #1E4A3A !important;
        --accent-teal: #1E4A3A !important;
        --accent-blue: #1E4A3A !important;
        --success: #176B3B !important;
        --success-soft: #E8F6EE !important;
        --danger: #A23A27 !important;
        --danger-soft: #FFF0EC !important;
        --warn: #76520F !important;
        --warning-text: #76520F !important;
        --warning-soft: #FFF7E3 !important;
    }

    html { scroll-behavior: smooth !important; }

    body {
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif !important;
        background:
            radial-gradient(circle at top left, rgba(30, 74, 58, 0.08), transparent 32%),
            radial-gradient(circle at top right, rgba(176, 141, 101, 0.10), transparent 30%),
            linear-gradient(180deg, #ffffff 0%, #FAF8F4 48%, #F7F3EA 100%) !important;
        color: var(--eh-text) !important;
        min-height: 100vh !important;
        line-height: 1.6 !important;
        overflow-x: hidden !important;
        -webkit-font-smoothing: antialiased !important;
    }

    body::before {
        content: "" !important;
        position: fixed !important;
        inset: 0 !important;
        z-index: -10 !important;
        pointer-events: none !important;
        background-image:
            radial-gradient(circle at 1px 1px, rgba(30, 74, 58, 0.10) 1.2px, transparent 1.4px),
            linear-gradient(135deg, rgba(30, 74, 58, 0.035) 25%, transparent 25%),
            linear-gradient(45deg, rgba(176, 141, 101, 0.035) 25%, transparent 25%) !important;
        background-size: 34px 34px, 88px 88px, 88px 88px !important;
        background-position: 0 0, 0 0, 44px 44px !important;
        opacity: 0.72 !important;
    }

    a { text-decoration: none !important; }

    .admin-shell,
    .admin-wrapper {
        background: transparent !important;
        color: var(--eh-text) !important;
        min-height: 100vh !important;
    }

    .sidebar {
        background: rgba(255, 255, 255, 0.97) !important;
        color: var(--eh-text) !important;
        border-right: 1px solid var(--eh-border) !important;
        box-shadow: 16px 0 45px rgba(24, 37, 31, 0.06) !important;
    }

    .brand,
    .sidebar-title,
    .navbar-brand,
    .brand h2,
    .brand-text h2,
    .sidebar .brand h2,
    .sidebar-title {
        color: var(--eh-forest-dark) !important;
        font-weight: 900 !important;
        letter-spacing: 1.4px !important;
    }

    .brand p,
    .brand-text p,
    .sidebar .brand p,
    .sidebar-footer,
    .sidebar-footer div,
    .sidebar-footer strong {
        color: var(--eh-text-soft) !important;
    }

    .brand-icon {
        width: 42px !important;
        height: 42px !important;
        border-radius: 14px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
        border: none !important;
        font-size: 0 !important;
        flex-shrink: 0 !important;
    }

    .brand-icon::before {
        content: "\f06c" !important;
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900 !important;
        font-size: 1rem !important;
        color: #ffffff !important;
    }

    .brand-icon i { color: #ffffff !important; font-size: 1rem !important; }

    .nav-links a,
    .sidebar-link,
    .navbar-links a,
    .navbar a:not(.btn-nav),
    .back-site,
    .logout-btn {
        color: var(--eh-text-soft) !important;
        background: transparent !important;
        border: 1px solid transparent !important;
        box-shadow: none !important;
        font-weight: 850 !important;
    }

    .nav-links a i,
    .sidebar-link i,
    .back-site i,
    .logout-btn i,
    .navbar-links a i {
        color: var(--eh-forest) !important;
    }

    .nav-links a:hover,
    .nav-links a.active,
    .sidebar-link:hover,
    .sidebar-link.active,
    .navbar-links a:hover,
    .navbar-links a.active,
    .back-site:hover {
        color: var(--eh-forest-dark) !important;
        background: var(--eh-forest-soft) !important;
        border-color: var(--eh-border-strong) !important;
        box-shadow: 0 8px 18px rgba(24, 37, 31, 0.06) !important;
    }

    .logout-btn:hover {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border-color: rgba(162, 58, 39, 0.26) !important;
    }

    .sidebar-footer > div,
    .topbar-badge,
    .topbar-user,
    [style*="rgba(255,255,255,0.04)"],
    [style*="rgba(255, 255, 255, 0.04)"],
    [style*="rgba(255,255,255,0.05)"],
    [style*="background:rgba(255,255,255"] {
        background: #ffffff !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: none !important;
    }

    .main-content,
    .admin-content {
        background: transparent !important;
        color: var(--eh-text) !important;
    }

    .topbar {
        background: rgba(255,255,255,0.86) !important;
        border: 1px solid var(--eh-border) !important;
        border-radius: 24px !important;
        padding: 22px 24px !important;
        margin-bottom: 24px !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    .eyebrow,
    .subtitle,
    .topbar p,
    .topbar-badge,
    .topbar-user {
        color: var(--eh-text-soft) !important;
    }

    .navbar {
        background: rgba(250, 248, 244, 0.96) !important;
        border-bottom: 1px solid var(--eh-border) !important;
        box-shadow: 0 10px 28px rgba(24, 37, 31, 0.05) !important;
        backdrop-filter: blur(18px) !important;
        -webkit-backdrop-filter: blur(18px) !important;
    }

    .navbar-brand {
        display: inline-flex !important;
        align-items: center !important;
        gap: 10px !important;
        color: var(--eh-forest-dark) !important;
        font-weight: 900 !important;
        letter-spacing: 1.4px !important;
        text-transform: uppercase !important;
    }

    .navbar-brand::before {
        content: "\f06c" !important;
        width: 42px !important;
        height: 42px !important;
        border-radius: 14px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900 !important;
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
    }

    .btn-nav {
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        border: none !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
    }

    .content-card,
    .card,
    .panel,
    .panel-body,
    .table-wrap,
    .booking-table-wrap,
    .scan-card,
    .scanner-card,
    .filter-bar,
    .filters,
    .filter-panel,
    .stat-card,
    .metric-card,
    .summary-card,
    .issue-card,
    .detail-card,
    .reply-card,
    .quick-status-card,
    .ticket-card,
    .notice-box,
    .form-panel,
    .side-panel,
    .event-form,
    .event-panel,
    .user-card,
    .modal-content,
    .empty-state,
    .empty-box {
        background: rgba(255, 255, 255, 0.97) !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    .content-card,
    .card,
    .panel,
    .table-wrap,
    .booking-table-wrap,
    .scan-card,
    .filter-bar,
    .stat-card,
    .detail-card,
    .quick-status-card,
    .notice-box {
        border-radius: 24px !important;
    }

    h1, h2, h3, h4, h5, h6,
    .page-title,
    .section-title,
    .content-card h2,
    .card-title,
    .panel-title,
    .ticket-title,
    .stat-val,
    .stat-number,
    .title,
    .detail-title,
    .bank-value,
    .summary-title,
    .total-amount,
    .topbar h1,
    .modal-title {
        color: var(--eh-forest-dark) !important;
        text-shadow: none !important;
        font-weight: 900 !important;
    }

    p, li, label, small,
    .content-card > p,
    .stat-lbl,
    .muted,
    .subtitle,
    .card-subtitle,
    .meta-item small,
    .booking-label,
    .payment-label,
    .field label,
    .form-label,
    .empty-text,
    .hint,
    .note,
    .qr-note,
    .filter-bar label,
    .modal-note,
    .table-note,
    [style*="color:#cbd5e1"],
    [style*="color: #cbd5e1"],
    [style*="color:#aab4d6"],
    [style*="color:#94a3b8"],
    [style*="color:#5a6a9a"],
    [style*="color:var(--muted)"] {
        color: var(--eh-text-soft) !important;
        text-shadow: none !important;
    }

    strong,
    .value,
    .booking-value,
    .payment-value,
    .meta-item span,
    .detail-value,
    .s-value,
    .bank-value,
    .issue-title,
    .reply-text,
    td strong,
    .table-title,
    .card strong {
        color: var(--eh-text) !important;
        font-weight: 900 !important;
    }

    input,
    select,
    textarea,
    .form-control,
    .search-input,
    .search-select,
    .field input,
    .field select,
    .filter-bar select,
    .filter-bar input {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif !important;
    }

    input::placeholder,
    textarea::placeholder,
    .field input::placeholder {
        color: #7E9086 !important;
        opacity: 1 !important;
    }

    input:focus,
    select:focus,
    textarea:focus,
    .form-control:focus,
    .field input:focus,
    .field select:focus,
    .filter-bar select:focus,
    .filter-bar input:focus {
        border-color: rgba(30, 74, 58, 0.52) !important;
        box-shadow: 0 0 0 4px rgba(30, 74, 58, 0.10) !important;
        outline: none !important;
    }

    select option {
        background: #ffffff !important;
        color: var(--eh-text) !important;
    }

    table,
    .data-table,
    .booking-table,
    .payment-table {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border-collapse: separate !important;
        border-spacing: 0 !important;
    }

    thead th,
    .data-table thead th,
    .booking-table thead th,
    .payment-table th,
    table th {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border-bottom: 1px solid var(--eh-border-strong) !important;
        font-weight: 900 !important;
        text-transform: uppercase !important;
        letter-spacing: 0.5px !important;
    }

    tbody td,
    .data-table tbody td,
    .booking-table tbody td,
    .payment-table td,
    table td {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border-bottom: 1px solid rgba(30, 74, 58, 0.12) !important;
        font-weight: 700 !important;
    }

    tbody tr:hover td,
    .data-table tbody tr:hover,
    .booking-table tbody tr:hover td,
    .payment-table tbody tr:hover td,
    tbody tr.data-row:hover td {
        background: #FAF8F4 !important;
        color: var(--eh-text) !important;
    }

    .btn,
    .primary-btn,
    .btn-primary,
    .btn-save,
    .search-btn,
    .btn-filter,
    .approve-btn,
    .btn-add-type,
    button[type="submit"].primary-btn,
    button[type="submit"].btn-primary {
        color: #ffffff !important;
        background: linear-gradient(135deg, var(--eh-forest), var(--eh-forest-dark)) !important;
        border: 1px solid transparent !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
        font-weight: 900 !important;
    }

    .btn:hover,
    .primary-btn:hover,
    .btn-primary:hover,
    .btn-save:hover,
    .search-btn:hover,
    .btn-filter:hover,
    .approve-btn:hover,
    .btn-add-type:hover {
        transform: translateY(-1px) !important;
        box-shadow: 0 18px 42px rgba(30, 74, 58, 0.30) !important;
        opacity: 1 !important;
    }

    .secondary-btn,
    .btn-secondary,
    .btn-outline,
    .btn-reset,
    .btn-view,
    .btn-edit,
    .action-link,
    .back-link,
    .btn-cancel,
    .qs-btn {
        background: #ffffff !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .secondary-btn:hover,
    .btn-secondary:hover,
    .btn-outline:hover,
    .btn-reset:hover,
    .btn-view:hover,
    .btn-edit:hover,
    .back-link:hover,
    .qs-btn:hover,
    .qs-btn.active {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border-color: rgba(30, 74, 58, 0.42) !important;
    }

    .reject-btn,
    .delete-btn,
    .btn-delete,
    .btn-remove-type,
    .cancel-btn,
    .btn-cancel-event,
    .danger-btn,
    .btn-danger {
        background: #ffffff !important;
        color: var(--eh-danger-text) !important;
        border: 1px solid rgba(162, 58, 39, 0.30) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .reject-btn:hover,
    .delete-btn:hover,
    .btn-delete:hover,
    .btn-remove-type:hover,
    .cancel-btn:hover,
    .btn-cancel-event:hover,
    .danger-btn:hover,
    .btn-danger:hover {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border-color: rgba(162, 58, 39, 0.45) !important;
    }

    button:disabled,
    .btn:disabled {
        background: #F1F3F1 !important;
        color: #87928C !important;
        border-color: #DDE4DF !important;
        box-shadow: none !important;
        cursor: not-allowed !important;
    }

    .alert,
    .alert-box,
    .alert-info,
    .info-box {
        background: var(--eh-info-bg) !important;
        color: var(--eh-info-text) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
    }

    .alert-success,
    .alert-success-box,
    .success-box,
    .status-approved,
    .payment-approved,
    .badge-success,
    .valid,
    .unused,
    .approved:not(.status-box),
    .badge-available {
        background: var(--eh-success-bg) !important;
        color: var(--eh-success-text) !important;
        border: 1px solid rgba(23, 107, 59, 0.22) !important;
    }

    .alert-danger,
    .alert-error,
    .alert-error-box,
    .error-box,
    .status-rejected,
    .payment-rejected,
    .badge-danger,
    .invalid,
    .not-approved,
    .wrong,
    .badge-soldout {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border: 1px solid rgba(162, 58, 39, 0.22) !important;
    }

    .alert-warning,
    .payment-pending,
    .status-pending,
    .badge-warning,
    .used,
    .qs-in-progress,
    .badge-progress {
        background: var(--eh-warning-bg) !important;
        color: var(--eh-warning-text) !important;
        border: 1px solid rgba(138, 90, 0, 0.22) !important;
    }

    .badge,
    .chip,
    .type-pill,
    .ticket-type-pill,
    .role-pill,
    .status-pill,
    .ticket-badge,
    .bank-badge,
    .category-pill,
    .permission-pill {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid var(--eh-border-strong) !important;
        box-shadow: none !important;
        font-weight: 900 !important;
    }

    .status-box.approved,
    .approved.status-box {
        background: var(--eh-success-bg) !important;
        color: var(--eh-success-text) !important;
        border: 2px solid rgba(23, 107, 59, 0.24) !important;
    }

    .status-box.not-approved,
    .not-approved.status-box {
        background: var(--eh-danger-bg) !important;
        color: var(--eh-danger-text) !important;
        border: 2px solid rgba(162, 58, 39, 0.24) !important;
    }

    .p-high { background: var(--eh-danger-text) !important; }
    .p-medium { background: #C2882E !important; }
    .p-low { background: var(--eh-success-text) !important; }

    .badge-open { background: var(--eh-danger-bg) !important; color: var(--eh-danger-text) !important; border-color: rgba(162,58,39,0.22) !important; }
    .badge-progress { background: var(--eh-warning-bg) !important; color: var(--eh-warning-text) !important; border-color: rgba(138,90,0,0.22) !important; }
    .badge-resolved { background: var(--eh-success-bg) !important; color: var(--eh-success-text) !important; border-color: rgba(23,107,59,0.22) !important; }

    #reader,
    .qr-box,
    .scan-result,
    .result-box {
        background: #ffffff !important;
        color: var(--eh-text) !important;
        border: 1px solid var(--eh-border) !important;
        box-shadow: var(--eh-shadow-soft) !important;
    }

    video,
    canvas {
        background: #ffffff !important;
        border-radius: 16px !important;
    }

    .note {
        background: var(--eh-forest-soft) !important;
        color: var(--eh-forest-dark) !important;
        border: 1px solid rgba(30, 74, 58, 0.22) !important;
    }

    .fa-solid,
    .fa-regular,
    .card-title i,
    .content-card h2 i,
    .topbar i,
    .stat-card i,
    .empty-state i,
    .btn-edit i,
    .btn-view i {
        color: var(--eh-forest) !important;
    }

    .primary-btn i,
    .btn-primary i,
    .approve-btn i,
    .btn-filter i,
    .btn-save i,
    .search-btn i,
    .btn-nav i {
        color: #ffffff !important;
    }

    [style*="#7c5cff"],
    [style*="#6c5ce7"],
    [style*="#2bc0ff"],
    [style*="#00cec9"],
    [style*="color:#ffffff"],
    [style*="color: #ffffff"],
    [style*="color:white"],
    [style*="color: white"] {
        color: var(--eh-forest-dark) !important;
    }

    [style*="background:rgba(43,192,255"],
    [style*="background:rgba(6,182,212"],
    [style*="background: rgba(43,192,255"],
    [style*="background: rgba(6, 182, 212"],
    [style*="background:rgba(124,92,255"],
    [style*="background: rgba(124, 92, 255"],
    [style*="background:rgba(91, 33, 182"],
    [style*="background: rgba(91, 33, 182"] {
        background: var(--eh-forest-soft) !important;
        border-color: var(--eh-border-strong) !important;
        color: var(--eh-forest-dark) !important;
    }

    .primary-btn,
    .btn-primary,
    .btn-save,
    .search-btn,
    .btn-filter,
    .approve-btn,
    .btn-nav,
    .primary-btn *,
    .btn-primary *,
    .btn-save *,
    .search-btn *,
    .btn-filter *,
    .approve-btn *,
    .btn-nav * {
        color: #ffffff !important;
    }

    @media (max-width: 900px) {
        .admin-shell,
        .admin-wrapper { display: block !important; }
        .sidebar {
            position: relative !important;
            width: 100% !important;
            min-height: auto !important;
            border-right: none !important;
            border-bottom: 1px solid var(--eh-border) !important;
        }
        .nav-links,
        .navbar-links { justify-content: center !important; }
    }
</style>

</body>
</html>