<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT" %>
<%
    TVHT btc = (TVHT) session.getAttribute("btc");
    if (btc == null) {
        response.sendRedirect("gdLogin.jsp");
        return;
    }
    String tenNguoiDung = btc.getHoTen();
    String chucVu = btc.getChucVu();
    String email = btc.getEmail();
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển Ban tổ chức - FIDE World Chess</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="min-h-full flex flex-col text-slate-800">

    <!-- Top Navbar -->
    <nav class="bg-[#1e3a8a] text-white shadow-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <a href="gdTrangQuanLiGiaiCoVua.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <div class="flex items-center gap-4">
                    <span class="text-xs text-blue-200">Xin chào: <b class="text-white"><%= tenNguoiDung %></b></span>
                    <a href="gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Grid -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8">
        <!-- Welcome Banner -->
        <div class="bg-white p-6 sm:p-8 rounded-2xl shadow-sm border border-slate-200 flex flex-col md:flex-row justify-between items-start md:items-center gap-4">
            <div>
                <h2 class="text-2xl sm:text-3xl font-extrabold text-[#1e3a8a]">Bảng Điều Khiển Nghiệp Vụ</h2>
            </div>
            <div class="flex items-center gap-2 bg-emerald-50 border border-emerald-200 text-emerald-800 text-xs px-4 py-2 rounded-xl font-medium shadow-sm">
                <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                Tài khoản: <span class="font-bold text-emerald-950"><%= tenNguoiDung %></span>
            </div>
        </div>

        <!-- 3 Cards -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <!-- Card 1 -->
            <a href="gdTimKiemGiaiDau.jsp" class="group bg-white border-2 border-blue-500 rounded-2xl p-8 hover:bg-blue-50/50 transition-all duration-200 shadow-sm hover:shadow-md flex flex-col justify-between">
                <div>
                    <div class="w-14 h-14 bg-blue-100 text-[#1e3a8a] rounded-xl flex items-center justify-center mb-6 group-hover:scale-105 transition transform shadow-inner">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-[#1e3a8a] mb-2">Quản lý Giải Đấu</h3>
                    <p class="text-xs text-slate-600 leading-relaxed">
                        Tìm kiếm giải đấu theo năm, xem danh sách và chỉnh sửa thông tin chi tiết các giải vô địch cờ vua thế giới.
                    </p>
                </div>
                <div class="mt-8 pt-4 border-t border-slate-100 flex items-center justify-between text-xs font-bold text-blue-600 group-hover:text-blue-800">
                    <span>Vào phân hệ quản lý</span>
                    <span>→</span>
                </div>
            </a>

            <!-- Card 2 -->
            <a href="gdChonVongDau.jsp" class="group bg-white border-2 border-blue-500 rounded-2xl p-8 hover:bg-blue-50/50 transition-all duration-200 shadow-sm hover:shadow-md flex flex-col justify-between">
                <div>
                    <div class="w-14 h-14 bg-indigo-100 text-indigo-900 rounded-xl flex items-center justify-center mb-6 group-hover:scale-105 transition transform shadow-inner">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-indigo-950 mb-2">Cập nhật Kết Quả</h3>
                    <p class="text-xs text-slate-600 leading-relaxed">
                        Chọn vòng đấu đang diễn ra, tìm kiếm trận đấu theo bàn (test biên "11"), nhập điểm và tự động tính Elo FIDE.
                    </p>
                </div>
                <div class="mt-8 pt-4 border-t border-slate-100 flex items-center justify-between text-xs font-bold text-blue-600 group-hover:text-blue-800">
                    <span>Nhập điểm vòng đấu</span>
                    <span>→</span>
                </div>
            </a>

            <!-- Card 3 -->
            <div class="bg-slate-100 border-2 border-slate-300 rounded-2xl p-8 text-slate-400 flex flex-col justify-between relative overflow-hidden">
                <div class="absolute top-4 right-4 bg-yellow-100 text-yellow-800 text-[10px] font-bold px-2.5 py-1 rounded-md">
                    Tạm hoãn
                </div>
                <div>
                    <div class="w-14 h-14 bg-slate-200 text-slate-400 rounded-xl flex items-center justify-center mb-6 opacity-60">
                        <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                    </div>
                    <h3 class="text-xl font-bold text-slate-500 mb-2">Bảng Xếp Hạng</h3>
                    <p class="text-xs text-slate-400 leading-relaxed">
                        Xem bảng xếp hạng sau vòng đấu tính theo tổng điểm, điểm đối thủ đã gặp (Buchholz) và Elo.
                    </p>
                </div>
                <div class="mt-8 pt-4 border-t border-slate-200 text-xs text-slate-400 font-medium">
                    (Đang bảo trì theo chỉ đạo của GV)
                </div>
            </div>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500">
        © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    </footer>

</body>
</html>
