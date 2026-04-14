<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.eventhorizon.service.BookingService, java.util.List, com.eventhorizon.model.Booking" %>

<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;
    String userName = currentSession != null ? (String) currentSession.getAttribute("userName") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    BookingService bookingService = new BookingService();
    List<Booking> bookings = bookingService.getAllBookings();
    int bookingCount = bookings != null ? bookings.size() : 0;
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bookings - EventHorizon</title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

    <style>
        .bookings-shell {
            display: flex;
            flex-direction: column;
            gap: 24px;
        }

        .bookings-hero {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
            padding: 28px;
            border-radius: 24px;
            background:
                linear-gradient(135deg, rgba(124, 58, 237, 0.16), rgba(6, 182, 212, 0.10)),
                rgba(15, 23, 42, 0.75);
            border: 1px solid rgba(255,255,255,0.08);
            box-shadow: 0 20px 40px rgba(0,0,0,0.25);
        }

        .bookings-hero h2 {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 8px;
            color: #f8fafc;
        }

        .bookings-hero p {
            margin: 0;
            color: var(--text-secondary);
            max-width: 760px;
        }

        .bookings-summary {
            display: flex;
            gap: 16px;
            flex-wrap: wrap;
        }

        .summary-card {
            min-width: 180px;
            padding: 18px 20px;
            border-radius: 20px;
            background: rgba(255,255,255,0.04);
            border: 1px solid rgba(255,255,255,0.08);
        }

        .summary-card .label {
            display: block;
            font-size: 0.82rem;
            color: var(--text-muted);
            margin-bottom: 6px;
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .summary-card .value {
            font-size: 1.7rem;
            font-weight: 800;
            color: #f8fafc;
        }

        .booking-panel {
            background: var(--card-bg);
            border: 1px solid var(--border-color);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 18px 36px rgba(0,0,0,0.22);
        }

        .booking-toolbar {
            display: flex;
            justify-content: space-between;
            align-items: center;
            gap: 14px;
            flex-wrap: wrap;
            padding: 22px 24px;
            border-bottom: 1px solid var(--border-color);
            background: rgba(255,255,255,0.02);
        }

        .toolbar-left h3 {
            margin: 0 0 6px;
            font-size: 1.2rem;
            color: #f8fafc;
        }

        .toolbar-left p {
            margin: 0;
            color: var(--text-secondary);
            font-size: 0.95rem;
        }

        .search-wrap {
            display: flex;
            align-items: center;
            gap: 10px;
            min-width: 320px;
            max-width: 480px;
            width: 100%;
            padding: 12px 14px;
            border-radius: 16px;
            background: rgba(2, 6, 23, 0.55);
            border: 1px solid rgba(255,255,255,0.08);
        }

        .search-wrap i {
            color: var(--text-muted);
        }

        .search-wrap input {
            flex: 1;
            border: none;
            outline: none;
            background: transparent;
            color: #f8fafc;
            font-size: 0.96rem;
        }

        .search-wrap input::placeholder {
            color: var(--text-muted);
        }

        .table-holder {
            overflow-x: auto;
        }

        .bookings-table {
            width: 100%;
            border-collapse: collapse;
            min-width: 1050px;
        }

        .bookings-table thead th {
            text-align: left;
            padding: 18px 20px;
            font-size: 0.82rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color: var(--text-muted);
            background: rgba(255,255,255,0.02);
            border-bottom: 1px solid var(--border-color);
        }

        .bookings-table tbody td {
            padding: 18px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.06);
            color: #dbe4f0;
            vertical-align: middle;
        }

        .bookings-table tbody tr:hover {
            background: rgba(255,255,255,0.02);
        }

        .booking-id {
            font-family: "Courier New", monospace;
            font-weight: 700;
            color: #22d3ee;
            font-size: 0.88rem;
        }

        .event-title {
            font-weight: 700;
            color: #f8fafc;
        }

        .total-amount {
            font-weight: 700;
            color: #67e8f9;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 8px 12px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 800;
            letter-spacing: 0.04em;
            text-transform: uppercase;
        }

        .status-confirmed {
            color: #86efac;
            background: rgba(34, 197, 94, 0.14);
            border: 1px solid rgba(34, 197, 94, 0.22);
        }

        .status-cancelled {
            color: #fca5a5;
            background: rgba(239, 68, 68, 0.14);
            border: 1px solid rgba(239, 68, 68, 0.22);
        }

        .btn-cancel-booking {
            border: none;
            border-radius: 12px;
            padding: 10px 14px;
            font-weight: 700;
            cursor: pointer;
            color: #fff;
            background: linear-gradient(135deg, #ef4444, #f97316);
            transition: transform 0.2s ease, opacity 0.2s ease;
        }

        .btn-cancel-booking:hover {
            transform: translateY(-1px);
            opacity: 0.95;
        }

        .muted-dash {
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        .empty-bookings {
            padding: 48px 24px;
            text-align: center;
            color: var(--text-secondary);
        }

        .alert-inline {
            margin: 0 24px 20px;
            padding: 14px 16px;
            border-radius: 16px;
            border: 1px solid rgba(6, 182, 212, 0.22);
            background: rgba(6, 182, 212, 0.08);
            color: #bae6fd;
            font-weight: 600;
        }

        @media (max-width: 900px) {
            .bookings-hero {
                padding: 22px;
            }

            .summary-card {
                min-width: 150px;
            }

            .search-wrap {
                min-width: 100%;
                max-width: 100%;
            }
        }
    </style>
</head>
<body>

<div class="admin-shell">

    <aside class="sidebar">
        <div>
            <div class="brand">
                <div class="brand-icon">⬡</div>
                <div>
                    <h2>EVENTHORIZON</h2>
                    <p>Admin Workspace</p>
                </div>
            </div>

            <nav class="nav-links">
                <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">
                    <i class="fa-solid fa-chart-line"></i>
                    <span>Dashboard</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=list">
                    <i class="fa-solid fa-users"></i>
                    <span>Manage Users</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=addAdminForm">
                    <i class="fa-solid fa-user-plus"></i>
                    <span>Request New Admin</span>
                </a>

                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">
                    <i class="fa-solid fa-user-check"></i>
                    <span>Admin Requests</span>
                </a>

                <a href="<%= request.getContextPath() %>/event?action=adminList">
                    <i class="fa-solid fa-calendar-days"></i>
                    <span>Manage Events</span>
                </a>

                <a class="active" href="<%= request.getContextPath() %>/admin/bookings.jsp">
                    <i class="fa-solid fa-ticket"></i>
                    <span>Bookings</span>
                </a>
            </nav>
        </div>

        <div class="sidebar-footer">
            <a class="back-site" href="<%= request.getContextPath() %>/event?action=list">
                <i class="fa-solid fa-globe"></i>
                <span>Open Website</span>
            </a>

            <a class="logout-btn" href="<%= request.getContextPath() %>/user?action=logout">
                <i class="fa-solid fa-right-from-bracket"></i>
                <span>Logout</span>
            </a>
        </div>
    </aside>

    <main class="main-content">
        <section class="topbar">
            <div>
                <p class="eyebrow">Administration</p>
                <h1>Bookings</h1>
                <p class="subtitle">Welcome back, <strong><%= userName != null ? userName : "Admin" %></strong></p>
            </div>

            <div class="topbar-badge">
                <i class="fa-solid fa-ticket"></i>
                <span>Booking Control</span>
            </div>
        </section>

        <div class="bookings-shell">
            <section class="bookings-hero">
                <div>
                    <h2>All Booking Records</h2>
                    <p>Review confirmed and cancelled reservations, search instantly, and manage booking activity from the same premium admin workspace.</p>
                </div>

                <div class="bookings-summary">
                    <div class="summary-card">
                        <span class="label">Total Bookings</span>
                        <span class="value"><%= bookingCount %></span>
                    </div>
                </div>
            </section>

            <% if ("cancelled".equals(request.getParameter("msg"))) { %>
                <div class="alert-inline">
                    Booking cancelled successfully and seats were restored.
                </div>
            <% } %>

            <section class="booking-panel">
                <div class="booking-toolbar">
                    <div class="toolbar-left">
                        <h3>Booking Table</h3>
                        <p>Search by booking ID, customer ID, or event title.</p>
                    </div>

                    <div class="search-wrap">
                        <i class="fa-solid fa-magnifying-glass"></i>
                        <input type="text" id="liveSearch" placeholder="Search bookings...">
                    </div>
                </div>

                <div class="table-holder">
                    <table class="bookings-table">
                        <thead>
                            <tr>
                                <th>Booking ID</th>
                                <th>Customer ID</th>
                                <th>Event</th>
                                <th>Tickets</th>
                                <th>Total (LKR)</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody id="bookingTableBody">
                        <% if (bookings == null || bookings.isEmpty()) { %>
                            <tr>
                                <td colspan="8">
                                    <div class="empty-bookings">No bookings found.</div>
                                </td>
                            </tr>
                        <% } else { %>
                            <% for (Booking b : bookings) { %>
                                <tr data-search-row>
                                    <td class="booking-id"><%= b.getBookingId() %></td>
                                    <td><%= b.getCustomerId() %></td>
                                    <td class="event-title"><%= b.getEventTitle() %></td>
                                    <td><%= b.getNumberOfTickets() %></td>
                                    <td class="total-amount"><%= b.getTotalAmount() %></td>
                                    <td><%= b.getBookingDate() %></td>
                                    <td>
                                        <% if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                            <span class="status-badge status-confirmed">Confirmed</span>
                                        <% } else { %>
                                            <span class="status-badge status-cancelled">Cancelled</span>
                                        <% } %>
                                    </td>
                                    <td>
                                        <% if ("CONFIRMED".equalsIgnoreCase(b.getStatus())) { %>
                                            <form action="<%= request.getContextPath() %>/booking" method="post" style="display:inline;">
                                                <input type="hidden" name="action" value="cancel">
                                                <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                                                <button type="submit"
                                                        class="btn-cancel-booking"
                                                        onclick="return confirm('Cancel this booking and restore seats?');">
                                                    Cancel
                                                </button>
                                            </form>
                                        <% } else { %>
                                            <span class="muted-dash">—</span>
                                        <% } %>
                                    </td>
                                </tr>
                            <% } %>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </section>
        </div>
    </main>
</div>

<script>
    (function () {
        var searchInput = document.getElementById("liveSearch");
        var rows = document.querySelectorAll("[data-search-row]");

        if (!searchInput) return;

        searchInput.addEventListener("input", function () {
            var keyword = searchInput.value.toLowerCase().trim();

            rows.forEach(function (row) {
                var text = row.innerText.toLowerCase();
                row.style.display = text.indexOf(keyword) !== -1 ? "" : "none";
            });
        });
    })();
</script>

</body>
</html>