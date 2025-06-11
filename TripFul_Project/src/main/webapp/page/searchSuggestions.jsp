<%@ page contentType="application/json; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.stream.Collectors" %>
<%@ page import="java.util.stream.Stream" %>
<%@ page import="java.util.Arrays" %>
<%@ page import="place.PlaceDao" %>
<%@ page import="place.PlaceDto" %>
<%@ page import="com.google.gson.Gson" %>

<%
    String keyword = request.getParameter("keyword");
    if (keyword == null) keyword = "";

    PlaceDao dao = new PlaceDao();
    List<PlaceDto> allPlaces = dao.getRandomPlaces(100); // 장소 리스트

    String lowerKeyword = keyword.toLowerCase().trim();
    boolean isHashtagSearch = lowerKeyword.startsWith("#"); // 키워드가 '#'으로 시작하는지 확인

    // 해시태그 검색이면 '#'을 제거한 키워드로 실제 검색 수행
    String actualSearchKeyword = isHashtagSearch ? lowerKeyword.substring(1) : lowerKeyword;

    if (lowerKeyword.isEmpty()) {
        out.print("[]");
        return;
    }

    Set<String> suggestions = allPlaces.stream()
        .flatMap(dto -> {
            Stream<String> relatedTerms = Stream.empty();

            // 1. 장소 이름 검색 (항상 적용)
            // '#' 검색이 아닐 때만 장소 이름을 추천합니다.
            // '#' 검색일 때는 해시태그에 집중하기 위함
            if (!isHashtagSearch && dto.getPlace_name() != null && dto.getPlace_name().toLowerCase().contains(actualSearchKeyword)) {
                relatedTerms = Stream.concat(relatedTerms, Stream.of(dto.getPlace_name()));
            }

            // 2. 국가 이름 검색 (항상 적용)
            // '#' 검색이 아닐 때만 국가 이름을 추천합니다.
            if (!isHashtagSearch && dto.getCountry_name() != null && dto.getCountry_name().toLowerCase().contains(actualSearchKeyword)) {
                relatedTerms = Stream.concat(relatedTerms, Stream.of(dto.getCountry_name()));
            }

            // 3. 태그 검색 로직 (isHashtagSearch 여부에 따라 엄격하게 분기)
            if (dto.getPlace_tag() != null) {
                relatedTerms = Stream.concat(relatedTerms,
                    Arrays.stream(dto.getPlace_tag().split(","))
                        .map(String::trim)
                        .filter(tag -> {
                            boolean tagStartsWithHash = tag.startsWith("#");
                            boolean tagContainsKeyword = tag.toLowerCase().contains(actualSearchKeyword);

                            if (isHashtagSearch) {
                                // '#'으로 시작하는 키워드인 경우:
                                // 태그에 실제 검색어가 포함되어 있고, '태그도 반드시 #'으로 시작하는 경우만 포함'
                                return tagContainsKeyword && tagStartsWithHash;
                            } else {
                                // 일반 키워드인 경우:
                                // 태그에 실제 검색어가 포함되어 있고, 태그가 '#'으로 시작하지 않는 경우만 포함.
                                return tagContainsKeyword && !tagStartsWithHash;
                            }
                        })
                        .map(tag -> {
                            // 결과에 '#'을 붙여서 보여줄지 말지는 isHashtagSearch에 따라 결정
                            if (isHashtagSearch) {
                                return tag.startsWith("#") ? tag : "#" + tag; // #검색시 #붙여서 보여줌
                            } else {
                                return tag.startsWith("#") ? tag.substring(1) : tag; // 일반 검색시 #제거
                            }
                        })
                );
            }
            return relatedTerms;
        })
        .map(String::trim)
        // 최종적으로 키워드가 포함된 것만 필터링 (다시 한번 필터링하여 정확도 높임)
        .filter(name -> {
            if (isHashtagSearch) {
                // 해시태그 검색 시에는 '#'이 붙은 형태로 필터링
                return name.toLowerCase().contains(lowerKeyword); // 예: '#서울'이라는 제안이 '#서'를 포함하는지
            } else {
                // 일반 검색 시에는 '#'이 없는 형태로 필터링
                return name.toLowerCase().contains(lowerKeyword); // 예: '서울'이라는 제안이 '서'를 포함하는지
            }
        })
        .distinct()
        .limit(10)
        .collect(Collectors.toSet());

    Gson gson = new Gson();
    String json = gson.toJson(suggestions);
    out.print(json);
%>