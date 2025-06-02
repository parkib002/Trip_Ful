<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="main.MainPlaceDao, main.MainPlaceDto" %>
<%@ page import="review.ReviewDao" %>


<%
    MainPlaceDao mainPlaceDao = new MainPlaceDao();
    ReviewDao reviewDao = new ReviewDao();

    // MainPlaceDao에서 5개 랜덤 장소 가져오기
    List<MainPlaceDto> placeList = mainPlaceDao.getRandomPlaces(5);

    // 메인 하단 '최신 여행자 리뷰' 섹션용: 모든 리뷰를 최신순으로 가져옵니다.
    // 여기서는 최대 3개만 표시할 것이므로, 전체를 가져온 후 JSP에서 필요한 만큼만 사용합니다.
    List<HashMap<String, String>> overallLatestReviewList = reviewDao.getAllReviews();
%>
<header class="hero">
    <video autoplay muted loop playsinline class="bg-video">
        <source src="<%=request.getContextPath()%>/image/hero.mp4" type="video/mp4">
    </video>
    <div class="hero-content">
        <h1>Welcome To Our Tripful</h1>
        <h2>IT'S Travel review site</h2>
    </div>
</header>

<div id="spotReviewCarousel" class="carousel slide" data-bs-ride="carousel">
    <div class="carousel-inner">
        <% if (placeList != null && !placeList.isEmpty()) { %>
        <% for (int i = 0; i < placeList.size(); i++) {
            MainPlaceDto place = placeList.get(i);
            String activeClass = (i == 0) ? "active" : "";

            // 해당 장소 (place.getPlaceNum())의 최신 리뷰 1개만 가져옵니다.
            HashMap<String, String> currentPlaceLatestReview = reviewDao.getLatestReviewForPlace(place.getPlaceNum());

            // 디버깅 용 (Tomcat 콘솔에서 확인 가능)
            System.out.println("DEBUG: 캐러셀 아이템 - 장소: " + place.getPlaceName() + " (Place_num: " + place.getPlaceNum() + ")");
            if (currentPlaceLatestReview != null) {
                System.out.println("DEBUG:   - 이 장소에 대한 리뷰 발견: 작성자=" + currentPlaceLatestReview.get("author") + ", 내용: " + currentPlaceLatestReview.get("text"));
            } else {
                System.out.println("DEBUG:   - 이 장소에 대한 리뷰를 찾을 수 없습니다.");
            }
        %>
        <div class="carousel-item <%= activeClass %>">
            <div class="d-flex justify-content-center py-4">
                <div class="col-md-10">
                    <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden">
                        <div class="position-relative">
                            <img src="<%=request.getContextPath()%>/images/<%= place.getPlaceImg() %>"
                                 class="card-img-top object-fit-cover"
                                 style="height: 450px; width: 100%; filter: brightness(90%);"
                                 alt="<%= place.getPlaceName() %>">
                            <div class="position-absolute top-0 start-0 w-100 h-100 bg-dark bg-opacity-25"></div>
                        </div>
                        <div class="card-body p-4">
                            <h5 class="card-title fw-bold text-primary"><%= place.getPlaceName() %></h5>
                            <p class="card-text"><%= place.getPlaceContent() %></p>
                            <p class="text-muted small">태그: <%= place.getPlaceTag() %> | 대륙: <%= place.getContinentName() %></p>
                            <a href="index.jsp?main=place/detailPlace.jsp?place_num=<%= place.getPlaceNum() %>" class="btn btn-outline-warning mt-2">자세히 보기</a>

                            <div class="bg-light p-4 mt-4 rounded-4 shadow-sm border-start border-5 border-warning">
                                <h6 class="fw-bold mb-2"><%= place.getPlaceName() %>에 대한 여행자의 리뷰</h6>
                                <% if (currentPlaceLatestReview != null) {
                                    String reviewAuthor = currentPlaceLatestReview.get("author") != null ? currentPlaceLatestReview.get("author") : "익명";
                                    String reviewContent = currentPlaceLatestReview.get("text") != null ? currentPlaceLatestReview.get("text") : "리뷰 내용 없음";
                                %>
                                <p class="fst-italic mb-2">
                                    “<%= reviewContent.length() > 100 ? reviewContent.substring(0, 100) + "..." : reviewContent %>”
                                </p>
                                <small class="text-muted">by <%= reviewAuthor %>님</small>
                                <% } else { %>
                                <p class="fst-italic mb-2">“아직 등록된 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
                                <small class="text-muted">by Tripful</small>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
        <% } else { %>
        <div class="carousel-item active">
            <div class="d-flex justify-content-center py-4">
                <div class="col-md-10">
                    <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden text-center p-5">
                        <p class="fs-5 text-muted">아직 추천할 관광지 정보가 없습니다.</p>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<div class="container my-5">
    <h3 class="text-center mb-4">📰 공지사항 & 이벤트</h3>
    <a href="index.jsp?main=board/event.jsp" class="alert alert-warning text-center fw-semibold fs-5 shadow-sm d-block text-decoration-none text-dark">
        📣 [이벤트] 여름맞이 특별 할인! 전 세계 인기 여행지 최대 30% OFF ~ 6월 30일까지
    </a>

    <div class="bg-light p-4 rounded-3 shadow-sm mt-3">
        <h5 class="fw-bold mb-3">✍ 최신 여행자 리뷰</h5>
        <% if (overallLatestReviewList != null && !overallLatestReviewList.isEmpty()) {
            // 최대 3개의 리뷰만 표시합니다.
            int displayCount = Math.min(overallLatestReviewList.size(), 3);
            for (int j = 0; j < displayCount; j++) {
                HashMap<String, String> review = overallLatestReviewList.get(j);
                String reviewAuthor = review.get("author") != null ? review.get("author") : "익명";
                String reviewText = review.get("text") != null ? review.get("text") : "리뷰 내용 없음";
                String reviewRatingStr = review.get("rating");
                double reviewRating = 0.0;
                try {
                    reviewRating = Double.parseDouble(reviewRatingStr);
                } catch (NumberFormatException e) {
                    // 숫자 변환 실패 시 기본값 0.0 유지
                }
                String reviewDate = review.get("date") != null ? review.get("date").substring(0, 10) : ""; // 날짜만 자르기
                String reviewPlaceNum = review.get("place_num");
                String reviewPlaceName = "";
                if (reviewPlaceNum != null && !reviewPlaceNum.trim().isEmpty()) {
                    reviewPlaceName = reviewDao.getPlaceName(reviewPlaceNum);
                }
        %>
        <a href="index.jsp?main=place/detailPlace.jsp?place_num=<%= reviewPlaceNum %>"
           class="text-decoration-none text-dark">
            <div class="card mb-3 p-3 border-0 shadow-sm rounded-3 bg-white hover-shadow" style="cursor: pointer;">
                <div class="d-flex justify-content-between align-items-center mb-2">
                    <h6 class="mb-0 text-primary">
                        <%= reviewAuthor %>
                        <% if (!reviewPlaceName.isEmpty()) { %>
                        <small class="text-muted ms-2">(<%= reviewPlaceName %>)</small>
                        <% } %>
                    </h6>
                    <div class="text-warning">
                        <%
                            int fullStars = (int) reviewRating;
                            boolean hasHalfStar = (reviewRating - fullStars) >= 0.5;
                            int emptyStars = 5 - fullStars - (hasHalfStar ? 1 : 0);

                            // 꽉 찬 별
                            for (int k = 0; k < fullStars; k++) {
                        %>
                        <i class="bi bi-star-fill"></i>
                        <%
                            }
                            if (hasHalfStar) {
                        %>
                        <i class="bi bi-star-half"></i>
                        <%
                            }
                            for (int k = 0; k < emptyStars; k++) {
                        %>
                        <i class="bi bi-star"></i>
                        <%
                            }
                        %>
                        <small class="text-muted ms-1">(<%= String.format("%.1f", reviewRating) %>)</small>
                    </div>
                </div>
                <p class="mb-2"><%= reviewText.length() > 150 ? reviewText.substring(0, 150) + "..." : reviewText %></p>
                <small class="text-muted text-end">작성일: <%= reviewDate %></small>
            </div>
        </a>

        <%
            }
        } else {
        %>
        <p class="fst-italic mb-1">“아직 등록된 최신 리뷰가 없습니다. 첫 리뷰를 작성해보세요!”</p>
        <small class="text-muted">- Tripful</small>
        <% } %>
        <div class="mt-3 text-end">
            <a href="index.jsp?main=Review/allReviews.jsp" class="btn btn-outline-secondary btn-sm">리뷰 전체 보기</a>
        </div>
    </div>
</div>


<div class="container my-5">
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <h3 class= " text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>