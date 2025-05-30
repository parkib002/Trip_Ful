<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardSupportDao"%>
<%@ page import="board.BoardSupportDto"%>
<%@ page import="java.util.List"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.JSONArray"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    // 세션에서 현재 사용자 정보 가져오기
    String current_loginok = (String) session.getAttribute("loginok");
    String current_userId = (String) session.getAttribute("id");

    // 요청 파라미터 받기
    String idx_str = request.getParameter("idx");
    // String regroup_str_param = request.getParameter("regroup"); // 이 파라미터는 원본 글 DTO에서 가져오므로 직접 사용할 필요는 없을 수 있습니다.

    JSONObject resultJson = new JSONObject();
    BoardSupportDao dao = new BoardSupportDao();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");

    if (idx_str == null || idx_str.trim().isEmpty()) {
        resultJson.put("status", "error");
        resultJson.put("message", "필수 파라미터(idx)가 누락되었습니다.");
        out.print(resultJson.toString());
        out.flush();
        return;
    }

    BoardSupportDto originalPostDto = dao.getData(idx_str);

    if (originalPostDto == null) {
        resultJson.put("status", "notfound");
        resultJson.put("message", "해당 게시글을 찾을 수 없습니다.");
    } else {
        boolean canView = false;
        // 공개글이거나, 비밀글일 경우 (작성자이거나 admin이면) 조회 가능
        if ("0".equals(originalPostDto.getQna_private())) {
            canView = true;
        } else if ("1".equals(originalPostDto.getQna_private())) {
            if ( (current_userId != null && current_userId.equals(originalPostDto.getQna_writer())) ||
                 (current_loginok != null && "admin".equals(current_loginok)) ) {
                canView = true;
            }
        }

        if (canView) {
            // --- 조회수 증가 로직 ---
            boolean isAuthor = current_userId != null && current_userId.equals(originalPostDto.getQna_writer());
            
            @SuppressWarnings("unchecked") // 세션에서 가져올 때 타입 경고를 무시하기 위함
            List<String> viewedPosts = (List<String>) session.getAttribute("viewedPosts");
            if (viewedPosts == null) {
                viewedPosts = new ArrayList<String>();
            }

            if (!isAuthor && !viewedPosts.contains(idx_str)) {
                dao.updateReadCount(idx_str);
                viewedPosts.add(idx_str);
                session.setAttribute("viewedPosts", viewedPosts);
                originalPostDto.setQna_readcount(originalPostDto.getQna_readcount() + 1);
            }
            // -----------------------

            JSONObject postJson = new JSONObject();
            postJson.put("qna_idx", originalPostDto.getQna_idx());
            postJson.put("qna_title", originalPostDto.getQna_title());
            postJson.put("qna_content", originalPostDto.getQna_content());
            postJson.put("qna_writer", originalPostDto.getQna_writer());
            postJson.put("qna_img", originalPostDto.getQna_img());
            postJson.put("qna_private", originalPostDto.getQna_private());
            postJson.put("qna_category", originalPostDto.getQna_category());
            postJson.put("qna_readcount", originalPostDto.getQna_readcount());
            if(originalPostDto.getQna_writeday() != null) {
                postJson.put("qna_writeday_formatted", sdf.format(originalPostDto.getQna_writeday()));
            } else {
                postJson.put("qna_writeday_formatted", "");
            }
            postJson.put("regroup", originalPostDto.getRegroup());
            postJson.put("restep", originalPostDto.getRestep());
            postJson.put("relevel", originalPostDto.getRelevel());

            resultJson.put("originalPost", postJson);

            // 원본 글의 regroup 값을 기준으로 답변 목록을 가져옵니다.
            int regroupValue = originalPostDto.getRegroup();
            List<BoardSupportDto> repliesList = dao.getRepliesByRegroup(regroupValue);

            JSONArray repliesArray = new JSONArray();
            if (repliesList != null) {
                for (BoardSupportDto replyDto : repliesList) {
                    JSONObject replyJson = new JSONObject();
                    replyJson.put("qna_idx", replyDto.getQna_idx());
                    replyJson.put("qna_title", replyDto.getQna_title());
                    replyJson.put("qna_content", replyDto.getQna_content());
                    replyJson.put("qna_writer", replyDto.getQna_writer());
                    replyJson.put("qna_img", replyDto.getQna_img());
                    if(replyDto.getQna_writeday() != null) {
                        replyJson.put("qna_writeday_formatted", sdf.format(replyDto.getQna_writeday()));
                    } else {
                        replyJson.put("qna_writeday_formatted", "");
                    }
                    
                    // ✨ 수정된 부분: regroup과 restep 값을 JSON에 추가 ✨
                    replyJson.put("regroup", replyDto.getRegroup());
                    replyJson.put("restep", replyDto.getRestep());
                    replyJson.put("relevel", replyDto.getRelevel()); // 이 값은 원래 있었음
                    
                    repliesArray.add(replyJson);
                }
            }
            resultJson.put("replies", repliesArray);
            resultJson.put("status", "success");

        } else {
            resultJson.put("status", "forbidden");
            resultJson.put("message", "비밀글 접근 권한이 없습니다.");
        }
    }
    out.print(resultJson.toString());
    out.flush();
%>