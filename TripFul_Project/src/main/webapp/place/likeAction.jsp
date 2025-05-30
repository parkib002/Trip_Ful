<%@page import="com.google.gson.JsonObject"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
	String num=request.getParameter("place_num");

	PlaceDao dao=new PlaceDao();
	
	dao.likeCount(num);
	
	int like=dao.getLikeCount(num);
	
	JsonObject ob=new JsonObject();
	
	ob.addProperty("place_like", like);
	
	out.print(ob.toString());
%>
