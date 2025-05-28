
function showContinents() {
  const $area = $('#selection-area');
  $area.empty();
  const continents = ['asia', 'europe', 'america', 'africa', 'oceania'];

  $.each(continents, function (_, cont) {
    $('<button>')
      .text(cont.charAt(0).toUpperCase() + cont.slice(1))
      .click(() => {
        console.log('Continent clicked:', cont);
        // AJAX로 나라 목록 가져오기
        $.ajax({
          url: 'place/selectContinentAction.jsp',
          method: 'POST',
          data: { continent: cont },
          dataType: 'json',
          success: function (response) {
            showCountries(cont, response); // 서버에서 받아온 나라-관광지 데이터를 넘김
          },
          error: function () {
            alert('서버에서 데이터를 가져오는 데 실패했습니다.');
          }
        });
      })
      .appendTo($area);
  });

  $('#placeContainer').empty();
}

function showCountries(continent, data) {
  const $area = $('#selection-area');
  $area.empty();

  $('<button>').text('이전').click(showContinents).appendTo($area);

  // 나라 버튼 생성
  $.each(data, function (country, placeList) {
    $('<button>')
      .text(country)
      .click(() => showPlaces(country, placeList))
      .appendTo($area);
  });

  $('#placeContainer').empty();

  // ✅ 모든 관광지를 한 번에 출력하기 위해 배열 합치기
  let allPlaces = [];
  $.each(data, function (_, placeList) {
    allPlaces = allPlaces.concat(placeList);
  });

  // ✅ 대륙에 속한 모든 관광지 먼저 출력
  showPlaces(continent + ' 전체', allPlaces);
}
function showPlaces(country, places) {
  const $container = $('#placeContainer');
  $container.empty();

  $.each(places, function (_, place) {
    const $card = $('<div class="place-card">').css('cursor', 'pointer');

    const fileName = place.place_img;
    const imgPath = fileName ? './image/places/' + fileName : null;
    const $img = $('<img>')
      .attr('alt', place.place_name)
      .css({ width: '200px', height: '150px', objectFit: 'cover' }); // 깜빡임 줄이기 위해 사이즈 고정

    // 먼저 placeholder 설정
    $img.attr('src', 'https://via.placeholder.com/200x150?text=' + encodeURIComponent(place.place_name));

    // 실제 이미지가 있는 경우 로드 시도
    if (imgPath) {
      const testImg = new Image();
      testImg.onload = function () {
        $img.attr('src', imgPath); // 실제 이미지가 존재하면 교체
      };
      testImg.src = imgPath;
    }

    // 카드 구성
    $card.append($img);
    $('<div class="caption">').text(place.place_name).appendTo($card);
    $card.click(() => {
      location.href = 'index.jsp?main=place/detailPlace.jsp?place=' + encodeURIComponent(place.place_name);
    });

    $card.appendTo($container);
  });
}

$(document).ready(showContinents);