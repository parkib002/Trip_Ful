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
	String pw = request.getParameter("newpw");
	String id = null;
	
	if(session.getAttribute("id")!=null){
		id = (String)session.getAttribute("id");
	}
	else{
		id = (String)request.getAttribute("id");
	}

	LoginDao dao = new LoginDao();
	dao.changePW(id, pw);
	
	
%>
<script>
	alert("비밀번호가 변경되었습니다.");
	window.location.href="<%=request.getContextPath()%>/index.jsp?main=login/login.jsp";
	
</script>
</body>
</html>