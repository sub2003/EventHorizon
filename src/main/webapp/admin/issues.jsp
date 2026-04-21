<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Issue Management — EventHorizon Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <%-- Include your shared admin stylesheet --%>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin.css" />
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

        /* ── STAT CARDS ─────────────────────────────────────────── */
        .stat-grid {
            display: grid; grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 16px; margin-bottom: 28px;
        }
        .stat-card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 20px;
            display: flex; flex-direction: column; gap: 6px;
        }
        .stat-card .stat-val { font-size: 2rem; font-weight: 700; line-height: 1; }
        .stat-card .stat-lbl { font-size: .78rem; color: var(--muted); font-weight: 500; }
        .stat-card.open     { border-left: 3px solid var(--danger); }
        .stat-card.progress { border-left: 3px solid var(--warn); }
        .stat-card.resolved { border-left: 3px solid var(--success); }

        /* ── FILTER BAR ─────────────────────────────────────────── */
        .filter-bar {
            display: flex; flex-wrap: wrap; gap: 12px; align-items: flex-end;
            background: var(--card); border: 1px solid var(--border);
            border-radius: 14px; padding: 18px 20px; margin-bottom: 20px;
        }
        .filter-bar label { font-size: .78rem; color: var(--muted); display: block; margin-bottom: 5px; }
        .filter-bar select, .filter-bar input {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 8px; color: var(--text); padding: 8px 12px;
            font-family: 'Sora', sans-serif; font-size: .85rem;
        }
        .filter-bar select:focus { outline: none; border-color: var(--accent); }
        .btn-filter {
            padding: 9px 20px; background: var(--accent); border: none;
            border-radius: 8px; color: #fff; font-family: 'Sora', sans-serif;
            font-size: .85rem; font-weight: 600; cursor: pointer;
            display: flex; align-items: center; gap: 6px;
        }
        .btn-filter:hover { opacity: .88; }
        .btn-reset {
            padding: 9px 16px; background: transparent; border: 1px solid var(--border);
            border-radius: 8px; color: var(--muted); font-family: 'Sora', sans-serif;
            font-size: .85rem; cursor: pointer;
        }
        .btn-reset:hover { color: var(--text); border-color: var(--text); }

        /* ── TABLE ──────────────────────────────────────────────── */
        .table-wrap { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; }
        th {
            font-size: .75rem; font-weight: 600; color: var(--muted);
            text-transform: uppercase; letter-spacing: .6px;
            padding: 12px 16px; border-bottom: 1px solid var(--border);
            background: var(--surface); text-align: left;
        }
        th:first-child { border-radius: 10px 0 0 0; }
        th:last-child  { border-radius: 0 10px 0 0; }
        td {
            padding: 14px 16px; font-size: .86rem;
            border-bottom: 1px solid rgba(38,44,62,.6);
            vertical-align: middle;
        }
        tr:hover td { background: rgba(108,92,231,.04); }

        /* ── BADGES ─────────────────────────────────────────────── */
        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 10px; border-radius: 100px; font-size: .73rem; font-weight: 600;
        }
        .badge-open     { background: rgba(225,112,85,.12); color: var(--danger);  border: 1px solid rgba(225,112,85,.3); }
        .badge-progress { background: rgba(253,203,110,.12); color: var(--warn);   border: 1px solid rgba(253,203,110,.3); }
        .badge-resolved { background: rgba(0,184,148,.12);  color: var(--success); border: 1px solid rgba(0,184,148,.3); }
        .badge-rejected { background: rgba(99,110,114,.12); color: #b2bec3;        border: 1px solid rgba(99,110,114,.3); }

        .priority-dot {
            display: inline-block; width: 8px; height: 8px; border-radius: 50%; margin-right: 5px;
        }
        .p-high   { background: var(--danger);  }
        .p-medium { background: var(--warn);    }
        .p-low    { background: var(--success); }

        /* category chip */
        .cat-chip {
            background: rgba(108,92,231,.1); color: #a29bfe;
            padding: 3px 10px; border-radius: 6px; font-size: .75rem; white-space: nowrap;
        }

        /* action btn */
        .btn-view {
            padding: 7px 14px; background: rgba(108,92,231,.15);
            border: 1px solid rgba(108,92,231,.3); border-radius: 8px;
            color: #a29bfe; font-size: .8rem; font-weight: 600; text-decoration: none;
            transition: all .2s; white-space: nowrap;
        }
        .btn-view:hover { background: var(--accent); color: #fff; }

        /* empty state */
        .empty-state {
            text-align: center; padding: 60px 20px;
            color: var(--muted); font-size: .9rem;
        }
        .empty-state i { font-size: 2.5rem; display: block; margin-bottom: 12px; opacity: .4; }

        /* ID mono */
        .id-cell { font-family: 'JetBrains Mono', monospace; font-size: .78rem; color: var(--muted); }

        /* Page header */
        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 24px; flex-wrap: wrap; gap: 12px;
        }
        .page-header h2 { font-size: 1.4rem; font-weight: 700; }
        .page-header h2 span { color: var(--accent2); }
        .admin-badge {
            background: rgba(0,206,201,.1); border: 1px solid rgba(0,206,201,.25);
            color: var(--accent2); padding: 5px 14px; border-radius: 100px; font-size: .78rem; font-weight: 600;
        }
    </style>
</head>
<body>

<%-- Include your shared admin sidebar/layout --%>
<%@ include file="layout.jsp" %>

<div class="admin-content"> <%-- adjust class to match your layout wrapper --%>

    <!-- Header -->
    <div class="page-header">
        <h2>Issue <span>Management</span></h2>
        <span class="admin-badge"><i class="fas fa-user-shield"></i> ${adminType}</span>
    </div>

    <!-- Stat Cards -->
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
            <span class="stat-val" style="color:var(--accent);">${issues.size()}</span>
            <span class="stat-lbl">Showing</span>
        </div>
    </div>

    <!-- Filter Bar -->
    <form action="${pageContext.request.contextPath}/IssueServlet" method="get" class="filter-bar">
        <input type="hidden" name="action" value="adminList" />

        <div>
            <label>Category</label>
            <select name="category">
                <option value="">All Categories</option>
                <optgroup label="Booking &amp; Payments">
                    <option value="Booking Problem"            <c:if test="${catFilter=='Booking Problem'}">selected</c:if>>Booking Problem</option>
                    <option value="Payment Verification Issue" <c:if test="${catFilter=='Payment Verification Issue'}">selected</c:if>>Payment Verification Issue</option>
                    <option value="Ticket Not Received"        <c:if test="${catFilter=='Ticket Not Received'}">selected</c:if>>Ticket Not Received</option>
                    <option value="QR Code Not Working"        <c:if test="${catFilter=='QR Code Not Working'}">selected</c:if>>QR Code Not Working</option>
                    <option value="Refund Request"             <c:if test="${catFilter=='Refund Request'}">selected</c:if>>Refund Request</option>
                    <option value="Seat Availability Problem"  <c:if test="${catFilter=='Seat Availability Problem'}">selected</c:if>>Seat Availability Problem</option>
                </optgroup>
                <optgroup label="Events">
                    <option value="Event Information Error"      <c:if test="${catFilter=='Event Information Error'}">selected</c:if>>Event Information Error</option>
                    <option value="Event Cancellation Complaint" <c:if test="${catFilter=='Event Cancellation Complaint'}">selected</c:if>>Event Cancellation Complaint</option>
                </optgroup>
                <optgroup label="Account &amp; Technical">
                    <option value="Account Login Problem"          <c:if test="${catFilter=='Account Login Problem'}">selected</c:if>>Account Login Problem</option>
                    <option value="Profile / Registration Problem" <c:if test="${catFilter=='Profile / Registration Problem'}">selected</c:if>>Profile / Registration Problem</option>
                    <option value="Website Technical Issue"        <c:if test="${catFilter=='Website Technical Issue'}">selected</c:if>>Website Technical Issue</option>
                </optgroup>
                <optgroup label="General">
                    <option value="General Inquiry" <c:if test="${catFilter=='General Inquiry'}">selected</c:if>>General Inquiry</option>
                    <option value="Other"           <c:if test="${catFilter=='Other'}">selected</c:if>>Other</option>
                </optgroup>
            </select>
        </div>

        <div>
            <label>Status</label>
            <select name="status">
                <option value="">All Statuses</option>
                <option value="OPEN"        <c:if test="${statFilter=='OPEN'}">selected</c:if>>Open</option>
                <option value="IN_PROGRESS" <c:if test="${statFilter=='IN_PROGRESS'}">selected</c:if>>In Progress</option>
                <option value="RESOLVED"    <c:if test="${statFilter=='RESOLVED'}">selected</c:if>>Resolved</option>
                <option value="REJECTED"    <c:if test="${statFilter=='REJECTED'}">selected</c:if>>Rejected</option>
            </select>
        </div>

        <button type="submit" class="btn-filter"><i class="fas fa-filter"></i> Filter</button>
        <a href="${pageContext.request.contextPath}/IssueServlet?action=adminList" class="btn-reset">Reset</a>
    </form>

    <!-- Table -->
    <div class="table-wrap">
        <c:choose>
            <c:when test="${not empty issues}">
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
                        <c:forEach var="issue" items="${issues}">
                        <tr>
                            <td class="id-cell">#${issue.issueId}</td>
                            <td>
                                <div style="font-weight:500;">${issue.userName}</div>
                                <div style="font-size:.76rem;color:var(--muted);">${issue.customerEmail}</div>
                            </td>
                            <td><span class="cat-chip">${issue.category}</span></td>
                            <td style="max-width:220px;">
                                <div style="white-space:nowrap;overflow:hidden;text-overflow:ellipsis;max-width:220px;" title="${issue.subject}">
                                    ${issue.subject}
                                </div>
                            </td>
                            <td>
                                <span class="priority-dot p-${issue.priority.toLowerCase()}"></span>
                                ${issue.priority}
                            </td>
                            <td>
                                <span class="badge badge-${issue.status == 'IN_PROGRESS' ? 'progress' : issue.status.toLowerCase()}">
                                    <c:choose>
                                        <c:when test="${issue.status == 'OPEN'}"><i class="fas fa-circle-dot"></i> Open</c:when>
                                        <c:when test="${issue.status == 'IN_PROGRESS'}"><i class="fas fa-spinner"></i> In Progress</c:when>
                                        <c:when test="${issue.status == 'RESOLVED'}"><i class="fas fa-check-circle"></i> Resolved</c:when>
                                        <c:otherwise><i class="fas fa-ban"></i> Rejected</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                            <td style="white-space:nowrap;color:var(--muted);font-size:.8rem;">
                                <fmt:formatDate value="${issue.createdAt}" pattern="dd MMM yyyy" />
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/IssueServlet?action=adminDetail&id=${issue.issueId}"
                                   class="btn-view"><i class="fas fa-eye"></i> View</a>
                            </td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="empty-state">
                    <i class="fas fa-inbox"></i>
                    No issues found matching your filters.
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</div><%-- end admin-content --%>

</body>
</html>
