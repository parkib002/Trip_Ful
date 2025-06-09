<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%
	LoginDao dao = new LoginDao();
	String inputId = request.getParameter("id");
	String currentId = null;
	if(session.getAttribute("id")!=null){
		// 세션 아이디 존재시 정보 수정 폼
		currentId = (String)session.getAttribute("id");
	}
	
	// 0이면 사용가능 1이면 중복 2면 글자수 제한 3이면 사용 불가 문자   4면 영문+숫자 아님
	int duplicate=dao.chkDup(inputId);
	
	if(inputId.equals(currentId)){
		duplicate = 5;
	}
%>
<%=duplicate%>