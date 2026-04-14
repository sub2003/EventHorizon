<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login – EventHorizon</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="auth-wrapper">
    <div class="auth-card">
        <div class="auth-logo">⬡ EVENTHORIZON</div>
        <p class="auth-subtitle">Sign in to your account</p>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Invalid email or password.
            </div>
        <% } %>

        <% if ("notVerified".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ⚠️ Please verify your email before logging in.
            </div>
        <% } %>

        <% if ("invalidToken".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Verification link is invalid or expired.
            </div>
        <% } %>

        <% if ("emailSendFailed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ Account created, but email could not be sent.
            </div>
        <% } %>

        <% if ("registered".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success" data-auto-dismiss>
                ✅ Account created successfully. Please log in.
            </div>
        <% } %>

        <% if ("checkEmail".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info" data-auto-dismiss>
                📧 Registration successful. Check your email to verify your account.
            </div>
        <% } %>

        <% if ("verified".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success" data-auto-dismiss>
                ✅ Email verified successfully. You can now log in.
            </div>
        <% } %>

        <% if ("logout".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info" data-auto-dismiss>
                👋 You have been logged out.
            </div>
        <% } %>

        <% if ("notAllowed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger" data-auto-dismiss>
                ❌ That action is not allowed.
            </div>
        <% } %>

        <form action="user" method="post" class="needs-validation">
            <input type="hidden" name="action" value="login">

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
                <label class="form-label" for="password">Password</label>
                <input type="password"
                       id="password"
                       name="password"
                       class="form-control"
                       placeholder="••••••••"
                       required>
            </div>

            <button type="submit" class="btn btn-primary btn-block" style="margin-top:8px;">
                🚀 Sign In
            </button>
        </form>

        <p style="text-align:center;margin-top:24px;color:var(--text-muted);font-size:0.9rem;">
            Don't have an account?
            <a href="register.jsp" style="color:var(--accent-teal);font-weight:600;">
                Sign up
            </a>
        </p>

        <p style="text-align:center;margin-top:8px;">
            <a href="index.jsp" style="color:var(--text-muted);font-size:0.85rem;">
                ← Back to Home
            </a>
        </p>

        <div class="alert alert-info" style="margin-top:24px;font-size:0.82rem;">
            <div><strong>Demo Admin:</strong> admin@eventhorizon.com / admin123</div>
            <div style="margin-top:4px;"><strong>Demo Customer:</strong> bob@gmail.com / pass123</div>
        </div>
    </div>
</div>

<script src="js/main.js"></script>
</body>
</html>