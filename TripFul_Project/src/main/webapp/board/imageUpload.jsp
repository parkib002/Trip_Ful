<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.*, java.util.*, com.oreilly.servlet.*, com.oreilly.servlet.multipart.*" %>

<%
    String savePath = application.getRealPath("/upload"); // 업로드 디렉토리
    int maxSize = 5 * 1024 * 1024; // 업로드 용량 제한: 5MB
    String encoding = "UTF-8";
	System.out.println(savePath);
    try {
        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());

        Enumeration files = multi.getFileNames();
        if (files.hasMoreElements()) {
            String fileField = (String) files.nextElement();
            String fileName = multi.getFilesystemName(fileField);

            if (fileName != null) {
                // 업로드된 이미지 URL을 클라이언트로 반환
                String fileUrl = request.getContextPath() + "/upload/" + fileName;
                out.print(fileUrl);
            } else {
                out.print("error: no file");
            }
        }
    } catch (Exception e) {
        out.print("error: " + e.getMessage());
        e.printStackTrace();
    }
%>