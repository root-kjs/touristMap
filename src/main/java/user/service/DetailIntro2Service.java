package user.service;
/* 공공데이터 > 소개정보조회(공통상세)(https://apis.data.go.kr/B551011/KorService2/detailIntro2?) : 상세소개 쉬는날, 개장기간 등 내역을 조회하는 기능*/
import jakarta.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;
import user.util.CsvUtil;

import java.io.File;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DetailIntro2Service {

    // [강사2025-09-11] 서블릿 컨텍스트: 실제 경로(/data/...) 확인용
    private final ServletContext servletContext;

    private final TourApiClient tourApiClient;
    // !!!! 일단 자바스크립트단에서 개별로 불러오고, 추후 자바단에서 DB화 하는 방법을 강구해보기로 함. 250910(수)
    /* [1-1/★★스케쥴링★★] 소개정보조회(공통상세)(detailIntro2) */
    List< Map< String,Object> > detailIntroData = new ArrayList<>(); // 저장소
    @Scheduled( cron ="0 0 3 * * * ") // 오전 3시 스케쥴링 공공데이터 호출
    public List< Map< String,Object >> schedulDetailIntro2(){
        // [강사2025-09-11] CSV 파일 경로 설정 (배포 서버 경로 기준)
        String filePath = servletContext.getRealPath("/data/detailIntro2.csv");
        File csvFile = new File(filePath);

        try {
            if (csvFile.exists()) {
                // [강사2025-09-11] 1. CSV 파일이 있으면 → CSV에서 로드
                System.out.println("[CSV] detailIntroData 에서 가져오는 중++ ");
                detailIntroData = CsvUtil.read(filePath);
            } else {
                // [강사2025-09-11] 2. CSV 파일이 없으면 → API 호출 후 CSV 저장
                System.out.println("[API] detailIntroData 가져오는 중++ ");

                // [강사2025-09-11] API 호출 파라미터 설정
                String extraParams = URLEncoder.encode("contentId", "UTF-8") + "=126128"; // 콘텐츠 ID
                extraParams += "&" + URLEncoder.encode("contenttypeid", "UTF-8") + "=12";
                // 관광타입: 12=관광지, 14=문화시설, 15=축제/공연, 25=여행코스, 28=레포츠, 32=숙박, 38=쇼핑, 39=음식점

                // [강사2025-09-11] API 호출 + JSON 파싱 → detailIntroData에 저장
                detailIntroData = tourApiClient.fetchAndParse("detailIntro2", extraParams);

                // [강사2025-09-11] 재사용 위해 CSV로 저장
                CsvUtil.write(filePath, detailIntroData);
            }
        } catch (Exception e) {
            // [강사2025-09-11] 오류 발생 시 로그 출력
            System.out.println(" [스케쥴링 오류] 소개정보조회(공통상세) = " + e );
        }

        // [강사2025-09-11] 최종적으로 detailIntroData 반환
        return detailIntroData;
    }// func end

    /* [1-2/패치] 소개정보조회(공통상세)(detailIntro2) > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getDetailIntro2Data( ){
        return detailIntroData;
    }// func end



}// class end
