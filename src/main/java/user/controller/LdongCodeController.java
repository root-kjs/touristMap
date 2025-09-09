package user.controller;
/* 법정동 코드조회(http://apis.data.go.kr/B551011/KorService2/ldongCode2) */
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.LdongCodeService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api_tour")
@RequiredArgsConstructor
public class LdongCodeController {

    private final LdongCodeService ldongCodeService;

    /* [01] 법정동/지역코드(getLdongCode2) 데이터 호출 */
    @GetMapping("/ldongCd")
    public List<Map<String, Object>> getLdongCode2() throws IOException {
        return ldongCodeService.getLdongCode2Data(); // 1. 실서버 패치용
    }// func end
}//class end
