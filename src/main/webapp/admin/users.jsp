<%@ page import="java.util.List" %>
<%@ page import="com.eventhorizon.model.User" %>
<%
    request.setAttribute("pageTitle", "Users");
%>
<%@ include file="layout.jsp" %>

<div class="panel">
    <div class="panel-header">
        <h2>Registered Users</h2>
        <p>Manage customers and admin accounts from one place.</p>
    </div>

    <div class="table-wrap">
        <table class="data-table">
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
                <th>Role</th>
            </tr>
            </thead>
            <tbody>
            <%
                List<User> users = (List<User>) request.getAttribute("users");
                if (users != null && !users.isEmpty()) {
                    for (User u : users) {
            %>
            <tr>
                <td><%= u.getUserId() %></td>
                <td><%= u.getName() %></td>
                <td><%= u.getEmail() %></td>
                <td><%= u.getPhone() %></td>
                <td><span class="badge-role"><%= u.getRole() %></span></td>
            </tr>
            <%
                    }
                } else {
            %>
            <tr>
                <td colspan="5" class="empty-cell">No users found.</td>
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