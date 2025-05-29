<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="board.MainPlaceDao" %>
<%@ page import="board.MainPlaceDto" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    MainPlaceDao dao = new MainPlaceDao();
    List<MainPlaceDto> allPlaces = dao.getRandomPlaces(100); // 모든 장소 가져오기

    String lowerKeyword = keyword.toLowerCase();

    if (lowerKeyword.trim().isEmpty()) {
        out.print("[]");
        return;
    }

    // 장소명 또는 국가명에 검색어가 포함되면 해당 항목 추가
    Set<String> suggestions = allPlaces.stream()
        .filter(dto -> dto.getPlaceName().toLowerCase().contains(lowerKeyword) ||
                       dto.getCountryName().toLowerCase().contains(lowerKeyword))
        .flatMap(dto -> Stream.of(dto.getPlaceName(), dto.getCountryName()))
        .filter(name -> name.toLowerCase().contains(lowerKeyword))
        .distinct()
        .limit(10)
        .collect(Collectors.toSet());

    // JSON 문자열 출력
    StringBuilder json = new StringBuilder("[");
    int index = 0;
    for (String suggestion : suggestions) {
        if (index++ > 0) json.append(",");
        json.append("\"").append(suggestion.replace("\"", "\\\"")).append("\"");
    }
    json.append("]");

    out.print(json.toString());
%>
