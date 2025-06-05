<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, place.PlaceDto, place.PlaceDao, review.ReviewDao" %>


<%

    ReviewDao reviewDao = new ReviewDao();
    PlaceDao placeDao = new PlaceDao();
    List<PlaceDto> placeList = placeDao.getRandomPlaces(5);
    List<HashMap<String, String>> overallLatestReviewList = reviewDao.getAllReviews();
%>

<!-- Hero Section -->
<header class="hero">
    <video autoplay muted loop playsinline class="bg-video">
        <source src="<%= request.getContextPath() %>/image/hero.mp4" type="video/mp4">
    </video>
    <div class="hero-content">
        <h1>Welcome To Our Tripful</h1>
        <h2>IT'S Travel review site</h2>
    </div>
</header>

<!-- Carousel Section -->
<div id="spotReviewCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
        <% if (placeList != null && !placeList.isEmpty()) {
            for (int i = 0; i < placeList.size(); i++) {
                PlaceDto place = placeList.get(i);
                String activeClass = (i == 0) ? "active" : "";
                HashMap<String, String> currentReview = reviewDao.getLatestReviewForPlace(place.getPlace_name());
        %>
        <div class="carousel-item <%= activeClass %>">
            <div class="d-flex justify-content-center py-4">
                <div class="col-md-10">
                    <!-- 카드 내부를 flex row로 배치 -->
                    <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden d-flex flex-row" style="min-height: 450px; position: relative;">
                        <!-- 이미지 영역 -->
                        <div style="flex: 0 0 40%; position: relative;">
                            <img src="<%= request.getContextPath() %>/save/<%= place.getPlace_img() %>"
                                 class="object-fit-cover h-100 w-100"
                                 alt="<%= place.getPlace_name() %>"
                                 style="filter: brightness(90%);">
                            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.25);"></div>
                        </div>

                        <!-- 텍스트 및 리뷰 영역 -->
                        <div class="card-body p-4 d-flex flex-column justify-content-between" style="flex: 1 1 60%; overflow-y: auto; position: relative;">
                            <div>
                                <h5 class="card-title fw-bold text-primary"><%= place.getPlace_name() %></h5>
                                <p class="card-text"><%= place.getPlace_content() %></p>
                                <p class="text-muted small">태그: <%= place.getPlace_tag()%> | 대륙: <%= place.getContinent_name() %></p>
                                <div class="bg-light p-4 mt-4 rounded-4 shadow-sm border-start border-5 border-warning">
                                    <h6 class="fw-bold mb-2"><%= place.getPlace_name()%>에 대한 여행자의 리뷰</h6>
                                    <% if (currentReview != null) {
                                        String reviewAuthor = Optional.ofNullable(currentReview.get("author")).orElse("익명");
                                        String reviewText = Optional.ofNullable(currentReview.get("text")).orElse("리뷰 내용 없음");
                                    %>
                                    <p class="fst-italic mb-2">
                                        “<%= reviewText.length() > 100 ? reviewText.substring(0, 100) + "..." : reviewText %>”
                                    </p>
                                    <small class="text-muted">by <%= reviewAuthor %>님</small>
                                    <% } else { %>
                                    <p class="fst-italic mb-2">“아직 등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
                                    <small class="text-muted">by Tripful</small>
                                    <% } %>
                                </div>
                            </div>
                            <!-- 우측 하단 버튼 -->
                            <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= place.getPlace_num() %>"
                               class="btn btn-outline-warning mt-2"
                               style="position: absolute; bottom: 16px; right: 16px;">
                                자세히 보기
                            </a>
                        </div>
                    </div> <!-- card -->
                </div>
            </div>
        </div>
        <% }} else { %>
        <div class="carousel-item active">
            <div class="d-flex justify-content-center py-4">
                <div class="col-md-10">
                    <div class="card border-0 shadow-lg h-100 rounded-4 text-center p-5">
                        <p class="fs-5 text-muted">아직 추천할 관광지 정보가 없습니다.</p>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<!-- Notice & Latest Reviews Section -->
<div class="container my-5">
    <h3 class="text-center mb-4">📰 공지사항 & 이벤트</h3>
    <a href="index.jsp?main=board/boardList.jsp&sub=event.jsp" class="alert alert-warning text-center fw-semibold fs-5 shadow-sm d-block text-decoration-none text-dark">
        📣 [이벤트] 여름맞이 특별 할인! 전 세계 인기 여행지 최대 30% OFF ~ 6월 30일까지
    </a>

    <div class="bg-light p-4 rounded-3 shadow-sm mt-3">
        <h5 class="fw-bold mb-3">✍ 최신 여행자 리뷰</h5>
        <% if (overallLatestReviewList != null && !overallLatestReviewList.isEmpty()) {
            int displayCount = Math.min(overallLatestReviewList.size(), 3);
            for (int j = 0; j < displayCount; j++) {
                HashMap<String, String> review = overallLatestReviewList.get(j);
                String author = Optional.ofNullable(review.get("author")).orElse("익명");
                String text = Optional.ofNullable(review.get("text")).orElse("리뷰 내용 없음");
                String date = Optional.ofNullable(review.get("date")).orElse("").substring(0, 10);
                String placeNum = review.get("place_num");
                String placeName = reviewDao.getPlaceName(placeNum);
                double rating = 0.0;
                try {
                    rating = Double.parseDouble(review.get("rating"));
                } catch (Exception e) {}
        %>
        <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= placeNum %>" class="text-decoration-none text-dark">
            <div class="card mb-3 p-3 border-0 shadow-sm rounded-3 bg-white hover-shadow" style="cursor: pointer;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0 text-primary"><%= author %>
                        <% if (placeName != null && !placeName.isEmpty()) { %>
                        <small class="text-muted ms-2">(<%= placeName %>)</small>
                        <% } %>
                    </h6>
                    <div class="text-warning">
                        <%
                            int full = (int) rating;
                            boolean half = (rating - full) >= 0.5;
                            int empty = 5 - full - (half ? 1 : 0);

                            for (int s = 0; s < full; s++) { %><i class="bi bi-star-fill"></i><% }
                        if (half) { %><i class="bi bi-star-half"></i><% }
                        for (int s = 0; s < empty; s++) { %><i class="bi bi-star"></i><% }
                    %>
                        <small class="text-muted ms-1">(<%= String.format("%.1f", rating) %>)</small>
                    </div>
                </div>
                <p class="mb-2"><%= text.length() > 150 ? text.substring(0, 150) + "..." : text %></p>
                <small class="text-muted text-end">작성일: <%= date %></small>
            </div>
        </a>
        <% }} else { %>
        <p class="fst-italic mb-1">“아직 등록된 최신 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
        <small class="text-muted">- Tripful</small>
        <% } %>
        <div class="mt-3 text-end">
            <a href="index.jsp?main=Review/allReviews.jsp" class="btn btn-outline-secondary btn-sm">리뷰 전체 보기</a>
        </div>
    </div>
</div>

<!-- 소개 Section -->
<div class="container my-5">
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <h3 class="text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>