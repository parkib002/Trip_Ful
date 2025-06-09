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
request.setCharacterEncoding("utf-8");

String realPath = getServletContext().getRealPath("/save");
int uploadSize = 1024 * 1024 * 10;

try {

    String pname = request.getParameter("place_name");
    String paddr = request.getParameter("place_address");
    String pid = request.getParameter("place_id");
    String countryname = request.getParameter("country_name");
    String continentname = request.getParameter("continent_name");
    String tag = request.getParameter("place_tag");
    String content = request.getParameter("place_content");
    String num = request.getParameter("num");

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

    // 3. DTO 세팅
    PlaceDto dto = new PlaceDto();
    dto.setPlace_name(pname);
    dto.setPlace_addr(paddr);
    dto.setPlace_code(pid);
    dto.setCountry_name(countryname);
    dto.setContinent_name(continentname);
    dto.setPlace_tag(tag);
    dto.setPlace_content(content); // img 태그 모두 제거된 HTML
    dto.setPlace_img(imgUrlBuilder.toString());
    dto.setPlace_num(num);

    PlaceDao dao = new PlaceDao();
    dao.updatePlace(dto);

    response.sendRedirect("../index.jsp?main=place/selectPlace.jsp");
    return;
} catch (Exception e) {
    e.printStackTrace();
    out.println("오류 발생: " + e.getMessage());
}
%>


