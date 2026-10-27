package com.name.app;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // הפניה לדף התצוגה של ההתחברות
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8"); // לטיפול בעברית

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        // קריאה לפונקציה שבודקת במסד הנתונים האם המשתמש והסיסמה תואמים
        boolean isValidUser = DatabaseController.validateUser(username, password);

        if (isValidUser) {
            HttpSession session = request.getSession();
            session.setAttribute("username", username);
            response.sendRedirect(request.getContextPath() + "/home");
        } else {
            request.setAttribute("error", "שם משתמש או סיסמה שגויים");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}