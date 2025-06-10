<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String subPage = request.getParameter("sub");
    if (subPage == null || subPage.isEmpty()) {
        subPage = "notice.jsp";
    }
    
    String keywordFromRequest = request.getParameter("keyword");
%>
<div class="board_menu">
    <ul class="board_menu_list">
        <li class="<%= (subPage.equals("notice.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp">공지사항</a>
        </li>
        <li class="<%= (subPage.equals("event.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=event.jsp">이벤트</a>
        </li>
        <li class="<%= (subPage.equals("support.jsp")) ? "active" : "" %>">
            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp">고객센터</a>
        </li>
    </ul>
</div>



<div class="layout main">
    <jsp:include page="<%= subPage %>" />
</div>