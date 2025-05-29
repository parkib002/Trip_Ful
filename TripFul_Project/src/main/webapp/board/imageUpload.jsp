<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.net.URLEncoder" %>

<%
    String savePath = request.getServletContext().getRealPath("/upload");
	System.out.println(savePath);

    if (savePath == null) {
        out.print("error: 서버 설정 오류 - 업로드 경로를 찾을 수 없습니다. (savePath is null)");
        return;
    }

    File saveDir = new File(savePath);
    if (!saveDir.exists()) {
        boolean created = saveDir.mkdirs();
        if (!created) {
            out.print("error: 서버 오류 - 업로드 디렉토리 생성 실패. (mkdirs failed)");
            return;
        }
    }

    int maxSize = 10 * 1024 * 1024; // 10MB
    String encoding = "UTF-8";
    String fileUrl = "";

    try {
        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encoding, new DefaultFileRenamePolicy());
        Enumeration<?> files = multi.getFileNames();

        if (files != null && files.hasMoreElements()) {
            String inputTagName = (String) files.nextElement();
            String filesystemName = multi.getFilesystemName(inputTagName);

            if (filesystemName != null) {
                String encodedFileName = URLEncoder.encode(filesystemName, "UTF-8").replace("+", "%20");
                fileUrl = request.getContextPath() + "/upload/" + encodedFileName;
                out.print(fileUrl.trim());
            } else {
                out.print("error: 파일 업로드 실패 (저장된 파일명 없음).");
            }
        } else {
            out.print("error: 요청에 파일이 없습니다.");
        }

    } catch (IOException ioe) {
        ioe.printStackTrace(); // 서버 로그에는 상세 오류를 남김
        String clientErrorMsg = "error: 파일 처리 중 IO 오류 발생.";
        if (ioe.getMessage() != null) {
            if (ioe.getMessage().toLowerCase().contains("posted content length exceeds limit") ||
                ioe.getMessage().toLowerCase().contains("maxsize")) {
                 clientErrorMsg = "error: 업로드할 파일의 크기가 너무 큽니다 (최대 " + (maxSize / (1024*1024)) + "MB).";
            }
        }
        out.print(clientErrorMsg);
        
    } catch (Exception e) {
        e.printStackTrace(); // 서버 로그에는 상세 오류를 남김
        out.print("error: 이미지 업로드 중 예기치 않은 서버 오류 발생.");
    }
%>