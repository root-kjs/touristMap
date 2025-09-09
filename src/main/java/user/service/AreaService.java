package user.service;
/* 공공데이터 > 지역기반 관광정보조회(http://apis.data.go.kr/B551011/KorService2/areaBasedList2) */
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import user.api.TourApiClient;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import static user.api.TourApiClient.url_api;
@Service
@RequiredArgsConstructor

public class AreaService {

    private final TourApiClient tourApiClient; //공공데이터 API통신(GET) + JSON파싱 로직을 처리하는 범용함수

    /* [1-1★★스케쥴링★★] 1차 법정동 코드(ldongCode2) > 도/광역시(17개:서울/경기/인천 등) 데이터 호출 메소드 */
    List<Map<String, Object>> ldongCode2Data = new ArrayList<>();
    @Scheduled(cron = "0 0 3 * * *")
    public List<Map<String, Object>> schedulLdongCode2depth1() {
        try {
            String extraParams = URLEncoder.encode("numOfRows", "UTF-8") + "=" + "17";
            ldongCode2Data = tourApiClient.fetchAndParse("ldongCode2", extraParams);
            //System.out.printf("1차 법정동 : %s\n 총 개수: %d", url_api, LdongCode2Data1.size()); // !확인용
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
            return ldongCode2Data;
    }//func end

    /* [1-2/패치] 1차 법정동 코드(ldongCode2) > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getLdongCode2( ){
        return ldongCode2Data;
    }// func end

    /* [2-1/수집] 지역기반 관광정보를 데이터 호출 메소드( 법정동코드(1차지역_17개) 파라미터 ) */
    /// **** 매개변수가 있는 메소드는 스케쥴링 불가(의존하는 데이터가 있기 때문에) **** */
    public List<Map<String, Object>> getAreaList2( String lDongRegnCd ) throws IOException {
        // arrange(정렬구분): A=제목순, C=수정일순, D=생성일순 / 대표 이미지가 반드시 있는 정렬(O=제목순, Q=수정일순, R=생성일순) // 전국 data: 50,204개(250906)
        String extraParams = String.format("lDongRegnCd="+lDongRegnCd+"&numOfRows=10000&arrange=Q", URLEncoder.encode(lDongRegnCd, StandardCharsets.UTF_8));
        List<Map<String, Object>> areaLDongRegnCd = tourApiClient.fetchAndParse("areaBasedList2", extraParams);
        //System.out.printf("3.지역기반(areaBasedList2) : %s\n 1. api_url : %s\n 3.총 개수: %d", lDongRegnCd, url_api, areaLDongRegnCd.size()); //!확인용
        return areaLDongRegnCd;
    }//func end

    /* [2-2★★스케쥴링★★] 법정동 지역기반 관광정보 데이터 매칭 메소드 */
    // 카카오 지도 좌측메뉴(지역명) 클릭시, 활성화된 좌측메뉴의(.active) 법정동 코드를 전달해주는 것과는 별개로
    // 위의 01+02 지역기반 관광정보 매칭/통합 데이터라 아래 메소드를 스케쥴링 후, 리스트맵으로 별도 자료 저장하여 저장된 리스트맵 자바객체를 패치로 전달하여 사용자에게 서비스함.
    /* 지역기반 관광정보 스케쥴링 저장소 */
    List<Map<String, Object>> areaListData = new ArrayList<>();
    @Scheduled(cron = "0 0 3 * * *")
    public List<Map<String, Object>> schedulAreaList2LDong( ) {
        try {
            List<Map<String, Object>> regionList = getLdongCode2();
            String lDongRegnCd = "";
            for (Map<String, Object> region : regionList) {
                lDongRegnCd = (String) region.get("code");
                List<Map<String, Object>> areaList = getAreaList2(lDongRegnCd);
                areaListData.addAll(areaList);
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
        //System.out.printf("3.지역기반 스케쥴링(areaBasedList2) : %s\n 1. api_url : %s\n 3.총 개수: %d", areaListData, url_api, areaListData.size()); //!확인용
        return areaListData;
    }//func end

    /* [1-2/패치] 법정동 지역기반 관광정보 데이터 > 스케쥴링으로 저장된 자바 객체 데이터 */
    public List<Map<String, Object>> getAreaListData( String lDongRegnCd ){
        // 매개변수로 넘어온 lDongRegnCd를 활용하여 데이터 필터링
        List<Map<String, Object>> filteredList = new ArrayList<>();
        for (Map<String, Object> item : areaListData) {
            if (lDongRegnCd.equals(item.get("lDongRegnCd"))) { // 매개변수 lDongRegnCd와 맵의 값이 같다면(법정동코드 같은 아이만)
                filteredList.add(item);
            }
        }
        return filteredList;
    }//func end

    /*
    // [*전국*] 지역기반 관광정보(areaBasedList2) : 전국 관광데이터 (50,204개_250907기준) : 예비확인용
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
    /*
    // @Scheduled(cron = "0 0 3 * * *")  // [02] 부산광역시 26
    public void fetchAllAreaNogada() throws IOException {
        System.out.println("[시작] 주요도시 관광정보 조회");
        try{ getAreaList2Resion1("11"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //서울특별시
        try{ getAreaList2Resion1("26"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //부산광역시
        try{ getAreaList2Resion1("27"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //대구광역시
        try{ getAreaList2Resion1("28"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //인천광역시
        try{ getAreaList2Resion1("29"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //광주광역시
        try{ getAreaList2Resion1("30"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //대전광역시
        try{ getAreaList2Resion1("31"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //울산광역시
        try{ getAreaList2Resion1("41"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //경기도
        try{ getAreaList2Resion1("43"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //충청북도
        try{ getAreaList2Resion1("44"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //충청남도
        try{ getAreaList2Resion1("46"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //전라남도
        try{ getAreaList2Resion1("47"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //경상북도
        try{ getAreaList2Resion1("48"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //경상남도
        try{ getAreaList2Resion1("50"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //제주특별자치도
        try{ getAreaList2Resion1("51"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //강원특별자치도
        try{ getAreaList2Resion1("52"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //전북특별자치도
        try{ getAreaList2Resion1("17"); } catch(IOException e){ System.out.println("오류 발생:" + e); } //세종특별자치시
        System.out.println("[종료] 주요도시 관광정보 조회");
    }// func end
    */

}// class end