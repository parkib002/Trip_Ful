<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link rel="stylesheet" href="../css/boardListStyle.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<meta charset="UTF-8">
<title>Insert title here</title>
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
