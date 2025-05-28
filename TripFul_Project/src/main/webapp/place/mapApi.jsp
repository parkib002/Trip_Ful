<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <title>관광지 북마크 추가</title>
  <style>
    #map {
      height: 500px;
      width: 100%;
    }
  </style>
</head>
<body>

  <h2>관광지를 검색하세요</h2>
  <input id="autocomplete" type="text" placeholder="관광지를 검색하세요" style="width: 300px;" />
  <button onclick="searchPlace()">검색</button>
  <button onclick="savePlace()">추가</button>

  <div id="map"></div>

  <div id="place-info" style="margin-top:20px;">
    <strong>선택된 장소 정보:</strong>
    <p id="output-name">이름: </p>
    <p id="output-address">주소: </p>
    <p id="output-lat">위도: </p>
    <p id="output-lng">경도: </p>
    <p id="output-placeid">Place ID: </p> <!-- ✅ 추가 -->
  </div>

  <script>
    let map, marker, autocomplete, currentPlace = null;

    function initMap() {
      const defaultCenter = { lat: 37.5665, lng: 126.9780 }; // 서울

      map = new google.maps.Map(document.getElementById("map"), {
        center: defaultCenter,
        zoom: 13
      });

      marker = new google.maps.Marker({ map: map });

      autocomplete = new google.maps.places.Autocomplete(document.getElementById("autocomplete"));

      // 장소 선택 시 정보 저장
      autocomplete.addListener("place_changed", function () {
        const place = autocomplete.getPlace();

        if (!place.geometry) {
          alert("장소 정보를 찾을 수 없습니다.");
          return;
        }

        // ✅ place_id도 포함해서 저장
        currentPlace = {
          name: place.name,
          address: place.formatted_address,
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng(),
          place_id: place.place_id
        };
      });
    }

    // 지도 이동
    function searchPlace() {
      if (!currentPlace) {
        alert("검색어를 입력하고 자동완성에서 장소를 선택해주세요.");
        return;
      }

      const location = new google.maps.LatLng(currentPlace.lat, currentPlace.lng);
      map.setCenter(location);
      map.setZoom(16);
      marker.setPosition(location);
    }

    // 정보 출력
    function savePlace() {
      if (!currentPlace) {
        alert("먼저 장소를 검색하고 선택해주세요.");
        return;
      }

      document.getElementById("output-name").innerText = "이름: " + currentPlace.name;
      document.getElementById("output-address").innerText = "주소: " + currentPlace.address;
      document.getElementById("output-lat").innerText = "위도: " + currentPlace.lat;
      document.getElementById("output-lng").innerText = "경도: " + currentPlace.lng;
      document.getElementById("output-placeid").innerText = "Place ID: " + currentPlace.place_id;

      console.log("저장할 데이터:", currentPlace);
    }
  </script>

  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDpVlcErlSTHrCz7Y4h3_VM8FTMkm9eXAc&libraries=places&callback=initMap" async defer></script>

</body>
</html>