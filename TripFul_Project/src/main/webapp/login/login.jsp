<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.security.SecureRandom" %>
<%@ page import="java.math.BigInteger" %>
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
String id = null;
String clientId = "IajLk4vELxMTjBeM9JGp";//애플리케이션 클라이언트 아이디값";
String redirectURI = URLEncoder.encode("http://localhost:8080/TripFul_Project/index.jsp?main=login/naverLoginAction.jsp", "UTF-8");
SecureRandom random = new SecureRandom();
String state = new BigInteger(130, random).toString();
String apiURL = "https://nid.naver.com/oauth2.0/authorize?response_type=code"
     + "&client_id=" + clientId
     + "&redirect_uri=" + redirectURI
     + "&state=" + state;
session.setAttribute("state", state);
if (session.getAttribute("id") != null) {
	id = (String) session.getAttribute("id");
}

%>
<script>
		$(function() {
			// JSP에서 받은 login 값 자바스크립트 변수에 저장
			const loginFail = "<%=login%>";

			// 실패 값이 "1"이면 알림 출력
			if (loginFail === "1") {
				alert("아이디 또는 비밀번호를 다시 확인해주세요");
			}
			
			<%
			if (id != null) {
			%>
				$("#check").prop("checked",true);
				$("#user").val('<%=id%>');
<%}%>
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

				<%
				//로그인 페이지
				%>
				<div class="sign-in-htm">
					<form action="./login/loginAction.jsp" method="post"
						onsubmit="return chkSignIn()">
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
							<a href="index.jsp?main=./login/forgotPw.jsp">Forgot
								Password?</a>
						</div>
						<div class="social_login">
							<img src="./login/social_img/google.png"> <img
								src="./login/social_img/kakao.png"> <img
								src="./login/social_img/naver.png" onclick="location.href='<%=apiURL%>'">
						</div>
					</form>
				</div>

				<%
				//회원가입 페이지
				%>
				<div class="sign-up-htm">
					<form action="index.jsp?main=./login/signupAction.jsp"
						method="post" onsubmit="return chkSignUp()">
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
							<img src="./login/social_img/google.png" id="google-signin-signup" alt="Google로 회원가입"> <img
								src="./login/social_img/kakao.png"> <img
								src="./login/social_img/naver.png">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./login/JavaScript/signupJS.js"></script>
<script>
	// Google 로그인 성공 시 호출될 콜백 함수
	function googleHandle(response) {
		console.log("Google ID 토큰: " + response.credential);
		const idToken = response.credential;

		// ID 토큰을 백엔드 서블릿으로 전송 (서블릿 URL은 실제 환경에 맞게 수정)
		fetch("./googleLogin", { 
			method: "POST",
			headers: {
				"Content-Type": "application/x-www-form-urlencoded",
			},
			body: "idtoken=" + idToken
		})
		.then(res => {
			if (!res.ok) { // HTTP 상태 코드가 200-299 범위가 아닐 경우
				throw new Error('서버 응답 오류: ' + res.status);
			}
			return res.json();
		})
		.then(data => {
			console.log("서버 응답:", data);
			if (data.loginSuccess) {
				$('#loginStatus').text(data.userName + "님, 환영합니다!");
				// 로그인 성공 후 메인 페이지 또는 대시보드로 리디렉션
				// 예: window.location.href = "main.jsp"; 
				alert(data.userName + "님, Google 계정으로 성공적으로 로그인(또는 회원가입) 되었습니다.");
				// 실제로는 페이지를 이동시키는 것이 좋습니다.
				// window.location.href = "index.jsp"; // 예시: 메인 페이지로 이동
			} else {
				$('#loginStatus').text("로그인 실패: " + (data.message || "서버에서 오류가 발생했습니다."));
				alert("Google 로그인 실패: " + (data.message || "서버 오류"));
			}
		})
		.catch(error => {
			console.error("서버 전송 또는 처리 오류:", error);
			$('#loginStatus').text("로그인 요청 중 오류 발생: " + error.message);
			alert("로그인 요청 중 오류 발생: " + error.message);
		});
	}
</script>
</html>