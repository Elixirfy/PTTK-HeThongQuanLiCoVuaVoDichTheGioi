package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {
    protected Connection con;
    protected boolean isLiveMySQL = false;

    private static final String DB_URL = "jdbc:mysql://localhost:3306/db_covua?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh&allowPublicKeyRetrieval=true&useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "root123";

    public DAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            this.con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
            this.isLiveMySQL = true;
        } catch (Exception e) {
            // Khi chưa bật container MySQL Docker, hệ thống chuyển sang chế độ dự phòng
            // nạp sẵn dữ liệu (Mock/In-Memory) để người dùng có thể test live ngay lập tức
            this.con = null;
            this.isLiveMySQL = false;
        }
    }

    public boolean isConnectedToMySQL() {
        return this.isLiveMySQL && this.con != null;
    }
}

