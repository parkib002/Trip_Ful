<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="review.ReviewDao"%>
<%@page import="review.ReviewDto"%>

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
	String realPath=getServletContext().getRealPath("/save");
	System.out.println(realPath);	
	
	//업로드크기
	  int uploadSize=1024*1024*5;
	
	  MultipartRequest multi=null;
	  
	  try{
		 
		 multi=new MultipartRequest(request,realPath,uploadSize,"utf-8",
			  new DefaultFileRenamePolicy());
		 
		 
		 String review_id=multi.getParameter("review_id");
		 System.out.print(review_id);
		 String review_content=multi.getParameter("review_content");
		 System.out.print(review_content);
		 //이미지 합치기
		 String review_img1=multi.getFilesystemName("review_img1");		 
		 String review_img2=multi.getFilesystemName("review_img2");
		 String review_img3=multi.getFilesystemName("review_img3");
		 System.out.println("review_img1: "+review_img1);
		 System.out.println("review_img2: "+review_img2);
		 System.out.println("review_img3: "+review_img3);
		 String [] imgs={review_img1,review_img2,review_img3};
		 String review_img="";
		 for(int i=0; i<imgs.length; i++)
		 {
				if(imgs[i]!=null)
				{
					review_img+=imgs[i]+",";
				}
				
		 }
		 review_img=review_img.substring(0,review_img.length()-1);
		 
		 System.out.println(review_img);
		 
		 Double review_star=Double.parseDouble(multi.getParameter("review_star"));
		 String place_num=multi.getParameter("place_num");
		 
		 ReviewDto dto=new ReviewDto();
		 
		 
		 dto.setReview_id(review_id);
		 dto.setReview_content(review_content);
		 dto.setReview_img(review_img==null?"":review_img);
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