package user.controller;
/* 분류체계 코드조회(http://apis.data.go.kr/B551011/KorService2/lclsSystmCode2) */
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.LclsSystmCodeService;
import user.service.LdongCodeService;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api_tour")
@RequiredArgsConstructor
public class lclsSystmCodeController {

    private final LclsSystmCodeService lclsSystmCodeService;

    /* [01] 분류체계코드/카테고리(getLclsSystmCode2) 데이터 호출 */
    @GetMapping("/lcls")
    public List<Map<String, Object>> getLclsSystmCode2() throws IOException {
        List<Map<String, Object>> result = lclsSystmCodeService.getLclsSystmCode2();
        return result;
    }// func end

}//class end
