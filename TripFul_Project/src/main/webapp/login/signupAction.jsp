<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Brush+Script&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	
<title>Insert title here</title>

<%
	request.setCharacterEncoding("utf-8");
	LoginDto dto = new LoginDto();
	LoginDao dao = new LoginDao();
	
	dto.setName(request.getParameter("name"));
	dto.setId(request.getParameter("id"));
	dto.setPw(request.getParameter("pw"));
	dto.setEmail(request.getParameter("email"));
	dto.setBirth(request.getParameter("birth"));
	
	dao.insertMember(dto);
	
	response.sendRedirect("./login.jsp");
	
%>

</head>
<body>

</body>
</html>