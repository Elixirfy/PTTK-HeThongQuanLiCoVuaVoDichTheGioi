<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hệ thống Quản lý Giải Cờ Vua Vô Địch Thế Giới</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
</head>
<body class="min-h-full flex flex-col text-slate-800">

    <!-- Top Navigation Bar -->
    <nav class="bg-[#1e3a8a] text-white shadow-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <a href="gdCoBan.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <a href="gdLogin.jsp" class="whitespace-nowrap bg-blue-600 hover:bg-blue-500 text-white px-4 py-2 rounded-lg text-xs font-semibold shadow-sm transition">
                    Đăng nhập Ban tổ chức
                </a>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-16 flex flex-col items-center justify-center text-center">
        <div class="inline-flex items-center gap-2 bg-yellow-100 border border-yellow-300 text-yellow-900 text-xs px-3.5 py-1.5 rounded-full font-bold mb-6 shadow-sm">
            FIDE OFFICIAL WORLD CHESS CHAMPIONSHIP PORTAL
        </div>

        <h1 class="text-4xl md:text-6xl font-extrabold text-[#1e3a8a] mb-6 tracking-tight max-w-4xl leading-tight">
            Hệ Thống Quản Lý Giải Cờ Vua Vô Địch Thế Giới
        </h1>

        <p class="text-slate-600 max-w-2xl text-base md:text-lg mb-10 leading-relaxed">
            Hệ thống chính thức phục vụ Ban tổ chức quản lý thông tin giải đấu, kiểm soát lịch trình thi đấu và cập nhật kết quả từng vòng đấu chuẩn FIDE quốc tế.
        </p>

        <div class="flex flex-col sm:flex-row gap-5 items-center justify-center">
            <a href="gdLogin.jsp" class="whitespace-nowrap px-8 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold rounded-xl shadow-md hover:shadow-lg transition flex items-center justify-center gap-2.5 text-base">
                <svg class="w-5 h-5 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h7a3 3 0 013 3v1"></path></svg>
                <span>Đăng nhập Ban tổ chức</span>
            </a>
            <button type="button" disabled class="whitespace-nowrap px-8 py-4 bg-slate-200 text-slate-400 font-bold rounded-xl cursor-not-allowed border border-slate-300 flex items-center justify-center gap-2.5 text-base" title="Chức năng đang bảo trì theo chỉ đạo của giảng viên">
                <svg class="w-5 h-5 opacity-40 flex-shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"></path></svg>
                <span>Bảng xếp hạng (Tạm hoãn)</span>
            </button>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500">
        © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    </footer>

</body>
</html>
