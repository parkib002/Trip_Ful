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
int uploadSize = 1024 * 1024 * 10; // 최대 10MB

try {
    MultipartRequest multi = new MultipartRequest(request, realPath, uploadSize, "utf-8", new DefaultFileRenamePolicy());

    // 입력값 읽기
    String pname = multi.getParameter("place_name");
    String paddr = multi.getParameter("place_address");
    String pid = multi.getParameter("place_id");
    String countryname = multi.getParameter("country_name");
    String continentname = multi.getParameter("continent_name");
    String tag = multi.getParameter("place_tag");
    String content = multi.getParameter("place_content");

    // 이미지 처리
    Pattern imgPattern = Pattern.compile("<img[^>]+src\\s*=\\s*\"(data:image/[^;]+;base64,[^\"]+)\"");
    Matcher matcher = imgPattern.matcher(content);

    StringBuilder imgUrlBuilder = new StringBuilder();

    while (matcher.find()) {
        String base64Image = matcher.group(1); // src="..." 에서 추출한 값
        String[] base64Data = base64Image.split(",");

        if (base64Data.length > 1) {
            byte[] imageBytes = Base64.getDecoder().decode(base64Data[1]);

            // 고유한 파일 이름 생성
            String fileName = "place_img_" + UUID.randomUUID() + ".png";
            String savePath = "save/" + fileName;
            String filePath = realPath + File.separator + fileName;

            // 이미지 파일 저장
            FileOutputStream fos = new FileOutputStream(filePath);
            fos.write(imageBytes);
            fos.close();

            // content 안의 base64 → 파일 URL로 교체
            content = content.replace(base64Image, savePath);

            // 이미지 URL 저장
            if (imgUrlBuilder.length() > 0) imgUrlBuilder.append(",");
            imgUrlBuilder.append(savePath);
        }
    }

    // DTO 설정
    PlaceDto dto = new PlaceDto();
    dto.setPlace_name(pname);
    dto.setPlace_addr(paddr);
    dto.setPlace_code(pid);
    dto.setCountry_name(countryname);
    dto.setContinent_name(continentname);
    dto.setPlace_tag(tag);
    dto.setPlace_content(content); // base64 제거된 HTML 내용
    dto.setPlace_img(imgUrlBuilder.toString()); // 쉼표로 연결된 이미지 경로

    // DAO 처리
    PlaceDao dao = new PlaceDao();
    dao.insertPlace(dto);

    // 성공 후 이동 (예: 목록 페이지로)

} catch (Exception e) {
    e.printStackTrace();
    out.println("<p>오류 발생: " + e.getMessage() + "</p>");
}
%>
