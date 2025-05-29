<%@page import="org.json.simple.JSONObject"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="place.PlaceDto"%>
<%@page import="java.util.List"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%
PlaceDao dao = new PlaceDao();
List<PlaceDto> allPlaces = dao.selectAllPlaces(); // 모든 관광지 가져오는 메서드 작성 필요
JSONArray jsonArray = new JSONArray();

for (PlaceDto place : allPlaces) {
    JSONObject obj = new JSONObject();
    obj.put("place_num", place.getPlace_num());
    obj.put("place_name", place.getPlace_name());
    obj.put("place_img", place.getPlace_img());
    obj.put("country", place.getCountry_name());
    jsonArray.add(obj);
}

out.print(jsonArray.toString());
%>
