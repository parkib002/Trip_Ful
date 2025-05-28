<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%--
    boardList.jsp는 index.jsp에 포함될 부분이므로,
    <!DOCTYPE html>, <html>, <head>, <body> 태그는 필요 없습니다.
    만약 해당 태그들이 있다면 제거해주세요.
    CSS와 JS 링크도 index.jsp에서 관리하는 것이 좋습니다.
--%>

<%
    String subPage = request.getParameter("sub");
    if (subPage == null || subPage.isEmpty()) { // .equals("") 보다 .isEmpty()가 더 안전합니다.
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
    <%-- 이 부분은 boardList.jsp와 같은 폴더(board/)에 notice.jsp, event.jsp, support.jsp가 있다고 가정합니다. --%>
    <%-- 이 subPage들도 HTML 조각(fragment)이어야 합니다. --%>
    <jsp:include page="<%= subPage %>" />
</div>