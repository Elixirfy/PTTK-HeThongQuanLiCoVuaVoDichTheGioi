<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT, com.pttk.model.TranDau, com.pttk.model.KyThuThamGiaTranDau, com.pttk.dao.TranDauDAO" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String idTDParam = request.getParameter("idTranDau");
    int idTranDau = 1101;
    if (idTDParam != null && !idTDParam.trim().isEmpty()) {
        try {
            idTranDau = Integer.parseInt(idTDParam.trim());
        } catch (NumberFormatException e) {
            idTranDau = 1101;
        }
    }

    TranDauDAO tdDAO = new TranDauDAO();
    TranDau td = tdDAO.getChiTietTranDau(idTranDau);
    if (td == null) {
        td = tdDAO.getChiTietTranDau(1101);
    }

    KyThuThamGiaTranDau p1 = (td != null && td.getDanhSachKyThu() != null && td.getDanhSachKyThu().length >= 1) ? td.getDanhSachKyThu()[0] : null;
    KyThuThamGiaTranDau p2 = (td != null && td.getDanhSachKyThu() != null && td.getDanhSachKyThu().length >= 2) ? td.getDanhSachKyThu()[1] : null;

    String p1Name = (p1 != null && p1.getKyThu() != null) ? p1.getKyThu().getHoTen() : "Magnus Carlsen";
    String p2Name = (p2 != null && p2.getKyThu() != null) ? p2.getKyThu().getHoTen() : "Hikaru Nakamura";
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Nhập Kết Quả Trận Đấu TD<%= idTranDau %> - FIDE World Chess</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>body { font-family: 'Inter', sans-serif; }</style>
    <script>
        // Ràng buộc tự động cặp điểm chuẩn FIDE khi người dùng chọn kết quả
        function onPlayer1ScoreChange() {
            const s1 = parseFloat(document.getElementById('score1').value);
            const select2 = document.getElementById('score2');
            if (s1 === 1.0) {
                select2.value = "0.0";
            } else if (s1 === 0.5) {
                select2.value = "0.5";
            } else if (s1 === 0.0) {
                select2.value = "1.0";
            }
        }

        function validateForm() {
            const s1 = parseFloat(document.getElementById('score1').value);
            const s2 = parseFloat(document.getElementById('score2').value);
            if (Math.abs((s1 + s2) - 1.0) > 0.001) {
                alert("Lỗi bộ điểm không hợp lệ! Tổng điểm trận đấu cờ vua chuẩn FIDE phải luôn bằng 1.0 (1-0, 0.5-0.5, hoặc 0-1).");
                return false;
            }
            return true;
        }
    </script>
</head>
<body class="min-h-full flex flex-col text-slate-800">

    <!-- Top Navbar -->
    <nav class="bg-[#1e3a8a] text-white shadow-md sticky top-0 z-50">
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
            <div class="flex items-center justify-between h-16">
                <a href="../gdTrangQuanLiGiaiCoVua.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="../images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <div class="flex items-center gap-4">
                    <span class="text-xs text-blue-200 hidden sm:inline">Xin chào: <b class="text-white"><%= currentUser.getHoTen() %></b></span>
                    <a href="../gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold shadow-sm transition">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Container -->
    <main class="flex-1 max-w-2xl w-full mx-auto px-4 sm:px-6 py-12">

        <!-- Outer Form Card with clean border -->
        <div class="bg-white rounded-3xl shadow-xl border border-slate-200 p-8 sm:p-10">

            <div class="border-b border-slate-200 pb-5 mb-8 flex justify-between items-center">
                <div>
                    <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Nhập Kết Quả Trận Đấu</h1>
                    <p class="text-xs text-slate-500 mt-1">
                        Mã trận: <b class="text-blue-700 font-mono">TD<%= idTranDau %></b> • <%= td != null && td.getBanDau() != null ? td.getBanDau().getSoBan() : "Bàn thi đấu" %>
                    </p>
                </div>
                <a href="gdChiTietTranDau.jsp?idTranDau=<%= idTranDau %>" class="text-xs text-slate-500 hover:text-slate-800 font-medium">
                    ← Hủy
                </a>
            </div>

            <form action="gdTinhDiem.jsp" method="POST" onsubmit="return validateForm();" class="space-y-6">
                <input type="hidden" name="idTranDau" value="<%= idTranDau %>">

                <!-- Player 1 Score Row -->
                <div class="bg-slate-50 p-5 rounded-2xl border border-slate-200 flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <span class="w-3.5 h-3.5 rounded-full border border-blue-400 bg-white inline-block"></span>
                        <div>
                            <span class="text-xs font-bold text-blue-600 uppercase block">Quân Trắng</span>
                            <span class="font-extrabold text-sm text-slate-900"><%= p1Name %></span>
                        </div>
                    </div>
                    <select name="score1" id="score1" onchange="onPlayer1ScoreChange()"
                            class="border-2 border-blue-500 bg-blue-50 font-bold text-blue-900 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 shadow-inner">
                        <option value="1.0" selected>1.0 (Thắng)</option>
                        <option value="0.5">0.5 (Hòa)</option>
                        <option value="0.0">0.0 (Thua)</option>
                    </select>
                </div>

                <!-- Player 2 Score Row -->
                <div class="bg-slate-50 p-5 rounded-2xl border border-slate-200 flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <span class="w-3.5 h-3.5 rounded-full bg-slate-900 inline-block"></span>
                        <div>
                            <span class="text-xs font-bold text-slate-400 uppercase block">Quân Đen</span>
                            <span class="font-extrabold text-sm text-slate-900"><%= p2Name %></span>
                        </div>
                    </div>
                    <select name="score2" id="score2"
                            class="border-2 border-blue-400 bg-blue-50 font-bold text-slate-900 rounded-lg px-3 py-2 text-sm outline-none focus:ring-2 focus:ring-blue-500 shadow-inner">
                        <option value="0.0" selected>0.0 (Thua)</option>
                        <option value="0.5">0.5 (Hòa)</option>
                        <option value="1.0">1.0 (Thắng)</option>
                    </select>
                </div>

                <!-- Bottom Action Row -->
                <div class="pt-4 flex items-center gap-3">
                    <a href="gdChiTietTranDau.jsp?idTranDau=<%= idTranDau %>"
                       class="w-1/3 py-3 px-4 border border-slate-300 text-slate-700 rounded-xl hover:bg-slate-100 text-sm font-semibold transition text-center shadow-sm">
                        Hủy
                    </a>
                    <button type="submit"
                            class="w-2/3 py-3 px-4 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-sm font-bold transition shadow-md hover:shadow-lg flex items-center justify-center gap-2">
                        <span>Tính điểm</span>
                    </button>
                </div>

            </form>

        </div>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500 mt-auto">
        © 2026 FIDE Tournament Administration • Hệ thống Cập nhật Kết quả FIDE
    </footer>

</body>
</html>
