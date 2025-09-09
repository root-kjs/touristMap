package user.service;
/* 공공데이터 > 법정동 코드조회(http://apis.data.go.kr/B551011/KorService2/ldongCode2) */
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
public class LdongCodeService {

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1/★★스케쥴링★★] 법정동 코드조회(ldongCode2) */
    List<Map<String, Object>> ldongCode2Data = new ArrayList<>();
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> schedulLdongCode2()  {
        try {
            String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=" + "";  // 법정동 시도 코드(인천: 28)_lDongRegnCd 해당되는 법정동 시군구코드 조회 , 입력이 없을시 전체 시도목록 호출
            extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=" + "500";// 한 페이지 결과 수 : 일단 최대값 설정함(250906기준 전국관광 정보 데이터수 : 50,204개)
            extraParams += "&" + URLEncoder.encode("lDongListYn", "UTF-8") + "=" + "Y"; // 법정동 목록조회 여부(N:코드조회 , Y:전체목록조회)
            ldongCode2Data = tourApiClient.fetchAndParse("ldongCode2", extraParams);
            //System.out.println( "1.법정동 코드조회(ldongCode2)" + url_api + "\n1.총 개수: " + ldongCode2Data.size());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        return ldongCode2Data;
    }//func end

    /* [1-2/패치] 법정동 코드조회(ldongCode2) 전체 > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getLdongCode2Data(){
        return ldongCode2Data;
    }// func end


}// class end