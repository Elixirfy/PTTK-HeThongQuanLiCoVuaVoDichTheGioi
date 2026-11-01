<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT, com.pttk.model.VongDau, com.pttk.model.TranDau, com.pttk.model.BanDau, com.pttk.dao.VongDauDAO, com.pttk.dao.TranDauDAO, java.util.ArrayList" %>
<%
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String idVDParam = request.getParameter("idVongDau");
    int idVongDau = 105; // Mặc định Vòng 5 đang diễn ra
    if (idVDParam != null && !idVDParam.trim().isEmpty()) {
        try {
            idVongDau = Integer.parseInt(idVDParam.trim());
        } catch (NumberFormatException e) {
            idVongDau = 105;
        }
    }

    VongDauDAO vdDAO = new VongDauDAO();
    VongDau vd = vdDAO.getVongDauById(idVongDau);
    if (vd == null) {
        vd = new VongDau(105, 5, java.sql.Date.valueOf("2026-09-16"), "Đang diễn ra", null, null, null);
    }
    // Lưu thực thể VongDau vào session
    session.setAttribute("vongDau", vd);

    String soBanQuery = request.getParameter("txtBanDau");
    boolean hasSearched = (soBanQuery != null && !soBanQuery.trim().isEmpty());
    String queryBan = (soBanQuery != null) ? soBanQuery.trim() : "";

    ArrayList<TranDau> listTranDau = new ArrayList<TranDau>();
    if (hasSearched) {
        // Đóng gói tiêu chí tìm kiếm theo chuẩn PTIT OOAD: nạp thực thể VongDau vừa chọn vào TranDau bằng setter
        TranDau tdCriteria = new TranDau();
        tdCriteria.setVongDau(vd);

        BanDau bdCriteria = new BanDau();
        bdCriteria.setSoBan(queryBan);
        tdCriteria.setBanDau(bdCriteria);

        TranDauDAO tdDAO = new TranDauDAO();
        listTranDau = tdDAO.searchTranDauTheoBan(tdCriteria);
    }
%>
<!DOCTYPE html>
<html lang="vi" class="h-full bg-slate-50">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <%@include file="../header.jsp" %>
    <title>Danh Sách Trận Đấu - Vòng <%= vd.getSoVong() %> - FIDE World Chess</title>
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
                    <button type="button" onclick="openPage('../gdCoBan.jsp')" class="bg-red-600 hover:bg-red-700 text-white px-3 py-1.5 rounded-lg text-xs font-semibold shadow-sm transition">Đăng xuất</button>
                </div>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="flex-1 max-w-7xl w-full mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-6">
        
        <!-- Header -->
        <div class="pb-2 border-b border-slate-200">
            <h1 class="text-2xl font-extrabold text-[#1e3a8a]">Danh Sách Trận Đấu - Vòng <%= vd.getSoVong() %></h1>
        </div>

        <!-- Search Bar by Board Number -->
        <div class="bg-white p-5 rounded-2xl shadow-sm border border-slate-200">
            <form action="gdChonTranDau.jsp" method="GET" class="flex flex-col sm:flex-row items-center gap-3">
                <input type="hidden" name="idVongDau" value="<%= idVongDau %>">
                <div class="relative flex-1 w-full">
                    <span class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none text-slate-400">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                    </span>
                    <input type="text" name="txtBanDau" value="<%= queryBan %>" placeholder="Nhập bàn của trận đấu..."
                           class="w-full pl-10 pr-4 py-2.5 border border-slate-300 rounded-xl text-sm focus:ring-2 focus:ring-blue-500 outline-none transition">
                </div>
                <button type="submit" class="w-full sm:w-auto px-6 py-2.5 bg-blue-600 hover:bg-blue-700 text-white text-sm font-bold rounded-xl shadow-sm hover:shadow transition flex items-center justify-center gap-2 whitespace-nowrap">
                    <span>Tìm kiếm</span>
                </button>
            </form>
        </div>

        <% if (hasSearched) { %>
            <!-- Matches Table (Chỉ hiển thị khi đã tìm kiếm theo kịch bản) -->
            <div class="bg-white rounded-2xl shadow-sm border border-slate-200 overflow-hidden">
                <div class="p-5 border-b border-slate-100 flex justify-between items-center bg-slate-50/50">
                    <h2 class="font-bold text-slate-800 text-sm">
                        Kết Quả Tìm Kiếm: <%= listTranDau.size() %> trận đấu
                    </h2>
                    <span class="text-xs bg-blue-100 text-blue-800 px-2.5 py-0.5 rounded-full font-medium">
                        Lọc theo từ khóa: "<%= queryBan %>"
                    </span>
                </div>

                <% if (listTranDau.isEmpty()) { %>
                    <div class="p-12 text-center">
                        <div class="w-12 h-12 mx-auto mb-3 text-slate-400">
                            <svg class="w-full h-full" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path></svg>
                        </div>
                        <h3 class="text-base font-bold text-slate-700">Không tìm thấy trận đấu nào thỏa mãn</h3>
                        <p class="text-xs text-slate-500 mt-1 max-w-md mx-auto">
                            Không có bàn đấu nào phù hợp với từ khóa "<b><%= queryBan %></b>" trong vòng này.
                        </p>
                    </div>
                <% } else { %>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse text-sm">
                            <thead class="bg-slate-100 text-slate-700 border-b border-slate-200 text-xs uppercase font-semibold">
                                <tr>
                                    <th class="p-4">Mã trận</th>
                                    <th class="p-4">Bàn đấu</th>
                                    <th class="p-4">Mã kỳ thủ 1</th>
                                    <th class="p-4">Mã kỳ thủ 2</th>
                                    <th class="p-4">Trạng thái</th>
                                    <th class="p-4 text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100">
                                <% for (TranDau td : listTranDau) { 
                                    int p1Id = 101;
                                    int p2Id = 102;
                                    if (td.getDanhSachKyThu() != null && td.getDanhSachKyThu().length >= 2) {
                                        if (td.getDanhSachKyThu()[0].getKyThu() != null) {
                                            p1Id = td.getDanhSachKyThu()[0].getKyThu().getId();
                                        }
                                        if (td.getDanhSachKyThu()[1].getKyThu() != null) {
                                            p2Id = td.getDanhSachKyThu()[1].getKyThu().getId();
                                        }
                                    }
                                    int displayId1 = p1Id % 100 == 0 ? p1Id : p1Id % 100;
                                    int displayId2 = p2Id % 100 == 0 ? p2Id : p2Id % 100;
                                %>
                                <tr class="hover:bg-slate-50/80 transition">
                                    <td class="p-4 font-mono font-bold text-[#1e3a8a]">
                                        TD<%= td.getId() %>
                                    </td>
                                    <td class="p-4">
                                        <span class="inline-flex items-center px-3 py-1 rounded-lg text-xs font-bold bg-blue-50 text-blue-800 border border-blue-200">
                                            <%= td.getBanDau() != null ? td.getBanDau().getSoBan() : "BD001" %>
                                        </span>
                                    </td>
                                    <td class="p-4 font-mono font-bold text-slate-800">
                                        KT<%= String.format("%03d", displayId1) %>
                                    </td>
                                    <td class="p-4 font-mono font-bold text-slate-800">
                                        KT<%= String.format("%03d", displayId2) %>
                                    </td>
                                    <td class="p-4">
                                        <% if ("Đang diễn ra".equals(td.getTrangThai())) { %>
                                            <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-100 text-emerald-800">
                                                <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                                Đang diễn ra
                                            </span>
                                        <% } else { %>
                                            <span class="inline-flex items-center px-2.5 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600">
                                                <%= td.getTrangThai() %>
                                            </span>
                                        <% } %>
                                    </td>
                                    <td class="p-4 text-center">
                                        <a href="gdChiTietTranDau.jsp?idTranDau=<%= td.getId() %>"
                                           class="px-4 py-1.5 bg-blue-600 hover:bg-blue-700 text-white font-bold text-xs rounded-lg shadow-sm hover:shadow transition">
                                            Chọn
                                        </a>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        <% } %>

    </main>

    <!-- Footer -->
    <footer class="bg-white border-t border-slate-200 py-4 text-center text-xs text-slate-500 mt-auto">
        © 2026 FIDE Tournament Administration • Hệ thống Cập nhật Kết quả FIDE
    </footer>

</body>
</html>
