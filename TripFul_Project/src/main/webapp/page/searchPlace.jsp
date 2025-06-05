<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="place.PlaceDao" %>
<%@ page import="place.PlaceDto" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";

    PlaceDao dao = new PlaceDao();  // dao 선언, 생성 반드시 필요!

    List<PlaceDto> allPlaces = dao.getRandomPlaces(100);
    List<PlaceDto> filtered;

    if(keyword.trim().isEmpty()) {
        filtered = allPlaces; // 검색어 없으면 전체 출력
    } else {
        String lowerKeyword = keyword.toLowerCase();
        filtered = allPlaces.stream()
                .filter(dto -> dto.getPlace_name().toLowerCase().contains(lowerKeyword) ||
                        dto.getCountry_name().toLowerCase().contains(lowerKeyword) ||
                        dto.getPlace_tag().toLowerCase().contains(lowerKeyword))
                .collect(Collectors.toList());

    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

    <script type="text/javascript">
        $(function(){

            $(document).on("click", ".col", function(){
                // 현재 클릭한 카드 안에서 .place_num 값을 찾음
                var num = $(this).find(".place_num").val();

                location.href="index.jsp?main=place/detailPlace.jsp&place_num="+num;
            });
        });
    </script>
</head>

<body class="bg-light">
<div class="container py-5">
    <h3 class="mb-4">'<%= keyword %>'에 대한 검색 결과</h3>
    <% if (filtered.isEmpty()) { %>
    <div class="alert alert-warning">검색 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4 search">
        <% for (PlaceDto dto : filtered) { 
        String [] img=dto.getPlace_img().split(",");%>
        <div class="col">
        	<input type="hidden" class="place_num" value="<%=dto.getPlace_num()%>">
            <div class="card h-100">
                <img src="./<%= img[0] %>" class="card-img-top" alt="<%= dto.getPlace_name() %>">
                <div class="card-body">
                    <h5 class="card-title"><%= dto.getPlace_name() %></h5>
                    <p class="card-text text-muted">국가: <%= dto.getCountry_name() %></p>
                    <p class="card-text text-muted">조회수: <%= dto.getPlace_count() %></p>
                    <p class="card-text text-muted">좋아요: <%= dto.getPlace_like() %></p>
                    <p class="card-text"><%= dto.getPlace_content().length() > 100 ? dto.getPlace_content().substring(0, 100) + "..." : dto.getPlace_content() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
