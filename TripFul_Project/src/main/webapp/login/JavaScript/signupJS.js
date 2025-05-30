/**
 * 
 */

function chkSignUp() {
	if ($(".sign-up-htm").children().find("label").hasClass("error")) {
		//console.log("에러 클래스 있음");
		return false;
	}
	else {
		//console.log("에러 클래스 못찾음");
		return true;
	}
}

function chkSignIn(){
	if ($(".sign-in-html").children().find("label").hasClass("error")){
		return false;
	}
	else {
		return true;
	}
}


$("#id").keyup(function() {
	//ajax를 통한 비동기 방식으로 중복 처리
	var inputId = $("#id");
	$.ajax({
		type: "get",
		url: "./checkDuplication.jsp",
		data: { "id": inputId.val() },
		dataType: "html",
		success: function(res) {
			if (res.trim() == 1) {
				inputId.siblings(".label").text("아이디      중복된 아이디입니다.");
				inputId.siblings(".label").addClass("error");
				console.log(res.trim());
			}
			else if (res.trim() == 2) {
				inputId.siblings(".label").text("아이디      6글자 이상 16글자 이하의 아이디를 입력하세요.");
				inputId.siblings(".label").addClass("error");
				console.log(res.trim());
			}
			else if (res.trim() == 3) {
				inputId.siblings(".label").text("아이디      사용불가능한 문자가 포함 되었습니다.");
				inputId.siblings(".label").addClass("error");
				//console.log(res.trim());
			}
			else if (res.trim() == 4) {
				inputId.siblings(".label").text("아이디      영문과 숫자가 모두 포함되어야 합니다.");
				inputId.siblings(".label").addClass("error");
				//console.log(res.trim());
			}
			else {
				inputId.siblings(".label").text("아이디      사용가능한 아이디입니다.");
				inputId.siblings(".label").removeClass("error");
				//console.log(res.trim());
			}
		}
	})
})

$("#pw").keyup(function() {
	if ($(this).val() == "") {
		$(this).siblings(".label").text("비밀번호");
		$(this).siblings(".label").removeClass("error");
	}
	else if ($(this).val().includes('!') || $(this).val().includes('@') || $(this).val().includes('#') || $(this).val().includes('$') ||
		$(this).val().includes('!') || $(this).val().includes('%') || $(this).val().includes('^') || $(this).val().includes('&')) {
		if ($(this).val().length >= 8 && $(this).val().length <= 16) {
			$(this).siblings(".label").text("비밀번호");
			$(this).siblings(".label").removeClass("error");
		}
		else {
			$(this).siblings(".label").text("비밀번호      8자리 이상 16자리 이하여야 합니다.");
			$(this).siblings(".label").addClass("error");
		}
	}
	else {
		$(this).siblings(".label").text("비밀번호      특수문자를 입력해주세요");
		$(this).siblings(".label").addClass("error");
	}
})
$("#birth").keyup(function() {
	if (isNaN($(this).val())) {
		$(this).siblings(".label").text("생년월일      숫자로만 입력해주세요.");
		$(this).siblings(".label").addClass("error");
	}
	else if ($(this).val().length != 6 && $(this).val() == "") {
		$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
		$(this).siblings(".label").addClass("error");
	}
	else {
		var year = $(this).val().substring(0, 2);
		var month = $(this).val().substring(2, 4);
		var day = $(this).val().substring(4, 6);

		if (Number(month) > 12 || Number(month) <= 0) {
			$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
			$(this).siblings(".label").addClass("error");
		}
		else if (Number(day) > 31 || Number(day) <= 0) {
			$(this).siblings(".label").text("생년월일     6자리 YYMMDD형태로 입력해주세요.");
			$(this).siblings(".label").addClass("error");
		}
		else {
			$(this).siblings(".label").text("생년월일");
			$(this).siblings(".label").removeClass("error");
		}
	}
	
	function googleHandle(){
		alert("로그인 됬나?");
	}

})