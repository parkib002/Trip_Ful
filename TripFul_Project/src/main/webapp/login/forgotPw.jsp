<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Nanum+Brush+Script&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link href="./login/loginStyle.css" rel="stylesheet">

<title>Insert title here</title>

</head>
<body>
	<div class="login-wrap">
		<div class="login-html">
			<input id="tab-1" type="radio" name="tab" class="sign-in" checked><label
				for="tab-1" class="tab">Find ID</label> <input id="tab-2"
				type="radio" name="tab" class="sign-up"><label for="tab-2"
				class="tab">Find PW</label>
			<div class="login-form">
				<%
				//아이디 찾기
				%>
				<div class="sign-in-htm">
					<form action="./login/findID.jsp" id="findID" name="findID" method="post">
						<div class="group">
							<label for="user" class="label">이름</label> <input id="name"
								type="text" class="input" name="name" required="required">
						</div>
						<div class="group">
							<label for="email" class="label">이메일</label> <input id="email"
								type="email" class="input" name="email" required="required">
						</div>
						<br>
						<div class="group">
							<input type="button" class="button" id="idBtn"
								onclick="findfunc()" value="아이디 찾기">
						</div>
					</form>
				</div>

				<%
				//비밀번호 찾기
				%>
				<div class="sign-up-htm">
					<form
						action="<%=request.getContextPath()%>/index.jsp?main=login/changeForm.jsp?status=1"
						method="post" id="findPW">
						<div class="group">
							<label for="user" class="label">이름</label> <input name="name"
								type="text" class="input" required="required" id="f_name">
						</div>
						<div class="group">
							<label for="user" class="label">아이디</label> <input name="id"
								type="text" class="input" required="required" id="f_id">
						</div>
						<div class="group">
							<label for="pass" class="label">이메일</label> <input name="email"
								type="email" class="input" required="required" id="f_email">
						</div>
						<br>
						<div class="group">
							<input type="button" class="button" value="비밀번호 변경" onclick="findPass()">
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
</body>
<script src="./login/JavaScript/forgotJS.js"></script>

</html>