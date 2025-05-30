<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="place.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*" %>
<%
	

    int pg = Integer.parseInt(request.getParameter("page"));
    int size = Integer.parseInt(request.getParameter("size"));
    int start = (pg - 1) * size;

    PlaceDao dao = new PlaceDao();
    List<PlaceDto> list = dao.selectAllPlacesPaged(start, size);

    Gson gson = new Gson();
    out.print(gson.toJson(list));
%>