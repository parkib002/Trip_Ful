<%@page import="review.ReviewDto"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="review.ReviewDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">

<link
	href="https://fonts.googleapis.com/css2?family=Cute+Font&family=Dongle&family=Gaegu&family=Nanum+Pen+Script&display=swap"
	rel="stylesheet">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.13.1/font/bootstrap-icons.min.css">
<link rel="stylesheet" href="ModalStyle.css">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
<%
	//place_num 얻기
	String place_num=request.getParameter("place_num");	
	ReviewDao rdao=new ReviewDao();
	ReviewDto rdto=new ReviewDto();
	
	//아이디, 로그인상태 세션값 받기
	String review_id=(String)session.getAttribute("id");
	String loginok=(String)session.getAttribute("loginok");
	
	//관광지 이름 얻기
	String place_name=rdao.getPlaceName(review_id);	
	
	//관광지 이름에 해당하는 리뷰리스트
	List<HashMap<String,String>> list=rdao.getPlaceList(place_name);
%>
<script type="text/javascript">
$(function() {
	  $("#modalBtn").click(function() {
		if(<%=loginok!=null%>){
			toggleModal();
		}else{
			var a=confirm("로그인 후 이용 가능합니다\n로그인 페이지로 이동 하시겠습니까?");
			if(a)
			{
				location.href="../index.jsp?main=login/login.jsp";
			}
		}
	}); 
$("#apitest").click(function() {
	var place_num=$("input[name='place_num']").val();
	console.log(place_num);
	$.ajax({
		type:"post",
		dataType:"json",
		url:"insertApi.jsp",
		data:{"place_num":place_num},
		success:function(res){
			//alert("1234");
			var s="";
			var a="";
			 res.reviews.forEach(function(r) {		
				s+="<tr><td><div class='review-header d-flex justify-content-between align-items-center'>";
				s+="<b>"+r.author+"</b>";							
				s+="<div><span class='review_writeday'>"+r.date+"</span>&nbsp;&nbsp;"; 
				s+="<i class='bi bi-three-dots-vertical category'></i><br></div></td></tr></div>";
				s+="<tr><td class='input-group'>";				
				s+="<input	type='hidden' name='review_star' id='review_star' value='"+r.rating+"'>";				 
			 	s+="<div class='review_star'><br>";	
			 	s+="<span>"+r.rating+"</span>&nbsp;&nbsp;";			 	
			 	a="<span class='on'></span>".repeat(Number(r.rating));
			 	a+="<span class='rating'></span>".repeat(5-Number(r.rating));			 	
			 	s+=a;
				s+="<br><br></div></td></tr>";
				s+=""
				s+="<tr><td>";
				s+="<span>"+r.text.replaceAll("\n", "<br>")+"</span><br><hr></td></tr>";
				
	           // console.log(r.author, r.rating, r.text, r.date);
	        });
			 $("#reviewList").html(s);
	    }	    
	});
});	

});
</script>
</head>

<body>

	<!-- 모달 버튼 -->
	<div>
		<button id="modalBtn">리뷰 작성</button>
		<button id="apitest">테스트</button>
	<div class="container mt-3">
		<form action="">
			<table id="reviewList">
					<tr>
						<th style="">
						<b >aaa</b><span >22</span>
						
						</th>
					</tr>
					
			</table>
		</form>
	</div>
</div>
	



	








	<!-- 모달 창 -->
	<div id="myModal" class="modal">
		<form class="modalfrm" enctype="multipart/form-data">
			<div align="center" class="modal-head">
			<input type="hidden" name="place_num" value="26">
				<h4><%=place_name %></h4>
			</div>
			<div class="modal-content">
				<table>
					<tr>
						
						<td>
						<input type="hidden" name="review_id" value="user01">
						<b>user01</b><br> <br>
						</td>
					</tr>
					<tr>
						<td class="input-group"><span>별점</span> &nbsp; <input
							type="hidden" name="review_star" id="review_star" value="0">
							<div class="star_rating">
								​​<span class="star" value="1"></span> 
								<span class="star" value="2"> </span> ​​
								<span class="star" value="3"> </span> ​​
								<span class="star" value="4"> </span> ​​ 
								<span class="star" value="5"> </span>
							</div></td>
					</tr>
					<tr>
						<td><textarea class="review_content" name="review_content"
								required="required"></textarea></td>
					</tr>
					<tr>
						<td>
							<div id="show" >
								<label class="btn-upload">
									<i class="bi bi-camera-fill camera"></i>
									<input type="file" name="review_img" id="file">
								</label>
							</div>
							<br><br>
						</td>
					</tr>

				</table>
			</div>
			<div class="modal-foot">
				<button type="button" class="close" id="closeBtn">취소</button>
				<button type="button" class="save">게시</button>
			</div>
		</form>
	</div>
	 
</body>
<script src="./JavaScript/ModalJs.js"></script>
</html>