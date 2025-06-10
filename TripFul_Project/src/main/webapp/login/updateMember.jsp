<%@page import="login.LoginDto"%>
<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%	

	request.setCharacterEncoding("utf-8");

	LoginDao dao = new LoginDao();
	LoginDto dto = dao.getOneMember(request.getParameter("currid"));
	
	dto.setId(request.getParameter("id"));
	dto.setName(request.getParameter("name"));
	dto.setEmail(request.getParameter("email"));
	dto.setBirth(request.getParameter("birth"));
	
	dao.updateMember(dto);
	
	session.setAttribute("id", dto.getId());

%>
<script>
	alert("회원정보가 수정되었습니다.");
	window.location.href="<%=request.getContextPath()%>/index.jsp?main=login/MyPage.jsp?id=<%=dto.getId()%>"
</script>