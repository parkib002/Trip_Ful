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
<script type="text/javascript">
    function filterList() {
        var filterValue = document.getElementById('answerFilter').value;
        var currentUrl = new URL(window.location.href);
        currentUrl.searchParams.set("filter", filterValue);
        currentUrl.searchParams.set("currentPage", "1"); // 필터 변경 시 1페이지부터 보도록 초기화
        window.location.href = currentUrl.toString();
    }

    // 페이지 로드 시 현재 필터 값에 따라 select 박스 선택
    document.addEventListener('DOMContentLoaded', function() {
        var filterSelect = document.getElementById('answerFilter');
        var urlParams = new URLSearchParams(window.location.search);
        var currentFilter = urlParams.get('filter');
        if (filterSelect && currentFilter) {
            for (var i = 0; i < filterSelect.options.length; i++) {
                if (filterSelect.options[i].value === currentFilter) {
                    filterSelect.options[i].selected = true;
                    break;
                }
            }
        } else if (filterSelect) { // 필터 파라미터가 없으면 'all'을 기본으로 선택
            filterSelect.value = "all";
        }
    });
</script>
</head>
<%
String loginok = (String)session.getAttribute("loginok");
String id = (String)session.getAttribute("id");

BoardSupportDao dao = new BoardSupportDao();
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

// 답변 상태 필터 값 가져오기
String filter = request.getParameter("filter");
if (filter == null || filter.isEmpty() || 
    !java.util.Arrays.asList("all", "answered", "unanswered").contains(filter)) {
    filter = "all"; // 기본값 또는 유효하지 않은 값일 경우
}

//페이징처리
int totalCount = dao.getTotalCount(filter); // 필터 값 전달
int perPage = 10; 
int perBlock = 5; 
int startNum; 
int startPage; 
int endPage;
int currentPage; 
int totalPage; 
int no; 

String currentPageParam = request.getParameter("currentPage");
if (currentPageParam == null || currentPageParam.isEmpty()) {
    currentPage = 1;
} else {
    try {
        currentPage = Integer.parseInt(currentPageParam);
    } catch (NumberFormatException e) {
        currentPage = 1; // 숫자가 아니면 1로 초기화
    }
}
if (currentPage < 1) currentPage = 1; // currentPage가 0 이하일 경우 1로 조정

totalPage = totalCount / perPage + (totalCount % perPage == 0 ? 0 : 1);
if (totalPage == 0) totalPage = 1; // 게시글이 없을 경우에도 1페이지로 표시
if (currentPage > totalPage) currentPage = totalPage; // 현재 페이지가 총 페이지보다 크면 마지막 페이지로

startPage = (currentPage - 1) / perBlock * perBlock + 1;
endPage = startPage + perBlock - 1;

if (endPage > totalPage) {
    endPage = totalPage;
}

startNum = (currentPage - 1) * perPage;
no = (int) (totalCount - ((long)currentPage - 1) * perPage);

List<BoardSupportDto> list = dao.getAllDatas(startNum, perPage, filter); // 필터 값 전달

String keywordFromRequest = request.getParameter("keyword");

%>
<body>

<br><br><br>
<!-- 검색창 -->
<div class="container my-3 board-search-container">
    <div class="row justify-content-center">
        <div class="col-12 col-md-8 col-lg-6">
            <form action="<%= request.getContextPath() %>/index.jsp" method="get" class="d-flex" id="boardPageGlobalSearchForm">
                <%-- main 파라미터를 boardSearchResults.jsp로 직접 지정 --%>
                <input type="hidden" name="main" value="board/boardSearchResult.jsp"> 
                
                <input class="form-control me-2" type="search"
                       id="boardPageGlobalSearchInput"
                       name="keyword"
                       value="<%= keywordFromRequest != null ? keywordFromRequest.replace("\"", "&quot;") : "" %>" 
                       placeholder="게시판 통합 검색"
                       aria-label="게시판 통합 검색">
                <button class="btn" type="submit"
                style="width: 100px; height: 50px;
                background-color: #2c3e50; color: white;">
                    <i class="bi bi-search"></i> 검색
                </button>
            </form>
        </div>
    </div>
</div>

    <div class="notice-wrapper-support">
        <div class="notice-header">
            <h3>
                <i class="bi bi-x-diamond-fill"> </i><b>고객센터</b>
            </h3>
            <select id="answerFilter" name="filter" onchange="filterList()">
                <option value="all">전체</option>
                <option value="answered">답변 완료</option>
                <option value="unanswered">미답변</option>
            </select>
            <%
            if(loginok == null) {
            %>
                <a style="float: right; text-decoration: none; color: black; margin-top: 20px;"
                href="javascript:void(0);" 
                onclick="if(confirm('로그인이 필요한 서비스입니다. 로그인 페이지로 이동하시겠습니까?')) { location.href='<%= request.getContextPath() %>/index.jsp?main=login/login.jsp'; } return false;">
                    <i class="bi bi-plus-square"></i>&nbsp;문의하기
                </a>
            <%} else {%>
                <a style="float: right; text-decoration: none; color: black; margin-top: 20px;"
                href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportAddForm.jsp">
                    <i class="bi bi-plus-square"></i>&nbsp;문의하기
                </a>
            <%} %>
            <hr style="clear: both;">
        </div>
        <br>
        <table class="table table-hover notice-table">
            <thead>
                <tr>
                    <th scope="col" style="width: 8%;">번호</th>
                    <th scope="col" style="width: 37%;">제목</th> 
                    <th scope="col" style="width: 15%; text-align: center;">작성자</th>
                    <th scope="col" style="width: 15%;">작성일</th> 
                    <th scope="col" style="width: 10%; text-align: center;">상태</th>
                    <th scope="col" style="width: 10%; text-align: center;">조회수</th>
                </tr>
            </thead>
            <tbody>
                <%
                if(list.isEmpty()){
                %>
                    <tr>
                        <td colspan="6" align="center"><b>
                        <%
                        if (!"all".equals(filter) && totalCount == 0) {
                            if ("answered".equals(filter)) {
                                out.print("답변 완료된 게시글이 없습니다.");
                            } else if ("unanswered".equals(filter)) {
                                out.print("미답변 게시글이 없습니다.");
                            } else {
                                out.print("해당 조건의 게시글이 없습니다.");
                            }
                        } else {
                            out.print("등록된 게시글이 없습니다.");
                        }
                        %>
                        </b></td>
                    </tr>
                <%
                } else {
                    for(int i = 0; i < list.size(); i++) {
                        BoardSupportDto dto = list.get(i);
                        // relevel == 0 조건은 DAO에서 이미 처리되었으므로 JSP에서는 생략 가능
                %>
                <tr class="original-post-row" data-idx="<%=dto.getQna_idx()%>"
                    data-regroup="<%=dto.getRegroup()%>">
                    <th> &nbsp;<%=no - i%></th>
                    <td>
                        <%
                        if ("0".equals(dto.getQna_private())) { 
                        %> <a href="javascript:void(0);" class="view-details-link"
                        style="color: black; text-decoration: none;"><%=dto.getQna_title() %></a>
                        <%
                        } else if ("1".equals(dto.getQna_private())) { 
                            if (id != null && (id.equals(dto.getQna_writer()) || (loginok != null && "admin".equals(loginok)))) {
                        %> <a href="javascript:void(0);" class="view-details-link" style="color: black; text-decoration: none;"><%=dto.getQna_title() %>
                             <i class="bi bi-lock-fill"></i></a>
                        <%
                            } else { 
                        %> <%=dto.getQna_title() %> <i class="bi bi-lock-fill"></i>
                        <%
                            }
                        } else { 
                        %> <%=dto.getQna_title() %> <%
                        }
                        %>
                    </td>
                    <td align="center"><%=dto.getQna_writer() %></td>
                    <td><%=sdf.format(dto.getQna_writeday()) %></td>
                    <td align="center">
                        <% if (dto.isAnswered()) { %>
                            &nbsp;<span class="status-answered badge rounded-pill bg-success" style="font-size: 0.9em; white-space: nowrap;">답변 완료</span>
                        <% } else { %>
                             &nbsp;<span class="status-unanswered badge rounded-pill bg-danger" style="font-size: 0.9em; white-space: nowrap;">미답변</span>
                        <% } %>
                    </td>
                    <td align="center"><%=dto.getQna_readcount() %></td>
                </tr>
                <tr class="details-row" id="details-<%=dto.getQna_idx()%>" style="display: none;">
                    <td colspan="6" class="details-content-cell"></td>
                </tr>
                <%
                    } // end for
                } // end else
                %>
            </tbody>
        </table>

        <nav class="pagination-container">
            <div class="pagination">
                <span class="pagination-inner"> 
                <%
                String pageUrlPrefix = request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=support.jsp&filter=" + filter + "&currentPage=";
                if(startPage > 1) { // 이전 블럭
                %> 
                    <a class="pagination-newer" href="<%= pageUrlPrefix + (startPage - 1) %>">이전</a>
                <%}
                
                for(int pp = startPage; pp <= endPage; pp++) {
                    if(pp == currentPage) {
                %> 
                    <a class="pagination-active" href="<%= pageUrlPrefix + pp %>"><%=pp %></a>
                <%  } else { %> 
                    <a class="page-link" href="<%= pageUrlPrefix + pp %>"><%=pp %></a>
                <%  }
                }
                
                if(endPage < totalPage) { // 다음 블럭
                %> 
                    <a class="pagination-older" href="<%= pageUrlPrefix + (endPage + 1) %>">다음</a>
                <%} %>
                </span>
            </div>
        </nav>
    </div>

    <%-- AJAX 로직은 이전과 동일하게 유지 --%>
    <script type="text/javascript">
    $(document).ready(function() {
        var currentLoginOk = "<%= loginok == null ? "null" : loginok %>"; 
        var currentUserId = "<%= id == null ? "null" : id %>"; 
        if (currentLoginOk === "null") currentLoginOk = null; 
        if (currentUserId === "null") currentUserId = null;

        // ... (나머지 AJAX 및 escapeHtml 함수는 이전과 동일) ...
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

            $('.details-row').not($detailsRow).hide().find('.details-content-cell').html('');

            $.ajax({
                url: '<%= request.getContextPath() %>/board/get_post_details_ajax.jsp',
                type: 'GET',
                data: { idx: qnaIdx, regroup: regroup },
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
                        var originalPostDeleteUrl = '<%= request.getContextPath() %>/board/supportDeleteAction.jsp' +
                                          '?qna_idx=' + post.qna_idx + '&from=support';

                        var buttonsHtml = '<div style="margin-bottom:10px; text-align:right;">';
                        if (currentLoginOk && (currentLoginOk === "admin" || (currentUserId && currentUserId === post.qna_writer))) {
                            buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-secondary updateAnswer" style="margin-left: 5px;" ' +
                                               'onclick="location.href=\'' + originalPostUpdateFormUrl + '\'">' +
                                               '<i class="bi bi-pencil-square"></i>&nbsp;수정</button>';
                            buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-danger deleteOriginalPost" style="margin-left: 5px;" ' +
                                               'onclick="if(confirm(\'정말로 이 게시글과 관련된 모든 답글을 삭제하시겠습니까?\\n삭제 후에는 복구할 수 없습니다.\')) location.href=\'' + originalPostDeleteUrl + '\'">' +
                                               '<i class="bi bi-trash"></i>&nbsp;삭제</button>';
                        }
                        if (currentLoginOk === "admin") {
                             buttonsHtml += '<button type="button" class="btn btn-sm btn-outline-primary answerAdd" style="margin-left: 5px;" ' +
                                           'onclick="location.href=\'' + originalPostReplyFormUrl + '\'">' +
                                           '<i class="bi bi-plus-square"></i>&nbsp;답변 작성</button>';
                        }
                        buttonsHtml += '</div>';
                        htmlContent += buttonsHtml;

                        htmlContent += '<p style="font-size:0.9em; color:#555;">작성자: ' + escapeHtml(post.qna_writer) + ' | 작성일: ' + escapeHtml(post.qna_writeday_formatted) + ' | 조회수: ' + post.qna_readcount + '</p>';
                        htmlContent += '<hr style="margin-top:5px; margin-bottom:15px;">';
                        if (post.qna_img && post.qna_img.trim() !== "" && post.qna_img.trim() !== "null") {
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
                            var paddingLeft = (parseInt(reply.relevel) || 0) * 20; 
                            
                            replyContent += '<li style="margin-top:10px; padding-top:10px; border-top:1px dashed #ccc; padding-left:' + paddingLeft + 'px;">';
                            replyContent += '<div>';
                            if (parseInt(reply.relevel) > 0) { 
                               replyContent += '<img src="<%=request.getContextPath()%>/image/re.png" alt="re" style="margin-right:5px;"> ';
                            }
                            replyContent += '<strong>' + escapeHtml(reply.qna_title) + '</strong>';
                            replyContent += '<small style="font-size:0.85em; color:#777; margin-left:10px;">작성자: ' + escapeHtml(reply.qna_writer) + ' | 작성일: ' + escapeHtml(reply.qna_writeday_formatted) + '</small>';
                            replyContent += '</div>';

                            if (reply.qna_img && reply.qna_img.trim() !== "" && reply.qna_img.trim() !== "null") {
                                replyContent += '<img src="<%=request.getContextPath()%>/upload/' + escapeHtml(reply.qna_img) + '" alt="답변 이미지" style="max-width:100%; height:auto; max-height:300px; margin-top:5px; margin-bottom:5px; border-radius:4px;">';
                            }
                            replyContent += '<div style="margin-top:5px; margin-bottom:10px;">' + escapeHtml(reply.qna_content).replace(/\n/g, '<br>') + '</div>';

                            var replyButtonsHtml = '<div style="text-align:right; margin-bottom:5px;">';
                            var replyToThisReplyUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportReplyForm.jsp' +
                                  '&parent_idx=' + reply.qna_idx + '&regroup=' + reply.regroup + '&restep=' + reply.restep + '&relevel=' + reply.relevel;
                            var updateThisReplyUrl = '<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=supportUpdateForm.jsp' +
                                                 '&qna_idx=' + reply.qna_idx;
                            var deleteThisReplyUrl = '<%= request.getContextPath() %>/board/supportDeleteAction.jsp' +
                                                 '?qna_idx=' + reply.qna_idx + '&from=support';
                            
                            if (currentLoginOk && (currentLoginOk === "admin" || (currentUserId && currentUserId === reply.qna_writer))) {
                                 replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-secondary" style="margin-left: 5px;" ' +
                                                   'onclick="location.href=\'' + updateThisReplyUrl + '\'">' +
                                                   '<i class="bi bi-pencil-square"></i>&nbsp;수정</button>';
                                replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-danger" style="margin-left: 5px;" ' +
                                                   'onclick="if(confirm(\'이 답변을 삭제하시겠습니까?\')) location.href=\'' + deleteThisReplyUrl + '\'">' +
                                                   '<i class="bi bi-trash"></i>&nbsp;삭제</button>';
                            }
                            if (currentLoginOk === "admin") {
                               replyButtonsHtml += '<button type="button" class="btn btn-sm btn-outline-info" style="margin-left: 5px;" ' +
                                              'onclick="location.href=\'' + replyToThisReplyUrl + '\'">' +
                                              '<i class="bi bi-reply-fill"></i>&nbsp;답변달기</button>';
                            }
                            replyButtonsHtml += '</div>';
                            replyContent += replyButtonsHtml;
                            replyContent += '</li>';
                            htmlContent += replyContent;
                        });
                        htmlContent += '</ul>';
                    } else {
                        htmlContent += '<p style="color:#888; text-align:center; padding:10px 0;">등록된 답변이 없습니다.</p>';
                    }
                    htmlContent += '</div>';

                    $detailsCell.html(htmlContent);
                    if(!$detailsRow.is(':visible')) { $detailsRow.show(); }
                },
                error: function(xhr, status, error) {
                    $detailsCell.html('<div style="color:red; text-align:center; padding:20px;">내용을 불러오는데 실패했습니다.</div>');
                    console.error("AJAX Error: ", status, error, xhr.responseText);
                }
            });
        });

        function escapeHtml(unsafe) {
            if (unsafe === null || typeof unsafe === 'undefined') return '';
            return String(unsafe)
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