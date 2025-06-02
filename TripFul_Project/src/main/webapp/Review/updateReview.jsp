<%@page import="java.io.File"%>
<%@page import="review.ReviewDao"%>
<%@page import="review.ReviewDto"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
		 Double review_star=Double.parseDouble(multi.getParameter("review_star"));
		 String place_num=multi.getParameter("place_num");
		 String review_idx=multi.getParameter("review_idx");
		 System.out.print(review_idx);
		 
		 //기본 이미지값 가져오기
 		 String review_img=multi.getParameter("photo");
		 
 		 System.out.print(review_img);
		 
		 //ReviewDao 생성
 		 ReviewDao dao=new ReviewDao();
		 
		 String final_img="";
		 File newfile= multi.getFile("review_img"); //새로운 이미지 선택시
		 if(newfile!=null)
		 {
			 final_img=multi.getFilesystemName("review_img");
			 //업로드한 이미지 지우기
			 String imgname = dao.getOneData(review_idx).getReview_img();
			
			//파일생성
			File file = new File(realPath + "\\" + imgname);
			//파일삭제
			if (file.exists()) //파일이 존재하면
				file.delete(); //파일삭제
		 }else if(review_img !=null && !review_img.isEmpty() && !review_img.equals("null")) //기존 이미지가 null이 아니고 비어있지 않을시
		 {
			 final_img=review_img; //기본이미지 그대로 사용
		 }else
		 {
			 final_img="";
		 }
		 
		 
		 
		 
		 ReviewDto dto=new ReviewDto();
		 
		 dto.setReview_id(review_id);
		 dto.setReview_content(review_content);
		 dto.setReview_img(final_img);
		 dto.setReview_star(review_star);
		 dto.setPlace_num(place_num);
		 dto.setReview_idx(review_idx);
		 
		 
		 
	   	
		 
		 dao.updateReview(dto);
		 
	    // System.out.println(dto.toString());
	  }catch(Exception e){
		  //System.out.print(e);
	  }
	  
%>