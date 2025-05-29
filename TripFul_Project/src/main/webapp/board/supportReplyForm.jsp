<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 문의 답글 작성</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%-- 필요시 Summernote CSS/JS 추가 --%>

<style>
    body { background-color: #f8f9fa; }
    .reply-header {
        background-color: #2c3e50; /* 답글 폼 헤더 색상 예시 */
        color: white;
        padding: 30px 20px;
        text-align: center;
        margin-bottom: 30px;
        border-radius: 15px;
    }
    .reply-form-container {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        max-width: 800px;
        margin: 0 auto;
    }
    .form-label { font-weight: bold; }
    .btn-custom-reply { background-color: #2c3e50; color: white; border: none; }
    .btn-custom-reply:hover { background-color: #1a2531; color: white; }
</style>
</head>
<body>
<%
    // 로그인 정보 가져오기
    String loginok_reply = (String)session.getAttribute("loginok");
    String userId_reply = (String)session.getAttribute("id");

    // 답글은 보통 관리자만 작성 가능하므로, "admin" 체크 또는 특정 권한 체크 필요
    // 예시: 관리자가 아니면 접근 불가 (또는 로그인 페이지로)
    if (loginok_reply == null || userId_reply == null /* || !"admin".equals(userId_reply) */ ) { // 관리자 ID가 "admin"이라고 가정
        response.sendRedirect(request.getContextPath() + "/index.jsp?main=login/login.jsp&errMsg=admin_only");
        return;
    }

    // 부모 글 정보 파라미터 받기
    String parent_idx_str = request.getParameter("parent_idx");
    String regroup_str = request.getParameter("regroup");
    String restep_parent_str = request.getParameter("restep"); // 부모 글의 restep
    String relevel_parent_str = request.getParameter("relevel"); // 부모 글의 relevel

    // 파라미터 유효성 검사 (간단하게)
    if (parent_idx_str == null || regroup_str == null || restep_parent_str == null || relevel_parent_str == null) {
        out.println("<script>alert('잘못된 접근입니다. 필요한 정보가 없습니다.'); history.back();</script>");
        return;
    }
    
    // 부모 글 제목 등을 가져와서 표시하고 싶다면 여기서 DAO를 통해 부모 글 정보 조회 가능
    // BoardSupportDao dao_reply = new BoardSupportDao();
    // BoardSupportDto parentDto = dao_reply.getData(Integer.parseInt(parent_idx_str));
    // String parentTitle = (parentDto != null) ? parentDto.getQna_title() : "원본글";

%>
<br><br>
<div class="reply-header">
    <h2>문의 답변 작성</h2>
    <%-- <p>Re: <%= parentTitle %></p> --%>
</div>

<div class="container reply-form-container">
    <h3 class="mb-4">답변 내용</h3>
    <form method="post" action="<%= request.getContextPath() %>/board/supportReplyAction.jsp" id="replyForm" enctype="multipart/form-data">
        
        <%-- 답글 처리에 필요한 부모글 정보 (hidden으로 전달) --%>
        <input type="hidden" name="parent_idx" value="<%= parent_idx_str %>">
        <input type="hidden" name="regroup" value="<%= regroup_str %>">
        <input type="hidden" name="restep_parent" value="<%= restep_parent_str %>">
        <input type="hidden" name="relevel_parent" value="<%= relevel_parent_str %>">
        
        <%-- 답글의 qna_type은 "답변" 등으로 고정하거나, 부모글 유형을 따를 수 있음. 여기서는 생략하고 Action에서 처리 --%>

        <div class="mb-3">
            <label for="qna_writer" class="form-label">답변 작성자</label>
            <input type="text" class="form-control" id="qna_writer" name="qna_writer" value="<%= userId_reply %>" readonly>
        </div>

        <div class="mb-3">
            <label for="qna_title" class="form-label">답변 제목</label>
            <input type="text" class="form-control" id="qna_title" name="qna_title" value="RE: 문의에 대한 답변입니다." required>
        </div>

        <div class="mb-3">
            <label for="qna_content" class="form-label">답변 내용</label>
            <textarea class="form-control" id="qna_content" name="qna_content" rows="10" placeholder="답변 내용을 작성해주세요" required></textarea>
        </div>
        
        <div class="mb-3">
            <label for="qna_img" class="form-label">파일 첨부 (선택)</label>
            <input class="form-control" type="file" id="qna_img" name="qna_img">
            <div class="form-text">스크린샷이나 관련 파일을 첨부하시면 문제 해결에 도움이 됩니다. (최대 5MB)</div>
        </div>
        
        <%-- 답글은 기본적으로 공개 또는 부모글의 상태를 따르도록 할 수 있음. 여기서는 생략하고 Action에서 처리 --%>
        <%-- 비밀글 여부가 필요하다면 추가:
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="qna_private" name="qna_private" value="1">
            <label class="form-check-label" for="qna_private">비밀 답변</label>
        </div>
        --%>

        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <button type="button" class="btn btn-secondary me-md-2" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-custom-reply">답변 등록</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {
        // 간단한 폼 유효성 검사
        $("#replyForm").submit(function(event) {
            if ($("#qna_title").val().trim() === "") {
                alert("답변 제목을 입력해주세요.");
                $("#qna_title").focus();
                return false;
            }
            if ($("#qna_content").val().trim() === "") {
                alert("답변 내용을 입력해주세요.");
                $("#qna_content").focus();
                return false;
            }
        });
    });
</script>

</body>
</html>