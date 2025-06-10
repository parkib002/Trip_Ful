<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="place.PlaceDao" %>
<%@ page import="place.PlaceDto" %>
<%@ page import="com.google.gson.Gson" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    PlaceDao dao = new PlaceDao();
    List<PlaceDto> allPlaces = dao.getRandomPlaces(100); // 장소 리스트

    String lowerKeyword = keyword.toLowerCase().trim();

    if (lowerKeyword.isEmpty()) {
        out.print("[]");
        return;
    }

    Set<String> suggestions = allPlaces.stream()
        .filter(dto ->
            dto.getPlace_name().toLowerCase().contains(lowerKeyword) ||
            dto.getCountry_name().toLowerCase().contains(lowerKeyword) ||
            (dto.getPlace_tag() != null && Arrays.stream(dto.getPlace_tag().split(","))
                .anyMatch(tag -> tag.trim().toLowerCase().contains(lowerKeyword)))
        )
        .flatMap(dto -> Stream.concat(
            Stream.of(dto.getPlace_name(), dto.getCountry_name()),
            dto.getPlace_tag() != null
                ? Arrays.stream(dto.getPlace_tag().split(","))
                    .map(String::trim)
                    .filter(tag -> tag.toLowerCase().contains(lowerKeyword))
                    .map(tag -> tag.startsWith("#") ? tag : "#" + tag)
                : Stream.empty()
        ))
        .map(String::trim)
        .filter(name -> name.toLowerCase().contains(lowerKeyword))
        .distinct()
        .limit(10)
        .collect(Collectors.toSet());

    Gson gson = new Gson();
    String json = gson.toJson(suggestions);
    out.print(json);
%>
