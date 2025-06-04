<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardEventDao" %>

<%
    // 1. 관리자 세션 확인
    String sessionId = (String) session.getAttribute("loginok"); // 실제 사용하는 세션 속성 이름으로 변경
    if (sessionId == null || !sessionId.equals("admin")) {      // 실제 관리자 식별 값과 비교
        out.println("<script>");
        out.println("alert('삭제 권한이 없습니다.');");
        out.println("location.href='" + request.getContextPath() + "/index.jsp';"); // 또는 로그인 페이지
        out.println("</script>");
        return;
    }

    // 2. 삭제할 이벤트 ID 받기 (URL 파라미터 'idx'로 전달받는다고 가정)
    String event_idx_str = request.getParameter("idx");

    if (event_idx_str == null || event_idx_str.trim().isEmpty()) {
        out.println("<script>alert('삭제할 이벤트의 ID가 올바르지 않습니다.'); history.back();</script>");
        return;
    }
    
    // 3. DAO 객체 생성 및 삭제 메소드 호출
    try {
        BoardEventDao dao = new BoardEventDao();
        dao.deleteEvent(event_idx_str);

        // 4. 삭제 완료 후 이벤트 목록 페이지로 리다이렉트
        // 이벤트 목록 페이지가 index.jsp?main=board/boardList.jsp&sub=event.jsp 라고 가정
        response.sendRedirect(request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=event.jsp");
        
    } catch (Exception e) {
        e.printStackTrace(); // 개발 중 오류 확인용
        out.println("<script>alert('이벤트 삭제 중 오류가 발생했습니다: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r") + "'); history.back();</script>");
    }
%>