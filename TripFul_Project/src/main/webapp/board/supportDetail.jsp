<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardSupportDto, board.BoardSupportDao" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // 1. 파라미터 및 세션 정보 가져오기
    String idx = request.getParameter("idx");
    
    String loginok = (String) session.getAttribute("loginok");
    String id = (String) session.getAttribute("id");
    boolean isAdmin = "admin".equals(loginok);

    // 2. 조회수 증가 로직
    BoardSupportDao dao = new BoardSupportDao();
    if (idx != null && !idx.trim().isEmpty()) {
        String readKey = "supportRead_" + idx; // 세션 키
        if (session.getAttribute(readKey) == null) {
            dao.updateReadCount(idx);
            session.setAttribute(readKey, "true");
        }
    }

    // 3. 질문(원본글) 데이터 가져오기
    BoardSupportDto dto = dao.getData(idx);

    // 4. 데이터 유효성 검사 및 권한 체크
    if (dto == null) {
        out.println("<script>alert('해당 문의글을 찾을 수 없습니다.'); history.back();</script>");
        return;
    }
    
    boolean canView = false;
    if ("0".equals(dto.getQna_private())) { // 공개글
        canView = true;
    } else { // 비밀글
        if (id != null && (id.equals(dto.getQna_writer()) || isAdmin)) {
            canView = true;
        }
    }

    if (!canView) {
        out.println("<script>alert('비밀글은 작성자와 관리자만 볼 수 있습니다.'); history.back();</script>");
        return;
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title><%= dto.getQna_title() %> - 고객센터</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<style>
    .detailContainer { max-width: 1000px; margin: 30px auto; }
    .question-card, .answer-card { margin-top: 20px; }
    .card-body img { max-width: 100%; height: auto; border-radius: 8px; margin: 10px 0; }
    .answer-list { padding-left: 0; }
    .answer-list li { list-style: none; margin-top: 15px; padding-top: 15px; border-top: 1px dashed #ddd; }
    .answer-list .re-icon { margin-right: 5px; }
</style>
</head>
<body>
<div class="container detailContainer mt-5 mb-5">
    <div class="card shadow-sm question-card">
        <div class="card-header bg-light">
            <h3><i class="bi bi-question-circle-fill text-primary"></i> <%= dto.getQna_title() %></h3>
        </div>
        <div class="card-body">
            <p class="card-text">
                <small class="text-muted">
                    <i class="bi bi-tags-fill"></i> <%= dto.getQna_category() %> | 
                    <i class="bi bi-person"></i> <%= dto.getQna_writer() %> | 
                    <i class="bi bi-calendar-event"></i> <%= sdf.format(dto.getQna_writeday()) %> | 
                    <i class="bi bi-eye"></i> <%= dto.getQna_readcount() %>
                </small>
            </p>
            <hr>
            <div class="content-area mt-3">
                <% if(dto.getQna_img() != null && !dto.getQna_img().equals("null") && !dto.getQna_img().isEmpty()) { %>
                    <img src="<%=request.getContextPath()%>/upload/<%=dto.getQna_img()%>" alt="첨부 이미지">
                <% } %>
                <%= dto.getQna_content().replace("\n", "<br>") %>
            </div>
        </div>
        <div class="card-footer d-flex justify-content-between align-items-center bg-light">
            <div>
                <% if (isAdmin) { %>
                    <button type="button" class="btn btn-sm btn-primary" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp&parent_idx=<%=dto.getQna_idx()%>&regroup=<%=dto.getRegroup()%>&restep=<%=dto.getRestep()%>&relevel=<%=dto.getRelevel()%>'"><i class="bi bi-plus-square"></i> 답변 작성</button>
                <% } %>
            </div>
            
            <div>
                <button type="button" class="btn btn-sm btn-outline-secondary" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp'"><i class="bi bi-list-ul"></i> 목록</button>
                
                <% if (isAdmin || (id != null && id.equals(dto.getQna_writer()))) { %>
                    <button type="button" class="btn btn-sm btn-outline-secondary ms-2" onclick="location.href='<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportUpdateForm.jsp&qna_idx=<%=dto.getQna_idx()%>'"><i class="bi bi-pencil-square"></i> 수정</button>
                    <button type="button" class="btn btn-sm btn-outline-danger ms-2" onclick="if(confirm('질문과 모든 답변이 삭제됩니다. 정말 삭제하시겠습니까?')) { location.href='<%= request.getContextPath() %>/board/supportDeleteAction.jsp?qna_idx=<%=dto.getQna_idx()%>'; }"><i class="bi bi-trash"></i> 삭제</button>
                <% } %>
            </div>
        </div>
    </div>  <%-- .question-card의 닫는 태그 --%>

    <div class="card shadow-sm answer-card">
        <div class="card-header bg-light">
            <h5><i class="bi bi-chat-dots-fill text-success"></i> 답변 목록</h5>
        </div>
        <div class="card-body">
            <div id="repliesContainer">
                <p class="text-center text-muted">답변을 불러오는 중입니다...</p>
            </div>
        </div>
    </div>
</div>

<script type="text/javascript">
$(document).ready(function() {
    var currentLoginOk = "<%= loginok == null ? "null" : loginok %>"; 
    var currentUserId = "<%= id == null ? "null" : id %>"; 
    if (currentLoginOk === "null") currentLoginOk = null; 
    if (currentUserId === "null") currentUserId = null;
    loadReplies('<%= dto.getRegroup() %>', currentLoginOk, currentUserId);
});

function loadReplies(regroup, currentLoginOk, currentUserId) {
    $.ajax({
        url: '<%= request.getContextPath() %>/board/get_post_details_ajax.jsp',
        type: 'GET',
        data: { idx: '<%= idx %>', regroup: regroup },
        dataType: 'json',
        success: function(response) {
            var $repliesContainer = $('#repliesContainer');
            $repliesContainer.empty();

            if (response.replies && response.replies.length > 0) {
                var repliesHtml = '<ul class="answer-list">';
                $.each(response.replies, function(index, reply) {
                    var paddingLeft = (parseInt(reply.relevel) -1) * 25;
                    
                    repliesHtml += '<li style="padding-left:' + paddingLeft + 'px;">';
                    if (parseInt(reply.relevel) > 1) {
                         repliesHtml += '<img src="<%=request.getContextPath()%>/image/re.png" alt="re" class="re-icon">';
                    }
                    repliesHtml += '<strong>' + escapeHtml(reply.qna_title) + '</strong>';
                    repliesHtml += '<small class="text-muted ms-2">작성자: ' + escapeHtml(reply.qna_writer) + ' | ' + escapeHtml(reply.qna_writeday_formatted) + '</small>';
                    
                    if (reply.qna_img && reply.qna_img.trim() !== "" && reply.qna_img.trim() !== "null") {
                        repliesHtml += '<br><img src="<%=request.getContextPath()%>/upload/' + escapeHtml(reply.qna_img) + '" alt="답변 이미지">';
                    }
                    
                    repliesHtml += '<div class="mt-2 mb-2">' + escapeHtml(reply.qna_content).replace(/\n/g, '<br>') + '</div>';
                    var replyButtonsHtml = '<div style="text-align:right; margin-bottom:5px;">';
                    var canModify = (currentLoginOk === "admin") || (currentUserId && currentUserId === reply.qna_writer);
                    
                    if (canModify) {
                        var updateUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportUpdateForm.jsp&qna_idx=' + reply.qna_idx;
                        var deleteUrl = '<%= request.getContextPath() %>/board/supportDeleteAction.jsp?qna_idx=' + reply.qna_idx;
                        replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-secondary" style="margin-left: 5px;" onclick="location.href=\'' + updateUrl + '\'">';
                        replyButtonsHtml += '<i class="bi bi-pencil-square"></i>&nbsp;수정</button>';
                        replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-danger" style="margin-left: 5px;" onclick="if(confirm(\'이 답변을 삭제하시겠습니까?\')) location.href=\'' + deleteUrl + '\'">';
                        replyButtonsHtml += '<i class="bi bi-trash"></i>&nbsp;삭제</button>';
                    }
                    if (currentLoginOk === "admin") {
                        var replyToReplyUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp' 
                                            + '&parent_idx=' + reply.qna_idx + '&regroup=' + reply.regroup 
                                            + '&restep=' + reply.restep + '&relevel=' + reply.relevel;
                        replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-info" style="margin-left: 5px;" ' +
                                            'onclick="location.href=\'' + replyToReplyUrl + '\'">' +
                                            '<i class="bi bi-reply-fill"></i>&nbsp;답변달기</button>';
                    }
                    replyButtonsHtml += '</div>';
                    repliesHtml += replyButtonsHtml;

                    repliesHtml += '</li>';
                });
                repliesHtml += '</ul>';
                $repliesContainer.html(repliesHtml);
            } else {
                $repliesContainer.html('<p class="text-center text-muted">등록된 답변이 없습니다.</p>');
            }
        },
        error: function() {
            $('#repliesContainer').html('<p class="text-center text-danger">답변을 불러오는데 실패했습니다.</p>');
        }
    });
}
function escapeHtml(unsafe) {
    if (unsafe === null || typeof unsafe === 'undefined') return '';
    return String(unsafe)
         .replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")
         .replace(/"/g, "&quot;").replace(/'/g, "&#039;");
}
</script>
</body>
</html>