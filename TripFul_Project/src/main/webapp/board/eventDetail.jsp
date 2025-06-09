<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardEventDto" %>
<%@ page import="board.BoardEventDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    String idx = request.getParameter("idx"); 
    BoardEventDao dao = new BoardEventDao();

    if (idx != null && !idx.trim().isEmpty()) {
        String readKey = "eventRead_" + idx;
        if (session.getAttribute(readKey) == null) {
            dao.updateReadCount(idx);
            session.setAttribute(readKey, "true");
        }
    }

    BoardEventDto dto = null;
    if (idx != null && !idx.trim().isEmpty()) {
        dto = dao.getData(idx);
    }

    String adminSessionValue = (String) session.getAttribute("loginok");
    boolean isAdmin = "admin".equals(adminSessionValue);
    String loggedInUserId = (String) session.getAttribute("id");

    if (dto == null) {
        out.println("<script>alert('해당 이벤트를 찾을 수 없습니다.'); history.back();</script>");
        return;
    }
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= dto.getEvent_title() %> - 이벤트 상세</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style type="text/css">
/* ... (기존 CSS 스타일 유지) ... */
.detailContainer { max-width: 1000px; margin: 30px auto; padding: 20px; }
.card-header h3 { margin-bottom: 0; }
.event-content img { max-width: 100%; height: auto; border-radius: 8px; margin-top: 10px; margin-bottom: 10px; }
.comment-item { word-break: break-all; }
.comment-item p { margin-top: 5px; margin-bottom: 10px; white-space: pre-wrap; }
.btn-sm i { vertical-align: middle; }
#commentToggleContainer { display: none; } /* 토글 버튼 컨테이너 초기 숨김 */
</style>
</head>
<body>
<div class="container detailContainer mt-5 mb-5">
    <%-- 이벤트 상세 내용 카드 --%>
    <div class="card shadow-sm">
        <div class="card-header bg-light"><h3><%= dto.getEvent_title() %></h3></div>
        <div class="card-body">
            <p class="card-text"><small class="text-muted"><i class="bi bi-person"></i> 작성자: <%= dto.getEvent_writer() %> | <i class="bi bi-calendar-event"></i> 작성일: <%= sdf.format(dto.getEvent_writeday()) %> | <i class="bi bi-eye"></i> 조회수: <%= dto.getEvent_readcount() %></small></p>
            <hr>
            <div class="event-content mt-3"><%= dto.getEvent_content() %></div>
        </div>
        <div class="card-footer text-end bg-light">
            <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=event.jsp'"><i class="bi bi-list-ul"></i>&nbsp;목록</button>
            <% if (isAdmin) { %>
            <button type="button" class="btn btn-sm btn-outline-primary" onclick="location.href='<%= request.getContextPath() %>/board/eventUpdateForm.jsp?idx=<%=idx %>'"> <i class="bi bi-pencil-square"></i>&nbsp;수정</button>
            <button type="button" class="btn btn-sm btn-outline-danger" onclick="if(confirm('정말로 이 이벤트를 삭제하시겠습니까?')) { location.href='<%= request.getContextPath() %>/board/eventDeleteAction.jsp?idx=<%=idx %>'; }"><i class="bi bi-trash"></i>&nbsp;삭제</button>
            <% } %>
        </div>
    </div>

    <%-- 댓글 섹션 --%>
    <div class="card mt-4 shadow-sm">
        <div class="card-header bg-light"><h5><i class="bi bi-chat-dots-fill"></i> 댓글</h5></div>
        <div class="card-body">
            <% if (loggedInUserId != null) { %>
            <form id="commentForm" class="mb-4">
                <input type="hidden" name="event_idx" value="<%= idx %>">
                <input type="hidden" name="user_id" value="<%= loggedInUserId %>"> 
                <div class="input-group">
                    <textarea class="form-control" id="comment_content" name="comment_content" rows="3" placeholder="따뜻한 댓글을 남겨주세요..."></textarea>
                    <button type="button" class="btn btn-primary" id="submitComment"><i class="bi bi-send"></i> 등록</button>
                </div>
            </form>
            <% } else { %>
            <p class="text-muted">댓글을 작성하려면 <a href="<%= request.getContextPath() %>/index.jsp?main=login/login.jsp">로그인</a>해주세요.</p>
            <% } %>
            <hr>
            <div id="commentListInitial"> <%-- ★ 초기 댓글 로드 위치 --%>
            </div>
            <div id="commentListAdditional"> <%-- ★ 추가 댓글 로드 위치 --%>
            </div>
            <%-- 더보기/간략히 보기 버튼 컨테이너 --%>
            <div class="text-center mt-3" id="commentToggleContainer">
                <button type="button" class="btn btn-outline-primary btn-sm" id="toggleCommentsButton">더보기</button>
            </div>
        </div>
    </div>
</div>

<script>
$(document).ready(function() {
    const currentEventId = '<%= idx %>';
    const currentUser = '<%= loggedInUserId == null ? "" : loggedInUserId %>';
    const isAdminUser = <%= isAdmin %>;
    
    const commentsPerPage = 5;   // 한 페이지에 보여줄 댓글 수
    let totalServerComments = 0; // 서버의 전체 댓글 수
    let additionalCommentsVisible = false; // 추가 댓글이 현재 보이는지 여부

    // 댓글 목록을 화면에 렌더링하는 함수 (내용은 이전과 거의 동일)
    function renderComments(commentsData, targetContainerId, clearContainerFirst) {
        const $targetContainer = $(targetContainerId);
        if (clearContainerFirst) {
            $targetContainer.empty();
        }

        if (!commentsData || commentsData.length === 0) {
            if (clearContainerFirst && targetContainerId === '#commentListInitial') {
                 $targetContainer.html('<p class="text-center text-muted">아직 등록된 댓글이 없습니다.</p>');
            }
            return; // 렌더링할 댓글 없음
        }

        commentsData.forEach(function(originalComment) {
            const comment = { ...originalComment }; 
            let answerIdx = (comment.answer_idx && String(comment.answer_idx).trim()) ? String(comment.answer_idx).trim() : 'ID없음';
            let writer    = (comment.writer && String(comment.writer).trim()) ? String(comment.writer).trim() : '작성자 익명';
            let content   = (comment.content && String(comment.content).trim()) ? String(comment.content).trim() : '내용 없음';
            let likeCount = (comment.likecount !== null && comment.likecount !== undefined) ? Number(comment.likecount) : 0;
            let writedayRaw = (comment.writeday && String(comment.writeday).trim()) ? String(comment.writeday).trim() : null;
            let userHasLikedThisComment = comment.userHasLiked === true; 
            let commentDate = '날짜 미표시';
            if (writedayRaw) {
                let dateObj = new Date(writedayRaw);
                if (!isNaN(dateObj.getTime())) { 
                    commentDate = dateObj.toLocaleString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit' });
                } else { commentDate = '날짜 형식 오류'; }
            }
            let likeButtonClass = userHasLikedThisComment ? 'btn-primary' : 'btn-outline-primary';
            let likeIconClass = userHasLikedThisComment ? 'bi-hand-thumbs-up-fill' : 'bi-hand-thumbs-up';
            let commentHtml = 
                '<div class="comment-item mb-3 pb-3 border-bottom" id="comment-item-' + answerIdx + '">' +
                    '<div class="d-flex justify-content-between align-items-center">' +
                        '<span><strong><i class="bi bi-person-circle"></i> ' + writer + '</strong> <small class="text-muted ms-2">- ' + commentDate + '</small></span>';
            if (currentUser === writer || isAdminUser) { 
                 commentHtml += '<button type="button" class="btn btn-sm btn-outline-danger delete-comment" data-answer-idx="' + answerIdx + '"><i class="bi bi-x-lg"></i></button>';
            }
            commentHtml += '</div>' + '<p class="mt-2 mb-2">' + content + '</p>' +
                           '<button type="button" class="btn btn-sm ' + likeButtonClass + ' like-comment me-2" data-answer-idx="' + answerIdx + '">' +
                           '<i class="bi ' + likeIconClass + '"></i> 좋아요 <span class="badge bg-primary rounded-pill like-count">' + likeCount + '</span></button>' +
                        '</div>';
            $targetContainer.append(commentHtml);
        });
    }

    // 초기 댓글 로드 및 버튼 설정 함수
    function loadInitialCommentsAndSetupButton() {
        $('#commentListAdditional').empty(); // 추가 댓글 영역 비우기
        additionalCommentsVisible = false; // 상태 초기화

        $.ajax({
            url: '<%=request.getContextPath()%>/board/eventAnswerListAction.jsp',
            type: 'GET',
            data: { event_idx: currentEventId, start: 0, count: commentsPerPage },
            dataType: 'json',
            success: function(response) {
                if(response && response.comments) {
                    renderComments(response.comments, '#commentListInitial', true);
                    totalServerComments = response.totalComments;

                    if (totalServerComments > commentsPerPage) {
                        $('#toggleCommentsButton').text('더보기').show();
                        $('#commentToggleContainer').show();
                    } else {
                        $('#commentToggleContainer').hide();
                    }
                } else {
                     $('#commentListInitial').html('<p class="text-center text-muted">댓글을 불러오지 못했습니다.</p>');
                     $('#commentToggleContainer').hide();
                }
            },
            error: function() { /* ... (기존 에러 처리) ... */ $('#commentToggleContainer').hide(); }
        });
    }

    // "더보기/간략히 보기" 버튼 클릭 이벤트
    $('#toggleCommentsButton').click(function() {
        const $button = $(this);
        
        if (!additionalCommentsVisible) { // 현재 "더보기" 상태 (추가 댓글 로드)
            $.ajax({
                url: '<%=request.getContextPath()%>/board/eventAnswerListAction.jsp',
                type: 'GET',
                // 초기 댓글(0~commentsPerPage-1) 다음부터 가져옴
                data: { event_idx: currentEventId, start: commentsPerPage, count: commentsPerPage },
                dataType: 'json',
                success: function(response) {
                    if (response && response.comments && response.comments.length > 0) {
                        renderComments(response.comments, '#commentListAdditional', true);
                        $button.text('간략히 보기');
                        additionalCommentsVisible = true;
                    } else {
                        alert('더 이상 댓글이 없습니다.');
                        $button.hide(); // 더 로드할 댓글이 없으므로 버튼 숨김
                    }
                },
                error: function() { alert('추가 댓글 로드 중 오류가 발생했습니다.'); }
            });
        } else { // 현재 "간략히 보기" 상태 (추가 댓글 숨김)
            $('#commentListAdditional').empty();
            $button.text('더보기');
            additionalCommentsVisible = false;
        }
    });

    // 초기 댓글 로드
    loadInitialCommentsAndSetupButton();

    // 댓글 등록 성공 시
    $('#submitComment').click(function() {
        let contentVal = $('#comment_content').val();
        let userIdForComment = $('input[name="user_id"]').val(); 

        if (!currentUser) { alert('댓글을 작성하려면 로그인이 필요합니다.'); return; }
        if (!contentVal.trim()) { alert('댓글 내용을 입력해주세요.'); $('#comment_content').focus(); return; }

        $.ajax({
            url: '<%=request.getContextPath()%>/board/eventAnswerAddAction.jsp',type: 'POST',
            data: {event_idx: currentEventId,user_id: userIdForComment, comment_content: contentVal},
            success: function(response) {
                if (response.trim() === "success") {
                    $('#comment_content').val('');
                    loadInitialCommentsAndSetupButton(); // ★ 변경
                } else { alert('댓글 등록 실패: ' + response); }
            },
            error: function() { alert('댓글 등록 중 서버 오류가 발생했습니다.'); }
        });
    });

    // 댓글 삭제 성공 시
    $('#commentListInitial, #commentListAdditional').on('click', '.delete-comment', function() { // 이벤트 위임 대상 변경
        if (!currentUser) { alert('댓글을 삭제하려면 로그인이 필요합니다.'); return; }
        if (!confirm('정말로 이 댓글을 삭제하시겠습니까?')) { return; }
        let answerIdx = $(this).data('answer-idx');

        $.ajax({
            url: '<%=request.getContextPath()%>/board/eventAnswerDeleteAction.jsp', type: 'POST',
            data: { answer_idx: answerIdx }, 
            success: function(response) {
                if (response.trim() === "success") {
                    loadInitialCommentsAndSetupButton(); // ★ 변경
                } else { alert('댓글 삭제 실패: ' + response); }
            },
            error: function() { alert('댓글 삭제 중 서버 오류가 발생했습니다.'); }
        });
    });

    // 댓글 좋아요 (이벤트 위임 대상 변경)
    $('#commentListInitial, #commentListAdditional').on('click', '.like-comment', function() {
        // ... (기존 좋아요 로직은 거의 동일, 버튼 상태 업데이트 후 필요시 loadInitialCommentsAndSetupButton() 대신 현재 상태만 업데이트 가능)
        if (!currentUser) { alert('좋아요를 누르려면 로그인이 필요합니다.'); return;}
        let answerIdx = $(this).data('answer-idx');
        let button = $(this);
        $.ajax({
            url: '<%=request.getContextPath()%>/board/eventAnswerLikeAction.jsp', type: 'POST',
            data: { answer_idx: answerIdx }, dataType: 'json',
            success: function(response) {
                if (response.status === "success") {
                    button.find('.like-count').text(response.likeCount);
                    if(response.userAction === "liked") {
                         button.removeClass('btn-outline-primary').addClass('btn-primary');
                         button.find('i').removeClass('bi-hand-thumbs-up').addClass('bi-hand-thumbs-up-fill');
                    } else if (response.userAction === "unliked") { 
                         button.removeClass('btn-primary').addClass('btn-outline-primary');
                         button.find('i').removeClass('bi-hand-thumbs-up-fill').addClass('bi-hand-thumbs-up');
                    }
                } else { alert('좋아요 처리 실패: ' + (response.message || '알 수 없는 오류')); }
            },
            error: function() { alert('좋아요 처리 중 서버 오류가 발생했습니다.');}
        });
    });
});
</script>
</body>
</html>