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
<%
	
	
	String review_idx=request.getParameter("review_idx");
	String title=request.getParameter("title");
	String report_content=request.getParameter("content");
	String member_id=(String)session.getAttribute("id");
	
	System.out.println("title: "+title+"\ncontent: "+report_content);
	ReportDao rdao=new ReportDao();
	ReportDto rdto=new ReportDto();
	int reportch=rdao.getReportIdx(review_idx);
	
	rdto.setReview_idx(review_idx);
	rdto.setMember_id(member_id);
	rdto.setReport_content(report_content);
	
%>
<body>
	<div class="container mt-3 report_box" >	
		<table class="table table-hover report_table" >
			<tr>
				<th><%=title %></th>
				<td><%=report_content %></td>				
			</tr>
			<tr>
				<td colspan="2">
					<button type="button" class="btn btn-primary">제출</button>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>