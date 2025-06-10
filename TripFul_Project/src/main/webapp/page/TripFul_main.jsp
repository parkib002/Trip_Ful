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

    List<PlaceDto> hotPlaceList = placeDao.getHotPlacesByViews(5);
%>

<header class="hero position-relative overflow-hidden">
    <video autoplay muted loop playsinline class="bg-video">
        <source src="<%= request.getContextPath() %>/image/hero.mp4" type="video/mp4">
    </video>
    <div class="hero-overlay position-absolute w-100 h-100 bg-dark opacity-50"></div>
    <%-- 여기서 animate-target 클래스를 제거했습니다. --%>
    <div class="hero-content position-absolute top-50 start-50 translate-middle text-center text-white">
        <h1 class="display-4 fw-bold mb-3">Welcome To Our Tripful</h1>
        <p class="lead">IT'S Travel review site</p>
    </div>
</header>

<%-- 캐러셀과 소개글을 묶는 컨테이너에 애니메이션 클래스 적용 --%>
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
                    HashMap<String, String> currentReview = reviewDao.getLatestReviewForPlace(place.getPlace_name());
                    String[] img = place.getPlace_img().split(",");
                    String content = place.getPlace_content();
                    String displayContent = content.length() > 300 ? content.substring(0, 300) + "..." : content;
            %>
            <div class="carousel-item <%= activeClass %>">
                <div class="d-flex justify-content-center py-4">
                    <div class="col-md-10">
                        <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden d-flex flex-md-row" style="min-height: 450px;">
                            <div class="carousel-image-wrapper">
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
                                        <% if (currentReview != null) {
                                            String reviewAuthor = Optional.ofNullable(currentReview.get("review_id")).orElse("익명");
                                            String reviewText = Optional.ofNullable(currentReview.get("review_content")).orElse("리뷰 내용 없음");
                                        %>
                                        <p class="fst-italic mb-2 text-secondary">“<%= reviewText.length() > 100 ? reviewText.substring(0, 100) + "..." : reviewText %>”</p>
                                        <small class="text-muted">by <%= reviewAuthor %>님</small>
                                        <% } else { %>
                                        <p class="fst-italic mb-2 text-secondary">“아직 등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
                                        <small class="text-muted">by Tripful</small>
                                        <% } %>
                                        <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= place.getPlace_num() %>"
                                           class="btn btn-outline-primary btn-sm mt-3" style="float: right;">자세히 보기</a>
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
</div> <%-- 캐러셀과 소개글을 묶는 div 끝 --%>


<div class="container my-5 fade-in-left-on-scroll"> <%-- 핫플레이스 전체를 묶는 div --%>
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
                        <img src="<%= hotPlaceImg[0] %>" class="img-fluid rounded-start h-100 object-fit-cover" alt="<%= hotPlace.getPlace_name() %>" style="max-height: 250px;">
                    </div>
                    <div class="col-md-7">
                        <div class="card-body d-flex flex-column justify-content-between">
                            <div>
                                <h5 class="card-title fw-bold text-dark"><%= i + 1 %>. <%= hotPlace.getPlace_name() %></h5>
                                <p class="card-text text-primary small"><%= hotPlace.getPlace_tag().replace(",", " #") %></p>
                                <p class="card-text text-secondary"><%= displayHotPlaceContent %></p>
                            </div>
                            <div class="text-end">
                                <a href="index.jsp?main=place/detailPlace.jsp&place_num=<%= hotPlace.getPlace_num() %>" class="btn btn-outline-primary btn-sm">자세히 보기</a>
                            </div>
                        </div>
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
</div> <%-- 핫플레이스 전체를 묶는 div 끝 --%>


<div class="container my-5 fade-in-left-on-scroll"> <%-- **여기에 fade-in-left-on-scroll 클래스 추가** --%>
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
                String placeName = reviewDao.getPlaceName(placeNum);
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

<script>

    document.addEventListener("DOMContentLoaded", () => {

// hero-content에서 animate-target 클래스가 제거되었으므로, 이 스크립트는 더 이상 필요 없습니다.

// const heroContent = document.querySelector('.hero-content');

// heroContent.classList.add('animate__animated', 'animate__fadeInDown');

// heroContent.style.visibility = 'visible';

// heroContent.addEventListener('animationend', () => {

// heroContent.classList.remove('animate__animated', 'animate__fadeInDown');

// }, { once: true });



// 기존 animate-target 처리 (hero-content 제외)

// hero-content에 animate-target이 없으므로, 이 셀렉터는 이제 hero-content를 포함하지 않습니다.

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

                    existingObserver.unobserve(el); // 한 번 애니메이션 후 관찰 중단

                }

            });

        }, { threshold: 0.2 }); // 애니메이션이 더 일찍 시작되도록 임계값 조정



        existingAnimateTargets.forEach(el => existingObserver.observe(el));



// 캐러셀과 소개글을 묶는 새로운 애니메이션 처리

        const fadeInLeftContainerTargets = document.querySelectorAll('.fade-in-left-on-scroll-container');

        const fadeInLeftContainerObserver = new IntersectionObserver((entries) => {

            entries.forEach(entry => {

                if (entry.isIntersecting) {

                    entry.target.classList.add('is-visible');

                    fadeInLeftContainerObserver.unobserve(entry.target); // 한 번 애니메이션 후 관찰 중단

                }

            });

        }, { threshold: 0.1 }); // 임계값 조정



        fadeInLeftContainerTargets.forEach(el => fadeInLeftContainerObserver.observe(el));



// 핫플레이스 전체를 묶는 애니메이션 처리 (기존 클래스 이름 사용)

        const fadeInLeftTargets = document.querySelectorAll('.fade-in-left-on-scroll');

        const fadeInLeftObserver = new IntersectionObserver((entries) => {

            entries.forEach(entry => {

                if (entry.isIntersecting) {

                    entry.target.classList.add('is-visible');

                    fadeInLeftObserver.unobserve(entry.target); // 한 번 애니메이션 후 관찰 중단

                }

            });

        }, { threshold: 0.1 }); // 임계값 조정



        fadeInLeftTargets.forEach(el => fadeInLeftObserver.observe(el));

    });

</script>