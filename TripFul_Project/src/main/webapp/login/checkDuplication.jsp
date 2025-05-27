<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%
	LoginDao dao = new LoginDao();
	String inputId = request.getParameter("id");
	
	// 0이면 사용가능 1이면 중복 2면 글자수 제한 3이면 사용 불가 문자   4면 영문+숫자 아님
	
	int duplicate=dao.chkDup(inputId);
%>
<%=duplicate%>