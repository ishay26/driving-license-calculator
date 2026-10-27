package com.name.app;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.sql.Connection;
import java.sql.Statement;

@WebListener
public class AppInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        try (Connection conn = DatabaseController.getConnection();
             Statement stmt = conn.createStatement()) {

            // יצירת טבלת משתמשים הכוללת תאריך לידה
            stmt.execute("CREATE TABLE IF NOT EXISTS users (" +
                    "username VARCHAR(50) PRIMARY KEY, " +
                    "password VARCHAR(100) NOT NULL, " +
                    "birth_date DATE NOT NULL)");

            // הוספת עמודה במידה והטבלה כבר הייתה קיימת ללא תאריך לידה
            try {
                stmt.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS birth_date DATE DEFAULT '2000-01-01'");
            } catch (Exception ignored) {}

            // טבלת היסטוריית בדיקות
            stmt.execute("CREATE TABLE IF NOT EXISTS driving_checks (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "username VARCHAR(50), " +
                    "test_date DATE NOT NULL, " +
                    "check_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP, " +
                    "FOREIGN KEY (username) REFERENCES users(username) ON DELETE CASCADE ON UPDATE CASCADE)");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {}
}