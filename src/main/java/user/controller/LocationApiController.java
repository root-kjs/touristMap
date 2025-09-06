package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.LocationApiService;
import java.io.IOException;
import java.util.List;
import java.util.Map;

// 공공데이터 API 연동 (*한국관광공사_국문 관광정보 서비스_GW  https://apis.data.go.kr/B551011/KorService2/)

@RequestMapping("/api")
@RestController
public class LocationApiController {

    @Autowired
    LocationApiService locationApiService;

    /* [01] 법정동_지역코드(getLdongCode2) */
    @GetMapping("/ldong")
    public List<Map<String, Object>> getLdongCode2() throws IOException {
        List<Map<String, Object>> result = locationApiService.getLdongCode2();
        return result;
    }// func end

    /* [02] 분류코드_카테고리(getLclsSystmCode2) */
    @GetMapping("/lcls")
    public List<Map<String, Object>> getLclsSystmCode2() throws IOException {
        List<Map<String, Object>> result = locationApiService.getLclsSystmCode2();
        return result;
    }// func end

    /* [03] 위치기반_관광정보_조회(getLocationBasedList2) */
    @GetMapping("/location")
    public List<Map<String, Object>> getLocationBasedList2() throws IOException {
        List<Map<String, Object>> result = locationApiService.getLocationBasedList2();
        return result;
    }// func end

}// class end
