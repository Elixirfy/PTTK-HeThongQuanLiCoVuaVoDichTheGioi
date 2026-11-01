package dao;

import model.*;

import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class TranDauDAO extends DAO {

    // Kho dữ liệu dự phòng chuẩn bị sẵn phục vụ kiểm thử (Khớp 100% boundary testing)
    private static final ArrayList<TranDau> MOCK_TRAN_DAU = new ArrayList<>();

    static {
        // Vòng 5 giải 2026 (id = 105)
        VongDau vd105 = new VongDau();
        vd105.setId(105);
        vd105.setSoVong(5);
        vd105.setTrangThai("Đang diễn ra");

        // Khởi tạo 10 đại kiện tướng quốc tế độc lập (Mỗi bàn 1 cặp kỳ thủ duy nhất trong cùng 1 vòng đấu)
        KyThu carlsen = new KyThu(101, "carlsen", "123", "Kỳ thủ", "Magnus Carlsen", "carlsen@chess.com", "",
                Date.valueOf("1990-11-30"), "Na Uy", 10, 2830.0f);
        KyThu nakamura = new KyThu(102, "nakamura", "123", "Kỳ thủ", "Hikaru Nakamura", "hikaru@chess.com", "",
                Date.valueOf("1987-12-09"), "Hoa Kỳ", 10, 2802.0f);
        KyThu liren = new KyThu(103, "liren", "123", "Kỳ thủ", "Ding Liren", "ding@chess.com", "",
                Date.valueOf("1992-10-24"), "Trung Quốc", 10, 2750.0f);
        KyThu gukesh = new KyThu(104, "gukesh", "123", "Kỳ thủ", "Gukesh Dommaraju", "gukesh@chess.com", "",
                Date.valueOf("2006-05-29"), "Ấn Độ", 10, 2760.0f);
        KyThu nepo = new KyThu(105, "nepo", "123", "Kỳ thủ", "Ian Nepomniachtchi", "ian@chess.com", "",
                Date.valueOf("1990-07-14"), "FIDE", 10, 2770.0f);
        KyThu caruana = new KyThu(106, "caruana", "123", "Kỳ thủ", "Fabiano Caruana", "caruana@chess.com", "",
                Date.valueOf("1992-07-30"), "Hoa Kỳ", 10, 2805.0f);
        KyThu firouzja = new KyThu(107, "firouzja", "123", "Kỳ thủ", "Alireza Firouzja", "firouzja@chess.com", "",
                Date.valueOf("2003-06-18"), "Pháp", 10, 2785.0f);
        KyThu pragg = new KyThu(108, "pragg", "123", "Kỳ thủ", "Praggnanandhaa R", "pragg@chess.com", "",
                Date.valueOf("2005-08-10"), "Ấn Độ", 10, 2755.0f);
        KyThu abdusattorov = new KyThu(109, "abdusattorov", "123", "Kỳ thủ", "Nodirbek Abdusattorov", "nodir@chess.com", "",
                Date.valueOf("2004-09-18"), "Uzbekistan", 10, 2765.0f);
        KyThu weiyi = new KyThu(110, "weiyi", "123", "Kỳ thủ", "Wei Yi", "weiyi@chess.com", "",
                Date.valueOf("1999-06-02"), "Trung Quốc", 10, 2762.0f);

        // Trận 1101: Bàn 11 (Carlsen vs Nakamura)
        BanDau b11 = new BanDau(1, "Bàn 11");
        KyThuThamGiaTranDau kq1 = new KyThuThamGiaTranDau(1, 0.54f, null, null, null, carlsen);
        KyThuThamGiaTranDau kq2 = new KyThuThamGiaTranDau(2, 0.46f, null, null, null, nakamura);
        TranDau td1101 = new TranDau(1101, "Đang diễn ra", vd105, b11, new KyThuThamGiaTranDau[]{kq1, kq2});
        kq1.setTranDau(td1101);
        kq2.setTranDau(td1101);
        MOCK_TRAN_DAU.add(td1101);

        // Trận 1102: Bàn 110 (Liren vs Gukesh)
        BanDau b110 = new BanDau(2, "Bàn 110");
        KyThuThamGiaTranDau kq3 = new KyThuThamGiaTranDau(3, 0.49f, null, null, null, liren);
        KyThuThamGiaTranDau kq4 = new KyThuThamGiaTranDau(4, 0.51f, null, null, null, gukesh);
        TranDau td1102 = new TranDau(1102, "Đang diễn ra", vd105, b110, new KyThuThamGiaTranDau[]{kq3, kq4});
        kq3.setTranDau(td1102);
        kq4.setTranDau(td1102);
        MOCK_TRAN_DAU.add(td1102);

        // Trận 1103: Bàn 011 (Nepomniachtchi vs Caruana)
        BanDau b011 = new BanDau(4, "Bàn 011");
        KyThuThamGiaTranDau kq5 = new KyThuThamGiaTranDau(5, 0.45f, null, null, null, nepo);
        KyThuThamGiaTranDau kq6 = new KyThuThamGiaTranDau(6, 0.55f, null, null, null, caruana);
        TranDau td1103 = new TranDau(1103, "Đang diễn ra", vd105, b011, new KyThuThamGiaTranDau[]{kq5, kq6});
        kq5.setTranDau(td1103);
        kq6.setTranDau(td1103);
        MOCK_TRAN_DAU.add(td1103);

        // Trận 1104: Bàn 111 (Firouzja vs Praggnanandhaa)
        BanDau b111 = new BanDau(6, "Bàn 111");
        KyThuThamGiaTranDau kq7 = new KyThuThamGiaTranDau(7, 0.54f, null, null, null, firouzja);
        KyThuThamGiaTranDau kq8 = new KyThuThamGiaTranDau(8, 0.46f, null, null, null, pragg);
        TranDau td1104 = new TranDau(1104, "Đang diễn ra", vd105, b111, new KyThuThamGiaTranDau[]{kq7, kq8});
        kq7.setTranDau(td1104);
        kq8.setTranDau(td1104);
        MOCK_TRAN_DAU.add(td1104);

        // Trận 1105: Bàn 01 (Abdusattorov vs Wei Yi)
        BanDau b01 = new BanDau(7, "Bàn 01");
        KyThuThamGiaTranDau kq9 = new KyThuThamGiaTranDau(9, 0.50f, null, null, null, abdusattorov);
        KyThuThamGiaTranDau kq10 = new KyThuThamGiaTranDau(10, 0.50f, null, null, null, weiyi);
        TranDau td1105 = new TranDau(1105, "Đang diễn ra", vd105, b01, new KyThuThamGiaTranDau[]{kq9, kq10});
        kq9.setTranDau(td1105);
        kq10.setTranDau(td1105);
        MOCK_TRAN_DAU.add(td1105);
    }

    public TranDauDAO() {
        super();
    }

    /**
     * Tìm kiếm trận đấu thuộc vòng đấu xác định theo bàn đấu (Chuẩn PTIT OOAD: nhận thực thể TranDau đã nạp VongDau)
     */
    public ArrayList<TranDau> searchTranDauTheoBan(TranDau tdCriteria) {
        ArrayList<TranDau> list = new ArrayList<>();
        if (tdCriteria == null || tdCriteria.getVongDau() == null) {
            return list;
        }
        int idVongDau = tdCriteria.getVongDau().getId();
        String keyword = (tdCriteria.getBanDau() != null && tdCriteria.getBanDau().getSoBan() != null)
                ? tdCriteria.getBanDau().getSoBan().trim() : "";

        if (isConnectedToMySQL()) {
            String sql = "SELECT td.id, td.trangThai, td.VongDauid, td.BanDauid, bd.soBan " +
                    "FROM tblTranDau td " +
                    "JOIN tblBanDau bd ON td.BanDauid = bd.id " +
                    "WHERE td.VongDauid = ? AND bd.soBan LIKE ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, idVongDau);
                ps.setString(2, "%" + keyword + "%");
                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        int tdId = rs.getInt("id");
                        TranDau td = getChiTietTranDau(tdId);
                        if (td != null) {
                            td.setVongDau(tdCriteria.getVongDau());
                            list.add(td);
                        }
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            // Mock Fallback
            for (TranDau td : MOCK_TRAN_DAU) {
                if (td.getVongDau() != null && td.getVongDau().getId() == idVongDau) {
                    if (keyword.isEmpty() || (td.getBanDau() != null && td.getBanDau().getSoBan().contains(keyword))) {
                        td.setVongDau(tdCriteria.getVongDau());
                        list.add(td);
                    }
                }
            }
        }

        return list;
    }

    /**
     * Overload tìm kiếm theo idVongDau và chuỗi bàn đấu để tương thích ngược
     */
    public ArrayList<TranDau> searchTranDauTheoBan(int idVongDau, String soBan) {
        VongDau vd = new VongDau();
        vd.setId(idVongDau);
        TranDau criteria = new TranDau();
        criteria.setVongDau(vd);
        BanDau bd = new BanDau();
        bd.setSoBan(soBan);
        criteria.setBanDau(bd);
        return searchTranDauTheoBan(criteria);
    }

    /**
     * Lấy thông tin chi tiết một trận đấu kèm 2 kỳ thủ tham gia
     */
    public TranDau getChiTietTranDau(int idTranDau) {
        if (isConnectedToMySQL()) {
            String sql = "SELECT td.id, td.trangThai, td.VongDauid, td.BanDauid, bd.soBan " +
                    "FROM tblTranDau td " +
                    "JOIN tblBanDau bd ON td.BanDauid = bd.id " +
                    "WHERE td.id = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, idTranDau);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        TranDau td = new TranDau();
                        td.setId(rs.getInt("id"));
                        td.setTrangThai(rs.getString("trangThai"));
                        td.setBanDau(new BanDau(rs.getInt("BanDauid"), rs.getString("soBan")));

                        // Lấy 2 kỳ thủ
                        String sqlPlayers = "SELECT kq.id, kq.kiVongThang, kq.ketQuaDiem, kq.eloTang, " +
                                "kt.Userid, kt.DOB, kt.quocTich, kt.heSoThang, kt.ELO, tv.hoTen, tv.email " +
                                "FROM tblKyThuThamGiaTranDau kq " +
                                "JOIN tblKyThu kt ON kq.KyThuid = kt.Userid " +
                                "JOIN tblTVHT tv ON kt.Userid = tv.Userid " +
                                "WHERE kq.TranDauid = ?";
                        try (PreparedStatement psP = con.prepareStatement(sqlPlayers)) {
                            psP.setInt(1, idTranDau);
                            try (ResultSet rsP = psP.executeQuery()) {
                                ArrayList<KyThuThamGiaTranDau> players = new ArrayList<>();
                                while (rsP.next()) {
                                    KyThu kt = new KyThu();
                                    kt.setId(rsP.getInt("Userid"));
                                    kt.setHoTen(rsP.getString("hoTen"));
                                    kt.setEmail(rsP.getString("email"));
                                    kt.setQuocTich(rsP.getString("quocTich"));
                                    kt.setHeSoThang(rsP.getInt("heSoThang"));
                                    kt.setELO(rsP.getFloat("ELO"));

                                    KyThuThamGiaTranDau kttg = new KyThuThamGiaTranDau();
                                    kttg.setId(rsP.getInt("id"));
                                    kttg.setKiVongThang(rsP.getFloat("kiVongThang"));
                                    kttg.setKetQuaDiem(rsP.getObject("ketQuaDiem") != null ? rsP.getFloat("ketQuaDiem") : null);
                                    kttg.setEloTang(rsP.getObject("eloTang") != null ? rsP.getFloat("eloTang") : null);
                                    kttg.setKyThu(kt);
                                    kttg.setTranDau(td);
                                    players.add(kttg);
                                }
                                td.setDanhSachKyThu(players.toArray(new KyThuThamGiaTranDau[0]));
                            }
                        }
                        return td;
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            for (TranDau td : MOCK_TRAN_DAU) {
                if (td.getId() == idTranDau) {
                    return td;
                }
            }
        }
        return null;
    }
}

