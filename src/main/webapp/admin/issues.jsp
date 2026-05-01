<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.Issue" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%
    request.setAttribute("pageTitle", "Issue Requests");

    List<Issue> issueListRaw = (List<Issue>) request.getAttribute("issueList");
    Integer showingCountRaw = (Integer) request.getAttribute("showingCount");

    int safeShowingCount = 0;
    if (showingCountRaw != null) {
        safeShowingCount = showingCountRaw;
    } else if (issueListRaw != null) {
        safeShowingCount = issueListRaw.size();
    }
%>
<%@ include file="layout.jsp" %>

<style>
    :root {
        --accent:   #6c5ce7;
        --accent2:  #00cec9;
        --danger:   #e17055;
        --success:  #00b894;
        --warn:     #fdcb6e;
        --bg:       #0b0d12;
        --surface:  #12151d;
        --card:     #181c26;
        --border:   #262c3e;
        --text:     #e8ecf4;
        --muted:    #7b859e;
    }

    .admin-content { width: 100%; }

    .stat-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
        gap: 16px;
        margin-bottom: 28px;
    }

    .stat-card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 20px;
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .stat-card .stat-val {
        font-size: 2rem;
        font-weight: 700;
        line-height: 1;
    }

    .stat-card .stat-lbl {
        font-size: .78rem;
        color: var(--muted);
        font-weight: 500;
    }

    .stat-card.open { border-left: 3px solid var(--danger); }
    .stat-card.progress { border-left: 3px solid var(--warn); }
    .stat-card.resolved { border-left: 3px solid var(--success); }

    .filter-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 12px;
        align-items: flex-end;
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 18px 20px;
        margin-bottom: 20px;
    }

    .filter-bar label {
        font-size: .78rem;
        color: var(--muted);
        display: block;
        margin-bottom: 5px;
    }

    .filter-bar select,
    .filter-bar input {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 8px;
        color: var(--text);
        padding: 8px 12px;
        font-family: 'Sora', sans-serif;
        font-size: .85rem;
    }

    .filter-bar select:focus,
    .filter-bar input:focus {
        outline: none;
        border-color: var(--accent);
    }

    .btn-filter {
        padding: 9px 20px;
        background: var(--accent);
        border: none;
        border-radius: 8px;
        color: #fff;
        font-family: 'Sora', sans-serif;
        font-size: .85rem;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 6px;
        text-decoration: none;
    }

    .btn-filter:hover { opacity: .88; }

    .btn-reset {
        padding: 9px 16px;
        background: transparent;
        border: 1px solid var(--border);
        border-radius: 8px;
        color: var(--muted);
        font-family: 'Sora', sans-serif;
        font-size: .85rem;
        cursor: pointer;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
    }

    .btn-reset:hover {
        color: var(--text);
        border-color: var(--text);
    }

    .table-wrap {
        overflow-x: auto;
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: 14px;
    }

    table {
        width: 100%;
        border-collapse: collapse;
    }

    th {
        font-size: .75rem;
        font-weight: 600;
        color: var(--muted);
        text-transform: uppercase;
        letter-spacing: .6px;
        padding: 12px 16px;
        border-bottom: 1px solid var(--border);
        background: var(--surface);
        text-align: left;
    }

    td {
        padding: 14px 16px;
        border-bottom: 1px solid rgba(255,255,255,0.04);
        font-size: .88rem;
        color: var(--text);
        vertical-align: middle;
    }

    tr:hover td {
        background: rgba(255,255,255,0.015);
    }

    .badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 4px 11px;
        border-radius: 100px;
        font-size: .74rem;
        font-weight: 600;
    }

    .badge-open {
        background: rgba(225,112,85,.12);
        color: var(--danger);
        border: 1px solid rgba(225,112,85,.3);
    }

    .badge-progress {
        background: rgba(253,203,110,.12);
        color: var(--warn);
        border: 1px solid rgba(253,203,110,.3);
    }

    .badge-resolved {
        background: rgba(0,184,148,.12);
        color: var(--success);
        border: 1px solid rgba(0,184,148,.3);
    }

    .badge-rejected {
        background: rgba(99,110,114,.12);
        color: #b2bec3;
        border: 1px solid rgba(99,110,114,.3);
    }

    .priority-dot {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        margin-right: 6px;
    }

    .p-high { background: var(--danger); }
    .p-medium { background: var(--warn); }
    .p-low { background: var(--success); }

    .btn-view {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 8px 12px;
        border-radius: 8px;
        background: rgba(108,92,231,.12);
        color: #a29bfe;
        border: 1px solid rgba(108,92,231,.28);
        text-decoration: none;
        font-size: .8rem;
        font-weight: 600;
    }

    .btn-view:hover {
        background: rgba(108,92,231,.18);
    }

    .empty-state {
        padding: 48px 24px;
        text-align: center;
        color: var(--muted);
        font-size: .95rem;
    }

    .empty-state i {
        display: block;
        font-size: 2rem;
        margin-bottom: 12px;
        color: var(--accent2);
    }

    .cat-chip {
        background: rgba(108,92,231,.1);
        color: #a29bfe;
        padding: 4px 12px;
        border-radius: 7px;
        font-size: .78rem;
        display: inline-block;
    }

    .id-cell {
        font-family: 'JetBrains Mono', monospace;
        font-size: .78rem;
        color: var(--muted);
    }

    .page-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 12px;
    }

    .page-header h2 {
        font-size: 1.4rem;
        font-weight: 700;
    }

    .page-header h2 span {
        color: var(--accent2);
    }

    .admin-badge {
        background: rgba(0,206,201,.1);
        border: 1px solid rgba(0,206,201,.25);
        color: var(--accent2);
        padding: 5px 14px;
        border-radius: 100px;
        font-size: .78rem;
        font-weight: 600;
    }
</style>

<div class="admin-content">

    <div class="page-header">
        <h2>Issue <span>Management</span></h2>
        <span class="admin-badge"><i class="fas fa-user-shield"></i> ${adminType}</span>
    </div>

    <div class="stat-grid">
        <div class="stat-card open">
            <span class="stat-val" style="color:var(--danger);">${openCount}</span>
            <span class="stat-lbl">Open Issues</span>
        </div>
        <div class="stat-card progress">
            <span class="stat-val" style="color:var(--warn);">${progressCount}</span>
            <span class="stat-lbl">In Progress</span>
        </div>
        <div class="stat-card resolved">
            <span class="stat-val" style="color:var(--success);">${resolvedCount}</span>
            <span class="stat-lbl">Resolved</span>
        </div>
        <div class="stat-card" style="border-left:3px solid var(--accent);">
            <span class="stat-val" style="color:var(--accent);"><%= safeShowingCount %></span>
            <span class="stat-lbl">Showing</span>
        </div>
    </div>

    <form action="${pageContext.request.contextPath}/IssueServlet" method="get" class="filter-bar">
        <input type="hidden" name="action" value="adminList" />

        <div>
            <label>Category</label>
            <select name="category">
                <option value="">All Categories</option>
                <optgroup label="Booking &amp; Payments">
                    <option value="Booking Problem" <c:if test="${catFilter=='Booking Problem'}">selected</c:if>>Booking Problem</option>
                    <option value="Payment Verification Issue" <c:if test="${catFilter=='Payment Verification Issue'}">selected</c:if>>Payment Verification Issue</option>
                    <option value="Ticket Not Received" <c:if test="${catFilter=='Ticket Not Received'}">selected</c:if>>Ticket Not Received</option>
                    <option value="QR Code Not Working" <c:if test="${catFilter=='QR Code Not Working'}">selected</c:if>>QR Code Not Working</option>
                    <option value="Refund Request" <c:if test="${catFilter=='Refund Request'}">selected</c:if>>Refund Request</option>
                    <option value="Seat Availability Problem" <c:if test="${catFilter=='Seat Availability Problem'}">selected</c:if>>Seat Availability Problem</option>
                </optgroup>
                <optgroup label="Events">
                    <option value="Event Information Error" <c:if test="${catFilter=='Event Information Error'}">selected</c:if>>Event Information Error</option>
                    <option value="Event Cancellation Complaint" <c:if test="${catFilter=='Event Cancellation Complaint'}">selected</c:if>>Event Cancellation Complaint</option>
                </optgroup>
                <optgroup label="Account &amp; Technical">
                    <option value="Account Login Problem" <c:if test="${catFilter=='Account Login Problem'}">selected</c:if>>Account Login Problem</option>
                    <option value="Profile / Registration Problem" <c:if test="${catFilter=='Profile / Registration Problem'}">selected</c:if>>Profile / Registration Problem</option>
                    <option value="Website Technical Issue" <c:if test="${catFilter=='Website Technical Issue'}">selected</c:if>>Website Technical Issue</option>
                </optgroup>
                <optgroup label="General">
                    <option value="General Inquiry" <c:if test="${catFilter=='General Inquiry'}">selected</c:if>>General Inquiry</option>
                    <option value="Other" <c:if test="${catFilter=='Other'}">selected</c:if>>Other</option>
                </optgroup>
            </select>
        </div>

        <div>
            <label>Status</label>
            <select name="status">
                <option value="">All Statuses</option>
                <option value="OPEN" <c:if test="${statFilter=='OPEN'}">selected</c:if>>Open</option>
                <option value="IN_PROGRESS" <c:if test="${statFilter=='IN_PROGRESS'}">selected</c:if>>In Progress</option>
                <option value="RESOLVED" <c:if test="${statFilter=='RESOLVED'}">selected</c:if>>Resolved</option>
                <option value="REJECTED" <c:if test="${statFilter=='REJECTED'}">selected</c:if>>Rejected</option>
            </select>
        </div>

        <button type="submit" class="btn-filter"><i class="fas fa-filter"></i> Filter</button>
        <a href="${pageContext.request.contextPath}/IssueServlet?action=adminList" class="btn-reset">Reset</a>
    </form>

    <div class="table-wrap">
        <%
            if (issueListRaw != null && !issueListRaw.isEmpty()) {
        %>
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Customer</th>
                    <th>Category</th>
                    <th>Subject</th>
                    <th>Priority</th>
                    <th>Status</th>
                    <th>Submitted</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
                <%
                    for (Issue issue : issueListRaw) {
                        String priority = issue.getPriority() != null ? issue.getPriority() : "MEDIUM";
                        String priorityClass = priority.toLowerCase();

                        String status = issue.getStatus() != null ? issue.getStatus() : "OPEN";
                        String badgeClass = "badge-" + status.toLowerCase();
                        if ("IN_PROGRESS".equals(status)) {
                            badgeClass = "badge-progress";
                        }
                %>
                <tr>
                    <td class="id-cell">#<%= issue.getIssueId() %></td>
                    <td>
                        <div style="font-weight:500;">
                            <%= (issue.getUserName() != null && !issue.getUserName().trim().isEmpty())
                                    ? issue.getUserName()
                                    : "Customer #" + issue.getUserId() %>
                        </div>
                        <div style="font-size:.76rem;color:var(--muted);">
                            <%= issue.getCustomerEmail() != null ? issue.getCustomerEmail() : "" %>
                        </div>
                    </td>
                    <td>
                        <span class="cat-chip"><%= issue.getCategory() != null ? issue.getCategory() : "" %></span>
                    </td>
                    <td style="max-width:220px;">
                        <div style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:220px;"
                             title="<%= issue.getSubject() != null ? issue.getSubject() : "" %>">
                            <%= issue.getSubject() != null ? issue.getSubject() : "" %>
                        </div>
                    </td>
                    <td>
                        <span class="priority-dot p-<%= priorityClass %>"></span>
                        <%= priority %>
                    </td>
                    <td>
                        <span class="badge <%= badgeClass %>">
                            <%= status %>
                        </span>
                    </td>
                    <td style="white-space:nowrap;color:var(--muted);font-size:.8rem;">
                        <%
                            if (issue.getCreatedAt() != null) {
                        %>
                            <fmt:formatDate value="<%= issue.getCreatedAt() %>" pattern="dd MMM yyyy" />
                        <%
                            } else {
                        %>
                            -
                        <%
                            }
                        %>
                    </td>
                    <td>
                        <a href="<%= request.getContextPath() %>/IssueServlet?action=adminDetail&id=<%= issue.getIssueId() %>" class="btn-view">
                            <i class="fas fa-eye"></i> View
                        </a>
                    </td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        <%
            } else {
        %>
        <div class="empty-state">
            <i class="fas fa-inbox"></i>
            No issues found matching your filters.
        </div>
        <%
            }
        %>
    </div>

</div>

</main>
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