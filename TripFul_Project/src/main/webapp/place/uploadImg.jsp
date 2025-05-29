<%@ page import="java.io.*" %>
<%@ page import="java.util.UUID" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%
    // 이미지 저장 경로
    String savePath = application.getRealPath("/save");

    // 요청에서 파일 받기
    Part filePart = request.getPart("file");
    String originalFileName = filePart.getSubmittedFileName();
    
    // 고유한 이름으로 저장 (중복 방지 + 원래 이름 유지)
    String fileExt = originalFileName.substring(originalFileName.lastIndexOf('.'));
    String uuid = UUID.randomUUID().toString();
    String newFileName = uuid + "_" + originalFileName;  // 예: 23f4b_img.png

    File saveDir = new File(savePath);
    if (!saveDir.exists()) saveDir.mkdirs();

    File file = new File(saveDir, newFileName);
    try (InputStream input = filePart.getInputStream();
         FileOutputStream output = new FileOutputStream(file)) {
        byte[] buffer = new byte[1024];
        int length;
        while ((length = input.read(buffer)) > 0) {
            output.write(buffer, 0, length);
        }
    }

    // 클라이언트에 저장 경로 반환 (Summernote가 삽입할 경로)
    response.getWriter().write("save/" + newFileName);
%>