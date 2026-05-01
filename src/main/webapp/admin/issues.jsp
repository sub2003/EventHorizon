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
        --accent: #1E4A3A;
        --accent2: #2E6B55;
        --danger: #A23A27;
        --success: #176B3B;
        --warn: #76520F;
        --surface: #FAF8F4;
        --card: #FFFFFF;
        --border: rgba(30, 74, 58, 0.16);
        --border-strong: rgba(30, 74, 58, 0.30);
        --text: #18251F;
        --muted: #52635A;
        --soft: #E8F1EC;
        --shadow: 0 18px 45px rgba(24, 37, 31, 0.09);
    }

    .admin-content { width: 100%; }

    .issue-page-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 24px;
        flex-wrap: wrap;
        gap: 14px;
    }

    .issue-page-header h2 {
        font-size: clamp(1.65rem, 3vw, 2.1rem);
        font-weight: 900;
        color: #123528;
        letter-spacing: -0.04em;
        line-height: 1.12;
    }

    .issue-page-header h2 span { color: var(--accent); }

    .issue-page-subtitle {
        margin-top: 6px;
        color: var(--muted);
        font-weight: 650;
        font-size: 0.95rem;
    }

    .admin-badge {
        background: #ffffff;
        border: 1px solid var(--border-strong);
        color: #123528;
        padding: 8px 14px;
        border-radius: 999px;
        font-size: .8rem;
        font-weight: 900;
        box-shadow: 0 10px 24px rgba(24, 37, 31, 0.06);
        display: inline-flex;
        align-items: center;
        gap: 8px;
        white-space: nowrap;
    }

    .admin-badge i { color: var(--accent); }

    .stat-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
        gap: 18px;
        margin-bottom: 24px;
    }

    .stat-card {
        background: #ffffff;
        border: 1px solid var(--border);
        border-radius: 20px;
        padding: 20px;
        display: flex;
        flex-direction: column;
        gap: 7px;
        box-shadow: var(--shadow);
        position: relative;
        overflow: hidden;
    }

    .stat-card::before {
        content: "";
        position: absolute;
        inset: 0 0 auto 0;
        height: 5px;
        background: var(--accent);
    }

    .stat-card.open::before { background: var(--danger); }
    .stat-card.progress::before { background: #C2882E; }
    .stat-card.resolved::before { background: var(--success); }
    .stat-card.showing::before { background: var(--accent); }

    .stat-card .stat-val {
        font-size: 2.15rem;
        font-weight: 900;
        line-height: 1;
        letter-spacing: -0.04em;
    }

    .stat-card .stat-lbl {
        font-size: .82rem;
        color: var(--muted);
        font-weight: 850;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .filter-bar {
        display: flex;
        flex-wrap: wrap;
        gap: 14px;
        align-items: flex-end;
        background: #ffffff;
        border: 1px solid var(--border);
        border-radius: 20px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: var(--shadow);
    }

    .filter-bar > div { min-width: 220px; }

    .filter-bar label {
        font-size: .78rem;
        color: #123528;
        display: block;
        margin-bottom: 7px;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.6px;
    }

    .filter-bar select,
    .filter-bar input {
        background: #ffffff;
        border: 1px solid var(--border-strong);
        border-radius: 12px;
        color: var(--text);
        padding: 11px 13px;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        font-size: .9rem;
        font-weight: 700;
        outline: none;
        min-height: 43px;
    }

    .filter-bar select:focus,
    .filter-bar input:focus {
        border-color: rgba(30, 74, 58, 0.52);
        box-shadow: 0 0 0 4px rgba(30, 74, 58, 0.10);
    }

    .btn-filter,
    .btn-reset,
    .btn-view {
        min-height: 43px;
        padding: 10px 16px;
        border-radius: 12px;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        font-size: .88rem;
        font-weight: 900;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        text-decoration: none;
        transition: 0.22s ease;
        white-space: nowrap;
    }

    .btn-filter {
        background: linear-gradient(135deg, #1E4A3A, #123528);
        border: 1px solid transparent;
        color: #fff;
        box-shadow: 0 12px 26px rgba(30, 74, 58, 0.22);
    }

    .btn-filter:hover { transform: translateY(-1px); }

    .btn-reset,
    .btn-view {
        background: #ffffff;
        border: 1px solid var(--border-strong);
        color: #123528;
        box-shadow: none;
    }

    .btn-reset:hover,
    .btn-view:hover {
        background: var(--soft);
        border-color: rgba(30, 74, 58, 0.42);
        transform: translateY(-1px);
    }

    .table-wrap {
        overflow-x: auto;
        background: #ffffff;
        border: 1px solid var(--border);
        border-radius: 22px;
        box-shadow: var(--shadow);
        padding: 18px;
    }

    table {
        width: 100%;
        border-collapse: separate;
        border-spacing: 0;
        min-width: 980px;
        background: #ffffff;
    }

    th {
        font-size: .75rem;
        font-weight: 900;
        color: #123528;
        text-transform: uppercase;
        letter-spacing: .7px;
        padding: 14px 16px;
        border-bottom: 1px solid var(--border-strong);
        background: var(--soft);
        text-align: left;
    }

    td {
        padding: 16px;
        border-bottom: 1px solid rgba(30, 74, 58, 0.12);
        font-size: .9rem;
        color: var(--text);
        vertical-align: middle;
        font-weight: 700;
    }

    tr:hover td { background: #FAF8F4; }
    tbody tr:last-child td { border-bottom: none; }

    .badge,
    .cat-chip {
        display: inline-flex;
        align-items: center;
        gap: 6px;
        padding: 6px 12px;
        border-radius: 999px;
        font-size: .74rem;
        font-weight: 900;
        border: 1px solid var(--border-strong);
        background: var(--soft);
        color: #123528;
        white-space: nowrap;
    }

    .badge-open {
        background: #FFF0EC;
        color: var(--danger);
        border-color: rgba(162, 58, 39, 0.24);
    }

    .badge-progress {
        background: #FFF7E3;
        color: var(--warn);
        border-color: rgba(138, 90, 0, 0.24);
    }

    .badge-resolved {
        background: #E8F6EE;
        color: var(--success);
        border-color: rgba(23, 107, 59, 0.24);
    }

    .badge-rejected {
        background: #F1F3F1;
        color: #65726C;
        border-color: rgba(101, 114, 108, 0.24);
    }

    .priority-dot {
        display: inline-block;
        width: 10px;
        height: 10px;
        border-radius: 50%;
        margin-right: 7px;
        vertical-align: middle;
    }

    .p-high { background: var(--danger); }
    .p-medium { background: #C2882E; }
    .p-low { background: var(--success); }

    .id-cell {
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        font-size: .82rem;
        color: var(--muted);
        font-weight: 900;
    }

    .empty-state {
        padding: 52px 24px;
        text-align: center;
        color: var(--muted);
        font-size: .96rem;
        font-weight: 700;
    }

    .empty-state i {
        display: block;
        font-size: 2.2rem;
        margin-bottom: 12px;
        color: var(--accent);
    }

    @media (max-width: 760px) {
        .filter-bar { align-items: stretch; }
        .filter-bar > div,
        .btn-filter,
        .btn-reset { width: 100%; }
    }
</style>

<div class="admin-content">

    <div class="issue-page-header">
        <div>
            <h2>Issue <span>Management</span></h2>
            <p class="issue-page-subtitle">Review customer reports, filter requests, and open each issue for admin action.</p>
        </div>
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
        <div class="stat-card showing">
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

</body>
</html>