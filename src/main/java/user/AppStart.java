package user;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling // 스케쥴링(TourAPI)
public class AppStart {
    public static void main(String[] args) {
        SpringApplication.run( AppStart.class);
    }
}