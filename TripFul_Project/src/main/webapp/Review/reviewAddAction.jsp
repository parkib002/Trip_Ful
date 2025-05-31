<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="review.ReviewDao"%>
<%@page import="review.ReviewDto"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<link href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
<%	
	String realPath=getServletContext().getRealPath("/save");
	//System.out.println(realPath);	
	
	//업로드크기
	  int uploadSize=1024*1024*5;
	
	  MultipartRequest multi=null;
	  
	  try{
		 
		 multi=new MultipartRequest(request,realPath,uploadSize,"utf-8",
			  new DefaultFileRenamePolicy());
		 
		 //System.out.print("확인");
		 String review_id=multi.getParameter("review_id");
		 String review_content=multi.getParameter("review_content");
		 String review_img=multi.getFilesystemName("review_img");
		 Double review_star=Double.parseDouble(multi.getParameter("review_star"));
		 String place_num=multi.getParameter("place_num");
		 
		 ReviewDto dto=new ReviewDto();
		 
		 dto.setReview_id(review_id);
		 dto.setReview_content(review_content);
		 dto.setReview_img(review_img);
		 dto.setReview_star(review_star);
		 dto.setPlace_num(place_num);
		 
		 ReviewDao dao=new ReviewDao();
		 dao.insertReview(dto);
		 
	     System.out.println(dto.toString());
	  }catch(Exception e){
		  //System.out.print(e);
	  }
	  
%>
	
</body>
</html>