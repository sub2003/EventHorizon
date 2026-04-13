<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String role = (String) session.getAttribute("role");
    if (session == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Admin Request</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 0;
        }
        .container {
            width: 500px;
            margin: 50px auto;
            background: #fff;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 0 12px rgba(0,0,0,0.12);
        }
        h2 {
            margin-top: 0;
            color: #333;
            text-align: center;
        }
        label {
            display: block;
            margin-top: 12px;
            font-weight: bold;
        }
        input {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }
        button {
            width: 100%;
            margin-top: 20px;
            padding: 12px;
            border: none;
            border-radius: 6px;
            background: #007bff;
            color: white;
            font-size: 15px;
            cursor: pointer;
        }
        button:hover {
            background: #0056b3;
        }
        .msg {
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
        }
        .success {
            background: #d4edda;
            color: #155724;
        }
        .error {
            background: #f8d7da;
            color: #721c24;
        }
        .links {
            margin-top: 15px;
            text-align: center;
        }
        .links a {
            text-decoration: none;
            margin: 0 10px;
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Request New Admin</h2>

    <%
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");

        if ("requestSubmitted".equals(msg)) {
    %>
        <div class="msg success">Admin request submitted successfully. Another admin must approve it.</div>
    <%
        }

        if ("requestFailed".equals(error)) {
    %>
        <div class="msg error">Failed to submit admin request. Email may already exist or a pending request already exists.</div>
    <%
        }
    %>

    <form action="<%= request.getContextPath() %>/user" method="post">
        <input type="hidden" name="action" value="requestAdmin">

        <label>Full Name</label>
        <input type="text" name="name" required>

        <label>Email</label>
        <input type="email" name="email" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Phone</label>
        <input type="text" name="phone" required>

        <button type="submit">Submit Admin Request</button>
    </form>

    <div class="links">
        <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">View Pending Requests</a>
        <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Back to Dashboard</a>
    </div>
</div>
</body>
</html>