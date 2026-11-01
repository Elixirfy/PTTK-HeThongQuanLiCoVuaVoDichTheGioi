package com.pttk.model;

import java.io.Serializable;

public class BanDau implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String soBan;

    public BanDau() {
    }

    public BanDau(int id, String soBan) {
        this.id = id;
        this.soBan = soBan;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getSoBan() {
        return soBan;
    }

    public void setSoBan(String soBan) {
        this.soBan = soBan;
    }
}

