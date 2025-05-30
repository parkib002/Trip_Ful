<%@page import="java.util.List"%>
<%@page import="board.BoardSupportDao"%>
<%@page import="board.BoardSupportDto"%>
<%@page import="java.io.File"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    request.setCharacterEncoding("UTF-8");

    String qna_idx_to_delete = request.getParameter("qna_idx");

    // 세션에서 로그인 정보 가져오기
    String loginok_delete = (String)session.getAttribute("loginok");
    String userId_delete = (String)session.getAttribute("id");

    BoardSupportDao dao_delete = new BoardSupportDao();
    boolean overallSuccess = false; // 작업 성공 여부를 나타내는 변수

    // qna_idx 파라미터 유효성 검사
    if (qna_idx_to_delete == null || qna_idx_to_delete.trim().isEmpty()) {
        %>
        <script>
            alert("삭제할 게시글 정보가 없습니다.");
            history.back();
        </script>
        <%
        return; // 처리 중단
    }

    // 삭제 대상 데이터 가져오기
    BoardSupportDto dto_to_delete = dao_delete.getData(qna_idx_to_delete);

    // 대상 데이터 존재 여부 확인
    if (dto_to_delete == null) {
        %>
        <script>
            alert("삭제할 게시글 또는 답변이 존재하지 않습니다.");
            location.href = "<%=request.getContextPath()%>/index.jsp?main=board/boardList.jsp&sub=support.jsp";
        </script>
        <%
        return; // 처리 중단
    }

    // 삭제 권한 확인 (관리자이거나, 본인이 작성한 글/답변인 경우)
    boolean isAdmin_delete = "admin".equals(loginok_delete);
    boolean isWriter_delete = userId_delete != null && userId_delete.equals(dto_to_delete.getQna_writer());

    if (!isAdmin_delete && !isWriter_delete) {
        %>
        <script>
            alert("게시글 또는 답변을 삭제할 권한이 없습니다.");
            history.back();
        </script>
        <%
        return; // 처리 중단
    }

    // 삭제 처리 시작
    try {
        String savePath = request.getServletContext().getRealPath("/upload");

        // Case 1: 원본 게시글 삭제 (relevel == 0)
        if (dto_to_delete.getRelevel() == 0) {
            // 1. 관련된 모든 답변글의 첨부파일 삭제 및 DB에서 답글 삭제
            List<BoardSupportDto> replies = dao_delete.getRepliesByRegroup(dto_to_delete.getRegroup());
            for (BoardSupportDto reply : replies) {
                if (reply.getQna_img() != null && !reply.getQna_img().isEmpty()) {
                    File replyFile = new File(savePath + File.separator + reply.getQna_img());
                    if (replyFile.exists()) {
                        replyFile.delete(); // 파일 삭제 실패 시 별도 처리나 로깅을 고려할 수 있습니다.
                    }
                }
                dao_delete.deleteSupport(String.valueOf(reply.getQna_idx())); // 답글 DB에서 삭제
            }

            // 2. 원본글의 첨부파일 삭제
            if (dto_to_delete.getQna_img() != null && !dto_to_delete.getQna_img().isEmpty()) {
                File originalFile = new File(savePath + File.separator + dto_to_delete.getQna_img());
                if (originalFile.exists()) {
                    originalFile.delete();
                }
            }

            // 3. 원본글 DB에서 삭제
            overallSuccess = dao_delete.deleteSupport(qna_idx_to_delete);

            if (overallSuccess) {
                %>
                <script>
                    alert("게시글과 관련 답글이 모두 삭제되었습니다.");
                    location.href = "<%=request.getContextPath()%>/index.jsp?main=board/boardList.jsp&sub=support.jsp";
                </script>
                <%
            } else {
                %>
                <script>
                    alert("원본 게시글 삭제에 실패했습니다.");
                    history.back();
                </script>
                <%
            }

        // Case 2: 특정 답변 글 삭제 (relevel > 0)
        } else { // 여기가 if (dto_to_delete.getRelevel() == 0) 에 대한 else 입니다.
            // 1. 해당 답변글의 첨부파일 삭제
            if (dto_to_delete.getQna_img() != null && !dto_to_delete.getQna_img().isEmpty()) {
                File replyFile = new File(savePath + File.separator + dto_to_delete.getQna_img());
                if (replyFile.exists()) {
                    replyFile.delete();
                }
            }

            // 2. 해당 답변글 DB에서 삭제
            overallSuccess = dao_delete.deleteSupport(qna_idx_to_delete);

            if (overallSuccess) {
                %>
                <script>
                    alert("선택한 답변이 삭제되었습니다.");
                    // 삭제 후 현재 보고 있는 게시글의 상세 보기로 돌아가거나, 목록을 새로고침 할 수 있습니다.
                    // 여기서는 목록으로 이동합니다.
                    location.href = "<%=request.getContextPath()%>/index.jsp?main=board/boardList.jsp&sub=support.jsp";
                </script>
                <%
            } else {
                %>
                <script>
                    alert("답변 삭제에 실패했습니다.");
                    history.back();
                </script>
                <%
            }
        } // 여기가 Case 1의 if 에 대한 else 블록의 끝입니다.

    } catch (Exception e) {
        e.printStackTrace(); // 서버 로그에 예외 출력
        // 사용자에게 보여줄 오류 메시지 (특수문자 처리)
        String errorMessage = e.getMessage() != null ? e.getMessage().replace("\"", "'").replace("\n", " ").replace("\r", "") : "알 수 없는 오류";
        %>
        <script>
            alert("삭제 처리 중 오류가 발생했습니다: <%= errorMessage %>");
            history.back();
        </script>
        <%
    } // 여기가 try 블록의 끝입니다.
%>