<%@page import="login.LoginDto"%>
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
<link href="./loginStyle.css" rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>Insert title here</title>
<%
	String id = (String)session.getAttribute("id");
	LoginDao dao = new LoginDao();
	LoginDto dto = dao.getOneMember(id);
%>
</head>
<script>
</script>
<body>
	<div class="login-wrap">
		<div class="login-html">
			<input id="tab-2"
				type="radio" name="tab" class="sign-up" checked><label for="tab-2"
				class="tab">Update Info</label>
			<div class="login-form">
				<%//로그인 페이지 %>
				<div class="sign-in-htm">
					<form action="loginAction.jsp" method="post" onsubmit="return chkSignIn()">
						<div class="group">
							<label for="user" class="label">아이디</label> <input id="user"
								type="text" class="input" name="user">
						</div>
						<div class="group">
							<input id="pass" type="hidden" class="input" data-type="password" name="pass">
						</div>
						<div class="group">
							<input id="check" type="checkbox" class="check" name="check">
							<label for="check"><span class="icon"></span> 아이디 기억</label>
						</div>
						<div class="group">
							<input type="submit" class="button" value="Sign In">
						</div>
						<div class="hr"></div>
						<div class="foot-lnk">
							<a href="./forgotPw.jsp">Forgot Password?</a>
						</div>
					</form>
				</div>
				
				<%//회원가입 페이지 %>
				<div class="sign-up-htm">
					<form action="./signupAction.jsp" method="post"
						onsubmit="return chkSignUp()" id="update">
						<div class="group">
							<label for="user" class="label">이름</label> <input name="name"
								type="text" class="input" required="required" value="<%=dto.getName() %>">
						</div>
						<div class="group">
							<input name="pw" type="hidden" class="input" data-type="password"
								required="required" id="pw" value="<%=dto.getPw()%>">
						</div>
						<div class="group">
							<label for="pass" class="label">이메일</label> <input name="email"
								type="email" class="input" required="required" value="<%=dto.getEmail()%>">
						</div>
						<div class="group">
							<label for="pass" class="label">생년월일</label> <input name="birth"
								type="text" class="input" required="required" id="birth" value="<%=dto.getBirth()%>">
						</div>
						<br>
						<div class="group">
							<input type="submit" class="button" value="Update Info">
						</div>
						<div class="hr"></div>
						<div class="foot-lnk">
							<a href="./findPW.jsp" onclick="window.open(this.href, '_blank', 'width=400, height=200 scrollbars=no, resizable=no, top=300, left=800'); return false;">Change Password?</a>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./JavaScript/signupJS.js"></script>
</html>