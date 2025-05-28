<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="board.BoardEventDto" %> <%-- 실제 BoardEventDto 경로로 수정 --%>
<%@ page import="board.BoardEventDao" %> <%-- 실제 BoardEventDao 경로로 수정 --%>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 썸머노트 이미지 업로드와는 별개로, 폼 전체가 multipart/form-data 이므로 필요
    String savePath = request.getServletContext().getRealPath("/upload"); // 폼 데이터 처리를 위한 임시 경로
    File saveDir = new File(savePath);
    if (!saveDir.exists()) {
        saveDir.mkdirs();
    }

    int maxSize = 10 * 1024 * 1024; // 10MB (폼 데이터 전체 크기 제한)
    String encType = "UTF-8";

    String eventTitle = "";
    String eventContent = "";
    String eventWriter = ""; // 작성자는 세션 등에서 가져와야 함
    String mainEventImage = ""; // 대표 이미지 (썸머노트 내용 중 첫 번째 이미지 또는 별도 업로드)

    try {
        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encType, new DefaultFileRenamePolicy());

        // 1. 폼 데이터 가져오기
        eventTitle = multi.getParameter("title"); // HTML form의 name="title"
        eventContent = multi.getParameter("content"); // HTML form의 name="content"

        // 2. 작성자 정보 가져오기 (예: 세션에서)
        // 실제 로그인 시스템에 맞게 수정하세요.
        String loggedInUserId = (String) session.getAttribute("id"); // 또는 "userId", "memberId" 등 세션 키
        if (loggedInUserId == null || loggedInUserId.trim().isEmpty()) {
            // 로그인되어 있지 않으면 로그인 페이지로 보내거나 에러 처리
            out.println("<script>alert('로그인이 필요합니다.'); location.href='loginForm.jsp';</script>"); // loginForm.jsp는 예시
            return;
        }
        eventWriter = loggedInUserId;

        // 3. 데이터 유효성 검사
        if (eventTitle == null || eventTitle.trim().isEmpty()) {
            out.println("<script>alert('제목을 입력해주세요.'); history.back();</script>");
            return;
        }
        if (eventContent == null || eventContent.trim().isEmpty()) {
            out.println("<script>alert('내용을 입력해주세요.'); history.back();</script>");
            return;
        }

        // 4. 썸머노트 내용에서 첫 번째 이미지 URL 추출 (event_img 필드용)
        //    또는 대표 이미지를 별도로 업로드 받는다면 해당 파일명을 사용합니다.
        //    여기서는 썸머노트 내용의 첫 번째 이미지를 대표 이미지로 가정합니다.
        Pattern pattern = Pattern.compile("<img[^>]+src=\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(eventContent);
        if (matcher.find()) {
            mainEventImage = matcher.group(1);
            // 이미지 URL에서 실제 파일명만 추출해야 할 수도 있습니다.
            // 예: "http://.../save/image.jpg" -> "image.jpg"
            // 현재는 전체 URL을 저장하는 것으로 가정합니다. 필요시 수정하세요.
            // String[] parts = mainEventImage.split("/");
            // mainEventImage = parts[parts.length - 1];
        }


        // 5. DTO 객체 생성 및 데이터 설정
        BoardEventDto dto = new BoardEventDto();
        dto.setEvent_title(eventTitle);
        dto.setEvent_content(eventContent);
        dto.setEvent_img(mainEventImage); // 추출한 첫 이미지 또는 대표 이미지 파일명
        dto.setEvent_readcount(0); // 새 글이므로 조회수는 0
        dto.setEvent_writer(eventWriter);
        // event_writeday는 DAO에서 now()로 자동 설정됨

        // 6. DAO 객체 생성 및 데이터베이스에 삽입
        BoardEventDao dao = new BoardEventDao();
        dao.insertBoard(dto); // DAO의 메서드명 확인 (insertBoard가 맞는지)

        // 7. 결과 처리
        // 성공 시 목록 페이지 또는 다른 적절한 페이지로 이동
        out.println("<script>alert('이벤트 글이 성공적으로 작성되었습니다.'); location.href='eventList.jsp';</script>"); // eventList.jsp는 예시

    } catch (Exception e) {
        e.printStackTrace();
        // 사용자에게 보여줄 오류 메시지는 좀 더 친절하게
        String errorMessage = "처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
        // 개발 중에는 실제 예외 메시지를 포함하여 디버깅 용이하게 할 수 있음
        // errorMessage = "처리 중 오류: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "");
        out.println("<script>alert('" + errorMessage + "'); history.back();</script>");
    }
%>