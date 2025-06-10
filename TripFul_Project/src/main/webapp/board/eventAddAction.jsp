<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardEventDto" %>
<%@ page import="board.BoardEventDao" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.util.regex.Matcher" %>

<%
    // 1. 인코딩 설정 (가장 위에 배치)
    request.setCharacterEncoding("UTF-8");

    String eventTitle = "";
    String eventContent = "";
    String eventWriter = ""; 
    String mainEventImage = ""; 

    try {
        // 2. MultipartRequest 제거: 더 이상 파일 업로드를 처리하지 않습니다.
        //    일반적인 방식으로 파라미터를 받습니다.
        eventTitle = request.getParameter("title");
        eventContent = request.getParameter("content");

        // 3. 작성자 정보 가져오기 (세션)
        String loggedInUserId = (String) session.getAttribute("id");
        if (loggedInUserId == null || loggedInUserId.trim().isEmpty()) {
            out.println("<script>alert('로그인이 필요합니다.'); location.href='login_form.jsp';</script>");
            return;
        }
        eventWriter = loggedInUserId;

        // 4. 데이터 유효성 검사
        if (eventTitle == null || eventTitle.trim().isEmpty()) {
            out.println("<script>alert('제목을 입력해주세요.'); history.back();</script>");
            return;
        }
        if (eventContent == null || eventContent.trim().isEmpty() || eventContent.equals("<p><br></p>")) {
            out.println("<script>alert('내용을 입력해주세요.'); history.back();</script>");
            return;
        }

        // 5. 썸머노트 내용에서 첫 번째 이미지 URL 추출
        //    이 로직은 그대로 유지합니다.
        Pattern pattern = Pattern.compile("<img[^>]+src=\"([^\"]+)\"");
        Matcher matcher = pattern.matcher(eventContent);
        if (matcher.find()) {
            // 전체 URL 경로를 DB에 저장합니다. (예: /tripful/upload/image.jpg)
            mainEventImage = matcher.group(1); 
        } else {
            // 이미지가 없는 경우 기본 이미지나 빈 문자열을 저장할 수 있습니다.
            mainEventImage = ""; // 또는 "no_image.jpg" 등
        }

        // 6. DTO 객체 생성 및 데이터 설정
        BoardEventDto dto = new BoardEventDto();
        dto.setEvent_title(eventTitle);
        dto.setEvent_content(eventContent);
        dto.setEvent_img(mainEventImage);
        dto.setEvent_readcount(0);
        dto.setEvent_writer(eventWriter);

        // 7. DAO를 통해 데이터베이스에 삽입
        BoardEventDao dao = new BoardEventDao();
        dao.insertBoard(dto);

        // 8. 성공 시 목록 페이지로 이동
        String redirectUrl = request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=event.jsp";
        out.println("<script>alert('이벤트 글이 성공적으로 작성되었습니다.'); location.href='" + redirectUrl + "';</script>");
        
    } catch (Exception e) {
        e.printStackTrace();
        String errorMessage = "처리 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.";
        out.println("<script>alert('" + errorMessage + "'); history.back();</script>");
    }
%>