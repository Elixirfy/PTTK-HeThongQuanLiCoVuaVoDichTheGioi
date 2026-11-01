# BACKUP DOCUMENTATION STORAGE

> **THƯ MỤC SAO LƯU TÀI LIỆU PHẢN CHIẾU 1:1 (DOCUMENTATION MIRROR VAULT)**
> Vị trí: `backup-documentation/`

---

## NGUYÊN TẮC VẬN HÀNH

Thư mục này phản chiếu chính xác cấu trúc cây thư mục (folder tree) của toàn bộ dự án.

Mỗi khi một file tài liệu bất kỳ trong dự án cần được chỉnh sửa:
1. Tạo một bản copy của file đó trước khi chỉnh sửa.
2. Đặt vào đúng thư mục con tương ứng bên trong `backup-documentation/`.
3. Đặt tên theo cú pháp: `[TÊN_FILE_GỐC]_backup_[YYYYMMDD_HHMMSS].md`.
4. Ghi nhận thời gian, file và lý do cập nhật vào `ENTRY_LOG.md`.

Ví dụ:
- Sửa `PROJECT_OVERVIEW.md` $\rightarrow$ Lưu snapshot vào `backup-documentation/PROJECT_OVERVIEW_backup_20261101_114000.md`.
- Sửa `docs/design/DATABASE_SPEC.md` $\rightarrow$ Lưu snapshot vào `backup-documentation/docs/design/DATABASE_SPEC_backup_20261101_114000.md`.

