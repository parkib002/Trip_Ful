let currentPage = 1;
let isLoading = false;
let lastLoaded = false;

let currentContinent = null;

// ✅ 대륙 기반 관광지 불러오기 (페이지 단위)
function loadContinentPlaces(continent, pageSize = 5) {
  if (isLoading || lastLoaded) return;

  isLoading = true;

  // 정렬 기준 값 가져오기
  const sort = $('#sortSelect').val() || 'popular'; // 기본 조회순

  $.ajax({
    url: 'place/selectContinentPaging.jsp',
    method: 'GET',
    data: {
      continent: continent,
      page: currentPage,
      size: pageSize,
      sort: sort  // 정렬 기준 추가
    },
    dataType: 'json',
    success: function (response) {
      let totalPlaces = 0;

      for (const country in response) {
        if (response.hasOwnProperty(country)) {
          const places = response[country];
          appendPlaces(places);
          totalPlaces += places.length;
        }
      }

      if (totalPlaces === 0) {
        lastLoaded = true;
      } else {
        currentPage++;
      }
    },
    error: function () {
      alert('관광지를 불러오는 데 실패했습니다.');
    },
    complete: function () {
      isLoading = false;
    }
  });
}

// ✅ 대륙 버튼 표시
function showContinents() {
  const $area = $('#selection-area');
  $area.empty();

  const continents = ['asia', 'europe', 'america', 'africa', 'oceania'];
  const $continentRow = $('<div>').addClass('continent-row');

  $.each(continents, function (_, cont) {
    $('<button>')
      .text(cont.charAt(0).toUpperCase() + cont.slice(1))
      .click(() => {
        currentContinent = cont;
        currentPage = 1;
        lastLoaded = false;
        $('#placeContainer').empty();

        loadContinentPlaces(cont, 10); // 최초 10개 로드
      })
      .appendTo($continentRow);
  });

  $continentRow.appendTo($area);
}

// ✅ 관광지 카드 생성
function appendPlaceCard(place, $container) {
  const $card = $('<div class="place-card">').css('cursor', 'pointer');
  const fileName = place.place_img ? place.place_img.split(',')[0] : null;
  const imgPath = fileName ? (fileName.startsWith('save/') ? fileName : './' + fileName) : 'https://via.placeholder.com/200x150?text=No+Image';

  const $infoBar = $('<div class="info-bar">');

  // 별점
  const ratingText = (typeof place.avg_rating === 'number' && place.avg_rating >= 0)
    ? `<span class="info-item rating">⭐ ${place.avg_rating.toFixed(1)}</span>`
    : `<span class="info-item rating no-rating">⭐ 평점없음</span>`;

  // 조회수
  const viewsText = `<span class="info-item views">👁️ ${place.views || 0}</span>`;

  // 좋아요
  const likesText = `<span class="info-item likes">❤️ ${place.likes || 0}</span>`;

  $infoBar.html(ratingText + viewsText + likesText);

  $card.append(
    $('<div class="image-wrapper">').append($('<img>').attr('src', imgPath).attr('alt', place.place_name)),
    $('<div class="caption">').text(place.place_name),
    $infoBar
  );

  $card.click(() => {
    location.href = 'index.jsp?main=place/detailPlace.jsp&place_num=' + place.place_num;
  });

  $container.append($card);
}

// ✅ 관광지 리스트에 추가로 붙이기
function appendPlaces(places) {
  const $container = $('#placeContainer');

  $.each(places, function (_, place) {
    appendPlaceCard(place, $container);
  });
}

// ✅ 무한스크롤 이벤트
$(window).on('scroll', function () {
  if (
    !isLoading &&
    !lastLoaded &&
    currentContinent && // 대륙 선택된 경우에만 작동
    $(window).scrollTop() + $(window).height() + 100 >= $(document).height()
  ) {
    loadContinentPlaces(currentContinent, 5); // 추가 5개씩 로드
  }
});

// ✅ 초기 페이지 로딩: 대륙 버튼만 표시
$(document).ready(function () {
  //showContinents(); // 관광지 출력 X, 대륙 버튼만 표시
});
