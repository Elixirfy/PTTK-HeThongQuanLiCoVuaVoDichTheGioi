package com.pttk.model;

public class TVHT extends User {
    private static final long serialVersionUID = 1L;
    
    private String username;
    private String password;
    private String chucVu;
    private String hoTen;
    private String email;
    private String note;

    public TVHT() {
        super();
    }

    public TVHT(int id, String username, String password, String chucVu, String hoTen, String email, String note) {
        super(id);
        this.username = username;
        this.password = password;
        this.chucVu = chucVu;
        this.hoTen = hoTen;
        this.email = email;
        this.note = note;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getChucVu() {
        return chucVu;
    }

    public void setChucVu(String chucVu) {
        this.chucVu = chucVu;
    }

    public String getHoTen() {
        return hoTen;
    }

    public void setHoTen(String hoTen) {
        this.hoTen = hoTen;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }
}

