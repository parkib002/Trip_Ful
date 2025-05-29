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

    try {
        multi = new MultipartRequest(request, savePath, maxSize, encType, new DefaultFileRenamePolicy());

        String parent_idx = multi.getParameter("parent_idx");
        String regroup_str = multi.getParameter("regroup");
        String restep_parent_str = multi.getParameter("restep_parent");
        String relevel_parent_str = multi.getParameter("relevel_parent");

        String qna_title = multi.getParameter("qna_title");
        String qna_content = multi.getParameter("qna_content");
        // String qna_private_param = multi.getParameter("qna_private");

        String loggedInUserId_reply = (String) session.getAttribute("id");
        String loginok_reply = (String) session.getAttribute("loginok");
        
        System.out.println("DEBUG: parent_idx_str = " + multi.getParameter("parent_idx"));
        System.out.println("DEBUG: regroup_str = " + multi.getParameter("regroup"));
        System.out.println("DEBUG: restep_parent_str = " + multi.getParameter("restep_parent"));
        System.out.println("DEBUG: relevel_parent_str = " + multi.getParameter("relevel_parent"));

        if (loggedInUserId_reply == null || loggedInUserId_reply.trim().isEmpty() || loginok_reply == null /* || !"admin".equals(loggedInUserId_reply) */) {
            response.sendRedirect(request.getContextPath() + "/index.jsp?main=login/loginForm.jsp&errMsg=reply_auth_failed");
            return;
        }
        String qna_writer = loggedInUserId_reply;

        if (qna_title == null || qna_title.trim().isEmpty() ||
            qna_content == null || qna_content.trim().isEmpty() ||
            parent_idx == null || regroup_str == null || restep_parent_str == null || relevel_parent_str == null) { // parent_idx 추가
            out.println("<script>alert('제목, 내용 및 답글 정보가 올바르지 않습니다.'); history.back();</script>");
            return;
        }

        String qna_img = null;
        String originalFileName = multi.getOriginalFileName("qna_img");
        String filesystemName = multi.getFilesystemName("qna_img");
        if (originalFileName != null && filesystemName != null) {
            qna_img = filesystemName;
        }

        String qna_private_status = "0"; // 기본 공개
        // if (qna_private_param != null && qna_private_param.equals("1")) {
        //     qna_private_status = "1";
        // }

        BoardSupportDto replyDto = new BoardSupportDto();
        replyDto.setQna_idx(parent_idx); // ⬅️ **수정된 부분: 부모글 ID를 qna_idx로 설정 (DAO가 답글로 인식하도록)**
        
        replyDto.setQna_category("답변"); // DAO의 insertReboard가 qna_category를 필요로 함
        replyDto.setQna_writer(qna_writer);
        replyDto.setQna_title(qna_title);
        replyDto.setQna_content(qna_content);
        replyDto.setQna_img(qna_img);
        replyDto.setQna_private(qna_private_status);
        
        int regroup = Integer.parseInt(regroup_str);
        int restep_parent = Integer.parseInt(restep_parent_str);
        int relevel_parent = Integer.parseInt(relevel_parent_str);

        // DAO의 insertReboard는 이 값들을 받아 내부에서 새 답글의 restep/relevel을 계산합니다.
        replyDto.setRegroup(regroup);
        replyDto.setRestep(restep_parent);
        replyDto.setRelevel(relevel_parent);
        
        // qna_readcount는 DAO의 SQL문에서 0으로 직접 설정하거나, 여기서 설정해도 됩니다.
        // replyDto.setQna_readcount(0); // DAO의 SQL에 이미 '0'으로 되어 있다면 생략 가능

        BoardSupportDao dao = new BoardSupportDao();
        dao.insertReboard(replyDto); // 이 메소드가 내부적으로 updateRestep 호출 및 답글 처리

        String listPage = request.getContextPath() + "/index.jsp?main=board/boardList.jsp&sub=support.jsp";
        response.sendRedirect(listPage + "&msg=reply_success");

    } catch (IOException ioe) {
        ioe.printStackTrace();
        out.println("<script>alert('파일 업로드 중 오류가 발생했습니다. (예: 파일 크기 초과)'); history.back();</script>");
    } catch (NumberFormatException nfe) {
        nfe.printStackTrace();
        out.println("<script>alert('잘못된 숫자 형식의 파라미터입니다.'); history.back();</script>");
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<script>alert('답변 등록 중 오류가 발생했습니다.'); history.back();</script>");
    }
%>