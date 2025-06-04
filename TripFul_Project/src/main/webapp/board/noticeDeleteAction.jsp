<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardNoticeDao" %>

<%
    // 1. 관리자 세션 확인
    String sessionId = (String) session.getAttribute("loginok"); // 실제 사용하는 세션 속성 이름
    if (sessionId == null || !sessionId.equals("admin")) {      // 실제 관리자 식별 값
        out.println("<script>");
        out.println("alert('삭제 권한이 없습니다.');");
        out.println("location.href='" + request.getContextPath() + "/index.jsp';");
        out.println("</script>");
        return;
    }

    // 2. 삭제할 공지사항 ID 받기 (URL 파라미터 'idx'로 전달받는다고 가정)
    String notice_idx_str = request.getParameter("idx");

    if (notice_idx_str == null || notice_idx_str.trim().isEmpty()) {
        out.println("<script>alert('삭제할 공지사항의 ID가 올바르지 않습니다.'); history.back();</script>");
        return;
    }
    
    // 3. DAO 객체 생성 및 삭제 메소드 호출
    try {
        BoardNoticeDao dao = new BoardNoticeDao();
        dao.deleteNotice(notice_idx_str);

        // 4. 삭제 완료 후 공지사항 목록 페이지로 리다이렉트
        // 공지사항 목록 페이지가 index.jsp?main=board/boardList.jsp&sub=notice.jsp 라고 가정 (또는 noticeList.jsp)
        response.sendRedirect(request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=notice.jsp"); // 'notice.jsp'는 예시입니다. 실제 목록 파일명으로 변경하세요.
        
    } catch (Exception e) {
        e.printStackTrace(); // 개발 중 오류 확인용
        out.println("<script>alert('공지사항 삭제 중 오류가 발생했습니다: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r") + "'); history.back();</script>");
    }
%>