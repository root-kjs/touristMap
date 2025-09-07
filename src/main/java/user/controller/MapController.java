package user.controller;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RequestMapping("/map")
@RestController
public class MapController {

    @Value("${kakao.map.appkey}")
    private String kakaoMapAppKey;

    @GetMapping("/kakao")
    public Map<String, Object> showMapPage(){
        Map<String, Object> result = new HashMap<>();
        result.put("kakaoKey", kakaoMapAppKey);
        return result;
    }//func end

}// class end
