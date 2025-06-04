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
		 //System.out.print(review_idx); 
		 
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
					review_img+=imgs[i].trim()+",";
				}else{
					review_img+="";
				}
				
		 }
		 if(imgs.length>0)
		 {
		 review_img=review_img.substring(0,review_img.length()-1);
		 }
		 System.out.println(review_img);
		 
		 //ReviewDao 생성
 		 ReviewDao dao=new ReviewDao();
 	     String imgname = dao.getOneData(review_idx).getReview_img();
	 	 //기존 이미지
	 	 System.out.print(imgname);
	 	 String []imgnames=null;
	 	 
	 	 
 		
		 String final_img="";
		
		 File [] newfile= {multi.getFile(review_img1),multi.getFile(review_img2),multi.getFile(review_img3)}; //새로운 이미지 선택시
		 
		 for(int i=0;i<3;i++)			 
		 {
			
			 imgnames[i]+=imgname.split(",");
			
			 if(newfile[i]!=null)
			 {
				 final_img+=(review_img+(i+1))+",";
				 //업로드한 이미지 지우기			
				 System.out.print("newfile: "+newfile[i]);
				//파일생성
				File file = new File(realPath + "\\" + imgnames[i]);
				//파일삭제
				if (file.exists()) //파일이 존재하면
					file.delete(); //파일삭제
			 }else if(
				imgnames[i] !=null && !imgnames[i].isEmpty() && !imgnames[i].equals("null")) //기존 이미지가 null이 아니고 비어있지 않을시
			 { 
			 final_img+=imgnames[i]+","; //기본이미지 그대로 사용
			 }else
			 {
			 final_img="";
			 }
		 }
		 
		 if(final_img.length()>0)
		 {
			 final_img=final_img.substring(0,final_img.length()-1);
		 }
		 System.out.print("final_img: "+final_img);
		 
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