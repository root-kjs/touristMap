package user.api;
/* 공공API 데이터 > 스케쥴링 시간 외 실서버 배포시 > 서버 실행될때마다 공공데이터 재수집하는 메소드 */
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;
import user.service.AreaService;
import user.service.LclsSystmCodeService;
import user.service.LdongCodeService;
import user.service.LocationApiService;

@Component
public class ApiRun implements CommandLineRunner {

    @Autowired private AreaService areaService;
    @Autowired private LclsSystmCodeService lclsSystmCodeService;
    @Autowired private LdongCodeService ldongCodeService;
    @Autowired private LocationApiService locationApiService;

    @Override
    public void run(String... args) throws Exception {
        // 앱 기동 직후, 스케줄링 자동 1번 실행
        areaService.schedulLdongCode2depth1();
        areaService.schedulAreaList2LDong();
        lclsSystmCodeService.schedulLclsSystmCode2();
        ldongCodeService.schedulLdongCode2();
        locationApiService.schedulLocationList2();
    } //func end
} //class end