<%@page import="java.io.File"%>
<%@page import="place.PlaceDao"%>
<%@page import="place.PlaceDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 삭제</title>
</head>
<body>

<%
	String num=request.getParameter("place_num");

	PlaceDao dao=new PlaceDao();
	
	PlaceDto dto=dao.getPlaceData(num);

    // 1. 삭제할 place_num 가져오기
     String imgPaths = dto.getPlace_img(); // 예: "/TripFul_Project/save/에펠탑28.jpg"

    if (imgPaths != null && !imgPaths.trim().isEmpty()) {
        String[] imgs = imgPaths.split(",");
        for (String imgPath : imgs) {
            // 컨텍스트 경로 제거 (/TripFul_Project/)
            String contextPath = request.getContextPath(); // "/TripFul_Project"
            if (imgPath.startsWith(contextPath)) {
                imgPath = imgPath.substring(contextPath.length());
            }

            String realPath = application.getRealPath(imgPath.trim());
            File file = new File(realPath);

            if (file.exists()) {
                boolean deleted = file.delete();
                System.out.println("[이미지 삭제] " + imgPath + " → " + (deleted ? "성공" : "실패"));
            } else {
                System.out.println("[이미지 없음] " + realPath);
            }
        }
    }

    // 4. DB 삭제
    dao.deletePlace(num);
%>

<script type="text/javascript">
    // 5. 삭제 후 페이지 이동
    location.href = "index.jsp?main=place/selectPlace.jsp";
</script>

</body>
</html>
