<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
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

        if ("approved".equals(msg)) {
    %>
        <div class="alert success">Admin request approved successfully.</div>
    <%
        } else if ("rejected".equals(msg)) {
    %>
        <div class="alert success">Admin request rejected successfully.</div>
    <%
        }

        if ("approveFailed".equals(error)) {
    %>
        <div class="alert error">Failed to approve request. You may be approving your own request or the email already exists.</div>
    <%
        } else if ("rejectFailed".equals(error)) {
    %>
        <div class="alert error">Failed to reject request. You may be rejecting your own request.</div>
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
                <th>Requested At</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                String currentAdminId = (String) session.getAttribute("userId");
                List<Map<String, String>> list =
                        (List<Map<String, String>>) request.getAttribute("adminRequests");

                if (list != null && !list.isEmpty()) {
                    for (Map<String, String> r : list) {
                        boolean ownRequest = currentAdminId != null &&
                                currentAdminId.equals(r.get("requesterAdminId"));
            %>
            <tr>
                <td><%= r.get("requestId") %></td>
                <td><%= r.get("requesterAdminId") %></td>
                <td><%= r.get("requestedName") %></td>
                <td><%= r.get("requestedEmail") %></td>
                <td><%= r.get("requestedPhone") %></td>
                <td><%= r.get("requestedAt") %></td>
                <td>
                    <div class="action-group">
                        <%
                            if (ownRequest) {
                        %>
                            <button class="btn disabled" disabled>Approve</button>
                            <button class="btn disabled" disabled>Reject</button>
                        <%
                            } else {
                        %>
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
                        <%
                            }
                        %>
                    </div>
                </td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="7" class="empty-cell">No pending admin requests.</td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
</div>

    </main>
</div>
</body>
</html>