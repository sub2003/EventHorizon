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
</body>
</html>