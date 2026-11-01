<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.GiaiDau, com.pttk.dao.GiaiDauDAO, java.sql.Date" %>
<%
    request.setCharacterEncoding("UTF-8");

    int id = Integer.parseInt(request.getParameter("id"));
    int nam = Integer.parseInt(request.getParameter("nam"));
    String variant = request.getParameter("variant");
    int muaGiai = Integer.parseInt(request.getParameter("muaGiai"));
    String diaDiem = request.getParameter("diaDiem");
    Date ngayBatDau = Date.valueOf(request.getParameter("ngayBatDau"));
    Date ngayKetThuc = Date.valueOf(request.getParameter("ngayKetThuc"));
    String note = request.getParameter("note");

    GiaiDau gd = new GiaiDau(id, nam, variant, muaGiai, diaDiem, "Kết thúc", note, ngayBatDau, ngayKetThuc);
    GiaiDauDAO giaiDauDAO = new GiaiDauDAO();
    boolean isSuccess = giaiDauDAO.updateGiaiDau(gd);

    if (isSuccess) {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật giải đấu</title>
</head>
<body>
    <script type="text/javascript">
        alert("Sửa thông tin giải đấu thành công!");
        window.location.href = "gdTimKiemGiaiDau.jsp?nam=<%= nam %>";
    </script>
</body>
</html>
<%
    } else {
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cập nhật giải đấu</title>
</head>
<body>
    <script type="text/javascript">
        alert("Lỗi! Cập nhật giải đấu không thành công.");
        window.history.back();
    </script>
</body>
</html>
<%
    }
%>
