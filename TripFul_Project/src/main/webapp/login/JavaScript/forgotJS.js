/**
 * 
 */

function findfunc() {

	window.open("findID.jsp", "popup_findID", "width=400, height=200,scrollbars=no,resizable=no,status=no,top=300,left=800");

	$("#findID").attr("target", "popup_findID").submit();

}

function findPass() {

	window.open("findPW.jsp", "popup_findPW", "width=400, height=200,scrollbars=no,resizable=no,status=no,top=300,left=800");

	$("#findPW").attr("target", "popup_findPW").submit();

}

function changePass(){
	if($("#n_pw").hasClass("error")){
		alert("새 비밀번호는 이전 비밀번호와 동일 할 수 없습니다.");
	}
	else if ($("#r_pw").hasClass("error")){
		alert("새 비밀번호와 재입력한 비밀번호가 다릅니다.");
	}
	else if ($("#n_pw").val()==null||$("#r_pw").val()==null){
		alert("모든 값을 입력해 주세요.");
	}
	else{
		alert("굿");
	}
}

$("#n_pw").keyup(function(){
	if($("#pw").val()==$(this).val()){
		$(this).addClass("error");
	}
	else if(!(/abc/.test($(this).val())){
		
	}
	else{
		$(this).removeClass("error");
	}
})
$("#r_pw").keyup(function(){
	if($("#n_pw").val()!=$(this).val()){
		$(this).addClass("error");
	}
	else{
		$(this).removeClass("error");
	}
})