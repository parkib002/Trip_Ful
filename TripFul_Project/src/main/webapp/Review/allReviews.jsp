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

        // 아이디, 로그인상태 세션값 받기
        String review_id = (String)session.getAttribute("id");
        String loginok = (String)session.getAttribute("loginok");

        // 모든 리뷰 가져오기
        List<HashMap<String,String>> list = rdao.getAllReviews(); // ReviewDao에 getAllReviews() 메서드 필요
    %>
    <script type="text/javascript">
        $(function() {
            // '리뷰 작성' 모달 버튼 클릭 이벤트 (기존과 동일하게 유지)
            var review_id_js = "<%=review_id%>"; // JavaScript에서 사용할 review_id 변수
            $("#modalBtn").click(function() {
                if(<%=loginok!=null%>){
                    $('.modal').css('display', 'flex');
                    setTimeout(function() {
                        $('.modal').addClass('show');
                    }, 10);
                }else{
                    var a=confirm("로그인 후 이용 가능합니다\\n로그인 페이지로 이동 하시겠습니까?");
                    if(a) {
                        location.href="../index.jsp?main=login/login.jsp";
                    }
                }
            });

            // 여기서는 apitest 버튼으로 특정 place_num의 리뷰를 다시 로드할 필요가 없으므로 해당 AJAX 호출은 제거하거나,
            // 만약 전체 리뷰 페이지에서도 어떤 특정 장소의 리뷰를 필터링해서 볼 수 있는 기능을 추가하고 싶다면,
            // 해당 로직을 여기에 맞게 수정해야 합니다.
            // 현재는 'allReviews.jsp'가 모든 리뷰를 보여주는 목적이므로, 이 AJAX 로직은 필요 없을 수 있습니다.
            // 필요하다면, 전체 리뷰 중 필터링 기능을 위한 별도의 AJAX를 구현해야 합니다.

            // Owl Carousel 초기화 (페이지 로드 시 바로 적용)
            // 초기 로딩 시 서버에서 가져온 데이터를 바로 캐러셀로 만들도록 합니다.
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

            // 리뷰 수정/삭제/신고 드롭다운 메뉴 토글 (기존 로직과 동일)
            $(document).on("click", ".category", function(e) {
                e.stopPropagation(); // 이벤트 버블링 방지
                $(this).next(".dropdown-menu").toggle();
            });

            $(document).on("click", function() {
                $(".dropdown-menu").hide();
            });

            // 수정 및 삭제 버튼 이벤트 (기존 로직과 동일, Review/JavaScript/reviewJs.js에서 처리)
            // 이 부분은 reviewJs.js에 있다고 가정하고, 해당 스크립트가 로드될 때 이벤트 리스너가 추가될 것입니다.
            // 만약 reviewJs.js가 모든 리뷰 페이지에 맞게 추가적인 로직이 필요하다면 수정해야 합니다.
        });
    </script>
</head>

<body>
<div class="container mt-5">
    <h3 class="text-center mb-4">모든 여행자 리뷰</h3>

    <div>
        <button id="modalBtn" class="btn btn-primary mb-3">리뷰 작성</button>
        <%-- 'API 테스트' 버튼은 모든 리뷰 페이지에서는 필요 없을 수 있으므로 제거하거나 용도에 맞게 변경하세요. --%>
        <%-- <button id="apitest" class="btn btn-info mb-3">리뷰 불러오기 (API 테스트)</button> --%>

        <div class="container mt-3">
            <form class="updatefrm" enctype="multipart/form-data" >
                <div id="reviewCarousel" class="owl-carousel owl-theme">
                    <%-- 모든 리뷰 데이터가 여기에 표시됩니다. --%>
                    <% if (list != null && !list.isEmpty()) { %>
                    <% for (HashMap<String, String> r : list) { %>
                    <div class='item'>
                        <div class='card h-100 p-3'>
                            <div class='review-header d-flex justify-content-between align-items-center mb-2'>
                                <b><%= r.get("author") %></b>
                                <% if (r.get("read") != null && !r.get("read").equals("DB") && !r.get("read").equals("")) { %>
                                <div class='googlechk mb-2'>
                                    <span class='googlereview'><%= r.get("read") %></span>
                                </div>
                                <% } %>
                                <div>
                                    <span class='review_writeday'><%= r.get("date") %></span>&nbsp;&nbsp;
                                    <i class='bi bi-three-dots-vertical category' review_id='<%= r.get("author") %>'></i>
                                    <% if (review_id != null && review_id.equals(r.get("author"))) { %>
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
                                <span><%= r.get("rating") %></span>&nbsp;&nbsp;
                                <%
                                    // 별점 문자열을 double로 변환한 후 int로 캐스팅
                                    double doubleRating = 0.0; // 기본값 설정
                                    try {
                                        doubleRating = Double.parseDouble(r.get("rating"));
                                    } catch (NumberFormatException e) {
                                        // "rating" 값이 유효한 숫자가 아닐 경우의 처리 (예: 기본값 0.0)
                                        System.err.println("Invalid rating format: " + r.get("rating"));
                                    }
                                    int rating = (int) doubleRating; // 소수점 버림
                                %>
                                <% for (int i = 0; i < rating; i++) { %>
                                <span class='rating on'></span>
                                <% } %>
                                <% for (int i = 0; i < (5 - rating); i++) { %>
                                <span class='rating'></span>
                                <% } %>
                            </div>
                            <% if (r.get("photo") != null && !r.get("photo").equals("null") && !r.get("photo").isEmpty()) { %>
                            <div class='review-image-container mb-2'>
                                <img src='save/<%= r.get("photo") %>' class='img-fluid rounded'>
                            </div>
                            <% } %>
                            <p class='card-text'><%= r.get("text").replaceAll("\n", "<br>") %></p>
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

<div id="myModal" class="modal">
    <form class="modalfrm" enctype="multipart/form-data">
        <div align="center" class="modal-head">
            <input type="hidden" name="place_num" value=""> <%-- 모든 리뷰 페이지이므로 place_num은 비워둡니다. --%>
            <h4>리뷰 작성</h4> <%-- 모든 리뷰 페이지에서는 특정 장소 이름 대신 일반적인 제목 --%>
        </div>
        <div class="modal-content">
            <table>
                <tr>
                    <td>
                        <input type="hidden" name="review_id" value="<%= review_id != null ? review_id : "" %>">
                        <b><%= review_id != null ? review_id : "비회원" %></b><br> <br>
                    </td>
                </tr>
                <tr>
                    <td class="input-group"><span>별점</span> &nbsp;
                        <input type="hidden" name="review_star" id="review_star" value="0">
                        <div class="star_rating">
                            ​​<span class="star" value="1"> </span>
                            <span class="star" value="2"> </span> ​​
                            <span class="star" value="3"> </span> ​​
                            <span class="star" value="4"> </span> ​​
                            <span class="star" value="5"> </span>
                        </div></td>
                </tr>
                <tr>
                    <td><textarea class="review_content" name="review_content"
                                  required="required"></textarea></td>
                </tr>
                <tr>
                    <td>
                        <div id="show" >
                            <label class="btn-upload">
                                <i class="bi bi-camera-fill camera"></i>
                                <input type="file" name="review_img" id="file">
                            </label>
                        </div>
                        <br><br>
                    </td>
                </tr>

            </table>
        </div>
        <div class="modal-foot">
            <button type="button" class="close" id="closeBtn">취소</button>
            <button type="button" class="save">게시</button>
        </div>
    </form>
</div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
<script src="Review/JavaScript/ModalJs.js"></script>
<script src="Review/JavaScript/reviewJs.js"></script>
</body>

</html>