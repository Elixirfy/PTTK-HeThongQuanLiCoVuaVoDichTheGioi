package model;

import java.io.Serializable;

/**
 * Lớp thực thể User đại diện cho "Everyone / Khách vãng lai".
 * - Bất kỳ người nào truy cập vào trang web hệ thống mà không cần đăng nhập.
 * - Không yêu cầu bất kỳ quyền hạn hay tài khoản xác thực nào.
 * - Có thể tự do xem các thông tin công khai (danh sách giải đấu, bảng xếp hạng sau vòng đấu).
 * - Là lớp cơ sở trong cây kế thừa người dùng (User -> TVHT -> BTC / KyThu).
 */
public class User implements Serializable {
    private static final long serialVersionUID = 1L;
    private int id;

    public User() {
    }

    public User(int id) {
        this.id = id;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }
}
