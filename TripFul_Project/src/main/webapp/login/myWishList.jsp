<%@page import="java.util.HashMap"%>
<%@page import="java.util.List"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="login.MyPageDao"%>
<%@page import="place.PlaceDao"%>
<%@page import="place.PlaceDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%
    String userId = request.getParameter("id");
    String continent = request.getParameter("continent");

    MyPageDao myPageDao = new MyPageDao();
    PlaceDao placeDao = new PlaceDao();
    List<String> placeNumsInWishlist = null;

    placeNumsInWishlist = myPageDao.getWishList(continent, userId);

    JSONObject obj = new JSONObject();
    JSONArray arr = new JSONArray();

    if (placeNumsInWishlist != null && !placeNumsInWishlist.isEmpty()) {
        for (String placeNum : placeNumsInWishlist) {
            PlaceDto placeDto = placeDao.getPlaceData(placeNum); 
            
            if(placeDto != null) {
                JSONObject placeObj = new JSONObject();
                placeObj.put("continent_name", placeDto.getContinent_name());
                placeObj.put("country_name", placeDto.getCountry_name());
                placeObj.put("place_num", placeDto.getPlace_num());
                placeObj.put("place_img", placeDto.getPlace_img());
                placeObj.put("place_content", placeDto.getPlace_content());
                placeObj.put("place_tag", placeDto.getPlace_tag());
                placeObj.put("place_code", placeDto.getPlace_code());
                placeObj.put("place_name", placeDto.getPlace_name());
                placeObj.put("place_count", placeDto.getPlace_count());
                placeObj.put("place_addr", placeDto.getPlace_addr());
                placeObj.put("place_like", placeDto.getPlace_like());
                
                arr.add(placeObj);
            }
        }
    }
    obj.put("wishlist", arr);

    response.setContentType("application/json");
    response.setCharacterEncoding("UTF-8");
%>
<%=obj.toString()%>