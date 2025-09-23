package user.service;
/* 공공데이터 > 분류체계 코드조회(http://apis.data.go.kr/B551011/KorService2/lclsSystmCode2) */
import jakarta.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;
import user.util.CsvUtil;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import static user.api.TourApiClient.url_api;

@Service
@RequiredArgsConstructor
public class LclsSystmCodeService {

    // [강사2025-09-11] 서블릿 컨텍스트: 실제 서버 경로(/data/...) 확인용
    private final ServletContext servletContext;

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1/★★스케쥴링★★] 분류체계 코드조회(lclsSystmCode2) */
    List<Map<String, Object>> lclsSystmData = new ArrayList<>();
    @Scheduled(cron = "0 06 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> schedulLclsSystmCode2()  {
        // [강사2025-09-11] CSV 저장 경로 (배포 서버 실제 경로 기준)
        String filePath = servletContext.getRealPath("/data/lclsSystmCode2.csv");
        File csvFile = new File(filePath);

        try {
            if (csvFile.exists()) {
                // [강사2025-09-11] 1. CSV 파일 존재 시 → CSV에서 데이터 로딩
                lclsSystmData = CsvUtil.read(filePath);
                System.out.println("[CSV 로딩] 분류체계 목록 - CSV에서 로드 완료 (" + lclsSystmData.size() + "건)");
            } else {
                // [강사2025-09-11] 2. CSV 없음 → API 호출로 신규 데이터 가져오기
                String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=500";
                // 한 페이지 최대 결과 수(50,204건 기준으로 최대치 설정, 250906 기준)

                extraParams += "&" + URLEncoder.encode("lclsSystmListYn", "UTF-8") + "=Y";
                // 분류체계 목록조회 여부 (N=코드조회, Y=전체목록조회)

                // [강사2025-09-11] API 호출 + JSON 파싱 → 데이터 획득
                lclsSystmData = tourApiClient.fetchAndParse("lclsSystmCode2", extraParams);

                // [강사2025-09-11] 데이터 CSV로 저장 → 재사용 가능
                CsvUtil.write(filePath, lclsSystmData);
                System.out.println("[API 호출] 분류체계 목록 - API 호출 및 CSV 저장 완료 (" + lclsSystmData.size() + "건)");
            }
        } catch (Exception e) {
            // [강사2025-09-11] 오류 처리: 로그 출력 + 런타임 예외로 던지기
            System.out.println("[오류] 분류체계 코드 스케줄링 실패 = " + e.getMessage());
            throw new RuntimeException(e);
        }

        // [강사2025-09-11] 최종 데이터 반환
        return lclsSystmData;
    }//func end

    /* [1-2/패치] 분류체계 코드조회(lclsSystmCode2) > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getLclsSystmCode2Data( ){
        return lclsSystmData;
    }// func end


}// class end