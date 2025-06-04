<%@page import="java.util.Collections"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="review.ReviewDao"%>
<%@page import="java.util.TimeZone"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@ page import="java.net.*, java.io.*, org.json.*" %>
<%@ page contentType="application/json; charset=UTF-8" %>
	<%
	String place_num=request.getParameter("place_num");
	ReviewDao dao=new ReviewDao();
	//관광지 이름
	String place_name=dao.getPlaceName(place_num);
	//관광지 코드
	String place_code=dao.getPlaceCode(place_num);
	SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
	//DB리스트
	List<HashMap<String,String>> DBlist=dao.getPlaceList(place_num);
	
    String apiKey = "AIzaSyCKGdGbCxXFTXVCUSrJ5ktk_jpgeBdon6A"; // 여기에 본인의 API 키 입력
    
  // String placeId = "ChIJod7tSseifDUR9hXHLFNGMIs"; // 예시: Sydney의 Google place ID
    
	//placeId를 place_code로 바꿔주면된다
    String urlString = "https://maps.googleapis.com/maps/api/place/details/json?place_id=" + place_code +"&language=ko" + "&fields=review,rating&key=" + apiKey;
	
    URL url = new URL(urlString);	
    HttpURLConnection conn = (HttpURLConnection) url.openConnection();
    conn.setRequestMethod("GET");

    BufferedReader reader = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
    StringBuilder response1 = new StringBuilder();

    String line;
    while ((line = reader.readLine()) != null) {
        response1.append(line);
    }
    reader.close();

    JSONObject json = new JSONObject(response1.toString());
    JSONArray googleReviews = json.getJSONObject("result").optJSONArray("reviews");
    
    List<HashMap<String, String>> merged = new ArrayList<>();
    
 	// Google 리뷰 추가
 	if (googleReviews != null) {
     for (int i = 0; i < googleReviews.length(); i++) {
         JSONObject r = googleReviews.getJSONObject(i);
         HashMap<String, String> apilist = new HashMap<>();
         apilist.put("author", r.optString("author_name"));
         apilist.put("rating", String.valueOf(r.optDouble("rating")));
         apilist.put("text", r.optString("text"));
		 
         long time = r.optLong("time") * 1000L;
         String date = "";
         if (time > 0) {
             Date d = new Date(time);             
             sdf.setTimeZone(TimeZone.getTimeZone("Asia/Seoul"));
             date = sdf.format(d);
         }
         apilist.put("date", date);
       	 apilist.put("photo1", "null");
         apilist.put("photo2", "null");
         apilist.put("photo3", "null");
         apilist.put("read", "Google");
         //api 리뷰 리스트 병합 리스트에 추가
         merged.add(apilist);    // Google 리뷰
      	
     	
     }
 }
 	
 	
    // DB 리뷰에서 키명 맞추기
    for (HashMap<String, String> map : DBlist) {
        HashMap<String, String> review = new HashMap<>();
        String reviewData=map.get("review_writeday");
        reviewData=reviewData.substring(0,reviewData.length()-9);
        review.put("author", map.get("review_id"));	
        review.put("rating", map.get("review_star"));
        review.put("text", map.get("review_content"));       
        review.put("date", reviewData);               
        
        String review_img=map.get("review_img");
        if(review_img!=null)
        {
        	String [] review_imgs=review_img.split(",");
        	for(int i=0;i<review_imgs.length;i++)
        	{
        		if(review_imgs.length>i)
        		{
        			review.put("photo"+(i+1), review_imgs[i].trim());
        		}else{
        			review.put("photo"+(i+1),"");
        		}
        	}
        }else{
        	review.put("photo1", "");
            review.put("photo2", "");
            review.put("photo3", "");
        }
        
        
        review.put("read","DB");
        review.put("review_idx", map.get("review_idx"));
        merged.add(review);
    } 	
 	
    // 날짜순 정렬   
    Collections.sort(merged, (m1, m2) -> {
        try {
            return sdf.parse(m2.get("date")).compareTo(sdf.parse(m1.get("date")));
        } catch (Exception e) {
            return 0;
        }
    });

    // JSONArray로 변환
    JSONArray jsonArr = new JSONArray();
    for (HashMap<String, String> m : merged) {
        JSONObject obj = new JSONObject(m);
        jsonArr.put(obj);
    }

    JSONObject result = new JSONObject();
    result.put("reviews", jsonArr);
    //System.out.println(result.toString());
    
%>
<%=result.toString() %>
