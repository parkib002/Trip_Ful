<%@page import="board.BoardEventDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="../css/noticeStyle.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<%
BoardEventDao dao=new BoardEventDao();

//페이징처리
//전체갯수
int totalCount=1;//dao.getTotalCount();
int perPage=5; //한페이지에 보여질 글의 갯수
int perBlock=5; //한블럭당 보여질 페이지의 갯수
int startNum; //db에서 가져올 글의 시작번호(mysql:0 오라클:1번)
int startPage; //각블럭당 보여질 시작페이지
int endPage;//각블럭당 보여질 끝페이지
int currentPage; //현재페이지
int totalPage; //총페이지

int no; //각페이지당 출력할 시작번호

//현재페이지 읽기,단 null일경우는 1페이지로 준다
if(request.getParameter("currentPage")==null)
	  currentPage=1;
else
	  currentPage=Integer.parseInt(request.getParameter("currentPage"));


//총페이지수를 구한다
//총글의 갯수/한페이지당 보여질개수로 나눔(7/5=1)
//나머지가 1이라도 있으면 무저건 1페이지추가(1+1=2페이지가 필요)
totalPage=totalCount/perPage+(totalCount%perPage==0?0:1);

//각블럭당 보여질 시작페이지
//perBlock=5일경우 현재페이지가 1~5 시작1,끝5
//만약 현재페이지가 13일경우는 시작11,끝15
startPage=(currentPage-1)/perBlock*perBlock+1;
endPage=startPage+perBlock-1;

//총페이지가 23개일경우 마지막 블럭은 끝 25가 아니라 23이다
if(endPage>totalPage)
	  endPage=totalPage;

//각페이지에서 보여질 시작번호
//예: 1페이지-->0  2페이지-->5 3페이지-->10...
startNum=(currentPage-1)*perPage;

//각페이지당 출력할 시작번호
//예를들어 총글갯수가 23   1페이지: 23  2페이지:18  3페이지: 13.....
no=totalCount-(currentPage-1)*perPage;


%>
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
				<th scope="col" style="width: 8%;">번호</th>
            	<th scope="col" style="width: 47%;">제목</th>
            	<th scope="col" style="width: 15%;">작성자</th>
           		<th scope="col" style="width: 20%;">작성일</th>
            	<th scope="col" style="width: 10%;">조회수</th>
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