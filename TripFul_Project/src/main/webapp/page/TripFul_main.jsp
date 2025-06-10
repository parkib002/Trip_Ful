<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, place.PlaceDto, place.PlaceDao, review.ReviewDao" %>
<%@ page import="board.BoardEventDto, board.BoardEventDao" %>

<%
    ReviewDao reviewDao = new ReviewDao();
    PlaceDao placeDao = new PlaceDao();
    BoardEventDao eventDao = new BoardEventDao();

    List<PlaceDto> placeList = placeDao.getRandomPlaces(5);
    List<HashMap<String, String>> overallLatestReviewList = reviewDao.getAllReviews();
    List<BoardEventDto> eventList = eventDao.getAllEvents();
%>

<!-- Hero Section -->
<header class="hero">
    <video autoplay muted loop playsinline class="bg-video">
        <source src="<%= request.getContextPath() %>/image/hero.mp4" type="video/mp4">
    </video>
    <div class="hero-content animate-target">
        <h1>Welcome To Our Tripful</h1>
        <h2>IT'S Travel review site</h2>
    </div>
</header>

<!-- 추천 여행지 소개 문구 Section -->
<div id="animatedText" class="animate-target container my-5 bg-warning-subtle text-center p-4 rounded-4 shadow-lg border border-warning">
    <h2 class="fw-semibold fs-4 text-warning-emphasis mb-2">✈️ 이번 주 추천 여행지 📍</h2>
    <p class="text-warning-emphasis mb-0">Tripful이 엄선한 여행지로 떠나보세요! 새로운 장소가 여러분을 기다리고 있어요 🧳</p>
</div>

<!-- Carousel Section -->
<div id="spotReviewCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-indicators">
        <% if (placeList != null && !placeList.isEmpty()) {
            for (int i = 0; i < placeList.size(); i++) {
                String activeClass = (i == 0) ? "active" : "";
        %>
        <button type="button" data-bs-target="#spotReviewCarousel" data-bs-slide-to="<%= i %>" class="<%= activeClass %>" aria-current="<%= i == 0 %>" aria-label="Slide <%= i + 1 %>"></button>
        <% }} %>
    </div>
    <div class="carousel-inner">
        <% if (placeList != null && !placeList.isEmpty()) {
            for (int i = 0; i < placeList.size(); i++) {
                PlaceDto place = placeList.get(i);
                String activeClass = (i == 0) ? "active" : "";
                HashMap<String, String> currentReview = reviewDao.getLatestReviewForPlace(place.getPlace_name());
                String[] img = place.getPlace_img().split(",");
                String content = place.getPlace_content();
                String displayContent = content.length() > 300 ? content.substring(0, 300) + "..." : content;
        %>
        <div class="carousel-item <%= activeClass %>">
            <div class="d-flex justify-content-center py-4">
                <div class="col-md-10">
                    <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden d-flex flex-row" style="min-height: 450px; position: relative;">
                        <div style="flex: 0 0 40%; position: relative; height: 450px;">
                            <img src="<%= img[0] %>" alt="<%= place.getPlace_name() %>"
                                 style="width: 100%; height: 100%; object-fit: cover; filter: brightness(90%); display: block;">
                            <div style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0,0,0,0.25);"></div>
                        </div>
                        <div class="card-body p-4 d-flex flex-column justify-content-between" style="flex: 1 1 60%; overflow-y: auto; position: relative;">
                            <div>
                                <h5 class="card-title fw-bold text-primary"><%= place.getPlace_name() %></h5>
                                <p class="text-muted small">태그: <%= place.getPlace_tag() %></p>
                                <div><%= displayContent %></div>
                                <div class="bg-light p-3 rounded-4 shadow-sm border-start border-5 border-warning" style="position: absolute; top: 270px; width: 90%;">
                                    <h6 class="fw-bold mb-2"><%= place.getPlace_name() %>에 대한 여행자의 리뷰</h6>
                                    <% if (currentReview != null) {
                                        String reviewAuthor = Optional.ofNullable(currentReview.get("author")).orElse("익명");
                                        String reviewText = Optional.ofNullable(currentReview.get("text")).orElse("리뷰 내용 없음");
                                    %>
                                    <p class="fst-italic mb-2">“<%= reviewText.length() > 100 ? reviewText.substring(0, 100) + "..." : reviewText %>”</p>
                                    <small class="text-muted">by <%= reviewAuthor %>님</small>
                                    <% } else { %>
                                    <p class="fst-italic mb-2">“아직 등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
                                    <small class="text-muted">by Tripful</small>
                                    <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= place.getPlace_num() %>"
                                       class="btn btn-outline-warning mb-1" style="float: right;">자세히 보기</a>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
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

<!-- 이벤트 Section -->
<div class="container my-5">
    <div id="eventCarousel" class="carousel slide animate-target" data-bs-ride="carousel">
        <div class="carousel-inner rounded-3 shadow-sm">
            <% if (eventList != null && !eventList.isEmpty()) {
                for (int i = 0; i < eventList.size(); i++) {
                    BoardEventDto event = eventList.get(i);
                    String activeClass = (i == 0) ? "active" : "";
            %>
            <div class="carousel-item <%= activeClass %>" data-bs-interval="5000">
                <a href="index.jsp?main=board/boardList.jsp&sub=eventDetail.jsp&idx=<%= event.getEvent_idx() %>"
                   class="alert alert-warning text-center fw-semibold fs-5 d-block text-decoration-none text-dark mb-0">
                    📣 [이벤트] <%= event.getEvent_title() %>
                </a>
            </div>
            <% }} else { %>
            <div class="carousel-item active">
                <div class="alert alert-secondary text-center fs-5 d-block mb-0">진행중인 이벤트가 없습니다.</div>
            </div>
            <% } %>
        </div>

        <% if (eventList != null && eventList.size() > 1) { %>
        <button class="carousel-control-prev" type="button" data-bs-target="#eventCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon event-carousel-control" aria-hidden="true" style="filter: invert(1);"></span>
            <span class="visually-hidden">Previous</span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#eventCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon event-carousel-control" aria-hidden="true" style="filter: invert(1);"></span>
            <span class="visually-hidden">Next</span>
        </button>
        <% } %>
    </div>
</div>

<!-- 사이트 소개 Section -->
<div id="introSection" class="animate-target container my-5">
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <h3 class="text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>

<!-- Animate.css -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"/>

<!-- 숨김 스타일 추가 -->
<style>
    .animate-target {
        visibility: hidden;
    }
</style>

<!-- 애니메이션 처리 스크립트 -->
<script>
    document.addEventListener("DOMContentLoaded", () => {
        const heroContent = document.querySelector('.hero-content');
        heroContent.classList.add('animate__animated', 'animate__fadeInDown');
        heroContent.style.visibility = 'visible';
        heroContent.addEventListener('animationend', () => {
            heroContent.classList.remove('animate__animated', 'animate__fadeInDown');
        }, { once: true });

        const targets = document.querySelectorAll('.animate-target:not(.hero-content)');

        let lastScrollY = window.scrollY;

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const currentScrollY = window.scrollY;
                    const isScrollingDown = currentScrollY > lastScrollY;
                    lastScrollY = currentScrollY;

                    const el = entry.target;
                    el.style.visibility = 'visible';

                    // 방향에 따라 애니메이션 다르게 설정
                    const animationClass = isScrollingDown ? 'animate__fadeInUp' : 'animate__fadeInDown';
                    el.classList.add('animate__animated', animationClass);

                    el.addEventListener('animationend', () => {
                        el.classList.remove('animate__animated', animationClass);
                    }, { once: true });
                } else {
                    // 다시 안 보일 때는 숨김
                    entry.target.style.visibility = 'hidden';
                }
            });
        }, { threshold: 0.5 });

        targets.forEach(el => observer.observe(el));
    });
</script>

