<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập - FIDE World Chess</title>
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
                <a href="gdCoBan.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <a href="gdCoBan.jsp" class="text-xs text-blue-200 hover:text-white">← Quay lại trang chủ</a>
            </div>
        </div>
    </nav>

    <!-- Main Content Form -->
    <main class="flex-1 max-w-md w-full mx-auto px-4 py-12 flex flex-col justify-center">
        <div class="bg-white p-8 rounded-2xl shadow-lg border border-slate-200">
            <div class="text-center mb-8">
                <div class="w-14 h-14 bg-blue-100 text-[#1e3a8a] rounded-xl mx-auto flex items-center justify-center mb-4 shadow-inner">
                    <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"></path></svg>
                </div>
                <h2 class="text-2xl font-bold text-[#1e3a8a]">Đăng Nhập Ban Tổ Chức</h2>
                <p class="text-sm text-slate-500 mt-1">Xác thực quyền quản trị viên giải đấu</p>
            </div>

            <form action="doCheckLogin.jsp" method="POST" class="space-y-5">
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-1.5">Tên đăng nhập (Username)</label>
                    <input type="text" name="txtUsername" value="btc1" required
                           class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>
                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mật khẩu (Password)</label>
                    <input type="password" name="pwdPassword" value="mk123@" required
                           class="w-full px-4 py-2.5 border border-slate-300 rounded-lg focus:ring-2 focus:ring-blue-500 outline-none text-sm">
                </div>
                <div class="pt-2 flex gap-3">
                    <a href="gdCoBan.jsp" class="w-1/3 py-2.5 px-4 border border-slate-300 text-slate-700 rounded-lg hover:bg-slate-100 text-sm font-semibold transition text-center flex items-center justify-center">
                        Hủy bỏ
                    </a>
                    <button type="submit" class="w-2/3 py-2.5 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg text-sm font-semibold transition shadow-md">
                        Đăng nhập →
                    </button>
                </div>
            </form>

            <div class="mt-8 pt-5 border-t border-slate-100 text-xs text-slate-500 bg-slate-50 -mx-8 -mb-8 p-6 rounded-b-2xl">
                <span class="font-bold text-slate-700 block mb-1">Tài khoản nạp sẵn kiểm thử:</span>
                <div class="space-y-1 font-mono text-[11px] text-blue-800">
                    <div>• <span class="font-bold">btc1</span> / mk123@ (Nguyễn Đức Ngọc - Trưởng ban)</div>
                    <div>• <span class="font-bold">admin</span> / admin123 (Quản trị viên)</div>
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
