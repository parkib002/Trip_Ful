<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardNoticeDto" %>
<%@ page import="board.BoardNoticeDao" %>
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
    // 실제 파일 저장이 이뤄지지 않는다면, 임시 경로로 사용됩니다.
    String tempSavePath = request.getServletContext().getRealPath("/upload");
    File tempDir = new File(tempSavePath);
    if (!tempDir.exists()) {
        tempDir.mkdirs(); // 임시 저장 폴더 생성
    }

    int maxSize = 10 * 1024 * 1024; // 최대 업로드 크기 (10MB) - 실제 파일 업로드 안해도 설정은 필요
    MultipartRequest multi = null;

    String notice_idx = null;
    String title = null;
    String content = null;
    String writer = null;       // hidden 필드에서 넘어올 작성자
    String notice_img = null;   // hidden 필드에서 넘어올 기존 이미지 정보 (문자열)

    try {
        // MultipartRequest 객체 생성 (enctype="multipart/form-data" 처리)
        multi = new MultipartRequest(request, tempSavePath, maxSize, "UTF-8", new DefaultFileRenamePolicy());

        // 폼에서 전송된 파라미터 받기
        notice_idx = multi.getParameter("notice_idx");
        title = multi.getParameter("title");
        content = multi.getParameter("content");
        writer = multi.getParameter("notice_writer"); 
        notice_img = multi.getParameter("notice_img");



        // 필수 값 유효성 검사
        if (notice_idx == null || notice_idx.trim().isEmpty() ||
            title == null || title.trim().isEmpty() ||
            content == null || content.trim().isEmpty() || // Summernote는 빈 내용도 ""으로 넘어올 수 있음
            writer == null || writer.trim().isEmpty()) {
            out.println("<script>alert('필수 항목(ID, 제목, 내용, 작성자)이 누락되었습니다.'); history.back();</script>");
            return;
        }

        // BoardNoticeDto 객체 생성 및 데이터 설정
        BoardNoticeDto dto = new BoardNoticeDto();
        dto.setNotice_idx(notice_idx);
        dto.setNotice_title(title);
        dto.setNotice_content(content);
        dto.setNotice_writer(writer);
        // notice_img는 hidden 필드에서 받은 값을 사용 (새 파일 업로드 로직이 있다면 해당 값으로 대체)
        dto.setNotice_img(notice_img == null ? "" : notice_img);


        // BoardNoticeDao 객체 생성 및 업데이트 메소드 호출
        BoardNoticeDao dao = new BoardNoticeDao();
        dao.updateBoard(dto);

        // 수정 완료 후 상세 페이지 또는 목록 페이지로 리다이렉트
        response.sendRedirect(request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=noticeDetail.jsp&idx=" + notice_idx);
       
    } catch (NumberFormatException e) {
        e.printStackTrace(); // 개발 중 오류 확인용
        out.println("<script>alert('게시물 ID 형식이 올바르지 않습니다.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace(); // 개발 중 오류 확인용
        out.println("<script>alert('게시물 수정 중 오류가 발생했습니다. 다시 시도해주세요. 오류: " + e.getMessage().replace("'", "\\'").replace("\n", "\\n").replace("\r", "\\r") + "'); history.back();</script>");
    }
%>