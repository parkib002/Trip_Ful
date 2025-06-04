<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardEventDto" %>
<%@ page import="board.BoardEventDao" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>

<%
	//어드민 확인
	String sessionId = (String) session.getAttribute("loginok"); // 로그인 시 세션에 저장한 속성 이름 사용
	if (sessionId == null || !sessionId.equals("admin")) { // 실제 관리자 식별 값과 비교
	    out.println("<script>");
	    out.println("alert('수정 권한이 없습니다.');");
	    out.println("location.href='" + request.getContextPath() + "/index.jsp';");
	    out.println("</script>");
	    return;
	}

    // MultipartRequest를 위한 임시 저장 경로 (실제 파일 저장이 없어도 필요할 수 있음)
    String tempSavePath = request.getServletContext().getRealPath("/upload");
    File tempDir = new File(tempSavePath);
    if (!tempDir.exists()) {
        tempDir.mkdirs(); // 폴더가 없으면 생성
    }

    int maxSize = 10 * 1024 * 1024; // 최대 업로드 크기 (10MB)
    MultipartRequest multi = null;

    String event_idx_str = null; // String 타입으로 event_idx를 받음
    String title = null;
    String content = null;
    String writer = null;
    String event_img = null;

    try {
        // MultipartRequest 객체 생성 (enctype="multipart/form-data" 처리)
        multi = new MultipartRequest(request, tempSavePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

        // 폼에서 전송된 파라미터 받기
        event_idx_str = multi.getParameter("event_idx");
        title = multi.getParameter("title");
        content = multi.getParameter("content");
        writer = multi.getParameter("event_writer");    // hidden 필드로 전달된 작성자
        event_img = multi.getParameter("event_img");      // hidden 필드로 전달된 기존 이미지 정보

        // 필수 값 유효성 검사
        if (event_idx_str == null || event_idx_str.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            // content는 비어있을 수도 있으므로, 필요에 따라 검사
            writer == null || writer.trim().isEmpty()) {
            out.println("<script>alert('필수 항목(ID, 제목, 작성자)이 누락되었습니다.'); history.back();</script>");
            return;
        }

        // BoardEventDto 객체 생성 및 데이터 설정
        BoardEventDto dto = new BoardEventDto();
        dto.setEvent_idx(event_idx_str); // DAO에서 String으로 처리하므로 그대로 전달
        dto.setEvent_title(title);
        dto.setEvent_content(content);
        dto.setEvent_writer(writer);
        dto.setEvent_img(event_img == null ? "" : event_img); // null이면 빈 문자열로 처리


        // BoardEventDao 객체 생성 및 업데이트 메소드 호출
        BoardEventDao dao = new BoardEventDao();
        dao.updateEvent(dto); // 수정된 updateEvent 메소드 호출

        // 수정 완료 후 상세 페이지 또는 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=eventDetail.jsp&idx=" + event_idx_str);

    } catch (NumberFormatException e) {
        e.printStackTrace();
        out.println("<script>alert('이벤트 ID 형식이 올바르지 않습니다.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('이벤트 수정 중 오류가 발생했습니다: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r") + "'); history.back();</script>");
    }
%>