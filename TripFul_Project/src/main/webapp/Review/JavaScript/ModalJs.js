// elements
var modalBtn = $("#modalBtn");
var modal = $("#myModal");
var closeBtn = $("#closeBtn");
var submitReviewBtn = $("#btn-write"); // #btn-write ID를 가진 버튼이 '게시'/'수정' 역할

// 마우스가 눌렸을 때 (mousedown) 모달 내에 있었는지 추적하는 변수
var mouseEvent = false;

// --- 공통 함수들 ---

/* 모달을 열고 'show' 클래스를 추가하는 함수. */
function openModal() {
    $('.modal').css('display', 'flex');
    setTimeout(function() {
        $('.modal').addClass('show');
    }, 10);
}

/* 모달을 닫고 리뷰 목록을 새로고침하는 함수.*/
function closeModalAndRefresh() {
    $('.modal').removeClass('show');
    setTimeout(function() {
        $('.modal').css('display', 'none');

        if (typeof loadReviews === 'function') {
            loadReviews();
        } else {
            console.error("loadReviews 함수를 찾을 수 없습니다. 스크립트 로드 순서 확인 필요.");
        }
    }, 300);
}

/* 모달 내부 폼과 UI를 초기화하는 함수. */
function resetModalForm() {
    $("#modalform")[0].reset(); // 폼 필드 초기화
    $("#review_star").val(0); // 별점 값 0으로 초기화
    $("#myModal .star_rating .star").removeClass('on'); // 별점 UI 초기화 (모든 별 'on'클래스 제거)
    $("#show").find(".img-wrapper").remove(); // 이미지 미리보기 제거
    $(".btn-upload").show(); // 이미지 업로드 버튼 다시 표시
    submitReviewBtn.text("게시"); // 버튼 텍스트를 '게시'로 설정
    $("input[name='review_idx']").val(""); // review_idx 숨김 필드 초기화
    $(".review_content").val(""); // textarea 내용도 초기화 (reset()으로 안될 수 있음)
}

/* 업데이트 모달창 클릭 시 기존 리뷰 데이터를 모달에 채워 넣는 함수.
 * @param {jQuery} $reviewItem 클릭된 '.item' 요소 (현재 리뷰 카드)
 */
function updateModalData(reviewItem) {
	
    // 버튼 텍스트를 '수정'으로 변경
    submitReviewBtn.text("수정");

    var review_idx = reviewItem.find(".updateModal").attr("review_idx"); // updateModal 버튼에서 가져옴
    $("input[name='review_idx']").val(review_idx);

    var rating = Number(reviewItem.find("input[name='rating']").val());
    var stars = $("#myModal .star_rating .star");
    stars.removeClass("on"); // 기존 초기화 후 다시 설정
    stars.each(function(index) {
        if (index < rating) {
            $(this).addClass('on');
        }
    });
    $("#review_star").val(rating); // 숨겨진 input에도 값 설정

    var getcontent = reviewItem.find("p.card-text").text();
    $(".review_content").val(getcontent); // textarea에 내용 채우기

    var getimg = reviewItem.find("img.photo").attr("src"); // 이미지값 가져오기
    var btnUpload = $(".btn-upload");
    var showContainer = $("#show");
	var fileName = getimg ? getimg.substring(getimg.lastIndexOf('/') + 1) : "";
	
	//console.log(fileName);
	}
	/*modalBtn.click(function() {
			toggleModal();
		});*/

	
    showContainer.find(".img-wrapper").remove(); // 기존 이미지 미리보기 삭제
    if (getimg && getimg !== "null" && getimg !== "undefined" && getimg !== "") { // 이미지 유효성 검사
        btnUpload.hide();
        
        showContainer.append("<div class='img-wrapper'><img id='showimg' src='" + getimg + "'><i class='bi bi-x img-icon'></i></div>");
		$("input[name='photo']").val(fileName);
    } else {
        btnUpload.show(); // 이미지가 없으면 업로드 버튼 표시
		$("input[name='photo']").val("");
    }
	



// --- 이벤트 핸들러 ---

// 닫기 버튼 클릭 시
closeBtn.click(function() {
    closeModalAndRefresh();
});

// '게시' 또는 '수정' 버튼 클릭 시 
submitReviewBtn.click(function(e) {
    e.preventDefault();

    var frm = $("#modalform")[0];
    if (!frm) {
        console.error("오류: 폼 요소를 찾을 수 없습니다.");
        return;
    }

    var formData = new FormData(frm);
    var actionUrl = "";

    if (submitReviewBtn.text() === "게시") {
        actionUrl = "Review/reviewAddAction.jsp";
        console.log("새 리뷰 데이터 전송:", formData);
    } else if (submitReviewBtn.text() === "수정") {
        actionUrl = "Review/updateReview.jsp";
        console.log("업데이트 리뷰 데이터 전송:", formData);
    } else {
        console.error("알 수 없는 버튼 상태입니다.");
        return;
    }

    $.ajax({
        type: "post",
        dataType: "html",
        url: actionUrl,
        data: formData,
        processData: false,
        contentType: false,
        success: function() {
            console.log("AJAX 작업 성공");
            closeModalAndRefresh(); // 성공 시 모달 닫고 목록 새로고침
        },
        error: function(xhr, status, error) {
            console.error("AJAX 작업 실패:", status, error);
            alert("작업 중 오류가 발생했습니다.");
        }
    });
});

// 마우스가 눌렸을 때 (mousedown) 모달 내에 있었는지 여부 추적
$(modal).mousedown(function() {
    mouseEvent = true;
});
// 마우스가 떼어졌을 때 (mouseup) 모달 내에 있었는지 여부 초기화
$(modal).mouseup(function() {
    mouseEvent = false;
});

$(window).click(function(event) {
    // 모달의 검은색 배경 부분이 클릭된 경우 닫히도록 하는 코드
    if ($(event.target).is(modal) && !mouseEvent) {
        closeModalAndRefresh();
    }
});


// 별점 클릭 이벤트
$(".star_rating .star").click(function() {
    var clickedStar = $(this);
    if (clickedStar.hasClass('on') && !clickedStar.next().hasClass('on')) {
        clickedStar.removeClass('on').prevAll('.star').removeClass('on');
    } else {
        clickedStar.addClass('on').prevAll('.star').addClass('on');
        clickedStar.nextAll('.star').removeClass('on');
    }
    var review_star = clickedStar.hasClass('on') ? clickedStar.index() + 1 : 0;
    $('#review_star').val(review_star);
});

// 파일 선택 이벤트
$("#file").change(function() {
    const file = this.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            $("#show").find(".img-wrapper").remove();
            $(".btn-upload").hide();
            $("#show").append("<div class='img-wrapper'><img id='showimg' src='" + e.target.result + "'><i class='bi bi-x img-icon'></i></div>");
        };
        reader.readAsDataURL(file);
    }
});

// 이미지 클릭 시 파일 선택 다시 열기
$(document).on("click", "#showimg", function() {
    $("#file").click();
});

// 이미지 삭제 아이콘 클릭 시
$(document).on("click", ".img-icon", function(e) {
    e.stopPropagation();
    $(".img-wrapper").hide();
    $(".btn-upload").show();
	$("input[name='photo']").val("");
});


// 업데이트 모달창 버튼
$(document).on("click", ".updateModal", function() {
    // 폼 초기화 (새 리뷰 작성 모드에서 바뀐 상태를 되돌림)
    resetModalForm(); // 모든 것을 초기화

    // 클릭된 리뷰 아이템 찾기
    var reviewItem = $(this).closest(".item");
    
    // 기존 리뷰 데이터로 모달 내용 채우기
    updateModalData(reviewItem);

    // 모달 열기
    openModal();
});
