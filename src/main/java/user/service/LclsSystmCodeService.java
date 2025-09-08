package user.service;
/* 공공데이터 > 분류체계 코드조회(http://apis.data.go.kr/B551011/KorService2/lclsSystmCode2) */
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
public class LclsSystmCodeService {

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1/★★스케쥴링★★] 분류체계 코드조회(lclsSystmCode2) */
    List<Map<String, Object>> lclsSystmData = new ArrayList<>();
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> schedulLclsSystmCode2() throws IOException {
        String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
        extraParams += "&" + URLEncoder.encode("lclsSystmListYn", "UTF-8") + "=" + "Y"; // 분류체계 목록조회 여부(N:코드조회 , Y:전체목록조회) // lclsSystm1(분류체계 1Depth 코드)
        lclsSystmData = tourApiClient.fetchAndParse("lclsSystmCode2", extraParams);
        System.out.println("2.분류체계 코드조회(lclsSystmCode2) " + url_api + "\n2.총 개수: " + lclsSystmData.size() );
        return lclsSystmData;
    }//func end

    /* [1-2/패치] 분류체계 코드조회(lclsSystmCode2) > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getLclsSystmCode2Data( ){
        List<Map<String, Object>> result = lclsSystmData;
        return result;
    }// func end


}// class end