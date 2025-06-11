<%@page import="review.ReviewDao"%>
<%@page import="review.ReportDto"%>
<%@page import="review.ReportDao"%>
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
	request.setCharacterEncoding("utf-8");

	String review_idx=request.getParameter("review_idx");
	String report_content=request.getParameter("report_content");
	String member_id=(String)session.getAttribute("id");
	
	
	System.out.println("review_idx: "+ review_idx);
	System.out.println("report_content: "+ report_content);
	System.out.println("member_id: "+ member_id);
	
	//리포트 Dao
	ReportDao dao=new ReportDao();
	ReviewDao rdao=new ReviewDao();
	//신고 체크
	int report_cnt=dao.getCntCheck(member_id, review_idx);
	
	//리포트 idx값 얻기
	String report_idx=dao.getReportIdx(member_id, review_idx);
	
	ReportDto dto=new ReportDto();	
	
	dto.setReport_content(report_content);
	dto.setReview_idx(review_idx);
	dto.setMember_id(member_id);	
	dto.setReport_idx(report_idx);
	//System.out.println(report_cnt);	
	
	dto.setReport_cnt(++report_cnt);
	//System.out.println(report_cnt);
	dao.updateReport(dto);
	
	//하나의 리뷰에 대한 신고 횟수 조회
	int totreport_cnt=dao.getAllreportCnt(review_idx);
	if(totreport_cnt>=10){
		rdao.deleteReview(review_idx);
	}
	
	
%>
</body>
</html>