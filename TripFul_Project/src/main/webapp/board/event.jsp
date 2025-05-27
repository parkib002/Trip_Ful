<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
<style type="text/css">

@import url('https://fonts.googleapis.com/css?family=Roboto:400,300');


.pagination-container {
	margin: 100px auto;
	text-align: center;
	color: #2c3e50;
	font-family: 'Roboto', sans-serif;
	font-weight: 400;
}

.pagination {
	position: relative;
}

.pagination a {
	position: relative;
	display: inline-block;
	color: #2c3e50;
	text-decoration: none;
	font-size: 1.2rem;
	padding: 8px 16px 10px;
}

.pagination a:before {
	z-index: -1;
	position: absolute;
	height: 100%;
	width: 100%;
	content: "";
	top: 0;
	left: 0;
	background-color: #2c3e50;
	border-radius: 24px;
	transform: scale(0);
	transition: all 0.2s;
}

.pagination a:hover,
.pagination a.pagination-active {
	color: #fff;
}

.pagination a:hover:before,
.pagination a.pagination-active:before {
	transform: scale(1);
}

.pagination-newer {
	margin-right: 50px;
}

.pagination-older {
	margin-left: 50px;
}
	.notice-wrapper {
	margin-top: 60px;
	display: flex;
	flex-direction: column;
	align-items: center; /* 자식들을 수평 중앙 정렬 */
}

.notice-header {
	width: 1400px;
}

.notice-header hr {
	width: 100%;
	margin: 0;
	border: none;
	border-top: 3px solid black;
}

.notice-table {
	width: 1400px;
}

</style>
</head>
<body>
<div class="notice-wrapper">
	<div class="notice-header">
		<h3><i class="bi bi-x-diamond-fill">  </i><b>이벤트</b></h3>
		<hr>
	</div>
	<br>
	<table class="table table-hover notice-table" style="width: 1400px;">
		<thead>
			<tr>
				<th scope="col">번호</th>
				<th scope="col">제목</th>
				<th scope="col">작성자</th>
				<th scope="col">작성일</th>
				<th scope="col">조회수</th>
			</tr>
		</thead>
		<tbody>
		<%
			for(int i=0;i<10;i++)
			{%>
				<tr>
					<th scope="row"><%=i+1%></th>
					<td>제목</td>
					<td>손흥민</td>
					<td>2025-05-21</td>
					<td>3</td>
				</tr>
			<%}
		%>
		</tbody>
	</table>
	
	<nav class="pagination-container">
		<div class="pagination">
				<a class="pagination-newer" href="#">이전</a>
				<span class="pagination-inner">
					<a class="pagination-active" href="#">1</a>
					<a href="#">2</a>
					<a href="#">3</a>
					<a href="#">4</a>
					<a href="#">5</a>
					<a href="#">6</a>
				</span>
				<a class="pagination-older" href="#">다음</a>
		</div>
</nav>
</div>

</body>
</html>