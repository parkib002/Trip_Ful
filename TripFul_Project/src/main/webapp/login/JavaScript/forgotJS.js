/**
 * 
 */

function findfunc() {

	window.open("./login/findID.jsp", "popup_findID", "width=400, height=200,scrollbars=no,resizable=no,status=no,top=300,left=800");

	$("#findID").attr("target", "popup_findID").submit();

}

function findPass() {
	$.ajax({
			type: "get",
			url: "./login/authentication.jsp",
			data: { "id": $("#f_id").val(),
				"name": $("#f_name").val(),
				"email": $("#f_email").val()
			 },
			dataType: "html",
			success: function(res) {
				if (res.trim() == "false") {
					alert("정보가 틀렸습니다.");
					
				}
				else {
					$("#findPW").attr("action", "/TripFul_Project/index.jsp?main=login/changeForm.jsp?status=1&id="+$("#f_id").val()); // action 재확인
					$("#findPW").submit(); // 폼을 수동으로 제출
				}
			}
		})
}

function changePass(){
	if($("#n_pw").hasClass("error")){
		alert("새 비밀번호는 이전 비밀번호와 동일 할 수 없습니다.");
	}
	else if($("#n_pw").hasClass("eerror")){
		alert("비밀번호는 특수 문자가 필요합니다.")
	}
	else if($("#n_pw").hasClass("errorr")){
		alert("비밀번호는 8글자 이상 16글자 이하여야 합니다.");
	}
	else if ($("#r_pw").hasClass("error")){
		alert("새 비밀번호와 재입력한 비밀번호가 다릅니다.");
	}
	else if ($("#n_pw").val()==null||$("#r_pw").val()==null){
		alert("모든 값을 입력해 주세요.");
	}
	
	else{
		$("#npw").submit();
	}
}


$("#r_pw").keyup(function(){
	if($("#n_pw").val()!=$(this).val()){
		$(this).addClass("error");
	}
	else{
		$(this).removeClass("error");
	}
})