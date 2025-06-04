<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.EventAnswerDao" %>
<%@ page import="board.EventAnswerDto" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %> <%-- JsonObject 임포트 추가 --%>
<%
    String event_idx = request.getParameter("event_idx");
    String loggedInUserId = (String) session.getAttribute("id");

    // 페이징 파라미터 받기
    int start = 0;
    int count = 5; // 한 번에 5개씩 가져오도록 기본값 설정 (조정 가능)

    String startParam = request.getParameter("start");
    if (startParam != null) {
        try {
            start = Integer.parseInt(startParam);
        } catch (NumberFormatException e) {
            // start 파라미터가 숫자가 아니면 기본값 사용
        }
    }
    // count 파라미터도 필요하면 동일하게 받을 수 있습니다.

    List<EventAnswerDto> commentList = null;
    int totalComments = 0;
    JsonObject responseData = new JsonObject(); // 응답용 JsonObject

    if (event_idx != null && !event_idx.trim().isEmpty()) {
        EventAnswerDao dao = new EventAnswerDao();
        commentList = dao.getAnswersByEventIdxWithPaging(event_idx, loggedInUserId, start, count);
        totalComments = dao.getTotalAnswerCount(event_idx); // 전체 댓글 수 조회
        
        responseData.add("comments", new Gson().toJsonTree(commentList));
        responseData.addProperty("totalComments", totalComments);
        responseData.addProperty("start", start);
        responseData.addProperty("count", count);
    } else {
        // event_idx가 없는 경우 빈 데이터 또는 에러 상태 반환
        responseData.add("comments", new Gson().toJsonTree(new ArrayList<EventAnswerDto>()));
        responseData.addProperty("totalComments", 0);
        responseData.addProperty("start", 0);
        responseData.addProperty("count", 0);
    }

    out.print(responseData.toString());
    out.flush();
%>