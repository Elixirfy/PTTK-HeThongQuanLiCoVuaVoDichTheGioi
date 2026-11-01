<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT" %>
<%
    TVHT btc = (TVHT) session.getAttribute("btc");
    if (btc == null) {
        response.sendRedirect("gdLogin.jsp");
        return;
    }
    String displayName = btc.getHoTen() != null && !btc.getHoTen().isEmpty() ? btc.getHoTen() : (btc.getUsername() != null ? btc.getUsername() : "btc1");
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Bảng điều khiển - FIDE World Chess</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="min-h-full flex flex-col text-slate-800 bg-[#f8fafc]">

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
                <div class="flex items-center gap-4 text-sm">
                    <span>Xin chào, <b class="text-yellow-400 font-bold"><%= displayName %></b></span>
                    <a href="gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold shadow-sm transition">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content: -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-16 flex items-center justify-center">
        <div class="grid grid-cols-1 md:grid-cols-3 gap-8 w-full max-w-5xl">
            
            <!-- Card 1: Quản lí thông tin giải đấu -->
            <a href="module1/gdTimKiemGiaiDau.jsp" class="group bg-white border border-slate-200 hover:border-blue-500 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm hover:shadow-md transition">
                <div class="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-105 transition">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-bold text-slate-900 group-hover:text-blue-600 mb-2 transition">Quản lí thông tin giải đấu</h3>
                <p class="text-sm text-slate-500">
                    Thêm, sửa, xóa các giải đấu
                </p>
            </a>

            <!-- Card 2: Cập nhật kết quả vòng đấu -->
            <a href="module2/gdTimKiemGiaiDau.jsp" class="group bg-white border border-slate-200 hover:border-blue-500 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm hover:shadow-md transition">
                <div class="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center mb-5 group-hover:scale-105 transition">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-bold text-slate-900 group-hover:text-blue-600 mb-2 transition">Cập nhật kết quả vòng đấu</h3>
                <p class="text-sm text-slate-500">
                    Nhập điểm, cập nhật kết quả từng trận
                </p>
            </a>

            <!-- Card 3: Xem bảng xếp hạng (Đang tạm hoãn theo chỉ đạo) -->
            <div class="bg-white border border-slate-200 rounded-2xl p-8 sm:p-10 text-center flex flex-col items-center justify-center shadow-sm opacity-70 cursor-not-allowed">
                <div class="w-16 h-16 bg-slate-50 text-slate-400 rounded-2xl flex items-center justify-center mb-5">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path>
                    </svg>
                </div>
                <h3 class="text-xl font-bold text-slate-700 mb-2">Xem bảng xếp hạng</h3>
                <p class="text-sm text-slate-500">
                    Theo dõi BXH kì thủ sau mỗi vòng
                </p>
            </div>

        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500">
        © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    </footer>

</body>
</html>
