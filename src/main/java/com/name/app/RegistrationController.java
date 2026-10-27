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
import java.time.LocalDate;

@WebServlet("/register")
public class RegistrationController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String birthDateStr = request.getParameter("birth_date");

        if (username == null || password == null || birthDateStr == null ||
                username.trim().isEmpty() || password.trim().isEmpty() || birthDateStr.trim().isEmpty()) {
            request.setAttribute("error", "כל השדות הינם חובה.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        LocalDate birthDate = LocalDate.parse(birthDateStr);
        if (birthDate.isAfter(LocalDate.now())) {
            request.setAttribute("error", "תאריך הלידה אינו יכול להיות עתידי.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
            return;
        }

        try (Connection conn = DatabaseController.getConnection()) {
            String sql = "INSERT INTO users (username, password, birth_date) VALUES (?, ?, ?)";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, username.trim());
            ps.setString(2, password);
            ps.setDate(3, Date.valueOf(birthDate));
            ps.executeUpdate();

            // התחברות אוטומטית לאחר הרשמה
            HttpSession session = request.getSession();
            session.setAttribute("username", username.trim());
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            request.setAttribute("error", "שם המשתמש כבר תפוס, בחר שם אחר.");
            request.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(request, response);
        }
    }
}