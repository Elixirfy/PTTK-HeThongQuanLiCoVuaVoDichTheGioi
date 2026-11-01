<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - FIDE World Chess</title>
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
                <a href="gdCoBan.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <a href="gdCoBan.jsp" class="text-xs text-blue-200 hover:text-white">← Quay lại</a>
            </div>
        </div>
    </nav>

    <!-- Main Content Form -->
    <main class="flex-1 max-w-md w-full mx-auto px-4 py-16 flex flex-col justify-center">
        <div class="bg-white p-8 sm:p-10 rounded-2xl shadow-md border border-slate-200">
            <div class="text-center mb-8">
                <h2 class="text-2xl font-bold text-[#1e3a8a] tracking-tight">Đăng nhập</h2>
            </div>

            <form action="doCheckLogin.jsp" method="POST" class="space-y-6">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Tài khoản</label>
                    <input type="text" name="txtUsername" value="btc1" required
                           class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm transition">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-2">Mật khẩu</label>
                    <input type="password" name="pwdPassword" value="mk123@" required
                           class="w-full px-4 py-3 border border-slate-300 rounded-xl focus:ring-2 focus:ring-blue-500 outline-none text-sm transition">
                </div>
                <div class="pt-4 flex items-center justify-between">
                    <a href="gdCoBan.jsp" class="text-sm font-medium text-slate-500 hover:text-slate-800 transition">
                        Quay lại
                    </a>
                    <button type="submit" class="px-7 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-semibold transition shadow-sm hover:shadow">
                        Đăng nhập
                    </button>
                </div>
            </form>
        </div>
    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500">
        © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    </footer>

</body>
</html>
