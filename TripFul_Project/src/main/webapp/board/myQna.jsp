<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.json.simple.JSONArray"%>
<%@page import="org.json.simple.JSONObject"%>
<%@page import="board.BoardSupportDto"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardSupportDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
	String userId = request.getParameter("id");
	String continent = request.getParameter("continent");
	
	BoardSupportDao myPageDao=new BoardSupportDao();
	List<BoardSupportDto> mypage_qna_list = null;
	mypage_qna_list=myPageDao.getAllDataForMyPage(userId);
	
	JSONObject obj = new JSONObject();
    JSONArray arr = new JSONArray();
    
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
    
    if(mypage_qna_list != null && !mypage_qna_list.isEmpty())
    {
    	for(BoardSupportDto dto : mypage_qna_list)
    	{
    		JSONObject ob = new JSONObject();
    		
    		ob.put("qna_idx", dto.getQna_idx());
    		ob.put("qna_title", dto.getQna_title());
    		ob.put("qna_writer", dto.getQna_writer());
    		ob.put("qna_category", dto.getQna_category());
    		ob.put("qna_private", dto.getQna_private().equals("1"));
    		ob.put("qna_writeday", sdf.format(dto.getQna_writeday()));
    		ob.put("is_answered", dto.isAnswered()); 
    		
    		arr.add(ob);
    	}
    }
%>
<%=arr.toString()%>