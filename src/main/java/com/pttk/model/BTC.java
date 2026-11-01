package com.pttk.model;

import java.io.Serializable;

public class BTC extends TVHT implements Serializable {
    private static final long serialVersionUID = 1L;

    public BTC() {
        super();
    }

    public BTC(int id, String username, String password, String chucVu, String hoTen, String email, String note) {
        super(id, username, password, chucVu, hoTen, email, note);
    }
}

