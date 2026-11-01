package com.pttk.model;

import java.io.Serializable;
import java.sql.Date;

public class GiaiDau implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int nam;
    private String variant;
    private int muaGiai;
    private String diaDiem;
    private String trangThai;
    private String note;
    private Date ngayBatDau;
    private Date ngayKetThuc;

    public GiaiDau() {
    }

    public GiaiDau(int id, int nam, String variant, int muaGiai, String diaDiem, String trangThai, String note, Date ngayBatDau, Date ngayKetThuc) {
        this.id = id;
        this.nam = nam;
        this.variant = variant;
        this.muaGiai = muaGiai;
        this.diaDiem = diaDiem;
        this.trangThai = trangThai;
        this.note = note;
        this.ngayBatDau = ngayBatDau;
        this.ngayKetThuc = ngayKetThuc;
    }

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getNam() { return nam; }
    public void setNam(int nam) { this.nam = nam; }

    public String getVariant() { return variant; }
    public void setVariant(String variant) { this.variant = variant; }

    public int getMuaGiai() { return muaGiai; }
    public void setMuaGiai(int muaGiai) { this.muaGiai = muaGiai; }

    public String getDiaDiem() { return diaDiem; }
    public void setDiaDiem(String diaDiem) { this.diaDiem = diaDiem; }

    public String getTrangThai() { return trangThai; }
    public void setTrangThai(String trangThai) { this.trangThai = trangThai; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public Date getNgayBatDau() { return ngayBatDau; }
    public void setNgayBatDau(Date ngayBatDau) { this.ngayBatDau = ngayBatDau; }

    public Date getNgayKetThuc() { return ngayKetThuc; }
    public void setNgayKetThuc(Date ngayKetThuc) { this.ngayKetThuc = ngayKetThuc; }
}

