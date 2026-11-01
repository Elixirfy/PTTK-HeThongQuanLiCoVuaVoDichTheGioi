<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.GiaiDau, com.pttk.model.TVHT, com.pttk.dao.GiaiDauDAO, java.util.ArrayList" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("gdLogin.jsp");
        return;
    }

    String namParam = request.getParameter("nam");
    int nam = 2024;
    if (namParam != null && !namParam.trim().isEmpty()) {
        try {
            nam = Integer.parseInt(namParam.trim());
        } catch (NumberFormatException e) {
            nam = 2024;
        }
    }

    GiaiDauDAO giaiDauDAO = new GiaiDauDAO();
    ArrayList<GiaiDau> listGiaiDau = giaiDauDAO.searchGiaiDauBTC(nam);
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý giải đấu - FIDE World Chess</title>
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
                    <span class="text-xs text-blue-200">Xin chào: <b class="text-white"><%= currentUser.getHoTen() %></b></span>
                    <a href="gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        <div>
            <a href="gdTrangQuanLiGiaiCoVua.jsp" class="text-xs text-blue-600 hover:underline font-semibold flex items-center gap-1 mb-1">
                ← Quay lại Bảng điều khiển
            </a>
            <h2 class="text-2xl font-extrabold text-[#1e3a8a]">Quản Lý Thông Tin Giải Đấu</h2>
        </div>

        <!-- Search Bar -->
        <div class="bg-white p-5 rounded-xl border border-slate-200 shadow-sm flex flex-col sm:flex-row justify-between items-center gap-4">
            <form action="gdTimKiemGiaiDau.jsp" method="GET" class="flex gap-3 w-full sm:w-auto flex-1 max-w-lg">
                <input type="number" name="nam" value="<%= nam %>" required placeholder="Nhập năm tìm kiếm..."
                       class="w-full px-4 py-2 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white text-sm font-semibold px-5 py-2 rounded-lg transition">
                    Tìm kiếm
                </button>
            </form>
            <div class="text-xs text-slate-500">
                Kiểm thử biên: <a href="gdTimKiemGiaiDau.jsp?nam=2024" class="text-blue-600 hover:underline">2024 (Đa bản ghi)</a> • <a href="gdTimKiemGiaiDau.jsp?nam=2026" class="text-blue-600 hover:underline">2026 (Đang diễn ra)</a> • <a href="gdTimKiemGiaiDau.jsp?nam=2025" class="text-blue-600 hover:underline">2025 (Rỗng)</a>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white border border-slate-200 rounded-xl shadow-sm overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse text-sm">
                    <thead class="bg-slate-100 text-slate-700 border-b border-slate-200">
                        <tr>
                            <th class="px-5 py-3.5 font-bold">Mã GD</th>
                            <th class="px-5 py-3.5 font-bold">Năm</th>
                            <th class="px-5 py-3.5 font-bold">Thể loại</th>
                            <th class="px-5 py-3.5 font-bold">Mùa giải</th>
                            <th class="px-5 py-3.5 font-bold">Địa điểm</th>
                            <th class="px-5 py-3.5 font-bold">Trạng thái</th>
                            <th class="px-5 py-3.5 font-bold text-center">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (listGiaiDau != null && !listGiaiDau.isEmpty()) {
                            for (GiaiDau gd : listGiaiDau) { %>
                        <tr class="hover:bg-slate-50 border-b border-slate-200 transition">
                            <td class="px-5 py-4 font-mono font-bold text-[#1e3a8a]">GD00<%= gd.getId() %></td>
                            <td class="px-5 py-4 font-semibold"><%= gd.getNam() %></td>
                            <td class="px-5 py-4">
                                <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold <%= "Classical".equals(gd.getVariant()) ? "bg-blue-100 text-blue-800" : "bg-purple-100 text-purple-800" %>">
                                    <%= gd.getVariant() %>
                                </span>
                            </td>
                            <td class="px-5 py-4 font-medium">Mùa <%= gd.getMuaGiai() %></td>
                            <td class="px-5 py-4 text-slate-700"><%= gd.getDiaDiem() %></td>
                            <td class="px-5 py-4">
                                <span class="px-2.5 py-0.5 rounded-full text-xs font-semibold <%= "Đang diễn ra".equals(gd.getTrangThai()) ? "bg-orange-100 text-orange-800" : "bg-slate-100 text-slate-700" %>">
                                    <%= gd.getTrangThai() %>
                                </span>
                            </td>
                            <td class="px-5 py-4 text-center">
                                <a href="gdSuaThongTinGiaiDau.jsp?id=<%= gd.getId() %>" class="bg-blue-600 hover:bg-blue-700 text-white text-xs font-semibold px-3 py-1.5 rounded-md shadow-sm transition">
                                    Sửa
                                </a>
                            </td>
                        </tr>
                        <% } } else { %>
                        <tr>
                            <td colspan="7" class="p-12 text-center text-slate-500 font-medium">
                                Không tồn tại giải đấu nào trong năm <%= nam %>.
                            </td>
                        </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </main>

</body>
</html>

