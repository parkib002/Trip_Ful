<%@ page import="java.io.*, java.net.URLDecoder" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    request.setCharacterEncoding("UTF-8");

    String imageUrl = request.getParameter("imageUrl");

    // 실제 게시글 내용에서 해당 이미지가 여전히 사용되고 있는지 확인 (DB나 임시 저장된 html 기준)
    // 아래는 간단한 예시: 실제로는 DB 조회 필요
    boolean stillInUse = false; // TODO: DB에서 사용 여부 확인

    if (!stillInUse && imageUrl != null && !imageUrl.isEmpty()) {
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
        out.print("skipped_or_invalid");
        System.out.println("삭제 건너뜀 또는 잘못된 URL: imageUrl=" + imageUrl);
    }
%>