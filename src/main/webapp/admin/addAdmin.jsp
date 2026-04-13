<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String msg = request.getParameter("msg");
    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Request New Admin</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; padding: 0; }
        .container { width: 500px; margin: 50px auto; background: #ffffff; padding: 25px; border-radius: 10px; box-shadow: 0 0 12px rgba(0,0,0,0.12); }
        h2 { text-align: center; margin-top: 0; color: #333; }
        .msg { padding: 12px; border-radius: 6px; margin-bottom: 15px; font-size: 14px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        label { display: block; margin-top: 12px; font-weight: bold; color: #333; }
        input { width: 100%; padding: 10px; margin-top: 6px; border: 1px solid #ccc; border-radius: 6px; box-sizing: border-box; }
        button { width: 100%; margin-top: 20px; padding: 12px; border: none; border-radius: 6px; background: #007bff; color: white; font-size: 15px; cursor: pointer; }
        button:hover { background: #0056b3; }
        .links { margin-top: 18px; text-align: center; }
        .links a { text-decoration: none; margin: 0 10px; color: #007bff; }
        .note { margin-top: 15px; font-size: 13px; color: #555; background: #f1f3f5; padding: 12px; border-radius: 6px; }
    </style>
</head>
<body>

<div class="container">
    <h2>Request New Admin</h2>

    <% if ("requestSubmitted".equals(msg)) { %>
        <div class="msg success">Admin request submitted successfully. Another admin must approve it.</div>
    <% } %>

    <% if ("requestFailed".equals(error)) { %>
        <div class="msg error">Failed to submit admin request. The email may already exist or another pending request already exists.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/user" method="post">
        <input type="hidden" name="action" value="requestAdmin">

        <label for="name">Full Name</label>
        <input type="text" id="name" name="name" required>

        <label for="email">Email Address</label>
        <input type="email" id="email" name="email" required>

        <label for="phone">Phone Number</label>
        <input type="text" id="phone" name="phone" required>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" required>

        <button type="submit">Submit Admin Request</button>
    </form>

    <div class="note">
        This request will stay pending until a different admin approves it.
        The admin who creates the request cannot approve it.
    </div>

    <div class="links">
        <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">View Pending Requests</a>
        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Back to Dashboard</a>
    </div>
</div>

</body>
</html>