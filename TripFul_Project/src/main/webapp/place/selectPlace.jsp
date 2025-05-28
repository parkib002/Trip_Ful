<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 선택 페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
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
      background-color: white;
      border-radius: 0.5rem;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    .place-card img {
      width: 100%;
      height: 150px;
      object-fit: cover;
    }
    .place-card .caption {
      padding: 0.75rem;
      text-align: center;
    }
    
    .place-card img {
  width: 100%;
  height: 150px;
  object-fit: cover;
  transition: transform 0.3s ease; /* 부드러운 애니메이션 */
}

.place-card:hover img {
  transform: scale(0.95); /* 95% 크기로 축소 */
}
  </style>
</head>
<body>
  <header>
    <h1>관광지 선택</h1>
  </header>

  <div class="container">
    <div class="selection-buttons" id="selection-area" style="position: relative; z-index: 10;"></div>
    <div class="places" id="placeContainer"></div>
  </div>

 
</body>
</html>

