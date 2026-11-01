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

    float s1 = 1.0f;
    float s2 = 0.0f;
    try {
        s1 = Float.parseFloat(request.getParameter("score1"));
        s2 = Float.parseFloat(request.getParameter("score2"));
    } catch (Exception e) {
        s1 = 1.0f;
        s2 = 0.0f;
    }

    // Kiểm tra tính hợp lệ của cặp điểm FIDE
    if (Math.abs((s1 + s2) - 1.0f) > 0.01f || (s1 == 1.0f && s2 == 1.0f) || (s1 == 0.0f && s2 == 0.0f)) {
        response.sendRedirect("gdNhapKetQua.jsp?idTranDau=" + idTranDau);
        return;
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

    float elo1Old = (p1 != null && p1.getKyThu() != null) ? p1.getKyThu().getELO() : 2830.0f;
    float elo2Old = (p2 != null && p2.getKyThu() != null) ? p2.getKyThu().getELO() : 2802.0f;

    float e1 = (p1 != null) ? p1.getKiVongThang() : 0.54f;
    float e2 = (p2 != null) ? p2.getKiVongThang() : 0.46f;

    int k1 = 10;
    int k2 = 10;

    float deltaElo1 = k1 * (s1 - e1);
    float deltaElo2 = k2 * (s2 - e2);

    float elo1New = elo1Old + deltaElo1;
    float elo2New = elo2Old + deltaElo2;
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xác Nhận Kết Quả Trận Đấu - FIDE World Chess</title>
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

        <!-- Emerald Success Confirmation Card -->
        <div class="bg-gradient-to-br from-emerald-50 via-teal-50/40 to-white rounded-3xl shadow-xl border-2 border-emerald-500/40 p-8 sm:p-10 relative overflow-hidden">
            
            <div class="border-b border-emerald-200 pb-5 mb-8 flex justify-between items-center relative z-10">
                <div>
                    <span class="text-[11px] font-extrabold text-emerald-800 uppercase tracking-wider block">Tính Toán Điểm Số Thành Công</span>
                    <h1 class="text-2xl font-black text-slate-900 mt-0.5">Xác Nhận Kết Quả Trận Đấu</h1>
                </div>
                <div class="text-right">
                    <span class="text-xs font-bold text-slate-400 block">Mã trận</span>
                    <span class="font-mono font-black text-base text-emerald-800">TD<%= idTranDau %></span>
                </div>
            </div>

            <!-- Two Players Rating Impact Rows -->
            <div class="space-y-4 mb-8 relative z-10">
                
                <!-- Player 1 Impact Card -->
                <div class="bg-white/90 backdrop-blur-sm p-5 rounded-2xl border border-emerald-200 shadow-sm flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <span class="w-3.5 h-3.5 rounded-full border border-blue-400 bg-white inline-block"></span>
                        <div>
                            <span class="text-xs font-bold text-blue-600 uppercase block">Quân Trắng</span>
                            <span class="font-extrabold text-base text-slate-900"><%= p1Name %></span>
                            <span class="text-xs text-slate-500 block">Điểm ván đấu: <b class="text-slate-800 font-mono"><%= String.format("%.1f", s1) %></b></span>
                        </div>
                    </div>
                    <div class="text-right">
                        <div class="font-mono font-bold text-sm text-slate-600">
                            <%= String.format("%.1f", elo1Old) %> → <span class="text-emerald-700 font-extrabold text-base"><%= String.format("%.1f", elo1New) %></span>
                        </div>
                        <span class="inline-flex items-center gap-1 font-mono font-extrabold text-xs <%= deltaElo1 >= 0 ? "text-emerald-700 bg-emerald-100" : "text-rose-700 bg-rose-100" %> px-2 py-0.5 rounded-full mt-1">
                            <%= deltaElo1 >= 0 ? "+" + String.format("%.1f", deltaElo1) : String.format("%.1f", deltaElo1) %> ELO
                        </span>
                    </div>
                </div>

                <!-- Player 2 Impact Card -->
                <div class="bg-white/90 backdrop-blur-sm p-5 rounded-2xl border border-emerald-200 shadow-sm flex items-center justify-between">
                    <div class="flex items-center gap-3">
                        <span class="w-3.5 h-3.5 rounded-full bg-slate-900 inline-block"></span>
                        <div>
                            <span class="text-xs font-bold text-slate-500 uppercase block">Quân Đen</span>
                            <span class="font-extrabold text-base text-slate-900"><%= p2Name %></span>
                            <span class="text-xs text-slate-500 block">Điểm ván đấu: <b class="text-slate-800 font-mono"><%= String.format("%.1f", s2) %></b></span>
                        </div>
                    </div>
                    <div class="text-right">
                        <div class="font-mono font-bold text-sm text-slate-600">
                            <%= String.format("%.1f", elo2Old) %> → <span class="text-emerald-700 font-extrabold text-base"><%= String.format("%.1f", elo2New) %></span>
                        </div>
                        <span class="inline-flex items-center gap-1 font-mono font-extrabold text-xs <%= deltaElo2 >= 0 ? "text-emerald-700 bg-emerald-100" : "text-rose-700 bg-rose-100" %> px-2 py-0.5 rounded-full mt-1">
                            <%= deltaElo2 >= 0 ? "+" + String.format("%.1f", deltaElo2) : String.format("%.1f", deltaElo2) %> ELO
                        </span>
                    </div>
                </div>

            </div>

            <!-- Form Submit to doLuuKetQua.jsp -->
            <form action="doLuuKetQua.jsp" method="POST" class="relative z-10 space-y-3">
                <input type="hidden" name="idTranDau" value="<%= idTranDau %>">
                <input type="hidden" name="score1" value="<%= s1 %>">
                <input type="hidden" name="score2" value="<%= s2 %>">
                <input type="hidden" name="deltaElo1" value="<%= deltaElo1 %>">
                <input type="hidden" name="deltaElo2" value="<%= deltaElo2 %>">
                <input type="hidden" name="idVongDau" value="<%= td != null && td.getVongDau() != null ? td.getVongDau().getId() : 105 %>">

                <button type="submit"
                        class="w-full py-4 px-6 bg-emerald-600 hover:bg-emerald-700 text-white font-extrabold text-base rounded-xl shadow-lg hover:shadow-xl transition flex items-center justify-center gap-2">
                    <span>Lưu kết quả</span>
                </button>

                <a href="gdNhapKetQua.jsp?idTranDau=<%= idTranDau %>"
                   class="w-full block py-2.5 text-center text-xs font-semibold text-slate-600 hover:text-slate-900 transition">
                    ← Sửa lại điểm số
                </a>
            </form>

        </div>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500 mt-auto">
        © 2026 FIDE Tournament Administration • Hệ thống Cập nhật Kết quả FIDE
    </footer>

</body>
</html>
