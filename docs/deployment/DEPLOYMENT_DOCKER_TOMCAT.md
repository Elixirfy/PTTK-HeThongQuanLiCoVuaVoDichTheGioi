# DEPLOYMENT GUIDE: DOCKER MYSQL & APACHE TOMCAT 9

> **HƯỚNG DẪN MÔI TRƯỜNG THỰC THI: DOCKER MYSQL 8.0 & TOMCAT 9**
> Vị trí: `docs/deployment/DEPLOYMENT_DOCKER_TOMCAT.md`
> Phục vụ: Cung cấp giải pháp chạy nhanh, tự động hóa toàn bộ môi trường mà không cần cài đặt MySQL lên máy host

---

## 1. THIẾT LẬP CƠ SỞ DỮ LIỆU BẰNG DOCKER (ZERO-CONFIG MYSQL)

Để giải quyết vấn đề máy tính cá nhân chưa cài đặt MySQL hoặc quên mật khẩu `root`, hệ thống sử dụng Docker Container để chạy MySQL 8.0 độc lập.

### 1.1. Cấu hình file `docker-compose.yml` (Dự kiến triển khai)
```yaml
version: '3.8'

services:
  mysql_db:
    image: mysql:8.0
    container_name: covua_mysql_db
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: root123
      MYSQL_DATABASE: db_covua
    ports:
      - "3306:3306"
    volumes:
      - ./sql/init_database.sql:/docker-entrypoint-initdb.d/init_database.sql:ro
      - mysql_data:/var/lib/mysql
    command: --default-authentication-plugin=mysql_native_password --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

volumes:
  mysql_data:
```

### 1.2. Thao tác vận hành Docker MySQL
* **Khởi động CSDL**:
  ```bash
  docker compose up -d
  ```
  *(Khi chạy lần đầu, container sẽ tự động nạp toàn bộ cấu trúc bảng và dữ liệu mẫu kiểm thử từ file `sql/init_database.sql`).*
* **Kiểm tra trạng thái container**:
  ```bash
  docker ps
  ```
* **Dừng container khi không sử dụng**:
  ```bash
  docker compose down
  ```

---

## 2. CẤU HÌNH KẾT NỐI JDBC TRONG `DAO.java`

Thông tin cấu hình kết nối chuẩn trong lớp cơ sở `DAO.java`:
* **Driver class**: `com.mysql.cj.jdbc.Driver`
* **Connection URL**: `jdbc:mysql://localhost:3306/db_covua?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Ho_Chi_Minh`
* **Username**: `root`
* **Password**: `root123`

---

## 3. MÔI TRƯỜNG WEB SERVER: APACHE TOMCAT 9

### 3.1. Lý do chọn Tomcat 9
* Tomcat 9 tuân thủ đặc tả **Java EE 8 / Servlet 4.0** với namespace truyền thống `javax.servlet.*`.
* Khớp 100% với các ví dụ bài giảng của giảng viên bộ môn PTTK PTIT.
* Không gặp xung đột package như Tomcat 10/11 (chuyển sang `jakarta.servlet.*`).

### 3.2. Cấu trúc thư mục mã nguồn Maven chuẩn
```text
PTTK/
├── pom.xml                           (Quản lý servlet-api, jstl, mysql-connector-java)
├── docker-compose.yml                (Chạy MySQL)
├── sql/
│   └── init_database.sql             (DDL & DML)
└── src/
    └── main/
        ├── java/
        │   └── com/pttk/
        │       ├── model/            (Entity POJOs)
        │       └── dao/              (DAO classes)
        └── webapp/
            ├── WEB-INF/
            │   └── web.xml           (Deployment descriptor)
            ├── css/
            │   └── style.css
            ├── gd*.jsp               (Trang hiển thị View)
            └── do*.jsp               (Trang xử lý Action)
```

