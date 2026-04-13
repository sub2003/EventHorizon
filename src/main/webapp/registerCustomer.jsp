<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">⬡ EVENTHORIZON</div>
        <p class="auth-subtitle">Create your customer account</p>

        <% if ("emailExists".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ An account with that email already exists.
            </div>
        <% } %>

        <form action="user" method="post" class="needs-validation" onsubmit="return validateCustomerPasswords();">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text" id="name" name="name"
                       class="form-control" placeholder="John Silva" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input type="email" id="email" name="email"
                       class="form-control" placeholder="you@example.com" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel" id="phone" name="phone"
                       class="form-control" placeholder="07X XXX XXXX" required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password" id="password" name="password"
                       class="form-control" placeholder="Min 6 characters" required minlength="6">
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword"
                       class="form-control" placeholder="Repeat password" required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top:8px;">
                ✨ Create Customer Account
            </button>
        </form>

        <p style="text-align:center;margin-top:24px;color:var(--text-muted);font-size:0.9rem;">
            Want to request admin access?
            <a href="registerAdminRequest.jsp" style="color:var(--accent-teal);font-weight:600;">Request Admin</a>
        </p>

        <p style="text-align:center;margin-top:8px;">
            <a href="register.jsp" style="color:var(--text-muted);font-size:0.85rem;">← Back</a>
        </p>
    </div>
</div>

<script>
    function validateCustomerPasswords() {
        const password = document.getElementById("password").value;
        const confirmPassword = document.getElementById("confirmPassword").value;

        if (password !== confirmPassword) {
            alert("Passwords do not match.");
            return false;
        }
        return true;
    }
</script>

<script src="js/main.js"></script>
</body>
</html>