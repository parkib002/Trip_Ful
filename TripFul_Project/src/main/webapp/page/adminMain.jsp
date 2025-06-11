<%@page import="login.LoginDao"%>
<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    // --- 1. 서버 측 로직 ---
    BoardSupportDao supportDao=new BoardSupportDao();
	LoginDao ldao = new LoginDao();

    // 세션에서 관리자 이름과 로그인 상태를 가져옵니다.
    String adminName = (String) session.getAttribute("name");
    String loginStatus = (String) session.getAttribute("loginok");

    // 로그인 상태가 'admin'이 아니면 인덱스 페이지로 리다이렉트합니다.
    if (loginStatus == null || !loginStatus.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 주요 현황 요약 데이터 (실제 DB 연동 필요)
    int newMembersToday = ldao.getTodayNewMembersCount();
    int newMembersThisWeek = ldao.getThisWeekNewMembersCount();
    int newMembersThisMonth = ldao.getThisMonthNewMembersCount();
    int recentReviewsCount = 45;
    int unansweredInquiriesCount = supportDao.getUnansweredTotalCount();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>관리자 메인 페이지</title>

    <%-- 라이브러리 로드 --%>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.5.0/dist/echarts.min.js"></script>
    
    <style>
        body { font-family: 'Inter', sans-serif; }
        .admin-banner {
            background: linear-gradient(135deg, #007BFF, #00B3D4);
            color: white;
            padding: 50px 20px;
            text-align: center;
            border-radius: 0 0 25px 25px;
            margin-bottom: 30px;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        }
        .admin-banner h1 { font-weight: 700; }
        .admin-section { padding: 20px; }
        .card {
            border: none;
            border-radius: 15px;
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            overflow: hidden;
        }
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
        }
        .card-icon { font-size: 2.5rem; color: #007BFF; }
        .summary-card .card-icon { color: #28A745; }
        .summary-card .display-6, .summary-card .h5 { font-weight: 600; }
        .list-group-item {
            border-left: none; border-right: none;
            padding-left: 0; padding-right: 0;
            cursor: pointer;
        }
        .list-group-item:first-child { border-top: none; border-top-left-radius: 0; border-top-right-radius: 0; }
        .list-group-item:last-child { border-bottom: none; border-bottom-left-radius: 0; border-bottom-right-radius: 0; }
        .btn-primary {
            background-color: #007BFF; border-color: #007BFF;
            transition: background-color 0.2s ease, border-color 0.2s ease;
        }
        .btn-primary:hover { background-color: #0056B3; border-color: #0056B3; }
        .section-title {
            font-size: 1.8rem; font-weight: 600;
            margin-bottom: 25px; color: #333; text-align: center;
        }
        .sort-dropdown {
            padding: 0.35rem 0.5rem; border: 2px solid #2196F3;
            border-radius: 0.5rem; font-size: 1rem;
            color: #2196F3; background-color: #fff;
            cursor: pointer; transition: all 0.3s ease;
        }
        .sort-dropdown:focus {
            outline: none; border-color: #2196f3;
            box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2);
        }
    </style>

    <script type="text/javascript">
        // ✅ 차트 객체와 상태 관련 변수를 전역 스코프에 선언
        let myChart;
        let currentContinent = 'asia';
        let c_Sort = 'views';

        // --- 페이지 로드 완료 후 실행되는 로직 ---
        $(function() {

            // ✅ 차트 초기화 (페이지 로드 시 딱 한 번만 실행)
            myChart = echarts.init(document.getElementById('chart'));

            // ✅ 차트 클릭 이벤트 등록 (페이지 로드 시 딱 한 번만 실행)
            myChart.on('click', function (params) {
                if (params.componentType === 'series') {
                    // 숨겨둔 place_num 값을 params.data 객체에서 가져옵니다.
                    let placeNum = params.data.place_num;

                    console.log("클릭된 장소의 고유 번호:", placeNum);

                    // place_num을 사용하여 상세 페이지로 이동합니다.
                    if(placeNum) {
                        location.href = 'index.jsp?main=place/detailPlace.jsp?place_num=' + placeNum;
                    }
                }
            });

            // --- 함수 정의 ---

            // 인기 여행지 TOP 5 목록을 가져오는 함수
           let currentSort = 'views';
    	
        function loadPopularList(sort) {
            $.ajax({
                type: "post",
                url: "page/sortPlaceAction.jsp",
                data: { "sort": sort },
                dataType: "json",
                success: function(res) {
                    console.log(sort);
                    console.log(res);
                    if (res.length > 0) {
                        console.log(res[0].place_name);
                    }
                    $('#popularList').empty();
                    $.each(res, function(index, item) {
                        var rank = index + 1;
                        var name = item.place_name;
                        var value = 0;
                        if (sort === 'views') {
                            value = item.place_count + "회";
                        } else if (sort === 'rating') {
                            value = item.avg_rating !== null ? item.place_rating.toFixed(1) + "점" : "0.0";
                        } else if (sort === 'likes') {
                            value = item.place_like + "개";
                        }

                        var li = '<li class="list-group-item d-flex justify-content-between align-items-center list" id=' + item.place_num + '>'
                            + rank + '. ' + name + "(" + item.country_name + ")"
                            + '<span class="badge bg-primary rounded-pill">' + value + '</span>'
                            + '</li>';
                        $('#popularList').append(li);
                    });
                },
                error: function(err) {
                    console.log("에러:", err);
                }
            });
        }

        loadPopularList(currentSort);

            // 통계 차트 데이터를 가져와 그리는 함수
            function loadChartData() {
                $.ajax({
                    type: "post",
                    url: "place/chartAction.jsp",
                    data: { "currentContinent": currentContinent, "c_Sort": c_Sort },
                    dataType: "json",
                    success: function(res) {
                        let xAxisData = [];
                        let seriesData = [];

                        for (let item of res) {
                            xAxisData.push(item.place_name);

                            let yValue = 0;
                            if (c_Sort === 'views') {
                                yValue = item.place_count;
                            } else if (c_Sort === 'likes') {
                                yValue = item.place_like;
                            } else if (c_Sort === 'rating') {
                                yValue = item.place_rating || 0;
                            }

                            // [핵심] series.data에 {값, 고유ID} 객체를 저장
                            seriesData.push({
                                value: yValue,
                                place_num: item.place_num
                            });
                        }
                        drawChart(xAxisData, seriesData, 'bar');
                    },
                    error: function(err) {
                        console.log("차트 데이터 로딩 에러:", err);
                        myChart.clear();
                    }
                });
            }

            
            loadPopularList(currentSort);
            // --- 이벤트 핸들러 등록 ---
$('#sortSelect').on('change', function() {
            currentSort = $(this).val();
            loadPopularList(currentSort);
        });

        $(document).on("click", ".list", function() {
            var num = $(this).attr("id");
            location.href = "index.jsp?main=place/detailPlace.jsp?place_num=" + num;
        });
            

            // 통계 차트 대륙 변경
            $("#continentSelect").change(function() {
                currentContinent = $(this).val();
                loadChartData();
            });

            // 통계 차트 정렬 기준 변경
            $("#c_SortSelect").change(function() {
                c_Sort = $(this).val();
                loadChartData();
            });

            // --- 페이지 로드 시 최초 데이터 호출 ---
            
            loadChartData();
        });


        // ✅ 차트를 그리는 역할만 하는 함수
        function drawChart(xAxisData, seriesData, chartType) {
            let option = {
                tooltip: { trigger: 'axis' },
                xAxis: {
                    type: 'category',
                    data: xAxisData,
                    axisLabel: {
                        rotate: 30,
                        interval: 0,
                        formatter: function (value) {
                            return value.length > 6 ? value.substring(0, 6) + "…" : value;
                        }
                    }
                },
                yAxis: { type: 'value' },
                series: [{
                    name: $("#c_SortSelect option:selected").text(),
                    data: seriesData,
                    type: chartType,
                    barWidth: '60%'
                }],
                grid: { left: '3%', right: '4%', bottom: '10%', containLabel: true }
            };
            myChart.setOption(option, true); // true 옵션으로 이전 설정과 병합하지 않고 새로 그림
        }
        
        // 브라우저 창 크기 변경 시 차트 크기 자동 조절
        $(window).on('resize', function(){
            if(myChart != null && myChart != undefined){
                myChart.resize();
            }
        });
    </script>
</head>

<body>
    <div class="admin-banner">
        <h1 class="display-4">Tripful 관리자 페이지</h1>
        <p class="lead">안녕하세요, <strong><%= adminName != null ? adminName : "관리자" %></strong>님! 사이트 현황을 한눈에 확인하세요.</p>
    </div>
    <div class="container admin-section">
        <h2 class="section-title mb-4">📈 주요 현황 요약</h2>
        <div class="row g-4 mb-5">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card summary-card shadow-sm p-3 h-100">
                    <div class="card-body text-center">
                        <div class="card-icon mb-3"><i class="bi bi-person-plus-fill"></i></div>
                        <h5 class="card-title mb-2">신규 가입 회원</h5>
                        <p class="card-text mb-1">오늘: <strong class="text-primary"><%= newMembersToday %></strong> 명</p>
                        <p class="card-text mb-1">이번 주: <strong class="text-primary"><%= newMembersThisWeek %></strong> 명</p>
                        <p class="card-text">이번 달: <strong class="text-primary"><%= newMembersThisMonth %></strong> 명</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card summary-card shadow-sm p-3 h-100">
                    <div class="card-body text-center">
                        <div class="card-icon mb-3"><i class="bi bi-chat-square-dots-fill"></i></div>
                        <h5 class="card-title mb-2">최근 등록 리뷰</h5>
                        <p class="display-6 text-primary"><strong><%= recentReviewsCount %></strong></p>
                        <p class="card-text text-muted">건</p>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card summary-card shadow-sm p-3 h-100">
                    <div class="card-body">
                        <div class="text-center card-icon mb-3"><i class="bi bi-star-fill"></i></div>
                        <h5 class="card-title mb-3 text-center">인기 여행지 TOP 5</h5>
                        <div class="text-center mb-3">
                            <select id="sortSelect" class="sort-dropdown">
                                <option value="views">조회순</option>
                                <option value="rating">별점순</option>
                                <option value="likes">좋아요순</option>
                            </select>
                        </div>
                        <ul class="list-group list-group-flush" id="popularList">
                            <%-- AJAX로 채워질 영역 --%>
                        </ul>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card summary-card shadow-sm p-3 h-100">
                    <div class="card-body text-center">
                        <div class="card-icon mb-3"><i class="bi bi-question-circle-fill"></i></div>
                        <h5 class="card-title mb-2">미답변 문의</h5>
                        <a href="<%=request.getContextPath()%>/index.jsp?main=board%2FboardList.jsp&sub=support.jsp&filter=unanswered&currentPage=1"
                           style="text-decoration: none;">
                            <p class="display-6 text-danger"><strong><%= unansweredInquiriesCount %></strong></p>
                        </a>
                        <p class="card-text text-muted">건</p>
                    </div>
                </div>
            </div>
        </div>
        
        <h2 class="section-title mb-4">⚙️ 핵심 기능 관리</h2>
        <div class="row g-4">
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card shadow-sm p-3 text-center h-100">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <div class="card-icon mb-3"><i class="bi bi-geo-alt-fill"></i></div>
                        <h5 class="card-title">여행지 관리</h5>
                        <p class="card-text text-muted small mb-3">등록된 여행지를 관리합니다.</p>
                        <a href="index.jsp?main=place/selectPlace.jsp" class="btn btn-primary w-100 mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                 <div class="card shadow-sm p-3 text-center h-100">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <div class="card-icon mb-3"><i class="bi bi-chat-left-text-fill"></i></div>
                        <h5 class="card-title">리뷰 관리</h5>
                        <p class="card-text text-muted small mb-3">사용자 리뷰를 관리합니다.</p>
                        <a href="index.jsp?main=Review/allReviews.jsp" class="btn btn-primary w-100 mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card shadow-sm p-3 text-center h-100">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <div class="card-icon mb-3"><i class="bi bi-people-fill"></i></div>
                        <h5 class="card-title">회원 관리</h5>
                        <p class="card-text text-muted small mb-3">회원 정보 및 권한을 관리합니다.</p>
                        <a href="index.jsp?main=login/memberList.jsp" class="btn btn-primary w-100 mt-auto">이동</a>
                    </div>
                </div>
            </div>
            <div class="col-lg-3 col-md-6 mb-4">
                <div class="card shadow-sm p-3 text-center h-100">
                    <div class="card-body d-flex flex-column justify-content-center">
                        <div class="card-icon mb-3"><i class="bi bi-megaphone-fill"></i></div>
                        <h5 class="card-title">공지사항 관리</h5>
                        <p class="card-text text-muted small mb-3">공지사항을 등록하고 수정합니다.</p>
                        <a href="index.jsp?main=board/boardList.jsp&sub=notice.jsp" class="btn btn-primary w-100 mt-auto">이동</a>
                    </div>
                </div>
            </div>
        </div>
        
        <h2 class="section-title mt-5 mb-4">📈 통계 추이</h2>
        <div class="row g-4">
            <div class="col-lg-12 col-md-12 mb-4">
                <div class="card shadow-sm p-3 h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-center align-items-center mb-3">
                            <select id="continentSelect" class="sort-dropdown me-2">
                                <option value="asia">아시아+오세아니아</option>
                                <option value="europe">유럽+아프리카</option>
                                <option value="namerica">북아메리카</option>
                                <option value="samerica">남아메리카</option>
                            </select>
                            <select class="sort-dropdown" id="c_SortSelect">
                                <option value="views">조회순</option>
                                <option value="rating">별점순</option>
                                <option value="likes">좋아요순</option>
                            </select>
                        </div>
                        <div id="chart" style="width: 100%; height: 500px;"></div>
                    </div>
                </div>
            </div>
        </div>

        <div class="text-center mt-5">
            <a href="../login/logoutAction.jsp" class="btn btn-outline-danger btn-lg px-4">
                <i class="bi bi-box-arrow-right me-2"></i>로그아웃
            </a>
        </div>
    </div>
</body>
</html>