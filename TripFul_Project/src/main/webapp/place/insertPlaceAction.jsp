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
<title>Insert title here</title>
</head>
<body>
<%
String realPath = getServletContext().getRealPath("/save");
int uploadSize = 1024 * 1024 * 10;

try {
    MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

    String pname = multi.getParameter("place_name");
    String paddr = multi.getParameter("place_address");
    String pid = multi.getParameter("place_id");
    String countryname = multi.getParameter("country_name");
    String continentname = multi.getParameter("continent_name");
    String tag = multi.getParameter("place_tag");
    String content = multi.getParameter("place_content");

    StringBuilder imgUrlBuilder = new StringBuilder();

    Pattern imgPattern = Pattern.compile("<img[^>]+src\\s*=\\s*\"(data:image/[^;]+;base64,[^\"]+)\"[^>]*>");
    Matcher matcher = imgPattern.matcher(content);

    StringBuffer contentBuffer = new StringBuffer();

    while (matcher.find()) {
        String base64Image = matcher.group(1);
        String[] base64Data = base64Image.split(",");
        if (base64Data.length > 1) {
            byte[] imageBytes = Base64.getDecoder().decode(base64Data[1]);

            String fileName = "place_img_" + UUID.randomUUID() + ".png";
            String savePath = "save/" + fileName;
            String filePath = realPath + File.separator + fileName;

            try (FileOutputStream fos = new FileOutputStream(filePath)) {
                fos.write(imageBytes);
            }

            if (imgUrlBuilder.length() > 0) imgUrlBuilder.append(",");
            imgUrlBuilder.append(savePath);
        }
        matcher.appendReplacement(contentBuffer, "");  // 이미지 태그 제거
    }
    matcher.appendTail(contentBuffer);
    content = contentBuffer.toString(); // 이미지 태그 제거된 텍스트

    PlaceDto dto = new PlaceDto();
    dto.setPlace_name(pname);
    dto.setPlace_addr(paddr);
    dto.setPlace_code(pid);
    dto.setCountry_name(countryname);
    dto.setContinent_name(continentname);
    dto.setPlace_tag(tag);
    dto.setPlace_content(content);
    dto.setPlace_img(imgUrlBuilder.length() > 0 ? imgUrlBuilder.toString() : "");

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