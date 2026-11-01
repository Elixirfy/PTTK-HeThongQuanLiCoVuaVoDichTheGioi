<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.GiaiDau, com.pttk.model.TVHT, com.pttk.dao.GiaiDauDAO, java.util.ArrayList, java.text.SimpleDateFormat" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String namParam = request.getParameter("nam");
    boolean hasSearched = (namParam != null && !namParam.trim().isEmpty());
    ArrayList<GiaiDau> listGiaiDau = null;

    if (hasSearched) {
        Integer nam = null;
        try {
            nam = Integer.parseInt(namParam.trim());
        } catch (NumberFormatException e) {
            nam = null;
        }
        if (nam != null) {
            GiaiDauDAO giaiDauDAO = new GiaiDauDAO();
            listGiaiDau = giaiDauDAO.searchGiaiDauBTC(nam);
        } else {
            listGiaiDau = new ArrayList<GiaiDau>();
        }
    }
    SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tìm Kiếm Giải Đấu - FIDE World Chess</title>
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
                <a href="../gdTrangQuanLiGiaiCoVua.jsp" class="flex items-center gap-3 group">
                    <div class="w-10 h-10 rounded-lg overflow-hidden border border-blue-700/80 shadow-md group-hover:border-yellow-400 transition bg-black flex items-center justify-center flex-shrink-0">
                        <img src="../images/NgocBackgroundBlackDesktop.png" alt="Logo" class="w-full h-full object-cover">
                    </div>
                    <div>
                        <span class="font-extrabold text-lg text-white block leading-tight">FIDE WORLD CHESS</span>
                        <span class="text-[11px] font-medium text-blue-200 tracking-wider uppercase block">Hệ thống Điều hành Giải đấu</span>
                    </div>
                </a>
                <div class="flex items-center gap-4 text-sm">
                    <span>Xin chào, <b class="text-yellow-400 font-bold"><%= currentUser.getHoTen() != null ? currentUser.getHoTen() : "btc1" %></b></span>
                    <a href="../gdCoBan.jsp" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold shadow-sm transition">Đăng xuất</a>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">

        <!-- Search Bar with "+ Thêm giải đấu" Button -->
        <div class="flex flex-col sm:flex-row items-center gap-4 w-full">
            <form action="gdTimKiemGiaiDau.jsp" method="GET" class="flex flex-1 gap-3 w-full">
                <input type="text" name="nam" value="<%= hasSearched ? namParam : "" %>" placeholder="Nhập năm giải đấu (VD: 2024)..." required
                       class="flex-1 px-5 py-3 border border-slate-300 rounded-xl text-base focus:ring-2 focus:ring-blue-500 outline-none bg-white shadow-sm transition">
                <button type="submit" class="bg-blue-600 hover:bg-blue-700 text-white font-bold text-base px-8 py-3 rounded-xl shadow-sm transition">
                    Tìm kiếm
                </button>
            </form>
            <button type="button" onclick="alert('Chức năng thêm giải đấu mới');" class="bg-white border-2 border-green-600 text-green-700 hover:bg-green-50 font-bold text-base px-6 py-3 rounded-xl shadow-sm transition whitespace-nowrap">
                + Thêm giải đấu
            </button>
        </div>

        <% if (hasSearched) { %>
            <!-- Result Table (Chỉ hiển thị khi đã tìm kiếm) -->
            <div class="bg-white border border-slate-200 rounded-2xl shadow-sm overflow-hidden mt-6">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse text-sm">
                        <thead class="bg-slate-50 text-slate-700 border-b border-slate-200">
                            <tr>
                                <th class="px-5 py-4 font-bold text-slate-900">Mã</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Năm</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Variant</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Mùa</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Ngày BĐ</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Ngày KT</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Địa điểm</th>
                                <th class="px-5 py-4 font-bold text-slate-900">Trạng thái</th>
                                <th class="px-5 py-4 font-bold text-slate-900 text-center">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-200">
                            <% if (listGiaiDau != null && !listGiaiDau.isEmpty()) {
                                for (GiaiDau gd : listGiaiDau) { %>
                            <tr class="hover:bg-slate-50 transition">
                                <td class="px-5 py-4 font-bold text-[#1e3a8a]">GD00<%= gd.getId() %></td>
                                <td class="px-5 py-4 font-medium text-slate-700"><%= gd.getNam() %></td>
                                <td class="px-5 py-4 text-slate-700"><%= gd.getVariant() %></td>
                                <td class="px-5 py-4 text-slate-700"><%= gd.getMuaGiai() %></td>
                                <td class="px-5 py-4 text-slate-700"><%= gd.getNgayBatDau() != null ? sdf.format(gd.getNgayBatDau()) : "-" %></td>
                                <td class="px-5 py-4 text-slate-700"><%= gd.getNgayKetThuc() != null ? sdf.format(gd.getNgayKetThuc()) : "-" %></td>
                                <td class="px-5 py-4 text-slate-700"><%= gd.getDiaDiem() %></td>
                                <td class="px-5 py-4">
                                    <span class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium bg-slate-200 text-slate-700">
                                        <%= gd.getTrangThai() %>
                                    </span>
                                </td>
                                <td class="px-5 py-4 text-center">
                                    <div class="flex items-center justify-center gap-2">
                                        <a href="gdSuaThongTinGiaiDau.jsp?id=<%= gd.getId() %>" class="px-3.5 py-1.5 border border-slate-300 text-slate-700 hover:bg-slate-100 rounded-lg text-xs font-semibold shadow-sm transition">
                                            Sửa
                                        </a>
                                        <button type="button" onclick="alert('Đã xóa giải đấu GD00<%= gd.getId() %> thành công!')" class="px-3.5 py-1.5 border border-red-500 text-red-500 hover:bg-red-50 rounded-lg text-xs font-semibold transition">
                                            Xóa
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <%  }
                            } else { %>
                            <tr>
                                <td colspan="9" class="p-12 text-center text-slate-500 font-medium">
                                    Không tìm thấy giải đấu nào phù hợp với từ khóa "<%= namParam %>".
                                </td>
                            </tr>
                            <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        <% } %>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500">
        © 2026 FIDE Tournament Administration • Học viện Công nghệ Bưu chính Viễn thông (PTIT)
    </footer>

</body>
</html>
