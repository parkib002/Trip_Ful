<%@page import="login.LoginDao"%>
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

<title>Insert title here</title>
<%
request.setCharacterEncoding("utf-8");
String name = request.getParameter("name");
String email = request.getParameter("email");

LoginDao dao = new LoginDao();

String findid = dao.findID(name, email);
%>
</head>
<body>
	<div class="container mt-3">
		<div style="text-align:center; margin-top:30px;">
			<div style="border:1px solid red; padding:20px"><%
			if (findid.equals("")) {
				%>
				<span>일치하는 아이디를 찾을 수 없습니다.</span>
				<%
			}
			else{
				%>
				<span><b><%=name %></b>님의 아이디는 <b style="color:red"><%=findid %></b>입니다.</span>
				<% 
			}
			%></div>
			<br><br><button onclick="idClose()">닫기</button>
		</div>
	</div>
</body>
<script>
	function idClose(){
		window.close();
		opener.location.href = "<%=request.getContextPath()%>/index.jsp?main=login/login.jsp";
	}
</script>
</html>