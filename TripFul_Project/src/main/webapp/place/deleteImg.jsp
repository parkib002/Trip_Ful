<%@ page import="java.io.*, java.net.URLDecoder" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String imageUrl = request.getParameter("imageUrl");

    if (imageUrl != null && !imageUrl.isEmpty()) {
        // 파일명만 추출
        String fileName = imageUrl.substring(imageUrl.lastIndexOf("/") + 1);
        
        // 🔥 URL 디코딩 추가 (한글 파일명 대응)
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
        out.print("invalid_url");
        System.out.println("잘못된 요청: imageUrl=" + imageUrl);
    }
%>
