package com.name.app;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.*;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/results")
public class CalculationController extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = (String) session.getAttribute("username");
        String testDateStr = request.getParameter("test_date");
        String type = request.getParameter("type");

        if (testDateStr == null || testDateStr.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/home");
            return;
        }

        LocalDate testDate = LocalDate.parse(testDateStr);
        LocalDate today = LocalDate.now();

        boolean isOver24 = false;
        try (Connection conn = DatabaseController.getConnection()) {
            String userSql = "SELECT birth_date FROM users WHERE username = ?";
            PreparedStatement userPs = conn.prepareStatement(userSql);
            userPs.setString(1, username);
            ResultSet userRs = userPs.executeQuery();
            if (userRs.next()) {
                Date bDate = userRs.getDate("birth_date");
                if (bDate != null) {
                    int age = Period.between(bDate.toLocalDate(), today).getYears();
                    if (age >= 24) {
                        isOver24 = true;
                    }
                }
            }

            String insertSql = "INSERT INTO driving_checks (username, test_date) VALUES (?, ?)";
            PreparedStatement ps = conn.prepareStatement(insertSql);
            ps.setString(1, username);
            ps.setDate(2, Date.valueOf(testDate));
            ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }

        LocalDate targetDate;
        String title;

        if ("day".equals(type)) {
            targetDate = testDate.plusMonths(3);
            title = "תקופת מלווה יום";
        } else if ("night".equals(type)) {
            targetDate = testDate.plusMonths(6);
            title = "תקופת מלווה לילה בלבד";
        } else {
            targetDate = testDate.plusYears(2);
            title = "תקופת נהג חדש";
        }

        request.setAttribute("title", title);
        request.setAttribute("testDate", testDateStr);
        request.setAttribute("targetDate", targetDate.toString());

        boolean isPeriodEnded = !today.isBefore(targetDate);

        if (!"young".equals(type)) {
            if (isPeriodEnded) {
                request.setAttribute("statusMessage", "תקופת המלווה הסתיימה - אין צורך במלווה כלל 🎉");
                request.setAttribute("badgeText", "אין צורך במלווה");
                request.setAttribute("isSpecialStatus", true);
            } else if (isOver24) {
                request.setAttribute("statusMessage", "אין צורך במלווה! נהגים מעל גיל 24 פטורים ממלווה.");
                request.setAttribute("badgeText", "אין צורך במלווה");
                request.setAttribute("isSpecialStatus", true);
            } else {
                request.setAttribute("remainingText", formatRemainingTime(today, targetDate));
                request.setAttribute("isSpecialStatus", false);
            }
        } else {
            if (isPeriodEnded) {
                request.setAttribute("statusMessage", "תקופת נהג חדש הסתיימה 🎉");
                request.setAttribute("badgeText", "תקופת נהג חדש הסתיימה");
                request.setAttribute("isSpecialStatus", true);
            } else {
                request.setAttribute("remainingText", formatRemainingTime(today, targetDate));
                request.setAttribute("isSpecialStatus", false);
            }
        }

        loadHistory(request, username);
        request.getRequestDispatcher("/WEB-INF/views/calculation.jsp").forward(request, response);
    }

    private String formatRemainingTime(LocalDate today, LocalDate targetDate) {
        Period period = Period.between(today, targetDate);
        long totalDays = ChronoUnit.DAYS.between(today, targetDate);

        if (totalDays <= 30) {
            return "נותרו עוד " + totalDays + " ימים";
        }

        StringBuilder sb = new StringBuilder("נותרו עוד ");
        if (period.getYears() > 0) sb.append(period.getYears()).append(" שנים ");
        if (period.getMonths() > 0) {
            if (period.getYears() > 0) sb.append("ו-");
            sb.append(period.getMonths()).append(" חודשים ");
        }
        if (period.getDays() > 0) sb.append("ו-").append(period.getDays()).append(" ימים");

        return sb.toString().trim();
    }

    private void loadHistory(HttpServletRequest request, String username) {
        List<Map<String, String>> history = new ArrayList<>();
        try (Connection conn = DatabaseController.getConnection()) {
            String sql = "SELECT test_date, check_time FROM driving_checks WHERE username = ? ORDER BY check_time DESC LIMIT 10";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> item = new HashMap<>();
                item.put("testDate", rs.getDate("test_date").toString());
                item.put("timeAgo", formatTimeAgo(rs.getTimestamp("check_time").toLocalDateTime()));
                history.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("history", history);
    }

    private String formatTimeAgo(LocalDateTime checkTime) {
        long minutes = ChronoUnit.MINUTES.between(checkTime, LocalDateTime.now());
        if (minutes < 1) return "ממש עכשיו";
        if (minutes < 60) return "לפני " + minutes + " דק'";
        long hours = ChronoUnit.HOURS.between(checkTime, LocalDateTime.now());
        if (hours < 24) return "לפני " + hours + " שעות";
        return "לפני " + ChronoUnit.DAYS.between(checkTime, LocalDateTime.now()) + " ימים";
    }
}