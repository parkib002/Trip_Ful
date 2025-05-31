
	
	




	$(document).on('click', '.category', function(e) {
        // 현재 클릭된 아이콘의 review-id를 가져옵니다. (옵션)
        var clickedId = $(this).attr("review_id");
		console.log(clickedId);
        // 다른 모든 열려있는 드롭다운 메뉴를 닫습니다.
        // 현재 클릭된 메뉴만 열리도록 하기 위함.
        $('.dropdown-menu').not($(this).next('.dropdown-menu')).slideUp(100);

        // 현재 클릭된 아이콘 바로 다음에 오는 '.dropdown-menu'를 찾아서 토글합니다.
        $(this).next('.dropdown-menu').slideToggle(100); // slideToggle로 부드러운 효과

        // 클릭 이벤트가 버블링되는 것을 막아, document 클릭 시 닫히는 이벤트와 충돌 방지
        e.stopPropagation();
    });

    // 2. 드롭다운 메뉴 외부를 클릭했을 때 메뉴 닫기
    $(document).on('click', function() {
        $('.dropdown-menu').slideUp(100);
    });