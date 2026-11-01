# STATIC CLASS DESIGN (3-TIER ARCHITECTURE)

> **THIẾT KẾ TĨNH 3 TẦNG: BOUNDARY (JSP) - CONTROL (DAO) - ENTITY (MODEL)**
> Vị trí: `docs/design/STATIC_CLASS_DESIGN.md`
> Phục vụ: Pha Design theo quy trình Unified Process

---

## 1. TẦNG GIAO DIỆN (BOUNDARY LAYER - JSP)

Tuân thủ phương pháp thiết kế giao diện của bộ môn: Mỗi trang `.jsp` tương đương một lớp giao diện với các thuộc tính điều khiển và thuộc tính ẩn để trao đổi dữ liệu:

### 1.1. Module 1: Quản lý thông tin giải đấu
* **`gdCoBan.jsp`**:
  - `btnLogin`: Liên kết chuyển tới trang đăng nhập.
* **`gdLogin.jsp`**:
  - `txtUsername`: Input text nhận tên đăng nhập.
  - `pwdPassword`: Input password nhận mật khẩu.
  - `btnLogin`: Nút submit gửi dữ liệu tới `doCheckLogin.jsp`.
  - `btnBack`: Liên kết quay lại `gdCoBan.jsp`.
* **`doCheckLogin.jsp`**:
  - Nhận `txtUsername`, `pwdPassword`.
  - Gọi `TVHTDAO.checkLogin(tvht)`.
  - Nếu đúng: Lưu session và chuyển sang `gdTrangQuanLiGiaiCoVua.jsp`.
  - Nếu sai: Alert "Tài khoản hoặc mật khẩu không chính xác!" và quay về `gdLogin.jsp`.
* **`gdTrangQuanLiGiaiCoVua.jsp`**:
  - `btnQuanLiGiaiDau`: Liên kết chuyển tới `gdTimKiemGiaiDau.jsp`.
  - `btnCapNhatKetQuaVongDau`: Liên kết chuyển tới cập nhật kết quả.
  - `btnDangXuat`: Liên kết kết thúc phiên làm việc.
* **`gdTimKiemGiaiDau.jsp`**:
  - `numNamTimKiem`: Input number nhận năm tìm kiếm.
  - `btnTimKiem`: Nút submit tìm kiếm giải đấu.
  - `tblGiaiDau`: Bảng hiển thị danh sách các giải đấu trong năm.
  - `chonSua`: Liên kết chọn sửa kèm tham số `idGiaiDau` gửi sang `gdSuaThongTinGiaiDau.jsp`.
* **`gdSuaThongTinGiaiDau.jsp`**:
  - `idGiaiDau`: Input hidden lưu mã giải đấu cần sửa.
  - `numNamToChuc`: Input number chứa năm tổ chức.
  - `txtVariant`: Input text chứa thể loại (Classical, Rapid & Blitz).
  - `txtMuaToChuc`: Input number chứa mùa tổ chức.
  - `datNgayBatDau`: Input date chứa ngày khai mạc.
  - `datNgayKetThuc`: Input date chứa ngày bế mạc.
  - `txtDiaDiem`: Input text chứa địa điểm tổ chức.
  - `txaMoTa`: TextArea chứa ghi chú, mô tả giải đấu.
  - `btnLuu`: Nút submit gửi dữ liệu sang `doCapNhatThongTinGiaiDau.jsp`.
  - `btnHuy`: Liên kết hủy thao tác quay lại `gdTimKiemGiaiDau.jsp`.
* **`doCapNhatThongTinGiaiDau.jsp`**:
  - Đóng gói dữ liệu form vào đối tượng `GiaiDau`.
  - Gọi `GiaiDauDAO.updateGiaiDau(gd)`.
  - Bật JavaScript Alert "Sửa thông tin giải đấu thành công!" và chuyển hướng về `gdTimKiemGiaiDau.jsp`.

### 1.2. Module 2: Cập nhật kết quả từng vòng đấu
* **`gdChonVongDau.jsp`**:
  - `tblVongDau`: Bảng danh sách các vòng đấu của giải đấu đã chọn.
  - `chonVD`: Liên kết chọn vòng đấu kèm kiểm tra trạng thái:
    - Nếu trạng thái là `Đang diễn ra` $\rightarrow$ Chuyển sang `gdChonTranDau.jsp?idVongDau=...`.
    - Nếu trạng thái là `Chưa bắt đầu` $\rightarrow$ Cảnh báo "Lỗi! Vòng đấu chưa diễn ra".
  - `btnQuayLai`: Liên kết quay về danh sách giải đấu.
* **`gdChonTranDau.jsp`**:
  - `txtBanDau`: Input text nhận từ khóa tìm kiếm Bàn đấu (ví dụ: "11", "01").
  - `btnTimKiem`: Nút submit lọc trận đấu theo bàn.
  - `tblTranDau`: Bảng danh sách các trận đấu tìm thấy (Mã trận, Bàn đấu, Tên Kỳ thủ 1, Tên Kỳ thủ 2).
  - `chonTD`: Liên kết chọn trận đấu chuyển sang `gdChiTietTranDau.jsp?idTranDau=...`.
* **`gdChiTietTranDau.jsp`**:
  - Hiển thị thông tin chi tiết: Mã trận, Bàn đấu, Họ tên & Elo của Kỳ thủ 1 và Kỳ thủ 2.
  - Hiển thị Kỳ vọng thắng FIDE ($E_1, E_2$) của 2 kỳ thủ.
  - `btnNhapKetQua`: Nút chuyển sang form nhập điểm `gdNhapKetQua.jsp`.
  - `btnQuayLai`: Quay về `gdChonTranDau.jsp`.
* **`gdNhapKetQua.jsp`**:
  - `slKyThu1`: Thẻ select chọn điểm cho Kỳ thủ 1 (`1.0`, `0.5`, `0.0`).
  - `slKyThu2`: Thẻ select chọn điểm cho Kỳ thủ 2 (`1.0`, `0.5`, `0.0`).
  - `btnTinhDiem`: Nút submit kiểm tra tính hợp lệ và chuyển sang `gdTinhDiem.jsp`.
  - `btnHuy`: Quay về `gdChiTietTranDau.jsp`.
* **`gdTinhDiem.jsp`**:
  - Hiển thị kết quả tính toán tự động: Biến động Elo ($\Delta ELO$) và Điểm Elo mới sau trận.
  - `btnLuu`: Nút submit gửi dữ liệu sang `doLuuKetQua.jsp`.
  - `btnHuy`: Hủy thao tác quay lại `gdChiTietTranDau.jsp`.
* **`doLuuKetQua.jsp`**:
  - Nhận mảng kết quả của 2 kỳ thủ (`KyThuThamGiaTranDau[2]`).
  - Gọi `KyThuThamGiaTranDauDAO.addKetQua(kq)`.
  - Bật JavaScript Alert "Cập nhật kết quả trận đấu thành công!" và quay về `gdChonTranDau.jsp`.

---

## 2. TẦNG TRUY XUẤT DỮ LIỆU (CONTROL LAYER - DAO)

Các lớp DAO kế thừa từ lớp cha `DAO` để tái sử dụng kết nối:

```java
// Lớp cơ sở DAO
public class DAO {
    protected Connection con;
    public DAO() {
        // Mở kết nối JDBC tới MySQL Docker: jdbc:mysql://localhost:3306/db_covua
    }
}
```

### 2.1. `TVHTDAO` (kế thừa `DAO`)
* `public boolean checkLogin(TVHT tvht)`: Xác thực username/password trong bảng `tblTVHT`, nếu đúng nạp đầy đủ thuộc tính `Userid`, `hoTen`, `chucVu`, `email` vào đối tượng `tvht` và trả về `true`.

### 2.2. `GiaiDauDAO` (kế thừa `DAO`)
* `public ArrayList<GiaiDau> searchGiaiDauBTC(int nam)`: Lấy danh sách các giải đấu tổ chức trong năm được chỉ định.
* `public GiaiDau getGiaiDauById(int id)`: Lấy thông tin chi tiết của 1 giải đấu để nạp vào form sửa.
* `public boolean updateGiaiDau(GiaiDau gd)`: Thực hiện câu lệnh SQL `UPDATE tblGiaiDau SET nam=?, variant=?, muaGiai=?, diaDiem=?, note=?, ngayBatDau=?, ngayKetThuc=? WHERE id=?`.

### 2.3. `VongDauDAO` (kế thừa `DAO`)
* `public ArrayList<VongDau> getVongDauCuaBTC(int idGiaiDau)`: Lấy danh sách các vòng đấu thuộc giải đấu, sắp xếp theo thứ tự `soVong` tăng dần.

### 2.4. `TranDauDAO` (kế thừa `DAO`)
* `public ArrayList<TranDau> searchTranDauTheoBan(TranDau td)`: Tìm kiếm các trận đấu thuộc vòng đấu xác định có số bàn đấu thỏa mãn từ khóa tìm kiếm (tìm kiếm chứa/tương đối theo chuỗi bàn đấu).
* `public TranDau getChiTietTranDau(int idTranDau)`: Lấy thông tin chi tiết một trận đấu kèm 2 bản ghi `KyThuThamGiaTranDau` tương ứng.

### 2.5. `KyThuThamGiaTranDauDAO` (kế thừa `DAO`)
* `public boolean addKetQua(KyThuThamGiaTranDau[] kq)`: Thực hiện transaction cập nhật điểm số `ketQuaDiem`, `eloTang` cho cả 2 kỳ thủ và cập nhật điểm `ELO` mới của kỳ thủ trong bảng `tblKyThu`, đồng thời cập nhật `trangThai` của trận đấu thành `"Kết thúc"`.

---

## 3. TẦNG THỰC THỂ (ENTITY LAYER - POJO)

Các lớp Java Bean chuẩn hóa thuộc tính và getter/setter:
* **`User`**: `id` (int).
* **`TVHT`** (extends `User`): `username`, `password`, `chucVu`, `hoTen`, `email`, `note`.
* **`BTC`** (extends `TVHT`): Giữ nguyên các thuộc tính.
* **`KyThu`** (extends `TVHT`): `DOB` (Date), `quocTich` (String), `heSoThang` (int), `ELO` (float).
* **`BanDau`**: `id` (int), `soBan` (String).
* **`GiaiDau`**: `id` (int), `nam` (int), `variant` (String), `muaGiai` (int), `diaDiem` (String), `trangThai` (String), `note` (String), `ngayBatDau` (Date), `ngayKetThuc` (Date).
* **`VongDau`**: `id` (int), `soVong` (int), `ngayThiDau` (Date), `trangThai` (String), `thoiGianBatDau` (Time), `thoiGianKetThuc` (Time), `giaiDau` (GiaiDau).
* **`TranDau`**: `id` (int), `trangThai` (String), `vongDau` (VongDau), `banDau` (BanDau), `ketQua` (KyThuThamGiaTranDau[]).
* **`KyThuThamGiaTranDau`**: `id` (int), `kiVongThang` (float), `ketQuaDiem` (float), `eloTang` (float), `tranDau` (TranDau), `kyThu` (KyThu).

