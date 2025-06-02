<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 필수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 수정</title>
<%
	String num=request.getParameter("place_num"); 

	PlaceDao dao=new PlaceDao();
	
	PlaceDto dto=dao.getPlaceData(num);
	
    String content = dto.getPlace_content();
    String imgPaths = dto.getPlace_img();

    String imgTags = "";
    if (imgPaths != null && imgPaths.trim().length() > 0) {
        String[] paths = imgPaths.split(",");
        StringBuilder sb = new StringBuilder();
        for (String path : paths) {
            sb.append("<img src='").append(path.trim()).append("' style='max-width:100%;'><br>");
        }
        imgTags = sb.toString();
    }

    String combinedContent = (content != null ? content : "") + "<br>" + imgTags;

    // 자바스크립트에 그대로 넣을 문자열로 이스케이프
    String jsEscapedContent = combinedContent.replace("\\", "\\\\")
                                             .replace("\"", "\\\"")
                                             .replace("\'", "\\\'")
                                             .replace("\r", "\\r")
                                             .replace("\n", "\\n");
%>
  <style>
    #map {
      height: 500px;
      width: 100%;
    }
  </style>
  
  <script>
  $(document).ready(function() {
	  $('#summernote').summernote({
	    height: 300,
	    placeholder: '내용을 입력하세요...',
	    toolbar: [
	      ['style', ['bold', 'italic', 'underline', 'clear']],
	      ['font', ['strikethrough', 'superscript', 'subscript']],
	      ['color', ['color']],
	      ['para', ['ul', 'ol', 'paragraph']],
	      ['insert', ['link', 'picture']],
	      ['view', ['fullscreen', 'codeview']]
	    ]
	  });

	  // 서버에서 받아온 내용 + 이미지 넣기
	  var initialContent = "<%= jsEscapedContent %>";
	  $('#summernote').summernote('code', initialContent);
	});
  
  $('#summernote').summernote({
	  height: 300,
	  callbacks: {
	    onImageUpload: function(files) {
	      for (let i = 0; i < files.length; i++) {
	        sendFile(files[i]);
	      }
	    }
	  }
	});

	function sendFile(file) {
	  const data = new FormData();
	  data.append("file", file);
	  $.ajax({
	    url: 'uploadImage.jsp',  // 이미지 저장 처리용 JSP
	    type: 'POST',
	    data: data,
	    contentType: false,
	    processData: false,
	    success: function(url) {
	      $('#summernote').summernote('insertImage', url); // 이게 핵심
	    }
	  });
	}
</script>


</head>

<body>

  <h2>수정할 관광지를 검색하세요</h2>
  <input id="autocomplete" type="text" placeholder="수정할 관광지를 검색하세요" style="width: 300px;" />
  <button onclick="searchPlace()">검색</button>
  <button onclick="savePlace()">추가</button>

  <div id="map"></div>
  
  <form method="post" action="place/updatePlaceAction.jsp" enctype="multipart/form-data">
 <div id="place-info" style="margin-top:20px;">
  <strong>선택된 장소 정보:</strong><br>
  <input type="hidden" name="num" value="<%=num%>"> 
  이름: <input type="text" id="output-name" name="place_name" value="<%=dto.getPlace_name()%>"><br>
  주소: <input type="text" id="output-address" name="place_address" value="<%=dto.getPlace_addr()%>"><br>
  Place ID: <input type="text" id="output-placeid" name="place_id" value="<%=dto.getPlace_code()%>"><br>
  나라: <input type="text" name="country_name" value="<%=dto.getCountry_name()%>"><br>
  대륙(영어): <input type="text" name="continent_name" value="<%=dto.getContinent_name()%>"><br>
  카테고리: <input type="text" name="place_tag" value="<%=dto.getPlace_tag()%>">
  <textarea id="summernote" name="place_content"></textarea>
  <button type="submit">제출</button>
</div>
</form>


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

  document.getElementById("output-name").value = currentPlace.name;
  document.getElementById("output-address").value = currentPlace.address;
  document.getElementById("output-placeid").value = currentPlace.place_id;

  console.log("저장할 데이터:", currentPlace);
}
  </script>
  

  <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyDpVlcErlSTHrCz7Y4h3_VM8FTMkm9eXAc&callback=initMap" async defer></script>

</body>
</html>