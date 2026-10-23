package com.name.app;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/*")
public class SecurityFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // בדיקה אם קיים יוזר מחובר
        boolean isLoggedIn = (session != null && session.getAttribute("username") != null);

        // הגדרת נתיבים שמותר לגשת אליהם גם בלי חיבור
        boolean isPublicPath = path.endsWith("/login") ||
                path.endsWith("/register") ||
                path.matches(".*(css|js|jpg|png)");

        if (isLoggedIn || isPublicPath) {
            chain.doFilter(request, response); // המשך רגיל
        } else {
            res.sendRedirect(req.getContextPath() + "/login"); // זריקה להתחברות
        }
    }
}