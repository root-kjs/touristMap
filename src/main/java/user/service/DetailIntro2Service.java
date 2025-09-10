package user.service;
/* 공공데이터 > 소개정보조회(공통상세)(https://apis.data.go.kr/B551011/KorService2/detailIntro2?) : 상세소개 쉬는날, 개장기간 등 내역을 조회하는 기능*/
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;

import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Service
@RequiredArgsConstructor
public class DetailIntro2Service {

    private final TourApiClient tourApiClient;
    // !!!! 일단 자바스크립트단에서 개별로 불러오고, 추후 자바단에서 DB화 하는 방법을 강구해보기로 함. 250910(수)
    /* [1-1/★★스케쥴링★★] 소개정보조회(공통상세)(detailIntro2) */
    List< Map< String,Object> > detailIntroData = new ArrayList<>(); // 저장소
    @Scheduled( cron ="0 0 3 * * * ") // 오전 3시 스케쥴링 공공데이터 호출
    public List< Map< String,Object >> schedulDetailIntro2(){
        try {
            String extraParams = URLEncoder.encode( "contentId","UTF-8") + "126128"; // 톤텐츠 아이디
            extraParams += "&" + URLEncoder.encode("contenttypeid", "UTF-8") + "=" + "12"; // 관광타입(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점) ID
            detailIntroData = tourApiClient.fetchAndParse("detailIntro2", extraParams);
        }catch ( Exception e ){
            //throw new RuntimeException(e);
            System.out.println(" [스케쥴링] 소개정보조회(공통상세) = " + e );
        }
        return detailIntroData;
    }// func end

    /* [1-2/패치] 소개정보조회(공통상세)(detailIntro2) > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getDetailIntro2Data( ){
        return detailIntroData;
    }// func end



}// class end
