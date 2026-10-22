package com.name.app;

import com.name.app.db.DatabaseManager;

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

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = (String) session.getAttribute("username");

        try (Connection conn = DatabaseManager.getConnection()) {
            String sql = "SELECT test_date FROM driving_checks WHERE username = ? ORDER BY check_time DESC LIMIT 1";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                LocalDate testDate = rs.getDate("test_date").toLocalDate();
                calculateAndSetAttributes(request, testDate);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        loadHistory(request, username);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String username = (String) session.getAttribute("username");
        String testDateStr = request.getParameter("test_date");

        if (testDateStr != null && !testDateStr.trim().isEmpty()) {
            try {
                LocalDate testDate = LocalDate.parse(testDateStr);

                if (testDate.isAfter(LocalDate.now())) {
                    request.setAttribute("error", "תאריך מעבר הטסט אינו יכול להיות תאריך עתידי.");
                } else {
                    try (Connection conn = DatabaseManager.getConnection()) {
                        String insertSql = "INSERT INTO driving_checks (username, test_date) VALUES (?, ?)";
                        PreparedStatement ps = conn.prepareStatement(insertSql);
                        ps.setString(1, username);
                        ps.setDate(2, Date.valueOf(testDate));
                        ps.executeUpdate();
                    }

                    calculateAndSetAttributes(request, testDate);
                }
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "פורמט תאריך לא תקין.");
            }
        }

        loadHistory(request, username);
        request.getRequestDispatcher("/WEB-INF/views/home.jsp").forward(request, response);
    }

    private void calculateAndSetAttributes(HttpServletRequest request, LocalDate testDate) {
        LocalDate today = LocalDate.now();

        LocalDate dayEscortEnd = testDate.plusMonths(3);
        LocalDate nightEscortEnd = testDate.plusMonths(6);
        LocalDate youngDriverEnd = testDate.plusYears(2);

        request.setAttribute("testDate", testDate);

        request.setAttribute("dayEscortEnd", dayEscortEnd);
        request.setAttribute("dayEscortRemaining", formatRemainingTime(today, dayEscortEnd));

        request.setAttribute("nightEscortEnd", nightEscortEnd);
        request.setAttribute("nightEscortRemaining", formatRemainingTime(today, nightEscortEnd));

        request.setAttribute("youngDriverEnd", youngDriverEnd);
        request.setAttribute("youngDriverRemaining", formatRemainingTime(today, youngDriverEnd));
    }

    private String formatRemainingTime(LocalDate today, LocalDate targetDate) {
        if (!today.isBefore(targetDate)) {
            return "הסתיימה התקופה 🎉";
        }

        Period period = Period.between(today, targetDate);
        long totalDays = ChronoUnit.DAYS.between(today, targetDate);

        if (totalDays <= 30) {
            return "נותרו עוד " + totalDays + " ימים";
        }

        StringBuilder sb = new StringBuilder("נותרו עוד ");
        if (period.getYears() > 0) {
            sb.append(period.getYears()).append(" שנים ");
        }
        if (period.getMonths() > 0) {
            if (period.getYears() > 0) sb.append("ו-");
            sb.append(period.getMonths()).append(" חודשים ");
        }
        if (period.getDays() > 0) {
            sb.append("ו-").append(period.getDays()).append(" ימים");
        }

        return sb.toString().trim();
    }

    private void loadHistory(HttpServletRequest request, String username) {
        List<Map<String, String>> history = new ArrayList<>();
        try (Connection conn = DatabaseManager.getConnection()) {
            String sql = "SELECT test_date, check_time FROM driving_checks " +
                    "WHERE username = ? ORDER BY check_time DESC LIMIT 10";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Map<String, String> item = new HashMap<>();
                Date testDate = rs.getDate("test_date");
                Timestamp checkTime = rs.getTimestamp("check_time");

                item.put("testDate", testDate.toString());
                item.put("timeAgo", formatTimeAgo(checkTime.toLocalDateTime()));
                history.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        request.setAttribute("history", history);
    }

    private String formatTimeAgo(LocalDateTime checkTime) {
        LocalDateTime now = LocalDateTime.now();
        long minutes = ChronoUnit.MINUTES.between(checkTime, now);
        if (minutes < 1) return "ממש עכשיו";
        if (minutes < 60) return "לפני " + minutes + " דק'";
        long hours = ChronoUnit.HOURS.between(checkTime, now);
        if (hours < 24) return "לפני " + hours + " שעות";
        long days = ChronoUnit.DAYS.between(checkTime, now);
        return "לפני " + days + " ימים";
    }
}