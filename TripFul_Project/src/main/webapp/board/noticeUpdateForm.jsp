<%@page import="board.BoardNoticeDto"%>
<%@page import="board.BoardNoticeDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	//어드민 확인
	String sessionId = (String) session.getAttribute("loginok"); // 로그인 시 세션에 저장한 사용자 ID (또는 권한 정보)
	
	if (sessionId == null || !sessionId.equals("admin")) {
	    response.getWriter().println("<script>");
	    response.getWriter().println("alert('수정 권한이 없습니다.');");
	    // 이전 페이지로 보내거나, 메인 페이지 등으로 리다이렉트
	    response.getWriter().println("history.back();");
	    response.getWriter().println("</script>");
	    return;
	}


    // 1. 수정할 게시물 ID 받기
    String noticeIdxStr = request.getParameter("idx");
    if (noticeIdxStr == null || noticeIdxStr.trim().isEmpty()) {
        // notice_idx가 없는 경우 오류 처리 또는 리다이렉트
        response.getWriter().println("<script>alert('잘못된 접근입니다. 게시물 ID가 없습니다.'); history.back();</script>");
        return;
    }

    int notice_idx = 0;
    try {
        notice_idx = Integer.parseInt(noticeIdxStr);
    } catch (NumberFormatException e) {
        response.getWriter().println("<script>alert('게시물 ID가 올바르지 않습니다.'); history.back();</script>");
        return;
    }

    // 2. DAO를 통해 게시물 정보 가져오기
    BoardNoticeDao dao = new BoardNoticeDao(); // 실제 사용하는 DAO 클래스로 변경
    BoardNoticeDto dto = dao.getData(noticeIdxStr); // 실제 사용하는 상세조회 메소드로 변경
    
    if (dto == null) {
        response.getWriter().println("<script>alert('존재하지 않는 게시물입니다.'); history.back();</script>");
        return;
    }
    
    String formWriter = dto.getNotice_writer() != null ? dto.getNotice_writer().replace("\"", "&quot;") : "";
    String formImg = dto.getNotice_img() != null ? dto.getNotice_img().replace("\"", "&quot;") : "";


    // HTML 태그 등을 안전하게 표시하기 위해 간단한 치환 (필요에 따라 더 강력한 XSS 필터링 고려)
    String title = dto.getNotice_title() != null ? dto.getNotice_title().replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") : "";
    // Summernote는 HTML을 직접 다루므로 내용은 그대로 전달
    String content = dto.getNotice_content() != null ? dto.getNotice_content() : "";

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글 수정하기</title> <%-- 페이지 제목 변경 --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
</head>
<body>
<div class="container">
    <h2>글 수정하기</h2> <%-- 폼 제목 변경 --%>
    <%-- 폼 액션을 수정 처리 JSP로 변경 --%>
    <form method="post" action="<%= request.getContextPath() %>/board/noticeUpdateAction.jsp" enctype="multipart/form-data">
        <%-- 수정할 게시물의 ID를 hidden 필드로 추가 --%>
        <input type="hidden" name="notice_idx" value="<%= notice_idx %>">
    	<input type="hidden" name="notice_writer" value="<%= formWriter %>">
		<input type="hidden" name="notice_img" value="<%= formImg %>">

        <div class="form-group">
            <label for="title">제목</label>
            <%-- value 속성에 기존 제목 채우기 --%>
            <input type="text" class="form-control" id="title" name="title" value="<%= title %>">
        </div>
        <div class="form-group">
            <label for="summernote">내용</label>
            <%-- textarea 내부에 기존 내용 채우기 --%>
            <textarea id="summernote" name="content"><%= content %></textarea>
        </div>
        <button type="submit" class="btn btn-primary">수정 완료</button> <%-- 버튼 텍스트 변경 --%>
    </form>
</div>

<script>
    $(document).ready(function () {
        $('#summernote').summernote({
            height: 300,
            placeholder: '내용을 입력하세요...',
            lang: 'ko-KR',
            callbacks: {
                onImageUpload: function (files) {
                    for (let i = 0; i < files.length; i++) {
                        uploadImage(files[i]);
                    }
                }
            },
            // 이 옵션을 추가하세요 ↓↓↓ (원문 주석 유지)
            lineHeights: ['0.5', '1.0', '1.5', '2.0'],
            styleTags: ['p', 'blockquote', 'pre', 'h1', 'h2', 'h3'],
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic', 'underline', 'clear']],
                ['fontname', ['fontname']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']],
                ['insert', ['picture', 'link', 'video']],
                ['view', ['fullscreen', 'codeview', 'help']]
            ]
        });

        // $('#summernote').summernote('code', '<%= content.replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r") %>');


        function uploadImage(file) {
            let data = new FormData();
            data.append("file", file);

            $.ajax({
                // COS 기반 업로드 처리 JSP
                url: '<%= request.getContextPath() %>/board/imageUpload.jsp',
                type: 'POST',
                data: data,
                processData: false,
                contentType: false,
                success: function (url) {
                    if (url.startsWith("error")) {
                        alert("이미지 업로드 실패: " + url);
                    } else {
                        $('#summernote').summernote('insertImage', url.trim());
                    }
                },
                error: function () {
                    alert("서버 오류: 이미지 업로드 실패");
                }
            });
        }
    });
</script>
</body>
</html>