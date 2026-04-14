<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">⬡ EVENTHORIZON</div>
        <p class="auth-subtitle">Create your customer account</p>

        <% if ("registerFailed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Registration failed. The email may already exist or some fields may be invalid.
            </div>
        <% } %>

        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success" data-auto-dismiss>
                ✅ Your customer account was created successfully. Please sign in.
            </div>
        <% } %>

        <% if ("notAllowed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Admin self-registration is not allowed.
            </div>
        <% } %>

        <form action="user" method="post" class="needs-validation" onsubmit="return validatePasswords();">
            <input type="hidden" name="action" value="register">

            <div class="form-group">
                <label class="form-label" for="name">Full Name</label>
                <input type="text"
                       id="name"
                       name="name"
                       class="form-control"
                       placeholder="John Silva"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="email">Email Address</label>
                <input type="email"
                       id="email"
                       name="email"
                       class="form-control"
                       placeholder="you@example.com"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="phone">Phone Number</label>
                <input type="tel"
                       id="phone"
                       name="phone"
                       class="form-control"
                       placeholder="07X XXX XXXX"
                       required>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="Min 6 characters"
                       required
                       minlength="6">
            </div>

            <div class="form-group">
                <label class="form-label" for="confirmPassword">Confirm Password</label>
                <input type="password"
                       id="confirmPassword"
                       name="confirmPassword"
                       class="form-control"
                       placeholder="Repeat password"
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top:8px;">
                ✨ Create Account
            </button>
        </form>

        <div style="margin-top:18px;padding:12px;border-radius:10px;background:rgba(255,255,255,0.04);color:var(--text-muted);font-size:0.9rem;line-height:1.5;">
            Create a customer account to browse events, book tickets, and manage your bookings securely.
        </div>

        <p style="text-align:center;margin-top:24px;color:var(--text-muted);font-size:0.9rem;">
            Already have an account?
            <a href="login.jsp" style="color:var(--accent-teal);font-weight:600;">Sign in</a>
        </p>

        <p style="text-align:center;margin-top:8px;">
            <a href="index.jsp" style="color:var(--text-muted);font-size:0.85rem;">← Back to Home</a>
        </p>
    </div>
</div>

<script>
    function validatePasswords() {
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