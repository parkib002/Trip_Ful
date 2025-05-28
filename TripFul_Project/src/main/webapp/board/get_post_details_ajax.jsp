<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="board.BoardSupportDao, board.BoardSupportDto, java.util.List, java.util.Map, java.util.HashMap, java.util.ArrayList" %>
<%@ page import="com.google.gson.Gson" %>
<%@ page import="java.text.SimpleDateFormat" %> <%-- SimpleDateFormat 임포트 추가 --%>
<%
    String qnaIdx = request.getParameter("idx");
    String regroupStr = request.getParameter("regroup");

    BoardSupportDao dao = new BoardSupportDao();
    Map<String, Object> responseData = new HashMap<>();
    Gson gson = new Gson();

    // 원하는 날짜 형식 지정
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy년 MM월 dd일 HH:mm");

    if (qnaIdx != null && !qnaIdx.isEmpty()) {
        BoardSupportDto originalPostDto = dao.getData(qnaIdx);
        if (originalPostDto != null) {
            Map<String, Object> postMap = new HashMap<>();
            postMap.put("qna_idx", originalPostDto.getQna_idx());
            postMap.put("qna_title", originalPostDto.getQna_title());
            postMap.put("qna_content", originalPostDto.getQna_content());
            postMap.put("qna_img", originalPostDto.getQna_img());
            postMap.put("qna_writer", originalPostDto.getQna_writer());
            postMap.put("qna_private", originalPostDto.getQna_private());
            postMap.put("qna_readcount", originalPostDto.getQna_readcount());
            // 날짜 포맷팅
            if (originalPostDto.getQna_writeday() != null) {
                postMap.put("qna_writeday_formatted", sdf.format(originalPostDto.getQna_writeday()));
            } else {
                postMap.put("qna_writeday_formatted", "");
            }
            postMap.put("qna_category", originalPostDto.getQna_category());
            // regroup, restep, relevel 등 필요한 다른 필드도 추가 가능

            responseData.put("originalPost", postMap);
        }
    }

    if (regroupStr != null && !regroupStr.isEmpty()) {
        try {
            int regroup = Integer.parseInt(regroupStr);
            List<BoardSupportDto> repliesDtoList = dao.getRepliesByRegroup(regroup);
            List<Map<String, Object>> repliesListFormatted = new ArrayList<>();

            if (repliesDtoList != null) {
                for (BoardSupportDto replyDto : repliesDtoList) {
                    Map<String, Object> replyMap = new HashMap<>();
                    replyMap.put("qna_idx", replyDto.getQna_idx());
                    replyMap.put("qna_title", replyDto.getQna_title());
                    replyMap.put("qna_content", replyDto.getQna_content());
                    replyMap.put("qna_img", replyDto.getQna_img());
                    replyMap.put("qna_writer", replyDto.getQna_writer());
                    // 날짜 포맷팅
                    if (replyDto.getQna_writeday() != null) {
                        replyMap.put("qna_writeday_formatted", sdf.format(replyDto.getQna_writeday()));
                    } else {
                        replyMap.put("qna_writeday_formatted", "");
                    }
                    replyMap.put("relevel", replyDto.getRelevel());
                    // 필요한 다른 필드 추가

                    repliesListFormatted.add(replyMap);
                }
            }
            responseData.put("replies", repliesListFormatted);
        } catch (NumberFormatException e) {
            responseData.put("error", "Invalid regroup value");
            e.printStackTrace();
        } catch (Exception e) {
            responseData.put("error", "Error fetching replies");
            e.printStackTrace();
        }
    }

    out.print(gson.toJson(responseData));
    out.flush();
%>