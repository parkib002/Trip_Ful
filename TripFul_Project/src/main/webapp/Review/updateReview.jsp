<%@page import="java.util.Arrays"%>
<%@page import="java.util.Enumeration"%>
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
	  boolean flag=true;
	  try{
		 
		 multi=new MultipartRequest(request,realPath,uploadSize,"utf-8",
			  new DefaultFileRenamePolicy());
		 
		 //System.out.print("확인");
		 String review_id=multi.getParameter("review_id");
		 String review_content=multi.getParameter("review_content");		 
		 Double review_star=Double.parseDouble(multi.getParameter("review_star"));
		 String place_num=multi.getParameter("place_num");
		 String review_idx=multi.getParameter("review_idx");
		 
		 if(review_content==null || review_content=="" || review_content.isEmpty())
		 {
			 flag=false;
			 return;
		 }
		 //System.out.print(review_idx); 		 
		 
		 //ReviewDao 생성
 		 ReviewDao dao=new ReviewDao();		 
		
		 //기존 이미지
		String getimg= dao.getOneData(review_idx).getReview_img();	
		String [] oldFileNames=new String[3];
		//기존 이미지 얻기
		if(getimg!=null)
	      {
	       String [] tempArr=getimg.split(",");
	      
		 for (int j = 0; j < tempArr.length && j < 3; j++) {
			 oldFileNames[j] = tempArr[j].trim();
		        // 빈 문자열은 null로 처리하여 나중에 쉽게 판별
		        if (oldFileNames[j].isEmpty()) {
		        	oldFileNames[j] = null;
		        }
		    }
	      }
		String [] final_imgArr=new String[3];
		Arrays.fill(final_imgArr, ""); // 모든 요소를 빈 문자열로 초기화
		
		 
		// 3. 각 이미지 슬롯(1, 2, 3)에 대한 처리
		for (int i = 0; i < 3; i++) {
		    // 현재 처리할 input file의 name (review_img1, review_img2, review_img3)
		    String newFileName = "review_img" + (i + 1);
			String delete_img=multi.getParameter("delete_img"+(i+1));
			
			//System.out.println("delete_img"+(i+1)+":"+delete_img);
		    // 해당 input file로 새로 업로드된 파일명
		    String newUploadedFileName = multi.getFilesystemName(newFileName);
		   // System.out.println("Input name: " + newFileName + ", New Uploaded File: " + newUploadedFileName);

		    // 현재 슬롯의 DB에 원래 저장되어 있던 파일명 (existingDbImgArray에서 가져옴)
		    String dbOriginalFileName = oldFileNames[i];
		   // System.out.println("DB Original File (slot " + (i + 1) + "): " + dbOriginalFileName);
		
		    if(newUploadedFileName!=null)
		    {
		    	final_imgArr[i]=newUploadedFileName.trim();
		    	//System.out.println("final_imgArr "+(i+1)+": "+final_imgArr[i]);
		    	 // 기존 DB 파일이 존재하고, 새로 업로드된 파일과 이름이 다르면 삭제
		        if (dbOriginalFileName != null && !dbOriginalFileName.isEmpty() && !dbOriginalFileName.equals(newUploadedFileName)) {
		            File oldFileToDelete = new File(realPath + File.separator + dbOriginalFileName);
		            if (oldFileToDelete.exists()) {
		                oldFileToDelete.delete();
		                //System.out.println("기존 DB 파일 삭제 (새 파일로 교체): " + oldFileToDelete.getAbsolutePath());
		            }
		        }
		    }else{
		    	if(dbOriginalFileName!=null && "true".equals(delete_img.trim()))
		    	{
		    		final_imgArr[i]=dbOriginalFileName.trim();
		    	 // DB에 기존 파일이 있었는데, 새로 업로드되지 않았으므로 삭제된 것으로 간주
		    	}else{
		    		
		    	//	System.out.print(i);
		             File oldFileToDelete = new File(realPath + File.separator + dbOriginalFileName);
		             if (oldFileToDelete.exists()) {
		                 oldFileToDelete.delete();
		                // System.out.println("기존 DB 파일 삭제 ('X' 버튼으로 제거 또는 업로드 없음): " + oldFileToDelete.getAbsolutePath());
		                // System.out.println(oldFileNames);
		                 final_imgArr[i]="";
		             }
		         }
		    
		    }
		}
	      
		// 3. 최종적으로 DB에 저장할 이미지 문자열 생성
		String final_img = String.join(",", final_imgArr);
		System.out.println("final_img (before cleanup): " + final_img);

		// 결과 문자열에서 불필요한 연속 콤마 또는 앞뒤 콤마 제거
		final_img = final_img.replaceAll(",+", ","); // 두 개 이상의 콤마를 하나로
		final_img = final_img.replaceAll("^,|,$", ""); // 시작/끝의 콤마 제거

		//System.out.println("final_img (after cleanup): " + final_img);
		
		// System.out.print("final_img: "+final_img); 
		 
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
<%=flag%>