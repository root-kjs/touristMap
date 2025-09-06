package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import user.service.AreaApiService;
import user.service.LocationApiService;

import java.io.IOException;
import java.util.List;
import java.util.Map;

@RequestMapping("/api")
@RestController

public class AreaApiController {

    @Autowired
    AreaApiService areaApiService;

    /* [01] ldongCode2Resion1 */
    @GetMapping("/city")
    public List<Map<String, Object>> getLdongCode2Resion1( ) throws IOException {
        List<Map<String, Object>> result = areaApiService.getLdongCode2Resion1( );
        return result;
    }// func end

    /* [02] scheduleMajorCityAreaLists */
    @GetMapping("/area") // @RequestParam : ?lDongRegnCd=11 (서울)/ ?lDongRegnCd=28 (인천)
    public List<Map<String, Object>> getAreaList2Resion( @RequestParam String lDongRegnCd) throws IOException {
        List<Map<String, Object>> result = areaApiService.getAreaList2Resion( lDongRegnCd );
        return result;
    }// func end

}// class end
