<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%
    request.setAttribute("pageTitle", "Issue Requests");
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
        --radius:   14px;
    }

    .admin-content {
        width: 100%;
    }

    .detail-wrap {
        display: grid;
        grid-template-columns: 1fr 320px;
        gap: 24px;
    }

    @media (max-width: 860px) {
        .detail-wrap {
            grid-template-columns: 1fr;
        }
    }

    .card {
        background: var(--card);
        border: 1px solid var(--border);
        border-radius: var(--radius);
        padding: 26px;
        margin-bottom: 20px;
    }

    .card h3 {
        font-size: 1rem;
        font-weight: 600;
        margin-bottom: 18px;
        display: flex;
        align-items: center;
        gap: 8px;
    }

    .card h3 i {
        color: var(--accent);
        font-size: .9rem;
    }

    .back-link {
        display: inline-flex;
        align-items: center;
        gap: 7px;
        color: var(--muted);
        text-decoration: none;
        font-size: .84rem;
        margin-bottom: 20px;
        transition: color .2s;
    }

    .back-link:hover {
        color: var(--text);
    }

    .meta-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 14px;
    }

    .meta-item small {
        display: block;
        font-size: .73rem;
        color: var(--muted);
        margin-bottom: 3px;
    }

    .meta-item span {
        font-size: .88rem;
        font-weight: 500;
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

    .priority-badge {
        display: inline-flex;
        align-items: center;
        gap: 5px;
        padding: 3px 10px;
        border-radius: 100px;
        font-size: .73rem;
        font-weight: 600;
    }

    .priority-high {
        background: rgba(225,112,85,.12);
        color: var(--danger);
    }

    .priority-medium {
        background: rgba(253,203,110,.12);
        color: var(--warn);
    }

    .priority-low {
        background: rgba(0,184,148,.12);
        color: var(--success);
    }

    .cat-chip {
        background: rgba(108,92,231,.1);
        color: #a29bfe;
        padding: 4px 12px;
        border-radius: 7px;
        font-size: .78rem;
    }

    .desc-box {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 12px;
        padding: 16px;
        line-height: 1.7;
        font-size: .88rem;
        white-space: pre-wrap;
    }

    .reply-thread {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }

    .reply-bubble {
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 14px;
        padding: 16px;
    }

    .reply-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        gap: 12px;
        margin-bottom: 10px;
        flex-wrap: wrap;
    }

    .reply-author {
        display: flex;
        align-items: center;
        gap: 10px;
        font-weight: 600;
        font-size: .86rem;
    }

    .author-dot {
        width: 32px;
        height: 32px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        color: white;
        font-weight: 700;
        font-size: .82rem;
    }

    .reply-time {
        font-size: .75rem;
        color: var(--muted);
    }

    .reply-text {
        font-size: .88rem;
        line-height: 1.7;
        white-space: pre-wrap;
    }

    .no-replies {
        text-align: center;
        padding: 28px 20px;
        color: var(--muted);
        border: 1px dashed var(--border);
        border-radius: 12px;
    }

    .no-replies i {
        display: block;
        font-size: 1.5rem;
        margin-bottom: 10px;
        color: var(--accent2);
    }

    .form-label {
        display: block;
        font-size: .8rem;
        color: var(--muted);
        margin-bottom: 8px;
        font-weight: 500;
    }

    textarea,
    select {
        width: 100%;
        background: var(--surface);
        border: 1px solid var(--border);
        border-radius: 10px;
        color: var(--text);
        padding: 12px 14px;
        font-family: inherit;
        font-size: .88rem;
    }

    textarea {
        min-height: 140px;
        resize: vertical;
    }

    textarea:focus,
    select:focus {
        outline: none;
        border-color: var(--accent);
    }

    .btn-send {
        margin-top: 16px;
        border: none;
        background: linear-gradient(135deg, var(--accent), var(--accent2));
        color: white;
        padding: 12px 18px;
        border-radius: 10px;
        font-size: .88rem;
        font-weight: 600;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .btn-send:hover {
        opacity: .92;
    }

    .info-row {
        display: flex;
        gap: 12px;
        align-items: flex-start;
        padding: 12px 0;
        border-bottom: 1px solid rgba(255,255,255,0.04);
    }

    .info-row:last-child {
        border-bottom: none;
        padding-bottom: 0;
    }

    .info-row i {
        color: var(--accent2);
        width: 18px;
        margin-top: 3px;
    }

    .info-row small {
        display: block;
        color: var(--muted);
        font-size: .72rem;
        margin-bottom: 3px;
    }

    .quick-status {
        display: grid;
        gap: 10px;
    }

    .qs-btn {
        width: 100%;
        background: transparent;
        border: 1px solid var(--border);
        border-radius: 10px;
        color: var(--muted);
        padding: 11px 14px;
        font-size: .84rem;
        font-weight: 600;
        cursor: pointer;
        display: flex;
        align-items: center;
        gap: 8px;
        justify-content: center;
    }

    .qs-btn:hover {
        border-color: var(--accent);
        color: var(--text);
    }

    .qs-btn.qs-progress {
        border-color: var(--warn);
        color: var(--warn);
    }

    .qs-btn.qs-resolved {
        border-color: var(--success);
        color: var(--success);
    }

    .qs-btn.qs-rejected {
        border-color: var(--danger);
        color: var(--danger);
    }

    .qs-btn.active {
        opacity: .5;
        cursor: default;
    }

    .page-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 10px;
    }

    .page-header h2 {
        font-size: 1.35rem;
        font-weight: 700;
    }

    .issue-id {
        font-family: 'JetBrains Mono', monospace;
        color: var(--muted);
        font-size: .9rem;
    }
</style>

<div class="admin-content">

    <a href="${pageContext.request.contextPath}/IssueServlet?action=adminList" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Issues
    </a>

    <div class="page-header">
        <div>
            <h2>Issue <span class="issue-id">#${issue.issueId}</span></h2>
            <div style="margin-top:5px; display:flex; gap:10px; align-items:center; flex-wrap:wrap;">
                <span class="cat-chip">${issue.category}</span>
                <span class="badge badge-${issue.status == 'IN_PROGRESS' ? 'progress' : issue.status.toLowerCase()}">
                    <c:choose>
                        <c:when test="${issue.status == 'OPEN'}"><i class="fas fa-circle-dot"></i> Open</c:when>
                        <c:when test="${issue.status == 'IN_PROGRESS'}"><i class="fas fa-spinner"></i> In Progress</c:when>
                        <c:when test="${issue.status == 'RESOLVED'}"><i class="fas fa-check-circle"></i> Resolved</c:when>
                        <c:otherwise><i class="fas fa-ban"></i> Rejected</c:otherwise>
                    </c:choose>
                </span>
                <span class="priority-badge priority-${issue.priority.toLowerCase()}">${issue.priority}</span>
            </div>
        </div>
    </div>

    <div class="detail-wrap">

        <div>
            <div class="card">
                <h3><i class="fas fa-info-circle"></i> Issue Details</h3>

                <div style="margin-bottom:18px;">
                    <span style="font-size:1.05rem; font-weight:600;">${issue.subject}</span>
                </div>

                <div class="meta-grid" style="margin-bottom:18px;">
                    <div class="meta-item">
                        <small>Submitted By</small>
                        <span>${issue.userName}</span>
                    </div>
                    <div class="meta-item">
                        <small>Email</small>
                        <span>${issue.customerEmail}</span>
                    </div>

                    <c:if test="${not empty issue.customerPhone}">
                        <div class="meta-item">
                            <small>Phone</small>
                            <span>${issue.customerPhone}</span>
                        </div>
                    </c:if>

                    <div class="meta-item">
                        <small>Submitted On</small>
                        <span><fmt:formatDate value="${issue.createdAt}" pattern="dd MMM yyyy, hh:mm a" /></span>
                    </div>

                    <c:if test="${issue.bookingId != null}">
                        <div class="meta-item">
                            <small>Booking ID</small>
                            <span>#${issue.bookingId}</span>
                        </div>
                    </c:if>

                    <c:if test="${issue.ticketId != null}">
                        <div class="meta-item">
                            <small>Ticket ID</small>
                            <span>#${issue.ticketId}</span>
                        </div>
                    </c:if>

                    <div class="meta-item">
                        <small>Assigned To</small>
                        <span>${issue.assignedAdminType.replace('_', ' ')}</span>
                    </div>

                    <div class="meta-item">
                        <small>Last Updated</small>
                        <span>
                            <c:choose>
                                <c:when test="${not empty issue.updatedAt}">
                                    <fmt:formatDate value="${issue.updatedAt}" pattern="dd MMM yyyy, hh:mm a" />
                                </c:when>
                                <c:otherwise>
                                    -
                                </c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>

                <small style="font-size:.75rem; color:var(--muted); display:block; margin-bottom:8px;">Description</small>
                <div class="desc-box">${issue.description}</div>
            </div>

            <div class="card">
                <h3><i class="fas fa-comments"></i> Reply History</h3>
                <c:choose>
                    <c:when test="${not empty issue.replies}">
                        <div class="reply-thread">
                            <c:forEach var="reply" items="${issue.replies}">
                                <div class="reply-bubble admin-reply">
                                    <div class="reply-header">
                                        <div class="reply-author">
                                            <div class="author-dot">${reply.adminName.substring(0,1).toUpperCase()}</div>
                                            ${reply.adminName}
                                            <span style="background:rgba(108,92,231,.15);color:#a29bfe;padding:2px 8px;border-radius:100px;font-size:.68rem;">Admin</span>
                                        </div>
                                        <span class="reply-time">
                                            <fmt:formatDate value="${reply.repliedAt}" pattern="dd MMM yyyy, hh:mm a" />
                                        </span>
                                    </div>
                                    <div class="reply-text">${reply.replyMessage}</div>
                                </div>
                            </c:forEach>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="no-replies">
                            <i class="fas fa-comment-slash"></i>
                            No replies yet. Use the form on the right to respond.
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>

            <c:if test="${issue.status != 'RESOLVED' && issue.status != 'REJECTED'}">
                <div class="card">
                    <h3><i class="fas fa-reply"></i> Send Reply to Customer</h3>

                    <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                        <input type="hidden" name="action" value="reply" />
                        <input type="hidden" name="issueId" value="${issue.issueId}" />

                        <div style="margin-bottom:14px;">
                            <label class="form-label">Reply Message <span style="color:var(--danger);">*</span></label>
                            <textarea name="replyMessage" placeholder="Type your reply to the customer here…" required></textarea>
                        </div>

                        <div>
                            <label class="form-label">Update Status (optional)</label>
                            <select name="newStatus">
                                <option value="">Keep current status</option>
                                <option value="IN_PROGRESS">In Progress</option>
                                <option value="RESOLVED">Resolved</option>
                                <option value="REJECTED">Rejected</option>
                            </select>
                        </div>

                        <button type="submit" class="btn-send">
                            <i class="fas fa-paper-plane"></i> Send Reply
                        </button>
                    </form>
                </div>
            </c:if>
        </div>

        <div>
            <div class="card">
                <h3><i class="fas fa-user-circle"></i> Customer Contact</h3>

                <div class="info-row">
                    <i class="fas fa-envelope"></i>
                    <div>
                        <small>Email</small>
                        <div>${issue.customerEmail}</div>
                    </div>
                </div>

                <c:if test="${not empty issue.customerPhone}">
                    <div class="info-row">
                        <i class="fas fa-phone"></i>
                        <div>
                            <small>Phone</small>
                            <div>${issue.customerPhone}</div>
                        </div>
                    </div>
                </c:if>

                <div class="info-row">
                    <i class="fas fa-layer-group"></i>
                    <div>
                        <small>Category</small>
                        <div>${issue.category}</div>
                    </div>
                </div>

                <div class="info-row">
                    <i class="fas fa-shield-halved"></i>
                    <div>
                        <small>Assigned Admin Type</small>
                        <div>${issue.assignedAdminType.replace('_', ' ')}</div>
                    </div>
                </div>
            </div>

            <c:if test="${issue.status != 'RESOLVED' && issue.status != 'REJECTED'}">
                <div class="card">
                    <h3><i class="fas fa-bolt"></i> Quick Status</h3>

                    <div class="quick-status">
                        <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                            <input type="hidden" name="action" value="updateStatus" />
                            <input type="hidden" name="issueId" value="${issue.issueId}" />
                            <input type="hidden" name="status" value="IN_PROGRESS" />
                            <button type="submit" class="qs-btn qs-progress ${issue.status == 'IN_PROGRESS' ? 'active' : ''}">
                                <i class="fas fa-spinner"></i> Mark In Progress
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                            <input type="hidden" name="action" value="updateStatus" />
                            <input type="hidden" name="issueId" value="${issue.issueId}" />
                            <input type="hidden" name="status" value="RESOLVED" />
                            <button type="submit" class="qs-btn qs-resolved ${issue.status == 'RESOLVED' ? 'active' : ''}">
                                <i class="fas fa-check-circle"></i> Mark Resolved
                            </button>
                        </form>

                        <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                            <input type="hidden" name="action" value="updateStatus" />
                            <input type="hidden" name="issueId" value="${issue.issueId}" />
                            <input type="hidden" name="status" value="REJECTED" />
                            <button type="submit" class="qs-btn qs-rejected ${issue.status == 'REJECTED' ? 'active' : ''}">
                                <i class="fas fa-ban"></i> Reject Issue
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>
        </div>

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

<!-- FINAL LOGO MATCH FIX: same green leaf mark used on customer pages/profile.jsp -->
<style>
    .brand-icon,
    .eh-brand-mark,
    .auth-brand-mark,
    .eh-footer-brand-mark,
    .navbar-brand::before {
        width: 42px !important;
        height: 42px !important;
        min-width: 42px !important;
        min-height: 42px !important;
        border-radius: 14px !important;
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        background: linear-gradient(135deg, #1E4A3A, #123528) !important;
        color: #ffffff !important;
        border: none !important;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24) !important;
        flex-shrink: 0 !important;
        font-size: 0 !important;
        line-height: 1 !important;
        overflow: hidden !important;
    }

    /* Prevent double icons. The actual visible icon should be the real <i class="fa-solid fa-leaf"></i>. */
    .brand-icon::before,
    .eh-brand-mark::before,
    .auth-brand-mark::before,
    .eh-footer-brand-mark::before {
        content: none !important;
        display: none !important;
    }

    .brand-icon i,
    .eh-brand-mark i,
    .auth-brand-mark i,
    .eh-footer-brand-mark i {
        display: inline-flex !important;
        align-items: center !important;
        justify-content: center !important;
        color: #ffffff !important;
        font-size: 1.05rem !important;
        line-height: 1 !important;
        width: auto !important;
        height: auto !important;
        margin: 0 !important;
        opacity: 1 !important;
        transform: none !important;
    }

    .brand-icon i::before,
    .eh-brand-mark i::before,
    .auth-brand-mark i::before,
    .eh-footer-brand-mark i::before {
        color: #ffffff !important;
        font-size: 1.05rem !important;
    }

    .brand,
    .eh-brand,
    .navbar-brand {
        display: inline-flex !important;
        align-items: center !important;
        gap: 12px !important;
        color: #123528 !important;
        font-weight: 900 !important;
        letter-spacing: 1.8px !important;
        text-transform: uppercase !important;
    }

    .brand h2,
    .brand-text h2,
    .eh-brand-text,
    .navbar-brand span {
        color: #123528 !important;
        font-weight: 900 !important;
        letter-spacing: 1.8px !important;
        text-transform: uppercase !important;
    }

    /* For pages that use .navbar-brand without a separate .brand-icon. */
    .navbar-brand::before {
        content: "\f06c" !important;
        font-family: "Font Awesome 6 Free" !important;
        font-weight: 900 !important;
        font-size: 1.05rem !important;
        color: #ffffff !important;
        letter-spacing: 0 !important;
    }
</style>
