<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<nav class="navbar navbar-light shadow px-4">
    <div class="container-fluid d-flex justify-content-between align-items-center position-relative">

        <!-- 좌측 햄버거 버튼 -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 중앙 로고 -->
        <div class="position-absolute top-50 start-50 translate-middle">
            <a class="navbar-brand" href="index.jsp">
                <img src="../image/tripful_logo.png" alt="Tripful Logo" height="120">
            </a>
        </div>

        <!-- 우측 로그인 영역 -->
        <div class="d-flex align-items-center">
            <span id="welcome-text" class="me-3">로그인을 해주세요</span>
            <button id="auth-button" class="btn btn-yellow">Login</button>
        </div>
    </div>

    <!-- 햄버거 메뉴 펼침 영역 -->
    <div class="collapse" id="mainMenu">
        <ul class="navbar-nav px-4 py-3 bg-light">
            <li class="nav-item">
                <a class="nav-link" href="#" data-bs-toggle="modal" data-bs-target="#regionModal">지역별 관광지</a>
            </li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/board/boardList.jsp?main=event.jsp">이벤트</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/board/boardList.jsp?main=notice.jsp">공지사항</a></li>
            <li class="nav-item"><a class="nav-link" href="${pageContext.request.contextPath}/board/boardList.jsp?main=support.jsp">QnA 게시판</a></li>
        </ul>
    </div>
</nav>



<header class="hero">
    <h1>Welcome To Our Tripful</h1>
    <h2>IT'S Travel review site</h2>
</header>


<script>
    document.addEventListener('click', function(event) {
        const menu = document.getElementById('mainMenu');
        const toggleButton = document.querySelector('.navbar-toggler');

        // 메뉴가 열려 있고, 클릭한 곳이 메뉴 안도 아니고 버튼도 아니면
        if (menu.classList.contains('show') &&
            !menu.contains(event.target) &&
            !toggleButton.contains(event.target)) {
            const bsCollapse = bootstrap.Collapse.getInstance(menu);
            bsCollapse.hide();
        }
    });
</script>
