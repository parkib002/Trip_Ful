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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<title>Insert title here</title>
<style>
/* 모달창 */
* {
	box-sizing: border-box;
}

.modal {
	/* 스타일 - customize */
	background-color: rgba(0, 0, 0, 0.7);
	pointer-events: none;
	padding: 20px;
	/* 트랜지션 효과 */
	transition: opacity 0.3s ease-in-out;
	opacity: 0;
	/* 화면 전체를 덮게하는 코드 */
	position: fixed;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	/* 중앙에 오게하는 코드 */
	display: flex;
	justify-content: center;
	align-items: center;
}
.modalfrm {
	/* 스타일 - customize */
	max-width: 500px;
	width: 100%;
	height: 800px;
	background-color: white;
	padding: 20px;
	border-radius: 5px;
	box-shadow: 0 0 10px rgba(0, 0, 0, 0.3);
	/* 트랜지션 효과 */
	opacity: 0;
	transition: opacity 0.3s ease-in-out, transform 0.3s ease-in-out;
	transform: scale(0.8);
}

.modal.show {
	/* 모달이 열렸을 때 보여지게 하는 코드 */
	opacity: 1;
	pointer-events: auto;
}

.modal.show .modalfrm {
	/* 모달이 열렸을 때 보여지게 하는 코드 */
	opacity: 1;
	transform: scale(1);
}

.close, .save {
	color: #aaa;
	float: right;
	font-size: 28px;
	font-weight: bold;
	cursor: pointer;
}

.close:hover ,.save:hover{
	color: black;
}
.modal-foot{
	position: fixed;
	bottom: 0px;
	right: 0px;	
}

/* 작성, 취소 버튼 스타일 */
.modal-foot button{
  padding:8px 15px 8px 15px;
  min-width: 100px;
  height: auto; 
  background: #fff;
  color:  #5877f9;
  border: 1px solid #5877f9;
  border-radius: 10px;
  font-size: 15px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;  
  &:hover {
  background: #5877f9;
    color: #fff;
  }
}

/* 별점 스타일 */
.star_rating {
  width: 100%; 
  box-sizing: border-box; 
  display: inline-flex; 
  float: left;
  flex-direction: row; 
  justify-content: flex-start;
  margin-bottom: 10px;
}
.star_rating .star {
  width: 25px; 
  height: 25px; 
  margin-right: 10px;
  display: inline-block; 
  background-image: url("../image/icons8-star-filled-40.png");
  background-repeat: no-repeat;
  background-size: 100%; 
  box-sizing: border-box; 
}
.star_rating .star.on {
  width: 25px; 
  height: 25px;
  margin-right: 10px;
  display: inline-block; 
  background-image: url("../image/icons8-채워진-스타-48.png");
   background-repeat: no-repeat;
  background-size: 100%; 
  box-sizing: border-box; 
}
/* 콘텐츠 스타일 */
.review_content{
	max-width: 100%;
    border: none; 
    resize: none;
    height: 150px;
    margin: 10px 0px 10px;"
    
}
.review_content:focus{
	outline-color: #5877f9;
}
/* 파일 인풋 버튼 스타일 */
.btn-upload {
  padding:8px 15px 8px 15px;
  min-width: 100px;
  height: auto;
  background: #fff;
  color: #5877f9;
  border: 1px solid #5877f9;
  border-radius: 50px;
  font-weight: 500;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;  
  &:hover {
  background: #5877f9;
    color: #fff;
  }
}
#file {

  display: none;
}

/* 모달버튼 */
#modalBtn{
    padding:8px 15px 8px 15px;
    min-width: 100px;
    height: auto;
    box-sizing: border-box;
    border-radius: 50px;
    font-size: 12px;
    font-weight: 700;
    background-color:#5877f9;
    border:2px solid #5877f9;
    color:#ffffff;
}
</style>
<script>

$(function() {	

  // elements
  var modalBtn = $("#modalBtn");
  var modal = $("#myModal");
  var closeBtn = $("#closeBtn");
  var save=$(".save");
 
  
  // 모달제어
  function toggleModal() {
    modal.toggleClass("show");
  }

  // events
  modalBtn.click(function() {
	  toggleModal();
});
  closeBtn.click(function() {
	  toggleModal();
});
  save.click(function() {
	
});

 $(window).on("click", function (event) {
    // 모달의 검은색 배경 부분이 클릭된 경우 닫히도록 하는 코드
    if ($(event.target).is(modal)) {
      toggleModal();
    }
  });
 
 //별점
 $('.star_rating .star').click(function() {
	 
	 var clickedStar=$(this);  
	  
	  //console.log(clickedStar.hasClass("on"));
	  
	    // 이미 on인 경우 = 다시 클릭하면 전부 off
	  if (clickedStar.hasClass('on') && !clickedStar.next().hasClass('on')) {
	    clickedStar.removeClass('on').prevAll('.star').removeClass('on');
	  } else {
	    // 해당 별까지 on, 나머지는 off
	    clickedStar.addClass('on').prevAll('.star').addClass('on');
	    clickedStar.nextAll('.star').removeClass('on');
	  }
		//별점 값 저장 (1~5)
		 var review_star= clickedStar.hasClass('on') ? clickedStar.index() + 1 : 0;
	 	$('#review_star').val(review_star);
	 	//console.log($("#review_star").val());
	});
 
 
	
});
</script>
</head>
<body>

	<!-- 모달 버튼 -->
	<button id="modalBtn">리뷰 작성</button>

	<!-- 모달 창 -->
	<div id="myModal" class="modal">
		<form action="review/reviewaddAction.jsp" method="post" class="modalfrm"
		enctype="multipart/form-data">
			<div align="center" class="modal-head">
				<h4>관광지 이름</h4>
			</div>
				<div class="modal-content" >			
					<table >						
						<tr>
							<td>
								<b>닉네임</b><br>	<br>										
							</td>					
						</tr>
						<tr>
							<td>
								<span>별점</span>	&nbsp;
								<input type="hidden" name="review_star" id="review_star" value="0">
								<div class ="star_rating">
​​									<span class="star" value="1"> </span>
​​									<span class="star" value="2"> </span>
​​									<span class="star" value="3"> </span>
​​									<span class="star" value="4"> </span>
​​									<span class="star" value="5"> </span>
								</div>				
							</td>
						</tr>
						<tr>
							<td>
								<textarea class="review_content" 
								name="review_content" required="required"></textarea>								
							</td>
						</tr>
						<tr>
							<td align="center">
								<label for="file">
 									 <div class="btn-upload">파일 업로드하기</div>
								</label>
									<input type="file" name="review_img" id="file">
							</td>
						</tr>
					</table>
				</div>
				<div class="modal-foot">				
					<button	type="button" class="close" id="closeBtn">취소</button>
					<button type="submit" class="save">게시</button>				
				</div>		
		</form>
	</div>
</body>
</html>