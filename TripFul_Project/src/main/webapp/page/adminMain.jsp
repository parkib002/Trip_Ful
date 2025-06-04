<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%
    String adminName = (String) session.getAttribute("name");
    String loginStatus = (String) session.getAttribute("loginok");
    if (loginStatus == null || !loginStatus.equals("admin")) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>관리자 메인 페이지</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        .admin-banner {
            background: linear-gradient(to right, #007bff, #00bcd4);
            color: white;
            padding: 40px 0;
            text-align: center;
            border-radius: 0 0 20px 20px;
        }
        .admin-section {
            padding: 40px 20px;
        }
        .card:hover {
            transform: scale(1.02);
            transition: transform 0.2s ease-in-out;
        }
        .card-icon {
            font-size: 2rem;
            color: #007bff;
        }
    </style>
</head>
<body>
<div class="admin-banner">
    <h1 class="display-4">Tripful 관리자 페이지</h1>
    <p class="lead">안녕하세요, <strong><%= adminName != null ? adminName : "관리자" %></strong>님!</p>
</div>

<div class="container admin-section">
    <div class="row g-4">
        <div class="col-md-3">
            <div class="card shadow-sm p-3 text-center">
                <div class="card-icon mb-2"><i class="bi bi-geo-alt-fill"></i></div>
                <h5 class="card-title">여행지 관리</h5>
<%--                <p class="card-text">등록된 여행지를 수정하거나 삭제할 수 있어요.</p>--%>
                <a href="index.jsp?main=admin/placeManage.jsp" class="btn btn-primary">이동</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm p-3 text-center">
                <div class="card-icon mb-2"><i class="bi bi-chat-left-text"></i></div>
                <h5 class="card-title">리뷰 관리</h5>
<%--                <p class="card-text">사용자가 작성한 리뷰를 관리하세요.</p>--%>
                <a href="index.jsp?main=admin/reviewManage.jsp" class="btn btn-primary">이동</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm p-3 text-center">
                <div class="card-icon mb-2"><i class="bi bi-people-fill"></i></div>
                <h5 class="card-title">회원 관리</h5>
<%--                <p class="card-text">회원 정보 확인 및 권한을 설정할 수 있어요.</p>--%>
                <a href="index.jsp?main=admin/userManage.jsp" class="btn btn-primary">이동</a>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card shadow-sm p-3 text-center">
                <div class="card-icon mb-2"><i class="bi bi-megaphone-fill"></i></div>
                <h5 class="card-title">공지사항 관리</h5>
<%--                <p class="card-text">공지사항을 등록하고 수정할 수 있어요.</p>--%>
                <a href="index.jsp?main=admin/noticeManage.jsp" class="btn btn-primary">이동</a>
            </div>
        </div>
    </div>

    <div class="text-center mt-5">
        <a href="../login/logoutAction.jsp" class="btn btn-outline-danger">로그아웃</a>
    </div>
</div>
</body>
</html>
