-- ====================================================================
-- HỆ THỐNG QUẢN LÝ GIẢI CỜ VUA VÔ ĐỊCH THẾ GIỚI (WORLD CHESS CHAMPIONSHIP)
-- Database Init Script for MySQL 8.0 / Docker
-- ====================================================================

CREATE DATABASE IF NOT EXISTS `db_covua` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE `db_covua`;

-- Drop existing tables in reverse order of FK dependencies
DROP TABLE IF EXISTS `tblKyThuThamGiaTranDau`;
DROP TABLE IF EXISTS `tblTranDau`;
DROP TABLE IF EXISTS `tblVongDau`;
DROP TABLE IF EXISTS `tblGiaiDau`;
DROP TABLE IF EXISTS `tblBanDau`;
DROP TABLE IF EXISTS `tblKyThu`;
DROP TABLE IF EXISTS `tblBTC`;
DROP TABLE IF EXISTS `tblTVHT`;
DROP TABLE IF EXISTS `tblUser`;

-- 1. Bảng tblUser
CREATE TABLE `tblUser` (
    `id` INT AUTO_INCREMENT PRIMARY KEY
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 2. Bảng tblTVHT (Kế thừa User)
CREATE TABLE `tblTVHT` (
    `Userid` INT PRIMARY KEY,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(100) NOT NULL,
    `chucVu` VARCHAR(100) NOT NULL,
    `hoTen` VARCHAR(150) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `note` VARCHAR(255) NULL,
    CONSTRAINT `fk_tvht_user` FOREIGN KEY (`Userid`) REFERENCES `tblUser` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 3. Bảng tblBTC (Kế thừa TVHT)
CREATE TABLE `tblBTC` (
    `Userid` INT PRIMARY KEY,
    CONSTRAINT `fk_btc_tvht` FOREIGN KEY (`Userid`) REFERENCES `tblTVHT` (`Userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 4. Bảng tblKyThu (Kế thừa TVHT)
CREATE TABLE `tblKyThu` (
    `Userid` INT PRIMARY KEY,
    `DOB` DATE NULL,
    `quocTich` VARCHAR(100) NOT NULL,
    `heSoThang` INT NOT NULL DEFAULT 10,
    `ELO` INT NOT NULL DEFAULT 1500,
    CONSTRAINT `fk_kythu_tvht` FOREIGN KEY (`Userid`) REFERENCES `tblTVHT` (`Userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 5. Bảng tblBanDau
CREATE TABLE `tblBanDau` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `soBan` VARCHAR(50) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 6. Bảng tblGiaiDau
CREATE TABLE `tblGiaiDau` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `nam` INT NOT NULL,
    `variant` VARCHAR(100) NOT NULL,
    `muaGiai` INT NOT NULL,
    `diaDiem` VARCHAR(255) NOT NULL,
    `trangThai` VARCHAR(50) NOT NULL,
    `note` TEXT NULL,
    `ngayBatDau` DATE NOT NULL,
    `ngayKetThuc` DATE NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 7. Bảng tblVongDau
CREATE TABLE `tblVongDau` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `soVong` INT NOT NULL,
    `ngayThiDau` DATE NOT NULL,
    `trangThai` VARCHAR(50) NOT NULL,
    `thoiGianBatDau` TIME NULL,
    `thoiGianKetThuc` TIME NULL,
    `GiaiDauid` INT NOT NULL,
    CONSTRAINT `fk_vongdau_giaidau` FOREIGN KEY (`GiaiDauid`) REFERENCES `tblGiaiDau` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 8. Bảng tblTranDau
CREATE TABLE `tblTranDau` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `trangThai` VARCHAR(50) NOT NULL,
    `VongDauid` INT NOT NULL,
    `BanDauid` INT NOT NULL,
    CONSTRAINT `fk_trandau_vongdau` FOREIGN KEY (`VongDauid`) REFERENCES `tblVongDau` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_trandau_bandau` FOREIGN KEY (`BanDauid`) REFERENCES `tblBanDau` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- 9. Bảng tblKyThuThamGiaTranDau
CREATE TABLE `tblKyThuThamGiaTranDau` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `kiVongThang` FLOAT NOT NULL DEFAULT 0.5,
    `ketQuaDiem` FLOAT NULL,
    `eloTang` FLOAT NULL,
    `TranDauid` INT NOT NULL,
    `KyThuid` INT NOT NULL,
    CONSTRAINT `fk_kttgtd_trandau` FOREIGN KEY (`TranDauid`) REFERENCES `tblTranDau` (`id`) ON DELETE CASCADE,
    CONSTRAINT `fk_kttgtd_kythu` FOREIGN KEY (`KyThuid`) REFERENCES `tblKyThu` (`Userid`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ====================================================================
-- SEED DATA & BOUNDARY TESTING DATA
-- ====================================================================

-- 1. Nạp Tài khoản TVHT & BTC
INSERT INTO `tblUser` (`id`) VALUES (1), (2), (3), (101), (102), (103), (104);

INSERT INTO `tblTVHT` (`Userid`, `username`, `password`, `chucVu`, `hoTen`, `email`, `note`) VALUES
(1, 'btc1', 'mk123@', 'Ban tổ chức', 'Nguyễn Đức Ngọc', 'ngoc.nd@fide.org', 'Trưởng ban điều hành giải đấu'),
(2, 'btc2', '123456', 'Ban tổ chức', 'Nguyễn Đức Mạnh', 'manh.nd@fide.org', 'Phó ban điều hành'),
(3, 'admin', 'admin123', 'Ban tổ chức', 'Nguyễn Hoàng Nam', 'nam.nh@fide.org', 'Quản trị viên hệ thống'),
(101, 'carlsen', 'player123', 'Kỳ thủ', 'Magnus Carlsen', 'carlsen@chess.com', 'Đại kiện tướng số 1 thế giới'),
(102, 'nakamura', 'player123', 'Kỳ thủ', 'Hikaru Nakamura', 'hikaru@chess.com', 'Đại kiện tướng Hoa Kỳ'),
(103, 'liren', 'player123', 'Kỳ thủ', 'Ding Liren', 'ding@chess.com', 'Đại kiện tướng Trung Quốc'),
(104, 'gukesh', 'player123', 'Kỳ thủ', 'Gukesh Dommaraju', 'gukesh@chess.com', 'Đại kiện tướng Ấn Độ');

INSERT INTO `tblBTC` (`Userid`) VALUES (1), (2), (3);

INSERT INTO `tblKyThu` (`Userid`, `DOB`, `quocTich`, `heSoThang`, `ELO`) VALUES
(101, '1990-11-30', 'Na Uy', 10, 2830),
(102, '1987-12-09', 'Hoa Kỳ', 10, 2802),
(103, '1992-10-24', 'Trung Quốc', 10, 2750),
(104, '2006-05-29', 'Ấn Độ', 10, 2760);

-- 2. Nạp Bàn đấu (Thiết kế phục vụ test chuỗi "11" theo ma trận Boundary Testing)
INSERT INTO `tblBanDau` (`id`, `soBan`) VALUES
(1, 'Bàn 11'),      -- Ca 1: Khớp chính xác "11"
(2, 'Bàn 110'),     -- Ca 2: "11" ở đầu chuỗi
(3, 'Bàn 115'),     -- Ca 2b: "11" ở đầu chuỗi
(4, 'Bàn 011'),     -- Ca 3: "11" ở cuối chuỗi
(5, 'Bàn 211'),     -- Ca 3b: "11" ở cuối chuỗi
(6, 'Bàn 111'),     -- Ca 4: Biên lặp "111"
(7, 'Bàn 01'),      -- Ca 5: Biên âm tính (không khớp "11")
(8, 'Bàn 101'),     -- Ca 5b: Biên âm tính (có số 1 nhưng không phải 11)
(9, 'Bàn 99');      -- Ca 5c: Biên âm tính

-- 3. Nạp Giải đấu (Test boundary năm: 2024 có nhiều giải, 2026 đang diễn ra, 2025 rỗng)
INSERT INTO `tblGiaiDau` (`id`, `nam`, `variant`, `muaGiai`, `diaDiem`, `trangThai`, `note`, `ngayBatDau`, `ngayKetThuc`) VALUES
(4, 2024, 'Classical', 1, 'Geneva, Thụy Sĩ', 'Kết thúc', 'Giải đấu vòng loại số 1', '2024-05-10', '2024-05-25'),
(5, 2024, 'Classical', 2, 'Geneva, Thụy Sĩ', 'Kết thúc', 'Giải đấu đầu tiên trong 20 năm không do Carlsen vô địch', '2024-09-10', '2024-09-25'),
(6, 2024, 'Rapid & Blitz', 1, 'Geneva, Thụy Sĩ', 'Kết thúc', 'Giải cờ chớp thế giới', '2024-12-01', '2024-12-10'),
(10, 2026, 'Classical', 1, 'Geneva, Thụy Sĩ', 'Kết thúc', 'Giải mở màn năm 2026', '2026-03-01', '2026-03-15'),
(11, 2026, 'Rapid & Blitz', 1, 'Geneva, Thụy Sĩ', 'Kết thúc', 'Giải cờ nhanh năm 2026', '2026-06-05', '2026-06-12'),
(12, 2026, 'Classical', 2, 'Hà Nội, Việt Nam', 'Đang diễn ra', 'Lần đầu tiên giải vô địch cờ vua thế giới tổ chức ở Việt Nam', '2026-09-10', '2026-09-30');

-- 4. Nạp Vòng đấu cho Giải GD012 (Hà Nội 2026)
INSERT INTO `tblVongDau` (`id`, `soVong`, `ngayThiDau`, `trangThai`, `thoiGianBatDau`, `thoiGianKetThuc`, `GiaiDauid`) VALUES
(101, 1, '2026-09-11', 'Kết thúc', '10:30:00', '18:00:00', 12),
(102, 2, '2026-09-12', 'Kết thúc', '10:30:00', '18:00:00', 12),
(103, 3, '2026-09-13', 'Kết thúc', '10:30:00', '18:00:00', 12),
(104, 4, '2026-09-15', 'Kết thúc', '10:30:00', '18:00:00', 12),
(105, 5, '2026-09-16', 'Đang diễn ra', '10:30:00', '18:00:00', 12), -- Vòng 5: Đang diễn ra (cho phép nhập điểm)
(106, 6, '2026-09-17', 'Chưa bắt đầu', '10:30:00', '18:00:00', 12), -- Vòng 6: Chưa bắt đầu (để test chặn lỗi)
(107, 7, '2026-09-19', 'Chưa bắt đầu', '10:30:00', '18:00:00', 12);

-- 5. Nạp Trận đấu cho Vòng 5 (VD105 - Đang diễn ra)
INSERT INTO `tblTranDau` (`id`, `trangThai`, `VongDauid`, `BanDauid`) VALUES
(1101, 'Đang diễn ra', 105, 1), -- Bàn 11
(1102, 'Đang diễn ra', 105, 2), -- Bàn 110
(1103, 'Đang diễn ra', 105, 4), -- Bàn 011
(1104, 'Đang diễn ra', 105, 6), -- Bàn 111
(1105, 'Đang diễn ra', 105, 7); -- Bàn 01

-- 6. Nạp Kỳ thủ tham gia trận TD1101 (Carlsen vs Nakamura trên Bàn 11)
INSERT INTO `tblKyThuThamGiaTranDau` (`id`, `kiVongThang`, `ketQuaDiem`, `eloTang`, `TranDauid`, `KyThuid`) VALUES
(1, 0.54, NULL, NULL, 1101, 101), -- Carlsen (Elo 2830, kỳ vọng thắng 0.54)
(2, 0.46, NULL, NULL, 1101, 102); -- Nakamura (Elo 2802, kỳ vọng thắng 0.46)

