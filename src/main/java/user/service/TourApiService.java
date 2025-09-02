package user.service;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

@Service
public class TourApiService {

    /*[01] 15.분류체계 코드조회(lclsSystm) : 분류체계코드목록을 1Deth, 2Deth, 3Deth 코드별 조회하는 기능 */
    @Scheduled( cron = "0 0 9 * * *" ) //  매일 오전 9시가 될때마다 api 가져오기
    public void lclsSystm() throws IOException {
    // 1) 가져올 API 경로 파라미터 설정
        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/B551011/KorService2/lclsSystmCode2"); /*URL*/
        urlBuilder.append("?" + URLEncoder.encode("numOfRows","UTF-8") +"="+ "300");    // 응답 데이터(콘텐츠) 수량
        urlBuilder.append("&" + URLEncoder.encode("lclsSystm1","UTF-8") +"="+ "");      // 대분류코드(예시: AC), 중분류코드(lclsSystm1필수)LclsSystm3 소분류코드(lclsSystm1,lclsSystm2필수)
        urlBuilder.append("&" + URLEncoder.encode("lclsSystmListYn","UTF-8")+"="+"Y");  // 분류체계 목록조회 여부(N: 코드조회, Y: 전체목록조회)
         /* --------------------------- 아래 공통 필수 파라미터 ------------------------------ */
        urlBuilder.append("&" + URLEncoder.encode("serviceKey","UTF-8") + "=DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D"); /* Service Key */
        urlBuilder.append("&" + URLEncoder.encode("MobileOS","UTF-8") +"="+"APP");      // OS 구분: IOS(아이폰), AND(안드로이드),WEB(웹), ETC(기타)
        urlBuilder.append("&" + URLEncoder.encode("MobileApp","UTF-8")+"="+"ETC");      // 서비스명=어플명
        urlBuilder.append("&" + URLEncoder.encode("_type","UTF-8")+"="+"json");         // REST 방식의 URL 호출 시 Json값 추가 (디폴트 응답 메세지 형식은 XML)
        URL url = new URL(urlBuilder.toString());  // URL 생성 및 파라미터 대입
        //System.out.println(url);
    // 2) 조합한 URL주소로 HTTP 통신 접속(GET) 요청
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");
        System.out.println("Response code(!): " + conn.getResponseCode());                         // 서버가 어떻게 응답상태 코드(숫자) 확인!, 200 '성공', 404 '페이지 없음', 500 '서버 내부 오류
    // 3) 서버가 보낸 응답 데이터를 읽기
        // **입력 스트림(Input Stream)**BufferedReader는 Java에서 텍스트 입력을 효율적으로 처리하기 위한 클래스(패키지: java.io.BufferedReader)
        // 문자 기반 입력 스트림(Reader)을 버퍼링(buffering) 해서 읽기 속도를 향상시킴, 보통 파일, 콘솔 입력, 네트워크 스트림에서 많이 사용됨 **라인 단위 입력(readLine())**이 가능 → 텍스트 처리에 자주 활용
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {                    // 서버의 응답이 성공/실패했는지에 따라 데이터를 읽어오는 통로를 다르게 설정하는 코드
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));              // 응답성공시 데이터가 들어오는 통로 개시
        } else { 
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream()));              // 응답실패!
        }
    // 4) 버퍼 리더(rd)를 통해 한 줄씩 데이터를 읽어온 데이터 스트링 빌더(sb)에 계속 추가
        // StringBuilder(가변 길이 문자열 저장소) : 동일한 객체 안에서 문자열을 변경 가능 → 성능 향상(특히 반복적인 문자열 처리에 유리).멀티스레드 환경에서 안전하게 쓰려면 StringBuffer 사용.동기화(synchronized) 지원 X → 단일 스레드 환경에서 빠름.
        // 기본 String은 불변(immutable)이라, 값을 바꿀 때마다 새로운 객체가 생성되지만, StringBuilder는 기존 버퍼를 수정하기 때문에 성능상 효율적
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println( "결과 : " + sb.toString() );
    }// func end
}// class end