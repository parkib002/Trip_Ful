<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%
	String pw = request.getParameter("password");
	String id = request.getParameter("id");
	
	LoginDao dao = new LoginDao();
	dao.changePW(id, pw);
	
%>
<script>
	window.close();
	opener.location.href="./login.jsp";
</script>
</body>
</html>