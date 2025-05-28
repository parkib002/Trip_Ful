<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="ModalStyle.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>

</head>

<body>
<%
	
%>
	<!-- 모달 버튼 -->
	<button id="modalBtn">리뷰 작성</button>

	<!-- 모달 창 -->
	<div id="myModal" class="modal">
		<form action="review/reviewaddAction.jsp" method="post"
			class="modalfrm" enctype="multipart/form-data">
			<div align="center" class="modal-head">
				<h4>관광지 이름</h4>
			</div>
			<div class="modal-content">
				<table>
					<tr>
						<td><b>닉네임</b><br> <br></td>
					</tr>
					<tr>
						<td class="input-group"><span>별점</span> &nbsp; <input
							type="hidden" name="review_star" id="review_star" value="0">
							<div class="star_rating">
								​​<span class="star" value="1"></span> ​​ 
								<span class="star" value="2"> </span> ​​
								<span class="star" value="3"> </span> ​​
								<span class="star" value="4"> </span> ​​ 
								<span class="star" value="5"> </span>
							</div></td>
					</tr>
					<tr>
						<td><textarea class="review_content" name="review_content"
								required="required"></textarea></td>
					</tr>
					<tr>
						<td>
							<div id="show" >
								<label class="btn-upload">
									<i class="bi bi-camera-fill camera"></i>
									<input type="file" name="review_img" id="file">
								</label>
							</div>
							<br><br>
						</td>
					</tr>

				</table>
			</div>
			<div class="modal-foot">
				<button type="button" class="close" id="closeBtn">취소</button>
				<button type="submit" class="save">게시</button>
			</div>
		</form>
	</div>
	 
</body>
<script src="./JavaScript/ModalJs.js"></script>
</html>