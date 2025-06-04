<%@page import="login.SocialDto"%>
<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%	
	request.setCharacterEncoding("utf-8");
	LoginDto dto = new LoginDto();
	LoginDao dao = new LoginDao();
	String id = request.getParameter("id");
	
	dto.setName(request.getParameter("name"));
	dto.setId(id);
	dto.setPw(request.getParameter("pw"));
	dto.setEmail(request.getParameter("email"));
	dto.setBirth(request.getParameter("birth"));
	
	dao.insertMember(dto);
	if(session.getAttribute("social")!=null){
		SocialDto s_dto = (SocialDto)session.getAttribute("social");
		LoginDto temp_dto = dao.getOneMember(id);
		s_dto.setMember_idx(temp_dto.getIdx());
		session.removeAttribute("social");
		dao.insertSocialMem(s_dto);
	}
	
	%>
	<script type="text/javascript">
	    alert("회원가입이 완료되었습니다. 로그인 페이지로 이동합니다."); // 선택적 알림
	    window.location.href = "<%=request.getContextPath()%>/index.jsp?main=login/login.jsp";
	</script>
	<%
	
%>