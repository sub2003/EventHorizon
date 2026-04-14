<%@ page contentType="text/html;charset=UTF-8" %>
<%
    String title = (String) request.getAttribute("pageTitle");
    if (title == null) title = "Admin Panel";
%>
<!DOCTYPE html>
<html>
<head>
    <title><%= title %></title>

    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/dashboard.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/admin.css">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
</head>
<body>

<div class="admin-shell">

    <aside class="sidebar">
        <h2>EVENTHORIZON</h2>

        <nav>
            <a href="<%= request.getContextPath() %>/admin/dashboard.jsp">Dashboard</a>
            <a href="<%= request.getContextPath() %>/user?action=list">Users</a>
            <a href="<%= request.getContextPath() %>/event?action=adminList">Events</a>
            <a href="<%= request.getContextPath() %>/admin/bookings.jsp">Bookings</a>
            <a href="<%= request.getContextPath() %>/user?action=listAdminRequests">Admin Requests</a>
        </nav>

        <a class="logout-btn" href="<%= request.getContextPath() %>/user?action=logout">
            Logout
        </a>
    </aside>

    <main class="main-content">
        <div class="topbar">
            <h1><%= title %></h1>
            <p>Welcome, <%= session.getAttribute("userName") %></p>
        </div>