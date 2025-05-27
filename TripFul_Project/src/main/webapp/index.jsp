<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Tripful - 관광지 정보</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="js/modal.js" defer></script>
</head>
<body>

<%@ include file="layout/header.jsp" %>

<%
    String mainPage = "page/TripFul_main.jsp";
    if (request.getParameter("main") != null) {
        mainPage = request.getParameter("main");
    }
%>

<div class="container my-5">
    <jsp:include page="<%= mainPage %>" />
</div>

<%@ include file="layout/footer.jsp" %>
<%@ include file="layout/regionModal.jsp" %>

</body>
</html>
