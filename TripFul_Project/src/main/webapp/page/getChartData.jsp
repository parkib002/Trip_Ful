<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="place.PlaceDao, place.PlaceDto, java.util.*, com.google.gson.Gson"%>
<%
    // 1. 클라이언트에서 보낸 파라미터 받기
    String continent = request.getParameter("continent");
    String sort = request.getParameter("sort");

    // 파라미터 유효성 검사 (기본값 설정)
    if (continent == null || continent.isEmpty()) {
        continent = "asia"; // 기본값: 아시아
    }
    if (sort == null || sort.isEmpty()) {
        sort = "views"; // 기본값: 조회순
    }

    // 2. DAO를 사용하여 데이터베이스에서 데이터 조회
    PlaceDao placeDao = new PlaceDao();
    List<PlaceDto> placeList = placeDao.selectContinentPlaces(continent, sort);

    // 3. ECharts에서 사용할 데이터 형식으로 가공
    List<String> labels = new ArrayList<>();   // x축 (장소 이름)
    List<Object> values = new ArrayList<>();   // y축 (정렬 기준에 따른 값)

    for (PlaceDto dto : placeList) {
        labels.add(dto.getPlace_name());
        
        if ("rating".equals(sort)) {
            // 별점이 null일 경우 0으로 처리
            values.add(dto.getAvg_rating() != null ? dto.getAvg_rating() : 0);
        } else if ("likes".equals(sort)) {
            values.add(dto.getPlace_like());
        } else { // "views" 또는 기본값
            values.add(dto.getPlace_count());
        }
    }

    // 4. 가공된 데이터를 Map에 담기
    Map<String, Object> chartData = new HashMap<>();
    chartData.put("labels", labels);
    chartData.put("values", values);

    // 5. Gson 라이브러리를 사용하여 Map을 JSON 문자열로 변환
    Gson gson = new Gson();
    String json = gson.toJson(chartData);

    // 6. JSON 응답 전송
    out.print(json);
%>