# AGENT ENTRY GUIDE: WORLD CHESS CHAMPIONSHIP MANAGEMENT SYSTEM (PTTK HTTT - PTIT)

> **DÀNH CHO AI AGENT TIẾP QUẢN DỰ ÁN**: 
> Tài liệu này được thiết kế theo cấu trúc kim tự tháp ngược (thông tin tối quan trọng ở trên cùng, chi tiết kỹ thuật ở phía dưới). Bất kỳ AI Agent nào (Claude, ChatGPT, Gemini, DeepSeek...) khi tiếp nhận workspace này cần đọc file này đầu tiên để nắm bắt ngay ngữ cảnh, quy tắc bất biến, trạng thái hiện tại và các bước tiếp theo mà không làm sai lệch ý đồ của người dùng.

---

## 1. THÔNG TIN TỐI QUAN TRỌNG (CRITICAL - BẮT BUỘC TUÂN THỦ 100%)

1. **CHƯA ĐƯỢC PHÉP VIẾT MÃ NGUỒN (SOURCE CODE)** khi chưa có lệnh xác nhận từ người dùng ("Vẫn chưa code luôn nhé").
2. **PHẠM VI CHỨC NĂNG (SCOPE)**:
   - **LÀM 2 CHỨC NĂNG**:
     1. `Quản lý thông tin giải đấu` (Trọng tâm: Tìm kiếm giải theo năm & Sửa thông tin giải đấu).
     2. `Cập nhật kết quả từng vòng đấu` (Trọng tâm: Tìm trận theo bàn $\rightarrow$ Xem chi tiết & kỳ vọng thắng $\rightarrow$ Nhập điểm FIDE $\rightarrow$ Tính biến động Elo $\rightarrow$ Lưu kết quả).
   - **TẠM THỜI DỪNG / KHÔNG LÀM**: Chức năng `Xem bảng xếp hạng kỳ thủ sau vòng đấu` (Thầy hướng dẫn phản hồi là phần này đang thiếu sót nên chưa triển khai).
3. **SƠ ĐỒ TUẦN TỰ (DESIGN SEQUENCE DIAGRAM) CŨ ĐANG SAI**:
   - Thầy giáo đã nhận xét các file `DesignSequenceDiagram/*.png` trong thư mục `PTTKCoVua` bị sai. **KHÔNG ĐƯỢC dùng chúng làm điểm quy chiếu**.
   - **Lý do sai**: Nhóm sinh viên đã tự ý đưa đối tượng `HTTP : Session` thành một Lifeline độc lập và lạm dụng `setAttribute / getAttribute` làm rối luồng.
   - **Chuẩn quy chiếu chuẩn**: Tham khảo 100% bài giảng mẫu của thầy tại blog bộ môn: `https://softwaredesign.home.blog/tutorials/he-thong-quan-li-dang-ki-tin-chi-va-diem-sinh-vien/thiet-ke-dong-bieu-do-hoat-dong-va-bieu-do-tuan-tu-cho-tung-modul/` (Đã được kéo về lưu tại `instructor_tutorials/`).
4. **QUY TẮC BẢO TOÀN VÀ SAO LƯU TÀI LIỆU (DOCUMENTATION BACKUP POLICY)**:
   - Mọi file tài liệu (`.md`) phải mang tính **khách quan 100%**, không chứa nhận định chủ quan, chỉ chứa yêu cầu của người dùng và dữ liệu kỹ thuật thực tế.
   - **TRƯỚC KHI CHỈNH SỬA BẤT KỲ FILE TÀI LIỆU NÀO**:
     - Phải tạo ngay bản sao lưu trong thư mục `backup-documentation/`.
     - Cấu trúc thư mục của `backup-documentation/` phải **phản chiếu 1:1 cây thư mục của dự án** (ví dụ: muốn sửa `docs/design/DATABASE_SPEC.md` thì phải copy bản cũ sang `backup-documentation/docs/design/DATABASE_SPEC_backup_[YYYYMMDD_HHMMSS].md`).
     - **Bắt buộc ghi nhận vào file `ENTRY_LOG.md`**: (1) Danh sách cụ thể các file được sửa đổi và (2) Ý tưởng chung / Mục đích cốt lõi của việc sửa các file đó.
5. **QUY CHUẨN ĐẶT TÊN FILE GIAO DIỆN**:
   - Bắt buộc giữ đúng tên file JSP theo tài liệu:
     - `gdCoBan.jsp`, `gdLogin.jsp`, `doCheckLogin.jsp`, `gdTrangQuanLiGiaiCoVua.jsp`.
     - `gdTimKiemGiaiDau.jsp`, `gdSuaThongTinGiaiDau.jsp`, `doCapNhatThongTinGiaiDau.jsp`.
     - `gdChonVongDau.jsp`, `gdChonTranDau.jsp`, `gdChiTietTranDau.jsp`, `gdNhapKetQua.jsp`, `gdTinhDiem.jsp`, `doLuuKetQua.jsp`.
6. **CHÍNH SÁCH QUẢN TRỊ TÁC TỬ & MA TRẬN PHÂN CẤP QUYẾT ĐỊNH (GOVERNANCE POLICY)**:
   - Tuân thủ nghiêm ngặt [`docs/policy/AGENT_GOVERNANCE_POLICY.md`](file:///d:/Opencode%20Workspace/PTTK/docs/policy/AGENT_GOVERNANCE_POLICY.md).
   - Tuyệt đối không tự ý quyết định theo suy nghĩ chủ quan (No rogue decisions).
   - Áp dụng **Ma trận Phân cấp Quyết định 3 Cấp độ**:
     - *Cấp 1 (Tự chủ)*: Chi tiết cú pháp, code getter/setter, CSS, SQL chuẩn $\rightarrow$ Tự làm.
     - *Cấp 2 (Thông báo)*: Thêm class utility, format ngày, comment code $\rightarrow$ Tự làm và thông báo trong câu trả lời.
     - *Cấp 3 (Cổng kiểm soát bắt buộc - Critical Boundary)*: Đổi Scope (tự ý code Xem BXH), đổi Schema CSDL, đổi Tomcat 9, đổi tên file JSP, hoặc chuyển pha sang viết code $\rightarrow$ **BẮT BUỘC DỪNG LẠI XIN LỆNH NGƯỜI DÙNG**.

---

## 2. BẢN CHẤT DỰ ÁN & KIẾN TRÚC HỆ THỐNG (HIGH PRIORITY)

### 2.1. Ngữ cảnh dự án
- **Học phần**: Phân tích và Thiết kế Hệ thống Thông tin (PTTK HTTT) - Học viện Công nghệ Bưu chính Viễn thông (PTIT).
- **Quy trình áp dụng**: **Unified Process (UP / USDP)** (Use-case driven, Architecture-centric, Iterative).
- **Đề tài**: Hệ thống quản lý giải cờ vua vô địch thế giới (Nhóm BTL N09, Lớp D23CTAT01-B, sinh viên Nguyễn Đức Ngọc B23DCAT215).

### 2.2. Kiến trúc Công nghệ (Tech Stack)
- **Kiến trúc phần mềm**: **JSP Model 1 + DAO (JavaBean)** theo đúng giáo trình của bộ môn PTIT:
  - Tầng Boundary (`src/main/webapp/`): Các trang `gd*.jsp` hiển thị view, gọi DAO để lấy dữ liệu đổ ra HTML table/form. Các trang `do*.jsp` tiếp nhận submit request, tạo đối tượng thực thể, gọi DAO lưu dữ liệu, bật JavaScript `alert()` và điều hướng.
  - Tầng Control / DAO (`com.pttk.dao`): Kế thừa lớp cơ sở `DAO` quản lý `Connection`. Gồm `TVHTDAO`, `GiaiDauDAO`, `VongDauDAO`, `TranDauDAO`, `KyThuThamGiaTranDauDAO`.
  - Tầng Entity (`com.pttk.model`): `User`, `TVHT`, `BTC`, `KyThu`, `GiaiDau`, `VongDau`, `TranDau`, `BanDau`, `KyThuThamGiaTranDau`.
- **Web Server**: **Apache Tomcat 9** (Sử dụng chuẩn `javax.servlet.*`, tương thích Java 8/11/17, không dùng Tomcat 10+ vì tránh xung đột namespace `jakarta.*`).
- **Cơ sở dữ liệu**: **MySQL 8.0** chạy hoàn toàn qua **Docker** (`docker-compose.yml`). Người dùng không cài MySQL cục bộ hoặc quên tài khoản root, do đó hệ thống DB phải được tự động hóa qua Docker container với cổng mặc định `3306`, user `root`, password `root123`, tự động chạy script `init.sql`.

---

## 3. NGHIỆP VỤ CỜ VUA & QUY TẮC DỮ LIỆU (MEDIUM PRIORITY)

### 3.1. Công thức tính điểm FIDE & Hệ số Elo
1. **Điểm trận đấu**:
   - Thắng: `1.0` điểm, Hòa: `0.5` điểm, Thua: `0.0` điểm.
   - Các cặp điểm hợp lệ duy nhất: `(1.0 - 0.0)`, `(0.5 - 0.5)`, `(0.0 - 1.0)`. Mọi cặp điểm khác đều phải bị chặn và báo lỗi validate.
2. **Kỳ vọng thắng (Expected Score $E$)**:
   $$E_A = \frac{1}{1 + 10^{(R_B - R_A)/400}}, \quad E_B = 1 - E_A$$
3. **Biến động Elo ($\Delta ELO$)**:
   $$\Delta R_A = \text{round}(K \times (S_A - E_A)), \quad \Delta R_B = \text{round}(K \times (S_B - E_B))$$
   - Hệ số $K$ lấy từ thuộc tính `heSoThang` của kỳ thủ và **được cố định từ đầu giải đấu** (không biến thiên).

### 3.2. Yêu cầu Kiểm thử Biên (Boundary Testing)
Dữ liệu khởi tạo trong Database phải thiết kế để phục vụ đầy đủ pha Testing:
- **Tìm kiếm bàn đấu**: Khi người dùng nhập từ khóa `"11"`, DB phải có:
  - Bàn `"11"` (khớp chính xác).
  - Bàn `"110"`, `"115"` (từ khóa ở đầu).
  - Bàn `"011"`, `"211"` (từ khóa ở cuối).
  - Bàn `"111"` (trùng lặp).
  - Bàn `"01"`, `"102"` (không chứa từ khóa).
- **Tìm kiếm năm giải đấu**: Năm có nhiều giải (`2024`), năm đang diễn ra (`2026`), năm hoàn toàn không có giải nào (`2025` để kiểm tra exception "Không tồn tại giải đấu").
- **Trạng thái vòng đấu**: Vòng `Đang diễn ra` (cho phép nhập điểm), vòng `Chưa bắt đầu` (chặn và báo lỗi "Vòng đấu chưa diễn ra").

---

## 4. BẢN ĐỒ TRI THỨC SECOND BRAIN (MAP OF CONTENT)

Khi cần tra cứu sâu từng phần, truy cập các file markdown theo cấu trúc:

| Hạng mục | File tài liệu chi tiết | Mô tả nội dung |
| :--- | :--- | :--- |
| **Bản đồ chỉ mục** | [`ENTRY_LOG.md`](file:///d:/Opencode%20Workspace/PTTK/ENTRY_LOG.md) | Entry log, cấu trúc Second Brain & Lịch sử cập nhật |
| **Tổng quan dự án** | [`PROJECT_OVERVIEW.md`](file:///d:/Opencode%20Workspace/PTTK/PROJECT_OVERVIEW.md) | Tài liệu khách quan tổng thể về dự án |
| **Pha Requirement** | [`docs/requirements/REQUIREMENTS_SPEC.md`](file:///d:/Opencode%20Workspace/PTTK/docs/requirements/REQUIREMENTS_SPEC.md) | Actor, Use Case, Đặc tả nghiệp vụ |
| **Pha Analysis** | [`docs/analysis/ANALYSIS_MODELS.md`](file:///d:/Opencode%20Workspace/PTTK/docs/analysis/ANALYSIS_MODELS.md) | Scenario v2, State diagrams, Boundary/Control/Entity |
| **Thiết kế CSDL** | [`docs/design/DATABASE_SPEC.md`](file:///d:/Opencode%20Workspace/PTTK/docs/design/DATABASE_SPEC.md) | Cấu trúc bảng, Data Dictionary, PK/FK |
| **Thiết kế Tĩnh** | [`docs/design/STATIC_CLASS_DESIGN.md`](file:///d:/Opencode%20Workspace/PTTK/docs/design/STATIC_CLASS_DESIGN.md) | Thiết kế Boundary JSP, DAO, Entity |
| **Thiết kế Động** | [`docs/design/DYNAMIC_FLOW_DESIGN.md`](file:///d:/Opencode%20Workspace/PTTK/docs/design/DYNAMIC_FLOW_DESIGN.md) | Activity & Sequence Diagram chuẩn hóa (Không Session) |
| **Pha Testing** | [`docs/testing/BOUNDARY_TEST_CASES.md`](file:///d:/Opencode%20Workspace/PTTK/docs/testing/BOUNDARY_TEST_CASES.md) | Ma trận kiểm thử biên & phân vùng tương đương |
| **Chính sách Quản trị** | [`docs/policy/AGENT_GOVERNANCE_POLICY.md`](file:///d:/Opencode%20Workspace/PTTK/docs/policy/AGENT_GOVERNANCE_POLICY.md) | Ma trận phân cấp quyết định & bảo vệ quyền quyết định của User |
| **Triển khai** | [`docs/deployment/DEPLOYMENT_DOCKER_TOMCAT.md`](file:///d:/Opencode%20Workspace/PTTK/docs/deployment/DEPLOYMENT_DOCKER_TOMCAT.md) | Cấu hình Docker MySQL 8.0 & Apache Tomcat 9 |

---

## 5. TRẠNG THÁI HIỆN TẠI & KẾ HOẠCH BÀN GIAO TIẾP THEO

- **Trạng thái hiện tại**: Đã nghiên cứu toàn bộ tài liệu Word và hình ảnh biểu đồ trong `PTTKCoVua/`, đã đối chiếu bài mẫu của giảng viên tại `instructor_tutorials/`, đã thiết lập hệ thống tài liệu Second Brain và cơ chế sao lưu.
- **Kế hoạch hành động khi Người dùng cho phép lập trình**:
  1. Soạn thảo `docker-compose.yml` và `sql/init_database.sql` (chứa toàn bộ schema và dữ liệu test biên).
  2. Khởi tạo cấu trúc dự án Maven chuẩn Dynamic Web App (Tomcat 9, Java EE, JSTL, MySQL Connector).
  3. Lập trình tầng Entity (`com.pttk.model`) và tầng DAO (`com.pttk.dao`).
  4. Lập trình tầng JSP (`src/main/webapp/`) tuân thủ nghiêm ngặt 2 module theo danh sách tên file chuẩn.
  5. Kiểm thử tích hợp các luồng chính và ca kiểm thử biên.

