<%
request.setAttribute("pageTitle", "Request Admin");
%>
<%@ include file="layout.jsp" %>

<div class="form-box">
    <form action="<%= request.getContextPath() %>/user" method="post">
        <input type="hidden" name="action" value="requestAdmin">

        <label>Name</label>
        <input name="name" required>

        <label>Email</label>
        <input name="email" required>

        <label>Password</label>
        <input type="password" name="password" required>

        <label>Phone</label>
        <input name="phone" required>

        <button class="btn btn-primary">Submit Request</button>
    </form>
</div>

</main></div></body></html>