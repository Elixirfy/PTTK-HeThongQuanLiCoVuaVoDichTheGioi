package model;

import java.io.Serializable;

public class TranDau implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String trangThai;
    private VongDau vongDau;
    private BanDau banDau;
    private KyThuThamGiaTranDau[] danhSachKyThu;

    public TranDau() {
    }

    public TranDau(int id, String trangThai, VongDau vongDau, BanDau banDau, KyThuThamGiaTranDau[] danhSachKyThu) {
        this.id = id;
        this.trangThai = trangThai;
        this.vongDau = vongDau;
        this.banDau = banDau;
        this.danhSachKyThu = danhSachKyThu;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public VongDau getVongDau() {
        return vongDau;
    }

    public void setVongDau(VongDau vongDau) {
        this.vongDau = vongDau;
    }

    public BanDau getBanDau() {
        return banDau;
    }

    public void setBanDau(BanDau banDau) {
        this.banDau = banDau;
    }

    public KyThuThamGiaTranDau[] getDanhSachKyThu() {
        return danhSachKyThu;
    }

    public void setDanhSachKyThu(KyThuThamGiaTranDau[] danhSachKyThu) {
        this.danhSachKyThu = danhSachKyThu;
    }
}

