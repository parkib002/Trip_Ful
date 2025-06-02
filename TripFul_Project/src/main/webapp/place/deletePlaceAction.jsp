<%@page import="java.io.File"%>
<%@page import="place.PlaceDao"%>
<%@page import="place.PlaceDto"%>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
<link href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> <!-- jQuery 필수 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/summernote-lite.min.js"></script>
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관광지 추가</title>

<%
    // 1. 파라미터로 삭제할 관광지 번호 받기
    String num = request.getParameter("place_num");

    // 2. DAO 초기화
    PlaceDao dao = new PlaceDao();
    PlaceDto dto = dao.getPlaceData(num); // 삭제할 관광지 데이터

    // 3. 이미지 경로 가져오기
    String imgPaths = dto.getPlace_img(); // 예: "save/place_img_abc.png,save/place_img_def.png"

    // 4. 실제 파일 경로에서 이미지 삭제
    if (imgPaths != null && !imgPaths.trim().isEmpty()) {
        String[] imgs = imgPaths.split(",");
        for (String imgPath : imgs) {
            String realPath = application.getRealPath("/") + imgPath;
            File file = new File(realPath);
            if (file.exists()) {
                boolean deleted = file.delete();
                System.out.println("[이미지 삭제] " + imgPath + " → " + (deleted ? "성공" : "실패"));
            } else {
                System.out.println("[이미지 없음] " + imgPath);
            }
        }
    }

    // 5. DB에서 관광지 삭제
    dao.deletePlace(num);

%>
<script type="text/javascript">
	location.href="index.jsp?main=place/selectPlace.jsp"
</script>
