<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.stream.Collectors" %>

<%
    String keyword = request.getParameter("keyword");
    if(keyword == null) keyword = "";

    PlaceDao dao = new PlaceDao();

    List<PlaceDto> allPlaces = dao.getRandomPlaces(100);
    List<PlaceDto> filtered;

    if(keyword.trim().isEmpty()) {
        filtered = allPlaces;
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

    <style>
         /* 카드 내용 영역 고정 높이 및 overflow 처리 */
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

    /* ✅ 이미지 고정 크기와 잘림 처리 */
    .card-img-top {
        width: 100%;
        height: 200px; /* 원하는 높이로 조절 가능 */
        object-fit: cover; /* 비율 유지하며 잘라냄 */
    }
        
    </style>

    <script type="text/javascript">
        $(function(){
            // 카드 클릭 시 해당 place_num을 읽어 상세 페이지로 이동
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

    <% if (filtered.isEmpty()) { %>
    <div class="alert alert-warning">검색 결과가 없습니다.</div>
    <% } else { %>
    <div class="row row-cols-1 row-cols-md-3 g-4 search">
        <% for (PlaceDto dto : filtered) {
            String[] img = dto.getPlace_img().split(",");
        %>
        <div class="col">
            <div class="card h-100">
                <input type="hidden" class="place_num" value="<%= dto.getPlace_num() %>">
                <img src="<%= img[0] %>" class="card-img-top" alt="<%= dto.getPlace_name() %>"
                     onerror="this.src='../image/places/경복궁.jpg'"> <!-- 이미지 로딩 실패 시 기본 이미지 -->
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