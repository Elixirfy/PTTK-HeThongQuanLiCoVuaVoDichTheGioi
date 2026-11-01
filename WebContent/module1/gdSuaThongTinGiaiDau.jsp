<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.GiaiDau, com.pttk.model.TVHT, com.pttk.dao.GiaiDauDAO" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    int id = 5;
    if (idParam != null && !idParam.trim().isEmpty()) {
        try {
            id = Integer.parseInt(idParam.trim());
        } catch (NumberFormatException e) {
            id = 5;
        }
    }

    GiaiDauDAO giaiDauDAO = new GiaiDauDAO();
    GiaiDau gd = giaiDauDAO.getGiaiDauById(id);
    if (gd == null) {
        gd = new GiaiDau(5, 2024, "Classical", 2, "Geneva, Thụy Sĩ", "Kết thúc", "Giải đấu cờ vua", java.sql.Date.valueOf("2024-09-10"), java.sql.Date.valueOf("2024-09-25"));
    }
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa thông tin giải đấu - FIDE World Chess</title>
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
                    <span class="text-xs text-blue-200">Xin chào: <b class="text-white"><%= currentUser.getHoTen() %></b></span>
                    <a href="../gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content Form -->
    <main class="flex-1 max-w-3xl w-full mx-auto px-4 py-8">
        <div class="bg-white p-8 rounded-2xl shadow-sm border border-slate-200">
            <div class="border-b border-slate-200 pb-4 mb-6 flex justify-between items-center">
                <div>
                    <h2 class="text-2xl font-extrabold text-[#1e3a8a]">Sửa Thông Tin Giải Đấu</h2>
                    <p class="text-xs text-slate-500 mt-1">Mã định danh giải: <span class="font-mono font-bold text-blue-700">GD00<%= gd.getId() %></span></p>
                </div>
                <a href="gdTimKiemGiaiDau.jsp?nam=<%= gd.getNam() %>" class="text-xs text-slate-500 hover:text-slate-800 font-medium">
                    ← Hủy quay lại
                </a>
            </div>

            <form action="doCapNhatThongTinGiaiDau.jsp" method="POST" class="space-y-5">
                <input type="hidden" name="id" value="<%= gd.getId() %>">

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Năm tổ chức</label>
                        <input type="number" name="nam" value="<%= gd.getNam() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Thể loại (Variant)</label>
                        <input type="text" name="variant" value="<%= gd.getVariant() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mùa tổ chức</label>
                        <input type="number" name="muaGiai" value="<%= gd.getMuaGiai() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Địa điểm tổ chức</label>
                        <input type="text" name="diaDiem" value="<%= gd.getDiaDiem() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                </div>

                <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Ngày bắt đầu</label>
                        <input type="date" name="ngayBatDau" value="<%= gd.getNgayBatDau() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                    <div>
                        <label class="block text-sm font-semibold text-slate-700 mb-1.5">Ngày kết thúc</label>
                        <input type="date" name="ngayKetThuc" value="<%= gd.getNgayKetThuc() %>" required
                               class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none">
                    </div>
                </div>

                <div>
                    <label class="block text-sm font-semibold text-slate-700 mb-1.5">Mô tả / Ghi chú</label>
                    <textarea name="note" rows="3" class="w-full px-3.5 py-2.5 border border-slate-300 rounded-lg text-sm focus:ring-2 focus:ring-blue-500 outline-none"><%= gd.getNote() != null ? gd.getNote() : "" %></textarea>
                </div>

                <div class="flex justify-end gap-3 pt-4 border-t border-slate-100">
                    <a href="gdTimKiemGiaiDau.jsp?nam=<%= gd.getNam() %>" class="px-5 py-2.5 border border-slate-300 rounded-lg text-sm font-semibold text-slate-700 hover:bg-slate-100 transition">
                        Hủy bỏ
                    </a>
                    <button type="submit" class="px-6 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-sm font-bold shadow-md transition flex items-center gap-2">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>
                        Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </main>

</body>
</html>
