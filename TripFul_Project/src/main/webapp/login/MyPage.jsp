<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gaegu&family=Hi+Melody&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/login/myPageDesign.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<body>
	<aside class="side-bar">
		<section class="side-bar__icon-box">
			<section class="side-bar__icon-1">
				<div></div>
				<div></div>
				<div></div>
			</section>
		</section>
		<ul>
			<li><span><i class="fa-solid fa-earth-americas"></i>&nbsp;홍길동</span>
				<ul>
					<li><a href="#">내 정보</a></li>
					<li><a href="#">내 리뷰</a></li>
					<li><a href="#">위시리스트</a></li>
					<li><a href="#">내 코스</a></li>
				</ul></li>
		</ul>
	</aside>
	<div class="container mt-3">
		<div class="MyInfo">
			<h1>내 정보</h1>
			<ul>
				<li>이름 : </li>
				<li>연령대 : </li>
				<li>이메일 : </li>
				<li>아이디 : </li>
			</ul>
			<div class="update-btn">
				<button class="btn btn-info">정보 수정</button>
			</div>
		</div>
		<div class="MyReview">
		<h1>내 리뷰</h1>
			
		</div>
		<div class="WishList">
		<h1>위시리스트</h1>
			
		</div>
	</div>
</body>
</html>