<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String subPage = request.getParameter("sub");
    if (subPage == null || subPage.isEmpty()) {
        subPage = "notice.jsp";
    }
    
    String keywordFromRequest = request.getParameter("keyword");
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
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp">공지사항</a>
                        </td>
                        <td class="<%= (subPage.equals("event.jsp")) ? "active" : "" %>">
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=event.jsp">이벤트</a>
                        </td>
                        <td class="<%= (subPage.equals("support.jsp")) ? "active" : "" %>">
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp">고객센터</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </div>
</div>

<br><br>
<!-- 검색창 -->
<div class="container my-3 board-search-container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <form action="<%= request.getContextPath() %>/index.jsp" method="get" class="d-flex" id="boardPageGlobalSearchForm">
                <%-- main 파라미터를 boardSearchResults.jsp로 직접 지정 --%>
                <input type="hidden" name="main" value="board/boardSearchResult.jsp"> 
                
                <input class="form-control me-2" type="search"
                       id="boardPageGlobalSearchInput"
                       name="keyword"
                       value="<%= keywordFromRequest != null ? keywordFromRequest.replace("\"", "&quot;") : "" %>" 
                       placeholder="게시판 통합 검색"
                       aria-label="게시판 통합 검색">
                <button class="btn" type="submit"
                style="width: 100px; height: 50px;
                background-color: #2c3e50; color: white;">
                    <i class="bi bi-search"></i> 검색
                </button>
            </form>
        </div>
    </div>
</div>

<div class="layout main">
    <jsp:include page="<%= subPage %>" />
</div>