<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="board.BoardSupportDto"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    // HTTP 응답 헤더 설정: JSON임을 브라우저에 알립니다.
    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");

    String userId = request.getParameter("id");
    // 디버깅을 위해 하드코딩된 userId를 제거하거나 필요에 따라 사용하세요.
    // 현재는 "kch0101"로 고정되어 있으나, 실제 사용자 ID를 받아야 합니다.
    if (userId == null || userId.isEmpty()) {
        // userId가 없을 경우에 대한 처리 (예: 빈 JSON 반환 또는 에러 메시지)
        userId = "kch0101"; // 임시로 디폴트 값 설정 (실제 배포시에는 적절한 에러 처리 필요)
    }

    BoardSupportDao myPageDao = new BoardSupportDao();
    List<BoardSupportDto> mypage_qna_list = myPageDao.getAllDataForMyPage(userId); // 실제 userId 사용

    // 최상위 JSON 객체와 배열 생성
    JSONObject resultObj = new JSONObject(); // 최종적으로 응답할 JSON 객체
    JSONArray qnaArray = new JSONArray();   // Q&A DTO들을 담을 JSON 배열

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");

    if(mypage_qna_list != null && !mypage_qna_list.isEmpty()) {
        for(BoardSupportDto dto : mypage_qna_list) {
            JSONObject qnaItem = new JSONObject(); // 각 Q&A DTO를 담을 JSON 객체

            qnaItem.put("qna_idx", dto.getQna_idx());
            qnaItem.put("qna_title", dto.getQna_title());
            qnaItem.put("qna_writer", dto.getQna_writer());
            qnaItem.put("qna_category", dto.getQna_category());
            // boolean 값은 JavaScript에서 true/false로 직접 변환됩니다.
            qnaItem.put("qna_private", dto.getQna_private().equals("1")); 
            qnaItem.put("qna_writeday", sdf.format(dto.getQna_writeday()));
            qnaItem.put("is_answered", dto.isAnswered()); // isAnswered는 이미 boolean이라고 가정

            qnaArray.add(qnaItem); // 생성된 Q&A 객체를 배열에 추가
        }
    }
    
    // 모든 Q&A 항목이 담긴 배열을 최종 JSON 객체에 "qna" 키로 추가
    resultObj.put("qna", qnaArray);
    
    // 최종 JSON 객체를 문자열로 변환하여 출력
    out.print(resultObj.toString());
    out.flush(); // 버퍼 비우기
%>