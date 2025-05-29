<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="board.BoardSupportDto" %>
<%@ page import="board.BoardSupportDao" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 1. 파일 업로드 설정
    String savePath = request.getServletContext().getRealPath("/upload"); // 문의 첨부파일 저장 경로
    System.out.println(savePath);
    File saveDir = new File(savePath);
    if (!saveDir.exists()) {
        saveDir.mkdirs(); // 디렉토리가 없으면 생성
    }

    int maxSize = 5 * 1024 * 1024; // 최대 업로드 파일 크기: 5MB (폼과 동일하게)
    String encType = "UTF-8";
    
    MultipartRequest multi = null;
    
    try {
        multi = new MultipartRequest(
            request,
            savePath,
            maxSize,
            encType,
            new DefaultFileRenamePolicy()
        );

        // 2. 폼 데이터 가져오기
        String qna_category = multi.getParameter("qna_category");
        String qna_title = multi.getParameter("qna_title");
        String qna_content = multi.getParameter("qna_content");
        String qna_private_param = multi.getParameter("qna_private"); // 체크 시 "1", 아니면 null

        // 3. 작성자 정보 가져오기 (세션에서)
        String loggedInUserId = (String) session.getAttribute("id");
        String loginok = (String) session.getAttribute("loginok"); // 폼에서 admin만 쓰도록 했으므로, 여기서도 확인 가능

        // 로그인 유효성 검사 (폼에서도 했지만, 액션에서도 하는 것이 안전)
        if (loggedInUserId == null || loggedInUserId.trim().isEmpty() || loginok == null /* || !"admin".equals(loginok) */ ) {
            // 폼에서 admin 체크를 했으므로, 여기서는 로그인 여부만 주로 확인하거나 필요에 따라 admin 체크도 추가
            // loginok이 "admin"이어야만 글쓰기가 가능하다면 해당 조건 추가
            response.sendRedirect(request.getContextPath() + "/index.jsp?main=login/loginForm.jsp&errMsg=not_logged_in");
            return;
        }
        String qna_writer = loggedInUserId;

        // 4. 데이터 유효성 검사 (필수 항목)
        if (qna_category == null || qna_category.trim().isEmpty() ||
            qna_title == null || qna_title.trim().isEmpty() ||
            qna_content == null || qna_content.trim().isEmpty()) {
            
            // 간단한 오류 처리 후 이전 페이지로
            out.println("<script>alert('문의 유형, 제목, 내용은 필수 입력 항목입니다.'); history.back();</script>");
            return;
        }

        // 5. 첨부 파일 처리
        String qna_img = null;
        String originalFileName = multi.getOriginalFileName("qna_img");
        String filesystemName = multi.getFilesystemName("qna_img");

        if (originalFileName != null && filesystemName != null) {
            qna_img = filesystemName; // 저장된 파일명 (필요시 원본 파일명도 DTO나 DB에 추가 가능)
        }

        // 6. 비밀글 여부 설정 (체크 시 "1", 아니면 "0" - 공개)
        String qna_private_status = (qna_private_param != null && qna_private_param.equals("1")) ? "1" : "0";

        // 7. DTO 객체 생성 및 데이터 설정
        BoardSupportDto dto = new BoardSupportDto();
        dto.setQna_category(qna_category);
        dto.setQna_writer(qna_writer);
        dto.setQna_title(qna_title);
        dto.setQna_content(qna_content);
        dto.setQna_img(qna_img); // 첨부 파일명 (없으면 null)
        dto.setQna_private(qna_private_status);
        
        // 새 글이므로 regroup, restep, relevel 설정
        // regroup은 DAO에서 새 qna_idx로 설정하거나, 여기서 0을 넘겨 DAO가 처리하도록 유도
        dto.setRegroup(0); // DAO에서 이 값을 보고 새 qna_idx로 업데이트 하도록 약속
        dto.setRestep(0);
        dto.setRelevel(0);
        dto.setQna_readcount(0); // 초기 조회수는 0

        // 8. DAO 객체 생성 및 데이터베이스에 삽입
        BoardSupportDao dao = new BoardSupportDao();
        dao.insertReboard(dto); //

        // 9. 결과 처리: 성공 시 고객센터 목록 페이지로 이동
        String redirectUrl = request.getContextPath() + "../index.jsp?main=board/boardList.jsp&sub=support.jsp"; // 문의 목록 페이지
        // out.println("<script>alert('문의가 성공적으로 등록되었습니다.'); location.href='" + redirectUrl + "';</script>");
        // alert 없이 바로 이동하려면 response.sendRedirect 사용
        response.sendRedirect(redirectUrl);

    } catch (IOException ioe) {
        // 파일 업로드 크기 초과 등의 IO 예외 처리
        ioe.printStackTrace(); // 서버 로그에 상세 오류 출력
        out.println("<script>alert('파일 업로드 중 오류가 발생했습니다. 파일 크기 등을 확인해주세요. ("+ ioe.getMessage().replaceAll("[\"';]", "") +")'); history.back();</script>");
    } catch (Exception e) {
        // 기타 예외 처리
        e.printStackTrace(); // 서버 로그에 상세 오류 출력
        out.println("<script>alert('문의 등록 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.'); history.back();</script>");
    }
%>