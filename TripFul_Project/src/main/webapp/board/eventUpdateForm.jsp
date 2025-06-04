<%@page import="board.BoardEventDto"%>
<%@page import="board.BoardEventDao"%>
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

    // 1. 수정할 이벤트 ID 받기
    String eventIdxStr = request.getParameter("idx");
    if (eventIdxStr == null || eventIdxStr.trim().isEmpty()) {
        response.getWriter().println("<script>alert('잘못된 접근입니다. 이벤트 ID가 없습니다.'); history.back();</script>");
        return;
    }

    int event_idx = 0;
    try {
        event_idx = Integer.parseInt(eventIdxStr);
    } catch (NumberFormatException e) {
        response.getWriter().println("<script>alert('이벤트 ID가 올바르지 않습니다.'); history.back();</script>");
        return;
    }

    // 2. DAO를 통해 이벤트 정보 가져오기
    BoardEventDao dao = new BoardEventDao();
    BoardEventDto dto = dao.getData(eventIdxStr); // BoardEventDao의 getData 메소드 호출

    if (dto == null) {
        response.getWriter().println("<script>alert('존재하지 않는 이벤트입니다.'); history.back();</script>");
        return;
    }

    // DTO에서 값 가져오기 (XSS 방지 및 null 처리)
    String formWriter = dto.getEvent_writer() != null ? dto.getEvent_writer().replace("\"", "&quot;") : "";
    String formImg = dto.getEvent_img() != null ? dto.getEvent_img().replace("\"", "&quot;") : "";
    String title = dto.getEvent_title() != null ? dto.getEvent_title().replace("\"", "&quot;").replace("<", "&lt;").replace(">", "&gt;") : "";
    String content = dto.getEvent_content() != null ? dto.getEvent_content() : "";

%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이벤트 수정하기</title> <%-- 페이지 제목 변경 --%>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
</head>
<body>
<div class="container">
    <h2>이벤트 수정하기</h2> <%-- 폼 제목 변경 --%>
    <%-- 폼 액션을 이벤트 수정 처리 JSP로 변경 --%>
    <form method="post" action="<%= request.getContextPath() %>/board/eventUpdateAction.jsp" enctype="multipart/form-data">
        <%-- 수정할 이벤트의 ID 및 기타 필요한 정보를 hidden 필드로 추가 --%>
        <input type="hidden" name="event_idx" value="<%= event_idx %>"> <%-- name을 event_idx로, value는 int 타입 event_idx --%>
        <input type="hidden" name="event_writer" value="<%= formWriter %>">
        <input type="hidden" name="event_img" value="<%= formImg %>">

        <div class="form-group">
            <label for="title">이벤트 제목</label> <%-- 레이블 텍스트 변경 --%>
            <input type="text" class="form-control" id="title" name="title" value="<%= title %>">
        </div>
        <div class="form-group">
            <label for="summernote">이벤트 내용</label> <%-- 레이블 텍스트 변경 --%>
            <textarea id="summernote" name="content"><%= content %></textarea>
        </div>
        <button type="submit" class="btn btn-primary">수정 완료</button>
    </form>
</div>

<script>
    $(document).ready(function () {
        $('#summernote').summernote({
            height: 300,
            placeholder: '이벤트 내용을 입력하세요...', // placeholder 변경
            lang: 'ko-KR',
            callbacks: {
                onImageUpload: function (files) {
                    for (let i = 0; i < files.length; i++) {
                        uploadImage(files[i]);
                    }
                }
            },
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

        function uploadImage(file) {
            let data = new FormData();
            data.append("file", file);

            $.ajax({
                // COS 기반 업로드 처리 JSP
                url: '<%= request.getContextPath() %>/board/imageUpload.jsp', // 이 경로는 공용으로 사용 가능
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