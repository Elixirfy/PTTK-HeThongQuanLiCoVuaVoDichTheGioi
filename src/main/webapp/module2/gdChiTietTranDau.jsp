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

    int vId = (td != null && td.getVongDau() != null) ? td.getVongDau().getId() : 105;
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@include file="../header.jsp" %>
    <title>Chi Tiết Trận Đấu TD<%= idTranDau %> - FIDE World Chess</title>
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
    <main class="flex-1 max-w-5xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-10 relative">

        <!-- Top Header Back Button -->
        <div class="mb-8 flex items-center justify-between">
            <a href="gdChonTranDau.jsp?idVongDau=<%= vId %>"
               class="inline-flex items-center gap-2 px-4 py-2 border border-slate-300 bg-white rounded-xl text-xs font-bold text-slate-700 hover:bg-slate-100 transition shadow-sm">
                <span>←</span> Quay lại
            </a>
            <div class="inline-flex items-center gap-2 bg-blue-100 text-blue-900 text-xs px-3.5 py-1.5 rounded-full font-bold">
                Trận đấu: TD<%= idTranDau %> • <%= td != null && td.getBanDau() != null ? td.getBanDau().getSoBan() : "Bàn thi đấu" %>
            </div>
        </div>

        <!-- Center Match Title -->
        <div class="text-center mb-10">
            <h1 class="text-3xl font-extrabold text-[#1e3a8a] tracking-tight">Thông Tin Chi Tiết Trận Đấu</h1>
        </div>

        <!-- Side-by-side Players Container -->
        <div class="flex flex-col md:flex-row gap-6 mb-12">
            
            <!-- Player 1 Card (White Pieces) -->
            <div class="border-l-4 border-blue-500 bg-white shadow-md rounded-2xl p-6 md:p-8 w-full md:w-1/2 flex flex-col justify-between">
                <div>
                    <div class="flex justify-between items-start mb-4">
                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-blue-50 text-blue-700 border border-blue-200">
                            <span class="w-2.5 h-2.5 rounded-full border border-blue-400 bg-white inline-block"></span> Quân Trắng
                        </span>
                        <span class="font-mono text-xs text-slate-500 font-bold">ID: KT<%= String.format("%03d", (p1 != null && p1.getKyThu() != null) ? (p1.getKyThu().getId() % 100 == 0 ? p1.getKyThu().getId() : p1.getKyThu().getId() % 100) : 1) %></span>
                    </div>

                    <h2 class="text-2xl font-extrabold text-slate-900 mb-6">
                        <%= p1 != null && p1.getKyThu() != null ? p1.getKyThu().getHoTen() : "Magnus Carlsen" %>
                    </h2>

                    <div class="bg-blue-50/60 rounded-xl p-4 border border-blue-100 space-y-3">
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-slate-600 font-medium">Hệ số Elo hiện tại:</span>
                            <span class="font-bold text-lg text-blue-900 font-mono">
                                <%= p1 != null && p1.getKyThu() != null ? String.format("%.1f", p1.getKyThu().getELO()) : "2830.0" %>
                            </span>
                        </div>
                        <div class="flex justify-between items-center text-sm pt-2 border-t border-blue-200/60">
                            <span class="text-slate-600 font-medium">Kỳ vọng thắng FIDE (E):</span>
                            <span class="font-extrabold text-base text-blue-700 font-mono">
                                <%= p1 != null ? String.format("%.2f", p1.getKiVongThang()) : "0.54" %>
                                <span class="text-xs text-blue-500 font-normal">(<%= p1 != null ? Math.round(p1.getKiVongThang() * 100) : 54 %>%)</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Player 2 Card (Black Pieces) -->
            <div class="border-l-4 border-gray-800 bg-white shadow-md rounded-2xl p-6 md:p-8 w-full md:w-1/2 flex flex-col justify-between">
                <div>
                    <div class="flex justify-between items-start mb-4">
                        <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-gray-100 text-gray-800 border border-gray-300">
                            <span class="w-2.5 h-2.5 rounded-full bg-slate-900 inline-block"></span> Quân Đen
                        </span>
                        <span class="font-mono text-xs text-slate-500 font-bold">ID: KT<%= String.format("%03d", (p2 != null && p2.getKyThu() != null) ? (p2.getKyThu().getId() % 100 == 0 ? p2.getKyThu().getId() : p2.getKyThu().getId() % 100) : 2) %></span>
                    </div>

                    <h2 class="text-2xl font-extrabold text-slate-900 mb-6">
                        <%= p2 != null && p2.getKyThu() != null ? p2.getKyThu().getHoTen() : "Hikaru Nakamura" %>
                    </h2>

                    <div class="bg-slate-100 rounded-xl p-4 border border-slate-200 space-y-3">
                        <div class="flex justify-between items-center text-sm">
                            <span class="text-slate-600 font-medium">Hệ số Elo hiện tại:</span>
                            <span class="font-bold text-lg text-slate-900 font-mono">
                                <%= p2 != null && p2.getKyThu() != null ? String.format("%.1f", p2.getKyThu().getELO()) : "2802.0" %>
                            </span>
                        </div>
                        <div class="flex justify-between items-center text-sm pt-2 border-t border-slate-200">
                            <span class="text-slate-600 font-medium">Kỳ vọng thắng FIDE (E):</span>
                            <span class="font-extrabold text-base text-gray-800 font-mono">
                                <%= p2 != null ? String.format("%.2f", p2.getKiVongThang()) : "0.46" %>
                                <span class="text-xs text-slate-500 font-normal">(<%= p2 != null ? Math.round(p2.getKiVongThang() * 100) : 46 %>%)</span>
                            </span>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <!-- Action Button -->
        <div class="flex justify-center">
            <a href="gdNhapKetQua.jsp?idTranDau=<%= idTranDau %>"
               class="whitespace-nowrap px-10 py-4 bg-blue-600 hover:bg-blue-700 text-white font-bold text-base rounded-2xl shadow-lg hover:shadow-xl transition flex items-center gap-2">
                <span>Nhập kết quả</span>
            </a>
        </div>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500 mt-auto">
        © 2026 FIDE Tournament Administration • Hệ thống Cập nhật Kết quả FIDE
    </footer>

</body>
</html>
