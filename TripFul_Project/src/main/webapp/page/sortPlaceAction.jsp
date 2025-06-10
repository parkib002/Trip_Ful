<%@page import="org.json.JSONObject"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="place.PlaceDto"%>
<%@page import="java.util.List"%>
<%@page import="place.PlaceDao"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>

<%

	String sort=request.getParameter("sort");
	
	System.out.println(sort);

	PlaceDao dao=new PlaceDao();
	
	List<PlaceDto> list=dao.getCountPlace(sort);
	
	JSONArray arr=new JSONArray();
		
	for(PlaceDto dto:list)
	{
		JSONObject ob=new JSONObject();
		ob.put("place_name", dto.getPlace_name());
		ob.put("country_name", dto.getCountry_name());
		ob.put("place_count", dto.getPlace_count());
		ob.put("place_like", dto.getPlace_like());
		ob.put("place_rating", dto.getAvg_rating());
		ob.put("place_num",dto.getPlace_num());
		
		
		arr.put(ob);
	}
			
			
%>
<%=arr.toString()%>