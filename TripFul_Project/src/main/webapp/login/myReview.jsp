<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="login.MyPageDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    String userId = request.getParameter("id");
    String continent = request.getParameter("continent");

    MyPageDao mdao = new MyPageDao();
    List<HashMap<String, String>> myReviews = null;

    myReviews = mdao.getMyReview(continent, userId);

    JSONObject obj = new JSONObject();
    JSONArray arr = new JSONArray();

    if (myReviews != null) {
        for (HashMap<String, String> review : myReviews) {
            JSONObject reviewObj = new JSONObject();
            
            reviewObj.put("review_idx", review.get("review_idx"));
            reviewObj.put("review_id", review.get("review_id"));
            reviewObj.put("review_content", review.get("review_content"));
            reviewObj.put("review_img", review.get("review_img"));
            reviewObj.put("review_star", review.get("review_star"));
            reviewObj.put("review_writeday", review.get("review_writeday"));
            
            arr.add(reviewObj);
        }
    }
    obj.put("reviews", arr);

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
    
%>
<%=obj.toString()%>