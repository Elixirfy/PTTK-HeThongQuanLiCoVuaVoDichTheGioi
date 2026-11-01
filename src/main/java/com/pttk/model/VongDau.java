package com.pttk.model;

import java.io.Serializable;
import java.sql.Date;
import java.sql.Time;

public class VongDau implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int soVong;
    private Date ngayThiDau;
    private String trangThai;
    private Time thoiGianBatDau;
    private Time thoiGianKetThuc;
    private GiaiDau giaiDau;

    public VongDau() {
    }

    public VongDau(int id, int soVong, Date ngayThiDau, String trangThai, Time thoiGianBatDau, Time thoiGianKetThuc, GiaiDau giaiDau) {
        this.id = id;
        this.soVong = soVong;
        this.ngayThiDau = ngayThiDau;
        this.trangThai = trangThai;
        this.thoiGianBatDau = thoiGianBatDau;
        this.thoiGianKetThuc = thoiGianKetThuc;
        this.giaiDau = giaiDau;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getSoVong() {
        return soVong;
    }

    public void setSoVong(int soVong) {
        this.soVong = soVong;
    }

    public Date getNgayThiDau() {
        return ngayThiDau;
    }

    public void setNgayThiDau(Date ngayThiDau) {
        this.ngayThiDau = ngayThiDau;
    }

    public String getTrangThai() {
        return trangThai;
    }

    public void setTrangThai(String trangThai) {
        this.trangThai = trangThai;
    }

    public Time getThoiGianBatDau() {
        return thoiGianBatDau;
    }

    public void setThoiGianBatDau(Time thoiGianBatDau) {
        this.thoiGianBatDau = thoiGianBatDau;
    }

    public Time getThoiGianKetThuc() {
        return thoiGianKetThuc;
    }

    public void setThoiGianKetThuc(Time thoiGianKetThuc) {
        this.thoiGianKetThuc = thoiGianKetThuc;
    }

    public GiaiDau getGiaiDau() {
        return giaiDau;
    }

    public void setGiaiDau(GiaiDau giaiDau) {
        this.giaiDau = giaiDau;
    }
}

