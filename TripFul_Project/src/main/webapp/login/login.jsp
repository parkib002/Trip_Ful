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
	<link href="./login/loginStyle.css" rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>Insert title here</title>
<%
    String login = request.getParameter("login");
%>
	<script>
		$(function() {
			// JSP에서 받은 login 값 자바스크립트 변수에 저장
			const loginFail = "<%=login%>";

			// 실패 값이 "1"이면 알림 출력
			if (loginFail === "1") {
				alert("아이디 또는 비밀번호를 다시 확인해주세요");
			}
		});
	</script>
<body>
	<div class="login-wrap">
		<div class="login-html">
			<input id="tab-1" type="radio" name="tab" class="sign-in" checked><label
				for="tab-1" class="tab">Sign In</label> <input id="tab-2"
				type="radio" name="tab" class="sign-up"><label for="tab-2"
				class="tab">Sign Up</label>
			<div class="login-form">
				
				<%//로그인 페이지 %>
				<div class="sign-in-htm">
					<form action="./login/loginAction.jsp" method="post" onsubmit="return chkSignIn()">
						<div class="group">
							<label for="user" class="label">아이디</label> <input id="user"
								type="text" class="input" name="user">
						</div>
						<div class="group">
							<label for="pass" class="label">비밀번호</label> <input id="pass"
								type="password" class="input" data-type="password" name="pass">
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
							<a href="index.jsp?main=./login/forgotPw.jsp">Forgot Password?</a>
						</div>
						<div class="social_login">
						<img src="./login/social_img/google.png">
						<img src="./login/social_img/kakao.png">
						<img src="./login/social_img/naver.png">
						</div>
					</form>
				</div>
				
				<%//회원가입 페이지 %>
				<div class="sign-up-htm">
					<form action="index.jsp?main=./login/signupAction.jsp" method="post"
						onsubmit="return chkSignUp()">
						<div class="group">
							<label for="user" class="label">이름</label> <input name="name"
								type="text" class="input" required="required">
						</div>
						<div class="group">
							<label for="user" class="label">아이디</label> <input name="id"
								type="text" class="input" required="required" id="id">
						</div>

						<div class="group">
							<label for="pass" class="label">비밀번호</label> <input name="pw"
								type="password" class="input" data-type="password"
								required="required" id="pw">
						</div>
						<div class="group">
							<label for="pass" class="label">이메일</label> <input name="email"
								type="email" class="input" required="required">
						</div>
						<div class="group">
							<label for="pass" class="label">생년월일</label> <input name="birth"
								type="text" class="input" required="required" id="birth">
						</div>
						<br>
						<div class="group">
							<input type="submit" class="button" value="Sign Up">
						</div>
						<div class="social_signin">
						<img src="./login/social_img/google.png">
						<img src="./login/social_img/kakao.png">
						<img src="./login/social_img/naver.png">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./login/JavaScript/signupJS.js"></script>
</html>