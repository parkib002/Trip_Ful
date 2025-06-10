<%@page import="org.json.JSONObject"%>
<%@page import="review.ReportDto"%>
<%@page import="review.ReportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>


	<%
		String review_idx=request.getParameter("review_idx");
		String member_id=(String)session.getAttribute("id");
		
		ReportDao dao=new ReportDao();
		
		//좋아요 체크
		int like=dao.getlike(member_id, review_idx);
		
		//리포트_idx값 얻기
		String report_idx=dao.getReportIdx(member_id, review_idx);
		
		//아이디 체크
		int idcheck=dao.getIdCheck(member_id, review_idx);
		
		
		ReportDto dto=new ReportDto();
		dto.setMember_id(member_id);
		dto.setReview_idx(review_idx);
		//System.out.println("idcheck: "+idcheck);
		if(idcheck!=0)
		{
			System.out.println("123");
			if(like>0)
			{
				dto.setLike(--like);
				dto.setReport_idx(report_idx);
				dao.updateLike(dto);
			}else{
				dto.setLike(++like);
				dto.setReport_idx(report_idx);
				dao.updateLike(dto);
			}
		}else{
			System.out.println("1234");
			dto.setLike(++like);
			dao.insertLike(dto);
			
		}
		int likeCount=dao.getLikeCount(review_idx);
		String likeCnt=likeCount+"";
		//System.out.println("likeCnt: "+likeCnt);
		
		JSONObject ob=new JSONObject();
		ob.put("member_id", member_id);
		ob.put("like",like);
		ob.put("likeCnt",likeCnt);
		ob.put("review_idx",review_idx);
		//System.out.println(like);
		
		
	%>
	<%=ob.toString() %>


