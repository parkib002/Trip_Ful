let currentPage = 1;
let isLoading = false;
let lastLoaded = false; // 더 이상 데이터가 없으면 true

let currentContinent = null;
let continentDataMap = {}; // 대륙별 데이터 캐싱

// ✅ 전체 관광지 불러오기
function loadAllPlaces(page = 1) {
  if (isLoading || lastLoaded) return;

  isLoading = true;

  $.ajax({
    url: 'place/selectAllPlacesAction.jsp',
    method: 'GET',
    data: { page: page }, // ✅ 페이지 번호 전송
    dataType: 'json',
    success: function (response) {
      if (response.length === 0) {
        lastLoaded = true;
        return;
      }

      appendPlaces(response); // ✅ 기존 showPlaces() → append 방식으로 변경
      currentPage++; // 다음 페이지를 위해 증가
    },
    error: function () {
      alert('관광지 데이터를 불러오는 데 실패했습니다.');
    },
    complete: function () {
      isLoading = false;
    }
  });
}

// ✅ 대륙 버튼 표시 (전체 보기 버튼 포함 여부 옵션)
function showContinents(showAllButton = false) {
  const $area = $('#selection-area');
  $area.empty();

  // 전체 보기 버튼은 옵션에 따라 표시
  if (showAllButton) {
    $('<div>').addClass('top-button-row').append(
      $('<button>').text('전체 보기').click(() => {
        loadAllPlaces();
        showContinents(false); // 전체 보기 클릭 후 전체보기 버튼 숨김
      })
    ).appendTo($area);
  }

  // 대륙 버튼 표시
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
            showCountries(cont, response, false); // 대륙 클릭: 이전 버튼 없음
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

  // 맨 위: 전체 보기 버튼 고정
  $('<div>').addClass('top-button-row').append(
    $('<button>').text('전체 보기').click(() => {
      loadAllPlaces();
      showContinents(false); // 전체 보기 후 버튼 숨김
    })
  ).appendTo($area);

  const $buttonRow = $('<div>').addClass('continent-row');

  // 나라 클릭 시에만 이전 버튼 생성
  if (showBackButton) {
    $('<button>').text('이전').click(() => {
      showCountries(currentContinent, continentDataMap[currentContinent], false);
    }).appendTo($buttonRow);
  }

  // 나라별 버튼 생성
  $.each(data, function (country, placeList) {
    $('<button>')
      .text(country)
      .click(() => {
        showCountries(continent, data, true); // 나라 클릭 시 이전 버튼 포함
        showPlaces(country, placeList);
      })
      .appendTo($buttonRow);
  });

  $buttonRow.appendTo($area);

  $('#placeContainer').empty();

  // 나라 클릭이 아닐 때만 대륙의 전체 관광지 보여줌
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
    const $card = $('<div class="place-card">').css('cursor', 'pointer');

    const fileName = place.place_img;
    const imgPath = fileName
      ? './image/places/' + fileName
      : 'https://via.placeholder.com/200x150?text=No+Image';

    const $img = $('<img>')
      .attr('alt', place.place_name)
      .attr('src', imgPath)
      .css({
        width: '200px',
        height: '150px',
        objectFit: 'cover'
      });

    $card.append($img);
    $('<div class="caption">').text(place.place_name).appendTo($card);

    $card.click(() => {
      const targetUrl = 'index.jsp?main=place/detailPlace.jsp' +
                        '&place_num=' + place.place_num;
      location.href = targetUrl;
    });

    $card.appendTo($container);
  });
}

function appendPlaces(places) {
  const $container = $('#placeContainer');

  $.each(places, function (_, place) {
    const $card = $('<div class="place-card">').css('cursor', 'pointer');

    const fileName = place.place_img;
    const imgPath = fileName
      ? './image/places/' + fileName
      : 'https://via.placeholder.com/200x150?text=No+Image';

    const $img = $('<img>')
      .attr('alt', place.place_name)
      .attr('src', imgPath);

    $card.append($img);
    $('<div class="caption">').text(place.place_name).appendTo($card);

    $card.click(() => {
      location.href = 'index.jsp?main=place/detailPlace.jsp&place_num=' + place.place_num;
    });

    $container.append($card);
  });
}


// ✅ 페이지 로딩 시 전체 관광지 출력 + 대륙 버튼만 표시 (전체보기 버튼 없음)
$(document).ready(function () {
  loadAllPlaces();
  showContinents(false); // 전체 보기 버튼 없음
});
