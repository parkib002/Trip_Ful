<%@page import="org.apache.catalina.ha.backend.Sender"%>
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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>Insert title here</title>

</head>
<body>
<%
	String id = request.getParameter("user");
	String pw = request.getParameter("pass");
	String chk = request.getParameter("check");
		
	//System.out.println(chk);
	LoginDao dao = new LoginDao();
	
	int flag = dao.loginMember(id, pw);
	
	//System.out.println(flag);
	
	if(flag==0){
		response.sendRedirect("../index.jsp?main=login/login.jsp&login=1");
	}
	else if (flag==1){
		System.out.println("유저");
		session.setAttribute("loginok","user");
		session.setAttribute("id",id);
		if(chk!=null){
			session.setAttribute("rememberId", "ok");
		}
		response.sendRedirect("../index.jsp");
	}
	else if (flag == 2) {
		System.out.println("어드민");
		session.setAttribute("loginok","admin");
		session.setAttribute("id",id);
		if(chk!=null){
			session.setAttribute("rememberId", "ok");
		}
		response.sendRedirect("../index.jsp");
	}
%>

</body>
</html>