<%
request.setAttribute("pageTitle", "Users");
%>
<%@ include file="layout.jsp" %>

<div class="table-container">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Role</th>
        </tr>
        </thead>

        <tbody>
        <%
            java.util.List users = (java.util.List) request.getAttribute("users");
            if (users != null) {
                for (Object obj : users) {
                    com.eventhorizon.model.User u = (com.eventhorizon.model.User) obj;
        %>
        <tr>
            <td><%= u.getUserId() %></td>
            <td><%= u.getName() %></td>
            <td><%= u.getEmail() %></td>
            <td><%= u.getRole() %></td>
        </tr>
        <% }} %>
        </tbody>
    </table>
</div>

</main></div></body></html>