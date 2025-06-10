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
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/lang/summernote-ko-KR.min.js"></script>
</head>
<body>
<div class="container">
    <h2 style="margin-top: 40px; margin-bottom: 20px;">이벤트 작성</h2>
    
    <form method="post" action="<%= request.getContextPath() %>/board/eventAddAction.jsp">
        <div class="form-group">
            <label for="title">제목</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="form-group">
            <label for="summernote">내용</label>
            <textarea id="summernote" name="content"></textarea>
        </div>
        <button type="submit" class="btn btn-primary">작성 완료</button>
        <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=event.jsp" class="btn btn-default">목록으로</a>
    </form>
</div>

<script>
    $(document).ready(function () {
        // 1. 에디터에 포함된 이미지 URL을 추적하기 위한 Set 객체 (상태 저장소)
        let trackedImageUrls = new Set();

        // Summernote 초기화
        $('#summernote').summernote({
            height: 400,
            placeholder: '이벤트 내용을 입력하세요...',
            lang: 'ko-KR',
            callbacks: {
                // 이미지가 에디터에 삽입될 때
                onImageUpload: function (files) {
                    for (let i = 0; i < files.length; i++) {
                        sendFile(files[i]);
                    }
                },
                // ✅ [핵심] 에디터 내용이 변경될 때마다 호출 (삭제 감지의 핵심)
                onChange: function(contents, $editable) {
                    // 1. 현재 에디터에 있는 모든 이미지의 URL을 Set으로 만듭니다.
                    let currentImages = new Set();
                    $editable.find('img').each(function() {
                        currentImages.add(this.src);
                    });

                    // 2. 삭제된 이미지를 찾습니다.
                    // (이전 추적 목록에는 있었지만, 현재 목록에는 없는 이미지)
                    const deletedImages = new Set(
                        [...trackedImageUrls].filter(url => !currentImages.has(url))
                    );

                    // 3. 삭제된 각 이미지에 대해 서버에 삭제 요청
                    deletedImages.forEach(imgUrl => {
                        deleteImageFromServer(imgUrl);
                    });

                    // 4. 추적하는 이미지 목록을 현재 상태로 최종 업데이트
                    trackedImageUrls = currentImages;
                }
            },
            toolbar: [
                ['style', ['style']],
                ['font', ['bold', 'italic', 'underline', 'strikethrough', 'clear']],
                ['fontname', ['fontname']],
                ['fontsize', ['fontsize']],
                ['color', ['color']],
                ['para', ['ul', 'ol', 'paragraph']],
                ['height', ['height']],
                ['table', ['table']],
                ['insert', ['link', 'picture', 'video']],
                ['view', ['fullscreen', 'codeview', 'help']]
            ]
        });

        // 이미지를 서버에 업로드하는 함수
        function sendFile(file) {
            const data = new FormData();
            data.append("file", file);

            $.ajax({
                url: '<%= request.getContextPath() %>/board/imageUpload.jsp',
                type: 'POST',
                data: data,
                contentType: false,
                processData: false,
                success: function (url) {
                    const imageUrl = url.trim();
                    if (imageUrl.toLowerCase().startsWith("error")) {
                        alert("이미지 업로드 실패: " + imageUrl);
                    } else {
                        // 업로드 성공 시 에디터에 이미지 삽입
                        // 이미지가 삽입되면 onChange 콜백이 자동으로 호출되어 목록을 갱신합니다.
                        $('#summernote').summernote('insertImage', imageUrl);
                    }
                },
                error: function (xhr, status, error) {
                    alert("이미지 업로드 중 서버 오류가 발생했습니다.");
                }
            });
        }

        // 서버에 실제 파일 삭제를 요청하는 공통 함수
        function deleteImageFromServer(fullUrl) {
            if (!fullUrl) return;

            const fileName = fullUrl.split('/').pop();

            $.ajax({
                url: '<%= request.getContextPath() %>/board/imageDelete.jsp', // 삭제 처리 페이지
                type: 'POST',
                data: { fileName: fileName },
                success: function(response) {
                    if (response.trim().startsWith("success")) {
                        console.log('이미지 삭제 완료:', fileName);
                    } else {
                        console.error('이미지 삭제 실패:', response);
                    }
                },
                error: function(xhr, status, error) {
                    console.error('이미지 삭제 요청 실패:', error);
                }
            });
        }
    });
</script>
</body>
</html>