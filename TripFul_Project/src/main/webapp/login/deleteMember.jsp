<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String loginok = (String)session.getAttribute("loginok");

	String id = request.getParameter("id");
	String pw = request.getParameter("pw");
	LoginDao dao = new LoginDao();
	
	boolean flag = false;
	
	System.out.println(id+" "+pw);
	
	if(dao.loginMember(id, pw)==1){
		flag = true;
		dao.deleteMember(id);
		session.removeAttribute("loginok");
	}
	else if(loginok.equals("admin")){
		flag = true;
		dao.deleteMember(id);
	}
%>
<%=flag%>