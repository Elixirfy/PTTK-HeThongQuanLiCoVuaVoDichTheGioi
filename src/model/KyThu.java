package model;

import java.sql.Date;

public class KyThu extends TVHT {
    private static final long serialVersionUID = 1L;

    private Date DOB;
    private String quocTich;
    private int heSoThang;
    private float ELO;

    public KyThu() {
        super();
    }

    public KyThu(int id, String username, String password, String chucVu, String hoTen, String email, String note,
                 Date DOB, String quocTich, int heSoThang, float ELO) {
        super(id, username, password, chucVu, hoTen, email, note);
        this.DOB = DOB;
        this.quocTich = quocTich;
        this.heSoThang = heSoThang;
        this.ELO = ELO;
    }

    public Date getDOB() {
        return DOB;
    }

    public void setDOB(Date DOB) {
        this.DOB = DOB;
    }

    public String getQuocTich() {
        return quocTich;
    }

    public void setQuocTich(String quocTich) {
        this.quocTich = quocTich;
    }

    public int getHeSoThang() {
        return heSoThang;
    }

    public void setHeSoThang(int heSoThang) {
        this.heSoThang = heSoThang;
    }

    public float getELO() {
        return ELO;
    }

    public void setELO(float ELO) {
        this.ELO = ELO;
    }
}

