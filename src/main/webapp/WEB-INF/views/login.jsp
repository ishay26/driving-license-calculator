<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>כניסה למערכת - מחשבון נהיגה</title>
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
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
            color: #f4f4f5;
        }

        .login-card {
            background: var(--card-bg);
            width: 100%;
            max-width: 420px;
            padding: 40px 32px;
            border-radius: 24px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.6);
            border: 1px solid var(--gold-border);
        }

        .brand-header { text-align: center; margin-bottom: 30px; }

        .brand-icon {
            width: 52px;
            height: 52px;
            background: var(--gold-grad);
            color: #09090b;
            border-radius: 16px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            margin-bottom: 14px;
        }

        .brand-header h1 { font-size: 24px; font-weight: 900; margin: 0 0 6px 0; color: var(--gold-light); }
        .brand-header p { color: #a1a1aa; font-size: 13px; margin: 0; }

        .input-group { margin-bottom: 18px; }
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
            transition: color 0.2s;
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

        .input-wrapper input:focus { border-color: #f59e0b; box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2); }

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

        .btn-submit:hover { transform: translateY(-2px); }

        .register-link-box {
            text-align: center;
            margin-top: 24px;
            padding-top: 20px;
            border-top: 1px solid #27272a;
        }

        .register-link-box a { color: var(--gold-light); text-decoration: none; font-weight: 800; font-size: 14px; }
        .register-link-box a:hover { text-decoration: underline; }

        .error-alert {
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
            color: #fca5a5;
            padding: 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 700;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="brand-header">
        <div class="brand-icon">
            <i class="fa-solid fa-car-side"></i>
        </div>
        <h1>מחשבון נהיגה</h1>
        <p>כניסה למערכת</p>
    </div>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="input-group">
            <label for="username">שם משתמש</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-user field-icon"></i>
                <input type="text" id="username" name="username" required autofocus placeholder="הכנס שם משתמש">
            </div>
        </div>

        <div class="input-group">
            <label for="password">סיסמה</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-lock field-icon"></i>
                <input type="password" id="password" name="password" required placeholder="הכנס סיסמה">
                <i class="fa-solid fa-eye toggle-eye" id="togglePasswordIcon" onclick="togglePassword('password', 'togglePasswordIcon')"></i>
            </div>
        </div>

        <button type="submit" class="btn-submit">התחבר</button>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-alert">
                <i class="fa-solid fa-triangle-exclamation"></i>
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <div class="register-link-box">
            עוד לא רשום? <a href="${pageContext.request.contextPath}/register">לחץ כאן להרשמה</a>
        </div>
    </form>
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