<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List,java.util.Map" %>
<%
    String role = (String) session.getAttribute("role");
    if (session == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    List<Map<String, String>> adminRequests =
            (List<Map<String, String>>) request.getAttribute("adminRequests");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Pending Admin Requests</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 20px;
        }
        h2 {
            text-align: center;
            color: #333;
        }
        .msg {
            width: 90%;
            max-width: 1100px;
            margin: 15px auto;
            padding: 10px;
            border-radius: 6px;
        }
        .success {
            background: #d4edda;
            color: #155724;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
        }
        table {
            width: 90%;
            margin: 20px auto;
            border-collapse: collapse;
            background: #fff;
            box-shadow: 0 0 12px rgba(0,0,0,0.08);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #007bff;
            color: white;
        }
        .actions form {
            display: inline-block;
            margin: 0 4px;
        }
        .approve-btn, .reject-btn {
            border: none;
            padding: 8px 12px;
            border-radius: 5px;
            color: white;
            cursor: pointer;
        }
        .approve-btn {
            background: #28a745;
        }
        .reject-btn {
            background: #dc3545;
        }
        .top-links {
            text-align: center;
            margin-top: 20px;
        }
        .top-links a {
            text-decoration: none;
            margin: 0 10px;
            color: #007bff;
        }
        .empty {
            width: 90%;
            max-width: 1100px;
            margin: 25px auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            box-shadow: 0 0 12px rgba(0,0,0,0.08);
        }
    </style>
</head>
<body>

<h2>Pending Admin Requests</h2>

<%
    String msg = request.getParameter("msg");
    String error = request.getParameter("error");

    if ("approved".equals(msg)) {
%>
    <div class="msg success">Admin request approved successfully.</div>
<%
    } else if ("rejected".equals(msg)) {
%>
    <div class="msg success">Admin request rejected successfully.</div>
<%
    }

    if ("approveFailed".equals(error)) {
%>
    <div class="msg error">Failed to approve request. You may be trying to approve your own request or the email already exists.</div>
<%
    } else if ("rejectFailed".equals(error)) {
%>
    <div class="msg error">Failed to reject request. You may be trying to reject your own request.</div>
<%
    }
%>

<%
    if (adminRequests == null || adminRequests.isEmpty()) {
%>
    <div class="empty">No pending admin requests.</div>
<%
    } else {
%>
    <table>
        <tr>
            <th>Request ID</th>
            <th>Requested By Admin ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Requested At</th>
            <th>Actions</th>
        </tr>

        <%
            for (Map<String, String> requestRow : adminRequests) {
        %>
        <tr>
            <td><%= requestRow.get("requestId") %></td>
            <td><%= requestRow.get("requesterAdminId") %></td>
            <td><%= requestRow.get("requestedName") %></td>
            <td><%= requestRow.get("requestedEmail") %></td>
            <td><%= requestRow.get("requestedPhone") %></td>
            <td><%= requestRow.get("requestedAt") %></td>
            <td class="actions">
                <form action="<%= request.getContextPath() %>/user" method="post">
                    <input type="hidden" name="action" value="approveAdminRequest">
                    <input type="hidden" name="requestId" value="<%= requestRow.get("requestId") %>">
                    <button type="submit" class="approve-btn">Approve</button>
                </form>

                <form action="<%= request.getContextPath() %>/user" method="post">
                    <input type="hidden" name="action" value="rejectAdminRequest">
                    <input type="hidden" name="requestId" value="<%= requestRow.get("requestId") %>">
                    <button type="submit" class="reject-btn">Reject</button>
                </form>
            </td>
        </tr>
        <%
            }
        %>
    </table>
<%
    }
%>

<div class="top-links">
    <a href="<%= request.getContextPath() %>/user?action=addAdminForm">Create Admin Request</a>
    <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Back to Dashboard</a>
</div>

</body>
</html>