<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardNoticeDao, board.BoardNoticeDto" %>
<%@ page import="board.BoardEventDao, board.BoardEventDto" %>
<%@ page import="board.BoardSupportDao, board.BoardSupportDto" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.util.Date" %>

<%!
    public String escapeRegex(String keyword) {
        if (keyword == null) return "";
        return keyword.replaceAll("([\\\\\\.\\*\\+\\?\\^\\$\\(\\)\\[\\]\\{\\}\\|\\^\\&])", "\\\\$1");
    }
    public String formatDate(SimpleDateFormat sdf, java.sql.Timestamp timestamp) {
        if (timestamp == null) return "-";
        return sdf.format(timestamp);
    }
    public String formatDate(SimpleDateFormat sdf, java.util.Date date) {
        if (date == null) return "-";
        return sdf.format(date);
    }
    public String getString(String str, String defaultStr) {
        if (str == null || str.trim().isEmpty()) return defaultStr;
        return str.replace("<", "&lt;").replace(">", "&gt;");
    }
    public String highlightKeyword(String text, String keyword) {
        if (text == null || text.isEmpty()) return "내용 없음";
        String safeText = text.replace("<", "&lt;").replace(">", "&gt;");
        if (keyword == null || keyword.isEmpty() || keyword.trim().isEmpty()) return safeText;
        String escapedKeywordForRegex = escapeRegex(keyword.trim());
        if (escapedKeywordForRegex.isEmpty()) return safeText;
        try {
            return safeText.replaceAll("(?i)" + escapedKeywordForRegex, "<mark>$0</mark>");
        } catch (java.util.regex.PatternSyntaxException e) {
            System.err.println("하이라이팅 정규식 오류: " + e.getMessage());
            return safeText;
        }
    }
%>

<%
    request.setCharacterEncoding("UTF-8");
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    String displayKeyword = getString(keyword, "");
    String encodedKeyword = URLEncoder.encode(keyword, "UTF-8");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    int perPage = 3; 
    int perBlock = 5; 

    // --- 공지사항(Notice) ---
    int noticeCurrentPage = 1;
    String noticePageStr = request.getParameter("noticePage");
    if (noticePageStr != null && !noticePageStr.isEmpty()) {
        try { noticeCurrentPage = Integer.parseInt(noticePageStr); } catch (NumberFormatException e) { noticeCurrentPage = 1;}
    }
    int noticeStartNum = (noticeCurrentPage - 1) * perPage;
    BoardNoticeDao noticeDao = new BoardNoticeDao();
    List<BoardNoticeDto> noticeList = noticeDao.searchNotices(keyword, noticeStartNum, perPage);
    int totalNoticeCount = noticeDao.getSearchTotalCount(keyword);
    int totalNoticePage = totalNoticeCount / perPage + (totalNoticeCount % perPage == 0 ? 0 : 1);
    int noticeStartPage = (noticeCurrentPage - 1) / perBlock * perBlock + 1;
    int noticeEndPage = noticeStartPage + perBlock - 1;
    if (noticeEndPage > totalNoticePage) noticeEndPage = totalNoticePage;

    // --- 이벤트(Event) ---
    int eventCurrentPage = 1;
    String eventPageStr = request.getParameter("eventPage");
    if (eventPageStr != null && !eventPageStr.isEmpty()) {
        try { eventCurrentPage = Integer.parseInt(eventPageStr); } catch (NumberFormatException e) { eventCurrentPage = 1;}
    }
    int eventStartNum = (eventCurrentPage - 1) * perPage;
    BoardEventDao eventDao = new BoardEventDao();
    List<BoardEventDto> eventList = eventDao.searchEvents(keyword, eventStartNum, perPage);
    int totalEventCount = eventDao.getSearchEventTotalCount(keyword);
    int totalEventPage = totalEventCount / perPage + (totalEventCount % perPage == 0 ? 0 : 1);
    int eventStartPage = (eventCurrentPage - 1) / perBlock * perBlock + 1;
    int eventEndPage = eventStartPage + perBlock - 1;
    if (eventEndPage > totalEventPage) eventEndPage = totalEventPage;

    // --- 고객센터(Support/Q&A) ---
    int supportCurrentPage = 1;
    String supportPageStr = request.getParameter("supportPage");
    if (supportPageStr != null && !supportPageStr.isEmpty()) {
        try { supportCurrentPage = Integer.parseInt(supportPageStr); } catch (NumberFormatException e) { supportCurrentPage = 1;}
    }
    int supportStartNum = (supportCurrentPage - 1) * perPage;
    BoardSupportDao supportDao = new BoardSupportDao();
    List<BoardSupportDto> supportList = supportDao.searchSupport(keyword, supportStartNum, perPage);
    int totalSupportCount = supportDao.getSearchSupportTotalCount(keyword);
    int totalSupportPage = totalSupportCount / perPage + (totalSupportCount % perPage == 0 ? 0 : 1);
    int supportStartPage = (supportCurrentPage - 1) / perBlock * perBlock + 1;
    int supportEndPage = supportStartPage + perBlock - 1;
    if (supportEndPage > totalSupportPage) supportEndPage = totalSupportPage;
%>

<br>
<div class="container mt-2 mb-5 search-results-container">
    <div class="row mb-3">
        <div class="col">
            <h2><i class="bi bi-search"></i> 검색 결과: "<%= displayKeyword %>"</h2>
        </div>
    </div>
    <hr class="mb-4">

    <%-- 공지사항 검색 결과 섹션 --%>
    <div class="search-results-section mb-5">
        <h4><i class="bi bi-megaphone-fill"></i> 공지사항 (<%= totalNoticeCount %>건)</h4>
        <% if (noticeList.isEmpty()) { %>
            <p class="text-muted ps-3 no-results">"<%= displayKeyword %>"에 대한 공지사항이 없습니다.</p>
        <% } else { %>
            <ul class="list-group list-group-flush">
                <% for (BoardNoticeDto notice : noticeList) { %>
                    <li class="list-group-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/noticeDetail.jsp&idx=<%= getString(notice.getNotice_idx(), "") %>&keyword=<%= encodedKeyword %>">
                                <%= highlightKeyword(notice.getNotice_title(), keyword) %>
                            </a>
                            <small class="text-muted item-date flex-shrink-0 ms-2"><%= formatDate(sdf, notice.getNotice_writeday()) %></small>
                        </div>
                        <div class="item-meta mt-1">
                            <span class="item-writer">작성자: <%= getString(notice.getNotice_writer(), "알 수 없음") %></span>
                        </div>
                    </li>
                <% } %>
            </ul>
            <% if(totalNoticePage > 0) { %>
            <nav class="pagination-container">
                <div class="pagination d-flex justify-content-center">
                    <span class="pagination-inner">
                        <% if (noticeStartPage > 1) { %>
                            <a class="pagination-newer" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeStartPage - perBlock %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportCurrentPage %>">이전</a>
                        <% } %>
                        <% for (int i = noticeStartPage; i <= noticeEndPage; i++) { %>
                            <% if (i == noticeCurrentPage) { %>
                                <a class="pagination-active" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= i %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportCurrentPage %>"><%= i %></a>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= i %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportCurrentPage %>"><%= i %></a>
                            <% } %>
                        <% } %>
                        <% if (noticeEndPage < totalNoticePage) { %>
                            <a class="pagination-older" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeEndPage + 1 %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportCurrentPage %>">다음</a>
                        <% } %>
                    </span>
                </div>
            </nav>
            <% } %>
        <% } %>
    </div>

    <%-- 이벤트 검색 결과 섹션 --%>
    <div class="search-results-section mb-5">
        <h4><i class="bi bi-calendar-event-fill"></i> 이벤트 (<%= totalEventCount %>건)</h4>
        <% if (eventList.isEmpty()) { %>
            <p class="text-muted ps-3 no-results">"<%= displayKeyword %>"에 대한 이벤트가 없습니다.</p>
        <% } else { %>
            <ul class="list-group list-group-flush">
                <% for (BoardEventDto event : eventList) { %>
                     <li class="list-group-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/eventDetail.jsp&idx=<%= getString(event.getEvent_idx(),"") %>&keyword=<%= encodedKeyword %>">
                                 <%= highlightKeyword(event.getEvent_title(), keyword) %>
                            </a>
                             <small class="text-muted item-date flex-shrink-0 ms-2"><%= formatDate(sdf, event.getEvent_writeday()) %></small>
                        </div>
                         <div class="item-meta mt-1">
                            <span class="item-writer">작성자: <%= getString(event.getEvent_writer(), "알 수 없음") %></span>
                        </div>
                    </li>
                <% } %>
            </ul>
            <% if(totalEventPage > 0) { %>
            <nav class="pagination-container">
                <div class="pagination d-flex justify-content-center">
                    <span class="pagination-inner">
                        <% if (eventStartPage > 1) { %>
                            <a class="pagination-newer" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventStartPage - perBlock %>&supportPage=<%= supportCurrentPage %>">이전</a>
                        <% } %>
                        <% for (int i = eventStartPage; i <= eventEndPage; i++) { %>
                            <% if (i == eventCurrentPage) { %>
                                <a class="pagination-active" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= i %>&supportPage=<%= supportCurrentPage %>"><%= i %></a>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= i %>&supportPage=<%= supportCurrentPage %>"><%= i %></a>
                            <% } %>
                        <% } %>
                        <% if (eventEndPage < totalEventPage) { %>
                            <a class="pagination-older" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventEndPage + 1 %>&supportPage=<%= supportCurrentPage %>">다음</a>
                        <% } %>
                    </span>
                </div>
            </nav>
            <% } %>
        <% } %>
    </div>

    <%-- 고객센터 검색 결과 섹션 --%>
    <div class="search-results-section">
        <h4><i class="bi bi-headset"></i> 고객센터 문의 (<%= totalSupportCount %>건)</h4>
        <% if (supportList.isEmpty()) { %>
            <p class="text-muted ps-3 no-results">"<%= displayKeyword %>"에 대한 문의글이 없습니다.</p>
        <% } else { %>
            <ul class="list-group list-group-flush">
                <% for (BoardSupportDto support : supportList) { %>
                     <li class="list-group-item">
                        <div class="d-flex justify-content-between align-items-start">
                            <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardList.jsp&sub=support.jsp&keyword=<%= encodedKeyword %>&scrollToQna=<%= getString(support.getQna_idx(),"") %>">
                                 <%= highlightKeyword(support.getQna_title(), keyword) %>
                                <% if ("1".equals(support.getQna_private())) { %><i class="bi bi-lock-fill ms-1"></i><% } %>
                            </a>
                             <small class="text-muted item-date flex-shrink-0 ms-2"><%= formatDate(sdf, support.getQna_writeday()) %></small>
                        </div>
                        <div class="item-meta mt-1">
                            <span class="item-writer">작성자: <%= getString(support.getQna_writer(), "알 수 없음") %></span>
                        </div>
                    </li>
                <% } %>
            </ul>
            <% if(totalSupportPage > 0) { %>
            <nav class="pagination-container">
                <div class="pagination d-flex justify-content-center">
                     <span class="pagination-inner">
                        <% if (supportStartPage > 1) { %>
                            <a class="pagination-newer" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportStartPage - perBlock %>">이전</a>
                        <% } %>
                        <% for (int i = supportStartPage; i <= supportEndPage; i++) { %>
                            <% if (i == supportCurrentPage) { %>
                                <a class="pagination-active" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= i %>"><%= i %></a>
                            <% } else { %>
                                <a href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= i %>"><%= i %></a>
                            <% } %>
                        <% } %>
                        <% if (supportEndPage < totalSupportPage) { %>
                            <a class="pagination-older" href="<%= request.getContextPath() %>/index.jsp?main=board/boardSearchResult.jsp&keyword=<%= encodedKeyword %>&noticePage=<%= noticeCurrentPage %>&eventPage=<%= eventCurrentPage %>&supportPage=<%= supportEndPage + 1 %>">다음</a>
                        <% } %>
                    </span>
                </div>
            </nav>
            <% } %>
        <% } %>
    </div>
</div>