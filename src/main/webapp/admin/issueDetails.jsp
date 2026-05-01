<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%
    request.setAttribute("pageTitle", "Issue Requests");
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
        --radius: 20px;
        --shadow: 0 18px 45px rgba(24, 37, 31, 0.09);
    }

    .admin-content { width: 100%; }

    .detail-wrap {
        display: grid;
        grid-template-columns: minmax(0, 1fr) 340px;
        gap: 24px;
        align-items: start;
    }

    @media (max-width: 980px) {
        .detail-wrap { grid-template-columns: 1fr; }
    }

    .card {
        background: #ffffff;
        border: 1px solid var(--border);
        border-radius: var(--radius);
        padding: 26px;
        margin-bottom: 20px;
        box-shadow: var(--shadow);
        color: var(--text);
    }

    .card h3 {
        font-size: 1rem;
        font-weight: 900;
        margin-bottom: 20px;
        display: flex;
        align-items: center;
        gap: 10px;
        color: #123528;
        text-transform: uppercase;
        letter-spacing: 0.4px;
    }

    .card h3 i { color: var(--accent); font-size: .96rem; }

    .back-link {
        display: inline-flex;
        align-items: center;
        gap: 8px;
        color: #123528;
        background: #ffffff;
        border: 1px solid var(--border-strong);
        text-decoration: none;
        font-size: .86rem;
        margin-bottom: 20px;
        transition: 0.22s ease;
        padding: 10px 14px;
        border-radius: 12px;
        font-weight: 900;
        box-shadow: 0 10px 24px rgba(24, 37, 31, 0.06);
    }

    .back-link:hover { background: var(--soft); transform: translateY(-1px); }

    .meta-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 14px;
    }

    .meta-item {
        background: #FAF8F4;
        border: 1px solid rgba(30, 74, 58, 0.12);
        border-radius: 14px;
        padding: 14px;
    }

    .meta-item small,
    .info-row small,
    .form-label {
        display: block;
        font-size: .74rem;
        color: var(--muted);
        margin-bottom: 5px;
        font-weight: 900;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    .meta-item span,
    .info-row div div,
    .issue-subject-text {
        font-size: .92rem;
        font-weight: 900;
        color: var(--text);
        overflow-wrap: anywhere;
    }

    .badge,
    .priority-badge,
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

    .priority-high { background: #FFF0EC; color: var(--danger); border-color: rgba(162, 58, 39, 0.24); }
    .priority-medium { background: #FFF7E3; color: var(--warn); border-color: rgba(138, 90, 0, 0.24); }
    .priority-low { background: #E8F6EE; color: var(--success); border-color: rgba(23, 107, 59, 0.24); }

    .desc-box,
    .reply-bubble,
    .no-replies {
        background: #FAF8F4;
        border: 1px solid rgba(30, 74, 58, 0.14);
        border-radius: 14px;
        color: var(--text);
    }

    .desc-box {
        padding: 18px;
        line-height: 1.75;
        font-size: .92rem;
        white-space: pre-wrap;
        font-weight: 650;
    }

    .reply-thread {
        display: flex;
        flex-direction: column;
        gap: 14px;
    }

    .reply-bubble { padding: 16px; }

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
        font-weight: 900;
        font-size: .9rem;
        color: #123528;
    }

    .author-dot {
        width: 34px;
        height: 34px;
        border-radius: 50%;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        background: linear-gradient(135deg, var(--accent), #123528);
        color: white;
        font-weight: 900;
        font-size: .82rem;
        box-shadow: 0 8px 18px rgba(30, 74, 58, 0.18);
    }

    .reply-time { font-size: .78rem; color: var(--muted); font-weight: 750; }
    .reply-text { line-height: 1.75; color: var(--text); font-weight: 650; white-space: pre-wrap; }

    .no-replies {
        text-align: center;
        padding: 30px 20px;
        color: var(--muted);
        border-style: dashed;
        font-weight: 700;
    }

    .no-replies i {
        display: block;
        font-size: 1.55rem;
        margin-bottom: 10px;
        color: var(--accent);
    }

    textarea,
    select {
        width: 100%;
        background: #ffffff;
        border: 1px solid var(--border-strong);
        border-radius: 13px;
        color: var(--text);
        padding: 13px 14px;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
        font-size: .92rem;
        font-weight: 700;
        outline: none;
    }

    textarea { min-height: 150px; resize: vertical; }

    textarea:focus,
    select:focus {
        border-color: rgba(30, 74, 58, 0.52);
        box-shadow: 0 0 0 4px rgba(30, 74, 58, 0.10);
    }

    .btn-send,
    .qs-btn {
        border-radius: 13px;
        font-size: .9rem;
        font-weight: 900;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        gap: 8px;
        transition: 0.22s ease;
        font-family: 'Inter', 'Segoe UI', Arial, sans-serif;
    }

    .btn-send {
        margin-top: 16px;
        border: none;
        background: linear-gradient(135deg, #1E4A3A, #123528);
        color: white;
        padding: 13px 18px;
        box-shadow: 0 14px 30px rgba(30, 74, 58, 0.24);
    }

    .btn-send:hover { transform: translateY(-1px); }

    .info-row {
        display: flex;
        gap: 12px;
        align-items: flex-start;
        padding: 14px 0;
        border-bottom: 1px solid rgba(30, 74, 58, 0.12);
    }

    .info-row:last-child { border-bottom: none; padding-bottom: 0; }
    .info-row i { color: var(--accent); width: 18px; margin-top: 3px; }

    .quick-status { display: grid; gap: 10px; }

    .quick-status form { width: 100%; }

    .qs-btn {
        width: 100%;
        background: #ffffff;
        border: 1px solid var(--border-strong);
        color: #123528;
        padding: 12px 14px;
    }

    .qs-btn:hover { background: var(--soft); transform: translateY(-1px); }
    .qs-btn.qs-progress { border-color: rgba(138, 90, 0, 0.28); color: var(--warn); background: #FFF7E3; }
    .qs-btn.qs-resolved { border-color: rgba(23, 107, 59, 0.28); color: var(--success); background: #E8F6EE; }
    .qs-btn.qs-rejected { border-color: rgba(162, 58, 39, 0.28); color: var(--danger); background: #FFF0EC; }
    .qs-btn.active { opacity: .55; cursor: default; }

    .issue-detail-header {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 20px;
        flex-wrap: wrap;
        gap: 12px;
    }

    .issue-detail-header h2 {
        font-size: clamp(1.55rem, 3vw, 2rem);
        font-weight: 900;
        color: #123528;
        letter-spacing: -0.04em;
    }

    .issue-id {
        color: var(--muted);
        font-size: .95rem;
        font-weight: 900;
    }

    @media (max-width: 720px) {
        .meta-grid { grid-template-columns: 1fr; }
        .card { padding: 22px; }
    }
</style>

<div class="admin-content">

    <a href="${pageContext.request.contextPath}/IssueServlet?action=adminList" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Issues
    </a>

    <div class="issue-detail-header">
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
                    <span class="issue-subject-text">${issue.subject}</span>
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
                                            <span class="cat-chip" style="font-size:.68rem;padding:3px 8px;">Admin</span>
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

</body>
</html>