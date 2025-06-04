<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.EventAnswerDao" %>
<%@ page import="board.EventAnswerDto" %>
<%
    String answer_idx = request.getParameter("comment_idx");

    // 로그인 사용자 ID 및 관리자 여부 확인
    String loggedInUserId = (String) session.getAttribute("id");
    String adminSessionValue = (String) session.getAttribute("loginok");
    boolean isAdmin = "admin".equals(adminSessionValue);

    if (loggedInUserId == null) {
        out.print("error:login_required");
        return;
    }
    if (answer_idx == null || answer_idx.trim().isEmpty()) {
        out.print("error:missing_id");
        return;
    }

    EventAnswerDao dao = new EventAnswerDao();
    boolean success = false;

    if (isAdmin) { // 관리자는 모든 댓글 삭제 가능
        success = dao.deleteAnswerByAdmin(answer_idx);
    } else {
        // 일반 사용자는 본인 댓글만 삭제 가능
        // DAO에서 writer를 함께 받아 삭제하거나, 여기서 댓글 정보를 조회하여 작성자 비교 후 삭제
        // 여기서는 EventAnswerDao.deleteAnswer(answer_idx, writer_id)를 호출한다고 가정
        success = dao.deleteAnswer(answer_idx, loggedInUserId);
    }

    if (success) {
        out.print("success");
    } else {
        out.print("error:db_fail_or_unauthorized");
    }
    out.flush();
%>