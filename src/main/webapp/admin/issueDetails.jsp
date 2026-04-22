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

</body>
</html>