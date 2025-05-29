<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%@ page import="login.LoginDao" %>
<%@ page import="login.LoginDto" %>
<%
    String myid = (String) session.getAttribute("id");
    String name = null;

    if (myid != null) {
        LoginDao dao = new LoginDao();
        LoginDto dto = dao.getOneMember(myid);
        name = dto.getName();
    }
%>

<nav class="navbar navbar-light shadow px-4" style="height: 90px; position: relative; z-index: 1000;">
    <div class="container-fluid position-relative d-flex justify-content-between align-items-center">

        <!-- 왼쪽: 햄버거 버튼 + 검색 -->
        <div class="d-flex align-items-center flex-grow-1" style="min-width: 0; position: relative;">
            <!-- 햄버거 버튼: 항상 보이게 -->
            <button class="navbar-toggler d-block border-0 me-2" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
                <span class="navbar-toggler-icon"></span>
            </button>

            <!-- 검색창: 중간 화면(md) 이상일 때만 표시 -->
            <form action="index.jsp" method="get"
                  class="d-none d-md-flex align-items-center shadow-sm rounded-pill px-3 py-1 bg-white flex-grow-1"
                  style="border: 1px solid #dee2e6; max-width: 600px; min-width: 0; width: 100%; position: relative;">

                <input type="hidden" name="main" value="page/searchPlace.jsp">
                <input type="text"
                       id="searchInput"
                       name="keyword"
                       autocomplete="off"
                       class="form-control border-0 bg-transparent"
                       placeholder="관광지 검색"
                       style="font-size: 0.9rem;">
                <button type="submit" class="btn p-0 ms-2" style="background: none; border: none;">
                    <i class="bi bi-search fs-5 text-secondary"></i>
                </button>

                <!-- 자동완성 추천 목록 -->
                <ul id="suggestions"
                    style="
        border: 1px solid #ccc;
        display: none;
        position: absolute;
        top: 110%;
        left: 0;
        right: 0;
        background: white;
        list-style: none;
        margin: 0;
        padding: 0;
        max-height: 200px;
        overflow-y: auto;
        z-index: 9999;
        box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    ">
                </ul>
            </form>
        </div>

        <!-- 중앙 로고 -->
        <div class="position-absolute top-50 start-50 translate-middle">
            <a class="navbar-brand" href="index.jsp">
                <img src="../image/tripful_logo.png" alt="Tripful Logo" style="height: 110px;">
            </a>
        </div>

        <!-- 오른쪽: 로그인/로그아웃 -->
        <div class="d-flex align-items-center gap-2 flex-shrink-0">
            <% if (myid == null) { %>
            <span class="me-2 d-none d-md-inline">로그인을 해주세요</span>
            <button class="btn btn-sm btn-outline-warning" onclick="location.href='index.jsp?main=login/login.jsp'">Login</button>
            <% } else { %>
            <span class="me-2 d-none d-md-inline"><strong><%= name %></strong>님 환영합니다!</span>
            <button class="btn btn-sm btn-outline-danger" onclick="location.href='login/logoutAction.jsp'">Logout</button>
            <% } %>
        </div>
    </div>

    <!-- 드롭다운 메뉴 -->
    <div class="collapse" id="mainMenu" style="position: absolute; top: 90px; left: 0; width: 100%; background-color: white; z-index: 1050;">
        <ul class="navbar-nav px-4 py-3">
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=/place/selectPlace.jsp">지역별 관광지</a></li>
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

        if (menu.classList.contains('show') &&
            !menu.contains(event.target) &&
            !toggleButton.contains(event.target)) {
            const bsCollapse = bootstrap.Collapse.getInstance(menu);
            bsCollapse.hide();
        }
    });

    // 자동완성 스크립트
    const input = document.getElementById('searchInput');
    const suggestions = document.getElementById('suggestions');

    input.addEventListener('input', () => {
        const query = input.value.trim();
        if (query.length === 0) {
            suggestions.style.display = 'none';
            suggestions.innerHTML = '';
            return;
        }

        fetch('page/searchSuggestions.jsp?keyword=' + encodeURIComponent(query))
            .then(res => {
                if (!res.ok) throw new Error('서버 에러');
                return res.json();
            })
            .then(data => {
                suggestions.innerHTML = '';
                if (data.length === 0) {
                    suggestions.style.display = 'none';
                    return;
                }
                data.forEach(placeName => {
                    const li = document.createElement('li');
                    li.textContent = placeName;
                    li.style.padding = '8px 12px';
                    li.style.cursor = 'pointer';
                    li.addEventListener('mousedown', (e) => { // 클릭시 값 입력, blur 방지
                        e.preventDefault();
                        input.value = placeName;
                        suggestions.style.display = 'none';
                    });
                    li.addEventListener('mouseover', () => {
                        li.style.backgroundColor = '#eee';
                    });
                    li.addEventListener('mouseout', () => {
                        li.style.backgroundColor = 'transparent';
                    });
                    suggestions.appendChild(li);
                });
                suggestions.style.display = 'block';
            })
            .catch(err => {
                console.error(err);
                suggestions.style.display = 'none';
            });
    });

    // input 포커스 아웃시 추천 숨기기 (0.2초 지연 후)
    input.addEventListener('blur', () => {
        setTimeout(() => {
            suggestions.style.display = 'none';
        }, 200);
    });
</script>
