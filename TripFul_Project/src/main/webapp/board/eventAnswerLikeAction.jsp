<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.EventAnswerDao" %>
<%@ page import="com.google.gson.JsonObject" %>
<%
    // 1. 요청 파라미터 받기
    String answer_idx = request.getParameter("answer_idx");

    // 2. 세션에서 로그인한 사용자 ID 가져오기
    //    실제 사용하는 세션 속성 이름으로 변경해야 합니다. (예: "userid", "memberId" 등)
    String loggedInUserId = (String) session.getAttribute("id"); 

    JsonObject responseJson = new JsonObject(); // JSON 응답 객체 생성

    // 3. 로그인 상태 확인
    if (loggedInUserId == null || loggedInUserId.trim().isEmpty()) {
        responseJson.addProperty("status", "error");
        responseJson.addProperty("message", "login_required"); // "로그인이 필요합니다."
        out.print(responseJson.toString());
        out.flush();
        return;
    }

    // 4. 댓글 ID 파라미터 유효성 검사
    if (answer_idx == null || answer_idx.trim().isEmpty()) {
        responseJson.addProperty("status", "error");
        responseJson.addProperty("message", "missing_id"); // "댓글 ID가 누락되었습니다."
        out.print(responseJson.toString());
        out.flush();
        return;
    }

    EventAnswerDao dao = new EventAnswerDao();
    String userActionStatus = "error"; // DAO 작업 결과 기본값

    try {
        // 5. DAO의 toggleLike 메소드 호출하여 좋아요 상태 변경
        userActionStatus = dao.toggleLike(answer_idx, loggedInUserId);

        if (!"error".equals(userActionStatus)) {
            // 6. 좋아요 처리 성공 시, 업데이트된 좋아요 수 가져오기
            int newLikeCount = dao.getLikeCount(answer_idx);

            responseJson.addProperty("status", "success");
            responseJson.addProperty("likeCount", newLikeCount);
            responseJson.addProperty("userAction", userActionStatus); // "liked" 또는 "unliked"
        } else {
            // toggleLike 메소드가 "error"를 반환한 경우 (DB 처리 중 문제 발생)
            responseJson.addProperty("status", "error");
            responseJson.addProperty("message", "db_process_failed"); // "데이터베이스 처리 중 오류가 발생했습니다."
        }
    } catch (Exception e) {
        // 기타 예기치 않은 예외 발생 시
        e.printStackTrace(); // 서버 로그에 예외 기록
        responseJson.addProperty("status", "error");
        responseJson.addProperty("message", "server_exception"); // "서버 내부 오류가 발생했습니다."
    }

    // 7. 최종 JSON 응답 출력
    out.print(responseJson.toString());
    out.flush();
%>