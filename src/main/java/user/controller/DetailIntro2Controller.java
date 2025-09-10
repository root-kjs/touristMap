package user.controller;
/* 공공데이터 > 소개정보조회(공통상세)(https://apis.data.go.kr/B551011/KorService2/detailIntro2?) : 상세소개 쉬는날, 개장기간 등 내역을 조회하는 기능*/
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.DetailIntro2Service;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api_tour")
@RequiredArgsConstructor
public class DetailIntro2Controller {

    private final DetailIntro2Service detailIntro2Service;
    // !!!! 일단 자바스크립트단에서 개별로 불러오고, 추후 자바단에서 DB화 하는 방법을 강구해보기로 함. 250910(수)
    @GetMapping("/intro")
    public List<Map<String,Object>> getDetailIntro2Data(){
        return detailIntro2Service.getDetailIntro2Data();
    }// func end

}//class end
