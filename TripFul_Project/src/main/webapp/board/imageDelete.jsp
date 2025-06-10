<%@ page language="java" contentType="text/plain; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.io.File" %>
<%
    try {
        request.setCharacterEncoding("UTF-8");

        // 1. 클라이언트로부터 삭제할 파일명 받기
        String fileName = request.getParameter("fileName");

        if (fileName == null || fileName.trim().isEmpty()) {
            out.print("error: 삭제할 파일명이 없습니다.");
            return;
        }

        // 2. [보안] 경로 조작 공격(Path Traversal) 방지
        //    파일명에 '..', '/', '\' 와 같은 경로 관련 문자가 포함되어 있는지 확인
        if (fileName.contains("..") || fileName.contains("/") || fileName.contains("\\")) {
            out.print("error: 유효하지 않은 파일명입니다.");
            return; 
        }

        // 3. 실제 서버의 업로드 경로 찾기
        String uploadPath = request.getServletContext().getRealPath("/upload");
        
        // 4. 파일 객체 생성 및 삭제 시도
        File fileToDelete = new File(uploadPath, fileName);

        if (fileToDelete.exists()) {
            // 파일이 실제로 존재하면 삭제
            if (fileToDelete.delete()) {
                // 성공 시 "success" 반환
                out.print("success");
            } else {
                // 파일은 있으나 삭제에 실패한 경우 (권한 등)
                out.print("error: 파일 삭제에 실패했습니다.");
            }
        } else {
            // 파일이 존재하지 않는 경우 (이미 삭제되었거나 잘못된 요청)
            // 이 경우는 성공으로 처리해도 무방합니다. 목적(파일 없음)은 달성되었기 때문입니다.
            out.print("success: 파일이 이미 존재하지 않습니다.");
        }

    } catch (Exception e) {
        e.printStackTrace(); // 서버 로그에 오류 기록
        out.print("error: 서버 처리 중 오류가 발생했습니다. " + e.getMessage());
    }
%>