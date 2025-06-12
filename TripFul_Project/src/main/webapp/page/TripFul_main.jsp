<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, place.PlaceDto, place.PlaceDao, review.ReviewDao" %>
<%@ page import="board.BoardEventDto, board.BoardEventDao" %>

<%
    ReviewDao reviewDao = new ReviewDao();
    PlaceDao placeDao = new PlaceDao();
    BoardEventDao eventDao = new BoardEventDao();

    List<PlaceDto> placeList = placeDao.getRandomPlaces(30);
    List<HashMap<String, String>> overallLatestReviewList = reviewDao.getAllReviews();
    List<BoardEventDto> eventList = eventDao.getAllEvents();

    List<PlaceDto> hotPlaceList = placeDao.getHotPlacesByViews(5);
%>

<header class="hero position-relative overflow-hidden">
    <video autoplay muted loop playsinline class="bg-video">
        <source src="<%= request.getContextPath() %>/image/main_video.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay position-absolute w-100 h-100 bg-dark opacity-50"></div>
    <div class="hero-content position-absolute top-50 start-50 translate-middle text-center text-white">
        <h1 class="display-4 fw-bold mb-3">Welcome To Our Tripful</h1>
        <p class="lead">IT'S Travel review site</p>
    </div>
</header>

<div class="fade-in-left-on-scroll-container">
    <div id="animatedText" class="animate-target container my-5 bg-light text-center p-4 rounded-4 shadow-lg border border-2 border-primary">
        <h2 class="fw-semibold fs-4 text-primary mb-2">✈️ 이번 주 추천 여행지 📍</h2>
        <p class="text-secondary mb-0">Tripful이 엄선한 여행지로 떠나보세요! 새로운 장소가 여러분을 기다리고 있어요 🧳</p>
    </div>

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
                    // DAO는 그대로 사용하고, place_num을 String으로 변환하여 전달
                    HashMap<String, String> currentReview = reviewDao.getLatestReviewForPlace(String.valueOf(place.getPlace_num()));
                    String[] img = place.getPlace_img().split(",");
                    String content = place.getPlace_content();
                    String displayContent = content.length() > 300 ? content.substring(0, 300) + "..." : content;
            %>
            <div class="carousel-item <%= activeClass %>">
                <div class="d-flex justify-content-center py-4">
                    <div class="col-md-10">
                        <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden d-flex flex-md-row" style="min-height: 450px;">
                            <div class="carousel-image-container">
                                <img src="<%= img[0] %>" alt="<%= place.getPlace_name() %>" class="carousel-image">
                                <div class="image-overlay"></div>
                            </div>
                            <div class="card-body p-4 d-flex flex-column justify-content-between position-relative">
                                <div>
                                    <h5 class="card-title fw-bold text-primary mb-2"><%= place.getPlace_name() %></h5>
                                    <p class="text-muted small mb-3">태그: <%= place.getPlace_tag() %></p>
                                    <p class="text-dark"><%= displayContent %></p>
                                    <div class="bg-light p-3 mt-4 rounded-4 shadow-sm border-start border-5 border-info position-absolute w-90 carousel-review-card">
                                        <h6 class="fw-bold mb-2 text-dark"><%= place.getPlace_name() %>에 대한 여행자의 리뷰</h6>
                                        <%
                                            // currentReview가 null이 아니고, 비어있지 않은지 한 번 더 확인합니다.
                                            if (currentReview != null && !currentReview.isEmpty()) {
                                                String reviewAuthor = Optional.ofNullable(currentReview.get("author")).orElse("익명");
                                                String reviewText = Optional.ofNullable(currentReview.get("text")).orElse("리뷰 내용 없음");
                                        %>
                                        <p class="fst-italic mb-2 text-secondary">“<%= reviewText.length() > 100 ? reviewText.substring(0, 100) + "..." : reviewText %>”</p>
                                        <div class="d-flex justify-content-between align-items-end mt-2">
                                            <small class="text-muted">by <%= reviewAuthor %>님</small>
                                            <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= place.getPlace_num() %>"
                                               class="btn btn-outline-primary btn-sm">자세히 보기</a>
                                        </div>
                                        <% } else { %>
                                        <p class="fst-italic mb-2 text-secondary">“아직 등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
                                        <div class="d-flex justify-content-between align-items-end mt-2">
                                            <small class="text-muted">by Tripful</small>
                                            <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= place.getPlace_num() %>"
                                               class="btn btn-outline-primary btn-sm">자세히 보기</a>
                                        </div>
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
</div>

<div class="container my-5 fade-in-left-on-scroll">
    <h2 class="fw-semibold fs-4 text-center text-primary mb-4">🔥 핫플레이스 TOP 5 🌟</h2>
    <% if (hotPlaceList != null && !hotPlaceList.isEmpty()) { %>
    <% for (int i = 0; i < hotPlaceList.size(); i++) {
        PlaceDto hotPlace = hotPlaceList.get(i);
        String[] hotPlaceImg = hotPlace.getPlace_img().split(",");
        String hotPlaceContent = hotPlace.getPlace_content();
        String displayHotPlaceContent = hotPlaceContent.length() > 150 ? hotPlaceContent.substring(0, 150) + "..." : hotPlaceContent;
    %>
    <div class="row justify-content-center mb-4">
        <div class="col-md-10">
            <div class="card shadow-sm rounded-4 overflow-hidden hot-place-card">
                <div class="row g-0">
                    <div class="col-md-5">
                        <div class="hot-place-image-container">
                            <img src="<%= hotPlaceImg[0] %>" class="hot-place-image rounded-start" alt="<%= hotPlace.getPlace_name() %>">
                        </div>
                    </div>
                    <div class="col-md-7">
                        <%-- === 수정된 부분 시작 === --%>
                        <div class="card-body d-flex flex-column h-100">
                            <div>
                                <h5 class="card-title fw-bold text-dark"><%= i + 1 %>. <%= hotPlace.getPlace_name() %></h5>
                                <p class="card-text text-primary small"><%= hotPlace.getPlace_tag().replace(",", " #") %></p>
                                <p class="card-text text-secondary"><%= displayHotPlaceContent %></p>
                            </div>
                            <%-- mt-auto 클래스를 추가하여 버튼을 포함한 div를 아래로 밀어냄 --%>
                            <div class="text-end mt-auto">
                                <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= hotPlace.getPlace_num() %>" class="btn btn-outline-primary btn-sm">자세히 보기</a>
                            </div>
                        </div>
                        <%-- === 수정된 부분 끝 === --%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% } %>
    <% } else { %>
    <div class="col-12">
        <div class="alert alert-info text-center" role="alert">
            아직 인기 있는 관광지 정보가 없습니다.
        </div>
    </div>
    <% } %>
</div>

<div class="container my-5 fade-in-left-on-scroll">
    <div class="bg-white p-4 rounded-3 shadow-sm">
        <h5 class="fw-bold mb-3 text-primary">✍ 최신 여행자 리뷰</h5>
        <% if (overallLatestReviewList != null && !overallLatestReviewList.isEmpty()) {
            int displayCount = Math.min(overallLatestReviewList.size(), 3);
            for (int j = 0; j < displayCount; j++) {
                HashMap<String, String> review = overallLatestReviewList.get(j);
                String author = Optional.ofNullable(review.get("author")).orElse("익명");
                String text = Optional.ofNullable(review.get("text")).orElse("리뷰 내용 없음");
                String date = Optional.ofNullable(review.get("date")).orElse("").substring(0, 10);
                String placeNum = review.get("place_num");
                String placeName = reviewDao.getPlaceName(placeNum); // PlaceName을 가져오는 메서드는 place_num 기반으로 작동해야 합니다.
                double rating = 0.0;
                try {
                    rating = Double.parseDouble(review.get("rating"));
                } catch (Exception e) {}
        %>
        <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= placeNum %>" class="text-decoration-none text-dark">
            <div class="card mb-3 p-3 border-0 shadow-sm rounded-3 bg-light hover-shadow">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0 text-dark"><%= author %>
                        <% if (placeName != null && !placeName.isEmpty()) { %>
                        <small class="text-primary ms-2">(<%= placeName %>)</small>
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
                <p class="mb-2 text-secondary"><%= text.length() > 150 ? text.substring(0, 150) + "..." : text %></p>
                <small class="text-muted text-end">작성일: <%= date %></small>
            </div>
        </a>
        <% }} else { %>
        <p class="fst-italic mb-1 text-secondary">“아직 등록된 최신 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
        <small class="text-muted">- Tripful</small>
        <% } %>
        <div class="mt-3 text-end">
            <a href="index.jsp?main=Review/allReviews.jsp" class="btn btn-outline-primary btn-sm">리뷰 전체 보기</a>
        </div>
    </div>
</div>

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

<div id="introSection" class="animate-target container my-5">
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <h3 class="text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>

<style>
    /* 캐러셀 이미지 컨테이너 스타일 */
    .carousel-image-container {
        flex: 0 0 40%;
        position: relative;
        height: 450px;
        overflow: hidden;
    }

    /* 캐러셀 이미지 스타일 */
    .carousel-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        filter: brightness(90%);
        display: block;
    }

    /* 이미지 오버레이 스타일 */
    .image-overlay {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background-color: rgba(0, 0, 0, 0.25);
    }

    /* 리뷰 카드 위치 조정 */
    .carousel-review-card {
        /* top: 270px;  이전 top 속성 제거 */
        bottom: 1rem; /* 하단에서 1rem 위로 */
        left: 5%;
        width: 90%;
        /* padding-bottom: 3.5rem; /* 버튼 공간 확보 */
        transform: translateY(0); /* 초기 transform 제거 */
    }

    /* 핫플레이스 이미지 컨테이너 스타일 */
    .hot-place-image-container {
        max-height: 250px;
        overflow: hidden;

    }

    /* 핫플레이스 이미지 스타일 */
    .hot-place-image {
        width: 100%;
        height: 100%;
        object-fit: cover;
        display: block;
    }


    /* 미디어 쿼리를 이용한 반응형 디자인 */
    @media (max-width: 767.98px) {
        .card.flex-md-row {
            flex-direction: column !important;
        }
        .carousel-image-container {
            height: 250px;
            flex: 0 0 100%;
        }
        .carousel-review-card {
            position: static !important;
            width: 100% !important;
            margin-top: 1rem !important;
            padding-bottom: 1rem !important; /* 모바일에서 padding-bottom 초기화 */
        }
        .hot-place-image-container {
            max-height: 200px;

        }
    }
</style>

<script>
    document.addEventListener("DOMContentLoaded", () => {
        const existingAnimateTargets = document.querySelectorAll('.animate-target');
        const existingObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const el = entry.target;
                    el.style.visibility = 'visible';
                    el.classList.add('animate__animated', 'animate__fadeInUp');
                    el.addEventListener('animationend', () => {
                        el.classList.remove('animate__animated', 'animate__fadeInUp');
                    }, { once: true });
                    existingObserver.unobserve(el);
                }
            });
        }, { threshold: 0.2 });

        existingAnimateTargets.forEach(el => existingObserver.observe(el));

        const fadeInLeftContainerTargets = document.querySelectorAll('.fade-in-left-on-scroll-container');
        const fadeInLeftContainerObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-visible');
                    fadeInLeftContainerObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        fadeInLeftContainerTargets.forEach(el => fadeInLeftContainerObserver.observe(el));

        const fadeInLeftTargets = document.querySelectorAll('.fade-in-left-on-scroll');
        const fadeInLeftObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('is-visible');
                    fadeInLeftObserver.unobserve(entry.target);
                }
            });
        }, { threshold: 0.1 });

        fadeInLeftTargets.forEach(el => fadeInLeftObserver.observe(el));
    });
</script>