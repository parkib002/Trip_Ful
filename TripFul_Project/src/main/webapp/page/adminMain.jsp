<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
	BoardSupportDao supportDao=new BoardSupportDao();
    // 세션에서 관리자 이름과 로그인 상태를 가져옵니다.
    String adminName = (String) session.getAttribute("name");
    String loginStatus = (String) session.getAttribute("loginok");
    // 로그인 상태가 'admin'이 아니면 인덱스 페이지로 리다이렉트합니다.
    if (loginStatus == null || !loginStatus.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
    // 주요 현황 요약 데이터 (예시 데이터)
    // TODO: 실제 데이터베이스에서 해당 정보를 조회하도록 로직을 구현해야 합니다.
    int newMembersToday = 12;
    int newMembersThisWeek = 78;
    int newMembersThisMonth = 320;
    int recentReviewsCount = 45;
    List<String> popularDestinations = Arrays.asList();
    int unansweredInquiriesCount = supportDao.getUnansweredTotalCount();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="
https://cdn.jsdelivr.net/npm/echarts@5.6.0/dist/echarts.min.js
"></script>
    <title>관리자 메인 페이지</title>
    <style>
        body {
            font-family: 'Inter', sans-serif; /* Google Font Inter 적용 */
        }
        .admin-banner {
            background: linear-gradient(135deg, #007BFF, #00B3D4); /* 그라데이션 각도 변경 */
            color: white;
            padding: 50px 20px; /* 패딩 조정 */
            text-align: center;
            border-radius: 0 0 25px 25px; /* 하단 모서리 둥글게 */
            margin-bottom: 30px; /* 하단 마진 추가 */
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
        }
        .admin-banner h1 {
            font-weight: 700; /* 제목 굵기 */
        }
        .admin-section {
            padding: 20px; /* 기존 40px 20px에서 변경 */
        }
        .card {
            border: none; /* 카드 테두리 제거 */
            border-radius: 15px; /* 카드 모서리 둥글게 */
            transition: transform 0.2s ease-in-out, box-shadow 0.2s ease-in-out;
            overflow: hidden; /* 내부 컨텐츠가 모서리를 넘지 않도록 */
        }
        .card:hover {
            transform: translateY(-5px); /* 위로 살짝 이동하는 효과 */
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15); /* 호버 시 그림자 강화 */
        }
        .card-icon {
            font-size: 2.5rem; /* 아이콘 크기 조정 */
            color: #007BFF; /* 기본 아이콘 색상 */
        }
        .summary-card .card-icon { /* 요약 카드 아이콘 색상 다르게 */
            color: #28A745;
        }
        .summary-card .display-6, .summary-card .h5 { /* 요약 카드 숫자/텍스트 크기 */
            font-weight: 600;
        }
        .list-group-item {
            border-left: none;
            border-right: none;
            padding-left: 0;
            padding-right: 0;
        }
        .list-group-item:first-child {
            border-top: none;
            border-top-left-radius: 0;
            border-top-right-radius: 0;
        }
        .list-group-item:last-child {
            border-bottom: none;
            border-bottom-left-radius: 0;
            border-bottom-right-radius: 0;
        }
        .btn-primary {
            background-color: #007BFF;
            border-color: #007BFF;
            transition: background-color 0.2s ease, border-color 0.2s ease;
        }
        .btn-primary:hover {
            background-color: #0056B3;
            border-color: #0056B3;
        }
        .section-title {
            font-size: 1.8rem;
            font-weight: 600;
            margin-bottom: 25px;
            color: #333;
            text-align: center;
        }
        .sort-dropdown {
 			padding: 0.35rem 0.5rem;
		 	border: 2px solid #2196F3;
  			border-radius: 0.5rem;
  			font-size: 1rem;
 		 	color: #2196F3;
		  	background-color: #fff;
		  	cursor: pointer;
 		 	transition: all 0.3s ease;
		}
		
		.sort-dropdown:focus {
 			outline: none; /* 기본 outline 제거 */
  			border-color: #2196f3; /* 테두리를 원래 색으로 고정 */
  			box-shadow: 0 0 0 2px rgba(33, 150, 243, 0.2); /* 선택적으로 포커스 효과 */
		}
        
    </style>
    <script type="text/javascript">
        
    let currentXAxisData = ['이름', '영희', '민수', '지수']; // 초기 데이터
    let currentSeriesData = [70, 80, 100, 30];
    let currentChartType = 'bar'; // 기본 차트 타입 (예: 'bar' 또는 'line')
    
    $(function() {
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
                    if(res.length > 0) {
                        console.log(res[0].place_name);
                    }
                    $('#popularList').empty();
                    $.each(res, function(index, item) {
                        var rank = index + 1;
                        var name = item.place_name;
                        var value = 0;
                        if (sort === 'views') {
                            value = item.place_count+"회";
                        } else if (sort === 'rating') {
                            value = item.avg_rating !== null ? item.place_rating.toFixed(1)+"점" : "0.0";
                        } else if (sort === 'likes') {
                            value = item.place_like+"개";
                        }

                        var li = '<li class="list-group-item d-flex justify-content-between align-items-center list" id='+item.place_num+'>'
                               + rank + '. ' + name+"("+item.country_name+")"
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
        // 페이지 최초 로딩 시 인기 리스트 불러오기
        loadPopularList(currentSort);
        $('#sortSelect').on('change', function() {
            currentSort = $(this).val();
            loadPopularList(currentSort);
        });
        
        
        
        //document.getElementById("drawLine").addEventListener('click', drawChart);
        //document.getElementById("drawBar").addEventListener('click', drawChart);
        
        $("#c_sortSelect").change(function(){
        	
        	 if ($(this).val() === 'views') {
                 currentXAxisData = ['1월', '2월', '3월', '4월','5월','6월','7월','8월','9월','10월','11월','12월'];
                 currentSeriesData = [100, 120, 150, 130,80,30,90,125,180,200,140,150,130];
             } else if ($(this).val() === 'new_review') {
                 currentXAxisData = ['A', 'B', 'C', 'D','A', 'B', 'C', 'D','A', 'B', 'C', 'D','A', 'B', 'C', 'D','A', 'B', 'C', 'D','A', 'B', 'C', 'D'];
                 currentSeriesData = [90, 110, 80, 140,90, 110, 80, 140,90, 110, 80, 140,90, 110, 80, 140,90, 110, 80, 140,90, 110, 80, 140];
             } else if ($(this).val() === 'new_member') {
                 currentXAxisData = ['X', 'Y', 'Z'];
                 currentSeriesData = [50, 70, 60];
             }
        	 drawChart(currentXAxisData, currentSeriesData, currentChartType);
        })
        
    });
    
    $(document).on("click",".list",function(){
    	
    	var num=$(this).attr("id");
    	
		location.href="index.jsp?main=place/detailPlace.jsp?place_num="+num;    	
    })
    
    function drawChart(xAxisData, seriesData, chartType) {
        var myChart = echarts.init(document.getElementById('chart'));
        let option = {
            xAxis: {
                type: 'category',
                data: xAxisData // 인자로 받은 x축 데이터
            },
            yAxis: {
                type: 'value'
            },
            series: [{
                data: seriesData, // 인자로 받은 y축(값) 데이터
                type: chartType // 인자로 받은 차트 타입
            }]
        };
        myChart.setOption(option);
    }
    
    </script>
</head>
<body>
<div class="admin-banner">
    <h1 class="display-4">Tripful 관리자 페이지</h1>
    <p class="lead">안녕하세요, <strong><%= adminName != null ? adminName : "관리자" %></strong>님! 사이트 현황을 한눈에 확인하세요.</p>
</div>
<div class="container admin-section">
    <!-- 주요 현황 요약 섹션 시작 -->
    <h2 class="section-title mb-4">📈 주요 현황 요약</h2>
    <div class="row g-4 mb-5">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card summary-card shadow-sm p-3 h-100">
                <div class="card-body text-center">
                    <div class="card-icon mb-3"><i class="bi bi-person-plus-fill"></i></div>
                    <h5 class="card-title mb-2">신규 가입 회원</h5>
                    <!-- TODO: 실제 데이터로 변경 필요 -->
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
                    <!-- TODO: 실제 데이터로 변경 필요 -->
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
                    <!-- TODO: 실제 데이터로 변경 필요 -->
                    <ul class="list-group list-group-flush" id="popularList">
                        <li class="list-group-item d-flex justify-content-between align-items-center">
                            <span class="badge bg-primary rounded-pill"></span> <!-- 예시 조회수 -->
                        </li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card summary-card shadow-sm p-3 h-100">
                <div class="card-body text-center">
                    <div class="card-icon mb-3"><i class="bi bi-question-circle-fill"></i></div>
                    <h5 class="card-title mb-2">미답변 문의</h5>
                    <!-- TODO: 실제 데이터로 변경 필요 -->
                    <a href="<%=request.getContextPath()%>/index.jsp?main=board%2FboardList.jsp&sub=support.jsp&filter=unanswered&currentPage=1"
                    style="text-decoration: none;"><p class="display-6 text-danger"><strong><%= unansweredInquiriesCount %></strong></p></a>
                    <p class="card-text text-muted">건</p>
                </div>
            </div>
        </div>
    </div>
    <!-- 주요 현황 요약 섹션 끝 -->
    <h2 class="section-title mb-4">⚙️ 핵심 기능 관리</h2>
    <div class="row g-4">
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card shadow-sm p-3 text-center h-100">
                <div class="card-body">
                    <div class="card-icon mb-3"><i class="bi bi-geo-alt-fill"></i></div>
                    <h5 class="card-title">여행지 관리</h5>
                    <p class="card-text text-muted small mb-3">등록된 여행지를 관리합니다.</p>
                    <a href="index.jsp?main=place/selectPlace.jsp" class="btn btn-primary w-100">이동</a>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card shadow-sm p-3 text-center h-100">
                <div class="card-body">
                    <div class="card-icon mb-3"><i class="bi bi-chat-left-text-fill"></i></div>
                    <h5 class="card-title">리뷰 관리</h5>
                    <p class="card-text text-muted small mb-3">사용자 리뷰를 관리합니다.</p>
                    <a href="index.jsp?main=Review/allReviews.jsp" class="btn btn-primary w-100">이동</a>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card shadow-sm p-3 text-center h-100">
                <div class="card-body">
                    <div class="card-icon mb-3"><i class="bi bi-people-fill"></i></div>
                    <h5 class="card-title">회원 관리</h5>
                    <p class="card-text text-muted small mb-3">회원 정보 및 권한을 관리합니다.</p>
                    <a href="index.jsp?main=login/memberList.jsp" class="btn btn-primary w-100">이동</a>
                </div>
            </div>
        </div>
        <div class="col-lg-3 col-md-6 mb-4">
            <div class="card shadow-sm p-3 text-center h-100">
                <div class="card-body">
                    <div class="card-icon mb-3"><i class="bi bi-megaphone-fill"></i></div>
                    <h5 class="card-title">공지사항 관리</h5>
                    <p class="card-text text-muted small mb-3">공지사항을 등록하고 수정합니다.</p>
                    <a href="index.jsp?main=board/boardList.jsp&sub=notice.jsp" class="btn btn-primary w-100">이동</a>
                </div>
            </div>
        </div>
    </div>
    <h2 class="section-title mb-4">📈 통계 추이</h2>
    <div class="row g-4">
        <div class="col-lg-12 col-md-12 mb-4">
            <div class="card shadow-sm p-3 text-center h-100">
                <div class="card-body">
                    <div class="card-icon mb-3"><i class="bi bi-bar-chart-fill"></i></div>
                    <h5 class="card-title"><select id="c_sortSelect" class="sort-dropdown">
        			<option value="views">리뷰 조회수</option>
       				<option value="new_review">리뷰 생성 수</option>
       				<option value="new_member">신규 가입자</option>
        			</select></h5>
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