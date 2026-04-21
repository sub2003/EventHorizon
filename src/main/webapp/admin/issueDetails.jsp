<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Issue #${issue.issueId} — EventHorizon Admin</title>
    <link href="https://fonts.googleapis.com/css2?family=Sora:wght@300;400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <%-- Shared admin stylesheet --%>
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
            --radius:   14px;
        }

        .detail-wrap {
            display: grid; grid-template-columns: 1fr 320px; gap: 24px;
        }
        @media (max-width: 860px) { .detail-wrap { grid-template-columns: 1fr; } }

        /* ── card ─────────────────────────────────────────────── */
        .card {
            background: var(--card); border: 1px solid var(--border);
            border-radius: var(--radius); padding: 26px; margin-bottom: 20px;
        }
        .card h3 {
            font-size: 1rem; font-weight: 600; margin-bottom: 18px;
            display: flex; align-items: center; gap: 8px;
        }
        .card h3 i { color: var(--accent); font-size: .9rem; }

        /* back link */
        .back-link {
            display: inline-flex; align-items: center; gap: 7px;
            color: var(--muted); text-decoration: none; font-size: .84rem;
            margin-bottom: 20px; transition: color .2s;
        }
        .back-link:hover { color: var(--text); }

        /* ── issue meta ─────────────────────────────────────────── */
        .meta-grid {
            display: grid; grid-template-columns: 1fr 1fr; gap: 14px;
        }
        .meta-item small { display: block; font-size: .73rem; color: var(--muted); margin-bottom: 3px; }
        .meta-item span  { font-size: .88rem; font-weight: 500; }

        /* badges */
        .badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 4px 11px; border-radius: 100px; font-size: .74rem; font-weight: 600;
        }
        .badge-open     { background: rgba(225,112,85,.12); color: var(--danger);  border: 1px solid rgba(225,112,85,.3); }
        .badge-progress { background: rgba(253,203,110,.12); color: var(--warn);   border: 1px solid rgba(253,203,110,.3); }
        .badge-resolved { background: rgba(0,184,148,.12);  color: var(--success); border: 1px solid rgba(0,184,148,.3); }
        .badge-rejected { background: rgba(99,110,114,.12); color: #b2bec3;        border: 1px solid rgba(99,110,114,.3); }

        .priority-badge {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 3px 10px; border-radius: 100px; font-size: .73rem; font-weight: 600;
        }
        .priority-high   { background: rgba(225,112,85,.12); color: var(--danger); }
        .priority-medium { background: rgba(253,203,110,.12); color: var(--warn); }
        .priority-low    { background: rgba(0,184,148,.12);  color: var(--success); }

        .cat-chip {
            background: rgba(108,92,231,.1); color: #a29bfe;
            padding: 4px 12px; border-radius: 7px; font-size: .78rem;
        }

        /* description box */
        .desc-box {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; padding: 16px;
            font-size: .87rem; line-height: 1.75; white-space: pre-wrap; color: var(--text);
        }

        /* ── REPLY THREAD ───────────────────────────────────────── */
        .reply-thread { display: flex; flex-direction: column; gap: 14px; }

        .reply-bubble {
            border-radius: 12px; padding: 16px;
            position: relative;
        }
        .reply-bubble.admin-reply {
            background: rgba(108,92,231,.1); border: 1px solid rgba(108,92,231,.25);
            margin-left: 20px;
        }
        .reply-bubble .reply-header {
            display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;
        }
        .reply-bubble .reply-author {
            font-size: .8rem; font-weight: 600; color: #a29bfe;
            display: flex; align-items: center; gap: 6px;
        }
        .reply-bubble .reply-time { font-size: .73rem; color: var(--muted); }
        .reply-bubble .reply-text { font-size: .87rem; line-height: 1.65; }

        /* admin avatar dot */
        .author-dot {
            width: 24px; height: 24px; border-radius: 50%;
            background: var(--accent); display: flex; align-items: center; justify-content: center;
            font-size: .65rem; font-weight: 700; color: #fff;
        }

        .no-replies {
            text-align: center; padding: 32px; color: var(--muted); font-size: .85rem;
        }
        .no-replies i { display: block; font-size: 1.8rem; margin-bottom: 8px; opacity: .4; }

        /* ── REPLY FORM ─────────────────────────────────────────── */
        textarea {
            width: 100%; background: var(--surface); border: 1px solid var(--border);
            border-radius: 10px; color: var(--text); padding: 12px 14px;
            font-family: 'Sora', sans-serif; font-size: .88rem; resize: vertical; min-height: 100px;
            transition: border-color .2s;
        }
        textarea:focus { outline: none; border-color: var(--accent); box-shadow: 0 0 0 3px rgba(108,92,231,.12); }

        select {
            background: var(--surface); border: 1px solid var(--border);
            border-radius: 9px; color: var(--text); padding: 9px 12px;
            font-family: 'Sora', sans-serif; font-size: .85rem; width: 100%;
        }
        select:focus { outline: none; border-color: var(--accent); }

        .form-label { font-size: .78rem; color: var(--muted); display: block; margin-bottom: 7px; font-weight: 500; }

        .btn-send {
            width: 100%; padding: 12px; margin-top: 14px;
            background: linear-gradient(135deg, var(--accent), #8e7cf5);
            border: none; border-radius: 10px; color: #fff;
            font-family: 'Sora', sans-serif; font-size: .95rem; font-weight: 600; cursor: pointer;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            transition: opacity .2s;
        }
        .btn-send:hover { opacity: .88; }

        /* ── SIDEBAR ─────────────────────────────────────────────── */
        .info-row {
            display: flex; align-items: flex-start; gap: 10px;
            padding: 11px 0; border-bottom: 1px solid var(--border);
            font-size: .85rem;
        }
        .info-row:last-child { border-bottom: none; }
        .info-row i { color: var(--accent); width: 16px; margin-top: 2px; }
        .info-row div small { display: block; font-size: .72rem; color: var(--muted); margin-bottom: 2px; }

        /* quick status buttons */
        .quick-status { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-top: 14px; }
        .qs-btn {
            padding: 9px 8px; border-radius: 9px; border: 1.5px solid var(--border);
            background: transparent; color: var(--muted);
            font-family: 'Sora', sans-serif; font-size: .78rem; font-weight: 600; cursor: pointer;
            transition: all .2s;
        }
        .qs-btn:hover         { border-color: var(--accent); color: var(--text); }
        .qs-btn.qs-progress   { border-color: var(--warn);    color: var(--warn); }
        .qs-btn.qs-resolved   { border-color: var(--success); color: var(--success); }
        .qs-btn.qs-rejected   { border-color: var(--danger);  color: var(--danger); }
        .qs-btn.active        { opacity: .5; cursor: default; }

        /* page header */
        .page-header {
            display: flex; align-items: center; justify-content: space-between;
            margin-bottom: 20px; flex-wrap: wrap; gap: 10px;
        }
        .page-header h2 { font-size: 1.35rem; font-weight: 700; }

        .issue-id { font-family: 'JetBrains Mono', monospace; color: var(--muted); font-size: .9rem; }
    </style>
</head>
<body>

<%@ include file="layout.jsp" %>

<div class="admin-content">

    <a href="${pageContext.request.contextPath}/IssueServlet?action=adminList" class="back-link">
        <i class="fas fa-arrow-left"></i> Back to Issues
    </a>

    <div class="page-header">
        <div>
            <h2>Issue <span class="issue-id">#${issue.issueId}</span></h2>
            <div style="margin-top:5px; display:flex; gap:10px; align-items:center;">
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

        <!-- LEFT COLUMN -->
        <div>
            <!-- Issue Details -->
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
                        <span><fmt:formatDate value="${issue.updatedAt}" pattern="dd MMM yyyy, hh:mm a" /></span>
                    </div>
                </div>

                <small style="font-size:.75rem; color:var(--muted); display:block; margin-bottom:8px;">Description</small>
                <div class="desc-box">${issue.description}</div>
            </div>

            <!-- Reply History -->
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

            <!-- Reply Form -->
            <c:if test="${issue.status != 'RESOLVED' && issue.status != 'REJECTED'}">
            <div class="card">
                <h3><i class="fas fa-reply"></i> Send Reply to Customer</h3>
                <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                    <input type="hidden" name="action"   value="reply" />
                    <input type="hidden" name="issueId"  value="${issue.issueId}" />

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

        <!-- RIGHT COLUMN (SIDEBAR) -->
        <div>
            <!-- Customer Info -->
            <div class="card">
                <h3><i class="fas fa-user"></i> Customer</h3>
                <div class="info-row">
                    <i class="fas fa-user-circle"></i>
                    <div><small>Name</small>${issue.userName}</div>
                </div>
                <div class="info-row">
                    <i class="fas fa-envelope"></i>
                    <div><small>Email</small><a href="mailto:${issue.customerEmail}" style="color:var(--accent2);text-decoration:none;">${issue.customerEmail}</a></div>
                </div>
                <c:if test="${not empty issue.customerPhone}">
                <div class="info-row">
                    <i class="fas fa-phone"></i>
                    <div><small>Phone</small><a href="tel:${issue.customerPhone}" style="color:var(--accent2);text-decoration:none;">${issue.customerPhone}</a></div>
                </div>
                </c:if>
            </div>

            <!-- Quick Status Update -->
            <div class="card">
                <h3><i class="fas fa-toggle-on"></i> Quick Status Update</h3>
                <p style="font-size:.8rem; color:var(--muted); margin-bottom:12px;">Change status without sending a reply message.</p>
                <div class="quick-status">
                    <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                        <input type="hidden" name="action"  value="updateStatus" />
                        <input type="hidden" name="issueId" value="${issue.issueId}" />
                        <input type="hidden" name="status"  value="IN_PROGRESS" />
                        <button type="submit" class="qs-btn qs-progress ${issue.status == 'IN_PROGRESS' ? 'active' : ''}">
                            <i class="fas fa-spinner"></i> In Progress
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                        <input type="hidden" name="action"  value="updateStatus" />
                        <input type="hidden" name="issueId" value="${issue.issueId}" />
                        <input type="hidden" name="status"  value="RESOLVED" />
                        <button type="submit" class="qs-btn qs-resolved ${issue.status == 'RESOLVED' ? 'active' : ''}">
                            <i class="fas fa-check"></i> Resolved
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                        <input type="hidden" name="action"  value="updateStatus" />
                        <input type="hidden" name="issueId" value="${issue.issueId}" />
                        <input type="hidden" name="status"  value="OPEN" />
                        <button type="submit" class="qs-btn ${issue.status == 'OPEN' ? 'active' : ''}">
                            <i class="fas fa-circle-dot"></i> Reopen
                        </button>
                    </form>
                    <form action="${pageContext.request.contextPath}/IssueServlet" method="post">
                        <input type="hidden" name="action"  value="updateStatus" />
                        <input type="hidden" name="issueId" value="${issue.issueId}" />
                        <input type="hidden" name="status"  value="REJECTED" />
                        <button type="submit" class="qs-btn qs-rejected ${issue.status == 'REJECTED' ? 'active' : ''}">
                            <i class="fas fa-ban"></i> Reject
                        </button>
                    </form>
                </div>
            </div>

            <!-- Issue Meta -->
            <div class="card">
                <h3><i class="fas fa-tag"></i> Issue Info</h3>
                <div class="info-row">
                    <i class="fas fa-layer-group"></i>
                    <div><small>Category</small>${issue.category}</div>
                </div>
                <div class="info-row">
                    <i class="fas fa-shield-alt"></i>
                    <div><small>Assigned Team</small>${issue.assignedAdminType.replace('_',' ')}</div>
                </div>
                <div class="info-row">
                    <i class="fas fa-exclamation"></i>
                    <div><small>Priority</small>
                        <span class="priority-badge priority-${issue.priority.toLowerCase()}">${issue.priority}</span>
                    </div>
                </div>
                <c:if test="${issue.bookingId != null}">
                <div class="info-row">
                    <i class="fas fa-ticket-alt"></i>
                    <div><small>Booking ID</small>#${issue.bookingId}</div>
                </div>
                </c:if>
                <c:if test="${issue.ticketId != null}">
                <div class="info-row">
                    <i class="fas fa-qrcode"></i>
                    <div><small>Ticket ID</small>#${issue.ticketId}</div>
                </div>
                </c:if>
                <div class="info-row">
                    <i class="fas fa-calendar"></i>
                    <div><small>Submitted</small><fmt:formatDate value="${issue.createdAt}" pattern="dd MMM yyyy" /></div>
                </div>
                <div class="info-row">
                    <i class="fas fa-comments"></i>
                    <div><small>Replies</small>${not empty issue.replies ? issue.replies.size() : 0}</div>
                </div>
            </div>
        </div>

    </div>
</div><%-- end admin-content --%>

</body>
</html>
