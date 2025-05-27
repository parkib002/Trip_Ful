<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 선택 페이지</title>
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <style>
    body {
      font-family: 'Segoe UI', sans-serif;
      margin: 0;
      padding: 0;
      background-color: #f4f4f4;
    }
    header {
      background-color: #2196f3;
      padding: 1rem;
      color: white;
      text-align: center;
    }
    .container {
      padding: 2rem;
      max-width: 1000px;
      margin: auto;
    }
    .selection-buttons {
      display: flex;
      flex-wrap: wrap;
      gap: 1rem;
      margin-bottom: 1.5rem;
      align-items: center;
      justify-content: center;
      text-align: center;
    }
    .selection-buttons button {
      padding: 0.75rem 1.5rem;
      background-color: #fff;
      border: 2px solid #2196f3;
      color: #2196f3;
      cursor: pointer;
      border-radius: 0.5rem;
      transition: all 0.3s ease;
    }
    .selection-buttons button:hover {
      background-color: #2196f3;
      color: white;
    }
    .places {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
      gap: 1rem;
    }
    .place-card {
      background-color: white;
      border-radius: 0.5rem;
      box-shadow: 0 2px 5px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    .place-card img {
      width: 100%;
      height: 150px;
      object-fit: cover;
    }
    .place-card .caption {
      padding: 0.75rem;
      text-align: center;
    }
    
    .place-card img {
  width: 100%;
  height: 150px;
  object-fit: cover;
  transition: transform 0.3s ease; /* 부드러운 애니메이션 */
}

.place-card:hover img {
  transform: scale(0.95); /* 95% 크기로 축소 */
}
  </style>
</head>
<body>
  <header>
    <h1>관광지 선택</h1>
  </header>

  <div class="container">
    <div class="selection-buttons" id="selection-area"></div>
    <div class="places" id="placeContainer"></div>
  </div>

  <script>
    const data = {
      asia: {
        Japan: ['도쿄 도쿄타워', '오사카 오사카성'],
        Korea: ['서울 경복궁', '부산 해운대','제주도 성산일출봉','전주 한옥마을']
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

    function showContinents() {
      const $area = $('#selection-area');
      $area.empty();
      const continents = ['asia', 'europe', 'america', 'africa', 'oceania'];
      $.each(continents, function(_, cont) {
        $('<button>')
          .text(cont.charAt(0).toUpperCase() + cont.slice(1))
          .click(() => showCountries(cont))
          .appendTo($area);
      });
      $('#placeContainer').empty();
    }

    function showCountries(continent) {
      const $area = $('#selection-area');
      $area.empty();
      $('<button>').text('이전').click(showContinents).appendTo($area);
      $.each(data[continent], function(country, _) {
        $('<button>')
          .text(country)
          .click(() => showPlaces(continent, country))
          .appendTo($area);
      });
      $('#placeContainer').empty();
    }

    const imageMap = {
    		  '서울 경복궁': '경복궁.jpg',
    		  '부산 해운대': '해운대.jpg',
    		  '제주도 성산일출봉': '성산일출봉.jpg',
    		  '전주 한옥마을': '한옥마을.jpg',
    		  // 다른 관광지도 필요시 추가
    		  '도쿄 도쿄타워': '도쿄타워.jpg',
    		  '오사카 오사카성': '오사카성.jpg'
    		  
    		};

    		function showPlaces(continent, country) {
    		  const places = data[continent][country];
    		  const $container = $('#placeContainer');
    		  $container.empty();
    		  $.each(places, function(_, place) {
    		    const $card = $('<div class="place-card">');

    		    const fileName = imageMap[place]; // 정확한 파일명 사용
    		    const imgPath = fileName ? '../image/places/' + fileName : null;

    		    $('<img>')
    		      .attr('src', imgPath)
    		      .attr('alt', place)
    		      .on('error', function() {
    		        $(this).attr('src', 'https://via.placeholder.com/200x150?text=' + encodeURIComponent(place));
    		      })
    		      .appendTo($card);

    		    $('<div class="caption">').text(place).appendTo($card);
    		    $card.appendTo($container);
    		  });
    		}

    $(document).ready(showContinents);
    
    //test
  </script>
</body>
</html>

