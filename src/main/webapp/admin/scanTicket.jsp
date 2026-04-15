<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    HttpSession currentSession = request.getSession(false);
    String role = currentSession != null ? (String) currentSession.getAttribute("role") : null;

    if (currentSession == null || role == null || !"ADMIN".equals(role)) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Scan Ticket - EventHorizon</title>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <style>
        * { box-sizing: border-box; font-family: Arial, sans-serif; }
        body { background: #050816; color: #eef2ff; margin: 0; }
        .container { width: 92%; max-width: 1000px; margin: 30px auto; }
        .title { font-size: 34px; font-weight: 800; margin-bottom: 20px; }
        .panel {
            background: linear-gradient(180deg, #0b1431, #09112a);
            border: 1px solid rgba(126, 93, 255, 0.18);
            border-radius: 22px;
            padding: 24px;
            margin-bottom: 24px;
        }
        label { display: block; margin-bottom: 8px; color: #a9b5de; font-weight: 700; }
        select, button {
            padding: 12px 14px;
            border-radius: 12px;
            border: 1px solid rgba(255,255,255,0.12);
            background: #081127;
            color: #fff;
            font-size: 15px;
        }
        button {
            background: linear-gradient(90deg, #7c5cff, #2bc0ff);
            border: none;
            font-weight: 800;
            cursor: pointer;
        }
        #reader {
            width: 100%;
            max-width: 520px;
            margin: 20px auto;
            background: #fff;
            border-radius: 16px;
            overflow: hidden;
        }
        .result {
            margin-top: 18px;
            padding: 18px;
            border-radius: 16px;
            font-size: 22px;
            font-weight: 800;
            text-align: center;
        }
        .valid { background: rgba(40, 180, 90, 0.16); color: #89f1ad; }
        .invalid { background: rgba(220, 70, 70, 0.16); color: #ff9d9d; }
        .used { background: rgba(255, 170, 0, 0.16); color: #ffd27d; }
        .wrong { background: rgba(120, 160, 255, 0.16); color: #a8c2ff; }
        .token-box {
            margin-top: 16px;
            padding: 12px;
            background: rgba(255,255,255,0.05);
            border-radius: 12px;
            word-break: break-all;
            color: #dce3ff;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="title">Scan Ticket QR</div>

    <div class="panel">
        <label for="eventId">Select Event ID for Validation</label>
        <input id="eventId" type="text" placeholder="Example: EVT005"
               style="width:100%; padding:12px 14px; border-radius:12px; border:1px solid rgba(255,255,255,0.12); background:#081127; color:#fff;">
        <div style="margin-top:16px;">
            <button onclick="startScanner()">Start Scanner</button>
            <button onclick="stopScanner()" style="margin-left:10px;">Stop Scanner</button>
        </div>
    </div>

    <div class="panel">
        <div id="reader"></div>
        <div id="scanResult" class="result" style="display:none;"></div>
        <div id="tokenBox" class="token-box" style="display:none;"></div>
    </div>
</div>

<script>
    let html5QrCode = null;
    let scanning = false;

    function showResult(type, text, token) {
        const result = document.getElementById("scanResult");
        const tokenBox = document.getElementById("tokenBox");

        result.className = "result " + type;
        result.innerText = text;
        result.style.display = "block";

        if (token) {
            tokenBox.innerText = "Scanned Token: " + token;
            tokenBox.style.display = "block";
        } else {
            tokenBox.style.display = "none";
        }
    }

    function stopScanner() {
        if (html5QrCode && scanning) {
            html5QrCode.stop().then(() => {
                scanning = false;
            }).catch(err => console.error(err));
        }
    }

    function startScanner() {
        const eventId = document.getElementById("eventId").value.trim();
        if (!eventId) {
            alert("Please enter event ID first.");
            return;
        }

        if (!html5QrCode) {
            html5QrCode = new Html5Qrcode("reader");
        }

        html5QrCode.start(
            { facingMode: "environment" },
            { fps: 10, qrbox: 250 },
            function(decodedText) {
                stopScanner();

                fetch("<%= request.getContextPath() %>/ticket?action=verify", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: "qrToken=" + encodeURIComponent(decodedText) +
                          "&eventId=" + encodeURIComponent(eventId)
                })
                .then(response => response.json())
                .then(data => {
                    if (data.result === "VALID") {
                        showResult("valid", "APPROVED", decodedText);
                    } else if (data.result === "ALREADY_USED") {
                        showResult("used", "ALREADY USED", decodedText);
                    } else if (data.result === "WRONG_EVENT") {
                        showResult("wrong", "WRONG EVENT", decodedText);
                    } else {
                        showResult("invalid", "NOT APPROVED", decodedText);
                    }
                })
                .catch(error => {
                    console.error(error);
                    showResult("invalid", "NOT APPROVED", decodedText);
                });
            },
            function(errorMessage) {
                // ignore scan misses
            }
        ).then(() => {
            scanning = true;
        }).catch(err => {
            console.error(err);
            alert("Could not start camera scanner.");
        });
    }
</script>
</body>
</html>