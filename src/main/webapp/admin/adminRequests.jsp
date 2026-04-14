<%
request.setAttribute("pageTitle", "Admin Requests");
%>
<%@ include file="layout.jsp" %>

<div class="table-container">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Actions</th>
        </tr>
        </thead>

        <tbody>
        <%
            java.util.List list = (java.util.List) request.getAttribute("adminRequests");
            if (list != null) {
                for (Object obj : list) {
                    com.eventhorizon.model.AdminRequest r =
                        (com.eventhorizon.model.AdminRequest) obj;
        %>
        <tr>
            <td><%= r.getRequestId() %></td>
            <td><%= r.getName() %></td>
            <td><%= r.getEmail() %></td>
            <td>
                <form action="<%= request.getContextPath() %>/user" method="post">
                    <input type="hidden" name="action" value="approveAdminRequest">
                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                    <button class="btn btn-primary">Approve</button>
                </form>

                <form action="<%= request.getContextPath() %>/user" method="post">
                    <input type="hidden" name="action" value="rejectAdminRequest">
                    <input type="hidden" name="requestId" value="<%= r.getRequestId() %>">
                    <button class="btn btn-danger">Reject</button>
                </form>
            </td>
        </tr>
        <% }} %>
        </tbody>
    </table>
</div>

</main></div></body></html>