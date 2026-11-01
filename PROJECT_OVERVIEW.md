# PROJECT OVERVIEW: WORLD CHESS CHAMPIONSHIP MANAGEMENT SYSTEM

> **TÀI LIỆU TỔNG QUAN TRI THỨC TOÀN DIỆN VỀ DỰ ÁN**
> Tài liệu này được biên soạn trên cơ sở khách quan 100%, tổng hợp toàn bộ yêu cầu của người dùng, báo cáo đề tài của nhóm sinh viên B23DCAT215 (Học viện Công nghệ Bưu chính Viễn thông) và chuẩn mực thiết kế theo bài giảng bộ môn.

---

## 1. THÔNG TIN CHUNG VỀ ĐỀ TÀI

* **Tên đề tài**: Hệ thống quản lý giải cờ vua vô địch thế giới (World Chess Championship Management System).
* **Học phần**: Phân tích và Thiết kế Hệ thống Thông tin (PTTK HTTT).
* **Đơn vị đào tạo**: Khoa Công nghệ Thông tin 1 - Học viện Công nghệ Bưu chính Viễn thông (PTIT).
* **Nhóm thực hiện**: Nhóm BTL N09 - Lớp D23CTAT01-B (Sinh viên Nguyễn Đức Ngọc - B23DCAT215, Nguyễn Đức Mạnh - B23DCAT182, Nguyễn Hoàng Nam - B23DCAT206).
* **Phương pháp luận phát triển**: **Unified Process (UP / USDP)**:
  - Tiếp cận hướng use-case (Use-Case Driven).
  - Lấy kiến trúc làm trung tâm (Architecture-Centric).
  - Lặp và tăng dần (Iterative & Incremental).
  - Phân tách theo 5 luồng quy trình chính: *Requirement*, *Analysis*, *Design*, *Implementation*, *Testing*.

---

## 2. PHẠM VI TRIỂN KHAI (MODULE M2)

Theo phân công bài tập lớn và chỉ đạo cập nhật từ giảng viên hướng dẫn:

### 2.1. Các chức năng TRỌNG TÂM TRIỂN KHAI (Active Scope)
1. **Quản lý thông tin giải đấu**:
   - Actor: Ban tổ chức (BTC).
   - Nghiệp vụ: Đăng nhập vào hệ thống $\rightarrow$ Tìm kiếm giải đấu theo năm $\rightarrow$ Hiển thị danh sách giải đấu $\rightarrow$ Chọn một giải đấu cụ thể để "Sửa" $\rightarrow$ Hiển thị form nạp sẵn dữ liệu cũ $\rightarrow$ Chỉnh sửa các trường (năm, variant, mùa, thời gian, địa điểm, mô tả) $\rightarrow$ Kiểm tra tính hợp lệ dữ liệu $\rightarrow$ Lưu cập nhật vào CSDL $\rightarrow$ Thông báo thành công và quay lại danh sách.
2. **Cập nhật kết quả từng vòng đấu**:
   - Actor: Ban tổ chức (BTC).
   - Nghiệp vụ: Đăng nhập $\rightarrow$ Lọc tìm giải đấu theo năm $\rightarrow$ Chọn giải đấu đang diễn ra $\rightarrow$ Hiển thị danh sách vòng đấu $\rightarrow$ Chọn vòng đấu có trạng thái `Đang diễn ra` (chặn nếu vòng `Chưa bắt đầu`) $\rightarrow$ Tìm kiếm trận đấu theo Bàn đấu $\rightarrow$ Xem chi tiết trận đấu và kỳ vọng thắng $\rightarrow$ Nhập điểm số thực tế ($1-0, 0.5-0.5, 0-1$) $\rightarrow$ Hệ thống tự động tính biến động điểm Elo theo công thức chuẩn FIDE $\rightarrow$ Hiển thị xác nhận Elo mới $\rightarrow$ Lưu kết quả và cập nhật Elo vào CSDL.

### 2.2. Chức năng TẠM HOÃN TRIỂN KHAI (Out of Scope / On Hold)
* **Xem bảng xếp hạng kỳ thủ sau vòng đấu**: Giảng viên hướng dẫn đã đánh giá phần thiết kế này còn thiếu sót và chưa hoàn thiện ở pha hiện tại. Chức năng này **tạm thời chưa được lập trình** cho đến khi có yêu cầu bổ sung từ người dùng.

---

## 3. KIẾN TRÚC KỸ THUẬT & PHƯƠNG THỨC HOẠT ĐỘNG

### 3.1. Mô hình Phân lớp (Layered Pattern)
Dự án được xây dựng theo mô hình **JSP Model 1 + DAO (JavaBean)** bám sát bài giảng mẫu của bộ môn PTIT:

1. **Tầng Giao diện (Boundary Layer - JSP)**:
   - Các trang hiển thị (`gd*.jsp`): Chịu trách nhiệm render giao diện HTML/CSS, nhận request từ người dùng, gọi trực tiếp các phương thức của DAO để lấy dữ liệu đổ vào bảng và biểu mẫu.
   - Các trang xử lý hành động (`do*.jsp`): Nhận các tham số HTTP POST/GET, khởi tạo và đóng gói dữ liệu vào các đối tượng Entity, gọi các phương thức cập nhật/thêm mới của DAO, hiển thị thông báo alert và chuyển hướng trang.
2. **Tầng Thao tác Dữ liệu (Control / DAO Layer)**:
   - Lớp cơ sở `DAO.java`: Chịu trách nhiệm mở và quản lý kết nối JDBC `Connection` đến CSDL.
   - Các lớp DAO chuyên trách: `TVHTDAO`, `GiaiDauDAO`, `VongDauDAO`, `TranDauDAO`, `KyThuThamGiaTranDauDAO` kế thừa từ `DAO`.
3. **Tầng Thực thể (Entity / Model Layer)**:
   - Các lớp đối tượng nghiệp vụ thuần túy (POJO): `User`, `TVHT`, `BTC`, `KyThu`, `GiaiDau`, `VongDau`, `TranDau`, `BanDau`, `KyThuThamGiaTranDau`.

### 3.2. Môi trường Thực thi (Runtime Environment)
* **Web Container**: **Apache Tomcat 9** (Sử dụng chuẩn `javax.servlet.*`, tương thích hoàn toàn với mã nguồn mẫu của bộ môn, tránh xung đột namespace `jakarta.*`).
* **Hệ quản trị CSDL**: **MySQL 8.0** chạy độc lập trên **Docker Container** (`docker-compose.yml`), cổng mặc định `3306`, tự động khởi tạo bảng và dữ liệu mẫu qua file `init.sql`.

---

## 4. QUY TẮC NGHIỆP VỤ CỜ VUA & CÔNG THỨC TOÁN HỌC

### 4.1. Quy tắc Điểm số Trận đấu FIDE
* Kỳ thủ thắng: nhận `1.0` điểm (đối thủ nhận `0.0` điểm).
* Kỳ thủ hòa: mỗi người nhận `0.5` điểm.
* Kỳ thủ thua: nhận `0.0` điểm (đối thủ nhận `1.0` điểm).
* **Ràng buộc kiểm tra tính hợp lệ**: Bộ điểm nhập vào $(S_1, S_2)$ chỉ hợp lệ khi $S_1 + S_2 = 1.0$ với $S_1, S_2 \in \{0.0, 0.5, 1.0\}$.

### 4.2. Công thức tính Kỳ vọng thắng (Expected Score)
Với hai kỳ thủ $A$ và $B$ có hệ số Elo hiện tại là $R_A$ và $R_B$:
$$E_A = \frac{1}{1 + 10^{(R_B - R_A)/400}}$$
$$E_B = \frac{1}{1 + 10^{(R_A - R_B)/400}} = 1 - E_A$$

### 4.3. Công thức tính Biến động Elo ($\Delta ELO$)
$$\Delta R_A = \text{round}(K \times (S_A - E_A))$$
$$\Delta R_B = \text{round}(K \times (S_B - E_B))$$
Trong đó:
* $S_A, S_B$ là điểm số thực tế của trận đấu.
* $K$ là hệ số phát triển lấy từ thuộc tính `heSoThang` của kỳ thủ, **được ấn định cố định từ đầu giải đấu**.
* Điểm Elo mới: $R'_{A} = R_A + \Delta R_A$.

---

## 5. MA TRẬN DỮ LIỆU & CHIẾN LƯỢC KIỂM THỬ BIÊN (BOUNDARY TESTING)

Để đáp ứng tiêu chí đánh giá khắt khe trong pha Testing của môn học, dữ liệu hệ thống được thiết lập phục vụ các ca kiểm thử:

1. **Tìm kiếm Bàn đấu (Keyword = `"11"`)**:
   - Ca biên khớp tuyệt đối: Bàn số `"11"`.
   - Ca biên chuỗi ở đầu: Bàn số `"110"`, `"115"`.
   - Ca biên chuỗi ở cuối: Bàn số `"011"`, `"211"`.
   - Ca biên lặp ký tự: Bàn số `"111"`.
   - Ca biên ngoại lai (không khớp): Bàn số `"01"`, `"102"` (không được xuất hiện trong kết quả tìm kiếm).
2. **Tìm kiếm Năm giải đấu**:
   - Ca năm có nhiều giải: `2024` (trả về danh sách nhiều mùa giải và thể thức).
   - Ca năm đang diễn ra: `2026` (chứa vòng đấu đang chạy).
   - Ca năm không tồn tại: `2025` (phải kích hoạt ngoại lệ thông báo không có giải đấu).
3. **Kiểm tra Tiến độ Vòng đấu**:
   - Vòng đấu `Đang diễn ra`: Cho phép đi tiếp vào nhập điểm.
   - Vòng đấu `Chưa bắt đầu`: Bắt buộc chặn và bật cảnh báo *"Vòng đấu chưa diễn ra"*.
4. **Kiểm tra Dữ liệu Điểm số Bất hợp lệ**:
   - Ca $(1.0, 1.0)$ $\rightarrow$ Báo lỗi hai kỳ thủ không thể cùng thắng.
   - Ca $(0.0, 0.0)$ $\rightarrow$ Báo lỗi hai kỳ thủ không thể cùng thua.
   - Ca $(1.0, 0.5)$, $(0.5, 0.0)$ $\rightarrow$ Báo lỗi tổng điểm không bằng 1.

