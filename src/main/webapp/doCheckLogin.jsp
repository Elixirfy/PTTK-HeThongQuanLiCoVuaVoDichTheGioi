<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.pttk.model.TVHT" %>
<%@ page import="com.pttk.dao.TVHTDAO" %>
<%
    request.setCharacterEncoding("UTF-8");
    String username = request.getParameter("txtUsername");
    String password = request.getParameter("pwdPassword");

    TVHT tvht = new TVHT();
    tvht.setUsername(username);
    tvht.setPassword(password);

    TVHTDAO tvhtDAO = new TVHTDAO();
    boolean isValid = tvhtDAO.checkLogin(tvht);

    if (isValid) {
        // Lưu thông tin người dùng vào Session theo thiết kế
        session.setAttribute("user", tvht);
        session.setAttribute("btc", tvht);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Xử lý đăng nhập</title>
</head>
<body>
    <script type="text/javascript">
        alert("Đăng nhập thành công! Chào mừng <%= tvht.getHoTen() %> (<%= tvht.getChucVu() %>).");
        window.location.href = "gdTrangQuanLiGiaiCoVua.jsp";
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
    <title>Xử lý đăng nhập</title>
</head>
<body>
    <script type="text/javascript">
        alert("Đăng nhập thất bại! Tên tài khoản hoặc mật khẩu không chính xác.");
        window.history.back();
    </script>
</body>
</html>
<%
    }
%>

