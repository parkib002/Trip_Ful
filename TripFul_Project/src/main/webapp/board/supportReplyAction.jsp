<%@page import="java.io.IOException"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.io.File" %>
<%@ page import="board.BoardSupportDto" %>
<%@ page import="board.BoardSupportDao" %>
<%
    request.setCharacterEncoding("UTF-8");

    String savePath = request.getServletContext().getRealPath("/upload");
    File saveDir = new File(savePath);
    if (!saveDir.exists()) {
        saveDir.mkdirs();
    }
    int maxSize = 5 * 1024 * 1024; // 5MB
    String encType = "UTF-8";
    MultipartRequest multi = null;

    // 로그인 정보 확인
    String loggedInUserId_reply = (String) session.getAttribute("id");
    if (loggedInUserId_reply == null) {
        out.println("<script>alert('로그인이 필요한 서비스입니다.'); location.href='" + request.getContextPath() + "/index.jsp?main=login/loginMain.jsp';</script>");
        return;
    }
	
    try {
        multi = new MultipartRequest(request, savePath, maxSize, encType, new DefaultFileRenamePolicy());

        // 폼에서 넘어온 부모 글의 정보
        String parent_regroup_str = multi.getParameter("regroup");
        String parent_restep_str = multi.getParameter("restep");     // 부모의 restep
        String parent_relevel_str = multi.getParameter("relevel");   // 부모의 relevel

        // 새 답변의 내용
        String qna_title = multi.getParameter("qna_title");
        String qna_content = multi.getParameter("qna_content");
        String qna_writer = multi.getParameter("qna_writer"); // 폼에서 readonly로 설정된 작성자 ID

        // 필수 파라미터 검사
        if (qna_title == null || qna_title.trim().isEmpty() ||
            qna_content == null || qna_content.trim().isEmpty() ||
            parent_regroup_str == null || parent_restep_str == null || parent_relevel_str == null) {
            out.println("<script>alert('제목, 내용 및 필수 답글 정보가 누락되었습니다.'); history.back();</script>");
            return;
        }

        // 첨부 파일 처리
        String qna_img = multi.getFilesystemName("qna_img"); // 저장된 파일명

        // 비밀글 여부 (답변은 기본적으로 공개 "0"으로 설정. 필요시 폼에서 받아오도록 수정)
        String qna_private_status = "0"; 
        // String qna_private_param = multi.getParameter("qna_private");
        // if (qna_private_param != null && qna_private_param.equals("1")) {
        //     qna_private_status = "1";
        // }


        // 새 답변 DTO 생성
        BoardSupportDto replyDto = new BoardSupportDto();
        replyDto.setQna_writer(qna_writer);
        replyDto.setQna_title(qna_title);
        replyDto.setQna_content(qna_content);
        replyDto.setQna_img(qna_img);
        replyDto.setQna_private(qna_private_status);
        replyDto.setQna_category("답변"); // 답변글의 카테고리 (필요에 따라 설정)
        // qna_readcount는 DAO의 SQL문에서 0으로 직접 설정됨

        // 부모의 regroup, restep, relevel을 DTO에 설정하여 DAO로 전달
        // DAO의 insertReboard 메소드가 이 값들을 기준으로 새 답글의 값을 계산함
        replyDto.setRegroup(Integer.parseInt(parent_regroup_str));
        replyDto.setRestep(Integer.parseInt(parent_restep_str));
        replyDto.setRelevel(Integer.parseInt(parent_relevel_str));
        
        BoardSupportDao dao = new BoardSupportDao();
        dao.insertReboard(replyDto); // 이 메소드가 내부적으로 updateRestep 호출 및 답글 처리

        // 성공 후 목록 페이지로 이동
        String listPage = request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=support.jsp";
        response.sendRedirect(listPage); // 필요시 성공 메시지 파라미터 추가 가능: + "&msg=reply_success"

    } catch (IOException ioe) {
        // 파일 업로드 관련 예외 (예: 크기 초과)
        ioe.printStackTrace();
        out.println("<script>alert('파일 업로드 중 오류가 발생했습니다. (예: 파일 크기 초과)'); history.back();</script>");
    } catch (NumberFormatException nfe) {
        // 숫자 변환 오류 (regroup, restep, relevel 파싱 실패 시)
        nfe.printStackTrace();
        out.println("<script>alert('잘못된 형식의 파라미터입니다. (숫자 오류)'); history.back();</script>");
    } catch (Exception e) {
        // 기타 모든 예외
        e.printStackTrace();
        out.println("<script>alert('답변 등록 중 알 수 없는 오류가 발생했습니다.'); history.back();</script>");
    }
%>