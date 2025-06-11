<%@page import="java.time.LocalDate"%>
<%@page import="login.LoginDto"%>
<%@page import="login.LoginDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link
	href="https://fonts.googleapis.com/css2?family=Dongle&family=Gaegu&family=Hi+Melody&family=Nanum+Myeongjo&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet"
	href="<%=request.getContextPath()%>/login/myPageDesign.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>

<title>내 정보</title>
</head>
<body>
	<%
	String id = request.getParameter("id");
	String s_id = null;
	String loginok = null;
	LoginDao dao = new LoginDao();
	LoginDto dto = dao.getOneMember(id);

	LocalDate now = LocalDate.now();
	String localeYear = now.toString().split("-")[0];
	int age = Integer.parseInt(localeYear) - Integer.parseInt(dto.getBirth().substring(0, 2)) - 1900;
	String age1 = age + "";
	age1 = age1.replaceAll("^1", "");
	age1 = age1.replaceAll("[1-9]$", "0 대");

	if (session.getAttribute("id") != null) {
		s_id = (String) session.getAttribute("id");
		loginok = (String) session.getAttribute("loginok");
	}
	%>
	<%-- [수정됨] 사이드바 메뉴에 data-target 속성 추가 --%>
	<aside class="side-bar">
		<section class="side-bar__icon-box">
			<section class="side-bar__icon-1">
				<div></div>
				<div></div>
				<div></div>
			</section>
		</section>
		<ul>
			<li><span><i class="fa-solid fa-earth-americas"></i>&nbsp;<%=dto.getName()%></span>
				<ul>
					<li><a href="#" data-target=".MyInfo">내 정보</a></li>
					<li><a href="#" data-target=".MyReview">내 리뷰</a></li>
					<li><a href="#" data-target=".WishList">위시리스트</a></li>
					<%-- 현재 '내 코스' 섹션이 없으므로 링크는 비워두거나 나중에 해당 섹션을 추가할 수 있습니다. --%>
					<li><a href="#" data-target=".MyQuestion">내 질문</a></li>
				</ul></li>
		</ul>
	</aside>
	<div class="container mt-3">
		<div class="MyInfo">
			<h1>내 정보</h1>
			<ul>
				<li>이름 : <%=dto.getName()%></li>
				<li>연령대 : <%=age1%>
				</li>
				<li>이메일 : <%=dto.getEmail()%></li>
				<li>아이디 : <%=id%></li>
			</ul>
			<div class="update-btn">
				<%
				if (id.equals(s_id) || (loginok != null && loginok.equals("admin"))) {
				%><button class="btn btn-info"
					onclick="location.href='http://localhost:8080/TripFul_Project/index.jsp?main=login/changeForm.jsp?userid=<%=id%>'">정보
					수정</button>
				<button class="btn btn-danger" onclick="btnDel()">회원 탈퇴</button>
				<%
				}
				%>
			</div>
		</div>
		<div class="MyReview">
			<h1>내 리뷰</h1>

			<div class="asia">
				<h2>아시아</h2>
				<div class="owl-carousel"></div>
			</div>

			<div class="namerica">
				<h2>북미</h2>
				<div class="owl-carousel"></div>
			</div>

			<div class="samerica">
				<h2>남미</h2>
				<div class="owl-carousel"></div>
			</div>

			<div class="europe">
				<h2>유럽</h2>
				<div class="owl-carousel"></div>
			</div>
		</div>

		<div class="WishList">
			<h1>위시리스트</h1>
			<div class="asia-wishlist">
				<h3>아시아 위시리스트</h3>
				<div class="owl-carousel"></div>
			</div>
			<div class="namerica-wishlist">
				<h3>북미 위시리스트</h3>
				<div class="owl-carousel"></div>
			</div>
			<div class="samerica-wishlist">
				<h3>남미 위시리스트</h3>
				<div class="owl-carousel"></div>
			</div>
			<div class="europe-wishlist">
				<h3>유럽 위시리스트</h3>
				<div class="owl-carousel"></div>
			</div>
		</div>

		<div class="MyQuestion">
    <h1>내 질문 </h1>
    <select id="answerFilter" name="filter" onchange="filterMyList()"
        style="max-width: 120px;" class="form-control">
        <option value="all">전체</option>
        <option value="answered">답변 완료</option>
        <option value="unanswered">미답변</option>
    </select>
    <br>
    <table class="table table-hover notice-table">
        <thead>
            <tr>
                <th scope="col" style="width: 8%;">번호</th>
                <th scope="col" style="width: 12%; text-align: center;">문의유형</th>
                <th scope="col" style="width: 30%;">제목</th>
                <th scope="col" style="width: 15%; text-align: center;">작성자</th>
                <th scope="col" style="width: 15%;">작성일</th>
                <th scope="col" style="width: 10%; text-align: center;">상태</th>
            </tr>
        </thead>
        <tbody>
            </tbody>
    </table>
</div>
	</div>


	<script type="text/javascript">
	
	// myPage.jsp의 <script> 태그 안에 추가
	let allQnaList = []; // 서버에서 가져온 모든 Q&A 데이터를 저장할 배열
	
	
	// 내 질문 (Q&A)을 로드하고 표시하는 함수
	function loadMyQuestions() {
	    var userId = "<%=id%>";
	    $.ajax({
	        type: "post",
	        dataType: "json",
	        url: "<%=request.getContextPath()%>/board/myQna.jsp",
	        data: { "id": userId },
	        success: function(res) {
	            console.log("Q&A 응답 데이터:", res);
	            allQnaList = res.qna || [];
	            },
	        error: function(xhr, status, error) {
	            console.error("Q&A 데이터를 불러오는 중 오류 발생:", status, error);
	            console.log("응답 텍스트:", xhr.responseText);
	            var tableBody = $('.notice-table tbody');
	            tableBody.empty();
	            tableBody.append('<tr><td colspan="6" class="text-center text-danger">질문을 불러오는데 실패했습니다.</td></tr>');
	        }
	    });
	}
	
	// 답변 필터링 함수 (기존 HTML에 추가된 select 태그와 연동)
	function filterMyList() { 
	    var filterValue = $('#answerFilter').val(); 
	    
	    // allQnaList에서 필터링할 데이터를 선택
	    let filteredQna = [];

	    if (filterValue === 'all') {
	        filteredQna = allQnaList;
	        
	    } else if (filterValue === 'answered') {
	        filteredQna = allQnaList.filter(qna => qna.is_answered === true);
	        
	    } else if (filterValue === 'unanswered') {
	        filteredQna = allQnaList.filter(qna => qna.is_answered === false);
	    }
	    displayMyList(filteredQna);
	}
	
	function displayMyList(filteredQna){
		$(".notice-table>tbody").empty();
		for(var i = 0; i < filteredQna.length; i++){
        	var html = "<tr><td>"+filteredQna[i].qna_idx+"</td><td>"+filteredQna[i].qna_category+"</td>";
        	html += "<td>"+filteredQna[i].qna_title+"</td>";
        	html += "<td>"+filteredQna[i].qna_writer+"</td>";
        	html += "<td>"+filteredQna[i].qna_writeday+"</td>";
        	if(filteredQna[i].is_answered === true){
        		html += "<td style='color:green'>답변완료</td>";
        	}
        	else{
        		html += "<td style='color:red'>답변없음</td>";
        	}
        	$(".notice-table>tbody").append(html);
        }
	}

	
    function btnDel(){
    	if(confirm("정말로 삭제하시겠습니까?")){
    		var pw = prompt("삭제하려면 비밀번호를 입력하세요.");
    		var userId = "<%=id%>";
    		$.ajax({
    			type:"post",
    			dataType:"html",
    			url:"login/deleteMember.jsp",
    			data:{"id":userId,
    				"pw":pw},
    			success:function(res){
    				console.log(pw);
    				if(res.trim()=="true"){
    					
    					alert("회원삭제 되었습니다.");
    					window.location.href="./index.jsp";
    				}
    				else{
    					alert("비밀번호가 틀렸습니다.");
    				}
    			}
    		})
    		
    	}
    }
    
    $(function() {
    	
    	loadMyQuestions();
		displayMyList(allQnaList);
        
        $('.side-bar ul ul a').on('click', function(e) {
            // data-target 속성이 있는 링크에만 작동
            var targetSelector = $(this).data('target');
            if (targetSelector) {
                e.preventDefault(); // a 태그의 기본 동작(페이지 이동) 방지
                
                var targetElement = $(targetSelector);

                // 해당 섹션이 페이지에 존재할 경우에만 스크롤
                if (targetElement.length) {
                    $('html, body').animate({
                        scrollTop: targetElement.offset().top
                    }, 10); // 0.5초 동안 부드럽게 스크롤
                }
            }
        });

        // 리뷰 로드 함수 호출
        loadMyReviews('asia');
        loadMyReviews('namerica');
        loadMyReviews('samerica');
        loadMyReviews('europe');

        // 위시리스트 로드 함수 호출
        loadWishList('asia');
        loadWishList('namerica');
        loadWishList('samerica');
        loadWishList('europe');
    });

    // 내 리뷰를 로드하는 함수
    function loadMyReviews(continent) {
        var userId = "<%=id%>";
        var loginok = "<%=loginok%>";
        var currId = "<%=s_id%>";

        var targetDivClass;
        switch(continent) {
            case 'asia': targetDivClass = '.asia .owl-carousel'; break;
            case 'namerica': targetDivClass = '.namerica .owl-carousel'; break;
            case 'samerica': targetDivClass = '.samerica .owl-carousel'; break;
            case 'europe': targetDivClass = '.europe .owl-carousel'; break;
            default: console.error("알 수 없는 대륙:", continent); return;
        }

        $.ajax({
            type: "post",
            dataType: "json",
            url: "login/myReview.jsp",
            data: { "id": userId, "continent": continent },
            success: function(res) {
                var carouselItemsHtml = "";
                var reviews = res.reviews;

                if (reviews && reviews.length > 0) {
                    reviews.forEach(function(r) {
                        var reviewCard = "";
                        reviewCard += "<div class='item'>";
                        reviewCard += "<div class='card h-100 p-3'>";
                        reviewCard += "<div class='review-header d-flex justify-content-between align-items-center mb-2'>";
                        reviewCard += "<b>" + r.review_id + "</b>";
                        reviewCard += "<div class='categorydate'>";
                        reviewCard += "<span class='review_writeday'>" + r.review_writeday + "</span>&nbsp;&nbsp;";
                        reviewCard += "<i class='bi bi-three-dots-vertical review_category' review_id='"+r.review_id+"'></i>";
                        reviewCard += "<div class='dropdown-menu'>";
                        if(r.review_id == currId || (loginok !== 'null' && loginok === "admin")) {
                        	console.log(r.review_id);
                        	console.log(userId);
                            reviewCard += "<button type='button' class='delete-btn' review_id='" + r.review_id + "' review_idx='"+r.review_idx+"'>삭제</button>";
                        } 
                        else {
                            reviewCard += "<button type='button' class='report' review_idx='"+r.review_idx+"' loginok='"+loginok+"'>신고</button>";
                        }
                        reviewCard += "</div></div></div>";

                        reviewCard += "<div class='star_rating2 mb-2'>";
                        reviewCard += "<span>" + r.review_star + "</span>&nbsp;&nbsp;";
                        reviewCard += "<input type='hidden' id='rating' name='rating' value='"+r.review_star+"'>";
                        for (var i = 0; i < Number(r.review_star); i++) {
                            reviewCard += "<span class='rating on'></span>";
                        }
                        for (var i = 0; i < (5 - Number(r.review_star)); i++) {
                            reviewCard += "<span class='rating off'></span>";
                        }
                        reviewCard += "</div>";
                        var photos = [];
                        if (r.review_img && r.review_img !== "null" && r.review_img !== "") photos.push(r.review_img);
                        reviewCard += "<div class='img-con mb-2'>";
                        if (photos.length > 0) {
                            photos.forEach(function(photoUrl) {
                                reviewCard += "<img src='save/" + photoUrl + "' class='photo'>";
                            });
                        }
                        reviewCard += "</div>";
                        reviewCard += "<p class='card-text'>" + r.review_content.replaceAll("\n", "<br>") + "</p>";
                        reviewCard += "</div>";
                        reviewCard += "</div>";
                        carouselItemsHtml += reviewCard;
                    });
                } else {
                    carouselItemsHtml = "<div class='item'><div class='card p-3 m-2 text-center'><p>아직 등록된 " + continent + " 리뷰가 없습니다.</p></div></div>";
                }

                var owl = $(targetDivClass);
                if (owl.data('owl.carousel')) {
                    owl.owlCarousel('destroy');
                }
                owl.html(carouselItemsHtml);
                owl.owlCarousel({
                    loop: false, margin: 10, nav: false, dots: false,
                    responsive: { 0: { items: 1, slideBy: 1 }, 768: { items: 2, slideBy: 1 }, 992: { items: 3, slideBy: 1 } }
                });
            },
            error: function(xhr, status, error) {
                console.error("AJAX 실패:", status, error);
                console.log("응답 텍스트:", xhr.responseText);
                alert("리뷰 데이터를 불러오는 중 오류가 발생했습니다.");
                var targetDiv = $(targetDivClass);
                if (targetDiv.data('owl.carousel')) { targetDiv.owlCarousel('destroy'); }
                targetDiv.html("<div class='item'><div class='card p-3 m-2 text-center'><p>리뷰를 불러오는데 실패했습니다.</p></div></div>");
            }
        });
    }

    // 위시리스트를 로드하는 함수
   // [수정됨] 위시리스트를 로드하는 함수 (장소 이름에 상세 페이지 링크 추가)
function loadWishList(continent) {
    var userId = "<%=id%>";

    var targetDivClass;
    switch(continent) {
        case 'asia': targetDivClass = '.asia-wishlist .owl-carousel'; break;
        case 'namerica': targetDivClass = '.namerica-wishlist .owl-carousel'; break;
        case 'samerica': targetDivClass = '.samerica-wishlist .owl-carousel'; break;
        case 'europe': targetDivClass = '.europe-wishlist .owl-carousel'; break;
        default: console.error("알 수 없는 대륙:", continent); return;
    }

    $.ajax({
        type: "post",
        dataType: "json",
        url: "login/myWishList.jsp",
        data: { "id": userId, "continent": continent },
        success: function(res) {
            var carouselItemsHtml = "";
            var wishlistItems = res.wishlist;

            if (wishlistItems && wishlistItems.length > 0) {
                wishlistItems.forEach(function(place) {
                    let decodedContent = $("<textarea/>").html(place.place_content).text();
                    let processedContent = $(`<div>${decodedContent}</div>`).text().trim();
                    processedContent = processedContent.length > 100 ? processedContent.substring(0, 100) + '...' : processedContent;

                    carouselItemsHtml += "<div class='item'>";
                    carouselItemsHtml += "<div class='card h-100 p-3'>";
                    
                    let imageUrl = place.place_img && place.place_img.split(',').length > 0 ? place.place_img.split(',')[0] : '';
                    imageUrl = imageUrl.replace('/TripFul_Project', ''); 
                    
                    carouselItemsHtml += "<img src='<%=request.getContextPath()%>"
													+ imageUrl
													+ "'class='card-img-top' alt='"
													+ place.place_name + "'>";
											carouselItemsHtml += "    <div class='card-body'>";

											// [수정됨] 상세 페이지로 이동할 URL을 생성하고 a 태그로 장소 이름을 감싸줍니다.
											var detailUrl = "index.jsp?main=place/detailPlace.jsp&place_num="
													+ place.place_num;
											carouselItemsHtml += "<h5 class='card-title'><a href='" + detailUrl + "'>"
													+ place.place_name
													+ "</a></h5>";

											carouselItemsHtml += "<p class='card-text'><small class='text-muted'>"
													+ place.country_name
													+ " - "
													+ place.continent_name
													+ "</small></p>";

											if (processedContent
													&& processedContent !== place.place_name) {
												carouselItemsHtml += "<p class='card-text'>"
														+ processedContent
														+ "</p>";
											}

											carouselItemsHtml += "<p class='card-text'><small class='text-muted'>좋아요: "
													+ place.place_like
													+ " | 조회수: "
													+ place.place_count
													+ "</small></p>";
											carouselItemsHtml += "</div>";
											carouselItemsHtml += "</div>";
											carouselItemsHtml += "</div>";
										});
							} else {
								carouselItemsHtml = "<div class='item'><div class='card p-3 m-2 text-center'><p>아직 등록된 "
										+ continent
										+ " 위시리스트가 없습니다.</p></div></div>";
							}

							var owl = $(targetDivClass);
							if (owl.data('owl.carousel')) {
								owl.owlCarousel('destroy');
							}
							owl.html(carouselItemsHtml);
							owl.owlCarousel({
								loop : false,
								margin : 10,
								nav : true,
								dots : false,
								responsive : {
									0 : {
										items : 1,
										slideBy : 1
									},
									768 : {
										items : 2,
										slideBy : 1
									},
									992 : {
										items : 3,
										slideBy : 1
									}
								}
							});
						},
						error : function(xhr, status, error) {
							console.error("AJAX 실패 (WishList):", status, error);
							console.log("응답 텍스트:", xhr.responseText);
							var targetDiv = $(targetDivClass);
							if (targetDiv.data('owl.carousel')) {
								targetDiv.owlCarousel('destroy');
							}
							targetDiv
									.html("<div class='item'><div class='card p-3 m-2 text-center'><p>위시리스트를 불러오는데 실패했습니다.</p></div></div>");
						}
					});

		}
	</script>
</body>
</html>