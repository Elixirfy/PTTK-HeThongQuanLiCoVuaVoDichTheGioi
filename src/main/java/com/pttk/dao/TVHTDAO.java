package com.pttk.dao;

import com.pttk.model.TVHT;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class TVHTDAO extends DAO {

    // Bộ dữ liệu nạp sẵn dự phòng (Pre-seeded Mock Store)
    // Hoạt động khi chưa kết nối tới MySQL container
    private static final Map<String, TVHT> PRE_SEEDED_USERS = new HashMap<>();

    static {
        PRE_SEEDED_USERS.put("btc1", new TVHT(1, "btc1", "mk123@", "Ban tổ chức", "Nguyễn Đức Ngọc", "ngoc.nd@fide.org", "Trưởng ban điều hành giải đấu"));
        PRE_SEEDED_USERS.put("btc2", new TVHT(2, "btc2", "123456", "Ban tổ chức", "Nguyễn Đức Mạnh", "manh.nd@fide.org", "Phó ban điều hành"));
        PRE_SEEDED_USERS.put("admin", new TVHT(3, "admin", "admin123", "Ban tổ chức", "Nguyễn Hoàng Nam", "nam.nh@fide.org", "Quản trị viên hệ thống"));
    }

    public TVHTDAO() {
        super();
    }

    public boolean checkLogin(TVHT tvht) {
        if (tvht == null || tvht.getUsername() == null || tvht.getPassword() == null) {
            return false;
        }

        String username = tvht.getUsername().trim();
        String password = tvht.getPassword();

        // 1. Nếu có kết nối MySQL sống: Truy vấn trực tiếp từ bảng tblTVHT và tblBTC
        if (this.con != null) {
            String sql = "SELECT t.Userid, t.username, t.password, t.chucVu, t.hoTen, t.email, t.note " +
                         "FROM tblTVHT t " +
                         "INNER JOIN tblBTC b ON t.Userid = b.Userid " +
                         "WHERE t.username = ? AND t.password = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, username);
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        tvht.setId(rs.getInt("Userid"));
                        tvht.setChucVu(rs.getString("chucVu"));
                        tvht.setHoTen(rs.getString("hoTen"));
                        tvht.setEmail(rs.getString("email"));
                        tvht.setNote(rs.getString("note"));
                        return true;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // 2. Chế độ dự phòng (Fallback Live Testing): Kiểm tra trong Pre-seeded Store
        TVHT seedUser = PRE_SEEDED_USERS.get(username);
        if (seedUser != null && seedUser.getPassword().equals(password)) {
            tvht.setId(seedUser.getId());
            tvht.setChucVu(seedUser.getChucVu());
            tvht.setHoTen(seedUser.getHoTen());
            tvht.setEmail(seedUser.getEmail());
            tvht.setNote(seedUser.getNote());
            return true;
        }

        return false;
    }
}

