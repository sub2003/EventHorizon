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
        <p class="auth-subtitle">Choose how you want to register</p>

        <div style="display:flex;flex-direction:column;gap:14px;margin-top:24px;">

            <a href="registerCustomer.jsp" class="btn btn-primary btn-block" style="text-align:center;text-decoration:none;">
                👤 Register as Customer
            </a>

            <a href="registerAdminRequest.jsp" class="btn btn-secondary btn-block" style="text-align:center;text-decoration:none;background:#22c55e;">
                🛡 Request Admin Account
            </a>

        </div>

        <div style="margin-top:22px;padding:14px;border-radius:10px;background:rgba(255,255,255,0.04);color:var(--text-muted);font-size:0.9rem;line-height:1.5;">
            <strong style="color:white;">Customer:</strong> create an account and use the website immediately.<br>
            <strong style="color:white;">Admin Request:</strong> submit a request that must be approved by a different admin.
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

<script src="js/main.js"></script>
</body>
</html>