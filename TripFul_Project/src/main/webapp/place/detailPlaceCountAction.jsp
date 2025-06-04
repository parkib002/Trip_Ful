<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@page import="com.google.gson.JsonObject"%>
<%@ page language="java" contentType="application/json; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
    String num = request.getParameter("place_num");
    response.setContentType("application/json; charset=UTF-8");

    PlaceDao dao = new PlaceDao();

    if (num != null && !num.trim().isEmpty()) {
        String readKey = "place_" + num;

        // 조회수 증가는 처음만 수행
        if (session.getAttribute(readKey) == null) {
            dao.placeReadCount(num);
            session.setAttribute(readKey, "true");
        }

        // 어쨌든 조회수는 보내줘야 한다 (새로고침 포함)
        PlaceDto dto = dao.getPlaceData(num);

        JsonObject ob = new JsonObject();
        ob.addProperty("place_count", dto.getPlace_count());

        response.getWriter().write(ob.toString());
    } else {
        // place_num이 잘못된 경우에도 JSON 포맷으로 에러 응답
        JsonObject error = new JsonObject();
        error.addProperty("error", "Invalid place_num");
        response.getWriter().write(error.toString());
    }
%>