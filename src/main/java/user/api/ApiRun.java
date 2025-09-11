package user.api;
/* 공공API 데이터 > 스케쥴링 시간 외 실서버 배포시 > 서버 실행될때마다 공공데이터 재수집하는 메소드 */
import lombok.RequiredArgsConstructor;
import lombok.SneakyThrows;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.event.EventListener;
import org.springframework.scheduling.TaskScheduler;
import org.springframework.scheduling.concurrent.ThreadPoolTaskScheduler;
import org.springframework.stereotype.Component;
import user.service.AreaService;
import user.service.LclsSystmCodeService;
import user.service.LdongCodeService;
import user.service.LocationApiService;

import java.time.Instant;
import java.util.Date;

@Component
@RequiredArgsConstructor
public class ApiRun {

    private final TaskScheduler scheduler;
    private final AreaService area;
    private final LclsSystmCodeService lcls;
    private final LdongCodeService ldong;
    private final LocationApiService loc;

    @EventListener(ApplicationReadyEvent.class)
    public void runAfterReady() {
        schedule(0, area::schedulLdongCode2depth1);
        schedule(3, area::schedulAreaList2LDong);
        schedule(20, lcls::schedulLclsSystmCode2);
        schedule(25, ldong::schedulLdongCode2);
        // schedule(25, loc::schedulLocationList2); // [강사2025-09-11]스케줄링을 사용하지 않는다.
    }

    private void schedule(int delaySec, Runnable task) {
        try {
            scheduler.schedule(task, Date.from(Instant.now().plusSeconds(delaySec)));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}

@Configuration
class TaskCfg {
    @Bean
    TaskScheduler taskScheduler() {
        var s = new ThreadPoolTaskScheduler();
        s.setPoolSize(1);
        s.setThreadNamePrefix("startup-");
        return s;
    }
}