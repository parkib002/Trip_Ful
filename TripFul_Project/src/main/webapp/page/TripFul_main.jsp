<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List" %>
<%@ page import="main.MainPlaceDao, main.MainPlaceDto" %>


<%
    // DAO에서 5개 랜덤 장소 가져오기
    MainPlaceDao dao = new MainPlaceDao();
    List<MainPlaceDto> placeList = dao.getRandomPlaces(5);
%>

<%--
    <head>와 <body>, </html> 태그는 index.jsp에 이미 존재하므로 여기서는 제거합니다.
    Bootstrap JS CDN도 index.jsp에서 로드하므로 여기서는 제거합니다.
--%>

<header class="hero text-center p-4 bg-light">
    <h1>Welcome To Our Tripful</h1>
    <h2>IT'S Travel review site</h2>
</header>
<div id="spotReviewCarousel" class="carousel slide" data-bs-ride="carousel">

    <div class="carousel-indicators">
        <% for (int i = 0; i < placeList.size(); i++) {
            String activeClass = (i == 0) ? "active" : "";
        %>
        <button type="button" data-bs-target="#spotReviewCarousel" data-bs-slide-to="<%=i%>" class="<%=activeClass%>" aria-current="<%= (i == 0) ? "true" : "false" %>" aria-label="슬라이드 <%=i+1%>"></button>
        <% } %>
    </div>

    <div class="carousel-inner">
        <% for (int i = 0; i < placeList.size(); i++) {
            MainPlaceDto place = placeList.get(i);
            String activeClass = (i == 0) ? "active" : "";
        %>
        <div class="carousel-item <%= activeClass %>">
            <%-- 기존 배경판 역할을 하던 div 제거 --%>
            <div class="d-flex justify-content-center py-4"> <%-- 카드 중앙 정렬을 위한 div 추가 --%>
                <div class="col-md-10"> <div class="card border-0 shadow-lg h-100 rounded-4 overflow-hidden">
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
                        <a href="#" class="btn btn-outline-warning mt-2">자세히 보기</a>

                        <div class="bg-light p-4 mt-4 rounded-4 shadow-sm border-start border-5 border-warning">
                            <h6 class="fw-bold mb-2"><%= place.getPlaceName() %>에 대한 여행자의 리뷰</h6>
                            <p class="fst-italic mb-2">“정말 인상적인 장소였습니다. 추천해요!”</p>
                            <small class="text-muted">by 여행자</small>
                        </div>
                    </div>
                </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>

<%----%>
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

<div class="container my-5">
    <h3 class="text-center mb-4">📰 공지사항 & 이벤트</h3>
    <a href="index.jsp?main=<%=request.getContextPath()%>/board/event.jsp" class="alert alert-warning text-center fw-semibold fs-5 shadow-sm d-block text-decoration-none text-dark">
        📣 [이벤트] 여름맞이 특별 할인! 전 세계 인기 여행지 최대 30% OFF ~ 6월 30일까지
    </a>

    <div class="bg-light p-4 rounded-3 shadow-sm mt-3">
        <h5 class="fw-bold mb-2">✍ 최신 여행자 리뷰</h5>
        <p class="fst-italic mb-1">“오사카 도톤보리는 야경이 정말 예뻐요! 쇼핑도 재밌고요 😊”</p>
        <small class="text-muted">- 여행자9912님</small>
        <div class="mt-3">
            <a href="index.jsp?main=<%=request.getContextPath()%>/Review/reviewList.jsp" class="btn btn-outline-secondary btn-sm">리뷰 전체 보기</a>
        </div>
    </div>
</div>


<div class="container my-5">
    <h3 class= " text-center mb-4">🧭 Tripful은 어떤 사이트인가요?</h3>
    <div class="p-4 bg-white shadow-sm rounded-3 text-center">
        <p class="fs-5 mb-0">
            Tripful은 여행지를 추천하고, 사용자 리뷰를 통해 더 나은 여행을 돕는 플랫폼입니다.<br>
            지역, 테마, 키워드로 원하는 장소를 찾고, 다른 여행자의 경험을 함께 나눠보세요.
        </p>
    </div>
</div>

<%--
    캐러셀 관련 JavaScript 코드를 별도의 파일 (예: mainPageCarousel.js)로 분리하고,
    index.jsp의 </body> 닫는 태그 바로 위에 로드하는 것이 좋습니다.
    아래 코드는 이제 mainPage.jsp에서 제거됩니다.
--%>