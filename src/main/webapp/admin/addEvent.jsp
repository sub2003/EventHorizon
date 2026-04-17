<!-- addEvent.jsp -->
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
            --bg-card: rgba(18, 26, 47, 0.94);
            --bg-hover: rgba(255, 255, 255, 0.03);
            --border: rgba(255, 255, 255, 0.08);
            --border-strong: rgba(255, 255, 255, 0.16);
            --text-primary: #f8fafc;
            --text-secondary: #94a3b8;
            --accent: #6d28d9;
            --accent-light: #8b5cf6;
            --success-soft: rgba(16, 185, 129, 0.16);
            --danger-soft: rgba(239, 68, 68, 0.16);
            --warning-soft: rgba(245, 158, 11, 0.16);
            --info-soft: rgba(6, 182, 212, 0.12);
            --shadow: 0 20px 45px rgba(0, 0, 0, 0.35);
            --radius-xl: 26px;
            --radius-lg: 20px;
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
            max-width: 1550px;
            margin: 0 auto;
            padding: 32px 22px 48px;
        }

        .hero {
            margin-bottom: 26px;
        }

        .hero h1 {
            font-size: 42px;
            font-weight: 800;
            letter-spacing: -0.5px;
            margin-bottom: 8px;
            color: #ffffff;
        }

        .hero p {
            font-size: 18px;
            color: var(--text-secondary);
        }

        .top-actions {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 16px;
            flex-wrap: wrap;
            margin-top: 18px;
        }

        .top-actions-left,
        .top-actions-right {
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
        }

        .btn-outline:hover {
            background: rgba(255, 255, 255, 0.10);
            transform: translateY(-1px);
        }

        .btn-primary,
        .btn-save {
            color: white;
            background: linear-gradient(135deg, var(--accent), var(--accent-light));
            box-shadow: 0 12px 28px rgba(109, 40, 217, 0.35);
        }

        .panel {
            background: var(--bg-card);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            box-shadow: var(--shadow);
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
            margin-bottom: 16px;
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

        .alert-info {
            background: var(--info-soft);
            color: #bae6fd;
            border-color: rgba(6, 182, 212, 0.30);
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

        .upload-preview {
            width: 130px;
            height: 90px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            display: none;
            margin-top: 10px;
        }

        .preview-text {
            color: var(--text-secondary);
            font-size: 13px;
            margin-top: 6px;
        }

        .form-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 20px;
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
            min-width: 88px;
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
            min-width: 320px;
        }

        .search-input,
        .filter-select {
            width: 100%;
            padding: 14px 16px;
            border-radius: 14px;
            border: 1px solid rgba(255, 255, 255, 0.10);
            background: rgba(7, 13, 28, 0.92);
            color: white;
            font-size: 14px;
            outline: none;
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
            min-width: 1600px;
        }

        thead th {
            text-align: left;
            padding: 20px 16px;
            font-size: 13px;
            font-weight: 800;
            text-transform: uppercase;
            letter-spacing: 0.7px;
            color: #cbd5e1;
            background: rgba(255, 255, 255, 0.03);
            border-bottom: 1px solid var(--border);
        }

        tbody td {
            padding: 20px 16px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
            vertical-align: middle;
            color: var(--text-primary);
        }

        tbody tr.data-row:hover {
            background: var(--bg-hover);
        }

        .event-id {
            font-weight: 800;
            color: #ffffff;
        }

        .event-title {
            font-weight: 800;
            color: #ffffff;
            line-height: 1.45;
        }

        .event-desc {
            margin-top: 4px;
            font-size: 12px;
            color: var(--text-secondary);
            line-height: 1.5;
        }

        .muted {
            color: #dbe4f0;
        }

        .event-image {
            width: 78px;
            height: 78px;
            border-radius: 14px;
            object-fit: cover;
            border: 1px solid rgba(255,255,255,0.08);
            background: rgba(255,255,255,0.04);
            display: block;
        }

        .image-placeholder {
            width: 78px;
            height: 78px;
            border-radius: 14px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
            color: #94a3b8;
            font-size: 12px;
            font-weight: 700;
            text-align: center;
            padding: 8px;
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
            color: #fde68a;
            background: rgba(245, 158, 11, 0.16);
            border: 1px solid rgba(245, 158, 11, 0.28);
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
            min-width: 88px;
        }

        .btn-cancel-event {
            color: #fde68a;
            background: rgba(245, 158, 11, 0.12);
            border: 1px solid rgba(245, 158, 11, 0.28);
            min-width: 88px;
        }

        .btn-delete {
            color: #fecaca;
            background: rgba(239, 68, 68, 0.16);
            border: 1px solid rgba(239, 68, 68, 0.28);
            min-width: 88px;
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

            .form-group.span-3 {
                grid-column: span 2;
            }

            .ticket-row {
                grid-template-columns: 1fr;
            }

            .ticket-actions {
                justify-content: flex-start;
            }
        }

        @media (max-width: 720px) {
            .page {
                padding: 20px 12px 32px;
            }

            .hero h1 {
                font-size: 32px;
            }

            .hero p {
                font-size: 16px;
            }

            .form-grid {
                grid-template-columns: 1fr;
            }

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

            .search-box {
                min-width: 100%;
            }

            .summary-bar {
                grid-template-columns: 1fr;
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
                var description = (row.getAttribute("data-description") || "").toLowerCase();

                var matchesSearch =
                    title.indexOf(searchValue) !== -1 ||
                    category.indexOf(searchValue) !== -1 ||
                    date.indexOf(searchValue) !== -1 ||
                    time.indexOf(searchValue) !== -1 ||
                    venue.indexOf(searchValue) !== -1 ||
                    status.indexOf(searchValue) !== -1 ||
                    eventId.indexOf(searchValue) !== -1 ||
                    description.indexOf(searchValue) !== -1;

                var matchesCategory = (categoryValue === "all" || category === categoryValue);
                var matchesStatus = (statusValue === "all" || status === statusValue);

                row.style.display = (matchesSearch && matchesCategory && matchesStatus) ? "" : "none";
                if (matchesSearch && matchesCategory && matchesStatus) {
                    visibleCount++;
                }
            });

            document.getElementById("resultCount").innerText = visibleCount + " event(s) found";
            document.getElementById("noResults").style.display = visibleCount === 0 ? "block" : "none";
        }

        function clearFilters() {
            document.getElementById("eventSearch").value = "";
            document.getElementById("categoryFilter").value = "all";
            document.getElementById("statusFilter").value = "all";
            filterEvents();
        }

        function confirmDelete() {
            return confirm("Delete this event?");
        }

        function confirmCancel() {
            return confirm("Cancel this event?");
        }

        function previewNewEventImage(input) {
            const preview = document.getElementById("newEventPreview");
            const previewText = document.getElementById("previewText");

            if (input.files && input.files[0]) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.src = e.target.result;
                    preview.style.display = "block";
                    previewText.innerText = "Selected image preview";
                };
                reader.readAsDataURL(input.files[0]);
            } else {
                preview.style.display = "none";
                previewText.innerText = "Choose an image to preview before saving.";
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

        window.onload = function () {
            addTicketTypeRow("Standard", "", "");
            filterEvents();

            document.addEventListener("input", function (e) {
                if (e.target && (e.target.name === "typePrice" || e.target.name === "typeSeats")) {
                    updateTicketSummary();
                }
            });
        };
    </script>
</head>
<body>
<div class="page">

    <div class="hero">
        <h1>Manage Events</h1>
        <p>Add, search, edit, cancel, and delete events with the same dark premium admin style.</p>

        <div class="top-actions">
            <div class="top-actions-left">
                <a href="<%=request.getContextPath()%>/admin/dashboard.jsp" class="btn btn-outline">Dashboard</a>
                <a href="<%=request.getContextPath()%>/user?action=list" class="btn btn-outline">Manage Users</a>
            </div>
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
        <% } else if ("error".equals(msg) || "error".equals(error)) { %>
            <div class="alert alert-error">Something went wrong. Please check the form values and try again.</div>
        <% } %>
    </div>

    <div class="panel">
        <div class="panel-head">
            <h2>Add New Event</h2>
            <p>This form now supports multiple ticket types per event without changing your existing event management features.</p>
        </div>

        <div class="panel-body">
            <form action="<%=request.getContextPath()%>/event" method="post" enctype="multipart/form-data">
                <input type="hidden" name="action" value="add">

                <div class="form-grid">
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" required placeholder="Enter event title">
                    </div>

                    <div class="form-group">
                        <label>Category</label>
                        <select name="category" required>
                            <option value="">Select category</option>
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
                        <label>Event Image</label>
                        <input type="file" name="eventImage" accept="image/*" onchange="previewNewEventImage(this)">
                        <img id="newEventPreview" class="upload-preview" alt="New event preview">
                        <div id="previewText" class="preview-text">Choose an image to preview before saving.</div>
                    </div>

                    <div class="form-group span-3">
                        <label>Description</label>
                        <textarea name="description" required placeholder="Write the event description"></textarea>
                    </div>

                    <div class="form-group span-3">
                        <label>Ticket Types</label>

                        <div class="ticket-types-box">
                            <div class="ticket-types-head">
                                <div>
                                    <div class="ticket-types-title">Per-event ticket categories</div>
                                    <div class="ticket-types-sub">Add VIP, Standard, Gold, Early Bird, or any custom ticket type with separate prices and seat counts.</div>
                                </div>

                                <button type="button" class="btn btn-add-type" onclick="addTicketTypeRow('', '', '')">
                                    + Add Ticket Type
                                </button>
                            </div>

                            <div id="ticketTypeList" class="ticket-type-list"></div>
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

                        <div class="alert alert-info" style="margin-top:16px;">
                            The event summary price and total seats will be calculated automatically from the ticket types you add.
                        </div>
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
                        placeholder="Search by event ID, title, category, venue, date, time, status, or description..."
                        onkeyup="filterEvents()">
                </div>

                <select id="categoryFilter" class="filter-select" onchange="filterEvents()">
                    <option value="all">All Categories</option>
                    <option value="concert">Concert</option>
                    <option value="technology">Technology</option>
                    <option value="sports">Sports</option>
                    <option value="cultural">Cultural</option>
                    <option value="music">Music</option>
                    <option value="conference">Conference</option>
                    <option value="workshop">Workshop</option>
                    <option value="exhibition">Exhibition</option>
                    <option value="festival">Festival</option>
                    <option value="seminar">Seminar</option>
                </select>

                <select id="statusFilter" class="filter-select" onchange="filterEvents()">
                    <option value="all">All Status</option>
                    <option value="active">Active</option>
                    <option value="cancelled">Cancelled</option>
                </select>

                <button type="button" class="btn btn-outline" onclick="clearFilters()">Clear</button>
            </div>

            <div class="result-count" id="resultCount">0 event(s) found</div>
        </div>

        <div class="table-wrap">
            <table>
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Image</th>
                    <th>Title</th>
                    <th>Category</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Venue</th>
                    <th>Price</th>
                    <th>Total Seats</th>
                    <th>Available</th>
                    <th>Status</th>
                    <th style="min-width: 260px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% if (events == null || events.isEmpty()) { %>
                    <tr>
                        <td colspan="12">
                            <div class="empty-state">No events found.</div>
                        </td>
                    </tr>
                <% } else { %>
                    <% for (Event event : events) { %>
                        <%
                            String description = event.getDescription() == null ? "" : event.getDescription();
                            String shortDescription = description.length() > 70 ? description.substring(0, 70) + "..." : description;
                        %>
                        <tr class="data-row"
                            data-event-id="<%= event.getEventId() %>"
                            data-title="<%= event.getTitle() %>"
                            data-category="<%= event.getCategory() %>"
                            data-date="<%= event.getDate() %>"
                            data-time="<%= event.getTime() %>"
                            data-venue="<%= event.getVenue() %>"
                            data-status="<%= event.getStatus() %>"
                            data-description="<%= description %>">

                            <td class="event-id"><%= event.getEventId() %></td>

                            <td>
                                <img class="event-image"
                                     src="<%=request.getContextPath()%>/event?action=image&id=<%= event.getEventId() %>"
                                     alt="event image"
                                     onerror="this.style.display='none'; this.nextElementSibling.style.display='flex';">
                                <div class="image-placeholder" style="display:none;">No Image</div>
                            </td>

                            <td>
                                <div class="event-title"><%= event.getTitle() %></div>
                                <div class="event-desc"><%= shortDescription %></div>
                            </td>

                            <td class="muted"><%= event.getCategory() %></td>
                            <td class="muted"><%= event.getDate() %></td>
                            <td class="muted"><%= event.getTime() %></td>
                            <td class="muted"><%= event.getVenue() %></td>
                            <td class="muted">LKR <%= String.format("%.2f", event.getTicketPrice()) %></td>
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
                                          onsubmit="return confirmCancel();">
                                        <input type="hidden" name="action" value="cancel">
                                        <input type="hidden" name="eventId" value="<%= event.getEventId() %>">
                                        <button type="submit" class="btn btn-cancel-event">Cancel</button>
                                    </form>

                                    <form method="post"
                                          action="<%=request.getContextPath()%>/event"
                                          style="margin:0;"
                                          onsubmit="return confirmDelete();">
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