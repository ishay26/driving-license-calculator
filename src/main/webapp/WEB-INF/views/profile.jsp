<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>עריכת פרופיל - מחשבון נהיגה</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --gold-grad: linear-gradient(135deg, #b45309 0%, #f59e0b 50%, #d97706 100%);
            --gold-light: #fef08a;
            --gold-border: rgba(245, 158, 11, 0.4);
            --bg-dark: #09090b;
            --card-bg: #18181b;
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-dark);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            color: #f4f4f5;
        }

        .navbar {
            background: #18181b;
            border-bottom: 1px solid var(--gold-border);
            padding: 16px 36px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            font-weight: 900;
            font-size: 20px;
            color: var(--gold-light);
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .mini-car-icon {
            background: var(--gold-grad);
            color: #09090b;
            width: 34px;
            height: 34px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
        }

        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 0 20px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 36px;
            border: 1px solid var(--gold-border);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        .input-group { margin-bottom: 20px; }
        .input-group label { display: block; font-weight: 700; font-size: 13px; color: #d4d4d8; margin-bottom: 8px; }

        .input-wrapper { position: relative; }
        .input-wrapper .field-icon { position: absolute; right: 16px; top: 50%; transform: translateY(-50%); color: #f59e0b; font-size: 14px; }
        .input-wrapper .toggle-eye {
            position: absolute;
            left: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #a1a1aa;
            font-size: 14px;
            cursor: pointer;
        }
        .input-wrapper .toggle-eye:hover { color: #f59e0b; }

        .input-wrapper input {
            width: 100%;
            padding: 14px 44px 14px 44px;
            border: 1px solid #3f3f46;
            border-radius: 14px;
            font-size: 15px;
            outline: none;
            background: #27272a;
            color: #ffffff;
        }

        .btn-submit {
            width: 100%;
            padding: 14px;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 800;
            cursor: pointer;
            border: none;
            background: var(--gold-grad);
            color: #09090b;
            margin-top: 10px;
        }

        .btn-back {
            display: inline-block;
            color: #a1a1aa;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 20px;
        }

        .alert-success {
            background: rgba(34, 197, 94, 0.15);
            border: 1px solid rgba(34, 197, 94, 0.3);
            color: #86efac;
            padding: 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
            text-align: center;
        }

        .alert-error {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5;
            padding: 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            margin-bottom: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-brand">
        <div class="mini-car-icon">
            <i class="fa-solid fa-car-side"></i>
        </div>
        <span>מחשבון נהיגה - פרופיל אישי</span>
    </div>
</div>

<div class="container">
    <a href="${pageContext.request.contextPath}/home" class="btn-back">
        <i class="fa-solid fa-arrow-right"></i> חזור לדף הבית
    </a>

    <div class="card">
        <h2 style="margin-top:0; color: var(--gold-light);">עריכת פרטי חשבון</h2>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert-success"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("success") %></div>
        <% } %>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert-error"><i class="fa-solid fa-triangle-exclamation"></i> <%= request.getAttribute("error") %></div>
        <% } %>

        <form method="post" action="${pageContext.request.contextPath}/profile">
            <div class="input-group">
                <label for="username">שם משתמש</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-user field-icon"></i>
                    <input type="text" id="username" name="username" value="${usernameVal}" required style="padding-left: 16px;">
                </div>
            </div>

            <div class="input-group">
                <label for="password">סיסמה</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-lock field-icon"></i>
                    <input type="password" id="password" name="password" value="${passwordVal}" required>
                    <i class="fa-solid fa-eye toggle-eye" id="toggleProfPasswordIcon" onclick="togglePassword('password', 'toggleProfPasswordIcon')"></i>
                </div>
            </div>

            <div class="input-group">
                <label for="birth_date">תאריך לידה</label>
                <div class="input-wrapper">
                    <i class="fa-solid fa-cake-candles field-icon"></i>
                    <input type="date" id="birth_date" name="birth_date" value="${birthDateVal}" required style="padding-left: 16px;">
                </div>
            </div>

            <button type="submit" class="btn-submit">שמור שינויים</button>
        </form>
    </div>
</div>

<script>
    function togglePassword(inputId, iconId) {
        const input = document.getElementById(inputId);
        const icon = document.getElementById(iconId);
        if (input.type === "password") {
            input.type = "text";
            icon.classList.remove("fa-eye");
            icon.classList.add("fa-eye-slash");
        } else {
            input.type = "password";
            icon.classList.remove("fa-eye-slash");
            icon.classList.add("fa-eye");
        }
    }
</script>

</body>
</html>