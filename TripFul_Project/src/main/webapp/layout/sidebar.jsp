<%
    String loginok = (String) session.getAttribute("loginok");
    boolean isLoggedIn = (loginok != null);
%>

<div class="d-flex flex-column flex-shrink-0 p-3 bg-light border-end" style="width: 250px; height: 100vh; position: fixed;">
    <a href="index.jsp" class="d-flex align-items-center mb-3 mb-md-0 me-md-auto link-dark text-decoration-none">
        <svg class="bi me-2" width="40" height="32"><use xlink:href="#home"/></svg>
        <span class="fs-4 fw-bold">Tripful</span>
    </a>
    <hr>
    <ul class="nav nav-pills flex-column mb-auto">
        <li class="nav-item">
            <a href="index.jsp" class="nav-link active" aria-current="page">
                🏠 메인페이지
            </a>
        </li>
        <li>
            <a href="index.jsp?main=place/placeList.jsp" class="nav-link link-dark">
                🌍 여행지 탐색
            </a>
        </li>
        <li>
            <a href="index.jsp?main=review/reviewList.jsp" class="nav-link link-dark">
                📝 리뷰 보기
            </a>
        </li>
        <% if (isLoggedIn) { %>
        <li>
            <a href="index.jsp?main=review/writeReview.jsp" class="nav-link link-dark">
                ✍ 리뷰 작성
            </a>
        </li>
        <li>
            <a href="logout.jsp" class="nav-link link-dark">
                🔒 로그아웃
            </a>
        </li>
        <% } else { %>
        <li>
            <a href="login.jsp" class="nav-link link-dark">
                🔓 로그인
            </a>
        </li>
        <% } %>
        <li>
            <a href="index.jsp?main=board/boardList.jsp" class="nav-link link-dark">
                📢 공지사항
            </a>
        </li>
        <li>
            <a href="index.jsp?main=board/boardList.jsp&sub=event.jsp" class="nav-link link-dark">
                🎁 이벤트
            </a>
        </li>
    </ul>
    <hr>
    <% if (isLoggedIn) { %>
    <div class="dropdown">
        <a href="#" class="d-flex align-items-center text-decoration-none dropdown-toggle" id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="<%= request.getContextPath() %>/image/user-icon.png" alt="" width="32" height="32" class="rounded-circle me-2">
            <strong>My Page</strong>
        </a>
        <ul class="dropdown-menu dropdown-menu-light text-small shadow" aria-labelledby="dropdownUser1">
            <li><a class="dropdown-item" href="index.jsp?main=member/mypage.jsp">내 정보</a></li>
            <li><a class="dropdown-item" href="index.jsp?main=review/myReviews.jsp">내 리뷰</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="logout.jsp">로그아웃</a></li>
        </ul>
    </div>
    <% } else { %>
    <div class="text-center">
        <a href="login.jsp" class="btn btn-primary mt-3">로그인 하러 가기</a>
    </div>
    <% } %>
</div>
