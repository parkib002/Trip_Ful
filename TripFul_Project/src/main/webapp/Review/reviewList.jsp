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
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
<link rel="stylesheet" href="Review/carouselStyle.css">
<link rel="stylesheet" href="Review/ModalStyle.css">
<title>Insert title her</title>
<%
	//place_num 얻기
	String place_num=request.getParameter("place_num");	
	ReviewDao rdao=new ReviewDao();
	ReviewDto rdto=new ReviewDto();
	
	//System.out.println(place_num);
	//아이디, 로그인상태 세션값 받기
	String review_id=(String)session.getAttribute("id");
	String loginok=(String)session.getAttribute("loginok");
	
	//관광지 이름 얻기
	String place_name=rdao.getPlaceName(review_id);	
	
	//관광지 이름에 해당하는 리뷰리스트
	List<HashMap<String,String>> list=rdao.getPlaceList(place_name);
	
%>
<script type="text/javascript">
$(function() {
	
	   $("#modalBtn").click(function() {	  
		   
		// 폼 초기화 로직
		$("#modalform")[0].reset(); // 폼 필드 초기화
		
		// 버튼 텍스트를 '게시'로 변경
	    submitReviewBtn.text("게시");
		$("#file").val(""); //img 값 초기화
		$("#review_star").val(0); // 별점 값 0으로 초기화
		$("#myModal .star_rating .star").removeClass('on'); // 별점 UI 초기화
		$("#show").find(".img-wrapper").remove(); // 이미지 미리보기 제거
		$(".btn-upload").show(); // 이미지 업로드 버튼 다시 표시
		   
		if(<%=loginok!=null%>){
			openModal();
		}else{
			 swal.fire({
			        title: "로그인 후 이용 가능합니다", 
			        text: "로그인 페이지로 이동하시겠습니까?", 
			        type: "warning",
			        confirmButtonColor: "#3085d6",
			        cancelButtonColor: "#d33",
			        confirmButtonText: "네, 이동하겠습니다",
			        cancelButtonText: "아니요",  
			        showCancelButton: true
			        })
			          .then((result) => {
			          if (result.value) {
			              window.location = 'index.jsp?main=login/login.jsp';
			          }
			        })
		}
	});  	   	
	   loadReviews();
});

function loadReviews() {
	var place_num="<%=place_num%>";
	var review_id="<%=review_id%>";
	//console.log(place_num);
	$.ajax({
		type:"post",
		dataType:"json",
		url:"Review/insertApi.jsp",
		data:{"place_num":place_num},
		success:function(res){
			 var carouselItemsHtml = ""; // 각 카드를 직접 여기에 넣음
	            var reviews = res.reviews; // 리뷰 리스트
	            
	            if (reviews && reviews.length > 0) { // 리뷰 데이터가 있는지 확인
	            	
	            	var carouselItemsHtml = "";
	                var totCnt = reviews.length;
	                var totStar = 0;
	                var starCounts = { '5': 0, '4': 0, '3': 0, '2': 0, '1': 0 }; // 각 별점별 개수 저장
	                
	                reviews.forEach(function(r){	                   

	                    // 각 리뷰마다 카드생성	       
	                    

	                    var reviewCard = "";
	                    reviewCard += "<div class='item'>"; // Owl Carousel의 'item' 클래스
	                    reviewCard += "<div class='card h-100 p-3'>";
	                    reviewCard += "<div class='review-header d-flex justify-content-between align-items-center mb-2'>";
	                    reviewCard += "<b>" + r.author + "</b>";	                    
	                    reviewCard += "<div class='categorydate'>";
	                    reviewCard += "<span class='review_writeday'>" + r.date + "</span>&nbsp;&nbsp;";
	                    reviewCard += "<i class='bi bi-three-dots-vertical category' review_id='"+r.author+"'></i>";
	                    reviewCard += "<div class='dropdown-menu'>";

	                    //console.log(r.author, review_id);
	                    				if(r.author == review_id || review_id=="adminTripful" && r.read=="DB")
	                    					{
	                    					reviewCard += "<button type='button' class='delete-btn' review_id='" + r.author + "' review_idx='"+r.review_idx+"'>삭제</button>";               			        
	                    			        
	                    			        if(r.author == review_id){
	                    			        	reviewCard += "<button type='button' class='updateModal' review_idx='"+r.review_idx+"'>수정</button>";
	                    			        }	                    			        

	                    				}else if(r.author!=review_id && r.read=="DB" || r.read=="Google"){	                    					
	                    					reviewCard += "<button type='button' class='report'>신고</button>"
	                    				}
	                    reviewCard += "</div>";//카테고리 끝
	                    reviewCard += "</div></div>"; //날짜 리뷰헤더 끝        
	                    reviewCard += "<div class='star_rating2 mb-2'>";
	                    reviewCard += "<span>" + r.rating + "</span>&nbsp;&nbsp;";
						reviewCard += "<input type='hidden' id='rating' name='rating' value='"+r.rating+"'>"
	                    // 별점 아이콘 생성
	                    for (var i = 0; i < Number(r.rating); i++) {

	                        reviewCard += "<span class='rating on' rating='"+r.rating+"'></span>";

	                    }
	                    for (var i = 0; i < (5 - Number(r.rating)); i++) {
	                        reviewCard += "<span class='rating off'></span>"; // 비활성 별
	                    }
	                    reviewCard += "</div>";

	                    // 리뷰 이미지 (사진이 있을 경우에만 추가)
	                    if (r.photo !== "null" && r.photo !== "") {
	                        reviewCard += "<div class='review-image-container mb-2'>";
	                        reviewCard += "<img src='save/" + r.photo + "' class='photo' photo='"+r.photo+"'>";
	                        reviewCard += "</div>";
	                    }
	                    

	                    // 리뷰 텍스트
	                    reviewCard += "<p class='card-text'>" + r.text.replaceAll("\n", "<br>") + "</p>";
	                    if(r.read !=="DB" && r.read !== "")
                    	{
                    	reviewCard += "<div class='googlechk mb-2'>";
                    	reviewCard += "<span class='googlereview'>"+r.read+"</span>";
                    	reviewCard += "</div>";
                    	}
	                    reviewCard += "</div>"; // .card 끝
	                    reviewCard += "</div>"; // .item 끝
						
	                    carouselItemsHtml += reviewCard;
	                    
	                    // 별점 통계 계산
	                    totStar += r.rating;
	                    starCounts[r.rating]++; // 해당 별점 개수 증가
	                });
	            } else {
	                // 리뷰가 없을 경우 대체 메시지
	                carouselInnerHtml = "";
	                carouselInnerHtml += "<div class='item'>";
	                carouselInnerHtml += "    <div class='card p-3 m-2 text-center'>";
	                carouselInnerHtml += "        <p>아직 등록된 리뷰가 없습니다.</p>";
	                carouselInnerHtml += "    </div>";
	                carouselInnerHtml += "</div>";
	            }
	            
	            // ⭐⭐⭐ 여기부터 별점 통계 진행 바 업데이트 로직 ⭐⭐⭐
                var avgRating = totCnt > 0 ? (totStar / totCnt).toFixed(1) : 0.0;
                $("#avgRating").text(avgRating);
                $("#totReview").text(totCnt);

                for (let i = 5; i >= 1; i--) {
                    var percentage = totCnt > 0 ? (starCounts[i] / totCnt * 100).toFixed(0) : 0;
                    $('.progress-bar.' + getStarClass(i)).css('width', percentage + '%');
                    $('.progress-bar.' + getStarClass(i)).closest('.rating-row').find('.rating-percentage').text(percentage + '%');
                }
	            

	        	 // 기존 캐러셀 파괴 및 새 HTML 삽입 후 Owl Carousel 초기화
	            var owl = $('#reviewCarousel');
	            if (owl.data('owl.carousel')) { // Owl Carousel이 이미 초기화되어 있다면
	                owl.owlCarousel('destroy'); // 파괴	
	                $('#avgRating').text('0.0');
	                $('#totReview').text('0');
	                // 모든 진행 바 0%로 초기화
	                for (let i = 5; i >= 1; i--) {
	                    $('.progress-bar.' + getStarClass(i)).css('width', '0%');
	                    $('.progress-bar.' + getStarClass(i)).closest('.rating-row').find('.rating-percentage').text('0%');
	                }
	            }
	            owl.html(carouselItemsHtml); // HTML 내용 업데이트

	            // Owl Carousel 초기화
	            owl.owlCarousel({
	                loop: false, // 마지막에서 처음으로 돌아가지 않음 (원한다면 true로 변경)
	                margin: 10,
	                nav: false, // 이전/다음 버튼 표시
	                dots: false, // 점(인디케이터) 표시
	                responsive: { // 반응형 설정
	                    0: { // 0px 이상
	                        items: 1, // 1개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    },
	                    768: { // 768px 이상 (태블릿)
	                        items: 2, // 2개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    },
	                    992: { // 992px 이상 (데스크탑)
	                        items: 3, // 3개씩 보여줌
	                        slideBy: 1 // 1개씩 슬라이드
	                    }
	                }
	            });
	            
	            
	    },	    error: function(xhr, status, error) {
	        console.error("AJAX 실패:", status, error);
	        console.log("응답 텍스트:", xhr.responseText);
	        alert("리뷰 데이터를 불러오는 중 오류가 발생했습니다.");
	    }   
	});	
	
}	
	

</script>
</head>

<body>

	<!-- 모달 버튼 -->
<div>
	<button id="modalBtn">리뷰 작성</button>	
	<div class="rating-summary">
    <h4>별점 통계</h4>
    <div class="rating-row">
        <span class="rating-label">5점</span>
        <div class="progress-bar-container">
            <div class="progress-bar five-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">4점</span>
        <div class="progress-bar-container">
            <div class="progress-bar four-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">3점</span>
        <div class="progress-bar-container">
            <div class="progress-bar three-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">2점</span>
        <div class="progress-bar-container">
            <div class="progress-bar two-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="rating-row">
        <span class="rating-label">1점</span>
        <div class="progress-bar-container">
            <div class="progress-bar one-star" style="width: 0%;"></div>
        </div>
        <span class="rating-percentage">0%</span>
    </div>
    <div class="overall-rating">
        <strong>평균 별점: <span id="avgRating">0.0</span></strong> (<span id="totReview">0</span>개 리뷰)
    </div>
</div>
	
	<div class="container mt-3">
		<form class="updatefrm" enctype="multipart/form-data" >
		
			<div id="reviewCarousel" class="owl-carousel owl-theme">  
								
			</div>			
		</form>
	</div>
</div>
	







	<!-- 모달 창 -->
	<div id="myModal" class="modal">
		<form id="modalform" class="modalfrm" enctype="multipart/form-data">			
			<div align="center" class="modal-head">
			<input type="hidden" name="place_num" value="<%=place_num%>">
			<input type="hidden" name="review_idx" value="">
			<input type="hidden" name="photo" value="">
				<h4><%=place_name %></h4>
			</div>
			<div class="modal-content">
				<table>
					<tr>
						
						<td>
						<input type="hidden" name="review_id" value="<%=review_id%>">
						<b><%=review_id %></b><br> <br>
						</td>
					</tr>
					<tr>
						<td class="input-group">
						<input type="hidden" name="review_star" id="review_star" value="0">
							<div class="star_rating">
								​​<span class="star" value="1"> </span> 
								<span class="star" value="2"> </span> ​​
								<span class="star" value="3"> </span> ​​
								<span class="star" value="4"> </span> ​​ 
								<span class="star" value="5"> </span>
							</div></td>
					</tr>
					<tr>
						<td><textarea class="review_content" name="review_content"
								required="required" placeholder="이곳에 다녀온 경험을 자세히 공유해 주세요."></textarea></td>
					</tr>
					<tr>
						<td>
							<div id="show" >
								<label class="btn-upload">
									<i class="bi bi-camera-fill camera"></i>
									<input type="file" name="review_img" id="file">
								</label>
							</div>
							<br><br>
						</td>
					</tr>

				</table>
			</div>
			<div class="modal-foot">
				<button type="button" class="close" id="closeBtn">취소</button>										
				<button type="button" id="btn-write" class="">게시</button>
				
			</div>
		</form>
	</div>
	 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
	 <script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>
	 <script src="Review/JavaScript/ModalJs.js"></script>
	 <script src="Review/JavaScript/reviewListJs.js"></script>
</body>

</html>
