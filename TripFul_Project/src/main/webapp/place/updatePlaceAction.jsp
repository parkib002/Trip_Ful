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
    String num = multi.getParameter("num");

    StringBuilder imgUrlBuilder = new StringBuilder();

    // 1. base64 이미지 찾기 & 파일 저장
    Pattern base64Pattern = Pattern.compile("<img[^>]+src\\s*=\\s*\"(data:image/[^;]+;base64,[^\"]+)\"[^>]*>");
    Matcher base64Matcher = base64Pattern.matcher(content);

    StringBuffer contentBuffer = new StringBuffer();

    while (base64Matcher.find()) {
        String base64Image = base64Matcher.group(1);
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
        // base64 이미지 태그는 삭제 (빈 문자열로 교체)
        base64Matcher.appendReplacement(contentBuffer, "");
    }
    base64Matcher.appendTail(contentBuffer);
    String contentWithoutBase64 = contentBuffer.toString();

    // 2. 기존 'save/...' 경로 가진 <img> 태그에서 이미지 경로 추출
    Pattern saveImgPattern = Pattern.compile("<img[^>]+src\\s*=\\s*\"(save/[^\"]+)\"[^>]*>", Pattern.CASE_INSENSITIVE);
    Matcher saveImgMatcher = saveImgPattern.matcher(contentWithoutBase64);

    contentBuffer = new StringBuffer();

    while (saveImgMatcher.find()) {
        String imgSrc = saveImgMatcher.group(1);
        if (imgUrlBuilder.length() > 0) imgUrlBuilder.append(",");
        imgUrlBuilder.append(imgSrc);
        // <img> 태그는 제거
        saveImgMatcher.appendReplacement(contentBuffer, "");
    }
    saveImgMatcher.appendTail(contentBuffer);

    String finalContent = contentBuffer.toString();

    // 3. DTO 세팅
    PlaceDto dto = new PlaceDto();
    dto.setPlace_name(pname);
    dto.setPlace_addr(paddr);
    dto.setPlace_code(pid);
    dto.setCountry_name(countryname);
    dto.setContinent_name(continentname);
    dto.setPlace_tag(tag);
    dto.setPlace_content(finalContent); // img 태그 모두 제거된 HTML
    dto.setPlace_img(imgUrlBuilder.length() > 0 ? imgUrlBuilder.toString() : "");
    dto.setPlace_num(num);

    PlaceDao dao = new PlaceDao();
    dao.updatePlace(dto);

} catch (Exception e) {
    e.printStackTrace();
    out.println("오류 발생: " + e.getMessage());
}
%>


