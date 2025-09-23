package user.service;
/* 공공데이터 > 위치기반 관광정보 조회(http://apis.data.go.kr/B551011/KorService2/locationBasedList2) */
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import static user.api.TourApiClient.url_api;

@Service
@RequiredArgsConstructor
public class LocationApiService {

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1/★★스케쥴링★★]  위치기반 관광정보(locationBasedList2) --> 중심좌표기준 반경 20km 이내 관광정보 출력 */
    List<Map<String, Object>> locationList2Data = new ArrayList<>();
    //@Scheduled(cron = "0 09 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> schedulLocationList2(  ) {
        try {
            String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "100";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
            extraParams += "&" + URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "28";
            extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "S"; // //arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
            // 더조은 학원 부평역 기준(사용자) : 위도 37.489457, 경도 126.724494 --> 추후 접속한 사용자 IP 좌표 기준으로 변경 예정_250906(토)
            extraParams += "&" + URLEncoder.encode("mapX", "UTF-8") + "=" + "126.724494";  // *필수입력 파라미터(GPS X좌표(WGS84 경도좌표))
            extraParams += "&" + URLEncoder.encode("mapY", "UTF-8") + "=" + "37.489457"; // *필수입력 파라미터(GPS Y좌표(WGS84 위도좌표))
            extraParams += "&" + URLEncoder.encode("radius", "UTF-8") + "=" + "20000m"; // *필수입력 파라미터: 거리반경(단위:m) , Max값 20000m=20Km
            locationList2Data = tourApiClient.fetchAndParse("locationBasedList2", extraParams);
            //System.out.println( "3.위치기반 관광정보(locationBasedList2)" + url_api + "\n3.총 개수: " + locationList2Data.size());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return locationList2Data;
    }//func end

    /* [1-2/패치] 위치기반 관광정보 5km 이내만 반환 */
    // [01-2] 강사 : 위치기반 추가
    public List<Map<String, Object>> getLdongCode2Data(String lDongRegnCd, double centerLat, double centerLng) {
        try {
            String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "100";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
            extraParams += "&" + URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + lDongRegnCd;
            extraParams += "&" + URLEncoder.encode("arrange", "UTF-8") + "=" + "S"; // //arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
            // 더조은 학원 부평역 기준(사용자) : 위도 37.489457, 경도 126.724494 --> 추후 접속한 사용자 IP 좌표 기준으로 변경 예정_250906(토)
            extraParams += "&" + URLEncoder.encode("mapX", "UTF-8") + "=" + centerLng;  // *필수입력 파라미터(GPS X좌표(WGS84 경도좌표))
            extraParams += "&" + URLEncoder.encode("mapY", "UTF-8") + "=" + centerLat; // *필수입력 파라미터(GPS Y좌표(WGS84 위도좌표))
            extraParams += "&" + URLEncoder.encode("radius", "UTF-8") + "=" + "5000"; // *필수입력 파라미터: 거리반경(단위:m) , Max값 20000m=20Km
            locationList2Data = tourApiClient.fetchAndParse("locationBasedList2", extraParams);
            //System.out.println( "3.위치기반 관광정보(locationBasedList2)" + url_api + "\n3.총 개수: " + locationList2Data.size());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return locationList2Data;
    }

}// class end