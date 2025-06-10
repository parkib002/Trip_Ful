<%@page import="login.SocialDto"%>
<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%	
	LoginDto dto = new LoginDto();
	dto.setName(request.getParameter("name"));
	dto.setId(request.getParameter("id"));
	dto.setEmail(request.getParameter("email"));
		
	LoginDao dao = new LoginDao();
	Boolean flag = dao.authentication(dto);
	System.out.println(dto.toString());
	System.out.println(flag);
%>
<%=flag%>