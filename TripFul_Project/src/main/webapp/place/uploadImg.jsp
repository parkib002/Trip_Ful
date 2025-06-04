<%@ page import="java.io.*" %>
<%@ page import="java.util.UUID" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page contentType="text/plain; charset=UTF-8" %>
<%@ page language="java" contentType="text/plain;charset=UTF-8" %>
<%
    try {
        // 이미지 저장 경로
        String savePath = application.getRealPath("/save");
        if (savePath == null) {
            throw new Exception("save 경로를 찾을 수 없습니다. 서버 환경 확인 필요");
        }

        Part filePart = request.getPart("file");
        if (filePart == null) {
            throw new Exception("업로드된 파일이 없습니다.");
        }

        String originalFileName = filePart.getSubmittedFileName();
        if (originalFileName == null || originalFileName.trim().isEmpty()) {
            throw new Exception("파일 이름을 확인할 수 없습니다.");
        }

        String uuid = UUID.randomUUID().toString();
        String newFileName = uuid + "_" + originalFileName;

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

        response.getWriter().write("save/" + newFileName);
    } catch (Exception e) {
        e.printStackTrace(response.getWriter());
    }
%>