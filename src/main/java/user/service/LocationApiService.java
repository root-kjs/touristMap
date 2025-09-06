package user.service;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.List;
import java.util.Map;
import static user.api.TourApiClient.url_api;

@Service
public class LocationApiService {

    @Autowired
    private TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수
    /*
    private final TourApiClient tourApiClient;
    public TourApiService(TourApiClient tourApiClient) {
        this.tourApiClient = tourApiClient;  나중에 김현수 선생님께 질문 할 것!
    }*/

    /* [01] 법정동 코드조회(ldongCode2) */
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> getLdongCode2() throws IOException {
        String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "";  // 법정동 시도 코드(인천: 28)_lDongRegnCd 해당되는 법정동 시군구코드 조회 , 입력이 없을시 전체 시도목록 호출
        extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lDongListYn", "UTF-8") + "=" + "Y"; // 법정동 목록조회 여부(N:코드조회 , Y:전체목록조회)
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("ldongCode2", extraParams);
        System.out.println( "1.법정동 코드조회(ldongCode2)" + url_api + "\n1.총 개수: " + result.size());
        return result;
    }//func end

    /* [02] 분류체계 코드조회(lclsSystmCode2) */
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> getLclsSystmCode2() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lclsSystmListYn", "UTF-8") + "=" + "Y"; // 분류체계 목록조회 여부(N:코드조회 , Y:전체목록조회) // lclsSystm1(분류체계 1Depth 코드)
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("lclsSystmCode2", extraParams);
        System.out.println("2.분류체계 코드조회(lclsSystmCode2) " + url_api + "\n2.총 개수: " + result.size() );
        return result;
    }//func end

    /* [03] 위치기반 관광정보(locationBasedList2) --> 중심좌표기준 반경 20km 이내 관광정보 출력 */
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> getLocationBasedList2() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "100";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "28";
        extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "S"; // //arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
        // 더조은 학원 부평역 기준(사용자) : 위도 37.489457, 경도 126.724494 --> 추후 접속한 사용자 IP 좌표 기준으로 변경 예정_250906(토)
        extraParams += "&" + URLEncoder.encode("mapX", "UTF-8") + "=" + "126.724494";  // *필수입력 파라미터(GPS X좌표(WGS84 경도좌표))
        extraParams += "&" + URLEncoder.encode("mapY", "UTF-8") + "=" + "37.489457"; // *필수입력 파라미터(GPS Y좌표(WGS84 위도좌표))
        extraParams += "&" + URLEncoder.encode("radius", "UTF-8") + "=" + "20000"; // *필수입력 파라미터: 거리반경(단위:m) , Max값 20000m=20Km
        List<Map<String, Object>> result = tourApiClient.fetchAndParse("locationBasedList2", extraParams);
        System.out.println( "3.위치기반 관광정보(locationBasedList2)" + url_api + "\n3.총 개수: " + result.size());
        return result;
    }//func end

    /* [04] 지역기반 관광정보(areaBasedList2) : 전국(50,204개_250907기준)
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