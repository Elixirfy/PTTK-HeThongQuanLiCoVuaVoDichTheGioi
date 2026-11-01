# AGENT GOVERNANCE & DECISION ESCALATION POLICY

> **CHÍNH SÁCH QUẢN TRỊ TÁC TỬ & MA TRẬN PHÂN CẤP QUYẾT ĐỊNH (MERIT & THINKING FRAMEWORK)**
> Vị trí: `docs/policy/AGENT_GOVERNANCE_POLICY.md`
> Hiệu lực: Bắt buộc áp dụng cho mọi AI Agent (Claude, ChatGPT, Gemini, DeepSeek...) khi thao tác trong workspace này.

---

## 1. NGUYÊN TẮC CỐT LÕI (CORE PRINCIPLES)

1. **Quyền Quyết định Tối cao của Người dùng (User Supremacy)**:
   - Người dùng nắm quyền phán quyết cuối cùng đối với mọi quyết định về kiến trúc, phạm vi, nghiệp vụ và tiến độ dự án.
   - AI Agent là trợ lý kỹ thuật có tư duy logic và tính phản biện khách quan, **tuyệt đối không được tự ý hành động theo suy nghĩ chủ quan** vượt ra ngoài các văn bản tài liệu đã duyệt.
2. **Nguyên tắc Căn cứ & Tư duy (Merit-Based Execution)**:
   - Mọi đề xuất hoặc dòng mã nguồn do Agent tạo ra phải có nguồn gốc (merit) rõ ràng: Từ báo cáo đề tài Word (`B23DCAT215 - Nguyễn Đức Ngọc.docx`), bài giảng mẫu của bộ môn PTIT (`softwaredesign.home.blog`), hoặc chỉ thị trực tiếp từ Người dùng.
3. **Cân bằng Tự chủ & Kiểm soát (Balanced Autonomy)**:
   - Hệ thống không bắt buộc Agent phải xin phép những chi tiết vụn vặt làm chậm tiến độ (micro-management).
   - Tuy nhiên, hệ thống thiết lập một **Ngưỡng ranh giới an toàn (Critical Boundary)**: Khi quyết định đạt tới một mức độ ảnh hưởng nhất định, Agent **bắt buộc phải dừng lại và xin ý kiến Người dùng**.

---

## 2. BÀI KIỂM TRA TƯ DUY 3 BƯỚC (THE 3-POINT MERIT TEST)

Trước khi thực hiện bất kỳ thay đổi nào, Agent bắt buộc phải tự chất vấn theo 3 tiêu chí:

```text
               ┌────────────────────────────────────────────────────────┐
               │              BÀI KIỂM TRA TƯ DUY 3 BƯỚC               │
               └──────────────────────────┬─────────────────────────────┘
                                          │
       1. CĂN CỨ HỢP LỆ?                  ▼
       Thay đổi này dựa trên văn bản nào? ────► KHÔNG CÓ CĂN CỨ ─────► [TỪ CHỐI / HỎI USER]
       (Doc / Bài giảng / Lệnh của User)
                                          │ CÓ CĂN CỨ
                                          ▼
       2. MỨC ĐỘ ẢNH HƯỞNG?
       Có đổi Schema CSDL, đổi Scope,     ────► CÓ RỦI RO LỚN   ─────► [LEO THANG LÊN CẤP 3]
       đổi Tech stack, đổi tên file JSP?
                                          │ RỦI RO THẤP / KỸ THUẬT NỘI BỘ
                                          ▼
       3. PHÂN CẤP QUYỀN HẠN?
       Thuộc Cấp 1, Cấp 2 hay Cấp 3?      ────► CẤP 1 HOẶC 2    ─────► [TỰ ĐỘNG THỰC THI]
```

---

## 3. MA TRẬN PHÂN CẤP QUYẾT ĐỊNH (THE 3-TIER ESCALATION MATRIX)

| Cấp độ (Tier) | Định nghĩa & Phạm vi | Quyền hạn của Agent | Ví dụ hành động cụ thể |
| :--- | :--- | :--- | :--- |
| **CẤP ĐỘ 1: TỰ CHỦ HOÀN TOÀN**<br>*(Autonomous)* | Các tác vụ kỹ thuật nội bộ, chi tiết cú pháp, cài đặt thuật toán đã có khuôn mẫu rõ ràng trong tài liệu. | **Tự quyết định & tự thực thi**.<br>Không cần làm phiền người dùng. | • Viết các hàm getter/setter, constructor trong Entity.<br>• Viết câu lệnh SQL JDBC chuẩn trong thân hàm DAO.<br>• Bắt ngoại lệ `SQLException`, đóng `Connection/PreparedStatement` trong khối `finally`.<br>• Tinh chỉnh CSS để giao diện hiển thị bảng biểu rõ ràng, ngay ngắn. |
| **CẤP ĐỘ 2: TỰ THỰC THI & THÔNG BÁO**<br>*(Informed)* | Lựa chọn giải pháp kỹ thuật phụ trợ, bổ sung tiện ích tối ưu mà không làm thay đổi luồng nghiệp vụ hay kiến trúc. | **Tự thực hiện**, sau đó thông báo tóm tắt cho Người dùng trong phản hồi. | • Tạo thêm class tiện ích `FideCalculator.java` để gom gọn công thức tính Elo.<br>• Tạo class định dạng ngày tháng `DateUtils.java`.<br>• Bổ sung các chú thích mã nguồn (Javadoc/Docstrings) làm sáng tỏ luồng code. |
| **CẤP ĐỘ 3: CỔNG KIỂM SOÁT BẮT BUỘC**<br>*(Critical Escalation)* | Các quyết định thay đổi cốt lõi về **Kiến trúc, Phạm vi, CSDL, Quy chuẩn môn học, và Chuyển pha dự án**. | **BẮT BUỘC DỪNG LẠI**.<br>Nêu rõ vấn đề, đề xuất phương án và chờ Người dùng phê duyệt trước khi hành động. | *Xem chi tiết Danh mục Cấm kỵ ở Mục 4 bên dưới.* |

---

## 4. DANH MỤC CÁC TRƯỜNG HỢP BẮT BUỘC DỪNG LẠI XIN LỆNH (CẤP ĐỘ 3)

Agent **TUYỆT ĐỐI KHÔNG ĐƯỢC PHÉP** tự ý thực hiện bất kỳ hành động nào dưới đây mà không có sự đồng ý rõ ràng bằng văn bản từ Người dùng:

1. **Chuyển pha phát triển (Phase Transition)**:
   - Tự ý bắt đầu viết code Java/JSP khi người dùng vẫn đang yêu cầu phân tích, đọc hiểu, hoặc chuẩn bị tài liệu ("Vẫn chưa code luôn nhé").
2. **Mở rộng hoặc Cắt giảm Phạm vi (Scope Alteration)**:
   - Tự ý code chức năng *"Xem bảng xếp hạng"* khi thầy hướng dẫn đã dặn hoãn lại.
   - Tự ý bổ sung các chức năng không có trong Module M2 (ví dụ: đăng ký tài khoản mới, phân cặp tự động Swiss-system).
   - Tự ý cắt bỏ các ca kiểm thử trong ma trận kiểm thử biên.
3. **Thay đổi Cấu trúc Cơ sở Dữ liệu (Schema Alteration)**:
   - Thêm bảng, xóa bảng, đổi tên bảng.
   - Sửa kiểu dữ liệu của các cột, xóa cột, đổi quan hệ Khóa chính / Khóa ngoại đã thống nhất trong [`docs/design/DATABASE_SPEC.md`](file:///d:/Opencode%20Workspace/PTTK/docs/design/DATABASE_SPEC.md).
4. **Thay đổi Nền tảng Công nghệ & Thư viện (Tech Stack Mutation)**:
   - Tự ý nâng cấp lên Tomcat 10/11 (`jakarta.servlet.*`) thay vì Tomcat 9 (`javax.servlet.*`).
   - Tự ý cài thêm framework bên ngoài (Spring Boot, Hibernate, JPA) phá vỡ mô hình JSP Model 1 + DAO chuẩn bài tập lớn PTIT.
   - Tự ý thay đổi cấu hình cổng Docker MySQL (`3306`) hay thông tin tài khoản root mặc định.
5. **Thay đổi Tên file Giao diện & Điểm vào (Naming & Entry Points)**:
   - Đổi tên bất kỳ file nào trong danh sách: `gdCoBan.jsp`, `gdLogin.jsp`, `doCheckLogin.jsp`, `gdTrangQuanLiGiaiCoVua.jsp`, `gdTimKiemGiaiDau.jsp`, `gdSuaThongTinGiaiDau.jsp`, `doCapNhatThongTinGiaiDau.jsp`, `gdChonVongDau.jsp`, `gdChonTranDau.jsp`, `gdChiTietTranDau.jsp`, `gdNhapKetQua.jsp`, `gdTinhDiem.jsp`, `doLuuKetQua.jsp`.
6. **Thay đổi Quy tắc Nghiệp vụ FIDE & Tiêu chí Test Biên**:
   - Thay đổi các cặp điểm hợp lệ ngoài: `(1-0)`, `(0.5-0.5)`, `(0-1)`.
   - Thay đổi logic tìm kiếm chuỗi bàn đấu mục tiêu `"11"`.

---

## 5. QUY CHUẨN XIN Ý KIẾN KHI CHẠM NGƯỠNG CẤP ĐỘ 3

Khi gặp một vấn đề kỹ thuật hoặc nghiệp vụ thuộc Cấp độ 3, Agent phải đặt câu hỏi cho Người dùng theo cấu trúc chuẩn mực:

1. **Bối cảnh & Vấn đề (Context & Conflict)**: Nêu ngắn gọn lý do tại sao vấn đề này phát sinh.
2. **Các phương án khả thi (Options)**:
   - *Phương án A*: Mô tả giải pháp, ưu điểm và nhược điểm.
   - *Phương án B*: Mô tả giải pháp, ưu điểm và nhược điểm.
3. **Khuyến nghị khách quan (Recommendation)**: Nêu rõ phương án nào phù hợp nhất với chuẩn chấm thi PTIT và tài liệu của thầy.
4. **Yêu cầu chỉ thị (Call to Action)**: Xin quyết định từ Người dùng trước khi thực thi.

