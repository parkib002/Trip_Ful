<%@ page language="java" contentType="application/json;charset=UTF-8" %>
<%@ page import="place.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.google.gson.*" %>
<%
    try {
        // 파라미터 기본값 처리 (안 들어오면 page=1, size=10)
        String pageStr = request.getParameter("page");
        String sizeStr = request.getParameter("size");
        int pg = 1;
        int size = 10;

        if (pageStr != null) {
            pg = Integer.parseInt(pageStr);
        }
        if (sizeStr != null) {
            size = Integer.parseInt(sizeStr);
        }

        int start = (pg - 1) * size;

        PlaceDao dao = new PlaceDao();
        List<PlaceDto> list = dao.selectAllPlacesPaged(start, size);

        // ✅ 필드명 변경: place_count → views, place_like → likes
        List<Map<String, Object>> newList = new ArrayList<>();

        for (PlaceDto dto : list) {
            Map<String, Object> map = new HashMap<>();
            map.put("place_num", dto.getPlace_num());
            map.put("place_name", dto.getPlace_name());
            map.put("place_img", dto.getPlace_img());
            map.put("avg_rating", dto.getAvg_rating());
            map.put("views", dto.getPlace_count());  // 변경
            map.put("likes", dto.getPlace_like());   // 변경
            newList.add(map);
        }

        Gson gson = new Gson();
        out.print(gson.toJson(newList));

    } catch (Exception e) {
        response.setStatus(500);
        String errorJson = "{\"error\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}";
        out.print(errorJson);
        e.printStackTrace();
    }
%>
