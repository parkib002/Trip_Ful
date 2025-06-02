<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tripful - 관광지 정보</title>
    <link rel="stylesheet" href="css/boardListStyle.css">
    <link rel="stylesheet" href="css/noticeStyle.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <link rel="stylesheet" href="css/style.css">
    <script src="js/selectPlace.js" defer></script>
    <script src="js/header.js"></script>
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

<%@ include file="layout/regionModal.jsp" %>

<script src="js/header.js"></script>
<script src="js/mainPageCarousel.js"></script>

</body>
</html>