<%@page import="org.json.JSONArray"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>새 창</title>
<!-- 부트스트랩, jQuery, Tailwind CSS 링크 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<!-- 스타일 복사 -->
<%
    request.setCharacterEncoding("UTF-8");

    String name = request.getParameter("preview_name");
    String address = request.getParameter("preview_address");
    String placeId = request.getParameter("preview_placeid");
    String tag = request.getParameter("preview_tag");
    String content = request.getParameter("preview_content");
    String imageJson = request.getParameter("preview_images");
    
    String contentWithoutImg = content.replaceAll("<img[^>]*>", "");

    List<String> imageList = new ArrayList<>();
    if (imageJson != null && !imageJson.isEmpty()) {
        JSONArray arr = new JSONArray(imageJson);
        for (int i = 0; i < arr.length(); i++) {
            imageList.add(arr.getString(i));
        }
    }

    // 콘솔에 출력 (서버 로그에서 확인 가능)
    System.out.println("=== [미리보기 디버그 정보] ===");
    System.out.println("이름: " + name);
    System.out.println("주소: " + address);
    System.out.println("Place ID: " + placeId);
    System.out.println("카테고리: " + tag);
    System.out.println("내용: " + content);
    System.out.println("imageList : " + imageList);
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
    margin-top: 15px; /* 원하는 만큼 숫자 조정 */
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

  hr {
    height: 2px;
    background-color: gray;
    border: none;
  }

.carousel-indicators {
    position: absolute;
    bottom: 10px; /* 원하는 만큼 조정 */
    left: 35%;
    transform: translateX(-50%);
    display: flex;
    justify-content: center;
    gap: 10px;
}
</style>
<script>
const initialPlaceId = "<%= placeId %>";

function initMap() {
	  console.log("initMap called");
	  map = new google.maps.Map(document.getElementById("map"), {
	    zoom: 15,
	    center: { lat: 37.5665, lng: 126.9780 },  // 서울 기본 위치
	  });
	  service = new google.maps.places.PlacesService(map);
	  console.log("Map and service initialized");
	  
	  // 👉 여기 추가!
	  if (initialPlaceId && initialPlaceId !== "null") {
	    console.log("Calling showPlaceOnMap with initialPlaceId:", initialPlaceId);
	    showPlaceOnMap(initialPlaceId);
	  }
	}
	function showPlaceOnMap(placeId) {
	  console.log("showPlaceOnMap called with placeId:", placeId);
	  if (!service || !map) {
	    console.error("Map or service not initialized!");
	    return;
	  }
	  const request = {
	    placeId: placeId,
	    fields: ["name", "geometry"],
	  };
	  service.getDetails(request, (place, status) => {
	    console.log("Place Details Status:", status);
	    if (status === google.maps.places.PlacesServiceStatus.OK) {
	      const location = place.geometry.location;
	      console.log("Place location:", location.toString());
	      map.setCenter(location);
	      new google.maps.Marker({
	        map: map,
	        position: location,
	      });
	    } else {
	      console.error("Place ID lookup failed:", status);
	    }
	  });
	}
	document.addEventListener("DOMContentLoaded", function () {
		  window.addEventListener("message", function (event) {
		    const data = event.data;
		    //console.log("message received", data);
		    if (data) {
		      document.getElementById("preview-name").innerText = data.name || '';
		      document.getElementById("preview-address").innerText = data.address || '';
		      document.getElementById("preview-placeid").innerText = data.placeId || '';
		      // 중요: 이 부분에서 값 제대로 들어오는지 확인
		      //console.log("data.tag:", data.tag);
		      //console.log("data.content:", data.content);
		      document.getElementById("preview-tag").innerText = data.tag || '태그 없음';
		      document.getElementById("preview-content").innerHTML = data.content || '<p>내용 없음</p>';
		      const placeId = data.placeId || null;
		      console.log("Current placeId:", placeId);
		      console.log(data.content)
		      if (placeId && service && map) {
		        showPlaceOnMap(placeId);
		      } else {
		        console.log("Map or service not ready. Retrying after 500ms...");
		        setTimeout(() => {
		          if (placeId && service && map) {
		            showPlaceOnMap(placeId);
		          } else {
		            console.error("Map/service still not ready. Cannot show place.");
		          }
		        }, 500);
		      }
		    }
		  });
		});
</script>
<script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDpVlcErlSTHrCz7Y4h3_VM8FTMkm9eXAc&libraries=places&callback=initMap" async defer></script>
</head>
<body>
<div class="container">
        <h1 class="place-title" align="center" id="preview-name"><%=name %></h1>
        <div class="category-views d-flex justify-content-between align-items-center mb-2">
    	<p class="category m-0" id="preview-tag">카테고리: <%=tag %></p>
   	 	<p class="views m-0 count"></p>
   	 	<p class="views m-0">별점: 없음</p>
<!-- 좋아요 아이콘과 좋아요 수 -->
<div class="d-flex align-items-center gap-1">
  <img id="likeIcon" src="../image/places/white_heart.png" style="width: 25px; height: 25px; cursor: pointer;" alt="좋아요">
  <span id="likecount">0</span>
</div>
		</div>
        <div class="main-section">
           <!-- Carousel -->
          
<div id="demo" class="carousel slide" data-bs-ride="carousel">
  <!-- Indicators/dots -->
<div class="carousel-indicators">
    <%
    for (int i = 0; i < imageList.size(); i++) {
%>
  <button type="button" data-bs-target="#demo" data-bs-slide-to="<%=i%>" class="<%= (i == 0) ? "active" : "" %>"></button>
<%
    }
%>
</div>
  <!-- The slideshow/carousel -->
  <div class="carousel-inner">
      <div class="carousel-inner">
    <%
      for (int i = 0; i < imageList.size(); i++) {
        String img = imageList.get(i);
    %>
      <div class="carousel-item <%= (i == 0) ? "active" : "" %>">
        <img src="<%= img %>" class="d-block w-100" alt="uploaded image">
      </div>
    <%
      }
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
</div>
            <div class="info-box">
                <p class="description"></p>
                <div id="map" style="width: 100%; height: 500px;"></div>
                <p class="address" id="preview-address">주소: <%=address %></p>
            </div>
        </div>
        
           <hr>
		<div id="preview-content">
		<%=contentWithoutImg %>
		</div>
</body>
</html>