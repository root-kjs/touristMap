package user.service;
/* 공공데이터 > 지역기반 관광정보조회(http://apis.data.go.kr/B551011/KorService2/areaBasedList2) */
import lombok.RequiredArgsConstructor;
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
@RequiredArgsConstructor
public class AreaService {

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [01_17개] 1차 법정동 코드(ldongCode2) > 도/광역시(17개:서울/경기/인천 등) 데이터 호출 */
    public List<Map<String, Object>> getLdongCode2Resion1() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "17";
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("ldongCode2", extraParams);
        System.out.printf("1차 법정동 : %s\n 총 개수: %d", url_api, result.size()); // !확인용
        return result;
    }//func end

//    /* [02_17개] 1차 법정동코드(17개) 가져와서, getAreaList2Resion()에 해당 법정동코드 넘겨주는 메소드 */
//    @Scheduled(cron = "0 0 3 * * *")
//    public void fetchAllCityDataScheduled() {
//        System.out.println("[시작] 전국 주요도시 관광정보 조회 ");
//        try {
//            List<Map<String, Object>> regionList = getLdongCode2Resion1(); // 1. 1차 지역(17개) 법정동 리스트 가져오기
//            // 2. for-each(반복문) 1차 지역목록 순회 > 코드와 지역명 추출
//            for (Map<String, Object> region : regionList) { // Map에서 code와 name값 추출
//                String lDongRegnCd = (String) region.get("code");
//                String name = (String) region.get("name");
//                try {
//                    System.out.printf("[%s(%s)] 관광정보 조회\n", name, code); // !확인용
//                    List<Map<String, Object>> touristData = getAreaList2Resion( lDongRegnCd ); // 추출code > 해당 지역 관광정보 조회
//                    System.out.printf("[%s] [02_17개]지역기반 관광정보(areaBasedList2) %s\n 4.총 개수: %d\n ",name, url_api, touristData.size() ); // 해당 지역 데이터 확인용!
//                } catch (IOException e) {
//                    System.out.println("오류:" + name + e);
//                }
//            }
//        } catch (IOException e) { System.out.printf("오류:"+ e); }
//        System.out.println("[종료] 전국 주요도시 관광정보 조회");
//    }//func end

    /* [03_공통] 법정동코드(1차지역_17개)를 개별코드 파라미터로 받아 > 지역기반 관광정보를 데이터 호출 > 리스트/맵으로 변환 */
    public List<Map<String, Object>> getAreaList2Resion( String lDongRegnCd ) throws IOException {
        // numOfRows(한 페이지 결과 수): 전국 data: 50,204개(250906)
        // arrange(정렬구분): A=제목순, C=수정일순, D=생성일순 / 대표 이미지가 반드시 있는 정렬(O=제목순, Q=수정일순, R=생성일순)
        String extraParams = String.format("lDongRegnCd=%s&numOfRows=10000&arrange=Q", URLEncoder.encode(lDongRegnCd, StandardCharsets.UTF_8));
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("areaBasedList2", extraParams);
        System.out.printf("[03_공통].지역(areaBasedList2) : %s\n 1. api_url : %s\n 1.총 개수: %d", lDongRegnCd, url_api, result.size()); //!확인용
        return result;
    }//func end

    /* 예비확인용
    // [*전국*] 지역기반 관광정보(areaBasedList2) : 전국 관광데이터 (50,204개_250907기준)
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> areaBasedList2() throws IOException {
        String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "28"; // 법정동 시도 코드(인천:28)_전국데이터를 가져와야 해서 일단 빈값(*없어도 되지만 추후 활용)
        extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + "5000";  // 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광정보수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "Q"; // //정렬구분 (A=제목순, C=수정일순, D=생성일순)대표 이미지가 반드시 있는 정렬(O=제목순, Q=수정일순, R=생성일순)
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("areaBasedList2", extraParams);
        System.out.println("4.지역기반 관광정보(areaBasedList2)" + url_api + "\n4.총 개수: " + result.size() );
        return result;
    }//func end
    */

}// class end