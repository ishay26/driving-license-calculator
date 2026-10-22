<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>כניסה למערכת - מחשבון נהיגה</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-grad: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            --bg-grad: linear-gradient(135deg, #0f172a 0%, #1e1b4b 100%);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-grad);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            padding: 20px;
        }

        .login-card {
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            width: 100%;
            max-width: 420px;
            padding: 40px 36px;
            border-radius: 28px;
            box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.35);
        }

        .brand-icon {
            width: 64px;
            height: 64px;
            background: var(--primary-grad);
            color: white;
            border-radius: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 30px;
            margin: 0 auto 16px auto;
            box-shadow: 0 10px 20px rgba(79, 70, 229, 0.3);
        }

        .title {
            text-align: center;
            font-size: 24px;
            font-weight: 800;
            color: #0f172a;
            margin: 0 0 6px 0;
        }

        .subtitle {
            text-align: center;
            color: #64748b;
            font-size: 14px;
            margin-bottom: 28px;
        }

        .input-group {
            margin-bottom: 20px;
        }

        .input-group label {
            display: block;
            font-weight: 700;
            font-size: 13px;
            color: #334155;
            margin-bottom: 8px;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            right: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
        }

        .input-wrapper input {
            width: 100%;
            padding: 12px 42px 12px 14px;
            border: 1px solid #cbd5e1;
            border-radius: 12px;
            font-size: 15px;
            outline: none;
            transition: all 0.2s;
            background: #f8fafc;
        }

        .input-wrapper input:focus {
            background: white;
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .btn-group {
            display: flex;
            gap: 12px;
            margin-top: 28px;
        }

        .btn {
            flex: 1;
            padding: 14px;
            border-radius: 12px;
            font-size: 15px;
            font-weight: 700;
            cursor: pointer;
            border: none;
            transition: all 0.2s;
        }

        .btn-login {
            background: var(--primary-grad);
            color: white;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
        }

        .btn-login:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(79, 70, 229, 0.4);
        }

        .btn-register {
            background: #f1f5f9;
            color: #334155;
            border: 1px solid #cbd5e1;
        }

        .btn-register:hover {
            background: #e2e8f0;
        }

        .error-box {
            background: #fef2f2;
            border: 1px solid #fecaca;
            color: #dc2626;
            padding: 12px;
            border-radius: 10px;
            font-size: 13px;
            font-weight: 600;
            margin-top: 20px;
            text-align: center;
        }
    </style>
</head>
<body>

<div class="login-card">
    <div class="brand-icon">
        <i class="fa-solid fa-car-side"></i>
    </div>
    <h1 class="title">מחשבון נהיגה</h1>
    <p class="subtitle">התחבר או הירשם כדי לנהל ולחשב מועדים</p>

    <form method="post" action="${pageContext.request.contextPath}/login">
        <div class="input-group">
            <label for="username">שם משתמש</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-user"></i>
                <input type="text" id="username" name="username" required autofocus placeholder="הכנס שם משתמש">
            </div>
        </div>

        <div class="input-group">
            <label for="password">סיסמה</label>
            <div class="input-wrapper">
                <i class="fa-solid fa-lock"></i>
                <input type="password" id="password" name="password" required placeholder="הכנס סיסמה">
            </div>
        </div>

        <div class="btn-group">
            <button type="submit" name="action" value="login" class="btn btn-login">התחבר</button>
            <button type="submit" name="action" value="register" class="btn btn-register">הרשם</button>
        </div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="error-box">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
    </form>
</div>

</body>
</html>