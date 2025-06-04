<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.EventAnswerDao" %>
<%@ page import="board.EventAnswerDto" %>
<%
    request.setCharacterEncoding("UTF-8");

    String event_idx = request.getParameter("event_idx");
    String writer = request.getParameter("user_id"); // eventDetail.jsp의 hidden input name
    String content = request.getParameter("comment_content");

    // 서버 측에서도 로그인 여부 및 사용자 ID 확인 (세션에서 가져오는 것이 더 안전)
    String loggedInUserId = (String) session.getAttribute("id"); // 실제 세션 속성명 사용

    if (loggedInUserId == null || !loggedInUserId.equals(writer)) {
        out.print("error:login_required_or_mismatch");
        return;
    }

    if (event_idx == null || writer == null || content == null ||
        event_idx.trim().isEmpty() || writer.trim().isEmpty() || content.trim().isEmpty()) {
        out.print("error:missing_params");
        return;
    }

    EventAnswerDto dto = new EventAnswerDto();
    dto.setEvent_idx(event_idx);
    dto.setWriter(writer);
    dto.setContent(content);

    EventAnswerDao dao = new EventAnswerDao();
    boolean success = dao.addAnswer(dto);

    if (success) {
        out.print("success");
    } else {
        out.print("error:db_fail");
    }
    out.flush();
%>