<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="place.PlaceDao, place.PlaceDto" %>


<%
    // DAO에서 5개 랜덤 장소 가져오기
    PlaceDao dao = new PlaceDao();
    List<PlaceDto> placeList = dao.getRandomPlaces(5);
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추천 관광지</title>

</head>
<body>

<header class="hero text-center p-4 bg-light">
    <h1>Welcome To Our Tripful</h1>
    <h2>IT'S Travel review site</h2>
</header>

<div id="spotReviewCarousel" class="carousel slide" data-bs-ride="carousel">

    <!-- 인디케이터 추가 -->
    <div class="carousel-indicators">
        <% for (int i = 0; i < placeList.size(); i++) {
            String activeClass = (i == 0) ? "active" : "";
        %>
        <button type="button" data-bs-target="#spotReviewCarousel" data-bs-slide-to="<%=i%>" class="<%=activeClass%>" aria-current="<%= (i == 0) ? "true" : "false" %>" aria-label="슬라이드 <%=i+1%>"></button>
        <% } %>
    </div>

    <div class="carousel-inner">
        <% for (int i = 0; i < placeList.size(); i++) {
            PlaceDto place = placeList.get(i);
            String activeClass = (i == 0) ? "active" : "";
        %>
        <div class="carousel-item <%= activeClass %>">
            <div class="row align-items-center gx-5 py-4 bg-white shadow rounded-4 mx-2">
                <!-- 관광지 카드 -->
                <div class="col-md-6">
                    <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden">
                        <div class="position-relative">
                            <img src="<%=request.getContextPath()%>/images/<%= place.getPlace_img() %>"
                                 class="card-img-top object-fit-cover"
                                 style="height: 450px; width: 100%; filter: brightness(90%);"
                                 alt="<%= place.getPlace_name() %>">
                            <div class="position-absolute top-0 start-0 w-100 h-100 bg-dark bg-opacity-25"></div>
                        </div>
                        <div class="card-body p-4">
                            <h5 class="card-title fw-bold text-primary"><%= place.getPlace_name() %></h5>
                            <p class="card-text"><%= place.getPlace_content() %></p>
                            <p class="text-muted small">태그: <%= place.getPlace_tag() %> | 대륙: <%= place.getContinent_name() %></p>
                            <a href="#" class="btn btn-outline-warning mt-2">자세히 보기</a>
                        </div>
                    </div>
                </div>
                <!-- 리뷰 -->
                <div class="col-md-6">
                    <div class="bg-light p-4 rounded-4 shadow-sm border-start border-5 border-warning h-100 d-flex flex-column justify-content-center">
                        <h6 class="fw-bold mb-2"><%= place.getPlace_name() %>에 대한 여행자의 리뷰</h6>
                        <p class="fst-italic mb-2">“정말 인상적인 장소였습니다. 추천해요!”</p>
                        <small class="text-muted">by 여행자</small>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<%--<!-- ✅ 2. 실시간 인기 관광지 -->--%>
<%--<div class="container my-5">--%>
<%--    <h3 class="text-center mb-4">🔥 실시간 인기 관광지</h3>--%>
<%--    <div class="row row-cols-1 row-cols-md-3 g-4">--%>
<%--        <% for(MainPlaceDto place : dao.getPopularPlaces()) { %>--%>
<%--        <div class="col">--%>
<%--            <div class="card h-100 shadow-sm">--%>
<%--                <img src="<%=request.getContextPath()%>/images/<%= place.getPlaceImg() %>" class="card-img-top" style="height: 200px; object-fit: cover;">--%>
<%--                <div class="card-body">--%>
<%--                    <h5 class="card-title"><%= place.getPlaceName() %></h5>--%>
<%--                    <p class="card-text text-truncate"><%= place.getPlaceContent() %></p>--%>
<%--                </div>--%>
<%--            </div>--%>
<%--        </div>--%>
<%--        <% } %>--%>
<%--    </div>--%>
<%--</div>--%>

<!-- ✅ 3. 공지사항 / 이벤트 / 최신 리뷰 -->
<div class="container my-5">
    <h3 class="text-center mb-4">📰 공지사항 & 이벤트</h3>
    <div class="alert alert-warning text-center fw-semibold fs-5 shadow-sm">
        📣 [이벤트] 여름맞이 특별 할인! 전 세계 인기 여행지 최대 30% OFF ~ 6월 30일까지
    </div>
    <div class="bg-light p-4 rounded-3 shadow-sm mt-3">
        <h5 class="fw-bold mb-2">✍ 최신 여행자 리뷰</h5>
        <p class="fst-italic mb-1">“오사카 도톤보리는 야경이 정말 예뻐요! 쇼핑도 재밌고요 😊”</p>
        <small class="text-muted">- 여행자9912님</small>
    </di

        v>
</div>

<!-- ✅ 4. Tripful 소개 -->
<div class="container my-5">
    <h3 class="text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>
    <!-- Bootstrap JS CDN -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const carousel = document.querySelector('#spotReviewCarousel');
        const bsCarousel = new bootstrap.Carousel(carousel, {
            interval: 8000,
            ride: 'carousel'
        });

        // 클릭 시 수동 슬라이드 전환
        carousel.addEventListener('click', function () {
            bsCarousel.next();
        });
    });
</script>

</body>
</html>
