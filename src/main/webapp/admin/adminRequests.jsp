<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    request.setAttribute("pageTitle", "Admin Requests");
%>
<%@ include file="layout.jsp" %>

<div class="panel">
    <div class="panel-header">
        <h2>Pending Admin Requests</h2>
        <p>Review and approve or reject admin access requests.</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
    %>

    <% if ("approved".equals(msg)) { %>
        <div class="alert success">Admin request approved successfully.</div>
    <% } else if ("rejected".equals(msg)) { %>
        <div class="alert success">Admin request rejected successfully.</div>
    <% } %>

    <% if ("approveFailed".equals(error)) { %>
        <div class="alert error">Failed to approve request. You may be approving your own request or the email already exists.</div>
    <% } else if ("rejectFailed".equals(error)) { %>
        <div class="alert error">Failed to reject request. You may be rejecting your own request.</div>
    <% } %>

    <%
        String currentAdminId = (String) session.getAttribute("userId");
        List<Map<String, String>> list = (List<Map<String, String>>) request.getAttribute("adminRequests");
    %>

    <div class="table-wrap">
        <table class="data-table">
            <thead>
            <tr>
                <th>Request ID</th>
                <th>Requested By</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Permission</th>
                <th>Requested At</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <% if (list != null && !list.isEmpty()) { %>
                <% for (Map<String, String> r : list) { %>
                    <%
                        boolean ownRequest = currentAdminId != null &&
                                currentAdminId.equals(r.get("requesterAdminId"));
                    %>
                    <tr>
                        <td><%= r.get("requestId") %></td>
                        <td><%= r.get("requesterAdminId") %></td>
                        <td><%= r.get("requestedName") %></td>
                        <td><%= r.get("requestedEmail") %></td>
                        <td><%= r.get("requestedPhone") %></td>
                        <td>
                            <span class="permission-pill">
                                <%= UserService.permissionLabel(r.get("requestedPermission")) %>
                            </span>
                        </td>
                        <td><%= r.get("requestedAt") %></td>
                        <td>
                            <div class="action-group">
                                <% if (ownRequest) { %>
                                    <button class="btn disabled" disabled>Approve</button>
                                    <button class="btn disabled" disabled>Reject</button>
                                <% } else { %>
                                    <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="approveAdminRequest">
                                        <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                        <button type="submit" class="btn primary">Approve</button>
                                    </form>

                                    <form action="<%= request.getContextPath() %>/user" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="rejectAdminRequest">
                                        <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                                        <button type="submit" class="btn danger">Reject</button>
                                    </form>
                                <% } %>
                            </div>
                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr>
                    <td colspan="8" class="empty-cell">No pending admin requests.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>

<style>
    .panel {
        background: rgba(15, 23, 42, 0.88);
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 24px;
        padding: 28px;
        box-shadow: 0 18px 40px rgba(0,0,0,0.28);
    }

    .panel-header {
        margin-bottom: 22px;
    }

    .panel-header h2 {
        margin: 0 0 8px;
        font-size: 34px;
        color: #ffffff;
        font-weight: 800;
    }

    .panel-header p {
        margin: 0;
        color: #cbd5e1;
        font-size: 17px;
    }

    .alert {
        border-radius: 14px;
        padding: 14px 16px;
        margin-bottom: 18px;
        font-weight: 700;
    }

    .alert.success {
        background: rgba(16, 185, 129, 0.15);
        color: #a7f3d0;
        border: 1px solid rgba(16, 185, 129, 0.35);
    }

    .alert.error {
        background: rgba(239, 68, 68, 0.14);
        color: #fecaca;
        border: 1px solid rgba(239, 68, 68, 0.35);
    }

    .table-wrap {
        overflow-x: auto;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 1100px;
    }

    .data-table thead th {
        text-align: left;
        padding: 16px 14px;
        color: #cbd5e1;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        border-bottom: 1px solid rgba(255,255,255,0.1);
        background: rgba(255,255,255,0.03);
    }

    .data-table tbody td {
        padding: 16px 14px;
        color: #f8fafc;
        border-bottom: 1px solid rgba(255,255,255,0.06);
        vertical-align: middle;
    }

    .data-table tbody tr:hover {
        background: rgba(255,255,255,0.03);
    }

    .permission-pill {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 7px 12px;
        border-radius: 999px;
        font-size: 12px;
        font-weight: 800;
        color: #fde68a;
        background: rgba(245, 158, 11, 0.16);
        border: 1px solid rgba(245, 158, 11, 0.28);
    }

    .action-group {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }

    .btn {
        border: none;
        border-radius: 12px;
        padding: 10px 16px;
        font-size: 14px;
        font-weight: 800;
        cursor: pointer;
    }

    .btn.primary {
        color: white;
        background: linear-gradient(135deg, #4f46e5, #6366f1);
    }

    .btn.danger {
        color: #fff1f2;
        background: linear-gradient(135deg, #b91c1c, #ef4444);
    }

    .btn.disabled {
        background: rgba(255,255,255,0.06);
        color: #94a3b8;
        cursor: not-allowed;
    }

    .empty-cell {
        text-align: center;
        color: #94a3b8 !important;
        padding: 26px !important;
        font-weight: 600;
    }
</style>

</main>
</div>
</body>
</html>