<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardNoticeDto"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardNoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<%
BoardNoticeDao dao=new BoardNoticeDao();

String loginok=null;
String id=null;

//세션에서 id 값을 가져올 때 null 체크 추가 (NPE 방지)
if( session.getAttribute("loginok")!=null)
{
loginok=(String)session.getAttribute("loginok");
if(session.getAttribute("id") != null) {
id=(String)session.getAttribute("id");
}
}

//페이징처리
//전체갯수
int totalCount=dao.getTotalCount();
int perPage=10; //한페이지에 보여질 글의 갯수
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

//전체데이타
List<BoardNoticeDto> list=dao.getList(startNum, perPage);

SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<body>
<div class="notice-wrapper">
	<div class="notice-header">
		<h3><i class="bi bi-x-diamond-fill">  </i><b>공지사항</b></h3>
		<%
			if("admin".equals(loginok))
			{%>
				<a style="float: right; text-decoration: none; color: black;"
				href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=noticeAddForm.jsp">
					<i class="bi bi-plus-square"></i>&nbsp;글쓰기
				</a>
			<%}
		%>
		<hr class="mt-2">
	</div>
	<br>
	<table class="table table-hover notice-table">
		<thead>
			<tr>
				<th scope="col" style="width: 8%;">번호</th>
            	<th scope="col" style="width: 47%;">제목</th>
            	<th scope="col" style="width: 15%; text-align: center;">작성자</th>
           		<th scope="col" style="width: 20%;">작성일</th>
            	<th scope="col" style="width: 10%; text-align: center;">조회수</th>
			</tr>
		</thead>
		<tbody>
		
		
		
		<%
		
			if(list.isEmpty())
			{%>
				<tr>
					<td colspan="5" align="center"><b>등록된 게시글이 없습니다</b></td>
				</tr>
			<%}else{
					for(int i=0;i<list.size();i++)
					{
						BoardNoticeDto dto=list.get(i);
					%>
						<tr>
							<th scope="row">&nbsp;<%=no - i%></th>
							<td>
								<a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=noticeDetail.jsp&idx=<%=dto.getNotice_idx() %>"
								style="text-decoration: none; color: black;">
									<%=dto.getNotice_title() %>
								</a>
							</td>
							<td align="center"><%=dto.getNotice_writer() %></td>
							<td><%=sdf.format(dto.getNotice_writeday()) %></td>
							<td align="center"><%=dto.getNotice_readcount() %></td>
						</tr>
					<%}
			}
		%>
		</tbody>
	</table>
	
	<nav class="pagination-container">
			<div class="pagination">
				<span class="pagination-inner"> <%
					if(startPage>1){%> <a class="pagination-newer"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp&currentPage=<%=startPage-perBlock%>">이전</a>
					<%}
				
				for(int pp=startPage;pp<=endPage;pp++)
				{
					if(pp==currentPage)
					{%> <a class="pagination-active"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}else{%> <a class="page-link" <%-- 클래스명 일관성 --%>
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}
				}
				
				//다음
				if(endPage<totalPage)
				{%> <a class="pagination-older"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp&currentPage=<%=endPage+1%>">다음</a>
					<%}
				%>
			</div>
		</nav>
</div>

</body>
</html>