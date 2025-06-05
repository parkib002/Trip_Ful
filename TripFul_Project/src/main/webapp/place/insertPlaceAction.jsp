<%@page import="place.PlaceDao"%>
<%@page import="place.PlaceDto"%>
<%@page import="java.util.regex.Matcher"%>
<%@page import="java.util.regex.Pattern"%>
<%@page import="java.util.Base64"%>
<%@page import="java.util.UUID"%>
<%@page import="java.io.*"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.tailwindcss.com"></script>
<title>Insert Place</title>
</head>
<body>
<%
String realPath = getServletContext().getRealPath("/save"); // 실제 저장 경로
int uploadSize = 1024 * 1024 * 10; // 10MB

try {
    MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

    // 파라미터 수집
    String pname = multi.getParameter("place_name");
    String paddr = multi.getParameter("place_address");
    String pid = multi.getParameter("place_id");
    String countryname = multi.getParameter("country_name");
    String continentname = multi.getParameter("continent_name");
    String tag = multi.getParameter("place_tag");
    String content = multi.getParameter("place_content");

    // 이미지 추출용 패턴 (<img src="...">)
    Pattern imgTagPattern = Pattern.compile("<img[^>]+src\\s*=\\s*\"([^\"]+)\"[^>]*>");
    Matcher matcher = imgTagPattern.matcher(content);

    StringBuilder imgUrlBuilder = new StringBuilder();
    StringBuffer cleanedContent = new StringBuffer(); // 이미지 제거된 컨텐츠

    while (matcher.find()) {
        String src = matcher.group(1); // 이미지 src 값

        if (src.startsWith("data:image/")) {
            // base64 이미지
            String[] base64Data = src.split(",");
            if (base64Data.length > 1) {
                byte[] imageBytes = Base64.getDecoder().decode(base64Data[1]);

                String fileName = "place_img_" + UUID.randomUUID() + ".png";
                String savePath = "save/" + fileName;
                String filePath = realPath + File.separator + fileName;

                try (FileOutputStream fos = new FileOutputStream(filePath)) {
                    fos.write(imageBytes);
                }

                if (imgUrlBuilder.length() > 0) imgUrlBuilder.append(",");
                imgUrlBuilder.append("/" + savePath); // 웹 경로 저장
            }
        } else if (src.contains("/save/")) {
            // 일반 이미지 경로
            if (imgUrlBuilder.length() > 0) imgUrlBuilder.append(",");
            imgUrlBuilder.append(src.trim());
        }

        // <img> 태그 제거
        matcher.appendReplacement(cleanedContent, "");
    }
    matcher.appendTail(cleanedContent); // 나머지 텍스트 붙이기
    content = cleanedContent.toString();

    // DTO에 데이터 담기
    PlaceDto dto = new PlaceDto();
    dto.setPlace_name(pname);
    dto.setPlace_addr(paddr);
    dto.setPlace_code(pid);
    dto.setCountry_name(countryname);
    dto.setContinent_name(continentname);
    dto.setPlace_tag(tag);
    dto.setPlace_content(content); // 이미지 태그 없는 본문
    dto.setPlace_img(imgUrlBuilder.toString()); // 이미지 경로들

    // DB 저장
    PlaceDao dao = new PlaceDao();
    dao.insertPlace(dto);

    response.sendRedirect("../index.jsp?main=place/selectPlace.jsp");
    return;

} catch (Exception e) {
    e.printStackTrace();
    out.println("오류 발생: " + e.getMessage());
}
%>
</body>
</html>
