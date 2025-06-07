<%@ page import="java.io.*, java.net.URLDecoder, place.PlaceDao, place.PlaceDto" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String imageUrl = request.getParameter("imageUrl");
    String placeNum = request.getParameter("num"); // 글 번호 받기

    if (imageUrl == null || imageUrl.isEmpty() || placeNum == null || placeNum.isEmpty()) {
        out.print("invalid_parameters");
        return;
    }

    // DB에서 글 내용 조회
    PlaceDao dao = new PlaceDao();
    PlaceDto dto = dao.getPlaceData(placeNum);

    String content = dto != null ? dto.getPlace_content() : "";

    // 이미지 URL을 포함하는지 체크 (파일명이나 경로로 체크 가능)
    // 실제 글 내용에 이미지 src가 포함되어 있으면 삭제하지 않음
    boolean stillInUse = false;
    if (content != null && !content.isEmpty()) {
        String decodedImageUrl = URLDecoder.decode(imageUrl, "UTF-8");
        stillInUse = content.contains(decodedImageUrl) || content.contains(imageUrl);
    }

    if (!stillInUse) {
        String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
        fileName = URLDecoder.decode(fileName, "UTF-8");

        String savePath = application.getRealPath("/save");
        String filePath = savePath + File.separator + fileName;
        File file = new File(filePath);

        if (file.exists()) {
            if (file.delete()) {
                out.print("deleted");
                System.out.println("이미지 삭제 성공: " + filePath);
            } else {
                out.print("delete_failed");
                System.out.println("삭제 실패: " + filePath);
            }
        } else {
            out.print("file_not_found");
            System.out.println("파일 없음: " + filePath);
        }
    } else {
        out.print("still_in_use");
        System.out.println("이미지 아직 사용 중: " + imageUrl);
    }
%>
