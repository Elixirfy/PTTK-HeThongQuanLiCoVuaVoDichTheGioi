package com.pttk.dao;

import com.pttk.model.GiaiDau;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GiaiDauDAO extends DAO {

    // Bộ nhớ dự phòng nạp sẵn khớp 100% với file init_database.sql
    private static final List<GiaiDau> PRE_SEEDED_GIAI_DAU = new ArrayList<>();

    static {
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(4, 2024, "Classical", 1, "Geneva, Thụy Sĩ", "Kết thúc", "Giải đấu vòng loại số 1 quốc tế", Date.valueOf("2024-05-01"), Date.valueOf("2024-05-15")));
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(5, 2024, "Classical", 2, "Geneva, Thụy Sĩ", "Kết thúc", "Giải đấu đầu tiên trong 20 năm không do Carlsen vô địch", Date.valueOf("2024-09-10"), Date.valueOf("2024-09-25")));
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(6, 2024, "Rapid & Blitz", 1, "Geneva, Thụy Sĩ", "Kết thúc", "Giải cờ nhanh & cờ chớp", Date.valueOf("2024-12-01"), Date.valueOf("2024-12-10")));
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(10, 2026, "Classical", 1, "Geneva, Thụy Sĩ", "Kết thúc", "Giải mở màn mùa giải 2026", Date.valueOf("2026-03-01"), Date.valueOf("2026-03-15")));
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(11, 2026, "Rapid & Blitz", 1, "Geneva, Thụy Sĩ", "Kết thúc", "Giải cờ nhanh châu Âu", Date.valueOf("2026-06-05"), Date.valueOf("2026-06-12")));
        PRE_SEEDED_GIAI_DAU.add(new GiaiDau(12, 2026, "Classical", 2, "Hà Nội, Việt Nam", "Đang diễn ra", "Lần đầu tiên giải vô địch cờ vua thế giới tổ chức ở Việt Nam", Date.valueOf("2026-09-10"), Date.valueOf("2026-09-30")));
    }

    public GiaiDauDAO() {
        super();
    }

    public ArrayList<GiaiDau> searchGiaiDauBTC(int nam) {
        ArrayList<GiaiDau> result = new ArrayList<>();

        if (this.con != null) {
            String sql = "SELECT * FROM tblGiaiDau WHERE nam = ? ORDER BY muaGiai ASC, id ASC";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, nam);
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        GiaiDau gd = new GiaiDau();
                        gd.setId(rs.getInt("id"));
                        gd.setNam(rs.getInt("nam"));
                        gd.setVariant(rs.getString("variant"));
                        gd.setMuaGiai(rs.getInt("muaGiai"));
                        gd.setDiaDiem(rs.getString("diaDiem"));
                        gd.setTrangThai(rs.getString("trangThai"));
                        gd.setNote(rs.getString("note"));
                        gd.setNgayBatDau(rs.getDate("ngayBatDau"));
                        gd.setNgayKetThuc(rs.getDate("ngayKetThuc"));
                        result.add(gd);
                    }
                    return result;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        // Chế độ dự phòng khi chưa bật MySQL Docker
        for (GiaiDau gd : PRE_SEEDED_GIAI_DAU) {
            if (gd.getNam() == nam) {
                result.add(gd);
            }
        }
        return result;
    }

    public GiaiDau getGiaiDauById(int id) {
        if (this.con != null) {
            String sql = "SELECT * FROM tblGiaiDau WHERE id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        GiaiDau gd = new GiaiDau();
                        gd.setId(rs.getInt("id"));
                        gd.setNam(rs.getInt("nam"));
                        gd.setVariant(rs.getString("variant"));
                        gd.setMuaGiai(rs.getInt("muaGiai"));
                        gd.setDiaDiem(rs.getString("diaDiem"));
                        gd.setTrangThai(rs.getString("trangThai"));
                        gd.setNote(rs.getString("note"));
                        gd.setNgayBatDau(rs.getDate("ngayBatDau"));
                        gd.setNgayKetThuc(rs.getDate("ngayKetThuc"));
                        return gd;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        for (GiaiDau gd : PRE_SEEDED_GIAI_DAU) {
            if (gd.getId() == id) {
                return gd;
            }
        }
        return null;
    }

    public boolean updateGiaiDau(GiaiDau gd) {
        if (gd == null) return false;

        if (this.con != null) {
            String sql = "UPDATE tblGiaiDau SET nam=?, variant=?, muaGiai=?, diaDiem=?, note=?, ngayBatDau=?, ngayKetThuc=? WHERE id=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, gd.getNam());
                ps.setString(2, gd.getVariant());
                ps.setInt(3, gd.getMuaGiai());
                ps.setString(4, gd.getDiaDiem());
                ps.setString(5, gd.getNote());
                ps.setDate(6, gd.getNgayBatDau());
                ps.setDate(7, gd.getNgayKetThuc());
                ps.setInt(8, gd.getId());
                return ps.executeUpdate() > 0;
            } catch (Exception e) {
                e.printStackTrace();
                return false;
            }
        }

        // Chế độ dự phòng
        for (int i = 0; i < PRE_SEEDED_GIAI_DAU.size(); i++) {
            if (PRE_SEEDED_GIAI_DAU.get(i).getId() == gd.getId()) {
                PRE_SEEDED_GIAI_DAU.set(i, gd);
                return true;
            }
        }
        return false;
    }
}

