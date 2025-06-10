<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";
    String lowerKeyword = keyword.toLowerCase();

    PlaceDao dao = new PlaceDao();
    List<PlaceDto> allPlaces = dao.getRandomPlaces(100);

    // 각각 필터링
    List<PlaceDto> nameMatched = allPlaces.stream()
            .filter(dto -> dto.getPlace_name().toLowerCase().contains(lowerKeyword))
            .collect(Collectors.toList());

    List<PlaceDto> countryMatched = allPlaces.stream()
            .filter(dto -> dto.getCountry_name().toLowerCase().contains(lowerKeyword))
            .collect(Collectors.toList());

    List<PlaceDto> tagMatched = allPlaces.stream()
            .filter(dto -> dto.getPlace_tag().toLowerCase().contains(lowerKeyword))
            .collect(Collectors.toList());
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>검색 결과</title>

    <style>
        .card-text.content-snippet {
            height: 80px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 4;
            -webkit-box-orient: vertical;
        }

        .card {
            cursor: pointer;
            transition: box-shadow 0.3s ease;
        }

        .card:hover {
            box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        }

        .card-img-top {
            width: 100%;
            height: 200px;
            object-fit: cover;
        }
    </style>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script type="text/javascript">
        $(function(){
            $(document).on("click", ".card", function(){
                var num = $(this).find(".place_num").val();
                location.href = "index.jsp?main=place/detailPlace.jsp&place_num=" + num;
            });
        });
    </script>
</head>

<body class="bg-light">
<div class="container py-5">
    <h3 class="mb-4">'<%= keyword %>'에 대한 검색 결과</h3>

    <!-- 관광지 이름 검색 결과 -->
    <h4>📍 관광지 이름에 해당하는 결과</h4>
    <% if (nameMatched.isEmpty()) { %>
    <div class="alert alert-warning">관광지 이름 관련 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <% for (PlaceDto dto : nameMatched) {
            String[] img = dto.getPlace_img().split(",");
        %>
        <div class="col">
            <div class="card h-100">
                <input type="hidden" class="place_num" value="<%= dto.getPlace_num() %>">
                <img src="<%= img[0] %>" class="card-img-top" alt="<%= dto.getPlace_name() %>" onerror="this.src='../image/places/경복궁.jpg'">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= dto.getPlace_name() %></h5>
                    <p class="card-text text-muted mb-1">국가: <%= dto.getCountry_name() %></p>
                    <p class="card-text text-muted mb-1">조회수: <%= dto.getPlace_count() %></p>
                    <p class="card-text text-muted mb-2">좋아요: <%= dto.getPlace_like() %></p>
                    <p class="card-text text-muted mb-2">카테고리: <%= dto.getPlace_tag() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- 나라 이름 검색 결과 -->
    <h4 class="mt-5">🌍 나라 이름에 해당하는 결과</h4>
    <% if (countryMatched.isEmpty()) { %>
    <div class="alert alert-warning">나라 관련 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <% for (PlaceDto dto : countryMatched) {
            String[] img = dto.getPlace_img().split(",");
        %>
        <div class="col">
            <div class="card h-100">
                <input type="hidden" class="place_num" value="<%= dto.getPlace_num() %>">
                <img src="<%= img[0] %>" class="card-img-top" alt="<%= dto.getPlace_name() %>" onerror="this.src='../image/places/경복궁.jpg'">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= dto.getPlace_name() %></h5>
                    <p class="card-text text-muted mb-1">국가: <%= dto.getCountry_name() %></p>
                    <p class="card-text text-muted mb-1">조회수: <%= dto.getPlace_count() %></p>
                    <p class="card-text text-muted mb-2">좋아요: <%= dto.getPlace_like() %></p>
                    <p class="card-text text-muted mb-2">카테고리: <%= dto.getPlace_tag() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

    <!-- 태그 검색 결과 -->
    <h4 class="mt-5">🏷️ 태그에 해당하는 결과</h4>
    <% if (tagMatched.isEmpty()) { %>
    <div class="alert alert-warning">태그 관련 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4">
        <% for (PlaceDto dto : tagMatched) {
            String[] img = dto.getPlace_img().split(",");
        %>
        <div class="col">
            <div class="card h-100">
                <input type="hidden" class="place_num" value="<%= dto.getPlace_num() %>">
                <img src="<%= img[0] %>" class="card-img-top" alt="<%= dto.getPlace_name() %>" onerror="this.src='../image/places/경복궁.jpg'">
                <div class="card-body d-flex flex-column">
                    <h5 class="card-title"><%= dto.getPlace_name() %></h5>
                    <p class="card-text text-muted mb-1">국가: <%= dto.getCountry_name() %></p>
                    <p class="card-text text-muted mb-1">조회수: <%= dto.getPlace_count() %></p>
                    <p class="card-text text-muted mb-2">좋아요: <%= dto.getPlace_like() %></p>
                    <p class="card-text text-muted mb-2">카테고리: <%= dto.getPlace_tag() %></p>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>
</div>
</body>
</html>
