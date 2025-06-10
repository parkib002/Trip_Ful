<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">

<title>Insert title here</title>
</head>
<body>
	<%
		String review_idx=request.getParameter("review_idx");
		ReviewDao dao=new ReviewDao();
		dao.deleteReview(review_idx);
	%>
</body>
</html>