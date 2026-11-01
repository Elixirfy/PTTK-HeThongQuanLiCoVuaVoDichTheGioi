package model;

import java.io.Serializable;

public class KyThuThamGiaTranDau implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private float kiVongThang;
    private Float ketQuaDiem;
    private Float eloTang;
    private TranDau tranDau;
    private KyThu kyThu;

    public KyThuThamGiaTranDau() {
    }

    public KyThuThamGiaTranDau(int id, float kiVongThang, Float ketQuaDiem, Float eloTang, TranDau tranDau, KyThu kyThu) {
        this.id = id;
        this.kiVongThang = kiVongThang;
        this.ketQuaDiem = ketQuaDiem;
        this.eloTang = eloTang;
        this.tranDau = tranDau;
        this.kyThu = kyThu;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public float getKiVongThang() {
        return kiVongThang;
    }

    public void setKiVongThang(float kiVongThang) {
        this.kiVongThang = kiVongThang;
    }

    public Float getKetQuaDiem() {
        return ketQuaDiem;
    }

    public void setKetQuaDiem(Float ketQuaDiem) {
        this.ketQuaDiem = ketQuaDiem;
    }

    public Float getEloTang() {
        return eloTang;
    }

    public void setEloTang(Float eloTang) {
        this.eloTang = eloTang;
    }

    public TranDau getTranDau() {
        return tranDau;
    }

    public void setTranDau(TranDau tranDau) {
        this.tranDau = tranDau;
    }

    public KyThu getKyThu() {
        return kyThu;
    }

    public void setKyThu(KyThu kyThu) {
        this.kyThu = kyThu;
    }
}

