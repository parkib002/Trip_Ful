<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tripful - 관광지 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }
        .hero-image {
            background-image: url('../image/IMG_0104.JPEG');
            background-size: cover;
            background-position: center;
            height: 400px;
            border-radius: 1rem;
        }
        main {
            flex: 1;
        }
    </style>
</head>
<body class="bg-light">

<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm px-4">
    <a class="navbar-brand" href="#">
        <img src="../image/tripful.png" alt="Tripful Logo" height="50">
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown">
        <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-between" id="navbarNavDropdown">
        <ul class="navbar-nav">
            <li class="nav-item dropdown">
                <a class="nav-link dropdown-toggle" href="#" role="button" data-bs-toggle="dropdown">지역별 관광지</a>
                <ul class="dropdown-menu">
                    <li><a class="dropdown-item" href="#">서울</a></li>
                    <li><a class="dropdown-item" href="#">부산</a></li>
                    <li><a class="dropdown-item" href="#">제주</a></li>
                </ul>
            </li>
        </ul>
        <div class="d-flex align-items-center">
            <span id="welcome-text" class="me-3 text-secondary">로그인을 해주세요</span>
            <button id="auth-button" class="btn btn-primary">Login</button>
        </div>
    </div>
</nav>

<!-- Hero Section -->
<main class="container my-4">
    <div class="hero-image d-flex justify-content-center align-items-center text-white shadow mb-5">
        <h1 class="display-4 bg-dark bg-opacity-50 p-4 rounded">대한민국 관광 명소를 한눈에!</h1>
    </div>

    <!-- 검색 바 -->
    <div class="mb-4">
        <form class="d-flex">
            <input class="form-control me-2" type="search" placeholder="관광지를 검색해보세요..." aria-label="Search">
            <button class="btn btn-outline-success" type="submit">검색</button>
        </form>
    </div>

    <!-- 지역별 관광지 카드 -->
    <h2 class="mb-3">추천 관광지</h2>
    <div class="row row-cols-1 row-cols-md-3 g-4 mb-5">
        <div class="col">
            <div class="card h-100 shadow-sm">
                <img src="../image/seoul.jpg" class="card-img-top" alt="서울">
                <div class="card-body">
                    <h5 class="card-title">서울</h5>
                    <p class="card-text">역사와 현대가 어우러진 대한민국 수도 서울.</p>
                    <a href="#" class="btn btn-primary">자세히 보기</a>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm">
                <img src="../image/busan.jpg" class="card-img-top" alt="부산">
                <div class="card-body">
                    <h5 class="card-title">부산</h5>
                    <p class="card-text">바다와 도심이 공존하는 아름다운 항구 도시.</p>
                    <a href="#" class="btn btn-primary">자세히 보기</a>
                </div>
            </div>
        </div>
        <div class="col">
            <div class="card h-100 shadow-sm">
                <img src="../image/jeju.jpg" class="card-img-top" alt="제주">
                <div class="card-body">
                    <h5 class="card-title">제주</h5>
                    <p class="card-text">자연의 경이로움이 살아 숨 쉬는 섬 제주도.</p>
                    <a href="#" class="btn btn-primary">자세히 보기</a>
                </div>
            </div>
        </div>
    </div>

    <!-- 리뷰/추천 섹션 -->
    <h2 class="mb-3">여행자들의 리뷰</h2>
    <div class="list-group mb-5">
        <div class="list-group-item">
            <h5 class="mb-1">서울 경복궁이 정말 멋졌어요!</h5>
            <p class="mb-1">역사와 전통을 직접 느낄 수 있어요. 한복 체험도 추천합니다.</p>
            <small>by 여행자A</small>
        </div>
        <div class="list-group-item">
            <h5 class="mb-1">부산 해운대는 낮과 밤 모두 최고!</h5>
            <p class="mb-1">야경이 특히 아름다워요. 광안대교도 꼭 보세요.</p>
            <small>by 여행자B</small>
        </div>
        <div class="list-group-item">
            <h5 class="mb-1">제주도 오름 등반, 강추!</h5>
            <p class="mb-1">바람과 경치가 정말 좋아요. 조용히 힐링하기에 제격이에요.</p>
            <small>by 여행자C</small>
        </div>
    </div>
</main>

<!-- Footer -->
<footer class="bg-dark text-white text-center py-4 mt-auto">
    <div class="container">
        <p class="mb-1">Address: 1234 Street, City, Country</p>
        <p class="mb-0">Tel: +123 456 7890</p>
    </div>
</footer>

<script>
    const authButton = document.getElementById('auth-button');
    const welcomeText = document.getElementById('welcome-text');
    let loggedIn = false;

    authButton.addEventListener('click', () => {
        loggedIn = !loggedIn;
        if (loggedIn) {
            welcomeText.textContent = 'taelim34 님 환영합니다';
            authButton.textContent = 'Logout';
            authButton.classList.remove('btn-primary');
            authButton.classList.add('btn-danger');
        } else {
            welcomeText.textContent = '로그인을 해주세요';
            authButton.textContent = 'Login';
            authButton.classList.remove('btn-danger');
            authButton.classList.add('btn-primary');
        }
    });
</script>

</body>
</html>
