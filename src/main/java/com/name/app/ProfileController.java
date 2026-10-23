package com.name.app;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {

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
            String sql = "SELECT username, password, birth_date FROM users WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                request.setAttribute("usernameVal", rs.getString("username"));
                request.setAttribute("passwordVal", rs.getString("password"));
                request.setAttribute("birthDateVal", rs.getDate("birth_date").toString());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        request.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String oldUsername = (String) session.getAttribute("username");
        String newUsername = request.getParameter("username");
        String newPassword = request.getParameter("password");
        String birthDateStr = request.getParameter("birth_date");

        if (newUsername == null || newPassword == null || birthDateStr == null ||
                newUsername.trim().isEmpty() || newPassword.trim().isEmpty() || birthDateStr.trim().isEmpty()) {
            request.setAttribute("error", "כל השדות הינם חובה.");
            doGet(request, response);
            return;
        }

        try (Connection conn = DatabaseManager.getConnection()) {
            String sql = "UPDATE users SET username = ?, password = ?, birth_date = ? WHERE username = ?";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newUsername.trim());
            ps.setString(2, newPassword);
            ps.setDate(3, Date.valueOf(LocalDate.parse(birthDateStr)));
            ps.setString(4, oldUsername);
            ps.executeUpdate();

            // עדכון הסשן בשם המשתמש החדש
            session.setAttribute("username", newUsername.trim());
            request.setAttribute("success", "הפרטים עודכנו בהצלחה!");

        } catch (Exception e) {
            request.setAttribute("error", "לא ניתן לעדכן (ייתכן ששם המשתמש כבר תפוס).");
        }

        doGet(request, response);
    }
}