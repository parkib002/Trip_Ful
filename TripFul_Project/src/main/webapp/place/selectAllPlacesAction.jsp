<%@page import="review.ReviewDao"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="place.PlaceDto"%>
<%@page import="java.util.List"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
PlaceDao dao = new PlaceDao();
ReviewDao rdao = new ReviewDao();
List<PlaceDto> list = dao.selectAllPlaces();

JSONArray arr = new JSONArray();

for (PlaceDto dto : list) {
    JSONObject obj = new JSONObject();
    obj.put("place_num", dto.getPlace_num());
    obj.put("place_name", dto.getPlace_name());
    obj.put("place_img", dto.getPlace_img());

    double avg = rdao.getAverageRatingByPlace(dto.getPlace_num());
    obj.put("avg_rating", avg); // -1.0이면 '평점 없음' 처리
    arr.add(obj);
}

out.print(arr.toString());
%>
