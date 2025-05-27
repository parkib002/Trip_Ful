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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<title>Insert title here</title>
<%
request.setCharacterEncoding("utf-8");
String name = request.getParameter("name");
String email = request.getParameter("email");
String id = request.getParameter("id");

LoginDao dao = new LoginDao();

String pw = dao.findPW(name, email, id);
%>
</head>
<body>
	<div>
		<div>
			<%
			if (pw.equals("")) {
			%>
			<span>일치하는 유저의 정보를 찾을 수 없습니다.</span>
			<%
			} else {
			%><form>
			<input type="hidden" value=<%=id %> name="id">
			<input type="hidden" value=<%=pw %> id="pw">
				<table class="table table-border">
					<tr>
					
						<th>새 비밀번호 입력</th>
						<td><input type="password" class="form-control"
							name="password" id="n_pw"></td>
					</tr>
					<tr>
						<th>비밀번호 재입력</th>
						<td><input type="password" class="form-control" id="r_pw"></td>
					</tr>
				</table>
				<div style="text-align: center">
					<button type="button" onclick="changePass()">비밀번호 변경</button>
				</div>
			</form>
			<%
			}
			%>
		</div>
	</div>
</body>
<script src="./JavaScript/forgotJS.js"></script>
</html>