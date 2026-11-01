# ANALYSIS MODELS & SPECIFICATIONS

> **MÔ HÌNH HÓA PHA PHÂN TÍCH (ANALYSIS WORKFLOW)**
> Vị trí: `docs/analysis/ANALYSIS_MODELS.md`
> Phục vụ: Pha Analysis theo quy trình Unified Process

---

## 1. PHÂN TÍCH TĨNH: TRÍCH XUẤT THỰC THỂ KHÁI NIỆM

Dựa trên đoạn văn mô tả kịch bản nghiệp vụ chuẩn, các danh từ được bóc tách và phân loại:

### 1.1. Lọc và Đánh giá Danh từ
* **Danh từ trừu tượng / giao diện (Loại bỏ khỏi thực thể nghiệp vụ)**: Hệ thống, trang chủ, chức năng, giao diện, tìm kiếm, danh sách giải đấu, thao tác, trang chỉnh sửa, thông báo, lựa chọn, công thức, tiêu chí, thứ tự.
* **Danh từ liên quan đến con người**:
  - `User`: Lớp trừu tượng đại diện người dùng.
  - `TVHT`: Kế thừa `User`, chứa thông tin tài khoản đăng nhập (`username`, `password`, `hoTen`, `email`, `chucVu`).
  - `BTC`: Kế thừa `TVHT`.
  - `KyThu`: Kế thừa `TVHT`, bổ sung các thuộc tính thi đấu (`DOB`, `quocTich`, `ELO`, `heSoThang`).
* **Danh từ liên quan đến vật & sự kiện**:
  - `BanDau`: Đại diện bàn thi đấu.
  - `GiaiDau`: Chứa thông tin giải (`nam`, `variant`, `muaGiai`, `diaDiem`, `trangThai`, `ngayBatDau`, `ngayKetThuc`).
  - `VongDau`: Thuộc giải đấu (`soVong`, `ngayThiDau`, `trangThai`, `thoiGianBatDau`, `thoiGianKetThuc`).
  - `TranDau`: Thuộc vòng đấu, diễn ra trên bàn đấu (`trangThai`, `BanDau`, `VongDau`).
  - `KyThuThamGiaTranDau`: Lớp liên kết giữa `KyThu` và `TranDau` để ghi nhận vai trò, kỳ vọng thắng và điểm số của từng kỳ thủ trong một trận đấu cụ thể.

---

## 2. QUAN HỆ SỐ LƯỢNG VÀ BẢN CHẤT ĐỐI TƯỢNG

1. **Quan hệ Kế thừa (Generalization)**:
   - `TVHT` $\rightarrow$ `User`
   - `BTC` $\rightarrow$ `TVHT`
   - `KyThu` $\rightarrow$ `TVHT`
2. **Quan hệ Chứa đựng / Hợp thành (Composition)**:
   - Một `GiaiDau` chứa $1..N$ `VongDau`. Khi giải đấu bị xóa thì các vòng đấu bên trong cũng bị hủy.
   - Một `VongDau` chứa $1..N$ `TranDau`.
3. **Quan hệ Liên kết Nhiều - Nhiều ($N - N$) được Chuẩn hóa**:
   - Một `TranDau` có đúng $2$ kỳ thủ tham gia. Một `KyThu` có thể tham gia nhiều trận đấu.
   - Quan hệ này được tách thành thực thể **`KyThuThamGiaTranDau`** ($1$ trận đấu có $2$ bản ghi `KyThuThamGiaTranDau`, $1$ kỳ thủ có nhiều bản ghi `KyThuThamGiaTranDau`).
4. **Quan hệ Một - Nhiều ($1 - N$)**:
   - Một `BanDau` có thể tổ chức nhiều `TranDau` theo các vòng/khung giờ khác nhau. Mỗi `TranDau` chỉ thuộc về một `BanDau`.

---

## 3. PHÂN TÍCH ĐỘNG: BIỂU ĐỒ TRẠNG THÁI (STATE DIAGRAM)

Biểu đồ trạng thái quy định nghiêm ngặt các điều kiện chuyển trạng thái giữa các màn hình và kiểm soát ngoại lệ:

### 3.1. Phân hệ Quản lý thông tin giải đấu
* Trạng thái 1: *Giao diện cơ bản* $\xrightarrow{\text{Chọn Đăng nhập}}$ Trạng thái 2: *Giao diện đăng nhập*.
* Tại *Giao diện đăng nhập*:
  - Nếu thông tin sai $\rightarrow$ Hiển thị thông báo lỗi $\rightarrow$ Người dùng nhấn OK quay lại form đăng nhập.
  - Nếu thông tin đúng $\rightarrow$ Chuyển sang Trạng thái 3: *Trang quản lý chính của BTC*.
* Tại *Trang quản lý chính*:
  - Nhấn "Đăng xuất" $\rightarrow$ Quay về Trang chủ cơ bản.
  - Nhấn "Quản lý giải đấu" $\rightarrow$ Chuyển sang Trạng thái 4: *Tìm kiếm giải đấu*.
* Tại *Tìm kiếm giải đấu*:
  - Nhập năm $\rightarrow$ Nhấn "Tìm kiếm" $\rightarrow$ Hiển thị danh sách giải (hoặc thông báo không tìm thấy giải).
  - Nhấn "Sửa" tại 1 giải $\rightarrow$ Chuyển sang Trạng thái 5: *Sửa chi tiết giải đấu*.
* Tại *Sửa chi tiết giải đấu*:
  - Nhấn "Hủy" $\rightarrow$ Quay lại trang danh sách giải đấu.
  - Nhấn "Lưu thay đổi" $\rightarrow$ Dữ liệu được ghi vào DB $\rightarrow$ Hiển thị thông báo thành công $\rightarrow$ Quay lại trang danh sách.

### 3.2. Phân hệ Cập nhật kết quả từng vòng đấu
* Từ Trang quản lý chính $\xrightarrow{\text{Chọn Cập nhật kết quả}}$ Chuyển sang *Tìm kiếm giải đấu*.
* Chọn một giải đấu $\rightarrow$ Chuyển sang *Giao diện chọn vòng đấu*.
* **Kiểm tra tiến độ vòng đấu (Ràng buộc nghiệp vụ bắt buộc)**:
  - Nếu vòng đấu có trạng thái `Chưa bắt đầu` $\rightarrow$ **Kích hoạt trạng thái cảnh báo**: *"Vòng đấu chưa diễn ra"* $\rightarrow$ Nhấn OK quay lại danh sách vòng đấu.
  - Nếu vòng đấu có trạng thái `Đang diễn ra` $\rightarrow$ Chuyển sang *Giao diện tìm kiếm trận đấu theo bàn*.
* Tại *Giao diện tìm kiếm trận đấu theo bàn*:
  - Nhập số bàn $\rightarrow$ Hiển thị danh sách trận $\rightarrow$ Chọn trận đấu $\rightarrow$ Chuyển sang *Chi tiết trận đấu*.
* Tại *Chi tiết trận đấu*:
  - Xem thông tin kỳ vọng thắng $\rightarrow$ Bấm "Nhập kết quả" $\rightarrow$ Chuyển sang *Giao diện nhập điểm*.
* Tại *Giao diện nhập điểm*:
  - Nhập điểm $\rightarrow$ Bấm "Tính điểm":
    - Nếu bộ điểm không hợp lệ $\rightarrow$ Cảnh báo lỗi $\rightarrow$ Giữ nguyên form.
    - Nếu bộ điểm hợp lệ $\rightarrow$ Tự động tính Elo theo FIDE $\rightarrow$ Chuyển sang *Giao diện xác nhận Elo*.
* Tại *Giao diện xác nhận Elo*:
  - Nhấn "Lưu kết quả" $\rightarrow$ Ghi nhận vào DB $\rightarrow$ Hiển thị thông báo thành công $\rightarrow$ Quay lại danh sách trận.

