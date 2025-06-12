<%@page import="place.PlaceDao"%>
<%@page import="com.google.gson.JsonObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%
String place_num = request.getParameter("place_num");
String user_id = (String)session.getAttribute("id");
String action = request.getParameter("action"); // 추가 : "check" 또는 "toggle"

PlaceDao dao = new PlaceDao();
JsonObject ob = new JsonObject();

if (user_id == null) {
} else {
    if ("check".equals(action)) {
        // 좋아요 여부만 확인 (토글 아님)
        boolean liked = dao.hasUserLikedPlace(place_num, user_id);
        ob.addProperty("liked", liked);
    } else {
        // 토글 처리
        boolean alreadyLiked = dao.hasUserLikedPlace(place_num, user_id);
        if (alreadyLiked) {
            dao.deleteLike(place_num, user_id);
            ob.addProperty("liked", false);
        } else {
            dao.insertLike(place_num, user_id);
            ob.addProperty("liked", true);
        }
    }
    int newCount = dao.getLikeCount(place_num);
    ob.addProperty("place_like", newCount);
}

response.setContentType("application/json;charset=utf-8");
response.getWriter().write(ob.toString());
%>
