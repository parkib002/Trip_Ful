<%@page import="review.ReviewDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
    <meta charset="UTF-8">

    <link
            href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap"
            rel="stylesheet">
    <link
            href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
            rel="stylesheet">

    <link rel="stylesheet"
          href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <%-- ModalStyle.css는 이제 리뷰 작성 모달이 없으므로 필요 없을 수 있습니다. --%>
    <link rel="stylesheet" href="Review/ModalStyle.css">
    <script
            src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
    <link rel="stylesheet" href="Review/carouselStyle.css">

    <title>모든 여행자 리뷰</title>
    <%
        ReviewDao rdao = new ReviewDao();

        // 아이디, 로그인상태 세션값 받기 (리뷰 수정/삭제/신고 기능에 사용됨)
        String review_id_session = (String)session.getAttribute("id"); // 세션 ID와 충돌 방지
        String loginok = (String)session.getAttribute("loginok");

        // 모든 리뷰 가져오기
        List<HashMap<String,String>> list = rdao.getAllReviews();
    %>
    <script type="text/javascript">
        $(function() {
            // Owl Carousel 초기화 (페이지 로드 시 바로 적용)
            var owl = $('#reviewCarousel');
            owl.owlCarousel({
                loop: false,
                margin: 10,
                nav: false,
                dots: false,
                responsive: {
                    0: { items: 1, slideBy: 1 },
                    768: { items: 2, slideBy: 1 },
                    992: { items: 3, slideBy: 1 }
                }
            });

            // 리뷰 수정/삭제/신고 드롭다운 메뉴 토글
            $(document).on("click", ".category", function(e) {
                e.stopPropagation(); // 이벤트 버블링 방지
                $(this).next(".dropdown-menu").toggle();
            });

            $(document).on("click", function() {
                $(".dropdown-menu").hide();
            });

            // 수정 및 삭제 버튼 이벤트는 Review/JavaScript/reviewJs.js에서 처리될 것입니다.
            // reviewJs.js에 모달 관련 로직이 있다면 해당 스크립트 파일도 검토가 필요합니다.
        });
    </script>
</head>

<body>
<div class="container mt-5">
    <h3 class="text-center mb-4">모든 여행자 리뷰</h3>

    <div>
        <%-- '리뷰 작성' 버튼 제거 --%>
        <%-- 'API 테스트' 버튼도 제거 --%>

        <div class="container mt-3">
            <form class="updatefrm" enctype="multipart/form-data" >
                <div id="reviewCarousel" class="owl-carousel owl-theme">
                    <% if (list != null && !list.isEmpty()) { %>
                    <% for (HashMap<String, String> r : list) {
                        // 각 리뷰에 연결된 여행지의 이름을 가져옵니다.
                        // r.get("place_num")은 ReviewDao의 getAllReviews()에서 "place_num" 키로 담았을 경우입니다.
                        // 현재 JSP에서 r.get("author") 등을 쓰는 것으로 보아, DAO에서 "place_num" 대신 다른 키를 쓰고 있을 수 있습니다.
                        // 만약 DAO에서 "place_num" 키를 사용하지 않는다면 이 부분을 수정해야 합니다.
                        String currentPlaceNum = r.get("place_num"); // DAO에서 place_num 키로 값을 넘겼는지 확인
                        String placeName = "알 수 없는 여행지"; // 기본값 설정

                        if (currentPlaceNum != null && !currentPlaceNum.trim().isEmpty()) {
                            // rdao.getPlaceName()은 ReviewDao에 존재하는 메서드입니다.
                            String fetchedPlaceName = rdao.getPlaceName(currentPlaceNum);
                            if (fetchedPlaceName != null && !fetchedPlaceName.trim().isEmpty()) {
                                placeName = fetchedPlaceName;
                            }
                        }
                    %>
                    <div class='item'>
                        <div class='card h-100 p-3'>
                            <div class='review-header d-flex justify-content-between align-items-center mb-2'>
                                <b><%= r.get("author") != null ? r.get("author") : "익명" %></b> <%-- author 값 null 체크 --%>
                                <%-- 'read' 값 null 체크 및 "DB" 아닐 경우에만 표시 --%>
                                <% if (r.get("read") != null && !r.get("read").equals("DB") && !r.get("read").trim().isEmpty()) { %>
                                <div class='googlechk mb-2'>
                                    <span class='googlereview'><%= r.get("read") %></span>
                                </div>
                                <% } %>
                                <div>
                                    <%-- 'date' 값 null 체크 --%>
                                    <span class='review_writeday'><%= r.get("date") != null ? r.get("date") : "" %></span>&nbsp;&nbsp;
                                    <i class='bi bi-three-dots-vertical category' review_id='<%= r.get("author") != null ? r.get("author") : "" %>'></i>
                                    <%-- 세션 ID와 리뷰 작성자 ID 비교 --%>
                                    <% if (review_id_session != null && review_id_session.equals(r.get("author"))) { %>
                                    <div class='dropdown-menu'>
                                        <button type='submit' class='edit-btn' review_id='<%= r.get("author") %>'>수정</button>
                                        <button type='button' class='delete-btn' review_id='<%= r.get("author") %>'>삭제</button>
                                    </div>
                                    <% } else { %>
                                    <div class='dropdown-menu'>
                                        <button>신고</button>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                            <div class='star_rating2 mb-2'>
                                <%-- 'rating' 값 null 체크 및 파싱 --%>
                                <span><%= r.get("rating") != null ? r.get("rating") : "0.0" %></span>&nbsp;&nbsp;
                                <%
                                    double doubleRating = 0.0;
                                    String ratingStr = r.get("rating");
                                    if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                                        try {
                                            doubleRating = Double.parseDouble(ratingStr);
                                        } catch (NumberFormatException e) {
                                            System.err.println("Invalid rating format: " + ratingStr);
                                        }
                                    }
                                    int rating = (int) doubleRating;
                                %>
                                <% for (int i = 0; i < rating; i++) { %>
                                <span class='rating on'></span>
                                <% } %>
                                <% for (int i = 0; i < (5 - rating); i++) { %>
                                <span class='rating'></span>
                                <% } %>
                            </div>
                            <%-- 'photo' 값 null 체크 --%>
                            <% String reviewPhoto = r.get("photo");
                                if (reviewPhoto != null && !reviewPhoto.equals("null") && !reviewPhoto.trim().isEmpty()) { %>
                            <div class='review-image-container mb-2'>
                                <img src='save/<%= reviewPhoto %>' class='img-fluid rounded'>
                            </div>
                            <% } %>
                            <p class='card-text'>
                                <%-- 'text' 값 null 체크 --%>
                                <% String reviewText = r.get("text");
                                    if (reviewText != null) {
                                        out.print(reviewText.replaceAll("\n", "<br>"));
                                    } else {
                                        out.print(""); // review_content가 null일 경우 빈 문자열 출력
                                    } %>
                            </p>

                            <hr class="my-3">
                            <div class="text-end">
                                <small class="text-muted">
                                    여행지: **<%= placeName %>**
                                    <%-- place_num이 유효할 때만 링크 표시 --%>
                                    <% if (currentPlaceNum != null && !currentPlaceNum.trim().isEmpty() && !placeName.equals("알 수 없는 여행지")) { %>
                                    <a href="index.jsp?main=place/detailPlace.jsp?place_num=<%= currentPlaceNum %>" class="btn btn-sm btn-outline-info ms-2">자세히 보기</a>
                                    <% } %>
                                </small>
                            </div>
                        </div>
                    </div>
                    <% } %>
                    <% } else { %>
                    <div class='item'>
                        <div class='card p-3 m-2 text-center'>
                            <p>아직 등록된 리뷰가 없습니다.</p>
                        </div>
                    </div>
                    <% } %>
                </div>
            </form>
        </div>
    </div>
</div>

<%-- 리뷰 작성 모달 창 관련 스크립트 제거 --%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
<%-- ModalJs.js는 모달이 없으므로 삭제 --%>
<%-- <script src="Review/JavaScript/ModalJs.js"></script> --%>
<script src="Review/JavaScript/reviewJs.js"></script>
</body>

</html>