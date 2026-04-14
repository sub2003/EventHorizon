<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    request.setAttribute("pageTitle", "Request Admin");
%>
<%@ include file="layout.jsp" %>

<div class="panel">
    <div class="panel-header">
        <h2>Request New Admin</h2>
        <p>Create a new admin access request and choose the permission category.</p>
    </div>

    <%
        String msg = request.getParameter("msg");
        String error = request.getParameter("error");
    %>

    <% if ("requestSubmitted".equals(msg)) { %>
        <div class="alert success">Admin request submitted successfully.</div>
    <% } %>

    <% if ("requestFailed".equals(error)) { %>
        <div class="alert error">Failed to submit admin request. Check the details and make sure the email is not already used or already pending.</div>
    <% } %>

    <div class="form-card">
        <form action="<%= request.getContextPath() %>/user" method="post" class="admin-form">
            <input type="hidden" name="action" value="requestAdmin">

            <div class="form-grid">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" name="name" required placeholder="Enter full name">
                </div>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email" id="email" name="email" required placeholder="Enter email address">
                </div>

                <div class="form-group">
                    <label for="phone">Phone Number</label>
                    <input type="text" id="phone" name="phone" required placeholder="Enter phone number">
                </div>

                <div class="form-group">
                    <label for="password">Temporary Password</label>
                    <input type="text" id="password" name="password" required placeholder="Enter temporary password">
                </div>

                <div class="form-group">
                    <label for="adminPermission">Permission</label>
                    <select id="adminPermission" name="adminPermission" required>
                        <option value="EVENTS_ONLY">Events only</option>
                        <option value="BOOKINGS_ONLY">Bookings only</option>
                        <option value="EVENTS_BOOKINGS">Events + Bookings</option>
                        <option value="FULL_ACCESS" selected>Full Access</option>
                    </select>
                </div>
            </div>

            <div class="form-actions">
                <button type="submit" class="btn primary">Submit Request</button>
                <a href="<%= request.getContextPath() %>/user?action=listAdminRequests" class="btn secondary">View Pending Requests</a>
            </div>
        </form>
    </div>
</div>

<style>
    .panel {
        background: rgba(15, 23, 42, 0.88);
        border: 1px solid rgba(255,255,255,0.08);
        border-radius: 24px;
        padding: 28px;
        box-shadow: 0 18px 40px rgba(0,0,0,0.28);
    }

    .panel-header {
        margin-bottom: 22px;
    }

    .panel-header h2 {
        margin: 0 0 8px;
        font-size: 34px;
        color: #ffffff;
        font-weight: 800;
    }

    .panel-header p {
        margin: 0;
        color: #cbd5e1;
        font-size: 17px;
    }

    .alert {
        border-radius: 14px;
        padding: 14px 16px;
        margin-bottom: 18px;
        font-weight: 700;
    }

    .alert.success {
        background: rgba(16, 185, 129, 0.15);
        color: #a7f3d0;
        border: 1px solid rgba(16, 185, 129, 0.35);
    }

    .alert.error {
        background: rgba(239, 68, 68, 0.14);
        color: #fecaca;
        border: 1px solid rgba(239, 68, 68, 0.35);
    }

    .form-card {
        background: rgba(255,255,255,0.02);
        border: 1px solid rgba(255,255,255,0.06);
        border-radius: 20px;
        padding: 22px;
    }

    .admin-form {
        width: 100%;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 18px;
    }

    .form-group {
        display: flex;
        flex-direction: column;
    }

    .form-group label {
        margin-bottom: 8px;
        font-size: 13px;
        text-transform: uppercase;
        letter-spacing: 0.5px;
        font-weight: 800;
        color: #cbd5e1;
    }

    .form-group input,
    .form-group select {
        width: 100%;
        padding: 14px 16px;
        border-radius: 14px;
        border: 1px solid rgba(255,255,255,0.1);
        background: rgba(7, 13, 28, 0.9);
        color: white;
        font-size: 15px;
        outline: none;
    }

    .form-group input:focus,
    .form-group select:focus {
        border-color: rgba(99, 102, 241, 0.6);
        box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
    }

    .form-actions {
        display: flex;
        gap: 12px;
        flex-wrap: wrap;
        margin-top: 24px;
    }

    .btn {
        text-decoration: none;
        border: none;
        border-radius: 14px;
        padding: 12px 20px;
        font-size: 15px;
        font-weight: 800;
        cursor: pointer;
        display: inline-flex;
        align-items: center;
        justify-content: center;
    }

    .btn.primary {
        color: white;
        background: linear-gradient(135deg, #4f46e5, #6366f1);
    }

    .btn.secondary {
        color: #e2e8f0;
        background: rgba(255,255,255,0.05);
        border: 1px solid rgba(255,255,255,0.12);
    }

    @media (max-width: 860px) {
        .form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>

</main>
</div>
</body>
</html>