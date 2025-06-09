<%@page import="login.LoginDto"%>
<%@page import="login.LoginDao"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.security.SecureRandom"%>
<%@ page import="java.math.BigInteger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Brush+Script&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link href="<%=request.getContextPath()%>/login/loginStyle.css"
	rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://developers.kakao.com/sdk/js/kakao.js"></script>
<%
String id = null;

if(request.getParameter("status")!=null){
	if (request.getParameter("status").equals("1")) {
		id = request.getParameter("id"); 
	%>
	<script>
		$(function() {
			$("#tab-2").prop("checked", true);
			$("#tab-1").prop("disabled", true);
			$("#currpw").attr("required", false);
			$("#curpw").hide();
		})
	</script>
	<%
	}
}

if (session.getAttribute("id") != null) {
id = (String) session.getAttribute("id");
}

LoginDao dao = new LoginDao();
LoginDto dto = dao.getOneMember(id);
%>

<body>
	<div class="login-wrap">
		<div class="login-html">
			<input id="tab-1" type="radio" name="tab" class="sign-in" checked><label
				for="tab-1" class="tab">Change Info</label> <input id="tab-2"
				type="radio" name="tab" class="sign-up"><label for="tab-2"
				class="tab">Change PW</label>
			<div class="login-form">

				<%
				//로그인 페이지
				%>
				<div class="sign-in-htm">
					<form action="<%=request.getContextPath()%>/login/updateMember.jsp"
						method="post" onsubmit="return chkSignIn()">
						<div class="group">
							<label for="user" class="label">이름</label> <input name="name"
								type="text" class="input" required="required" id="name"
								value=<%=dto.getName()%>>
						</div>
						<div class="group">
							<label for="user" class="label">아이디</label> <input name="id"
								type="text" class="input" required="required" id="id"
								value=<%=id%>>
						</div>
						<div class="group">
							<label for="pass" class="label">이메일</label> <input name="email"
								type="email" class="input" required="required"
								value=<%=dto.getEmail()%>>
						</div>
						<div class="group">
							<label for="pass" class="label">생년월일</label> <input name="birth"
								type="text" class="input" required="required" id="birth"
								value=<%=dto.getBirth()%>>
						</div>
						<input type="hidden" value=<%=id %> name="currid">
						<br>
						<div class="group">
							<input type="submit" class="button" value="Change">
						</div>
						<div class="hr"></div>
					</form>
				</div>

				<%
				//회원가입 페이지
				%>
				<div class="sign-up-htm">
					<form action="./login/changePW.jsp" method="post"
						onsubmit="return chkSignUp()">
						<div class="group" id="curpw">
							<label for="user" class="label">현재 비밀번호</label> <input
								name="currpw" type="password" class="input" required="required"
								id="currpw">
						</div>
						<div class="group">
							<label for="pass" class="label">새 비밀번호</label> <input
								name="newpw" type="password" class="input" required="required"
								id="newpw">
						</div>
						<div class="group">
							<label for="pass" class="label">새 비밀번호 재 입력</label> <input
								name="renewpw" type="password" class="input" required="required"
								id="renewpw">
						</div>
						<input name="id"
								type="hidden" class="hidden" required="required" id="id"
								value=<%=id%>>
						<br>
						<div class="group">
							<input type="submit" class="button" value="Change">
						</div>
						<div class="hr"></div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./login/JavaScript/signupJS.js"></script>
</html>