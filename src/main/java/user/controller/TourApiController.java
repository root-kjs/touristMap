package user.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import user.service.TourApiService;
import java.io.IOException;

@RequestMapping("/api")
@RestController
public class TourApiController {

    @Autowired TourApiService tourApiService;
    @GetMapping
    public void lclsSystm() throws IOException {
        tourApiService.lclsSystm();
    }// func end

}// class end
