package user.controller;

import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import user.service.FileService;

@RestController // 스프링 컨테이너의 빈 등록
@RequestMapping("/file")
public class FileController {
    @Autowired // 스프링 컨테이너 에서 빈 꺼내오기
    private FileService fileService;
    // [1] 업로드
    // POST , http://localhost:8080/file/upload
    // [Headers] Content-Type : multipart/form-data
    // [Body] : form
    @PostMapping("/static/upload")
    public String fileUpload(MultipartFile multipartFile ){
        System.out.println("multipartFile = " + multipartFile);
        System.out.println("FileController.fileUpload");
        String result = fileService.fileUpload( multipartFile );
        return  result;
    }  // func end

    // [2] 다운로드
    @GetMapping("/download")
    // GET , http://localhost:8080/file/download?fileName=bf8aa6fe-b0c8-401f-a683-8b9df2ac1cda_logo.jpg (존재하는 파일명으로 테스트 )
    public void fileDownload( @RequestParam String fileName , HttpServletResponse response ){
        fileService.fileDownload( fileName , response );
    }

    // [3] 파일삭제
    @GetMapping("/delete")
    public boolean fileDelete( @RequestParam String fileName ){
        boolean result = fileService.fileDelete( fileName );
        return result;
    }

} // class end
