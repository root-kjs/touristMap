package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.TourApiService;
import java.io.IOException;

// 공공데이터 API 연동(한국관광공사_국문 관광정보 서비스_GW)https://apis.data.go.kr/B551011/KorService2/lclsSystmCode2?
@RequestMapping("/api")
@RestController
public class TourApiController {

    @Autowired TourApiService tourApiService;

    @GetMapping("/ldong")
    public String ldongCode2() throws IOException {
        String result = tourApiService.ldongCode2();
        return result;
    }// func end

    @GetMapping("/lcls")
    public String lclsSystmCode2() throws IOException {
        String result = tourApiService.lclsSystmCode2();
        return result;
    }// func end

}// class end
