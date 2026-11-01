package com.pttk.dao;

import com.pttk.model.KyThuThamGiaTranDau;
import com.pttk.model.TranDau;

import java.sql.PreparedStatement;

public class KyThuThamGiaTranDauDAO extends DAO {

    public KyThuThamGiaTranDauDAO() {
        super();
    }

    /**
     * Cập nhật điểm trận, tính biến động Elo và lưu vào CSDL
     */
    public boolean addKetQua(KyThuThamGiaTranDau[] kq) {
        if (kq == null || kq.length < 2) {
            return false;
        }

        KyThuThamGiaTranDau p1 = kq[0];
        KyThuThamGiaTranDau p2 = kq[1];

        // 1. Kiểm tra tính hợp lệ của cặp điểm FIDE (1-0, 0.5-0.5, 0-1)
        if (p1.getKetQuaDiem() == null || p2.getKetQuaDiem() == null) {
            return false;
        }
        float s1 = p1.getKetQuaDiem();
        float s2 = p2.getKetQuaDiem();
        if (Math.abs((s1 + s2) - 1.0f) > 0.001f) {
            return false; // Tổng điểm không bằng 1.0 (ví dụ 1-1 hoặc 0-0 là sai)
        }

        // 2. Tính toán biến động Elo theo công thức FIDE: Delta ELO = K * (S - E)
        int k1 = (p1.getKyThu() != null && p1.getKyThu().getHeSoThang() > 0) ? p1.getKyThu().getHeSoThang() : 10;
        int k2 = (p2.getKyThu() != null && p2.getKyThu().getHeSoThang() > 0) ? p2.getKyThu().getHeSoThang() : 10;

        float deltaElo1 = k1 * (s1 - p1.getKiVongThang());
        float deltaElo2 = k2 * (s2 - p2.getKiVongThang());

        p1.setEloTang(deltaElo1);
        p2.setEloTang(deltaElo2);

        if (isConnectedToMySQL()) {
            try {
                con.setAutoCommit(false);

                // Cập nhật kết quả cho từng kỳ thủ trong bảng tblKyThuThamGiaTranDau
                String sqlUpdateKQ = "UPDATE tblKyThuThamGiaTranDau SET ketQuaDiem = ?, eloTang = ? WHERE id = ?";
                try (PreparedStatement psKQ = con.prepareStatement(sqlUpdateKQ)) {
                    psKQ.setFloat(1, s1);
                    psKQ.setFloat(2, deltaElo1);
                    psKQ.setInt(3, p1.getId());
                    psKQ.executeUpdate();

                    psKQ.setFloat(1, s2);
                    psKQ.setFloat(2, deltaElo2);
                    psKQ.setInt(3, p2.getId());
                    psKQ.executeUpdate();
                }

                // Cập nhật điểm Elo mới trong bảng tblKyThu (kiểu FLOAT)
                String sqlUpdateElo = "UPDATE tblKyThu SET ELO = ELO + ? WHERE Userid = ?";
                try (PreparedStatement psElo = con.prepareStatement(sqlUpdateElo)) {
                    psElo.setFloat(1, deltaElo1);
                    psElo.setInt(2, p1.getKyThu().getId());
                    psElo.executeUpdate();

                    psElo.setFloat(1, deltaElo2);
                    psElo.setInt(2, p2.getKyThu().getId());
                    psElo.executeUpdate();
                }

                // Cập nhật trạng thái trận đấu thành "Kết thúc"
                if (p1.getTranDau() != null) {
                    String sqlUpdateTD = "UPDATE tblTranDau SET trangThai = 'Kết thúc' WHERE id = ?";
                    try (PreparedStatement psTD = con.prepareStatement(sqlUpdateTD)) {
                        psTD.setInt(1, p1.getTranDau().getId());
                        psTD.executeUpdate();
                    }
                }

                con.commit();
                con.setAutoCommit(true);
                return true;
            } catch (Exception e) {
                try {
                    con.rollback();
                    con.setAutoCommit(true);
                } catch (Exception ex) {
                    ex.printStackTrace();
                }
                e.printStackTrace();
                return false;
            }
        } else {
            // Mock Update
            TranDauDAO tdDAO = new TranDauDAO();
            if (p1.getTranDau() != null) {
                TranDau td = tdDAO.getChiTietTranDau(p1.getTranDau().getId());
                if (td != null) {
                    td.setTrangThai("Kết thúc");
                    if (td.getDanhSachKyThu() != null && td.getDanhSachKyThu().length >= 2) {
                        td.getDanhSachKyThu()[0].setKetQuaDiem(s1);
                        td.getDanhSachKyThu()[0].setEloTang(deltaElo1);
                        td.getDanhSachKyThu()[1].setKetQuaDiem(s2);
                        td.getDanhSachKyThu()[1].setEloTang(deltaElo2);

                        if (td.getDanhSachKyThu()[0].getKyThu() != null) {
                            td.getDanhSachKyThu()[0].getKyThu().setELO(td.getDanhSachKyThu()[0].getKyThu().getELO() + deltaElo1);
                        }
                        if (td.getDanhSachKyThu()[1].getKyThu() != null) {
                            td.getDanhSachKyThu()[1].getKyThu().setELO(td.getDanhSachKyThu()[1].getKyThu().getELO() + deltaElo2);
                        }
                    }
                }
            }
            return true;
        }
    }
}

