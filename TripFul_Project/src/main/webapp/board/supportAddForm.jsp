<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>고객 문의 작성</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<style>
	body {
		background-color: #f8f9fa;
	}
    .support-header {
        background-color: #1A3A2F; 
        color: white;
        padding: 40px 20px;
        text-align: center;
        margin-bottom: 30px;
        border-radius: 30px;
    }
    .support-header h2 {
        margin: 0;
        font-weight: bold;
    }
    .support-form-container {
        background-color: white;
        padding: 30px;
        border-radius: 8px;
        box-shadow: 0 0 15px rgba(0,0,0,0.1);
        max-width: 800px; /* 폼의 최대 너비 설정 */
        margin: 0 auto; /* 가운데 정렬 */
    }
    .form-label {
        font-weight: bold;
    }
    .btn-custom-submit {
        background-color: #1A3A2F; /* 헤더와 동일한 색상 */
        color: white;
        border: none;
    }
    .btn-custom-submit:hover {
        background-color: #142e25; /* 호버 시 약간 더 어둡게 */
        color: white;
    }
    /* Summernote 사용 시 툴바가 너무 길어지는 것을 방지하기 위한 스타일 (선택 사항) */
    .note-toolbar {
        overflow-x: auto; /* 가로 스크롤 추가 */
        flex-wrap: nowrap !important; /* 줄바꿈 방지 */
    }
    .note-btn-group {
        white-space: nowrap; /* 버튼 그룹 내 줄바꿈 방지 */
    }
</style>
</head>
<body>
<%
//로그인 정보 가져오기
String userId = (String)session.getAttribute("id"); // 실제 사용자 ID 세션 속성명 사용

// 로그인이 안되어있으면 로그인 페이지로 이동 (userId가 null이거나 비어있으면)
if (userId == null || userId.trim().isEmpty()) {
    response.getWriter().println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/index.jsp?main=login/login.jsp';</script>");
    return;
}
%>
<br><br><br>
<div class="support-header">
    <h2>무엇을 도와드릴까요?</h2>
    <p>고객님의 문제를 해결하기 위해 최선을 다하겠습니다.</p>
</div>

<div class="container support-form-container">
    <h3 class="mb-4">문의 내용 작성</h3>
    <%-- 파일 업로드 시 enctype="multipart/form-data" 추가 --%>
    <form method="post" action="<%= request.getContextPath() %>/board/supportAddAction.jsp" id="supportForm" enctype="multipart/form-data">
        
        <div class="mb-3">
            <label for="qna_category" class="form-label">문의 유형</label>
            <select class="form-select" id="qna_category" name="qna_category" required>
            	<option value="">문의 유형을 선택해주세요</option>
                <option value="홈페이지 사용">홈페이지 사용</option>
                <option value="여행지 정보">여행지 정보</option>
                <option value="계정문의">계정문의</option>
                <option value="이벤트 문의">이벤트 문의</option>
                <option value="기타 문의">기타 문의</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="qna_writer" class="form-label">작성자</label>
            <br>
            <input type="text" class.form-control" id="qna_writer" name="qna_writer" value="<%= userId %>" readonly>
        </div>

        <div class="mb-3">
            <label for="qna_title" class="form-label">제목</label>
            <input type="text" class="form-control" id="qna_title" name="qna_title" placeholder="제목을 입력해주세요" required>
        </div>

        <div class="mb-3">
            <label for="qna_content" class="form-label">문의 내용</label>
            <textarea class="form-control" id="qna_content" name="qna_content" rows="10" placeholder="문의하실 내용을 자세히 작성해주세요" required></textarea>
        </div>
        
        <%-- 파일 첨부가 필요하다면 아래 주석 해제 --%>
        <div class="mb-3">
            <label for="qna_img" class="form-label">파일 첨부 (선택)</label>
            <input class="form-control" type="file" id="qna_img" name="qna_img">
            <div class="form-text">스크린샷이나 관련 파일을 첨부하시면 문제 해결에 도움이 됩니다. (최대 5MB)</div>
        </div>
        

        <div class="mb-3 form-check">
            <input type="checkbox" class="form-check-input" id="qna_private" name="qna_private" value="1">
            <label class="form-check-label" for="qna_private">비밀글로 문의하기 (체크 시 관리자와 본인만 열람 가능)</label>
        </div>

        <div class="d-grid gap-2 d-md-flex justify-content-md-end">
            <button type="button" class="btn btn-secondary me-md-2" onclick="history.back()">취소</button>
            <button type="submit" class="btn btn-custom-submit">문의 제출</button>
        </div>
    </form>
</div>

<script>
    $(document).ready(function() {

        // 폼 유효성 검사 (간단 예시)
        $("#supportForm").submit(function(event) {
            if ($("#qna_type").val() === "") {
                alert("문의 유형을 선택해주세요.");
                $("#qna_type").focus();
                return false;
            }
            if ($("#qna_title").val().trim() === "") {
                alert("제목을 입력해주세요.");
                $("#qna_title").focus();
                return false;
            }
            if ($("#qna_content").val().trim() === "") {
            	
                alert("문의 내용을 입력해주세요.");
                $("#qna_content").focus();
                return false;
            }
            // 파일 업로드 관련 유효성 검사 (예: 파일 크기, 확장자 등)는 여기서 또는 서버에서 추가 가능
        });
    });
</script>

</body>
</html>