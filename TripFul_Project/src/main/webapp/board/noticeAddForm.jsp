<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>글쓰기</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
</head>
<body>
<div class="container">
    <h2>글 작성하기</h2>
    <form method="post" action="<%= request.getContextPath() %>/board/noticeAddAction.jsp" enctype="multipart/form-data">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" class="form-control" id="title" name="title">
        </div>
        <div class="form-group">
            <label for="summernote">내용</label>
            <textarea id="summernote" name="content"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">작성 완료</button>
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
            
         	// 이 옵션을 추가하세요 ↓↓↓
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
