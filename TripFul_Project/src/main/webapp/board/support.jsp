<%@page import="javax.annotation.PostConstruct"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="board.BoardSupportDto"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>고객센터</title>
</head>
<%
String loginok=null;
String id=null;
// 세션에서 id 값을 가져올 때 null 체크 추가 (NPE 방지)
if(session.getAttribute("loginok")!=null)
{
 loginok=(String)session.getAttribute("loginok");
 if(session.getAttribute("id") != null) {
    id=(String)session.getAttribute("id");
 }
}
BoardSupportDao dao=new BoardSupportDao();
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");

//페이징처리
//전체갯수
int totalCount=dao.getTotalCount();
int perPage=3; //한페이지에 보여질 글의 갯수
int perBlock=5; //한블럭당 보여질 페이지의 갯수
int startNum; //db에서 가져올 글의 시작번호(mysql:0 오라클:1번)
int startPage; //각블럭당 보여질 시작페이지
int endPage;//각블럭당 보여질 끝페이지
int currentPage; //현재페이지
int totalPage; //총페이지

int no; //각페이지당 출력할 시작번호

//현재페이지 읽기,단 null일경우는 1페이지로 준다
if(request.getParameter("currentPage")==null)
	  currentPage=1;
else
	  currentPage=Integer.parseInt(request.getParameter("currentPage"));


//총페이지수를 구한다
//총글의 갯수/한페이지당 보여질개수로 나눔(7/5=1)
//나머지가 1이라도 있으면 무저건 1페이지추가(1+1=2페이지가 필요)
totalPage=totalCount/perPage+(totalCount%perPage==0?0:1);

//각블럭당 보여질 시작페이지
//perBlock=5일경우 현재페이지가 1~5 시작1,끝5
//만약 현재페이지가 13일경우는 시작11,끝15
startPage=(currentPage-1)/perBlock*perBlock+1;
endPage=startPage+perBlock-1;

//총페이지가 23개일경우 마지막 블럭은 끝 25가 아니라 23이다
if(endPage>totalPage)
	  endPage=totalPage;

//각페이지에서 보여질 시작번호
//예: 1페이지-->0  2페이지-->5 3페이지-->10...
startNum=(currentPage-1)*perPage;

//각페이지당 출력할 시작번호
//예를들어 총글갯수가 23   1페이지: 23  2페이지:18  3페이지: 13....
no=totalCount-(currentPage-1)*perPage;

List<BoardSupportDto> list=dao.getAllDatas(startNum, perPage);

%>
<body>
	<div class="notice-wrapper">
		<div class="notice-header">
			<h3>
				<i class="bi bi-x-diamond-fill"> </i><b>고객센터</b>
			</h3>
			<%
				if(loginok==null)
				{%>
					<a style="float: right; text-decoration: none; color: black;"
					href="javascript:void(0);" 
                    onclick="if(confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) { location.href='<%= request.getContextPath() %>/index.jsp?main=login/login.jsp'; } return false;">
						<i class="bi bi-plus-square"></i>&nbsp;문의하기
					</a>
				<%}else{%>
					<a style="float: right; text-decoration: none; color: black;"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportAddForm.jsp">
						<i class="bi bi-plus-square"></i>&nbsp;문의하기
					</a>
				<%}
			%>
			<hr>
		</div>
		<br>
		<table class="table table-hover notice-table">
			<thead>
				<tr>
					<th scope="col" style="width: 8%;">번호</th>
					<th scope="col" style="width: 47%;">제목</th>
					<th scope="col" style="width: 15%;">작성자</th>
					<th scope="col" style="width: 20%;">작성일</th>
					<th scope="col" style="width: 10%;">조회수</th>
				</tr>
			</thead>
			<tbody>
				<%
				    if(list.isEmpty()){
				%>
								<tr>
									<td colspan="5" align="center"><b>등록된 게시글이 없습니다</b></td>
								</tr>
								<%
				    } else {
				        for(int i=0; i<list.size(); i++) {
				            BoardSupportDto dto = list.get(i);
				            if (dto.getRelevel() == 0) { // 원글만 표시
				%>
				<tr class="original-post-row" data-idx="<%=dto.getQna_idx()%>"
					data-regroup="<%=dto.getRegroup()%>">
					<td><%=no-i%></td>
					<td>
						<%
					    if ("0".equals(dto.getQna_private())) { // 공개글
					    %> <a href="javascript:void(0);" class="view-details-link"
						style="color: black; text-decoration: none;"><%=dto.getQna_title() %></a>
						<%
					    } else if ("1".equals(dto.getQna_private())) { // 비밀글
					        // 로그인했고 (작성자이거나 || admin이면)
					        if (id != null && (id.equals(dto.getQna_writer()) || "admin".equals(loginok))) {
					    %> <a href="javascript:void(0);" class="view-details-link" style="color: black; text-decoration: none;"><%=dto.getQna_title() %>
							 <i class="bi bi-lock-fill"></i></a>
                        <%
					        } else { // 비밀글인데 권한 없는 경우
					    %> <%=dto.getQna_title() %> <i class="bi bi-lock-fill"></i>
						<%
					        }
					    } else { // 예외 처리 (혹은 기본)
					    %> <%=dto.getQna_title() %> <%
					    }
					    %>
					</td>
					<td><%=dto.getQna_writer() %></td>
					<td><%=dto.getQna_writeday() %></td>
					<td><%=dto.getQna_readcount() %></td>
				</tr>
				<%-- 원글 내용과 답글이 표시될 영역 (처음에는 숨김) --%>
				<tr class="details-row" id="details-<%=dto.getQna_idx()%>"
					style="display: none;">
					<td colspan="5" class="details-content-cell">
						<%-- 이 안에 내용과 답글이 동적으로 채워짐 --%>
					</td>
				</tr>
				<%
            }
        }
    }
%>
			</tbody>
		</table>

		<nav class="pagination-container">
			<div class="pagination">
				<span class="pagination-inner"> <%
					if(startPage>1){%> <a class="pagination-newer"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=startPage-perBlock%>">이전</a> <%-- 이전 페이지 계산 수정 --%>
					<%}
				
				for(int pp=startPage;pp<=endPage;pp++)
				{
					if(pp==currentPage)
					{%> <a class="pagination-active"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}else{%> <a class="page-link" <%-- 클래스명 일관성 --%>
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}
				}
				
				//다음
				if(endPage<totalPage)
				{%> <a class="pagination-older"
					href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=endPage+1%>">다음</a>
					<%}
				%>
			</div>
		</nav>
	</div>


	<script type="text/javascript">
$(document).ready(function() {
    // 로그인 상태와 사용자 ID를 JavaScript 변수로 가져오기
    // JSP EL/Scriptlet은 페이지 로드 시 한 번만 실행되므로, 그 값을 JS 변수에 저장해두고 사용
    var currentLoginOk = "<%= loginok %>"; // "admin" 또는 "yes" 등의 값, 혹은 null 문자열 "null"
    var currentUserId = "<%= id %>"; // 사용자 ID 또는 null 문자열 "null"
    if (currentLoginOk === "null") currentLoginOk = null; // 실제 null로 사용하기 위함
    if (currentUserId === "null") currentUserId = null;


    $('.view-details-link').on('click', function(e) {
        e.preventDefault();

        var $thisLink = $(this);
        var $parentRow = $thisLink.closest('.original-post-row');
        var qnaIdx = $parentRow.data('idx');
        var regroup = $parentRow.data('regroup');
        var $detailsRow = $('#details-' + qnaIdx);
        var $detailsCell = $detailsRow.find('.details-content-cell');

        if ($detailsRow.is(':visible')) {
            $detailsRow.hide();
            $detailsCell.html('');
            return;
        }

        $('.details-row').not($detailsRow).hide().find('.details-content-cell').html(''); // 다른 열린 상세 닫기

        $.ajax({
            url: '<%= request.getContextPath() %>/board/get_post_details_ajax.jsp',
            type: 'GET',
            data: {
                idx: qnaIdx,
                regroup: regroup
            },
            dataType: 'json',
            beforeSend: function() {
                $detailsCell.html('<div style="text-align:center; padding:20px;">로딩 중...</div>');
                $detailsRow.show();
            },
            success: function(response) {
                var htmlContent = '';

                if (response.originalPost) {
                    var post = response.originalPost;
                    htmlContent += '<div class="original-post-content" style="padding:15px; border-bottom:1px solid #eee;">';
                    htmlContent += '<h4>[질문] ' + escapeHtml(post.qna_title) + '</h4>';
                    
                    var originalPostReplyFormUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp' +
                                      '&parent_idx=' + post.qna_idx +
                                      '&regroup=' + post.regroup +
                                      '&restep=' + post.restep +
                                      '&relevel=' + post.relevel;
                    var originalPostUpdateFormUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportUpdateForm.jsp' +
                                      '&qna_idx=' + post.qna_idx;
                    var originalPostDeleteUrl = '<%= request.getContextPath() %>/board/supportDeleteAction.jsp' + // 액션 페이지 직접 호출
                                      '?qna_idx=' + post.qna_idx + '&from=support'; // from 파라미터 추가 가능

                    var buttonsHtml = '<div style="margin-bottom:10px; text-align:right;">';
                     // admin이거나, 로그인했고 && 글 작성자이면
                    if (currentLoginOk && (currentLoginOk === "admin" || (currentUserId && currentUserId === post.qna_writer))) {
                        buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-secondary updateAnswer" style="margin-left: 5px;" ' +
                                           'onclick="location.href=\'' + originalPostUpdateFormUrl + '\'">' +
                                           '<i class="bi bi-pencil-square"></i>&nbsp;수정</button>';
                        buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-danger deleteOriginalPost" style="margin-left: 5px;" ' +
                                           'onclick="if(confirm(\'정말로 이 게시글과 관련된 모든 답글을 삭제하시겠습니까?\\n삭제 후에는 복구할 수 없습니다.\')) location.href=\'' + originalPostDeleteUrl + '\'">' +
                                           '<i class="bi bi-trash"></i>&nbsp;삭제</button>';
                    }
                    // admin이면 답글 작성 버튼 항상 보임 (원글에 대한 답글)
                    if (currentLoginOk === "admin") {
                         buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-primary answerAdd" style="margin-left: 5px;" ' +
                                       'onclick="location.href=\'' + originalPostReplyFormUrl + '\'">' +
                                       '<i class="bi bi-plus-square"></i>&nbsp;답변 작성</button>';
                    }
                    buttonsHtml += '</div>';
                    htmlContent += buttonsHtml;

                    htmlContent += '<p style="font-size:0.9em; color:#555;">작성자: ' + escapeHtml(post.qna_writer) + ' | 작성일: ' + escapeHtml(post.qna_writeday_formatted) + ' | 조회수: ' + post.qna_readcount + '</p>';
                    htmlContent += '<hr style="margin-top:5px; margin-bottom:15px;">';
                    if (post.qna_img && post.qna_img.trim() !== "") {
                         htmlContent += '<img src="<%=request.getContextPath()%>/upload/' + escapeHtml(post.qna_img) + '" alt="첨부 이미지" style="max-width:100%; height:auto; max-height:400px; margin-bottom:10px; border-radius:4px;"><br>';
                    }
                    htmlContent += '<div style="min-height:100px;">' + escapeHtml(post.qna_content).replace(/\n/g, '<br>') + '</div>';
                    htmlContent += '</div>';
                }

                htmlContent += '<br><div class="replies-section" style="padding:0 15px 15px 15px;"><h5><i class="bi bi-chat-dots"></i> 답변 목록</h5>';
                if (response.replies && response.replies.length > 0) {
                    htmlContent += '<ul style="list-style:none; padding-left:0;">';
                    $.each(response.replies, function(index, reply) {
                        var replyContent = '';
                        // 답글의 깊이에 따라 왼쪽 패딩 증가 (계단식 표현)
                        var paddingLeft = (parseInt(reply.relevel) || 0) * 20; // relevel이 0부터 시작한다고 가정
                        
                        replyContent += '<li style="margin-top:10px; padding-top:10px; border-top:1px dashed #ccc; padding-left:' + paddingLeft + 'px;">';
                        
                        // 답글 제목 및 작성자 정보
                        replyContent += '<div>';
                        if (parseInt(reply.relevel) > 0) { // relevel이 0보다 큰 경우, 즉 대댓글인 경우 re 이미지 표시
                           replyContent += '<img src="<%=request.getContextPath()%>/image/re.png" alt="re" style="margin-right:5px;"> ';
                        }
                        replyContent += '<strong>' + escapeHtml(reply.qna_title) + '</strong>';
                        replyContent += '<small style="font-size:0.85em; color:#777; margin-left:10px;">작성자: ' + escapeHtml(reply.qna_writer) + ' | 작성일: ' + escapeHtml(reply.qna_writeday_formatted) + '</small>';
                        replyContent += '</div>';

                        // 답글 내용
                        if (reply.qna_img && reply.qna_img.trim() !== "") {
                            replyContent += '<img src="<%=request.getContextPath()%>/upload/' + escapeHtml(reply.qna_img) + '" alt="답변 이미지" style="max-width:100%; height:auto; max-height:300px; margin-top:5px; margin-bottom:5px; border-radius:4px;">';
                        }
                        replyContent += '<div style="margin-top:5px; margin-bottom:10px;">' + escapeHtml(reply.qna_content).replace(/\n/g, '<br>') + '</div>';

                        // --- 답글에 대한 버튼들 ---
                        var replyButtonsHtml = '<div style="text-align:right; margin-bottom:5px;">';
                        
                        // 답글에 대한 답글 작성 URL
                        var replyToThisReplyUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp' +
	                          '&parent_idx=' + reply.qna_idx +
	                          '&regroup=' + reply.regroup +
	                          '&restep=' + reply.restep +
	                          '&relevel=' + reply.relevel;
                        
                        
                        var updateThisReplyUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportUpdateForm.jsp' +
                                             '&qna_idx=' + reply.qna_idx;
                        
                        var deleteThisReplyUrl = '<%= request.getContextPath() %>/board/supportDeleteAction.jsp' + // 액션 페이지 직접 호출
                                             '?qna_idx=' + reply.qna_idx + '&from=support';
	
						
                        // admin이거나, (로그인했고 && 현재 답글의 작성자이면)
                        if (currentLoginOk && (currentLoginOk === "admin" || (currentUserId && currentUserId === reply.qna_writer))) {
                             replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-secondary" style="margin-left: 5px;" ' +
                                               'onclick="location.href=\'' + updateThisReplyUrl + '\'">' +
                                               '<i class="bi bi-pencil-square"></i>&nbsp;수정</button>';
                            replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-danger" style="margin-left: 5px;" ' +
                                               'onclick="if(confirm(\'이 답변을 삭제하시겠습니까?\')) location.href=\'' + deleteThisReplyUrl + '\'">' +
                                               '<i class="bi bi-trash"></i>&nbsp;삭제</button>';
                        }
                        
                        // admin이면 답글에 대한 답글 작성 버튼 항상 보임
                        if (currentLoginOk === "admin") {
                           replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-info" style="margin-left: 5px;" ' +
                                          'onclick="location.href=\'' + replyToThisReplyUrl + '\'">' +
                                          '<i class="bi bi-reply-fill"></i>&nbsp;답변달기</button>';
                        }
                        replyButtonsHtml += '</div>';
                        replyContent += replyButtonsHtml;
                        // --- ---

                        replyContent += '</li>';
                        htmlContent += replyContent;
                    });
                    htmlContent += '</ul>';
                } else {
                    htmlContent += '<p style="color:#888; text-align:center; padding:10px 0;">등록된 답변이 없습니다.</p>';
                }
                htmlContent += '</div>';

                $detailsCell.html(htmlContent);
                if(!$detailsRow.is(':visible')) { // 이미 show() 된 상태면 다시 show() 하지 않음
                    $detailsRow.show();
                }
            },
            error: function(xhr, status, error) {
                $detailsCell.html('<div style="color:red; text-align:center; padding:20px;">내용을 불러오는데 실패했습니다.</div>');
                console.error("AJAX Error: ", status, error, xhr.responseText);
            }
        });
    });

    function escapeHtml(unsafe) {
        if (unsafe === null || typeof unsafe === 'undefined') return '';
        return String(unsafe) // Ensure it's a string before replacing
             .replace(/&/g, "&amp;")
             .replace(/</g, "&lt;")
             .replace(/>/g, "&gt;")
             .replace(/"/g, "&quot;")
             .replace(/'/g, "&#039;");
    }
});
</script>
</body>
</html>