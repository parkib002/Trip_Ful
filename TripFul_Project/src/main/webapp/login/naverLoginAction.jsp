<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.HttpURLConnection" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="org.json.simple.JSONObject" %>
<%@ page import="org.json.simple.parser.JSONParser" %>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%
    // 1. Naver 로그인 콜백으로부터 code와 state 파라미터 받기
    String code = request.getParameter("code");
    String state = request.getParameter("state"); // CSRF 방지를 위해 사용된 state 값 (검증 필요)

    String naverProfileInfoJsonString = null; // 사용자 프로필 JSON 문자열을 저장할 변수
    String naverLoginErrorMessage = null;   // 에러 메시지를 저장할 변수
    JSONObject parsedNaverUserProfile = null; // 파싱된 사용자 정보를 담을 객체

    // code와 state가 정상적으로 넘어왔을 경우에만 토큰 요청 및 프로필 조회 시도
    if (code != null && state != null) {
        // 2. 애플리케이션 등록 시 발급받은 클라이언트 아이디와 시크릿
        String clientId = "IajLk4vELxMTjBeM9JGp"; // ★★★ 실제 Naver 클라이언트 아이디로 변경하세요. ★★★
        String clientSecret = "grEV0aBwgW"; // ★★★ 실제 Naver 클라이언트 시크릿으로 변경하세요. ★★★

        // 3. 콜백 URL (Naver 개발자 센터에 등록된 URL이자 현재 이 페이지의 URL)
        //    토큰 요청 시 redirect_uri 파라미터로 사용됩니다.
        String redirectURI = URLEncoder.encode("http://localhost:8080/TripFul_Project/login/naverLoginAction.jsp", "UTF-8");

        // 4. 액세스 토큰 요청 API URL
        String tokenApiURL = "https://nid.naver.com/oauth2.0/token?grant_type=authorization_code"
            + "&client_id=" + clientId
            + "&client_secret=" + clientSecret
            + "&redirect_uri=" + redirectURI // 현재 페이지 URL과 일치해야 함
            + "&code=" + code
            + "&state=" + state;

        String accessToken = "";

        try {
            URL token_url = new URL(tokenApiURL);
            HttpURLConnection con = (HttpURLConnection)token_url.openConnection();
            con.setRequestMethod("GET");
            int responseCode = con.getResponseCode();
            BufferedReader br;

            if (responseCode == 200) { // 정상 호출
                br = new BufferedReader(new InputStreamReader(con.getInputStream()));
            } else {  // 에러 발생
                br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
            }
            String inputLine;
            StringBuilder res = new StringBuilder();
            while ((inputLine = br.readLine()) != null) {
                res.append(inputLine);
            }
            br.close();
            con.disconnect();

            if (responseCode == 200) {
                JSONParser parser = new JSONParser();
                JSONObject tokenResponseJson = (JSONObject) parser.parse(new StringReader(res.toString()));
                accessToken = (String) tokenResponseJson.get("access_token");

                if (accessToken != null && !accessToken.isEmpty()) {
                    // 5. 사용자 프로필 조회 API 호출
                    String profileApiURL = "https://openapi.naver.com/v1/nid/me";
                    URL profile_url = new URL(profileApiURL);
                    HttpURLConnection profile_con = (HttpURLConnection)profile_url.openConnection();
                    profile_con.setRequestMethod("GET");
                    profile_con.setRequestProperty("Authorization", "Bearer " + accessToken);

                    int profileResponseCode = profile_con.getResponseCode();
                    BufferedReader profile_br;

                    if (profileResponseCode == 200) {
                        profile_br = new BufferedReader(new InputStreamReader(profile_con.getInputStream()));
                    } else {
                        profile_br = new BufferedReader(new InputStreamReader(profile_con.getErrorStream()));
                    }
                    
                    StringBuilder profileRes = new StringBuilder();
                    String profileInputLine;
                    while ((profileInputLine = profile_br.readLine()) != null) {
                        profileRes.append(profileInputLine);
                    }
                    profile_br.close();
                    profile_con.disconnect();

                    naverProfileInfoJsonString = profileRes.toString(); // 화면에 보여줄 JSON 문자열 저장

                    if(profileResponseCode == 200) {
                        // (선택 사항) 사용자 정보 파싱해서 특정 값 사용
                        JSONObject profileJsonResponse = (JSONObject) parser.parse(new StringReader(naverProfileInfoJsonString));
                        // Naver API 응답에서 사용자 정보는 "response" 객체 안에 있습니다.
                        parsedNaverUserProfile = (JSONObject) profileJsonResponse.get("response");
                        
                        // 예: 세션에 사용자 정보 저장 (DB 연동 안 할 경우 임시)
                        // if (parsedNaverUserProfile != null) {
                        //    session.setAttribute("naverUserEmail", parsedNaverUserProfile.get("email"));
                        //    session.setAttribute("naverUserName", parsedNaverUserProfile.get("name"));
                        //    session.setAttribute("isNaverLoggedIn", true);
                        // }
                    } else {
                        naverLoginErrorMessage = "프로필 정보 요청 실패 (응답 코드: " + profileResponseCode + "): " + naverProfileInfoJsonString;
                    }
                } else {
                    naverLoginErrorMessage = "액세스 토큰을 얻는 데 실패했습니다. 응답: " + res.toString();
                }
            } else {
                naverLoginErrorMessage = "토큰 요청 실패 (응답 코드: " + responseCode + "): " + res.toString();
            }
        } catch (Exception pe) {
            naverLoginErrorMessage = "JSON 파싱 오류: " + pe.getMessage();
            // pe.printStackTrace(); // 개발 중 상세 오류 확인
        }/* catch (Exception e) {
            naverLoginErrorMessage = "네이버 로그인 처리 중 예외 발생: " + e.toString();
            // e.printStackTrace(); // 개발 중 상세 오류 확인
        }*/
    } else if (request.getParameter("error") != null) {
        // Naver 인증 과정에서 사용자가 취소하거나 오류 발생 시 error 파라미터로 전달됨
        naverLoginErrorMessage = "네이버 로그인 오류: " + request.getParameter("error_description");
    }
    // 이제 naverProfileInfoJsonString 또는 parsedNaverUserProfile 또는 naverLoginErrorMessage 변수를 사용하여
    // 아래 HTML 부분에서 정보를 표시하거나 다른 처리를 할 수 있습니다.
%>