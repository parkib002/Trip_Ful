<%@ page import="java.io.*, com.oreilly.servlet.*, com.oreilly.servlet.multipart.*" %>
<%@ page contentType="text/plain; charset=UTF-8" %>

<%
    // 실제 저장 경로 (웹 루트의 /upload 폴더)
    String savePath = application.getRealPath("/save");
   
    // 디렉토리 없으면 생성
    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs(); // 상위 폴더까지 생성
    }

    int maxSize = 10 * 1024 * 1024; // 최대 업로드 크기: 10MB
    String encoding = "UTF-8";

    // MultipartRequest 객체 생성 (cos.jar 필요)
    MultipartRequest multi = new MultipartRequest(
        request,
        savePath,
        maxSize,
        encoding,
        new DefaultFileRenamePolicy() // 같은 이름이 있으면 자동으로 변경
    );

    // 업로드된 파일의 원래 이름
    String fileName = multi.getFilesystemName("file");

    // 이미지 URL 생성
    String imageUrl = request.getContextPath() + "/save/" + fileName;

    out.print(imageUrl); // Summernote가 받을 URL 응답

    System.out.println("업로드 경로: " + savePath);
%>
