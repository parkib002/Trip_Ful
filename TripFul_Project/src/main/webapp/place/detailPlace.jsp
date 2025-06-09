<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@page import="review.ReviewDto"%>
<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>
<%
	request.setCharacterEncoding("utf-8");

	String num=request.getParameter("place_num");

	PlaceDao dao=new PlaceDao();
	
	PlaceDto dto=dao.getPlaceData(num);
	
	String [] img=dto.getPlace_img().split(",");
	
	ReviewDao rdao=new ReviewDao();
	
	double star=rdao.getAverageRatingByPlace(num);
	
	List<ReviewDto> list=dao.selectReview(num);	
	
	String loginok=(String)session.getAttribute("loginok");
	
	if (loginok == null) loginok = "";

	
%>

<style type="text/css">
body {
    font-family: 'Arial', sans-serif;
    margin: 0;
    background-color: #f5f5f5;
}

.container {
    max-width: 1000px;
    margin: 0 auto;
    padding: 20px;
    background-color: white;
}

.place-title {
    font-size: 32px;
    margin-bottom: 20px;
    border-bottom: 2px solid #ccc;
    padding-bottom: 10px;
}

.main-section {
    display: flex;
    gap: 20px;
    margin-bottom: 40px;
    align-items: flex-start;
    min-height: 320px;
}

.carousel {
    width: 500px;
    flex-shrink: 0;
}

.carousel-inner img {
    width: 500px;
    height: 500px;
    object-fit: cover;
    border-radius: 10px;
}

.image-box img {
    width: 400px;
    height: auto;
    border-radius: 10px;
}

.info-box {
    flex: 1;
}

.description {
    font-size: 16px;
    margin-bottom: 15px;
}

.category, .location {
    font-size: 14px;
    color: #666;
}

.review-section h2 {
    font-size: 24px;
    margin-bottom: 20px;
}

.review-card {
    background-color: #f9f9f9;
    padding: 15px;
    border-radius: 10px;
    margin-bottom: 15px;
    box-shadow: 0 2px 5px rgba(0,0,0,0.1);
}

.review-header {
    display: flex;
    justify-content: space-between;
    margin-bottom: 8px;
}

.review-user {
    font-weight: bold;
}

.review-date {
    font-size: 12px;
    color: #999;
}

.category-views {
    font-size: 14px;
    color: #666;
}

.button-group {
  display: flex;
  gap: 12px;
}

.btn-outline {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  padding: 8px 16px;
  font-size: 14px;
  font-weight: 500;
  border: 2px solid;
  border-radius: 20px;
  background-color: transparent;
  cursor: pointer;
  gap: 8px;
  min-width: 100px; /* 버튼 폭 고정 또는 최소값 */
  height: 40px;
  transition: all 0.3s ease;
  white-space: nowrap;
  text-align: center;
}

.btn-outline i {
  font-size: 14px;
  display: inline-block;
  vertical-align: middle;
}

.edit {
  border-color: #3498db;
  color: #3498db;
}

.edit:hover {
  background-color: #3498db;
  color: white;
}

.delete {
  border-color: #e74c3c;
  color: #e74c3c;
}

.delete:hover {
  background-color: #e74c3c;
  color: white;
}

#map{
	
	border: 1px solid gray;
	border-radius: 10px;
}

</style>
</head>
<script>
$(function(){
	
	let num="<%=num%>";
	let loginok="<%=loginok == null ? "" : loginok%>";
	
	$.ajax({

		type:"get",
		url:"place/detailPlaceCountAction.jsp",
		dataType:"json",
		data:{"place_num":num},
		success:function(res){
			
			
			var count=res.place_count;
			
			$(".count").text("조회수: "+count);
			
		}
		
	})
	
	  // 1) 처음 로딩 시 좋아요 상태 체크
	  if (loginok) {
	    $.ajax({
	      type: "get",
	      url: "place/detailPlaceLikeAction.jsp",
	      data: { "place_num": num, "action": "check" },
	      dataType: "json",
	      success: function (res) {
	        if (res.liked) {
	          $("#likeIcon").attr("src", "./image/places/red_heart.png");
	        } else {
	          $("#likeIcon").attr("src", "./image/places/white_heart.png");
	        }
	        if (res.place_like !== undefined) {
	          $("#likecount").text(res.place_like);
	        }
	      }
	    });
	  } else {
	    // 로그인 안했으면 흰 하트, 좋아요 수는 그냥 출력
	    $("#likeIcon").attr("src", "./image/places/white_heart.png");
	  }

	  // 2) 좋아요 클릭 시 토글 호출
	  $("#likeIcon").click(function () {
	    if (!loginok) {
	      alert("로그인 후 좋아요를 눌러주세요");
	      return;
	    }

	    $.ajax({
	      type: "get",
	      url: "place/detailPlaceLikeAction.jsp",
	      data: { "place_num": num },
	      dataType: "json",
	      success: function (res) {
	        if (res.error) {
	          alert(res.error);
	          return;
	        }

	        if (res.place_like !== undefined) {
	          $("#likecount").text(res.place_like);
	        }

	        if (res.liked) {
	          $("#likeIcon").attr("src", "./image/places/red_heart.png");
	        } else {
	          $("#likeIcon").attr("src", "./image/places/white_heart.png");
	        }
	      },
	      error: function (xhr, status, error) {
	        console.error("좋아요 처리 실패:", error);
	      }
	    });
	  });
	

})


  function initMap() {
    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 15,
      center: { lat: 37.5665, lng: 126.9780 }, // 초기값 (서울)
    });

    const placeId = "<%=dto.getPlace_code() %>"; // 예시 Place ID

    const request = {
      placeId: placeId,
      fields: ["name", "geometry"], // geometry에 위도/경도 포함
    };

    const service = new google.maps.places.PlacesService(map);
    service.getDetails(request, (place, status) => {
      if (status === google.maps.places.PlacesServiceStatus.OK) {
        const location = place.geometry.location;
        map.setCenter(location);
        new google.maps.Marker({
          map: map,
          position: location
        });
      } else {
        console.error("Place ID lookup failed:", status);
      }
    });
  } 
  
 function deletePlace(name,num){
	 
	 var a=confirm(name+"을(를) 정말로 삭제하시겠습니까?");
	 
	 if(a)
		 location.href="index.jsp?main=place/deletePlaceAction.jsp?place_num="+num;
 }
</script>

<script
  src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDpVlcErlSTHrCz7Y4h3_VM8FTMkm9eXAc&libraries=places&callback=initMap"
  async defer></script>
<body>
<div class="container" >
        <h1 class="place-title" align="center"><%=dto.getPlace_name() %>
        <%
        	if("admin".equals(loginok)){
        %>

<div class="button-group">
  <button class="btn-outline edit" onclick="location.href='place/updatePlace.jsp?place_num=<%=num%>'"><i class="fas fa-pen"></i>수정</button>
  <button class="btn-outline delete" onclick="deletePlace('<%=dto.getPlace_name()%>',<%=num%>)"><i class="fas fa-trash"></i>삭제</button>
</div>
<%} %>
        </h1>


        <div class="category-views d-flex justify-content-between align-items-center mb-2">
    	<p class="category m-0">카테고리: <%=dto.getPlace_tag() %></p>
   	 	<p class="views m-0 count"></p>
   	 	<p class="views m-0">별점: <%=star==-1.0?"없음":star%></p>
   	 	<input type="hidden" id="num" value="<%=dto.getPlace_num()%>">
<!-- 좋아요 아이콘과 좋아요 수 -->
<div class="d-flex align-items-center gap-1">
  <img id="likeIcon" src="./image/places/white_heart.png" style="width: 25px; height: 25px; cursor: pointer;" alt="좋아요">
  <span id="likecount"><%=dto.getPlace_like()%></span>
</div>
		</div>
        <div class="main-section">
           <!-- Carousel -->
<div id="demo" class="carousel slide" data-bs-ride="carousel">

  <!-- Indicators/dots -->
<div class="carousel-indicators">
  <% for (int i = 0; i < img.length; i++) { %>
    <button type="button" data-bs-target="#demo" data-bs-slide-to="<%=i%>" class="<%= (i == 0 ? "active" : "") %>"></button>
  <% } %>
</div>
  
  <!-- The slideshow/carousel -->
  <div class="carousel-inner">
  <%
  	for(int i=0;i<img.length;i++){
  %>
    <div class="carousel-item <%= (i == 0 ? "active" : "") %>">
      <img src="<%=img[i] %>" alt="Los Angeles" class="d-block" style="width:500px;">
    </div>
   
    <%} 
    %>
  </div>
  
  <!-- Left and right controls/icons -->
  <button class="carousel-control-prev" type="button" data-bs-target="#demo" data-bs-slide="prev">
    <span class="carousel-control-prev-icon"></span>
  </button>
  <button class="carousel-control-next" type="button" data-bs-target="#demo" data-bs-slide="next">
    <span class="carousel-control-next-icon"></span>
  </button>
</div>
            <div class="info-box">
                <p class="description"></p>
                <p class="location">위치: </p>
                <div id="map" style="width: 100%; height: 400px;"></div>
                <p class="address">주소:<%=dto.getPlace_addr() %>
            </div>
        </div>

		<div>
				<%=dto.getPlace_content() %>
		</div>
		
<div class="review-section">
  <h2>방문자 리뷰</h2>


  <div class="review-card">
    <jsp:include page="../Review/reviewList.jsp?place_num=<%=num %>"/>
  </div>
	
</div>
    </div>
</body>
</html>