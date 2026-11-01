<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT, com.pttk.model.GiaiDau, com.pttk.model.VongDau, com.pttk.dao.GiaiDauDAO, com.pttk.dao.VongDauDAO, java.util.ArrayList" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String idGDParam = request.getParameter("idGiaiDau");
    int idGiaiDau = 12;
    if (idGDParam != null && !idGDParam.trim().isEmpty()) {
        try {
            idGiaiDau = Integer.parseInt(idGDParam.trim());
        } catch (NumberFormatException e) {
            idGiaiDau = 12;
        }
    }

    GiaiDauDAO giaiDauDAO = new GiaiDauDAO();
    GiaiDau gd = giaiDauDAO.getGiaiDauById(idGiaiDau);
    if (gd == null) {
        gd = new GiaiDau(12, 2026, "Classical", 2, "Hà Nội, Việt Nam", "Đang diễn ra", "Giải cờ vua thế giới 2026", java.sql.Date.valueOf("2026-09-10"), java.sql.Date.valueOf("2026-09-30"));
    }

    VongDauDAO vongDauDAO = new VongDauDAO();
    ArrayList<VongDau> listVongDau = vongDauDAO.getVongDauCuaBTC(idGiaiDau);
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@include file="../header.jsp" %>
    <title>Chọn Vòng Đấu - FIDE World Chess</title>
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

    <!-- Main Content -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- Header -->
        <div class="pb-2 border-b border-slate-200">
            <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Chọn Vòng Đấu Cần Nhập Điểm</h1>
            <p class="text-xs text-slate-500 mt-0.5">
                Giải đấu: <b class="text-slate-800"><%= gd.getVariant() %> <%= gd.getNam() %> (Mùa <%= gd.getMuaGiai() %>)</b> • Địa điểm: <%= gd.getDiaDiem() %>
            </p>
        </div>

        <!-- Table of Rounds -->
        <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
            <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                <h2 class="font-bold text-slate-800 text-sm">Danh Sách Các Vòng Đấu Của Giải</h2>
                <span class="text-xs text-slate-500">Tổng cộng: <b><%= listVongDau.size() %></b> vòng đấu</span>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-sm">
                    <thead class="bg-slate-100 text-slate-700 border-b border-slate-200 text-xs uppercase font-semibold">
                        <tr>
                            <th class="p-4">Vòng đấu</th>
                            <th class="p-4">Ngày thi đấu</th>
                            <th class="p-4">Thời gian</th>
                            <th class="p-4">Trạng thái</th>
                            <th class="p-4 text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100">
                        <% for (VongDau vd : listVongDau) { %>
                        <tr class="hover:bg-slate-50/80 transition">
                            <td class="p-4 font-bold text-[#1e3a8a]">
                                Vòng <%= vd.getSoVong() %>
                            </td>
                            <td class="p-4 text-slate-700 font-medium">
                                <%= vd.getNgayThiDau() %>
                            </td>
                            <td class="p-4 text-slate-500 font-mono text-xs">
                                <%= vd.getThoiGianBatDau() %> - <%= vd.getThoiGianKetThuc() %>
                            </td>
                            <td class="p-4">
                                <% if ("Đang diễn ra".equals(vd.getTrangThai())) { %>
                                    <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800 border border-emerald-300">
                                        <span class="w-2 h-2 rounded-full bg-emerald-600 animate-pulse"></span>
                                        Đang diễn ra
                                    </span>
                                <% } else if ("Chưa bắt đầu".equals(vd.getTrangThai())) { %>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-semibold bg-amber-100 text-amber-800 border border-amber-200">
                                        Chưa bắt đầu
                                    </span>
                                <% } else { %>
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">
                                        Kết thúc
                                    </span>
                                <% } %>
                            </td>
                            <td class="p-4 text-center">
                                <% if ("Đang diễn ra".equals(vd.getTrangThai())) { %>
                                    <a href="gdChonTranDau.jsp?idVongDau=<%= vd.getId() %>"
                                       class="px-4 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-lg shadow-sm hover:shadow transition">
                                        Chọn
                                    </a>
                                <% } else if ("Chưa bắt đầu".equals(vd.getTrangThai())) { %>
                                    <button type="button" onclick="alert('Lỗi! Vòng đấu chưa diễn ra.');"
                                            class="px-4 py-1.5 bg-slate-200 text-slate-500 font-semibold text-xs rounded-lg transition">
                                        Chọn
                                    </button>
                                <% } else { %>
                                    <a href="gdChonTranDau.jsp?idVongDau=<%= vd.getId() %>"
                                       class="px-4 py-1.5 border border-slate-300 text-slate-700 hover:bg-slate-50 font-semibold text-xs rounded-lg transition">
                                        Chọn
                                    </a>
                                <% } %>
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500 mt-auto">
        © 2026 FIDE Tournament Administration • Hệ thống Cập nhật Kết quả FIDE
    </footer>

</body>
</html>
