package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.TourApiService;
import java.io.IOException;
import java.util.List;
import java.util.Map;
// 공공데이터 API 연동(한국관광공사_국문 관광정보 서비스_GW  https://apis.data.go.kr/B551011/KorService2/
@RequestMapping("/api_tour")

@RestController
public class TourApiController {

    @Autowired TourApiService tourApiService;

    /* [01] 법정동_지역코드(ldongCode2) */
    @GetMapping("/ldong")
    public List<Map<String, Object>> ldongCode2() throws IOException {
        List<Map<String, Object>> result = tourApiService.ldongCode2();
        return result;
    }// func end

    /* [02] 분류코드_카테고리(lclsSystmCode2) */
    @GetMapping("/lcls")
    public List<Map<String, Object>> lclsSystmCode2() throws IOException {
        List<Map<String, Object>> result = tourApiService.lclsSystmCode2();
        return result;
    }// func end

    /* [03] 위치기반_관광정보_조회(locationBasedList2) */
    @GetMapping("/location")
    public List<Map<String, Object>> locationBasedList2() throws IOException {
        List<Map<String, Object>> result = tourApiService.locationBasedList2();
        return result;
    }// func end

    /* [04] 지역기반_관광정보_조회(areaBasedList2) */
    @GetMapping("/area")
    public List<Map<String, Object>> areaBasedList2() throws IOException {
        List<Map<String, Object>> result = tourApiService.areaBasedList2();
        return result;
    }// func end


}// class end
