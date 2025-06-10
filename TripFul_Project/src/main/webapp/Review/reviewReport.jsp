<%@page import="review.ReportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="Review/report.css">
<title>Insert title here</title>
<%	
	String review_idx=request.getParameter("review_idx");		
%>
<script type="text/javascript">
	$(function() {
		var review_idx=<%=review_idx%>
		
		//console.log(review_idx);
		$(".report_tr").click(function() {
			var title=$(this).find(".report_title").text();			
			var content=$(this).find(".report_text").text();	
			
			//console.log(title, content);
			$("input[name='review_title']").val(title);
			$("input[name='review_content']").val(content);		
			//console.log($("input[name='review_title']").val(),$("input[name='review_content']").val());
			
			
			$("#myform").submit();
			
		   
		});
		
	});	
</script>
</head>

<body>
	<div class="container mt-3 report_box" >
	<form id="myform" action="Review/reportForm.jsp" method="post" >
	<input type="hidden" name="review_idx" value="<%=review_idx%>">
	<input type="hidden" name="review_title" value="">
	<input type="hidden" name="review_content" value="">
	<h4 class="report_main_title">리뷰 신고</h4>
		<table class="table table-hover report_table" >
			<tr class="report_tr">			
				<td>
					<div class="report_con">						
							<h5 class="report_title">주제에서 벗어남</h5>					
							<span class="report_text">해당 비즈니스의 이용 경험과 관련이 없는 리뷰입니다.</span>	
					</div>
				</td>
				<td>
					<i class="bi bi-chevron-right report_right"></i>					
				</td>
			</tr>
			<tr class="report_tr">			
				<td>
					<div class="report_con" >						
							<h5 class="report_title">스팸</h5>							
							<span class="report_text">봇 또는 가짜 계정에서 작성되었거나 광고 또는 프로<br>
							모션이 포함된 리뷰입니다.</span>						
						</div>					
				</td>
				<td>					
					<i class="bi bi-chevron-right report_right"></i>					
				</td>
			</tr>
			<tr class="report_tr">			
				<td>
					<div class="report_con"  >						
							<h5 class="report_title">욕설</h5>							
							<span class="report_text">리뷰에 욕설을 포함하거나, 성적인 언어를 노골적으로<br>
							 사용하거나, 폭력 행위를 사실적으로 묘사합니다.</span>						
					</div>					
				</td>
				<td>					
					<i class="bi bi-chevron-right report_right"></i>					
				</td>
			</tr>
			<tr class="report_tr">			
				<td>
					<div class="report_con"  >						
							<h5 class="report_title">차별 또는 증오심 표현</h5>							
							<span class="report_text">정체성을 근거로 개인 또는 집단에 위해를 가하는 표현이<br>
								 사용된 리뷰입니다.</span>						
						</div>					
				</td>
				<td>					
					<i class="bi bi-chevron-right report_right"></i>					
				</td>
			</tr>
			<tr class="report_tr">			
				<td>
					<div class="report_con"  >					
							<h5 class="report_title">도움이 되지 않음</h5>							
							<span class="report_text">리뷰가 이 장소에 갈지 여부를 결정하는 데 도움이 되지<br>
								 않음.</span>						
						</div>					
				</td>
				<td>					
					<i class="bi bi-chevron-right report_right"></i>					
				</td>
			</tr>
		</table>	
		</form>	
	</div>
</body>
</html>