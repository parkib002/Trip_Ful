<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardSupportDao"%>
<%@ page import="board.BoardSupportDto"%>
<%@ page import="java.util.List"%>
<%@ page import="org.json.simple.JSONObject"%> <%-- 만약 json-simple 라이브러리를 사용한다면 --%>
<%@ page import="org.json.simple.JSONArray"%>  <%-- 만약 json-simple 라이브러리를 사용한다면 --%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    // 요청 파라미터 받기
    String idx_str = request.getParameter("idx");
    String regroup_str_param = request.getParameter("regroup"); // 답글 가져올 때 사용

    JSONObject resultJson = new JSONObject(); // 최종 반환될 JSON 객체
    BoardSupportDao dao = new BoardSupportDao();
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");

    if (idx_str != null) {
        // 1. 원글 정보 가져오기
        BoardSupportDto originalPostDto = dao.getData(idx_str); // getData는 qna_idx로 하나의 DTO를 가져옴
        if (originalPostDto != null) {
            // 조회수 증가 (AJAX로 상세보기를 하므로, 여기서 조회수 증가 로직을 넣거나, 별도 처리 필요)
            // dao.updateReadCount(idx_str); // 필요하다면 주석 해제 (중복 증가 방지 로직 고려)

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
            
            // 🔽 중요! regroup, restep, relevel 추가 🔽
            postJson.put("regroup", originalPostDto.getRegroup());
            postJson.put("restep", originalPostDto.getRestep());
            postJson.put("relevel", originalPostDto.getRelevel());
            // 🔼 중요! regroup, restep, relevel 추가 🔼

            resultJson.put("originalPost", postJson);

            // 2. 답글 목록 가져오기 (regroup 파라미터가 있다면, 또는 originalPostDto.getRegroup() 사용)
            if (regroup_str_param != null) { // 또는 originalPostDto.getRegroup()를 사용할 수 있음
                int regroup = Integer.parseInt(regroup_str_param);
                List<BoardSupportDto> repliesList = dao.getRepliesByRegroup(regroup); // DAO에 이 메소드 구현 필요
                JSONArray repliesArray = new JSONArray();
                for (BoardSupportDto replyDto : repliesList) {
                    JSONObject replyJson = new JSONObject();
                    replyJson.put("qna_idx", replyDto.getQna_idx());
                    replyJson.put("qna_title", replyDto.getQna_title());
                    replyJson.put("qna_content", replyDto.getQna_content());
                    replyJson.put("qna_writer", replyDto.getQna_writer());
                    replyJson.put("qna_img", replyDto.getQna_img());
                    // ... 기타 필요한 답글 필드들 ...
                    if(replyDto.getQna_writeday() != null) {
                        replyJson.put("qna_writeday_formatted", sdf.format(replyDto.getQna_writeday()));
                    } else {
                        replyJson.put("qna_writeday_formatted", "");
                    }
                    replyJson.put("regroup", replyDto.getRegroup());
                    replyJson.put("restep", replyDto.getRestep());
                    replyJson.put("relevel", replyDto.getRelevel());
                    repliesArray.add(replyJson);
                }
                resultJson.put("replies", repliesArray);
            }
        }
    }
    out.print(resultJson.toString());
%>