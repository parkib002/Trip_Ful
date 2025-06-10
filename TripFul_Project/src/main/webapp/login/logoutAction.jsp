<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="https://fonts.googleapis.com/css2?family=Dongle&family=Gaegu&family=Hi+Melody&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <title>Insert title here</title>
</head>
<body>
<%
    //loginok세션제거
    session.removeAttribute("loginok");
	if(session.getAttribute("rememberId")==null){
		session.removeAttribute("id");
	}
    //loginmain으로 이동
    response.sendRedirect("../index.jsp");
%>
</body>
</html>