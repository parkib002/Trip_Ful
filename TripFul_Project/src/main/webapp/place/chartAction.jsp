<%@page import="org.json.JSONObject"%>
<%@page import="org.json.JSONArray"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="java.util.List"%>
<%@page import="place.PlaceDto"%>
<%@page import="place.PlaceDao"%>
<%@ page contentType="application/json; charset=UTF-8" %>
<%
	request.setCharacterEncoding("utf-8");

	String continent=request.getParameter("currentContinent");
	String sort=request.getParameter("c_Sort");
	
	PlaceDao dao=new PlaceDao();
	
	List<PlaceDto> list=dao.getCountContinent(sort, continent);
	
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