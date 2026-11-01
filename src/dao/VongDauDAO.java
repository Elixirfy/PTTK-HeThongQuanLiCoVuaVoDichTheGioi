package dao;

import model.GiaiDau;
import model.VongDau;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;

public class VongDauDAO extends DAO {

    // Kho dữ liệu dự phòng chuẩn bị sẵn phục vụ kiểm thử (Khớp 100% CSDL MySQL)
    private static final ArrayList<VongDau> MOCK_VONG_DAU = new ArrayList<>();

    static {
        GiaiDau gd12 = new GiaiDau(12, 2026, "Classical", 2, "Hà Nội, Việt Nam", "Đang diễn ra",
                "Lần đầu tiên giải vô địch cờ vua thế giới tổ chức ở Việt Nam",
                Date.valueOf("2026-09-10"), Date.valueOf("2026-09-30"));

        MOCK_VONG_DAU.add(new VongDau(101, 1, Date.valueOf("2026-09-11"), "Kết thúc", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12));
        MOCK_VONG_DAU.add(new VongDau(102, 2, Date.valueOf("2026-09-12"), "Kết thúc", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12));
        MOCK_VONG_DAU.add(new VongDau(103, 3, Date.valueOf("2026-09-13"), "Kết thúc", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12));
        MOCK_VONG_DAU.add(new VongDau(104, 4, Date.valueOf("2026-09-15"), "Kết thúc", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12));
        MOCK_VONG_DAU.add(new VongDau(105, 5, Date.valueOf("2026-09-16"), "Đang diễn ra", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12)); // Cho phép nhập kết quả
        MOCK_VONG_DAU.add(new VongDau(106, 6, Date.valueOf("2026-09-17"), "Chưa bắt đầu", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12)); // Để test biên chặn lỗi
        MOCK_VONG_DAU.add(new VongDau(107, 7, Date.valueOf("2026-09-19"), "Chưa bắt đầu", Time.valueOf("10:30:00"), Time.valueOf("18:00:00"), gd12));
    }

    public VongDauDAO() {
        super();
    }

    /**
     * Lấy danh sách vòng đấu của giải đấu theo idGiaiDau
     */
    public ArrayList<VongDau> getVongDauCuaBTC(int idGiaiDau) {
        ArrayList<VongDau> result = new ArrayList<>();

        if (isConnectedToMySQL()) {
            String sql = "SELECT * FROM tblVongDau WHERE GiaiDauid = ? ORDER BY soVong ASC";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, idGiaiDau);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        VongDau vd = new VongDau();
                        vd.setId(rs.getInt("id"));
                        vd.setSoVong(rs.getInt("soVong"));
                        vd.setNgayThiDau(rs.getDate("ngayThiDau"));
                        vd.setTrangThai(rs.getString("trangThai"));
                        vd.setThoiGianBatDau(rs.getTime("thoiGianBatDau"));
                        vd.setThoiGianKetThuc(rs.getTime("thoiGianKetThuc"));
                        result.add(vd);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Mock Fallback
            for (VongDau vd : MOCK_VONG_DAU) {
                if (vd.getGiaiDau() != null && vd.getGiaiDau().getId() == idGiaiDau) {
                    result.add(vd);
                }
            }
        }

        return result;
    }

    /**
     * Lấy thông tin chi tiết một vòng đấu theo id
     */
    public VongDau getVongDauById(int idVongDau) {
        if (isConnectedToMySQL()) {
            String sql = "SELECT * FROM tblVongDau WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, idVongDau);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        VongDau vd = new VongDau();
                        vd.setId(rs.getInt("id"));
                        vd.setSoVong(rs.getInt("soVong"));
                        vd.setNgayThiDau(rs.getDate("ngayThiDau"));
                        vd.setTrangThai(rs.getString("trangThai"));
                        vd.setThoiGianBatDau(rs.getTime("thoiGianBatDau"));
                        vd.setThoiGianKetThuc(rs.getTime("thoiGianKetThuc"));
                        return vd;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            for (VongDau vd : MOCK_VONG_DAU) {
                if (vd.getId() == idVongDau) {
                    return vd;
                }
            }
        }
        return null;
    }
}

