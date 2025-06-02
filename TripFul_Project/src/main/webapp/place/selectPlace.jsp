<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 선택 페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <%
  	String loginok=(String)session.getAttribute("loginok");
  %>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    header {
      background-color: #2196f3;
      padding: 1rem;
      color: white;
      text-align: center;
    }
    .container {
      padding: 2rem;
      max-width: 1000px;
      margin: auto;
    }
    .selection-buttons {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1.5rem;
      align-items: center;
      justify-content: center;
      text-align: center;
    }
    .selection-buttons button {
      padding: 0.75rem 1.5rem;
      background-color: #fff;
      border: 2px solid #2196f3;
      color: #2196f3;
      cursor: pointer;
      border-radius: 0.5rem;
      transition: all 0.3s ease;
    }
    .selection-buttons button:hover {
      background-color: #2196f3;
      color: white;
    }
    .places {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 1rem;
    }
.place-card {
  padding: 0;
  margin: 0;
  border-radius: 0.5rem;
  overflow: hidden;
  box-shadow: 0 2px 5px rgba(0,0,0,0.1);
  display: flex;
  flex-direction: column;
  justify-content: flex-start; /* 위쪽 정렬 */
  height: 230px;
}
.place-card {
  display: flex;
  flex-direction: column;
  justify-content: flex-end; /* 맨 아래 정렬 */
  height: 230px;
}
.image-wrapper {
  height: 170px;
  overflow: hidden;
  border-bottom: 1px solid #ccc;
  margin-bottom: 6px;
}


.image-wrapper img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  box-shadow: 0 4px 8px rgba(0,0,0,0.15);
  border-radius: 0.5rem 0.5rem 0 0;
}




.place-card .caption {
  padding: 2px 5px; /* 적당히 위아래 패딩 줄임 */
  text-align: center;
  height: auto; /* 높이 고정 제거 */
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
   .place-card img {
 	width: 100%;
    height: 150px;
    object-fit: cover;
    transition: transform 0.3s ease; /* 부드러운 애니메이션 */
	}
	.top-button-row, .continent-row {
   display: flex;
   flex-wrap: wrap;
   gap: 1rem;
   justify-content: center;
   margin-bottom: 1rem;
   }

   .place-card:hover .image-wrapper img {
  transform: scale(0.95);
}
   
   .sort-label {
  font-weight: bold;
  color: #2196f3;
  font-size: 1rem;
}

.sort-dropdown {
  padding: 0.65rem 1rem;
  border: 2px solid #2196f3;
  border-radius: 0.5rem;
  font-size: 1rem;
  color: #2196f3;
  background-color: #fff;
  cursor: pointer;
  transition: all 0.3s ease;
}

.sort-dropdown:hover {
  background-color: #2196f3;
  color: #fff;
}

.caption, .rating {
  margin: 0 !important;
  padding: 0 !important;
  line-height: 1.1;      /* 줄 높이 줄이기 */
  font-size: 1rem;
}

.text-container {
  display: block !important;
  padding: 0 3px 3px 3px !important;
}

.caption {
  font-weight: 700;
  font-size: 1rem;
  color: #333;
}


.rating {
  color: #f39c12;
  font-size: 0.9rem;
  margin-top: 2px;
  text-align: center;
}
.text-area {
  background-color: #f9f9f9;
  padding: 8px 10px;
  border-top: 1px solid #ddd;
  border-radius: 0 0 0.5rem 0.5rem;
  display: flex;
  flex-direction: column;
  justify-content: center;
  align-items: center;
  text-align: center;
}

  </style>
  <script type="text/javascript">
  $('#sortSelect').on('change', function () {
	  const selectedSort = $(this).val();
	  currentPage = 1;
	  lastLoaded = false;
	  $('#placeContainer').empty();

	  loadAllPlaces(currentPage, selectedSort);
	});
  </script>
</head>
<body>

  <header>
    <h1>관광지 선택</h1>
  </header>

<div class="container">
  <div class="selection-buttons" id="global-controls">
    <!-- 🔽 정렬 드롭다운 추가 -->
    <label for="sortSelect" class="sort-label">정렬: </label>
    <select id="sortSelect" class="sort-dropdown">
      <option value="popular">조회순</option>
      <option value="rating">별점순</option>
      <option value="likes">좋아요순</option>
    </select>
    
    <%
    if("admin".equals(loginok)){%>
    <button type="button" onclick="location.href='index.jsp?main=place/insertPlace.jsp'">관광지 추가</button>
    <%} %>
  </div>

  <div class="selection-buttons" id="selection-area" style="position: relative; z-index: 10;"></div>
  <div class="places" id="placeContainer"></div>
</div>
 <% 
 System.out.println("관광지 DAO 진입: " + System.currentTimeMillis());

System.out.println("관광지 DAO 응답 완료: " + System.currentTimeMillis());
%>
</body>
</html>

