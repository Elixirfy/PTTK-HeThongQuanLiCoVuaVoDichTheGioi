<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT, com.pttk.model.TranDau, com.pttk.model.KyThuThamGiaTranDau, com.pttk.dao.TranDauDAO, com.pttk.dao.KyThuThamGiaTranDauDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    TVHT currentUser = (TVHT) session.getAttribute("btc");
    if (currentUser == null) {
        response.sendRedirect("../gdLogin.jsp");
        return;
    }

    String idTDParam = request.getParameter("idTranDau");
    String s1Param = request.getParameter("score1");
    String s2Param = request.getParameter("score2");
    String idVDParam = request.getParameter("idVongDau");

    int idTranDau = 1101;
    float s1 = 1.0f;
    float s2 = 0.0f;
    int idVongDau = 105;

    try {
        if (idTDParam != null) idTranDau = Integer.parseInt(idTDParam.trim());
        if (s1Param != null) s1 = Float.parseFloat(s1Param.trim());
        if (s2Param != null) s2 = Float.parseFloat(s2Param.trim());
        if (idVDParam != null) idVongDau = Integer.parseInt(idVDParam.trim());
    } catch (Exception e) {
        e.printStackTrace();
    }

    TranDauDAO tdDAO = new TranDauDAO();
    TranDau td = tdDAO.getChiTietTranDau(idTranDau);

    boolean isSuccess = false;
    if (td != null && td.getDanhSachKyThu() != null && td.getDanhSachKyThu().length >= 2) {
        td.getDanhSachKyThu()[0].setKetQuaDiem(s1);
        td.getDanhSachKyThu()[1].setKetQuaDiem(s2);

        KyThuThamGiaTranDauDAO kqDAO = new KyThuThamGiaTranDauDAO();
        isSuccess = kqDAO.addKetQua(td.getDanhSachKyThu());
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xử lý lưu kết quả trận đấu</title>
</head>
<body>
<% if (isSuccess) { %>
    <script>
        alert("Cập nhật kết quả trận đấu thành công!");
        window.location.href = "gdChonTranDau.jsp?idVongDau=<%= idVongDau %>";
    </script>
<% } else { %>
    <script>
        alert("Lỗi! Không thể lưu kết quả trận đấu. Vui lòng thử lại.");
        window.history.back();
    </script>
<% } %>
</body>
</html>
