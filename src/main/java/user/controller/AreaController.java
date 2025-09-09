package user.controller;
/* 지역기반 관광정보조회(http://apis.data.go.kr/B551011/KorService2/areaBasedList2) */
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import user.service.AreaService;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@RequestMapping("/api_tour")
@RestController
@RequiredArgsConstructor
public class AreaController {

    private final AreaService areaService;

    /* [01] 법정동 코드(17개지역) 데이터 호출 */
    @GetMapping("/ldong")
    public List<Map<String, Object>> getLdongCode2Data() throws IOException {
        return areaService.getLdongCode2(); // 1. 실서버 패치용
    }// func end

    /* [02] 지역기반 관광정보 데이터 호출(법정동 코드(17개지역))  */
    @GetMapping("/area") // @RequestParam: lDongRegnCd=11 (서울), lDongRegnCd=28 (인천)
    public List<Map<String, Object>> getAreaListData( @RequestParam String lDongRegnCd ) throws IOException {
        return areaService.getAreaListData( lDongRegnCd ); // 1. 실서버 패치용
    }// func end


}// class end
