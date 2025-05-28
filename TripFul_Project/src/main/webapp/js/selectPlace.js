const data = {
  asia: {
    Japan: ['도쿄 도쿄타워', '오사카 오사카성'],
    Korea: ['서울 경복궁', '부산 해운대', '제주도 성산일출봉', '전주 한옥마을']
  },
  europe: {
    France: ['파리 에펠탑', '파리 루브르 박물관'],
    Italy: ['로마 콜로세움', '베네치아 베네치아 운하']
  },
  america: {
    USA: ['뉴욕 자유의 여신상', '그랜드 캐니언'],
    Brazil: ['리우 해변', '아마존 정글']
  },
  africa: {
    Egypt: ['피라미드', '카이로 박물관'],
    Kenya: ['마사이마라', '나이로비 국립공원']
  },
  oceania: {
    Australia: ['시드니 오페라 하우스', '그레이트 배리어 리프'],
    NewZealand: ['밀포드 사운드', '호빗 마을']
  }
};

const imageMap = {
  '서울 경복궁': '경복궁.jpg',
  '부산 해운대': '해운대.jpg',
  '제주도 성산일출봉': '성산일출봉.jpg',
  '전주 한옥마을': '한옥마을.jpg',
  '도쿄 도쿄타워': '도쿄타워.jpg',
  '오사카 오사카성': '오사카성.jpg'
};

function showContinents() {
  const $area = $('#selection-area');
  $area.empty();
  const continents = ['asia', 'europe', 'america', 'africa', 'oceania'];
  $.each(continents, function (_, cont) {
    $('<button>')
      .text(cont.charAt(0).toUpperCase() + cont.slice(1))
      .click(() => {
        console.log('Continent clicked:', cont);  // ← 추가
        showCountries(cont);
      })
      .appendTo($area);
  });
  $('#placeContainer').empty();
}

function showCountries(continent) {
  const $area = $('#selection-area');
  $area.empty();
  $('<button>').text('이전').click(showContinents).appendTo($area);
  $.each(data[continent], function (country, _) {
    $('<button>')
      .text(country)
      .click(() => showPlaces(continent, country))
      .appendTo($area);
  });
  $('#placeContainer').empty();
}

function showPlaces(continent, country) {
  const places = data[continent][country];
  const $container = $('#placeContainer');
  $container.empty();
  $.each(places, function (_, place) {
    const $card = $('<div class="place-card">')
      .css('cursor', 'pointer')
      .click(() => {
        location.href = 'index.jsp?main=place/detailPlace.jsp?place=' + encodeURIComponent(place);
      });

    const fileName = imageMap[place];
    const imgPath = fileName ? './image/places/' + fileName : null;

    $('<img>')
      .attr('src', imgPath)
      .attr('alt', place)
      .on('error', function () {
        $(this).attr('src', 'https://via.placeholder.com/200x150?text=' + encodeURIComponent(place));
      })
      .appendTo($card);

    $('<div class="caption">').text(place).appendTo($card);
    $card.appendTo($container);
  });
}

$(document).ready(showContinents);
