<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 문의 답글 작성</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<style>
    body { background-color: #f8f9fa; }
    .reply-header {
        background-color: #2C3E50;
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
    // 로그인 정보 확인 (답변 작성은 주로 관리자 또는 로그인 사용자)
    String loginok_reply = (String)session.getAttribute("loginok");
    String userId_reply = (String)session.getAttribute("id");

    if (userId_reply == null) { // 간단히 로그인 여부만 체크 (또는 특정 권한 체크)
        out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/index.jsp?main=login/loginMain.jsp';</script>");
        return;
    }

    // 부모 글 정보 파라미터 받기 (support.jsp에서 넘어온 값들)
    String parent_idx_str = request.getParameter("parent_idx"); // 참고용 부모 ID
    String parent_regroup_str = request.getParameter("regroup");
    String parent_restep_str = request.getParameter("restep");   // 부모 글의 restep
    String parent_relevel_str = request.getParameter("relevel"); // 부모 글의 relevel

    // 파라미터 유효성 검사
    if (parent_idx_str == null || parent_regroup_str == null || parent_restep_str == null || parent_relevel_str == null) {
        out.println("<script>alert('잘못된 접근입니다. (필수정보 누락)'); history.back();</script>");
        return;
    }
    
	 // 새로 추가된 parent_title 파라미터를 받습니다. (웹 컨테이너가 자동으로 디코딩해줌)
    String parentTitle = request.getParameter("parent_title");
    if (parentTitle == null || parentTitle.trim().isEmpty()) {
        parentTitle = "원본글"; // 혹시 파라미터가 없을 경우를 대비한 기본값
    }

    // 동적으로 답변 제목을 생성합니다.
    String replyTitle = "Re: [" + parentTitle + "] 문의에 대한 답변입니다.";
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
        <%-- parent_idx는 참고용이며, 실제 답글 DTO의 qna_idx로 사용하지 않음 --%>
        <%-- <input type="hidden" name="parent_idx_for_reference" value="<%= parent_idx_str %>"> --%>
        <input type="hidden" name="regroup" value="<%= parent_regroup_str %>">
        <input type="hidden" name="restep" value="<%= parent_restep_str %>">     <%-- 부모의 restep --%>
        <input type="hidden" name="relevel" value="<%= parent_relevel_str %>">   <%-- 부모의 relevel --%>
        
        <div class="mb-3">
            <label for="qna_writer" class="form-label">답변 작성자</label>
            <input type="text" class="form-control" id="qna_writer" name="qna_writer" value="<%= userId_reply %>" readonly>
        </div>

        <div class="mb-3">
            <label for="qna_title" class="form-label">답변 제목</label>
            <input type="text" class="form-control" id="qna_title" name="qna_title" value="<%= replyTitle.replace("\"", "&quot;") %>" required>
        </div>

        <div class="mb-3">
            <label for="qna_content" class="form-label">답변 내용</label>
            <textarea class="form-control" id="qna_content" name="qna_content" rows="10" placeholder="답변 내용을 작성해주세요" required></textarea>
        </div>
        
        <div class="mb-3">
            <label for="qna_img" class="form-label">파일 첨부 (선택)</label>
            <input class="form-control" type="file" id="qna_img" name="qna_img">
        </div>
        
        <%-- 답변글은 기본적으로 공개로 처리하거나, 필요시 비밀글 옵션 추가 --%>
        <%-- <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="qna_private" name="qna_private" value="1">
            <label class="form-check-label" for="qna_private">비밀 답변</label>
        </div> --%>


        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <button type="button" class="btn btn-secondary me-md-2" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-custom-reply">답변 등록</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {
        $("#replyForm").submit(function(event) {
            if ($("#qna_title").val().trim() === "") {
                alert("답변 제목을 입력해주세요.");
                $("#qna_title").focus();
                return false; // 폼 제출 중단
            }
            if ($("#qna_content").val().trim() === "") {
                alert("답변 내용을 입력해주세요.");
                $("#qna_content").focus();
                return false; // 폼 제출 중단
            }
            // 추가적인 유효성 검사 가능
        });
    });
</script>

</body>
</html>