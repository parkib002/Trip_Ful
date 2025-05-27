<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
<style type="text/css">
	.title {
		border: 1px solid gray;
		height: 310px;
		background-color: #6994BF;
		display: block; /* flex 제거 */
		padding: 30px 50px; /* 내부 여백 추가 */
		color: white;
	}

	.title-content {
		max-width: 1200px;
		margin: 0 auto;
		margin-top: 60px; /* 위쪽에서 20px 내려오기 */
	}

	.title-content h1 {
		margin: 0;
		font-size: 36px;
		font-weight: normal; /* 볼드 제거 */
		text-align: left; /* 왼쪽 정렬 */
	}

	.title-content .desc {
		font-size: 18px;
		margin-bottom: 20px;
		text-align: left; /* 왼쪽 정렬 */
	}

	.board_menu td {
		width: 300px;
		height: 80px;
		font-size: 22px;
		cursor: pointer;
		text-align: center;
		vertical-align: middle;
		border: 1px solid #ccc;
		padding: 0;
		font-weight: normal; /* td 기본은 normal */
	}

	.board_menu td a {
		display: block;
		color: inherit;
		text-decoration: none;
		height: 100%;
		width: 100%;
		line-height: 80px;
	}

	.board_menu td.active {
		background-color: #2C3E50;
		color: white;
		font-weight: bold;
	}
	

</style>
</head>
<body>
<%
    String mainPage = request.getParameter("main");
    if(mainPage == null || mainPage.equals("")) {
        mainPage = "notice.jsp";
    }
%>
<div class="board_header">
	<div class="title">
		<div class="title-content">
			<h1>소식</h1>
			<div class="desc">새로운 소식</div>
			<div class="board_menu">
				<table class='table table-bordered'>
					<tr>
						<td class="<%= (mainPage.equals("notice.jsp")) ? "active" : "" %>">
							<a href="boardList.jsp?main=notice.jsp">공지사항</a>
						</td>
						<td class="<%= (mainPage.equals("event.jsp")) ? "active" : "" %>">
							<a href="boardList.jsp?main=event.jsp">이벤트</a>
						</td>
						<td class="<%= (mainPage.equals("support.jsp")) ? "active" : "" %>">
							<a href="boardList.jsp?main=support.jsp">고객센터</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>

<div class="layout main">
	<jsp:include page="<%= mainPage %>" />
</div>

</body>
</html>
