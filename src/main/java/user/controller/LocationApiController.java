package user.controller;
/* 위치기반 관광정보 조회(http://apis.data.go.kr/B551011/KorService2/locationBasedList2) */
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.LocationApiService;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@RequestMapping("/api_tour")
@RestController
@RequiredArgsConstructor
public class LocationApiController {

    private final LocationApiService locationApiService;

    /* [01] 위치기반_관광정보_조회(getLocationBasedList2) 데이터 호출*/
    @GetMapping("/location")
    public List<Map<String, Object>> getLocationBasedList2() throws IOException {
        List<Map<String, Object>> result = locationApiService.getLdongCode2Data();
        return result;
    }// func end

}// class end
