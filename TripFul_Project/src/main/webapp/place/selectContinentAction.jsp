<%@page import="org.json.simple.JSONObject"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="java.util.Map"%>
<%@page import="place.PlaceDto"%>
<%@page import="java.util.List"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>

<%
  String continent = request.getParameter("continent");
  PlaceDao dao = new PlaceDao();
  List<PlaceDto> list = dao.selectContinentPlaces(continent);

  Map<String, JSONArray> map = new HashMap<>();
  for (PlaceDto dto : list) {
    JSONObject obj = new JSONObject();
    obj.put("place_name", dto.getPlace_name());
    obj.put("place_img", dto.getPlace_img());

    String country = dto.getCountry_name();
    map.computeIfAbsent(country, k -> new JSONArray()).add(obj);
  }

  JSONObject result = new JSONObject();
  for (String country : map.keySet()) {
    result.put(country, map.get(country));
  }

  out.print(result.toString());
%>