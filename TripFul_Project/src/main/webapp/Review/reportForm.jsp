<%@page import="review.ReviewDao"%>
<%@page import="review.ReportDto"%>
<%@page import="review.ReportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="<%=request.getContextPath() %>/Review/report.css">
<link href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>  
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
<%	
	request.setCharacterEncoding("utf-8");
	String review_idx=request.getParameter("review_idx");
	String title=request.getParameter("review_title");
	String report_content=request.getParameter("review_content");
	String member_id=(String)session.getAttribute("id");
	
	ReviewDao rdao=new ReviewDao();
	String place_num=rdao.getPlaceNum(review_idx);
	
	
	ReportDao dao=new ReportDao();
	//아이디 체크
	int idcheck=dao.getIdCheck(member_id, review_idx);
	//신고체크
	int cntcheck=dao.getCntCheck(member_id,review_idx);
	
	
%>
<script type="text/javascript">
	$(function() {
		
	
	$(".report_write").click(function() {	
		var idcheck=<%=idcheck%>
		var cntcheck=<%=cntcheck%>
		//alert(idcheck>0?"true":"false");
		if(idcheck>0)			
		{	
			if(cntcheck>0)
				{
				alert("이미 신고한 리뷰입니다");
				location.href="../index.jsp?main=place/detailPlace.jsp?place_num="+<%=place_num%>;
				}else{
					//alert("1234");
					var review_idx=$("#review_idx").val();
					var report_content=$("#report_content").val();
					$.ajax({
						type:"post",
						dataType:"html",
						url:"reportUpdate.jsp",
						data:{"review_idx":review_idx,"report_content":report_content},
						success:function(){
							//alert("1234");
							location.href="../index.jsp?main=place/detailPlace.jsp?place_num="+<%=place_num%>;
						}
					});
				}		
		}else
		{
			//alert("1234");
			var review_idx=$("#review_idx").val();
			var report_content=$("#report_content").val();
			$.ajax({
				type:"post",
				dataType:"html",
				url:"reportAction.jsp",
				data:{"review_idx":review_idx,"report_content":report_content},
				success:function(){
					//alert("1234");
					location.href="../index.jsp?main=place/detailPlace.jsp?place_num="+<%=place_num%>;
				}
			});
		}
	});
	
	$("i.back").click(function(){
		history.back();
	});
	});
</script>
</head>

<body>
	<div class="container mt-3 report_box2" >	
	<input type="hidden" id="review_idx" name="review_idx" value="<%=review_idx%>">
	<input type="hidden" id="report_content" name="report_content" value="<%=report_content%>">
		<table class="table table-borderless report_container" >
		<caption align="top"><i class="bi bi-arrow-left-short back"></i></caption>
			<tr>
				<td>
					<h4><%=title %></h4>
					<br>
					<span><%=report_content %></span>					
				</td>				
			</tr>
			<tr>
				<td colspan="2" >
					<button type="button" class="btn btn-primary report_write">제출</button>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>