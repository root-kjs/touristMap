package user.service;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.util.Collections;
import java.util.List;
import java.util.Map;

@Service
public class TourApiService {

    URL url;
    StringBuilder urlBuilder;
    /* [00] 공공데이터 API통신 + JSON파싱 로직을 처리하는 범용함수 */
    private List<Map<String, Object>> fetchAndParse(String apiPath, String extraParams) throws IOException {
        /* 1) 가져올 API 경로 파라미터 설정 */
        urlBuilder = new StringBuilder("https://apis.data.go.kr/B551011/KorService2/" + apiPath +"?"); //호출할 API의 경로 (예: "ldongCode2", "lclsSystmCode2")
        urlBuilder.append("&" + extraParams); // extraParams : 추가 파라미터 & (예: "lDongListYn=Y")

        /* 2) 공통 필수 (&)파라미터 설정 */
        StringBuilder mobileOS = urlBuilder.append("&" + URLEncoder.encode("MobileOS", "UTF-8") + "=" + "WEB");// OS 구분 : IOS (아이폰), AND (안드로이드), WEB (웹), ETC(기타)
        urlBuilder.append("&" + URLEncoder.encode("MobileApp", "UTF-8") + "=" + "Root.Lab");        // 서비스명(어플명)
        urlBuilder.append("&" + URLEncoder.encode("_type", "UTF-8") + "=" + "json");                // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
        urlBuilder.append("&" + URLEncoder.encode("serviceKey", "UTF-8") + "=" + "DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D"); // 공공데이터 API 서비스키

        /* 3) 조합한 URL주소로 HTTP 통신 접속(GET) 요청 */
        url = new URL(urlBuilder.toString());
        System.out.println("url = " + url);
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
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

        /* 6) API 응답 데이터 > ObjectMapper를 사용하여 JSON 문자열을 Map<String, Object>로 변환 */
        ObjectMapper objectMapper = new ObjectMapper();

        // 응답이 비어있거나 올바르지 않은 경우 빈 리스트 반환
        if (sb.length() == 0) return Collections.emptyList();

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

    /* [01] 법정동 코드조회(ldongCode2) */
    @Scheduled(cron = "0 0 9 * * *") // 매일 오전 9시가 될때마다 api 가져오기
    public List<Map<String, Object>> ldongCode2() throws IOException {
        String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "";  // 법정동 시도 코드(인천: 28)_lDongRegnCd 해당되는 법정동 시군구코드 조회 , 입력이 없을시 전체 시도목록 호출
        extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lDongListYn", "UTF-8") + "=" + "Y"; // 법정동 목록조회 여부(N:코드조회 , Y:전체목록조회)
        List<Map<String, Object>> result = fetchAndParse("ldongCode2", extraParams);
        System.out.println( "1.법정동 코드조회(ldongCode2)" + url + "\n1.총 아이템 개수: " + result.size());
        return result;
    }//func end

    /* [02] 분류체계 코드조회(lclsSystmCode2) */
    @Scheduled(cron = "0 0 9 * * *") // 매일 오전 9시가 될때마다 api 가져오기
    public List<Map<String, Object>> lclsSystmCode2() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lclsSystmListYn", "UTF-8") + "=" + "Y"; // 분류체계 목록조회 여부(N:코드조회 , Y:전체목록조회) // lclsSystm1(분류체계 1Depth 코드)
        List<Map<String, Object>> result = fetchAndParse("lclsSystmCode2", extraParams);
        System.out.println("2.분류체계 코드조회(lclsSystmCode2) " + url + "\n2.총 아이템 개수: " + result.size() );
        return result;
    }//func end

    /* [03] 위치기반 관광정보(locationBasedList2) --> 중심좌표기준 반경 20km 이내 관광정보 출력 */
    @Scheduled(cron = "0 0 9 * * *") // 매일 오전 9시가 될때마다 api 가져오기
    public List<Map<String, Object>> locationBasedList2() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "60000";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "28";
        extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "S"; // //arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
        extraParams += "&" + URLEncoder.encode("mapX", "UTF-8") + "=" + "126.5207318";  // *필수입력 파라미터
        extraParams += "&" + URLEncoder.encode("mapY", "UTF-8") + "=" + "37.4689816"; // *필수입력 파라미터
        extraParams += "&" + URLEncoder.encode("radius", "UTF-8") + "=" + "20000"; // *필수입력 파라미터: 거리반경(단위:m) , Max값 20000m=20Km
        List<Map<String, Object>> result = fetchAndParse("locationBasedList2", extraParams);
        System.out.println( "3.위치기반 관광정보(locationBasedList2)" + url + "\n3.총 아이템 개수: " + result.size());
        return result;
    }//func end

    /* [04] 지역기반 관광정보(areaBasedList2) */
    @Scheduled(cron = "0 0 9 * * *") // 매일 오전 9시가 될때마다 api 가져오기
    public List<Map<String, Object>> areaBasedList2() throws IOException {
        String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + ""; // 법정동 시도 코드(인천:28)_전국데이터를 가져와야 해서 일단 빈값(*없어도 되지만 추후 활용)
        extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + "60000";  // 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광정보수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "Q"; // //정렬구분 (A=제목순, C=수정일순, D=생성일순)대표 이미지가 반드시 있는 정렬(O=제목순, Q=수정일순, R=생성일순)
        List<Map<String, Object>> result = fetchAndParse("areaBasedList2", extraParams);
        System.out.println("4.지역기반 관광정보(areaBasedList2)" + url + "\n4.총 아이템 개수: " + result.size() );
        return result;
    }//func end


}// class end