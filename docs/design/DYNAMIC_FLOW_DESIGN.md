# DYNAMIC FLOW DESIGN (ACTIVITY & STANDARDIZED SEQUENCE MODELS)

> **THIẾT KẾ ĐỘNG CHUẨN HÓA: BIỂU ĐỒ HOẠT ĐỘNG & BIỂU ĐỒ TUẦN TỰ PHIÊN BẢN 3**
> Vị trí: `docs/design/DYNAMIC_FLOW_DESIGN.md`
> Phục vụ: Pha Design theo quy trình Unified Process & bài giảng mẫu PTIT

---

## 1. NGUYÊN TẮC CHUẨN HÓA BIỂU ĐỒ TUẦN TỰ (CHUẨN BÀI GIẢNG BỘ MÔN)

Để khắc phục hoàn toàn các lỗi trong bản vẽ cũ theo góp ý của giảng viên hướng dẫn:
1. **Loại bỏ đường sinh mệnh `HTTP : Session`**: Trong mô hình thiết kế tuần tự chuẩn của bộ môn, Session chỉ là cơ chế lưu trữ kỹ thuật của web server, không biểu diễn thành một Lifeline độc lập tham gia tương tác trao đổi thông điệp nghiệp vụ.
2. **Quy tắc tương tác giữa các trang JSP**:
   - Actor tương tác lên trang `gdA.jsp`.
   - `gdA.jsp` gửi HTTP Request (qua Submit form hoặc Hyperlink kèm tham số) tới `gdB.jsp`.
   - Tại `gdB.jsp`, trang này chủ động gọi đến các phương thức tương ứng của `XxxDAO` để truy xuất hoặc đóng gói đối tượng thực thể `Xxx`.
   - Dữ liệu trả về được `gdB.jsp` hiển thị trực tiếp cho Actor.
3. **Quy tắc lưu trữ qua trang hành động (`do*.jsp`)**:
   - Trang form nhập liệu `gdSua/gdNhap.jsp` gửi toàn bộ dữ liệu form sang trang `do*.jsp`.
   - `do*.jsp` khởi tạo đối tượng Entity, gọi phương thức `update/add` của `DAO`.
   - `do*.jsp` hiển thị Alert thông báo thành công và redirect quay lại trang danh sách.

---

## 2. KỊCH BẢN TUẦN TỰ PHIÊN BẢN 3 (SCENARIO V3)

### 2.1. Phân hệ Quản lý thông tin giải đấu (Sửa thông tin)
1. BTC click chọn "Đăng nhập" tại `gdCoBan.jsp`.
2. Trình duyệt gửi request chuyển đến `gdLogin.jsp`.
3. `gdLogin.jsp` hiển thị form đăng nhập cho BTC.
4. BTC nhập `username`, `password` và nhấn nút "Đăng nhập".
5. `gdLogin.jsp` submit form gửi dữ liệu sang `doCheckLogin.jsp`.
6. `doCheckLogin.jsp` khởi tạo đối tượng `tvht` (`TVHT`) và gọi `TVHTDAO.checkLogin(tvht)`.
7. `TVHTDAO` kiểm tra CSDL, nạp các thuộc tính người dùng và trả về `true`.
8. `doCheckLogin.jsp` lưu thông tin đăng nhập và điều hướng sang `gdTrangQuanLiGiaiCoVua.jsp`.
9. `gdTrangQuanLiGiaiCoVua.jsp` hiển thị menu chức năng cho BTC.
10. BTC click chọn liên kết "Quản lý thông tin giải đấu".
11. Trình duyệt mở trang `gdTimKiemGiaiDau.jsp`.
12. BTC nhập năm tìm kiếm (ví dụ: `2024`) và nhấn nút "Tìm kiếm".
13. `gdTimKiemGiaiDau.jsp` gọi phương thức `GiaiDauDAO.searchGiaiDauBTC(nam)`.
14. `GiaiDauDAO` truy vấn CSDL, đóng gói danh sách các đối tượng `GiaiDau` và trả về.
15. `gdTimKiemGiaiDau.jsp` hiển thị bảng danh sách các giải đấu trong năm kèm liên kết `[Sửa]`.
16. BTC click vào liên kết `[Sửa]` của một giải đấu cụ thể (`gdSuaThongTinGiaiDau.jsp?id=...`).
17. `gdSuaThongTinGiaiDau.jsp` gọi `GiaiDauDAO.getGiaiDauById(id)` lấy thông tin chi tiết giải đấu và hiển thị lên các ô nhập liệu.
18. BTC chỉnh sửa các trường thông tin và nhấn nút "Lưu thay đổi".
19. `gdSuaThongTinGiaiDau.jsp` submit toàn bộ dữ liệu sang `doCapNhatThongTinGiaiDau.jsp`.
20. `doCapNhatThongTinGiaiDau.jsp` đóng gói dữ liệu vào đối tượng `GiaiDau` và gọi `GiaiDauDAO.updateGiaiDau(gd)`.
21. `GiaiDauDAO` thực thi câu lệnh SQL UPDATE và trả về kết quả thành công.
22. `doCapNhatThongTinGiaiDau.jsp` xuất JavaScript alert "Sửa thông tin giải đấu thành công!" và redirect về `gdTimKiemGiaiDau.jsp`.

---

### 2.2. Phân hệ Cập nhật kết quả từng vòng đấu
1. Tại `gdTrangQuanLiGiaiCoVua.jsp`, BTC click chọn "Cập nhật kết quả sau vòng đấu".
2. Trình duyệt mở `gdTimKiemGiaiDau.jsp`.
3. BTC nhập năm và nhấn "Tìm kiếm" $\rightarrow$ `GiaiDauDAO.searchGiaiDauBTC(nam)` trả về danh sách giải.
4. BTC click chọn một giải đấu đang diễn ra $\rightarrow$ Trình duyệt gọi `gdChonVongDau.jsp?idGiaiDau=...`.
5. `gdChonVongDau.jsp` gọi `VongDauDAO.getVongDauCuaBTC(idGiaiDau)` lấy danh sách các vòng đấu và hiển thị lên bảng.
6. BTC click chọn một vòng đấu có trạng thái `Đang diễn ra` $\rightarrow$ Trình duyệt chuyển sang `gdChonTranDau.jsp?idVongDau=...`. *(Nếu chọn vòng Chưa bắt đầu, trang chặn lại và thông báo lỗi)*.
7. Tại `gdChonTranDau.jsp`, BTC nhập từ khóa Bàn đấu (ví dụ: `"11"`) và bấm "Tìm kiếm".
8. `gdChonTranDau.jsp` đóng gói tiêu chí tìm kiếm và gọi `TranDauDAO.searchTranDauTheoBan(td)`.
9. `TranDauDAO` trả về danh sách các trận đấu trên bàn tương ứng.
10. BTC click chọn một trận đấu cụ thể $\rightarrow$ Trình duyệt gọi `gdChiTietTranDau.jsp?idTranDau=...`.
11. `gdChiTietTranDau.jsp` gọi `TranDauDAO.getChiTietTranDau(idTranDau)` lấy đầy đủ thông tin trận đấu, hai kỳ thủ và tính kỳ vọng thắng FIDE hiển thị cho BTC.
12. BTC nhấn nút "Nhập kết quả" $\rightarrow$ Trình duyệt mở form `gdNhapKetQua.jsp?idTranDau=...`.
13. BTC chọn điểm số cho Kỳ thủ 1 và Kỳ thủ 2 rồi bấm nút "Tính điểm".
14. `gdNhapKetQua.jsp` kiểm tra cặp điểm hợp lệ, áp dụng công thức FIDE tính ra $\Delta ELO$ và chuyển dữ liệu sang `gdTinhDiem.jsp`.
15. `gdTinhDiem.jsp` hiển thị bảng điểm Elo sau trận đấu để BTC xác nhận.
16. BTC nhấn nút "Lưu kết quả".
17. `gdTinhDiem.jsp` submit mảng 2 kết quả sang `doLuuKetQua.jsp`.
18. `doLuuKetQua.jsp` gọi `KyThuThamGiaTranDauDAO.addKetQua(kq)`.
19. `KyThuThamGiaTranDauDAO` cập nhật điểm trận, cộng trừ Elo trong `tblKyThu`, đổi trạng thái trận đấu thành `Kết thúc`.
20. `doLuuKetQua.jsp` xuất alert "Cập nhật kết quả trận đấu thành công!" và redirect về `gdChonTranDau.jsp`.

