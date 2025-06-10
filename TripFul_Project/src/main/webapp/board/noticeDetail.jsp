<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardNoticeDto" %> <%-- Notice DTO로 변경 --%>
<%@ page import="board.BoardNoticeDao" %> <%-- Notice DAO로 변경 --%>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String idx = request.getParameter("idx"); // 공지사항 ID (파라미터명은 eventDetail과 동일하게 idx로 가정)

    BoardNoticeDao dao = new BoardNoticeDao(); // Notice DAO 사용

    // ----- 조회수 증가 처리 -----
    if (idx != null && !idx.trim().isEmpty()) {
        String readKey = "noticeRead_" + idx; // 세션 키 prefix 변경
        if (session.getAttribute(readKey) == null) {
            dao.updateReadCount(idx); // Notice DAO의 메소드 사용
            session.setAttribute(readKey, "true");
        }
    }
    // ----- 조회수 증가 처리 끝 -----

    BoardNoticeDto dto = null; // Notice DTO 사용
    if (idx != null && !idx.trim().isEmpty()) {
        dto = dao.getData(idx); // Notice DAO의 getData 메소드 사용
    }

    // 관리자 여부 확인
    String adminSessionValue = (String) session.getAttribute("loginok");
    boolean isAdmin = "admin".equals(adminSessionValue);
    // String loggedInUserId = (String) session.getAttribute("id"); // 댓글 기능 없으므로 주석 처리 또는 삭제 가능

    if (dto == null) {
        out.println("<script>alert('해당 공지사항을 찾을 수 없습니다.'); history.back();</script>");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= dto.getNotice_title() %> - 공지사항 상세</title> <%-- DTO 및 페이지 종류에 맞게 변경 --%>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style type="text/css">
.detailContainer { max-width: 1000px; margin: 30px auto; padding: 20px; }
.card-header h3 { margin-bottom: 0; }
.notice-content img { max-width: 100%; height: auto; border-radius: 8px; margin-top: 10px; margin-bottom: 10px; } /* 클래스명 event-content -> notice-content (선택적) */
/* 댓글 관련 CSS는 필요 없어짐 */
.btn-sm i { vertical-align: middle; }

</style>
</head>
<body>
<div class="container detailContainer mt-5 mb-5">
    <div class="card shadow-sm">
        <div class="card-header bg-light">
            <h3><%= dto.getNotice_title() %></h3> <%-- DTO 필드명 변경 --%>
        </div>
        <div class="card-body">
            <p class="card-text">
                <small class="text-muted">
                    <i class="bi bi-person"></i> 작성자: <%= dto.getNotice_writer() %> | <%-- DTO 필드명 변경 --%>
                    <i class="bi bi-calendar-event"></i> 작성일: <%= sdf.format(dto.getNotice_writeday()) %> | <%-- DTO 필드명 변경 --%>
                    <i class="bi bi-eye"></i> 조회수: <%= dto.getNotice_readcount() %> <%-- DTO 필드명 변경 --%>
                </small>
            </p>
            <hr>
            
            <div class="notice-content mt-3"> <%-- 클래스명 event-content -> notice-content (선택적) --%>
                <%= dto.getNotice_content() %> <%-- DTO 필드명 변경 --%>
            </div>
        </div>
        <div class="card-footer text-end bg-light">
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=notice.jsp'"> <%-- 목록 페이지 sub 변경 --%>
                <i class="bi bi-list-ul"></i>&nbsp;목록
            </button>
            <% if (isAdmin) { %>
            <button type="button" class="btn btn-sm btn-outline-primary" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=noticeUpdateForm.jsp&idx=<%=idx %>'"> <%-- 수정 폼 sub 변경 --%>
                <i class="bi bi-pencil-square"></i>&nbsp;수정
            </button>
            <button type="button" class="btn btn-sm btn-outline-danger"
                    onclick="if(confirm('정말로 이 공지사항을 삭제하시겠습니까?')) { location.href='<%= request.getContextPath() %>/board/noticeDeleteAction.jsp?idx=<%=idx %>'; }"> <%-- 삭제 Action 변경 --%>
                <i class="bi bi-trash"></i>&nbsp;삭제
            </button>
            <% } %>
        </div>
    </div>

    <%-- 댓글 섹션 (비활성화 상태) --%>
    <div class="card mt-4 shadow-sm">
        <div class="card-header bg-light">
            <h5><i class="bi bi-chat-dots-fill"></i> 댓글</h5>
        </div>
        <div class="card-body">
            <p class="text-muted text-center">댓글을 달 수 없는 게시판입니다.</p>
            <%-- 또는, 댓글 관련 모든 HTML 요소를 아예 삭제해도 됩니다. --%>
            <%-- 
            <% if (loggedInUserId != null) { %>
            <form id="commentForm" class="mb-4"> ... </form>
            <% } else { %>
            <p class="text-muted"> ... </p>
            <% } %>
            <hr>
            <div id="commentList"> ... </div>
            --%>
        </div>
    </div>
    <%-- 댓글 섹션 끝 --%>
</div>

<%-- 댓글 관련 JavaScript는 필요 없으므로 삭제 또는 주석 처리 --%>
<%-- 
<script>
$(document).ready(function() {
    // const currentNoticeId = '<%= idx %>'; // 변수명 변경
    // const currentUser = '<%= loggedInUserId == null ? "" : loggedInUserId %>';
    // const isAdminUser = <%= isAdmin %>;

    // function loadComments(noticeId) { ... } // 내용 비우거나 삭제
    // loadComments(currentNoticeId);
    // $('#submitComment').click(function() { ... }); // 내용 비우거나 삭제
    // $('#commentList').on('click', '.delete-comment', function() { ... }); // 내용 비우거나 삭제
    // $('#commentList').on('click', '.like-comment', function() { ... }); // 내용 비우거나 삭제
});
</script>
--%>
</body>
</html>