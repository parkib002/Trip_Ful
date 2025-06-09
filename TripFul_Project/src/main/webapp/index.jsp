<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tripful - 관광지 정보</title>
	
	
    <link rel="stylesheet" href="css/pagination.css">
    <link rel="stylesheet" href="css/boardListStyle.css">
    <link rel="stylesheet" href="css/noticeStyle.css">
    <link rel="stylesheet" href="css/style.css">	

	
	<link rel="stylesheet" href="Review/ModalStyle.css">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.carousel.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/assets/owl.theme.default.min.css">
	<link
	href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

</head>
<body>

<%@ include file="layout/header.jsp" %>

<div class="wrapper d-flex flex-column min-vh-100">
    <main class="flex-grow-1">
        <%
            String mainPage = "page/TripFul_main.jsp";
            if (request.getParameter("main") != null) {
                mainPage = request.getParameter("main");
            }

            String sub = request.getParameter("sub");
            if (sub != null && !sub.isEmpty()) {
                request.setAttribute("sub", sub);
            }
        %>
        <div class="container-fluid my-5">
            <jsp:include page="<%= mainPage %>" />
        </div>
    </main>

    <%@ include file="layout/footer.jsp" %>
</div>

<div class="floating-buttons">
    <a href="index.jsp?main=board/boardList.jsp&sub=support.jsp"
       class="btn btn-light rounded-circle shadow-lg d-flex justify-content-center align-items-center"
       data-bs-toggle="tooltip" data-bs-placement="left" data-bs-title="고객센터">
        <i class="fas fa-headset fa-lg"></i>
    </a>

    <a href="#"class="btn btn-light rounded-circle shadow-lg d-flex justify-content-center align-items-center"
            data-bs-toggle="tooltip" data-bs-placement="left" data-bs-title="맨 위로">
        <i class="fas fa-arrow-up fa-lg"></i>
        </a>
</div>





<script>
    document.addEventListener(
        "DOMContentLoaded", function() {
        // 툴팁 활성화
        const tooltipTriggerList = document.querySelectorAll('[data-bs-toggle="tooltip"]');
        const tooltipList = [...tooltipTriggerList].map(tooltipTriggerEl => new bootstrap.Tooltip(tooltipTriggerEl));


    });
</script>



<script src="js/header.js" defer></script>
<script src="js/selectPlace.js" defer></script>
<script src="js/mainPageCarousel.js" defer></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/OwlCarousel2/2.3.4/owl.carousel.min.js"></script>

<script src="Review/JavaScript/ModalJs.js" defer></script>
<script src="Review/JavaScript/reviewListJs.js" defer></script>
</body>
</html>