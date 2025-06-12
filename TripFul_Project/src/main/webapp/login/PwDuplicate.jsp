<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%
	LoginDao dao = new LoginDao();
	String inputCurrPw = request.getParameter("currpw");
	String currentId = null;
	if(session.getAttribute("id")!=null){
		// 세션 아이디 존재시 정보 수정 폼
		currentId = (String)session.getAttribute("id");
	}
	else{
		currentId = request.getParameter("id");
	}
	
	// 0이면 DB오류 1이면 중복 2면 가능
	int duplicate=dao.chkPw(currentId, inputCurrPw);
	
	
%>
<%=duplicate%>