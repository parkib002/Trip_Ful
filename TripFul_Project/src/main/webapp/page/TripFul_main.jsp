<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>추천 관광지</title>
</head>
<body>

<header class="hero">
    <h1>Welcome To Our Tripful</h1>
    <h2>IT'S Travel review site</h2>
</header>

<div class="container py-5">
    <h2 class="text-center fw-bold mb-4">추천 관광지 & 리뷰</h2>

    <div id="spotReviewCarousel" class="carousel slide">
        <div class="carousel-inner">

            <!-- 슬라이드 1 : 서울 -->
            <div class="carousel-item active">
                <div class="row">
                    <!-- 관광지 카드 -->
                    <div class="col-md-6">
                        <div class="card shadow-sm mb-4">
                            <img src="${pageContext.request.contextPath}/image/seoul.jpg" class="card-img-top" alt="서울">
                            <div class="card-body">
                                <h5 class="card-title">서울</h5>
                                <p class="card-text">역사와 현대가 어우러진 대한민국 수도 서울.</p>
                                <a href="#" class="btn btn-warning">자세히 보기</a>
                            </div>
                        </div>
                    </div>
                    <!-- 리뷰 -->
                    <div class="col-md-6 d-flex align-items-center">
                        <div class="list-group w-100">
                            <div class="list-group-item border-start border-5 border-warning">
                                <h6 class="fw-bold">서울 경복궁이 정말 멋졌어요!</h6>
                                <p class="mb-1">역사와 전통을 직접 느낄 수 있어요. 한복 체험도 추천합니다.</p>
                                <small class="text-muted">by 여행자A</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 슬라이드 2 : 북촌한옥마을 -->
            <div class="carousel-item">
                <div class="row">
                    <!-- 관광지 카드 -->
                    <div class="col-md-6">
                        <div class="card shadow-sm mb-4">
                            <img src="${pageContext.request.contextPath}/image/test.png" class="card-img-top" alt="북촌한옥마을">
                            <div class="card-body">
                                <h5 class="card-title">북촌한옥마을</h5>
                                <p class="card-text">고즈넉한 전통 골목을 느낄 수 있는 곳.</p>
                                <a href="#" class="btn btn-warning">자세히 보기</a>
                            </div>
                        </div>
                    </div>
                    <!-- 리뷰 -->
                    <div class="col-md-6 d-flex align-items-center">
                        <div class="list-group w-100">
                            <div class="list-group-item border-start border-5 border-warning">
                                <h6 class="fw-bold">한옥 마을 산책 정말 좋아요!</h6>
                                <p class="mb-1">조용하고 전통적인 분위기가 정말 인상 깊었어요.</p>
                                <small class="text-muted">by 여행자B</small>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>

<!-- 부트스트랩 JS + 클릭 시 슬라이드 이동 스크립트 -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const carousel = document.querySelector('#spotReviewCarousel');
        const bsCarousel = new bootstrap.Carousel(carousel, {
            interval: 8000, // 8초 간격
            ride: 'carousel'
        });

        // 클릭 시 수동 슬라이드 전환 (원래 코드 유지)
        carousel.addEventListener('click', function () {
            bsCarousel.next();
        });
    });
</script>


</body>
</html>