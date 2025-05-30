document.addEventListener('DOMContentLoaded', function () {
    const carousel = document.querySelector('#spotReviewCarousel');
    // 캐러셀 요소가 존재하는지 확인하여 오류 방지
    if (carousel) {
        const bsCarousel = new bootstrap.Carousel(carousel, {
            interval: 8000,
            ride: 'carousel'
        });

        // 클릭 시 수동 슬라이드 전환
        carousel.addEventListener('click', function () {
            bsCarousel.next();
        });
    }
});