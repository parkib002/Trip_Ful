<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<nav class="navbar navbar-light shadow px-4" style="height: 80px; position: relative;">

    <div class="container-fluid d-flex justify-content-between align-items-center position-relative">

        <!-- 햄버거 버튼 -->
        <button class="navbar-toggler border-0" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- 로고 -->
        <div class="position-absolute top-50 start-50 translate-middle">
            <a class="navbar-brand" href="index.jsp">
                <img src="../image/tripful_logo.png" alt="Tripful Logo" height="120">
            </a>
        </div>

        <!-- 로그인 -->
        <div class="d-flex align-items-center">
            <span id="welcome-text" class="me-3">로그인을 해주세요</span>
            <button class="btn btn-yellow" onclick="location.href='index.jsp?main=login/login.jsp'">Login</button>
        </div>

    </div>

    <!-- 메뉴: position absolute로 띄우기 -->
    <div class="collapse" id="mainMenu" style="
    position: absolute;
    top: 80px;  /* 네비바 높이만큼 아래 */
    left: 0;
    width: 100%;
    background-color: inherit; /* 네비바 배경과 같게 */
    box-shadow: none; /* 경계선이나 그림자 없애기 */
    z-index: 1050;  ">
        <ul class="navbar-nav px-4 py-3">
            <li class="nav-item">
                <a class="nav-link" href="index.jsp?main=/place/selectPlace.jsp">지역별 관광지</a>
            </li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=event.jsp">이벤트</a></li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=notice.jsp">공지사항</a></li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=support.jsp">QnA 게시판</a></li>
        </ul>
    </div>

</nav>



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
