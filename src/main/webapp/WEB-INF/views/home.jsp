<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>מחשבון נהיגה - דף הבית</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --gold-grad: linear-gradient(135deg, #b45309 0%, #f59e0b 50%, #d97706 100%);
            --gold-light: #fef08a;
            --bg-dark: #09090b;
            --card-bg: #18181b;
            --border-gold: rgba(245, 158, 11, 0.3);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-dark);
            min-height: 100vh;
            margin: 0;
            padding: 0;
            color: #f4f4f5;
            display: flex;
            flex-direction: column;
        }

        .navbar {
            background: #18181b;
            border-bottom: 1px solid var(--border-gold);
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

        .user-nav { display: flex; align-items: center; gap: 14px; }

        .user-badge {
            background: #27272a;
            color: #fef08a;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 700;
            border: 1px solid var(--border-gold);
            text-decoration: none;
            transition: all 0.2s;
        }

        .user-badge:hover { background: #3f3f46; color: #ffffff; }

        .btn-logout {
            color: #fca5a5;
            text-decoration: none;
            font-size: 13px;
            font-weight: 700;
            padding: 6px 14px;
            border-radius: 10px;
            background: rgba(239, 68, 68, 0.15);
            border: 1px solid rgba(239, 68, 68, 0.3);
        }

        .container {
            flex: 1;
            max-width: 640px;
            width: 100%;
            margin: 45px auto;
            padding: 0 20px;
        }

        .card {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 38px;
            border: 1px solid var(--border-gold);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        .card-header { text-align: center; margin-bottom: 30px; }
        .card-header h2 { font-size: 25px; font-weight: 900; margin: 0 0 8px 0; color: var(--gold-light); }
        .card-header p { color: #a1a1aa; font-size: 14px; margin: 0; }

        .form-group { margin-bottom: 22px; }

        .input-label {
            display: block;
            font-weight: 700;
            font-size: 14px;
            color: #e4e4e7;
            margin-bottom: 10px;
        }

        input[type="date"] {
            width: 100%;
            padding: 15px;
            border: 1px solid #3f3f46;
            border-radius: 14px;
            font-size: 15px;
            font-weight: 700;
            outline: none;
            background: #27272a;
            color: #ffffff;
        }

        input[type="date"]:focus {
            border-color: #f59e0b;
            box-shadow: 0 0 0 3px rgba(245, 158, 11, 0.2);
        }

        .btn-section-title {
            font-weight: 700;
            font-size: 13px;
            color: #a1a1aa;
            margin-bottom: 12px;
            display: block;
        }

        .btn-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 12px;
        }

        .btn-action {
            background: #27272a;
            border: 1px solid #3f3f46;
            border-radius: 16px;
            padding: 18px 10px;
            font-weight: 800;
            font-size: 13px;
            color: #f4f4f5;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .btn-action i { font-size: 22px; color: #f59e0b; }

        .btn-action:hover {
            background: var(--gold-grad);
            color: #09090b;
            border-color: transparent;
            transform: translateY(-3px);
        }

        .btn-action:hover i { color: #09090b; }

        @media (max-width: 600px) { .btn-grid { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-brand">
        <div class="mini-car-icon">
            <i class="fa-solid fa-car-side"></i>
        </div>
        <span>מחשבון נהיגה</span>
    </div>
    <div class="user-nav">
        <!-- לחץ כאן כדי לעבור לעריכת הפרופיל -->
        <a href="${pageContext.request.contextPath}/profile" class="user-badge" title="לחץ לעריכת הפרופיל האישי">
            <i class="fa-regular fa-user-gear" style="margin-left: 6px;"></i>
            <%= session.getAttribute("username") %>
        </a>
        <a href="${pageContext.request.contextPath}/logout" class="btn-logout">התנתק</a>
    </div>
</div>

<div class="container">
    <div class="card">
        <div class="card-header">
            <h2>חישוב תוקף ליווי ונהג חדש</h2>
            <p>הזן תאריך ובחר בדיקה מתאימה:</p>
        </div>

        <form method="post" action="${pageContext.request.contextPath}/results">
            <div class="form-group">
                <label class="input-label" for="test_date">
                    <i class="fa-regular fa-calendar-days" style="color: #f59e0b; margin-left: 6px;"></i>
                    תאריך מעבר מבחן מעשי (טסט):
                </label>
                <input type="date" id="test_date" name="test_date" required
                       value="${not empty param.test_date ? param.test_date : (not empty testDate ? testDate : '')}">
            </div>

            <span class="btn-section-title">בחר סוג בדיקה:</span>
            <div class="btn-grid">
                <button type="submit" name="type" value="day" class="btn-action">
                    <i class="fa-solid fa-sun"></i>
                    <span>מלווה יום ולילה</span>
                </button>
                <button type="submit" name="type" value="night" class="btn-action">
                    <i class="fa-solid fa-moon"></i>
                    <span>מלווה לילה</span>
                </button>
                <button type="submit" name="type" value="young" class="btn-action">
                    <i class="fa-solid fa-id-card"></i>
                    <span>נהג חדש</span>
                </button>
            </div>
        </form>
    </div>
</div>

</body>
</html>