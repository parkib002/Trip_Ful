<%@page import="board.BoardSupportDto"%>
<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 문의 수정</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<style>
    body { background-color: #f8f9fa; }
    .edit-header {
        background-color: #5cb85c;
        color: white;
        padding: 30px 20px;
        text-align: center;
        margin-bottom: 30px;
        border-radius: 15px;
    }
    .edit-form-container {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        max-width: 800px;
        margin: 0 auto;
    }
    .form-label { font-weight: bold; }
    .btn-custom-edit { background-color: #5cb85c; color: white; border: none; }
    .btn-custom-edit:hover { background-color: #4cae4c; color: white; }
    .current-img-info { font-size: 0.9em; color: #6c757d; }
</style>
</head>
<body>
<%
    // 로그인 정보 가져오기
    String loginok_edit = (String)session.getAttribute("loginok");
    String userId_edit = (String)session.getAttribute("id");

    // 수정할 글의 qna_idx 파라미터 받기
    String qna_idx_str = request.getParameter("qna_idx");

    if (qna_idx_str == null || qna_idx_str.trim().isEmpty()) {
        out.println("<script>alert('잘못된 접근입니다. 수정할 게시글 정보가 없습니다.'); history.back();</script>");
        return;
    }

    BoardSupportDao dao = new BoardSupportDao();
    BoardSupportDto dto = dao.getData(qna_idx_str); 

    if (dto == null) {
        out.println("<script>alert('존재하지 않는 게시글입니다.'); history.back();</script>");
        return;
    }

    boolean isAdmin = "admin".equals(loginok_edit);
    boolean isWriter = userId_edit != null && userId_edit.equals(dto.getQna_writer());

    if (!isAdmin && !isWriter) {
        out.println("<script>alert('수정 권한이 없습니다.'); history.back();</script>");
        return;
    }
    
    boolean isPrivate = "1".equals(dto.getQna_private());
    String currentCategory = dto.getQna_category() == null ? "" : dto.getQna_category(); // 현재 카테고리 값
%>
<br><br>
<div class="edit-header">
    <h2>문의 수정</h2>
</div>

<div class="container edit-form-container">
    <h3 class="mb-4">수정 내용</h3>
    <form method="post" action="<%= request.getContextPath() %>/board/supportUpdateAction.jsp" id="editForm" enctype="multipart/form-data">
        
        <input type="hidden" name="qna_idx" value="<%= qna_idx_str %>">
        <input type="hidden" name="qna_existing_img" value="<%= (dto.getQna_img() != null ? dto.getQna_img() : "") %>">

        <div class="mb-3">
            <label for="qna_writer_display" class="form-label">작성자</label>
            <input type="text" class="form-control" id="qna_writer_display" name="qna_writer_display" value="<%= dto.getQna_writer() %>" readonly>
            <input type="hidden" name="qna_writer_loginid" value="<%= userId_edit %>"> 
        </div>

        <%-- 카테고리 선택 필드 추가 --%>
        <div class="mb-3">
            <label for="qna_category" class="form-label">문의 유형</label> 
            <select class="form-select" id="qna_category" name="qna_category" required>
                <option value="">문의 유형을 선택해주세요</option>
                <option value="홈페이지 사용" <%= "홈페이지 사용".equals(currentCategory) ? "selected" : "" %>>홈페이지 사용</option>
                <option value="여행지 정보" <%= "여행지 정보".equals(currentCategory) ? "selected" : "" %>>여행지 정보</option>
                <option value="계정문의" <%= "계정문의".equals(currentCategory) ? "selected" : "" %>>계정문의</option>
                <option value="이벤트 문의" <%= "이벤트 문의".equals(currentCategory) ? "selected" : "" %>>이벤트 문의</option>
                <option value="기타 문의" <%= "기타 문의".equals(currentCategory) ? "selected" : "" %>>기타 문의</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="qna_title" class="form-label">제목</label>
            <input type="text" class="form-control" id="qna_title" name="qna_title" value="<%= dto.getQna_title() %>" required>
        </div>

        <div class="mb-3">
            <label for="qna_content" class="form-label">내용</label>
            <textarea class="form-control" id="qna_content" name="qna_content" rows="10" placeholder="수정할 내용을 작성해주세요" required><%= dto.getQna_content() %></textarea>
        </div>
        
        <div class="mb-3">
            <label for="qna_img" class="form-label">파일 첨부 (새 파일로 교체)</label>
            <% if (dto.getQna_img() != null && !dto.getQna_img().isEmpty()) { %>
                <p class="current-img-info">현재 파일: <%= dto.getQna_img() %>
                    <input type="checkbox" name="delete_img" value="true" id="delete_img"> <label for="delete_img">기존 파일 삭제</label>
                </p>
            <% } %>
            <input class="form-control" type="file" id="qna_img" name="qna_img">
            <div class="form-text">새로운 파일을 첨부하면 기존 파일은 삭제되거나 교체됩니다. (최대 5MB)</div>
        </div>
        
        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="qna_private" name="qna_private" value="1" <%= isPrivate ? "checked" : "" %>>
            <label class="form-check-label" for="qna_private">비밀글로 수정</label>
        </div>

        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <button type="button" class="btn btn-secondary me-md-2" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-custom-edit">수정 완료</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {
        $("#editForm").submit(function(event) {
            if ($("#qna_type").val() === "") { // 카테고리 선택 유효성 검사 추가
                alert("카테고리를 선택해주세요.");
                $("#qna_type").focus();
                return false;
            }
            if ($("#qna_title").val().trim() === "") {
                alert("제목을 입력해주세요.");
                $("#qna_title").focus();
                return false;
            }
            if ($("#qna_content").val().trim() === "") {
                alert("내용을 입력해주세요.");
                $("#qna_content").focus();
                return false;
            }
        });
    });
</script>

</body>
</html>