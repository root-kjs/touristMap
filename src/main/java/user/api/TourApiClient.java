package user.api;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Component
public class TourApiClient {

    @Value("${api.tour.service-key}") // 공공데이터 API서비스 키( https://apis.data.go.kr/B551011/KorService2/)
    private String serviceKey;

    private final ObjectMapper objectMapper = new ObjectMapper(); // API 응답 데이터 > ObjectMapper를 사용하여 JSON문자열을 자바객체 변환 도구 */

    public static URL url_api;
    /* [00] 공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수(한국관광공사_국문 관광정보 서비스_GW : https://apis.data.go.kr/B551011/KorService2/) */
    public List<Map<String, Object>> fetchAndParse(String apiPath, String extraParams) throws IOException {
        /* 1) 가져올 API 경로 파라미터 설정 */
        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/B551011/KorService2/" + apiPath +"?"); //호출할 API의 경로 (예: "ldongCode2", "lclsSystmCode2")
        urlBuilder.append("&" + extraParams); // extraParams : 추가 파라미터 & (예: "lDongListYn=Y")

        /* 2) 공통 필수 (&)파라미터 설정 */
        StringBuilder mobileOS = urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + "WEB");// OS 구분 : IOS (아이폰), AND (안드로이드), WEB (웹), ETC(기타)
        urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + "Root.Lab");    // 서비스명(어플명)
        urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + "json");            // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
        urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + serviceKey ); // 공공데이터 API 서비스키

        /* 3) 조합한 URL주소로 HTTP 통신 접속(GET) 요청 */
        url_api = new URL(urlBuilder.toString());
        System.out.println("url = " + url_api);
        HttpURLConnection conn = (HttpURLConnection) url_api.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");

        /* 4) API응답 데이터 > 문자 기반 입력스트림(Reader)을 버퍼링(buffering)해서 읽기  > 라인 단위 입력(readLine()) 가능 */
        BufferedReader rd;
        if (conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {  // / 서버의 응답여부 확인
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));
        }
        /* 5) 버퍼 리더(rd)를 통해 한 줄씩 데이터를 읽어온 데이터 스트링 빌더(sb --> StringBuilder(가변 길이 문자열 저장소)에 계속 추가 */
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();

        if (sb.length() == 0) return Collections.emptyList(); // 응답이 비어있거나 올바르지 않은 경우 빈 리스트 반환

        /* 7) TypeReference를 사용해 복잡한 중첩 구조의 제네릭 타입을 명시 */
        Map<String, Object> resultMap = objectMapper.readValue(sb.toString(), new TypeReference<Map<String, Object>>() {});

        /* 8) Map을 탐색하여 원하는 데이터에 접근(Casting 필수) + null처리 : // 키를 이용해 단계적으로 응답받은 내부 데이터에 접근 */
        // response.body.items.item
        Map<String, Object> response = (Map<String, Object>) resultMap.get("response");
        if (response == null)  return Collections.emptyList();
        Map<String, Object> body = (Map<String, Object>) response.get("body");
        if (body == null) return Collections.emptyList();
        Map<String, Object> items = (Map<String, Object>) body.get("items");
        if (items == null) return Collections.emptyList();

        /* 9) item(최종 데이터) ---> List 형태이므로 List<Map<String, Object>>으로 캐스팅(데이터 자료형) 변환 */
        List<Map<String, Object>> itemList = (List<Map<String, Object>>) items.get("item");

        /* 10) 최종리스트 리턴 */
        if (itemList == null) {
            System.out.println("[실패] 총 아이템 개수: 0");
            return Collections.emptyList(); // 최종 데이터가 null인 경우 빈 리스트 반환
        }
        //System.out.println("[성공] 총 아이템 개수: " + itemList.size());
        return itemList;
    }//func end

}// class end
