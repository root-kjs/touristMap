package user;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling // 스케쥴링(TourAPI)
public class AppStart extends SpringBootServletInitializer {



    public static void main(String[] args) {
        SpringApplication.run( AppStart.class );
    }

    // WAR 파일로 배포할 때 외부 Tomcat이 사용할 설정 : 외부 서버설정을 내가 작업하는 스프링설정으로 변경
    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(AppStart.class); // 메인 애플리케이션 클래스 지정
    }

}//class end