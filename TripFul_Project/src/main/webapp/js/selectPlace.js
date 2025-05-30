let currentPage = 1;
let isLoading = false;
let lastLoaded = false;

let currentContinent = null;
let continentDataMap = {};

// ✅ 관광지 로드 함수 (초기 10개, 이후 5개씩)
function loadAllPlaces(pageSize = 10) {
  if (isLoading || lastLoaded) return;

  isLoading = true;

  $.ajax({
    url: 'place/selectAllPlacesAction.jsp',
    method: 'GET',
    data: {
      page: currentPage,
      size: pageSize
    },
    dataType: 'json',
    success: function (response) {
      if (response.length === 0) {
        lastLoaded = true;
        return;
      }

      appendPlaces(response);
      currentPage++;
    },
    error: function () {
      alert('관광지 데이터를 불러오는 데 실패했습니다.');
    },
    complete: function () {
      isLoading = false;
    }
  });
}

// ✅ 대륙 버튼 표시
function showContinents(showAllButton = false) {
  const $area = $('#selection-area');
  $area.empty();

  if (showAllButton) {
    $('<div>').addClass('top-button-row').append(
      $('<button>').text('전체 보기').click(() => {
        resetAndLoad(); // 전체 보기 누르면 리셋 후 다시 로드
      })
    ).appendTo($area);
  }

  const continents = ['asia', 'europe', 'america', 'africa', 'oceania'];
  const $continentRow = $('<div>').addClass('continent-row');

  $.each(continents, function (_, cont) {
    $('<button>')
      .text(cont.charAt(0).toUpperCase() + cont.slice(1))
      .click(() => {
        $.ajax({
          url: 'place/selectContinentAction.jsp',
          method: 'POST',
          data: { continent: cont },
          dataType: 'json',
          success: function (response) {
            currentContinent = cont;
            continentDataMap[cont] = response;
            showCountries(cont, response, false);
          },
          error: function () {
            alert('서버에서 데이터를 가져오는 데 실패했습니다.');
          }
        });
      })
      .appendTo($continentRow);
  });

  $continentRow.appendTo($area);
}

// ✅ 나라 버튼 표시
function showCountries(continent, data, showBackButton = false) {
  const $area = $('#selection-area');
  $area.empty();

  $('<div>').addClass('top-button-row').append(
    $('<button>').text('전체 보기').click(() => {
      resetAndLoad();
    })
  ).appendTo($area);

  const $buttonRow = $('<div>').addClass('continent-row');

  if (showBackButton) {
    $('<button>').text('이전').click(() => {
      showCountries(currentContinent, continentDataMap[currentContinent], false);
    }).appendTo($buttonRow);
  }

  $.each(data, function (country, placeList) {
    $('<button>')
      .text(country)
      .click(() => {
        showCountries(continent, data, true);
        showPlaces(country, placeList);
      })
      .appendTo($buttonRow);
  });

  $buttonRow.appendTo($area);

  $('#placeContainer').empty();

  if (!showBackButton) {
    let allPlaces = [];
    $.each(data, function (_, placeList) {
      allPlaces = allPlaces.concat(placeList);
    });
    showPlaces(continent + ' 전체', allPlaces);
  }
}

// ✅ 관광지 출력
function showPlaces(title, places) {
  const $container = $('#placeContainer');
  $container.empty();

  $.each(places, function (_, place) {
    appendPlaceCard(place, $container);
  });
}

// ✅ 관광지 추가로 붙이기
function appendPlaces(places) {
  const $container = $('#placeContainer');

  $.each(places, function (_, place) {
    appendPlaceCard(place, $container);
  });
}

// ✅ 관광지 카드 생성
function appendPlaceCard(place, $container) {
  const $card = $('<div class="place-card">').css('cursor', 'pointer');
  const $imgWrapper = $('<div class="image-wrapper">');

  const fileName = place.place_img ? place.place_img.split(',')[0] : null;
  let imgPath;

  if (fileName) {
    imgPath = fileName.startsWith('save/') ? fileName : './' + fileName;
  } else {
    imgPath = 'https://via.placeholder.com/200x150?text=No+Image';
  }

  const $img = $('<img>').attr('alt', place.place_name).attr('src', imgPath);
  $imgWrapper.append($img);
  $card.append($imgWrapper);

  $('<div class="caption">')
    .text(place.place_name)
    .css({ margin: '0', paddingBottom: '2px' })
    .appendTo($card);

  const ratingText = (typeof place.avg_rating === 'number' && place.avg_rating >= 0)
    ? '⭐ ' + place.avg_rating.toFixed(1)
    : '⭐ 평점없음';

  $('<div class="rating">')
    .text(ratingText)
    .css({ margin: '0', padding: '0' })
    .appendTo($card);

  $card.click(() => {
    location.href = 'index.jsp?main=place/detailPlace.jsp&place_num=' + place.place_num;
  });

  $container.append($card);
}

// ✅ 초기화 후 전체 관광지 다시 불러오기
function resetAndLoad() {
  currentPage = 1;
  lastLoaded = false;
  $('#placeContainer').empty();
  loadAllPlaces(10);
  showContinents(false);
}

// ✅ 스크롤 이벤트 등록
$(window).on('scroll', function () {
  if (
    !isLoading &&
    !lastLoaded &&
    $(window).scrollTop() + $(window).height() + 100 >= $(document).height()
  ) {
    loadAllPlaces(5); // 스크롤 시 5개씩 로드
  }
});

// ✅ 초기 페이지 로딩
$(document).ready(function () {
  loadAllPlaces(10); // 최초 10개
  showContinents(false);
});
