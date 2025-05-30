<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@page import="board.BoardSupportDao"%>
<%@page import="board.BoardSupportDto"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String savePath = request.getServletContext().getRealPath("/upload");
    int maxSize = 1024 * 1024 * 10; // 10MB
    String encType = "UTF-8";

    File uploadDir = new File(savePath);
    if (!uploadDir.exists()) {
        uploadDir.mkdirs();
    }

    String qna_idx = "";
    String qna_category = ""; // 카테고리 변수 추가
    String qna_title = "";
    String qna_content = "";
    String qna_private = "0";
    String qna_writer_loginid = ""; // 수정 요청자 ID
    String qna_existing_img = "";
    String delete_img_flag = "false";

    String new_qna_img = null;
    boolean updateResult = false;

    try {
        MultipartRequest multi = new MultipartRequest(request, savePath, maxSize, encType, new DefaultFileRenamePolicy());

        qna_idx = multi.getParameter("qna_idx");
        qna_category = multi.getParameter("qna_category"); // 카테고리 값 받기
        qna_title = multi.getParameter("qna_title");
        qna_content = multi.getParameter("qna_content");
        qna_writer_loginid = multi.getParameter("qna_writer_loginid"); // 폼에서 넘긴 로그인 ID
        qna_existing_img = multi.getParameter("qna_existing_img");

        if (multi.getParameter("qna_private") != null && multi.getParameter("qna_private").equals("1")) {
            qna_private = "1";
        }

        if (multi.getParameter("delete_img") != null && multi.getParameter("delete_img").equals("true")) {
            delete_img_flag = "true";
        }
        
        new_qna_img = multi.getFilesystemName("qna_img");

        BoardSupportDto dto = new BoardSupportDto();
        dto.setQna_idx(qna_idx);
        dto.setQna_category(qna_category); // DTO에 카테고리 설정
        dto.setQna_title(qna_title);
        dto.setQna_content(qna_content);
        dto.setQna_private(qna_private);
        // dto.setQna_writer(qna_writer_loginid); // 원글 작성자는 변경하지 않음. 필요시 수정자 정보를 다른 컬럼에 저장.

        String final_qna_img = qna_existing_img;

        if (delete_img_flag.equals("true")) {
            if (qna_existing_img != null && !qna_existing_img.isEmpty()) {
                File oldFile = new File(savePath + File.separator + qna_existing_img);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
            final_qna_img = null;
        }

        if (new_qna_img != null) {
            if (qna_existing_img != null && !qna_existing_img.isEmpty() && !qna_existing_img.equals(new_qna_img)) {
                File oldFile = new File(savePath + File.separator + qna_existing_img);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }
            final_qna_img = new_qna_img;
        }
        
        dto.setQna_img(final_qna_img);

        BoardSupportDao dao = new BoardSupportDao();
        // updateSupport 메소드는 이제 qna_type도 업데이트해야 함
        updateResult = dao.updateSupport(dto); 

        if (updateResult) {
            %>
            <script type="text/javascript">
                alert("게시글이 성공적으로 수정되었습니다.");
                location.href = "<%=request.getContextPath()%>/index.jsp?main=board/boardList.jsp&sub=support.jsp"; // 목록 페이지로 이동
            </script>
            <%
        } else {
            %>
            <script type="text/javascript">
                alert("게시글 수정에 실패했습니다.");
                history.back();
            </script>
            <%
        }

    } catch (Exception e) {
        e.printStackTrace();
        %>
        <script type="text/javascript">
            alert("처리 중 오류가 발생했습니다.");
            history.back();
        </script>
        <%
    }
%>