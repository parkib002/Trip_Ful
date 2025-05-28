<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
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
</style>
</head>
<body>
<div class="container">
        <h1 class="place-title"></h1>
        
        <div class="main-section">
            <div class="image-box">
                <img src="./image/places/경복궁.jpg" alt="">
            </div>
            <div class="info-box">
                <p class="description"></p>
                <p class="category">카테고리: </p>
                <p class="location">위치: </p>
            </div>
        </div>

        <div class="review-section">
            <h2>방문자 리뷰</h2>
             
                <div class="review-card">
                    <div class="review-header">
                        <span class="review-user"></span>
                        <span class="review-date"></span>
                    </div>
                    <div class="review-content">
                    </div>
                </div>
            
        </div>
    </div>
</body>
</html>