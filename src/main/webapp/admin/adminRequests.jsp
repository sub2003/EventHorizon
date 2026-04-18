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
            <p class="section-tag">Administration</p>
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
        <div class="alert error">Failed to approve request. The email may already exist or the request is no longer pending.</div>
    <%
        } else if ("rejectFailed".equals(error)) {
    %>
        <div class="alert error">Failed to reject request. The request is no longer pending.</div>
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
    .section-tag{
        margin:0 0 8px 0;
        color:#38bdf8;
        font-size:0.78rem;
        font-weight:800;
        text-transform:uppercase;
        letter-spacing:0.14em;
    }

    .panel{
        background:linear-gradient(135deg, rgba(17,24,39,0.94), rgba(12,30,66,0.95));
        border:1px solid rgba(255,255,255,0.08);
        border-radius:28px;
        padding:28px;
        box-shadow:0 18px 40px rgba(0,0,0,0.28);
    }

    .panel-header{
        display:flex;
        justify-content:space-between;
        align-items:flex-start;
        gap:18px;
        margin-bottom:22px;
    }

    .panel-header h2{
        margin:0 0 8px 0;
        font-size:2rem;
        line-height:1.15;
        font-weight:800;
        color:#f8fafc;
    }

    .panel-header p{
        margin:0;
        color:#a5b4fc;
        font-size:1rem;
    }

    .alert{
        border-radius:16px;
        padding:14px 16px;
        margin-bottom:18px;
        font-weight:700;
        border:1px solid transparent;
    }

    .alert.success{
        background:rgba(16,185,129,0.14);
        border-color:rgba(16,185,129,0.28);
        color:#a7f3d0;
    }

    .alert.error{
        background:rgba(239,68,68,0.14);
        border-color:rgba(239,68,68,0.28);
        color:#fecaca;
    }

    .table-wrap{
        overflow-x:auto;
        border-radius:20px;
        border:1px solid rgba(255,255,255,0.08);
        background:rgba(2,6,23,0.32);
    }

    .data-table{
        width:100%;
        border-collapse:collapse;
        min-width:1150px;
    }

    .data-table thead th{
        padding:17px 16px;
        text-align:left;
        background:rgba(91,33,182,0.22);
        color:#e2e8f0;
        font-size:0.8rem;
        font-weight:800;
        text-transform:uppercase;
        letter-spacing:0.08em;
        border-bottom:1px solid rgba(255,255,255,0.08);
    }

    .data-table tbody td{
        padding:18px 16px;
        color:#e5e7eb;
        border-bottom:1px solid rgba(255,255,255,0.06);
        vertical-align:middle;
    }

    .data-table tbody tr:hover{
        background:rgba(255,255,255,0.025);
    }

    .permission-badge{
        display:inline-flex;
        align-items:center;
        justify-content:center;
        padding:8px 12px;
        border-radius:999px;
        font-size:0.82rem;
        font-weight:700;
        color:#ddd6fe;
        background:rgba(91,33,182,0.22);
        border:1px solid rgba(167,139,250,0.22);
        white-space:nowrap;
    }

    .action-group{
        display:flex;
        gap:10px;
        flex-wrap:wrap;
    }

    .action-group form{
        margin:0;
    }

    .btn{
        border:none;
        border-radius:12px;
        padding:10px 14px;
        font-weight:700;
        cursor:pointer;
        transition:all 0.2s ease;
        font-size:0.92rem;
    }

    .btn.primary{
        color:#fff;
        background:linear-gradient(135deg, #2563eb, #1d4ed8);
        box-shadow:0 10px 20px rgba(37,99,235,0.22);
    }

    .btn.primary:hover{
        transform:translateY(-1px);
        opacity:0.96;
    }

    .btn.danger{
        color:#fff;
        background:linear-gradient(135deg, #ef4444, #dc2626);
        box-shadow:0 10px 20px rgba(239,68,68,0.22);
    }

    .btn.danger:hover{
        transform:translateY(-1px);
        opacity:0.96;
    }

    .empty-cell{
        text-align:center;
        color:#94a3b8 !important;
        padding:28px !important;
        font-weight:600;
    }

    @media (max-width: 768px){
        .panel{
            padding:20px;
            border-radius:22px;
        }

        .panel-header h2{
            font-size:1.55rem;
        }
    }
</style>

</main>
</div>
</body>
</html>