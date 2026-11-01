# BOUNDARY VALUE & EQUIVALENCE PARTITIONING TEST MATRIX

> **MA TRẬN CA KIỂM THỬ BIÊN & PHÂN VÙNG TƯƠNG ĐƯƠNG (PHA TESTING)**
> Vị trí: `docs/testing/BOUNDARY_TEST_CASES.md`
> Phục vụ: Pha Testing theo quy trình Unified Process và yêu cầu chấm thi thực hành

---

## 1. MỤC TIÊU KIỂM THỬ BIÊN

Thiết kế bộ dữ liệu và kịch bản kiểm thử nhằm đánh giá độ bền (robustness), tính chính xác của các thuật toán tìm kiếm chuỗi, kiểm tra trạng thái và xác thực ràng buộc nghiệp vụ FIDE.

---

## 2. MA TRẬN CA KIỂM THỬ BIÊN CHI TIẾT

### 2.1. Phân hệ Tìm kiếm Bàn đấu (Kiểm thử chuỗi với từ khóa mục tiêu: `"11"`)

| Mã Test | Loại ca kiểm thử | Giá trị nhập vào | Dữ liệu mẫu kỳ vọng trong CSDL | Kết quả hiển thị mong đợi |
| :--- | :--- | :--- | :--- | :--- |
| `TC-BD-01` | **Khớp chính xác (Exact Match)** | `"11"` | Bàn `"Bàn 11"` | Hiển thị chính xác trận đấu trên Bàn 11 |
| `TC-BD-02` | **Biên đầu (Prefix Match)** | `"11"` | Bàn `"Bàn 110"`, `"Bàn 115"` | Hiển thị các trận đấu trên Bàn 110, 115 |
| `TC-BD-03` | **Biên cuối (Suffix Match)** | `"11"` | Bàn `"Bàn 011"`, `"Bàn 211"` | Hiển thị các trận đấu trên Bàn 011, 211 |
| `TC-BD-04` | **Biên lặp (Repeated String)** | `"11"` | Bàn `"Bàn 111"` | Hiển thị trận đấu trên Bàn 111 |
| `TC-BD-05` | **Biên âm tính (Negative / Non-match)** | `"11"` | Bàn `"Bàn 01"`, `"Bàn 101"`, `"Bàn 99"` | **Không được xuất hiện** trong danh sách kết quả lọc |
| `TC-BD-06` | **Chuỗi rỗng (Empty Input)** | `""` (để trống) | Toàn bộ các bàn trong vòng đấu | Hiển thị toàn bộ tất cả các trận đấu trong vòng |
| `TC-BD-07` | **Giá trị không tồn tại** | `"999"` | Không có bàn nào tương ứng | Bảng trống kèm thông báo "Không tìm thấy trận đấu nào trên bàn 999" |

---

### 2.2. Phân hệ Tìm kiếm Năm Giải đấu

| Mã Test | Loại ca kiểm thử | Giá trị nhập | Dữ liệu kỳ vọng trong CSDL | Kết quả mong đợi |
| :--- | :--- | :--- | :--- | :--- |
| `TC-GD-01` | **Nhiều kết quả (Multi-records)** | `2024` | 3 giải đấu (Classical Mùa 1, Classical Mùa 2, Rapid & Blitz) | Hiển thị đủ 3 dòng giải đấu trong bảng |
| `TC-GD-02` | **Một kết quả đang diễn ra** | `2026` | Giải Classical Mùa 2 tại Hà Nội | Hiển thị giải đấu năm 2026 với trạng thái "Đang diễn ra" |
| `TC-GD-03` | **Ngoại lệ không tồn tại (Zero record)** | `2025` | Không có giải đấu nào năm 2025 | Bảng trống kèm thông báo "Không tồn tại giải đấu trong năm 2025" |
| `TC-GD-04` | **Dữ liệu biên sai định dạng** | `-2024` hoặc `"abcd"` | Không truy vấn CSDL | Bắt lỗi validate tại trình duyệt: "Vui lòng nhập năm hợp lệ" |

---

### 2.3. Phân hệ Kiểm tra Trạng thái Vòng đấu

| Mã Test | Loại ca kiểm thử | Trạng thái vòng chọn | Hành động của BTC | Kết quả xử lý của hệ thống |
| :--- | :--- | :--- | :--- | :--- |
| `TC-VD-01` | **Hợp lệ (Đang diễn ra)** | `Đang diễn ra` | Nhấp chọn vòng đấu | Hệ thống cho phép truy cập tiếp vào `gdChonTranDau.jsp` |
| `TC-VD-02` | **Chặn ngoại lệ (Chưa bắt đầu)** | `Chưa bắt đầu` | Nhấp chọn vòng đấu | Hệ thống chặn lại, xuất cảnh báo: **"Lỗi! Vòng đấu chưa diễn ra."** và giữ nguyên trang |
| `TC-VD-03` | **Đã hoàn thành (Kết thúc)** | `Kết thúc` | Nhấp chọn vòng đấu | Hiển thị danh sách trận đấu ở chế độ xem kết quả |

---

### 2.4. Phân hệ Kiểm tra Ràng buộc Điểm số Trận đấu FIDE

| Mã Test | Loại ca kiểm thử | Điểm Kỳ thủ 1 | Điểm Kỳ thủ 2 | Kết quả kiểm tra tính hợp lệ |
| :--- | :--- | :--- | :--- | :--- |
| `TC-KQ-01` | **Kỳ thủ 1 thắng (Hợp lệ)** | `1.0` | `0.0` | Hợp lệ $\rightarrow$ Tự động tính Elo theo FIDE $\rightarrow$ Sang trang xác nhận |
| `TC-KQ-02` | **Hai kỳ thủ hòa (Hợp lệ)** | `0.5` | `0.5` | Hợp lệ $\rightarrow$ Tự động tính Elo theo FIDE $\rightarrow$ Sang trang xác nhận |
| `TC-KQ-03` | **Kỳ thủ 2 thắng (Hợp lệ)** | `0.0` | `1.0` | Hợp lệ $\rightarrow$ Tự động tính Elo theo FIDE $\rightarrow$ Sang trang xác nhận |
| `TC-KQ-04` | **Biên lỗi: Cùng thắng** | `1.0` | `1.0` | **Bất hợp lệ** $\rightarrow$ Báo lỗi: "Kết quả không hợp lệ, không thể cùng thắng!" |
| `TC-KQ-05` | **Biên lỗi: Cùng thua** | `0.0` | `0.0` | **Bất hợp lệ** $\rightarrow$ Báo lỗi: "Kết quả không hợp lệ, không thể cùng thua!" |
| `TC-KQ-06` | **Biên lỗi: Thắng - Hòa** | `1.0` | `0.5` | **Bất hợp lệ** $\rightarrow$ Báo lỗi: "Tổng điểm trận đấu phải bằng 1.0!" |
| `TC-KQ-07` | **Biên lỗi: Thua - Hòa** | `0.0` | `0.5` | **Bất hợp lệ** $\rightarrow$ Báo lỗi: "Tổng điểm trận đấu phải bằng 1.0!" |

