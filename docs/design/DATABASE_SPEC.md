# DATABASE SPECIFICATION & RELATIONAL DESIGN

> **QUY TRÌNH THIẾT KẾ CSDL 5 BƯỚC & TỪ ĐIỂN DỮ LIỆU**
> Vị trí: `docs/design/DATABASE_SPEC.md`
> Phục vụ: Pha Design theo quy trình Unified Process

---

## 1. QUY TRÌNH 5 BƯỚC THIẾT KẾ CƠ SỞ DỮ LIỆU

Dựa trên biểu đồ lớp thực thể pha thiết kế, CSDL được chuyển đổi theo 5 bước chuẩn mực:

* **Bước 1: Ánh xạ lớp thực thể sang bảng dữ liệu**:
  - `User` $\rightarrow$ `tblUser`
  - `TVHT` $\rightarrow$ `tblTVHT`
  - `BTC` $\rightarrow$ `tblBTC`
  - `KyThu` $\rightarrow$ `tblKyThu`
  - `BanDau` $\rightarrow$ `tblBanDau`
  - `TranDau` $\rightarrow$ `tblTranDau`
  - `VongDau` $\rightarrow$ `tblVongDau`
  - `GiaiDau` $\rightarrow$ `tblGiaiDau`
  - `KyThuThamGiaTranDau` $\rightarrow$ `tblKyThuThamGiaTranDau`
* **Bước 2: Bỏ thuộc tính đối tượng, giữ lại các thuộc tính kiểu cơ bản**:
  - Bỏ các mảng danh sách (`danhSachVongDau[]`, `danhSachTranDau[]`, `ketQuaThiDau[]`).
  - Chuyển đổi kiểu dữ liệu sang kiểu dữ liệu tương ứng của MySQL (`integer` $\rightarrow$ `INT`, `String` $\rightarrow$ `VARCHAR`, `date` $\rightarrow$ `DATE`, `time` $\rightarrow$ `TIME`, `float` $\rightarrow$ `FLOAT`).
* **Bước 3: Xác định quan hệ số lượng giữa các bảng**:
  - $1$ `tblUser` – $1$ `tblTVHT` (Kế thừa).
  - $1$ `tblTVHT` – $1$ `tblBTC` (Kế thừa).
  - $1$ `tblTVHT` – $1$ `tblKyThu` (Kế thừa).
  - $1$ `tblGiaiDau` – $N$ `tblVongDau`.
  - $1$ `tblVongDau` – $N$ `tblTranDau`.
  - $1$ `tblBanDau` – $N$ `tblTranDau`.
  - $1$ `tblTranDau` – $N$ `tblKyThuThamGiaTranDau` (Chính xác là $2$ bản ghi cho mỗi trận đấu).
  - $1$ `tblKyThu` – $N$ `tblKyThuThamGiaTranDau`.
* **Bước 4: Thiết lập Khóa chính (PK) và Khóa ngoại (FK)**:
  - Khóa chính tự tăng trên cột `id` của: `tblUser`, `tblBanDau`, `tblTranDau`, `tblVongDau`, `tblGiaiDau`, `tblKyThuThamGiaTranDau`.
  - Các bảng con kế thừa (`tblTVHT`, `tblBTC`, `tblKyThu`) dùng cột `Userid` vừa làm khóa chính, vừa làm khóa ngoại tham chiếu đến bảng cha.
  - Các khóa ngoại liên kết:
    - `tblVongDau.GiaiDauid` $\rightarrow$ `tblGiaiDau(id)`
    - `tblTranDau.VongDauid` $\rightarrow$ `tblVongDau(id)`
    - `tblTranDau.BanDauid` $\rightarrow$ `tblBanDau(id)`
    - `tblKyThuThamGiaTranDau.TranDauid` $\rightarrow$ `tblTranDau(id)`
    - `tblKyThuThamGiaTranDau.KyThuid` $\rightarrow$ `tblKyThu(Userid)`
* **Bước 5: Tối ưu thuộc tính dẫn xuất & Loại bỏ bảng thống kê**:
  - Các thuộc tính dẫn xuất như `tongDiem`, `tongDiemDoiThu`, `eloTamTinh` đều có thể tính toán động từ kết quả các trận đấu trong CSDL.
  - **Loại bỏ hoàn toàn bảng `tblTKKiThu`** khỏi CSDL vật lý (chỉ giữ lớp `TKKiThu` trong code Java để đóng gói dữ liệu thống kê khi truy vấn).
  - Bổ sung cột `eloTang` (`FLOAT`) vào `tblKyThuThamGiaTranDau` để ghi lại lịch sử biến động điểm sau trận đấu.

---

## 2. TỪ ĐIỂN DỮ LIỆU CHI TIẾT (DATA DICTIONARY)

### 2.1. Bảng `tblUser`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Định danh người dùng |

### 2.2. Bảng `tblTVHT`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `Userid` | `INT` | `PK, FK -> tblUser(id)` | Khóa chính và tham chiếu cha |
| `username` | `VARCHAR(50)` | `NOT NULL, UNIQUE` | Tên đăng nhập |
| `password` | `VARCHAR(100)` | `NOT NULL` | Mật khẩu xác thực |
| `chucVu` | `VARCHAR(100)` | `NOT NULL` | Chức vụ (ví dụ: "Ban tổ chức", "Kỳ thủ") |
| `hoTen` | `VARCHAR(150)` | `NOT NULL` | Họ và tên đầy đủ |
| `email` | `VARCHAR(100)` | `NOT NULL, UNIQUE` | Địa chỉ email |
| `note` | `VARCHAR(255)` | `NULL` | Ghi chú thêm |

### 2.3. Bảng `tblBTC`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `Userid` | `INT` | `PK, FK -> tblTVHT(Userid)` | Đại diện thành viên Ban tổ chức |

### 2.4. Bảng `tblKyThu`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `Userid` | `INT` | `PK, FK -> tblTVHT(Userid)` | Định danh kỳ thủ |
| `DOB` | `DATE` | `NULL` | Ngày tháng năm sinh |
| `quocTich` | `VARCHAR(100)` | `NOT NULL` | Quốc tịch |
| `heSoThang` | `INT` | `NOT NULL, DEFAULT 10` | Hệ số phát triển $K$ FIDE (cố định từ đầu giải) |
| `ELO` | `INT` | `NOT NULL, DEFAULT 1500` | Hệ số Elo hiện tại của kỳ thủ |

### 2.5. Bảng `tblBanDau`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Khóa chính bàn đấu |
| `soBan` | `VARCHAR(50)` | `NOT NULL, UNIQUE` | Số hiệu/Tên bàn (phục vụ test biên: "11", "011", "110"...) |

### 2.6. Bảng `tblGiaiDau`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Mã định danh giải đấu |
| `nam` | `INT` | `NOT NULL` | Năm tổ chức giải |
| `variant` | `VARCHAR(100)` | `NOT NULL` | Thể loại (Classical, Rapid & Blitz) |
| `muaGiai` | `INT` | `NOT NULL` | Mùa giải (1, 2,...) |
| `diaDiem` | `VARCHAR(255)` | `NOT NULL` | Địa điểm tổ chức |
| `trangThai` | `VARCHAR(50)` | `NOT NULL` | Trạng thái ("Đang diễn ra", "Kết thúc", "Chưa bắt đầu") |
| `note` | `TEXT` | `NULL` | Mô tả giải đấu |
| `ngayBatDau` | `DATE` | `NOT NULL` | Ngày khai mạc |
| `ngayKetThuc` | `DATE` | `NOT NULL` | Ngày bế mạc |

### 2.7. Bảng `tblVongDau`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Mã vòng đấu |
| `soVong` | `INT` | `NOT NULL` | Thứ tự vòng đấu (1, 2, 3,...) |
| `ngayThiDau` | `DATE` | `NOT NULL` | Ngày diễn ra vòng đấu |
| `trangThai` | `VARCHAR(50)` | `NOT NULL` | Trạng thái ("Đang diễn ra", "Kết thúc", "Chưa bắt đầu") |
| `thoiGianBatDau` | `TIME` | `NULL` | Giờ bắt đầu thi đấu |
| `thoiGianKetThuc` | `TIME` | `NULL` | Giờ kết thúc thi đấu |
| `GiaiDauid` | `INT` | `FK -> tblGiaiDau(id)` | Tham chiếu đến giải đấu |

### 2.8. Bảng `tblTranDau`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Mã trận đấu |
| `trangThai` | `VARCHAR(50)` | `NOT NULL` | Trạng thái ("Đang diễn ra", "Kết thúc", "Chưa bắt đầu") |
| `VongDauid` | `INT` | `FK -> tblVongDau(id)` | Vòng đấu chứa trận |
| `BanDauid` | `INT` | `FK -> tblBanDau(id)` | Bàn thi đấu |

### 2.9. Bảng `tblKyThuThamGiaTranDau`
| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
| :--- | :--- | :--- | :--- |
| `id` | `INT` | `PK, AUTO_INCREMENT` | Khóa chính kết quả |
| `TranDauid` | `INT` | `FK -> tblTranDau(id)` | Trận đấu tham gia |
| `KyThuid` | `INT` | `FK -> tblKyThu(Userid)` | Kỳ thủ tham gia |
| `kiVongThang` | `FLOAT` | `NOT NULL, DEFAULT 0.5` | Kỳ vọng thắng FIDE tính trước trận |
| `ketQuaDiem` | `FLOAT` | `NULL` | Điểm số đạt được: 1.0 (thắng), 0.5 (hòa), 0.0 (thua) |
| `eloTang` | `FLOAT` | `NULL` | Điểm Elo biến động ($\Delta ELO$) sau trận |

