<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="place.PlaceDao" %>
<%@ page import="place.PlaceDto" %>
<%@ page import="com.google.gson.Gson" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    PlaceDao dao = new PlaceDao();
    List<PlaceDto> allPlaces = dao.getRandomPlaces(100); // 모든 장소 가져오기

    String lowerKeyword = keyword.toLowerCase();

    if (lowerKeyword.trim().isEmpty()) {
        out.print("[]");
        return;
    }

    // 장소명 또는 국가명에 검색어가 포함되면 해당 항목 추가
    Set<String> suggestions = allPlaces.stream()
        .filter(dto -> dto.getPlace_name().toLowerCase().contains(lowerKeyword) ||
                       dto.getCountry_name().toLowerCase().contains(lowerKeyword))
        .flatMap(dto -> Stream.of(dto.getPlace_name(), dto.getCountry_name()))
        .filter(name -> name.toLowerCase().contains(lowerKeyword))
        .distinct()
        .limit(10)
        .collect(Collectors.toSet());

    // Gson을 이용해 JSON으로 변환
    Gson gson = new Gson();
    String json = gson.toJson(suggestions);

    out.print(json);
%>
