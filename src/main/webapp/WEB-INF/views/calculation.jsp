<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="he" dir="rtl">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>תוצאות בדיקה - מחשבון נהיגה</title>
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
            box-shadow: 0 4px 10px rgba(245, 158, 11, 0.3);
        }

        .container {
            max-width: 1050px;
            margin: 40px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 1fr 340px;
            gap: 28px;
        }

        .card-box {
            background: var(--card-bg);
            border-radius: 24px;
            padding: 32px;
            border: 1px solid var(--border-gold);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.5);
        }

        .result-panel {
            background: #27272a;
            border: 1px solid #3f3f46;
            border-radius: 18px;
            padding: 26px;
            margin-bottom: 24px;
        }

        .special-panel {
            background: rgba(245, 158, 11, 0.08);
            border: 1px solid var(--border-gold);
            border-radius: 18px;
            padding: 26px;
            margin-bottom: 24px;
        }

        .result-title {
            font-weight: 800;
            font-size: 18px;
            color: var(--gold-light);
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .date-text {
            font-size: 36px;
            font-weight: 900;
            color: #ffffff;
            margin-bottom: 16px;
        }

        .gold-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--gold-grad);
            color: #09090b;
            padding: 10px 20px;
            border-radius: 20px;
            font-weight: 800;
            font-size: 14px;
            box-shadow: 0 4px 12px rgba(245, 158, 11, 0.25);
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--gold-grad);
            color: #09090b;
            text-decoration: none;
            padding: 12px 22px;
            border-radius: 12px;
            font-weight: 800;
            font-size: 14px;
            transition: all 0.2s;
        }

        .btn-back:hover { transform: translateY(-2px); box-shadow: 0 6px 16px rgba(245, 158, 11, 0.35); }

        .history-list { list-style: none; padding: 0; margin: 0; }
        .history-item {
            background: #27272a;
            border: 1px solid #3f3f46;
            border-radius: 12px;
            padding: 12px 16px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .history-date { font-weight: 700; font-size: 14px; color: #f4f4f5; }
        .history-tag { font-size: 12px; font-weight: 800; color: #fef08a; background: rgba(245, 158, 11, 0.15); padding: 4px 10px; border-radius: 20px; border: 1px solid rgba(245, 158, 11, 0.3); }

        @media (max-width: 800px) { .container { grid-template-columns: 1fr; } }
    </style>
</head>
<body>

<div class="navbar">
    <div class="nav-brand">
        <div class="mini-car-icon">
            <i class="fa-solid fa-car-side"></i>
        </div>
        <span>מחשבון נהיגה - תוצאות</span>
    </div>
    <a href="${pageContext.request.contextPath}/home?test_date=${testDate}" class="btn-back">
        <i class="fa-solid fa-arrow-right"></i> בדיקה חדשה
    </a>
</div>

<div class="container">
    <div class="card-box">
        <h2 style="margin-top:0; color: var(--gold-light);">תוצאת הבדיקה</h2>
        <p style="color: #a1a1aa; font-size: 14px; margin-bottom: 24px;">
            תאריך טסט שנבדק: <strong><%= request.getAttribute("testDate") %></strong>
        </p>

        <% Boolean isSpecialStatus = (Boolean) request.getAttribute("isSpecialStatus"); %>
        <% if (isSpecialStatus != null && isSpecialStatus) { %>
            <div class="special-panel">
                <div class="result-title"><i class="fa-solid fa-shield-halved"></i> <%= request.getAttribute("title") %></div>
                <div style="font-size: 17px; font-weight: 700; margin-bottom: 18px; line-height: 1.5; color: #f4f4f5;">
                    <%= request.getAttribute("statusMessage") %>
                </div>
                <div class="gold-badge">
                    <i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("badgeText") %>
                </div>
            </div>
        <% } else { %>
            <div class="result-panel">
                <div class="result-title"><i class="fa-solid fa-circle-check"></i> <%= request.getAttribute("title") %></div>
                <div class="date-text"><%= request.getAttribute("targetDate") %></div>
                <div class="gold-badge">
                    <i class="fa-solid fa-clock"></i> <%= request.getAttribute("remainingText") %>
                </div>
            </div>
        <% } %>

        <a href="${pageContext.request.contextPath}/home?test_date=${testDate}" class="btn-back">
            <i class="fa-solid fa-rotate-left"></i> חזור לבדיקה נוספת
        </a>
    </div>

    <div class="card-box">
        <h3 style="margin-top:0; font-size: 17px; color: var(--gold-light);"><i class="fa-solid fa-clock-rotate-left" style="margin-left: 6px;"></i> 10 בדיקות אחרונות</h3>
        <ul class="history-list">
            <%
                List<Map<String, String>> history = (List<Map<String, String>>) request.getAttribute("history");
                if (history != null && !history.isEmpty()) {
                    for (Map<String, String> item : history) {
            %>
                <li class="history-item">
                    <span class="history-date"><%= item.get("testDate") %></span>
                    <span class="history-tag"><%= item.get("timeAgo") %></span>
                </li>
            <%
                    }
                } else {
            %>
                <li class="history-item" style="color: #a1a1aa;">אין בדיקות קודמות.</li>
            <% } %>
        </ul>
    </div>
</div>

</body>
</html>