<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String subPage = request.getParameter("sub");
    if (subPage == null || subPage.isEmpty()) {
        subPage = "notice.jsp";
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
                        <td class="<%= (subPage.equals("notice.jsp")) ? "active" : "" %>">
                            <%-- 경로 수정: "../" 제거하고 request.getContextPath() 사용 --%>
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp">공지사항</a>
                        </td>
                        <td class="<%= (subPage.equals("event.jsp")) ? "active" : "" %>">
                            <%-- 경로 수정: "../" 제거하고 request.getContextPath() 사용 --%>
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=event.jsp">이벤트</a>
                        </td>
                        <td class="<%= (subPage.equals("support.jsp")) ? "active" : "" %>">
                            <%-- 경로 수정: "../" 제거하고 request.getContextPath() 사용 --%>
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp">고객센터</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

<div class="layout main">
    <jsp:include page="<%= subPage %>" />
</div>