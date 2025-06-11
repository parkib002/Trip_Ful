<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="review.ReviewDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">


<title>모든 여행자 리뷰</title>
<%
ReviewDao rdao = new ReviewDao();

// 아이디, 로그인상태 세션값 받기 (리뷰 수정/삭제/신고 기능에 사용됨)
String review_id_session = (String) session.getAttribute("id"); // 세션 ID와 충돌 방지
String loginok = (String) session.getAttribute("loginok");

// 모든 리뷰 가져오기
List<HashMap<String, String>> list = rdao.getAllReviews();

%>
<script type="text/javascript">
	$(function() {
		// 리뷰 수정/삭제/신고 드롭다운 메뉴 토글
		$(document).on("click", ".category", function(e) {
			e.stopPropagation(); // 이벤트 버블링 방지
			$(this).next(".dropdown-menu").toggle();
		});

		$(document).on("click", function() {
			$(".dropdown-menu").hide();
		});

		// 수정 및 삭제 버튼 이벤트는 Review/JavaScript/reviewJs.js에서 처리될 것입니다.
		// reviewJs.js에 모달 관련 로직이 있다면 해당 스크립트 파일도 검토가 필요합니다.
	});
</script>
<style>
/* 그리드 카드 간격 */
.card1 {
	box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 카드에 그림자 효과 */
	transition: transform 0.2s; /* 호버 시 부드러운 전환 */
}

.card1:hover {
	transform: translateY(-5px); /* 호버 시 살짝 위로 */
}

.card1 .categorydate {
	display: flex; /* Flex 컨테이너로 설정 */
	justify-content: space-between;
	/* 요소들을 양 끝으로 벌립니다. (예: 날짜와 카테고리 아이콘) */
	align-items: center; /* 요소들을 수직 중앙 정렬합니다. */
	flex-wrap: nowrap;
	min-width: 100px;
}

/* 카테고리 아이콘 */
.card1 .category {
	background: rgba(0, 0, 0, 0); /* 투명 배경 */
    color: #CCC; /* 아이콘 색상 */
    border: none;
    
    padding: 3.3px 8px;
    border-radius: 50%; /* 원형 버튼 */    
    cursor: pointer;
    pointer-events: all; /* 버튼 클릭 가능하게 설정 */
    transition: background-color 0.3s ease; /* 호버 효과 */ 
  	flex-shrink:0;
      
    width: 32px; /* 버튼의 고정 너비 */
    height: 32px; /* 버튼의 고정 높이 */
}
.review_writeday{
	color: #ccc;	
	min-width: 90px;
}
.card1 .category:hover {
	background: rgba(0, 0, 0, 0.4);
}

.review-image-container {
	width: 100%;
	height: 200px; /* 이미지 컨테이너 높이 고정 */
	overflow: hidden; /* 넘치는 부분 숨김 */
	display: flex;
	justify-content: center;
	align-items: center;
	background-color: #f8f9fa; /* 배경색 추가 */
	border-radius: 0.25rem; /* 카드 테두리 반경과 일치 */
}

.review-image-container img {
	width: 100%;
	height: 100%;
	object-fit: cover; /* 이미지가 컨테이너를 채우도록 조절 */
}
/* 별점 아이콘 스타일 (Bootstrap Icons i 태그에 적용) */
.star_rating2 .bi-star, .star_rating2 .bi-star-fill, .star_rating2 .bi-star-half
	{
	font-size: 1.2em; /* 별 아이콘 크기 조절 */
}

.star_rating2 .bi-star {
	color: #ccc; /* 빈 별 색상 */
}

.star_rating2 .bi-star-fill, .star_rating2 .bi-star-half {
	color: #ffc107; /* 채워진 별 색상 (노란색) */
}

.card-text {
	/* 리뷰 내용이 너무 길어지지 않도록 최대 높이 설정 및 스크롤 */
	max-height: 100px;
	overflow-y: auto;
	word-wrap: break-word; /* 긴 단어 줄바꿈 */
}

.card1 .dropdown-menu {
	position: absolute;
	/* top: calc(100% + 5px); /* category 아이콘 아래에 위치 (아이콘 높이 + 여백) */
	top: 45px;
	right: 35px; /* category 아이콘 옆에 위치 */
	background-color: #fff;
	border: 1px solid #ddd;
	box-shadow: 0 2px 5px rgba(0, 0, 0, 0.2);
	z-index: 1000; /* 기존보다 더 높게 */
	min-width: 60px; /* 메뉴 너비 조정 */
	border-radius: 4px;
	overflow: hidden;
}

.card1 .dropdown-menu button {
	display: block;
	width: 100%;
	padding: 8px 12px;
	text-align: left;
	border: none;
	background: none;
	cursor: pointer;
	font-size: 14px;
	color: #333;
	pointer-events: all;
}

.card1 .dropdown-menu button:hover {
	background-color: #f0f0f0;
}
</style>
</head>

<body>
	<div class="container mt-5">
		<h3 class="text-center mb-4">모든 여행자 리뷰</h3>

		<div class="container mt-3">
			<form class="updatefrm" enctype="multipart/form-data">
				<div class="row row-cols-1 row-cols-md-2 row-cols-lg-3 g-4">
					<%
					
					if (list != null && !list.isEmpty()) {
					%>
					<%
					for (HashMap<String, String> r : list) {
						String currentPlaceNum = r.get("place_num"); // DAO에서 "place_num" 키로 값을 넘겼는지 확인
						String placeName = "알 수 없는 여행지"; // 기본값 설정
						
						SimpleDateFormat parse=new SimpleDateFormat("yyyy-MM-dd");
						Date parsedate= parse.parse(r.get("date"));
						
						SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
						String date=sdf.format(parsedate);
						
						if (currentPlaceNum != null && !currentPlaceNum.trim().isEmpty()) {
							String fetchedPlaceName = rdao.getPlaceName(currentPlaceNum);
							if (fetchedPlaceName != null && !fetchedPlaceName.trim().isEmpty()) {
						placeName = fetchedPlaceName;
							}
						}
					%>
					<div class="col">
						<div class='card1 h-100 p-3'>
							<div
								class='review-header d-flex justify-content-between align-items-center mb-2'>
								<b><%=r.get("author") != null ? r.get("author") : "익명"%></b>
								<%
								if (r.get("read") != null && !r.get("read").equals("DB") && !r.get("read").trim().isEmpty()) {
								%>
								<div class='googlechk mb-2'>
									<span class='googlereview'><%=r.get("read")%></span>
								</div>
								<%
								}
								
								%>
								<div class="categorydate">
									<span class='review_writeday'><%=date != null ? date : ""%></span>&nbsp;&nbsp;
									<i class='bi bi-three-dots-vertical category'
										review_id='<%=r.get("author") != null ? r.get("author") : ""%>'></i>
									<%-- 세션 ID와 리뷰 작성자 ID 비교 --%>


									<div class='dropdown-menu'>
										<%
										if (review_id_session.equals(r.get("author")) || loginok.equals("admin")) {
										%>
										<button type="" class="delete-btn"
											review_id='<%=r.get("author")%>'
											review_idx='<%=r.get("review_num")%>'>삭제</button>

										<%
										if (review_id_session.equals(r.get("author"))) {
										%>
										<button type='button' class='updateModal'
											review_idx='<%=r.get("author")%>'>수정</button>
										<%
										}

										} else if (!review_id_session.equals(r.get("author"))) {
										%>
										<button type='button' class='report'
											review_idx='<%=r.get("review_num")%>' loginok='<%=loginok%>'>신고</button>
										<%
										}
										%>
									</div>
								</div>
							</div>
							<div class='star_rating2 mb-2'>
								<span><%=r.get("rating") != null ? r.get("rating") : "0.0"%></span>&nbsp;&nbsp;
								<%
								double doubleRating = 0.0;
								String ratingStr = r.get("rating");
								if (ratingStr != null && !ratingStr.trim().isEmpty()) {
									try {
										doubleRating = Double.parseDouble(ratingStr);
									} catch (NumberFormatException e) {
										System.err.println("Invalid rating format: " + ratingStr);
									}
								}
								// 별 아이콘을 위해 int로 변환 및 반쪽 별 계산
								int filledStars = (int) Math.floor(doubleRating);
								int halfStar = (doubleRating - filledStars >= 0.5) ? 1 : 0;
								int emptyStars = 5 - filledStars - halfStar;
								%>
								<%
								for (int i = 0; i < filledStars; i++) {
								%>
								<i class='bi bi-star-fill'></i>
								<%-- 채워진 별 아이콘 --%>
								<%
								}
								%>
								<%
								if (halfStar == 1) {
								%>
								<i class='bi bi-star-half'></i>
								<%-- 반쪽 별 아이콘 --%>
								<%
								}
								%>
								<%
								for (int i = 0; i < emptyStars; i++) {
								%>
								<i class='bi bi-star'></i>
								<%-- 빈 별 아이콘 --%>
								<%
								}
								%>
							</div>
							<%
							String reviewPhoto = r.get("photo");
							if (reviewPhoto != null && !reviewPhoto.equals("null") && !reviewPhoto.trim().isEmpty()) {
							%>
							<div class='review-image-container mb-2'>
								<img src='save/<%=reviewPhoto%>' class='img-fluid rounded'>
							</div>
							<%
							}
							%>
							<p class='card-text'>
								<%
								String reviewText = r.get("text");
								if (reviewText != null) {
									out.print(reviewText.replaceAll("\n", "<br>"));
								} else {
									out.print(""); // review_content가 null일 경우 빈 문자열 출력
								}
								%>
							</p>

							<hr class="my-3">
							<div class="text-end">
								<small class="text-muted"> 여행지: **<%=placeName%>** <%
								if (currentPlaceNum != null && !currentPlaceNum.trim().isEmpty() && !placeName.equals("알 수 없는 여행지")) {
								%>
									<a
									href="index.jsp?main=place/detailPlace.jsp?place_num=<%=currentPlaceNum%>"
									class="btn btn-sm btn-outline-info ms-2">자세히 보기</a> <%
 }
 %>
								</small>
							</div>
						</div>
					</div>
					<%
					}
					%>
					<%
					} else {
					%>
					<div class='col-12'>
						<div class='card p-3 m-2 text-center'>
							<p>아직 등록된 리뷰가 없습니다.</p>
						</div>
					</div>
					<%
					}
					%>
				</div>
			</form>
		</div>
	</div>

	<%-- <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script> --%>
	<%-- <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script> --%>
	<%-- <script src="Review/JavaScript/ModalJs.js"></script> --%>
	<script src="Review/JavaScript/reviewJs.js"></script>
</body>

</html>