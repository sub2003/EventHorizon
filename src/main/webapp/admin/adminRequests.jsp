<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.eventhorizon.service.UserService" %>
<%
    request.setAttribute("pageTitle", "Admin Requests");
%>
<%@ include file="layout.jsp" %>

<div class="panel">
    <div class="panel-header">
        <div>
            <h2>Pending Admin Requests</h2>
            <p>Review and approve or reject admin access requests.</p>
        </div>
    </div>

    <%
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");

        if ("approved".equals(msg)) {
    %>
        <div class="alert success">Admin request approved successfully.</div>
    <%
        } else if ("rejected".equals(msg)) {
    %>
        <div class="alert success">Admin request rejected successfully.</div>
    <%
        } else if ("requestSubmitted".equals(msg)) {
    %>
        <div class="alert success">New admin request submitted successfully.</div>
    <%
        }

        if ("approveFailed".equals(error)) {
    %>
        <div class="alert error">Failed to approve request.</div>
    <%
        } else if ("rejectFailed".equals(error)) {
    %>
        <div class="alert error">Failed to reject request.</div>
    <%
        }
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
            <%
                List<Map<String, String>> list =
                        (List<Map<String, String>>) request.getAttribute("adminRequests");

                if (list != null && !list.isEmpty()) {
                    for (Map<String, String> r : list) {
            %>
            <tr>
                <td><%= r.get("requestId") %></td>
                <td><%= r.get("requesterAdminId") %></td>
                <td><%= r.get("requestedName") %></td>
                <td><%= r.get("requestedEmail") %></td>
                <td><%= r.get("requestedPhone") %></td>
                <td>
                    <span class="permission-badge">
                        <%= UserService.permissionLabel(r.get("requestedPermission")) %>
                    </span>
                </td>
                <td><%= r.get("requestedAt") %></td>
                <td>
                    <div class="action-group">
                        <form action="<%= request.getContextPath() %>/user" method="post">
                            <input type="hidden" name="action" value="approveAdminRequest">
                            <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                            <button type="submit" class="btn primary"
                                    onclick="return confirm('Approve this admin request?');">
                                Approve
                            </button>
                        </form>

                        <form action="<%= request.getContextPath() %>/user" method="post">
                            <input type="hidden" name="action" value="rejectAdminRequest">
                            <input type="hidden" name="requestId" value="<%= r.get("requestId") %>">
                            <button type="submit" class="btn danger"
                                    onclick="return confirm('Reject this admin request?');">
                                Reject
                            </button>
                        </form>
                    </div>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="8" class="empty-cell">No pending admin requests.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<style>
    .panel {
        background: linear-gradient(135deg, rgba(13,18,40,0.96), rgba(10,27,63,0.96));
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 26px;
        padding: 26px;
        box-shadow: 0 18px 44px rgba(0,0,0,0.28);
    }

    .panel-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        gap: 16px;
        margin-bottom: 20px;
    }

    .panel-header h2 {
        margin: 0 0 8px 0;
        font-size: 2rem;
        font-weight: 800;
        color: #f8fafc;
    }

    .panel-header p {
        margin: 0;
        color: #94a3b8;
        font-size: 1rem;
    }

    .alert {
        border-radius: 16px;
        padding: 14px 16px;
        margin-bottom: 16px;
        font-weight: 600;
        border: 1px solid transparent;
    }

    .alert.success {
        background: rgba(16, 185, 129, 0.14);
        border-color: rgba(16, 185, 129, 0.3);
        color: #a7f3d0;
    }

    .alert.error {
        background: rgba(239, 68, 68, 0.14);
        border-color: rgba(239, 68, 68, 0.3);
        color: #fecaca;
    }

    .table-wrap {
        overflow-x: auto;
        border-radius: 18px;
        border: 1px solid rgba(255,255,255,0.08);
        background: rgba(8,12,28,0.45);
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        min-width: 1100px;
    }

    .data-table thead th {
        background: rgba(91, 33, 182, 0.22);
        color: #e2e8f0;
        text-align: left;
        padding: 16px 14px;
        font-size: 0.82rem;
        text-transform: uppercase;
        letter-spacing: 0.08em;
        border-bottom: 1px solid rgba(255,255,255,0.08);
    }

    .data-table tbody td {
        padding: 16px 14px;
        color: #e5e7eb;
        border-bottom: 1px solid rgba(255,255,255,0.06);
        vertical-align: middle;
    }

    .data-table tbody tr:hover {
        background: rgba(255,255,255,0.025);
    }

    .permission-badge {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: 8px 12px;
        border-radius: 999px;
        font-size: 0.82rem;
        font-weight: 700;
        color: #ddd6fe;
        background: rgba(91, 33, 182, 0.22);
        border: 1px solid rgba(167, 139, 250, 0.22);
        white-space: nowrap;
    }

    .action-group {
        display: flex;
        gap: 10px;
        flex-wrap: wrap;
    }

    .action-group form {
        margin: 0;
    }

    .btn {
        border: none;
        border-radius: 12px;
        padding: 10px 14px;
        font-weight: 700;
        cursor: pointer;
        transition: 0.2s ease;
        font-size: 0.92rem;
    }

    .btn.primary {
        color: #ffffff;
        background: linear-gradient(135deg, #2563eb, #1d4ed8);
        box-shadow: 0 10px 20px rgba(37, 99, 235, 0.22);
    }

    .btn.primary:hover {
        transform: translateY(-1px);
        opacity: 0.96;
    }

    .btn.danger {
        color: #ffffff;
        background: linear-gradient(135deg, #ef4444, #dc2626);
        box-shadow: 0 10px 20px rgba(239, 68, 68, 0.22);
    }

    .btn.danger:hover {
        transform: translateY(-1px);
        opacity: 0.96;
    }

    .empty-cell {
        text-align: center;
        color: #94a3b8;
        padding: 26px !important;
    }

    @media (max-width: 768px) {
        .panel {
            padding: 18px;
            border-radius: 20px;
        }

        .panel-header h2 {
            font-size: 1.5rem;
        }
    }
</style>

</main>
</div>
</body>
</html>