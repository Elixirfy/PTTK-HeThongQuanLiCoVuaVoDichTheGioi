# REQUIREMENTS SPECIFICATION: MODULE M2

> **ĐẶC TẢ YÊU CẦU NGHIỆP VỤ & USE CASE HỆ THỐNG**
> Vị trí: `docs/requirements/REQUIREMENTS_SPEC.md`
> Phục vụ: Pha Requirement trong quy trình Unified Process

---

## 1. MỤC TIÊU & PHẠM VI HỆ THỐNG

### 1.1. Mục tiêu
Xây dựng phân hệ trang web phục vụ công tác quản lý thông tin giải đấu và cập nhật kết quả từng vòng đấu của giải vô địch cờ vua thế giới.

### 1.2. Phân loại Tác nhân (Actors)
* **Khách / Người dùng (User)**: Tác nhân trừu tượng, có thể truy cập các trang công khai.
* **Thành viên hệ thống (TVHT)**: Kế thừa từ `User`, sở hữu tài khoản xác thực. Có các chức năng: Đăng nhập, Đăng xuất, Đổi mật khẩu/Thông tin.
* **Ban tổ chức (BTC)**: Kế thừa từ `TVHT`, có quyền thực thi nghiệp vụ quản lý giải đấu và nhập kết quả trận đấu.
* **Kỳ thủ (KyThu)**: Kế thừa từ `TVHT`, đóng vai trò là đấu thủ tham gia các trận đấu trong giải.

---

## 2. ĐẶC TẢ CHI TIẾT CÁC USE CASE TRIỂN KHAI

### 2.1. Use Case 1: Quản lý thông tin giải đấu (Trọng tâm: Sửa giải đấu)
* **Actor chính**: Ban tổ chức (BTC).
* **Tiền điều kiện**: BTC đã đăng nhập thành công vào hệ thống với thông tin tài khoản hợp lệ.
* **Hậu điều kiện**: Thông tin giải đấu được cập nhật chính xác trong CSDL và hiển thị trên giao diện danh sách.
* **Luồng sự kiện chính (Main Flow)**:
  1. BTC đăng nhập vào hệ thống $\rightarrow$ Trang chủ BTC hiển thị (`gdTrangQuanLiGiaiCoVua.jsp`).
  2. BTC nhấp chọn chức năng "Quản lý thông tin giải đấu".
  3. Hệ thống hiển thị giao diện tìm kiếm giải đấu (`gdTimKiemGiaiDau.jsp`) với ô nhập năm tìm kiếm.
  4. BTC nhập năm tổ chức (ví dụ: `2024`) và nhấn nút "Tìm kiếm".
  5. Hệ thống truy vấn CSDL và hiển thị bảng danh sách các giải đấu tổ chức trong năm đó. Mỗi dòng bao gồm: Mã, Năm, Thể loại (Variant), Mùa giải, Thời gian, Địa điểm, Mô tả, Trạng thái kèm hai thao tác `[Sửa]` và `[Xóa]`.
  6. BTC nhấn chọn liên kết `[Sửa]` tại giải đấu cần điều chỉnh.
  7. Hệ thống mở giao diện "Sửa thông tin giải đấu" (`gdSuaThongTinGiaiDau.jsp`), điền sẵn toàn bộ dữ liệu hiện tại của giải đấu.
  8. BTC chỉnh sửa các thông tin cần thiết và bấm "Lưu thay đổi".
  9. Hệ thống chuyển tiếp dữ liệu đến trang xử lý (`doCapNhatThongTinGiaiDau.jsp`), kiểm tra tính hợp lệ và gọi DAO cập nhật vào CSDL.
  10. Hệ thống hiển thị thông báo "Sửa thông tin giải đấu thành công!" và điều hướng quay lại trang danh sách giải đấu.
* **Luồng ngoại lệ (Exceptions)**:
  - *Không tìm thấy giải đấu*: Nếu không có giải đấu nào trong năm nhập vào, hệ thống hiển thị bảng trống kèm thông báo "Không tồn tại giải đấu trong năm [Năm]".
  - *Dữ liệu nhập không hợp lệ*: Nếu để trống các trường bắt buộc hoặc ngày bắt đầu lớn hơn ngày kết thúc, hệ thống hiển thị cảnh báo lỗi và giữ nguyên form sửa.

---

### 2.2. Use Case 2: Cập nhật kết quả từng vòng đấu
* **Actor chính**: Ban tổ chức (BTC).
* **Tiền điều kiện**: BTC đã đăng nhập thành công vào hệ thống.
* **Hậu điều kiện**: Kết quả trận đấu được lưu lại, điểm số và hệ số Elo của hai kỳ thủ được cập nhật.
* **Luồng sự kiện chính (Main Flow)**:
  1. BTC chọn chức năng "Cập nhật kết quả sau vòng đấu" từ trang chủ quản trị.
  2. Hệ thống hiển thị giao diện tìm kiếm giải đấu kèm danh sách các giải đấu.
  3. BTC nhập năm tổ chức và nhấn "Tìm kiếm" $\rightarrow$ chọn giải đấu mong muốn.
  4. Hệ thống hiển thị danh sách các vòng đấu của giải đấu đã chọn (`gdChonVongDau.jsp`).
  5. BTC nhấp chọn một vòng đấu có trạng thái **`Đang diễn ra`**.
  6. Hệ thống chuyển sang giao diện danh sách trận đấu (`gdChonTranDau.jsp`) có tích hợp ô tìm kiếm theo Bàn đấu.
  7. BTC nhập số Bàn đấu (hoặc để trống xem tất cả) và nhấn "Tìm kiếm".
  8. Hệ thống lọc và hiển thị danh sách các trận đấu tương ứng trên bàn đó.
  9. BTC nhấp chọn trận đấu cần nhập điểm.
  10. Hệ thống hiển thị giao diện "Thông tin chi tiết trận đấu" (`gdChiTietTranDau.jsp`) gồm: Mã trận, Bàn đấu, Họ tên, Mã và Kỳ vọng thắng ($E$) của Kỳ thủ 1 và Kỳ thủ 2.
  11. BTC bấm nút "Nhập kết quả trận đấu" $\rightarrow$ Trang `gdNhapKetQua.jsp` hiển thị.
  12. BTC chọn kết quả điểm số cho từng kỳ thủ:
      - Kỳ thủ 1 thắng: chọn `1.0` (Kỳ thủ 2 chọn `0.0`).
      - Hai kỳ thủ hòa: chọn `0.5` cho cả hai kỳ thủ.
      - Kỳ thủ 2 thắng: chọn `0.0` (Kỳ thủ 2 chọn `1.0`).
  13. BTC bấm "Tính điểm". Hệ thống kiểm tra tính hợp lệ của cặp điểm. Nếu hợp lệ, hệ thống áp dụng công thức FIDE tính ra biến động Elo ($\Delta ELO$) và Elo mới.
  14. Hệ thống chuyển sang trang xác nhận `gdTinhDiem.jsp` hiển thị số Elo mới sau cộng/trừ.
  15. BTC nhấn "Lưu kết quả" $\rightarrow$ Trang `doLuuKetQua.jsp` gọi DAO lưu kết quả trận và cập nhật Elo mới vào CSDL, hiển thị thông báo thành công và quay lại danh sách trận đấu.
* **Luồng ngoại lệ (Exceptions)**:
  - *Vòng đấu chưa diễn ra*: Nếu BTC bấm vào một vòng đấu có trạng thái `Chưa bắt đầu`, hệ thống chặn lại và hiển thị cảnh báo "Lỗi! Vòng đấu chưa diễn ra".
  - *Bộ điểm không hợp lệ*: Nếu BTC chọn hai kỳ thủ cùng thắng $(1, 1)$, cùng thua $(0, 0)$ hoặc tổng điểm khác 1, hệ thống hiển thị thông báo lỗi điểm không hợp lệ và yêu cầu nhập lại.

---

## 3. TRẠNG THÁI CHỨC NĂNG "XEM BẢNG XẾP HẠNG"
Chức năng này **tạm thời không triển khai** theo yêu cầu của giảng viên hướng dẫn. Tuy nhiên, toàn bộ cấu trúc CSDL và mô hình dữ liệu bên dưới vẫn bảo đảm tính toàn vẹn để có thể mở rộng bổ sung chức năng này trong tương lai mà không làm thay đổi cấu trúc bảng.

