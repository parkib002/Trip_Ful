
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
<link rel="stylesheet" href="../css/noticeStyle.css">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
</head>
<%
String loginok=(String)session.getAttribute("loginok");
String id=(String)session.getAttribute("id");
BoardSupportDao dao=new BoardSupportDao();
SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd HH:mm");

//페이징처리
//전체갯수
int totalCount=dao.getTotalCount();
int perPage=10; //한페이지에 보여질 글의 갯수
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
		<h3><i class="bi bi-x-diamond-fill">  </i><b>고객센터</b></h3>
		<a style="float: right; text-decoration: none; color: black;" 
		href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportAddForm.jsp">
			<i class="bi bi-plus-square"></i>&nbsp;문의하기
		</a>
		<hr>
	</div>
	<br>
	<table class="table table-hover notice-table" style="width: 1400px;">
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
    if(list.isEmpty()){ // list.size()==0 보다 isEmpty()가 더 나음
%>
       <tr>
         <td colspan="5" align="center">
           <b>등록된 게시글이 없습니다</b>
         </td>
       </tr>
<%
    } else {
        for(int i=0; i<list.size(); i++) {
            BoardSupportDto dto = list.get(i);
            // 원글만 기본 목록에 표시 (relevel == 0 인 글)
            if (dto.getRelevel() == 0) {
%>
               <tr class="original-post-row" data-idx="<%=dto.getQna_idx()%>" data-regroup="<%=dto.getRegroup()%>">
                  <td><%=no-i%></td>
                  <td>
                      <%-- 상세 보기 링크 대신 JavaScript 함수 호출 --%>
                      <%
					    // 조건 1: 글이 공개글인 경우 ("0") 누구나 제목을 클릭하여 상세 내용을 볼 수 있음
					    if ("0".equals(dto.getQna_private())) {
					    %>
					        <a href="javascript:void(0);" class="view-details-link"
					        style="color: black; text-decoration: none;"><%=dto.getQna_title() %></a>
					    <%
					    // 조건 2: 글이 비밀글인 경우 ("1")
					    } else if ("1".equals(dto.getQna_private())) {
					        // 조건 2-1: 로그인한 사용자가 글 작성자와 동일한 경우, 제목을 클릭하여 상세 내용을 볼 수 있음
					        if (loginok != null && id != null && id.equals(dto.getQna_writer())) {
					    %>
					            <a href="javascript:void(0);" class="view-details-link"><%=dto.getQna_title() %>
					            	<!-- 자물쇠 아이콘 -->
					            	<i class="bi bi-lock-fill"></i>
					            </a>
					    <%
					        // 조건 2-2: 로그인한 사용자가 글 작성자와 다르거나, 로그인하지 않은 경우, 제목만 표시하고 클릭 기능 없음
					        } else {
					    %>
					            <%=dto.getQna_title() %> <i class="bi bi-lock-fill"></i> <%-- 자물쇠 아이콘 추가 --%>
					    <%
					        }
					    // 조건 3: qna_private 값이 "0"도 "1"도 아닌 예외적인 경우 (또는 기본적으로 제목만 표시)
					    } else {
					    %>
					        <%=dto.getQna_title() %>
					    <%
					    }
					    %>
                  </td>
                  <td><%=dto.getQna_writer() %></td>
                  <td><%=dto.getQna_writeday() %></td>
                  <td><%=dto.getQna_readcount() %></td>
               </tr>
               <%-- 원글 내용과 답글이 표시될 영역 (처음에는 숨김) --%>
               <tr class="details-row" id="details-<%=dto.getQna_idx()%>" style="display:none;">
                   <td colspan="5" class="details-content-cell">
                       <%-- 이 안에 내용과 답글이 동적으로 채워짐 --%>
                   </td>
               </tr>
<%
            }
            // 답글은 처음에는 그리지 않거나, 다른 방식으로 처리 (AJAX로 가져오므로)
        }
    }
%>
</tbody>
	</table>
	
	<nav class="pagination-container">
		<div class="pagination">
			<span class="pagination-inner">
				<%
					if(startPage>1){%>
						<a class="pagination-newer" href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=startPage-5%>">이전</a>
					<%}
				
				for(int pp=startPage;pp<=endPage;pp++)
				{
					if(pp==currentPage)
					{%>
						<a class="pagination-active" href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}else{%>
						<a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=pp%>"><%=pp %></a>
					<%}
					
					
				}
				
				//다음
				if(endPage<totalPage)
				{%>
					<a class="pagination-older" href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&currentPage=<%=endPage+1%>">다음</a>
				<%}
				%>
		</div>
</nav>
</div>



<!-- 스크립트 기능 -->
<script type="text/javascript">
function toggleReplies(regroupValue, element) {
    // 특정 regroup 값을 가진 답글들을 선택
    var replies = document.querySelectorAll('.reply-post.regroup-' + regroupValue);
    // jQuery 방식: var $replies = $('.reply-post.regroup-' + regroupValue);

    for (var i = 0; i < replies.length; i++) {
        if (replies[i].style.display === 'none') {
            replies[i].style.display = ''; // 또는 'table-row'
        } else {
            replies[i].style.display = 'none';
        }
    }	

</script>
<script type="text/javascript">
$(document).ready(function() {
    $('.view-details-link').on('click', function(e) {
        e.preventDefault(); // 링크의 기본 동작(페이지 이동) 방지

        var $thisLink = $(this);
        var $parentRow = $thisLink.closest('.original-post-row');
        var qnaIdx = $parentRow.data('idx');
        var regroup = $parentRow.data('regroup');
        var $detailsRow = $('#details-' + qnaIdx);
        var $detailsCell = $detailsRow.find('.details-content-cell');

        // 이미 내용이 로드되어 있고 보이는 상태면 숨김 (토글 기능)
        if ($detailsRow.is(':visible')) {
            $detailsRow.hide();
            $detailsCell.html(''); // 내용 비우기
            return;
        }

        // 다른 열려있는 상세 내용은 숨기기 (선택 사항)
        $('.details-row').hide().find('.details-content-cell').html('');

        // AJAX 요청
        $.ajax({
            url: '<%= request.getContextPath() %>/board/get_post_details_ajax.jsp', // AJAX 요청 처리 페이지
            type: 'GET',
            data: {
                idx: qnaIdx,
                regroup: regroup
            },
            dataType: 'json', // 서버로부터 JSON 형식의 응답을 기대
            beforeSend: function() {
                // 로딩 표시 (선택 사항)
                $detailsCell.html('로딩 중...');
                $detailsRow.show();
            },
            success: function(response) {
                var htmlContent = '';

                // 원글 내용 표시
                if (response.originalPost) {
                    var post = response.originalPost;
                    htmlContent += '<div class="original-post-content" style="padding:15px; border-bottom:1px solid #eee;">';
                    htmlContent += '<h4>[질문] ' + escapeHtml(post.qna_title) + '</h4>';
                 	
                	 // support.jsp의 AJAX success 콜백 내
                    var post_qna_idx = post.qna_idx !== undefined && post.qna_idx !== null ? post.qna_idx : '0'; // 기본값 예시
                    var post_regroup = post.regroup !== undefined && post.regroup !== null ? post.regroup : '0';
                    var post_restep = post.restep !== undefined && post.restep !== null ? post.restep : '0';
                    var post_relevel = post.relevel !== undefined && post.relevel !== null ? post.relevel : '0';
                    
                    // "답글" 버튼 수정
                    var replyFormUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp' +
                                       '&parent_idx=' + post.qna_idx +       // 부모 글의 고유 ID
                                       '&regroup=' + post.regroup +         // 부모 글의 그룹 ID
                                       '&restep=' + post.restep +           // 부모 글의 스텝
                                       '&relevel=' + post.relevel;          // 부모 글의 레벨
                                       
                    htmlContent += '<button type="button" class="btn btn-sm btn-outline-secondary answerAdd" style="float: right;" ' +
                    'onclick="location.href=\'' + replyFormUrl + '\'">' +
                    '<i class="bi bi-pencil-square"></i>&nbsp;답글 작성</button>';
                    htmlContent += '<p>작성자: ' + escapeHtml(post.qna_writer) + ' | 작성일: ' + escapeHtml(post.qna_writeday_formatted) + ' | 조회수: ' + post.qna_readcount + '</p>';
                    htmlContent += '<hr>';
                    // 이미지가 있다면 표시 (경로 수정 필요)
                    if (post.qna_img && post.qna_img.trim() !== "") {
                         htmlContent += '<img src="<%=request.getContextPath()%>/upload/' + escapeHtml(post.qna_img) + '" alt="첨부 이미지" style="max-width:400px; margin-bottom:10px;"><br>';
                    }
                    htmlContent += '<div>' + escapeHtml(post.qna_content).replace(/\n/g, '<br>') + '</div>'; // 내용 (개행문자 <br>로 변경)
                    htmlContent += '</div>';
                    console.log(htmlContent);
                }
                // 답글 목록 표시
                htmlContent += '<div class="replies-section" style="padding:15px;"><h5>답변 목록</h5>';
                if (response.replies && response.replies.length > 0) {
                    htmlContent += '<ul style="list-style:none; padding-left:0;">';
                    $.each(response.replies, function(index, reply) {
                        htmlContent += '<li style="margin-top:10px; padding-top:10px; border-top:1px dashed #ccc; padding-left:' + (reply.relevel * 20) + 'px;">'; // 들여쓰기
                        htmlContent += '<img src="<%=request.getContextPath()%>/image/re.png" alt="re"> <strong>' + escapeHtml(reply.qna_title) + '</strong><br>';
                        htmlContent += '<small>작성자: ' + escapeHtml(reply.qna_writer) + ' | 작성일: ' + escapeHtml(reply.qna_writeday_formatted) + '</small>';
                        if (reply.qna_img && reply.qna_img.trim() !== "") {
                            htmlContent += '<br><img src="<%=request.getContextPath()%>/upload/' + escapeHtml(reply.qna_img) + '" alt="답변 이미지" style="max-width:300px; margin-top:5px; margin-bottom:5px;">';
                        }
                        htmlContent += '<div>' + escapeHtml(reply.qna_content).replace(/\n/g, '<br>') + '</div>';
                        htmlContent += '</li>';
                    });
                    htmlContent += '</ul>';
                } else {
                    htmlContent += '<p>등록된 답변이 없습니다.</p>';
                }
                htmlContent += '</div>';

                $detailsCell.html(htmlContent);
                $detailsRow.show(); // 숨겨진 행을 보이도록 변경
            },
            error: function(xhr, status, error) {
                $detailsCell.html('내용을 불러오는데 실패했습니다.');
                console.error("AJAX Error: ", status, error, xhr.responseText);
            }
        });
    });

    // XSS 방지를 위한 HTML 이스케이프 함수
    function escapeHtml(unsafe) {
        if (unsafe === null || typeof unsafe === 'undefined') return '';
        return unsafe
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