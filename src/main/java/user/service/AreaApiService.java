package user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;
import java.util.Map;
import static user.api.TourApiClient.url_api;

@Service
public class AreaApiService {

    @Autowired
    private TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [17개] 법정동 코드(ldongCode2) > 도/광역시(17개:서울/경기/인천 등) */
    public List<Map<String, Object>> getLdongCode2Resion1() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "17";  // 법정동코드 > 도/광역시(17개)
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("ldongCode2", extraParams);
        System.out.printf("1차 법정동 : %s\n 총 개수: %d", url_api, result.size());
        return result;
    }//func end

    /* [공통] 법정동코드(1차지역)를 파라미터로 받아 지역기반 관광정보를 조회하는 범용 메소드 */
    public List<Map<String, Object>> getAreaList2Resion(String lDongRegnCd) throws IOException {
        // numOfRows(한 페이지 결과 수): 전국 data: 50,204개(250906)
        // arrange(정렬구분): A=제목순, C=수정일순, D=생성일순 / 대표 이미지가 반드시 있는 정렬(O=제목순, Q=수정일순, R=생성일순)
        String extraParams = String.format("lDongRegnCd=%s&numOfRows=10000&arrange=Q", URLEncoder.encode(lDongRegnCd, StandardCharsets.UTF_8));
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("areaBasedList2", extraParams);
        System.out.printf("1.지역(areaBasedList2) : %s\n 1. api_url : %s\n 1.총 개수: %d", lDongRegnCd, url_api, result.size());
        return result;
    }//func end

    /* [ 통합] 법정동 코드가져와서 getAreaList2Resion에 해당 법정동코드 넘겨주는 메소드 */
    @Scheduled(cron = "0 0 3 * * *")
    public void fetchAllCityDataScheduled() {
        System.out.println("[시작] 전국 주요도시 관광정보 조회 ");
        try {
            List<Map<String, Object>> regionList = getLdongCode2Resion1(); // 1. 먼저, API를 통해 1차 지역(17개) 목록을 가져옵니다.
            // 2. for-each 반복문으로 지역 목록을 순회합니다.
            for (Map<String, Object> region : regionList) {
                String code = (String) region.get("code"); // Map에서 code와 name값 추출
                String name = (String) region.get("name");
                try {
                    System.out.printf("[%s(%s)] 관광정보 조회\n", name, code);
                    List<Map<String, Object>> touristData = getAreaList2Resion(code); // 추출code > 해당 지역 관광정보 조회
                    System.out.printf("[%s] 지역기반 관광정보(areaBasedList2) %s\n 4.총 개수: %d\n ",name, url_api, touristData.size() );
                } catch (IOException e) {
                    System.out.println("오류:" + name + e);
                }
            }
        } catch (IOException e) {
            System.out.printf("오류:"+ e);
        }
        System.out.println("[종료] 전국 주요도시 관광정보 조회");
    }//func end

}// class end