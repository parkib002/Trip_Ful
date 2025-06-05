<%@page import="login.SocialDto"%>
<%@page import="login.LoginDao"%>
<%@page import="login.LoginDto"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.net.HttpURLConnection"%>
<%@ page import="java.io.BufferedReader"%>
<%@ page import="java.io.InputStreamReader"%>
<%@ page import="java.io.BufferedWriter"%>
<%@ page import="java.io.OutputStreamWriter"%>
<%@ page import="java.io.StringReader"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="org.json.simple.JSONArray"%>

<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<%
// --- 0. 초기 변수 설정 및 에러 메시지 초기화 ---
String code = request.getParameter("code"); // 카카오 인증 서버로부터 받은 인가 코드
String kakaoLoginErrorMessage = null;

// DB에 저장할 member 정보 (필요한 정보만 남김)
String memberEmail = null; // 카카오 이메일
String memberName = null; // 카카오 이름 (본명, 'name' 필드에서 가져옴)
String memberBirth = null; // 생일 (예: 1130)
String memberBirthYear = null; // 출생년도 (예: 1990)
String memberBirthYYMMDD = null; // 최종 YYMMDD 형식 생년월일

// DB에 저장할 social_accounts 정보
String providerId = null; // 카카오에서 제공하는 사용자 고유 ID (long 타입이므로 String으로 변환)
String accessToken = null;
String refreshToken = null;

// 1. code 파라미터 유효성 검증
if (code == null || code.isEmpty()) {
	kakaoLoginErrorMessage = "카카오 로그인 인증 과정에서 필요한 정보(code)가 누락되었습니다.";
} else {
	// --- 2. 카카오 클라이언트 정보 설정 (보안상 JSP에 하드코딩하는 것은 권장되지 않음) ---
	// ★★★ 실제 카카오 REST API 키로 변경하세요. ★★★
	String clientId = "06960d1e88695098bafe3caf197a0a7e"; // 카카오 REST API 키
	// 카카오 로그인은 clientSecret을 사용하지 않는 경우가 많습니다. (설정했다면)
	// String clientSecret = "YOUR_KAKAO_CLIENT_SECRET"; 

	// 3. 콜백 URL (카카오 개발자 센터에 등록된 URL과 일치해야 함)
	String currentCallbackUrl = "http://localhost:8080/TripFul_Project/login/kakaoLoginAction.jsp";
	String encodedRedirectURI = URLEncoder.encode(currentCallbackUrl, "UTF-8");

	// --- 4. 액세스 토큰 요청 API 호출 ---
	String tokenApiURL = "https://kauth.kakao.com/oauth/token";

	try {
		URL token_url = new URL(tokenApiURL);
		HttpURLConnection con = (HttpURLConnection) token_url.openConnection();
		con.setRequestMethod("POST");
		con.setDoOutput(true); // POST 요청 시 Output Stream으로 데이터 전송

		// 요청 파라미터 설정
		String postParams = "grant_type=authorization_code" + "&client_id=" + clientId + "&redirect_uri="
		+ encodedRedirectURI + "&code=" + code;

		BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(con.getOutputStream()));
		bw.write(postParams);
		bw.flush();
		bw.close();

		int responseCode = con.getResponseCode();
		BufferedReader br;

		if (responseCode == 200) { // 정상 호출
	br = new BufferedReader(new InputStreamReader(con.getInputStream()));
		} else { // 에러 발생
	br = new BufferedReader(new InputStreamReader(con.getErrorStream()));
		}
		StringBuilder res = new StringBuilder();
		String inputLine;
		while ((inputLine = br.readLine()) != null) {
	res.append(inputLine);
		}
		br.close();
		con.disconnect();

		if (responseCode == 200) {
	JSONParser parser = new JSONParser();
	JSONObject tokenResponseJson = (JSONObject) parser.parse(new StringReader(res.toString()));

	accessToken = (String) tokenResponseJson.get("access_token");
	refreshToken = (String) tokenResponseJson.get("refresh_token");

	if (accessToken != null && !accessToken.isEmpty()) {
		// --- 5. 사용자 프로필 조회 API 호출 ---
		String profileApiURL = "https://kapi.kakao.com/v2/user/me";
		URL profile_url = new URL(profileApiURL);
		HttpURLConnection profile_con = (HttpURLConnection) profile_url.openConnection();
		profile_con.setRequestMethod("GET");
		profile_con.setRequestProperty("Authorization", "Bearer " + accessToken);
		profile_con.setRequestProperty("Content-Type", "application/x-www-form-urlencoded;charset=utf-8");

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

		if (profileResponseCode == 200) {
			JSONObject profileJsonResponse = (JSONObject) parser.parse(new StringReader(profileRes.toString()));

			// 카카오 사용자 고유 ID 추출 (long 타입으로 넘어오므로 String으로 변환)
			providerId = String.valueOf(profileJsonResponse.get("id"));

			// 사용자 프로필 정보 추출 (kakao_account 객체 내부에 존재)
			JSONObject kakaoAccount = (JSONObject) profileJsonResponse.get("kakao_account");
			if (kakaoAccount != null) {
				// ★ 수정: '이름 (name)' 동의 항목을 사용하므로, kakaoAccount에서 'name' 필드 직접 추출
				memberName = (String) kakaoAccount.get("name");
				
				// 이메일 정보 추출 (필수 동의로 설정되어 있어야 추출 가능)
				Boolean hasEmail = (Boolean) kakaoAccount.get("has_email");
				if (hasEmail != null && hasEmail) {
					memberEmail = (String) kakaoAccount.get("email");
					System.out.println(memberName);
				}

				// 생년월일 (birthday, birthyear) 정보 추출
				Boolean hasBirthday = (Boolean) kakaoAccount.get("has_birthday");
				if (hasBirthday != null && hasBirthday) {
					memberBirth = (String) kakaoAccount.get("birthday"); // 예: "1130"
				}
				Boolean hasBirthyear = (Boolean) kakaoAccount.get("has_birthyear");
				if (hasBirthyear != null && hasBirthyear) {
					memberBirthYear = (String) kakaoAccount.get("birthyear"); // 예: "1990"
				}
                
                // --- 생년월일 YYMMDD 형식으로 변환 ---
                if (memberBirthYear != null && memberBirth != null) {
                    // 예: 1990 -> 90, 1130 -> 901130
                    if (memberBirthYear.length() >= 2) { // 길이가 충분한지 확인
                        memberBirthYYMMDD = memberBirthYear.substring(2) + memberBirth;
                    } else {
                        memberBirthYYMMDD = memberBirth; // 년도가 2자리 미만이면 월일만 사용 또는 에러 처리
                    }
                } else {
                    memberBirthYYMMDD = ""; // 정보가 없으면 빈 문자열
                }
			}

			if (providerId != null && !providerId.isEmpty()) {
				// -------------------------------------------------------------
				// --- 6. 추출된 정보를 바탕으로 DB 연동 로직 (가장 중요한 부분) ---
				// -------------------------------------------------------------
				LoginDao dao = new LoginDao();
				if (dao.getMemberIdx("kakao", providerId) == null) {
					// 신규 회원: 회원가입 폼으로 정보 넘겨주기
					SocialDto s_dto = new SocialDto();
					s_dto.setSocial_provider("kakao");
					s_dto.setSocial_provider_key(providerId);
					session.setAttribute("social", s_dto);
%>
<script>
    // 회원가입 탭으로 이동하고, 카카오에서 받은 정보를 미리 채워넣음
    $(opener.document).find("#tab-2").prop("checked", true);
    $(opener.document).find("input[name='name']").val("<%=memberName != null ? memberName : ""%>").prop("readonly", true);
    $(opener.document).find("input[name='email']").val("<%=memberEmail != null ? memberEmail : ""%>").prop("readonly", true);
    // 생년월일 필드에 데이터 채우기 (YYMMDD 형식)
    $(opener.document).find("input[name='birth']").val("<%=memberBirthYYMMDD%>").prop("readonly", true);
    window.close();
</script>
<%
return;
} else {
// 기존 회원: 로그인 처리
LoginDto dto = dao.getOneMember(dao.getIdwithIdx(dao.getMemberIdx("kakao", providerId)));
if (dto.getAdmin() == 1) {
	session.setAttribute("loginok", "admin");
	session.setAttribute("social", "kakao");
	session.setAttribute("id", dto.getId());
%>
<script>
	window.opener.document.location.href = "../page/adminMain.jsp";
	window.close();
</script>
<%
} else {
session.setAttribute("loginok", "user");
session.setAttribute("social", "kakao");
session.setAttribute("id", dto.getId());
%>
<script>
	window.opener.document.location.href = "../index.jsp";
	window.close();
</script>
<%
}
return;
}

} else {
kakaoLoginErrorMessage = "카카오 사용자 고유 ID를 얻을 수 없습니다.";
}
} else {
kakaoLoginErrorMessage = "카카오 프로필 정보 요청 실패 (응답 코드: " + profileResponseCode + "): " + profileRes.toString();
}
} else {
kakaoLoginErrorMessage = "액세스 토큰을 얻는 데 실패했습니다. 응답: " + res.toString();
}
} else {
kakaoLoginErrorMessage = "토큰 요청 실패 (응답 코드: " + responseCode + "): " + res.toString();
}
} catch (Exception e) {
kakaoLoginErrorMessage = "카카오 로그인 처리 중 예외 발생: " + e.getMessage();
e.printStackTrace();
}
}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>카카오 로그인 처리</title>
</head>
<body>
	<%
	if (kakaoLoginErrorMessage != null) {
	%>
	<p>
		오류:
		<%=kakaoLoginErrorMessage%></p>
	<p>로그인 페이지로 돌아가려면 이 창을 닫아주세요.</p>
	<script>
		// 오류 발생 시 팝업 창을 닫도록 시도
		window.close();
	</script>
	<%
	}
	%>
</body>
</html>