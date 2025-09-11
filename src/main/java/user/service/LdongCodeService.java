package user.service;
/* 공공데이터 > 법정동 코드조회(http://apis.data.go.kr/B551011/KorService2/ldongCode2) */
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
public class LdongCodeService {

    // [강사2025-09-11] 서블릿 컨텍스트: 서버 실제 경로(/data/...) 확인용
    private final ServletContext servletContext;

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1/★★스케쥴링★★] 법정동 코드조회(ldongCode2) */
    List<Map<String, Object>> ldongCode2Data = new ArrayList<>();
    @Scheduled(cron = "0 0 3 * * *") // 매일 오전 3시가 될때마다 api 가져오기
    public List<Map<String, Object>> schedulLdongCode2()  {
        // [강사2025-09-11] CSV 파일 경로 지정 (전체 법정동 코드 저장용)
        String filePath = servletContext.getRealPath("/data/ldongCode2_all.csv");
        File csvFile = new File(filePath);

        try {
            if (csvFile.exists()) {
                // [강사2025-09-11] 1. CSV 존재 시 → CSV 파일에서 데이터 로딩
                ldongCode2Data = CsvUtil.read(filePath);
                System.out.println("[CSV 로딩] 전체 법정동 목록 - CSV에서 로드 완료 (" + ldongCode2Data.size() + "건)");
            } else {
                // [강사2025-09-11] 2. CSV 미존재 시 → API 호출로 전체 목록 조회

                // [강사2025-09-11] API 요청 파라미터 설정
                String extraParams = URLEncoder.encode("lDongRegnCd", "UTF-8") + "=";
                // 법정동 시도 코드 (예: 인천=28). 값 없으면 전국 전체 호출

                extraParams += "&" + URLEncoder.encode("numOfRows", "UTF-8") + "=500";
                // 페이지당 최대 500건 (250906 기준 전국 50,204건 → 여러 페이지 필요)

                extraParams += "&" + URLEncoder.encode("lDongListYn", "UTF-8") + "=Y";
                // 법정동 목록조회 여부 (N=코드조회, Y=전체목록조회)

                // [강사2025-09-11] API 호출 + JSON 파싱
                ldongCode2Data = tourApiClient.fetchAndParse("ldongCode2", extraParams);

                // [강사2025-09-11] CSV 저장 (재사용을 위해)
                CsvUtil.write(filePath, ldongCode2Data);
                System.out.println("[API 호출] 전체 법정동 목록 - API 호출 및 CSV 저장 완료 (" + ldongCode2Data.size() + "건)");
            }
        } catch (Exception e) {
            // [강사2025-09-11] 오류 발생 시 로그 출력 + 런타임 예외 전환
            System.out.println("[오류] 전체 법정동 목록 조회 실패 = " + e.getMessage());
            throw new RuntimeException(e);
        }

        // [강사2025-09-11] 최종적으로 전체 법정동 목록 반환
        return ldongCode2Data;
    }//func end

    /* [1-2/패치] 법정동 코드조회(ldongCode2) 전체 > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getLdongCode2Data(){
        return ldongCode2Data;
    }// func end


}// class end