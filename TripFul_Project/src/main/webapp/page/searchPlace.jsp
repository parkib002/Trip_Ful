<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="board.MainPlaceDao" %>
<%@ page import="board.MainPlaceDto" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";

    MainPlaceDao dao = new MainPlaceDao();  // dao 선언, 생성 반드시 필요!

    List<MainPlaceDto> allPlaces = dao.getRandomPlaces(100);
    List<MainPlaceDto> filtered;

    if(keyword.trim().isEmpty()) {
        filtered = allPlaces; // 검색어 없으면 전체 출력
    } else {
        String lowerKeyword = keyword.toLowerCase();
        filtered = allPlaces.stream()
                .filter(dto -> dto.getPlaceName().toLowerCase().contains(lowerKeyword) ||
                        dto.getCountryName().toLowerCase().contains(lowerKeyword))
                .collect(Collectors.toList());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container py-5">
    <h3 class="mb-4">'<%= keyword %>'에 대한 검색 결과</h3>
    <% if (filtered.isEmpty()) { %>
    <div class="alert alert-warning">검색 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <% for (MainPlaceDto dto : filtered) { %>
        <div class="col">
            <div class="card h-100">
                <img src="<%= dto.getPlaceImg() %>" class="card-img-top" alt="<%= dto.getPlaceName() %>">
                <div class="card-body">
                    <h5 class="card-title"><%= dto.getPlaceName() %></h5>
                    <p class="card-text text-muted">국가: <%= dto.getCountryName() %></p>
                    <p class="card-text"><%= dto.getPlaceContent().length() > 100 ? dto.getPlaceContent().substring(0, 100) + "..." : dto.getPlaceContent() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
