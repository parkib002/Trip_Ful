<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="login.LoginDao" %>
<%@ page import="login.LoginDto" %>
<%
    String myid = null;
    String name = null;
    String loginok = null;

    if (session.getAttribute("loginok") != null) {
        loginok = (String) session.getAttribute("loginok");
        myid = (String) session.getAttribute("id");

        if (myid != null) {
            LoginDao dao = new LoginDao();
            LoginDto dto = dao.getOneMember(myid);
            name = dto.getName();
        }
    }
%>

<nav class="navbar navbar-light shadow px-4">
    <div class="container-fluid position-relative d-flex justify-content-between align-items-center">
        <div class="d-flex align-items-center flex-grow-1" style="min-width: 0; position: relative;">
            <button class="navbar-toggler d-block border-0 me-2" type="button" data-bs-toggle="collapse" data-bs-target="#mainMenu">
                <span class="navbar-toggler-icon"></span>
            </button>

            <form action="index.jsp" method="get"
                  class="d-none d-lg-flex align-items-center shadow-sm rounded-pill px-3 py-1 bg-white flex-grow-1"
                  style="border: 1px solid #dee2e6; max-width: 300px; min-width: 0; width: 100%; position: relative;">
                <input type="hidden" name="main" value="page/searchPlace.jsp">

                <input type="text"
                       id="searchInput"
                       name="keyword"
                       autocomplete="off"
                       spellcheck="false"
                       autocorrect="off"
                       class="form-control border-0 bg-transparent"
                       placeholder="관광지 검색"
                       style="font-size: 0.9rem; ime-mode: active;" />

                <button type="submit" class="btn p-0 ms-2" style="background: none; border: none;">
                    <i class="bi bi-search fs-5 text-secondary"></i>
                </button>

                <ul id="suggestions" style="
                    position: absolute;
                    top: 100%;
                    left: 0;
                    right: 0;
                    background: white;
                    border: 1px solid #ccc;
                    max-height: 200px;
                    overflow-y: auto;
                    list-style: none;
                    margin: 0;
                    padding: 0;
                    display: none;
                    z-index: 10000;
                "></ul>
            </form>
        </div>

        <div class="position-absolute top-50 start-50 translate-middle">
            <a class="navbar-brand" href="index.jsp">
                <img src="./image/tripful_logo.png" alt="Tripful Logo" style="height: 110px;">
            </a>
        </div>

        <div class="d-flex align-items-center gap-2 flex-shrink-0">
            <% if (myid == null) { %>
            <span class="me-2 d-none d-md-inline">로그인을 해주세요</span>
            <button class="btn btn-sm btn-outline-warning" onclick="location.href='index.jsp?main=login/login.jsp'">Login</button>
            <% } else { %>
            <span class="me-2 d-none d-md-inline">
                    <a href="index.jsp?main=<%=
                        "admin".equals(loginok)
                        ? "page/adminMain.jsp"
                        : "login/MyPage.jsp?id=" + myid
                    %>" class="username-link">
                        <strong><%= name %></strong>님 페이지
                    </a>
                </span>
            <button class="btn btn-sm btn-outline-danger" onclick="location.href='login/logoutAction.jsp'">Logout</button>
            <% } %>
        </div>
    </div>

    <div class="collapse" id="mainMenu" style="position: absolute; top: 90px; left: 0; background-color: white; z-index: 1050;">
        <ul class="navbar-nav px-4 py-3">
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=/place/selectPlace.jsp">지역별 관광지</a></li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=event.jsp">이벤트</a></li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=notice.jsp">공지사항</a></li>
            <li class="nav-item"><a class="nav-link" href="index.jsp?main=board/boardList.jsp&sub=support.jsp">고객센터</a></li>
        </ul>
    </div>
</nav>
