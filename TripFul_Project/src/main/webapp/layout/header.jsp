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
              <a href="index.jsp?main=page/myPage.jsp" class="username-link" >
                <strong><%= name %></strong>님
                  페이지
              </a>
            </span>
            <button class="btn btn-sm btn-outline-danger" onclick="location.href='login/logoutAction.jsp'">Logout</button>
            <% } %>
        </div>
    </div>

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
    const input = document.getElementById('searchInput');
    const suggestions = document.getElementById('suggestions');
    const searchForm = input.closest('form');

    let isComposing = false;
    let latestQuery = "";

    input.addEventListener('compositionstart', () => {
        isComposing = true;
    });

    input.addEventListener('compositionend', () => {
        isComposing = false;
        triggerSearch(false);
    });

    input.addEventListener('input', () => {
        if (isComposing) {
            triggerSearch(true);
        } else {
            setTimeout(() => triggerSearch(false), 0);
        }
    });

    input.addEventListener('focus', () => {
        if (suggestions.children.length > 0) {
            suggestions.style.display = 'block';
        }
    });

    input.addEventListener('blur', () => {
        setTimeout(() => {
            suggestions.style.display = 'none';
        }, 150);
    });

    function triggerSearch(isDraft = false) {
        const query = input.value.trim();
        if (query.length === 0) {
            suggestions.style.display = 'none';
            suggestions.innerHTML = '';
            latestQuery = "";
            return;
        }
        if (query === latestQuery) return;
        latestQuery = query;

        fetch('page/searchSuggestions.jsp?keyword=' + encodeURIComponent(query) + '&draft=' + isDraft)
            .then(res => res.json())
            .then(data => {
                suggestions.innerHTML = '';
                if (!data || data.length === 0) {
                    suggestions.style.display = 'none';
                    return;
                }

                data.forEach(name => {
                    const li = document.createElement('li');
                    li.textContent = name;
                    li.style.padding = '8px 12px';
                    li.style.cursor = 'pointer';

                    li.addEventListener('mousedown', (e) => {
                        e.preventDefault();

                        input.blur();

                        setTimeout(() => {
                            input.value = name;
                            suggestions.style.display = 'none';
                            input.focus();

                            setTimeout(() => {
                                searchForm.submit();
                            }, 100);
                        }, 10);
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
            .catch(() => {
                suggestions.style.display = 'none';
            });
    }

    searchForm.querySelector('button[type="submit"]').addEventListener('click', (event) => {
        event.preventDefault();
        if (input.value.trim().length > 0) {
            searchForm.submit();
        }
    });

    input.addEventListener('keypress', (event) => {
        if (event.key === 'Enter') {
            event.preventDefault();
            if (input.value.trim().length > 0) {
                searchForm.submit();
            }
        }
    });
</script>
