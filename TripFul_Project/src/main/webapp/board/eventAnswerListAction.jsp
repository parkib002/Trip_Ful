<%@page import="java.util.ArrayList"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.EventAnswerDao" %>
<%@ page import="board.EventAnswerDto" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="com.google.gson.JsonObject" %>
<%
    // 1. 요청 파라미터 받기
    String event_idx = request.getParameter("event_idx");
    String loggedInUserId = (String) session.getAttribute("id");
    
    // ★ sort 파라미터 받기 (정렬 기준)
    String sort = request.getParameter("sort");
    if (sort == null || sort.isEmpty()) {
        sort = "latest"; // 기본값은 최신순
    }

    // 페이징 파라미터 받기
    int start = 0;
    int count = 5; 

    String startParam = request.getParameter("start");
    if (startParam != null) {
        try {
            start = Integer.parseInt(startParam);
        } catch (NumberFormatException e) {
            start = 0;
        }
    }

    List<EventAnswerDto> commentList = null;
    int totalComments = 0;
    JsonObject responseData = new JsonObject();

    if (event_idx != null && !event_idx.trim().isEmpty()) {
        EventAnswerDao dao = new EventAnswerDao();
        
        // ★ 기존 메소드 대신 새로운 getAnswers() 메소드 호출
        commentList = dao.getAnswers(event_idx, loggedInUserId, start, count, sort);
        
        totalComments = dao.getTotalAnswerCount(event_idx);
        
        responseData.add("comments", new Gson().toJsonTree(commentList));
        responseData.addProperty("totalComments", totalComments);
    } else {
        responseData.add("comments", new Gson().toJsonTree(new ArrayList<EventAnswerDto>()));
        responseData.addProperty("totalComments", 0);
    }

    out.print(responseData.toString());
    out.flush();
%>