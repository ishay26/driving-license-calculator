<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>מחשבון נהיגה - לוח בקרה מתקדם</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        :root {
            --primary-grad: linear-gradient(135deg, #4f46e5 0%, #7c3aed 100%);
            --accent-grad: linear-gradient(135deg, #10b981 0%, #059669 100%);
            --card-bg: rgba(255, 255, 255, 0.9);
            --bg-grad: linear-gradient(135deg, #f0f4ff 0%, #e0e7ff 50%, #f3e8ff 100%);
            --text-dark: #0f172a;
            --text-muted: #64748b;
            --shadow-sm: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            --shadow-lg: 0 20px 25px -5px rgba(79, 70, 229, 0.1), 0 8px 10px -6px rgba(0, 0, 0, 0.04);
        }

        * { box-sizing: border-box; }

        body {
            font-family: 'Segoe UI', system-ui, -apple-system, sans-serif;
            background: var(--bg-grad);
            min-height: 100vh;
            color: var(--text-dark);
            margin: 0;
            padding: 0;
        }

        .navbar {
            background: rgba(255, 255, 255, 0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid rgba(226, 232, 240, 0.8);
            padding: 16px 40px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: var(--shadow-sm);
        }

        .nav-brand {
            font-weight: 800;
            font-size: 20px;
            background: var(--primary-grad);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav-user {
            display: flex;
            align-items: center;
            gap: 16px;
        }

        .user-badge {
            background: #e0e7ff;
            color: #4338ca;
            padding: 8px 18px;
            border-radius: 30px;
            font-size: 14px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .logout-btn {
            color: #ef4444;
            text-decoration: none;
            font-size: 14px;
            font-weight: 700;
            padding: 8px 16px;
            border-radius: 12px;
            background: #fef2f2;
            border: 1px solid #fecaca;
            transition: all 0.2s ease;
        }

        .logout-btn:hover {
            background: #fee2e2;
            transform: translateY(-1px);
        }

        .container {
            max-width: 1200px;
            margin: 40px auto;
            padding: 0 24px;
            display: grid;
            grid-template-columns: 1fr 360px;
            gap: 32px;
        }

        .card {
            background: var(--card-bg);
            backdrop-filter: blur(16px);
            border-radius: 24px;
            border: 1px solid rgba(255, 255, 255, 0.6);
            padding: 32px;
            box-shadow: var(--shadow-lg);
        }

        .hero-title {
            font-size: 26px;
            font-weight: 800;
            margin: 0 0 8px 0;
            color: #1e1b4b;
        }

        .hero-subtitle {
            color: var(--text-muted);
            font-size: 15px;
            margin-bottom: 28px;
        }

        .form-container {
            background: linear-gradient(135deg, #ffffff 0%, #f8fafc 100%);
            border: 2px solid #e0e7ff;
            border-radius: 20px;
            padding: 24px;
            box-shadow: var(--shadow-sm);
            margin-bottom: 32px;
        }

        .form-label {
            font-weight: 700;
            font-size: 15px;
            color: #334155;
            display: block;
            margin-bottom: 10px;
        }

        .input-row {
            display: flex;
            gap: 14px;
        }

        input[type="date"] {
            flex: 1;
            padding: 14px 18px;
            border: 1px solid #cbd5e1;
            border-radius: 14px;
            font-size: 16px;
            font-weight: 600;
            outline: none;
            transition: all 0.2s;
            background: white;
        }

        input[type="date"]:focus {
            border-color: #6366f1;
            box-shadow: 0 0 0 4px rgba(99, 102, 241, 0.15);
        }

        .btn-calc {
            background: var(--primary-grad);
            color: white;
            border: none;
            padding: 14px 28px;
            border-radius: 14px;
            font-weight: 700;
            font-size: 15px;
            cursor: pointer;
            box-shadow: 0 4px 12px rgba(79, 70, 229, 0.3);
            transition: all 0.2s;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .btn-calc:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(79, 70, 229, 0.4);
        }

        .tabs-nav {
            display: flex;
            gap: 10px;
            background: #eef2ff;
            padding: 6px;
            border-radius: 16px;
            margin-bottom: 24px;
        }

        .tab-btn {
            flex: 1;
            padding: 12px;
            border: none;
            background: transparent;
            color: #475569;
            font-weight: 700;
            font-size: 14px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.2s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
        }

        .tab-btn.active {
            background: white;
            color: #4f46e5;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.05);
        }

        .result-card {
            display: none;
            background: linear-gradient(135deg, #ffffff 0%, #f0fdf4 100%);
            border: 2px solid #86efac;
            border-radius: 20px;
            padding: 28px;
            animation: fadeIn 0.3s ease-in-out;
        }

        .result-card.active { display: block; }

        .result-header {
            display: flex;
            align-items: center;
            gap: 12px;
            color: #166534;
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 12px;
        }

        .result-date-display {
            font-size: 32px;
            font-weight: 900;
            color: #14532d;
            margin-bottom: 14px;
            letter-spacing: -0.5px;
        }

        .time-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--accent-grad);
            color: white;
            padding: 8px 18px;
            border-radius: 30px;
            font-weight: 700;
            font-size: 14px;
            box-shadow: 0 4px 10px rgba(16, 185, 129, 0.25);
        }

        .sidebar-title {
            font-size: 18px;
            font-weight: 800;
            margin: 0 0 18px 0;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #1e1b4b;
        }

        .history-list {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .history-item {
            background: white;
            border: 1px solid #e2e8f0;
            border-radius: 14px;
            padding: 14px 18px;
            margin-bottom: 12px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s;
        }

        .history-item:hover {
            border-color: #a5b4fc;
            transform: translateX(-4px);
        }

        .history-date {
            font-weight: 700;
            font-size: 15px;
            color: #1e293b;
        }

        .history-time-badge {
            font-size: 12px;
            font-weight: 600;
            color: #6366f1;
            background: #e0e7ff;
            padding: 4px 10px;
            border-radius: 20px;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(6px); }
            to { opacity: 1; transform: translateY(0); }
        }

        @media (max-width: 850px) {
            .container { grid-template-columns: 1fr; }
            .navbar { padding: 16px 20px; }
        }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-brand">
        <i class="fa-solid fa-car-side"></i>
        <span>מחשבון נהיגה</span>
    </div>
    <div class="nav-user">
        <span class="user-badge">
            <i class="fa-solid fa-circle-user"></i>
            <%= session.getAttribute("username") %>
        </span>
        <a href="${pageContext.request.contextPath}/logout" class="logout-btn">
            <i class="fa-solid fa-right-from-bracket"></i> התנתק
        </a>
    </div>
</div>

<div class="container">
    <div class="card">
        <h1 class="hero-title">חישוב תוקף מלווה ונהג צעיר</h1>
        <p class="hero-subtitle">הזן את תאריך מעבר הטסט לקבלת מועדי תום התקופות וספירה לאחור בזמן אמת:</p>

        <div class="form-container">
            <form method="post" action="home">
                <label class="form-label" for="test_date">
                    <i class="fa-regular fa-calendar-check" style="color: #4f46e5;"></i> תאריך מעבר מבחן מעשי (טסט):
                </label>
                <div class="input-row">
                    <input type="date" id="test_date" name="test_date" required
                           value="<%= request.getAttribute("testDate") != null ? request.getAttribute("testDate") : "" %>">
                    <button type="submit" class="btn-calc">
                        <i class="fa-solid fa-calculator"></i> חשב והוסף
                    </button>
                </div>
            </form>
        </div>

        <% if (request.getAttribute("dayEscortEnd") != null) { %>
            <div class="tabs-nav">
                <button class="tab-btn active" onclick="switchTab('day')">
                    <i class="fa-solid fa-sun"></i> מלווה יום ולילה
                </button>
                <button class="tab-btn" onclick="switchTab('night')">
                    <i class="fa-solid fa-moon"></i> מלווה לילה
                </button>
                <button class="tab-btn" onclick="switchTab('young')">
                    <i class="fa-solid fa-id-card"></i> נהג צעיר
                </button>
            </div>

            <div id="panel-day" class="result-card active">
                <div class="result-header">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>סיום תקופת מלווה יום ולילה (3 חודשים)</span>
                </div>
                <div class="result-date-display"><%= request.getAttribute("dayEscortEnd") %></div>
                <div class="time-badge">
                    <i class="fa-solid fa-clock"></i> <%= request.getAttribute("dayEscortRemaining") %>
                </div>
            </div>

            <div id="panel-night" class="result-card">
                <div class="result-header">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>סיום תקופת מלווה לילה בלבד (3 חודשים נוספים)</span>
                </div>
                <div class="result-date-display"><%= request.getAttribute("nightEscortEnd") %></div>
                <div class="time-badge">
                    <i class="fa-solid fa-clock"></i> <%= request.getAttribute("nightEscortRemaining") %>
                </div>
            </div>

            <div id="panel-young" class="result-card">
                <div class="result-header">
                    <i class="fa-solid fa-circle-check"></i>
                    <span>סיום תקופת נהג צעיר / חדש (שנתיים)</span>
                </div>
                <div class="result-date-display"><%= request.getAttribute("youngDriverEnd") %></div>
                <div class="time-badge">
                    <i class="fa-solid fa-clock"></i> <%= request.getAttribute("youngDriverRemaining") %>
                </div>
            </div>
        <% } %>
    </div>

    <!-- סרגל צד: היסטוריית בדיקות -->
    <div class="card">
        <h3 class="sidebar-title">
            <i class="fa-solid fa-clock-rotate-left" style="color: #4f46e5;"></i> 10 בדיקות אחרונות
        </h3>
        <ul class="history-list">
            <%
                List<Map<String, String>> history = (List<Map<String, String>>) request.getAttribute("history");
                if (history != null && !history.isEmpty()) {
                    for (Map<String, String> item : history) {
            %>
                <li class="history-item">
                    <span class="history-date">
                        <i class="fa-regular fa-calendar" style="margin-left: 6px; color: #94a3b8;"></i>
                        <%= item.get("testDate") %>
                    </span>
                    <span class="history-time-badge"><%= item.get("timeAgo") %></span>
                </li>
            <%
                    }
                } else {
            %>
                <li class="history-item" style="color: var(--text-muted); justify-content: center;">
                    טרם בוצעו בדיקות במערכת
                </li>
            <% } %>
        </ul>
    </div>
</div>

<script>
    function switchTab(tab) {
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        document.querySelectorAll('.result-card').forEach(p => p.classList.remove('active'));

        if (tab === 'day') {
            document.querySelectorAll('.tab-btn')[0].classList.add('active');
            document.getElementById('panel-day').classList.add('active');
        } else if (tab === 'night') {
            document.querySelectorAll('.tab-btn')[1].classList.add('active');
            document.getElementById('panel-night').classList.add('active');
        } else if (tab === 'young') {
            document.querySelectorAll('.tab-btn')[2].classList.add('active');
            document.getElementById('panel-young').classList.add('active');
        }
    }
</script>

</body>
</html>