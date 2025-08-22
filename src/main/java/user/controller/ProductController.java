package user.controller;

import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import user.model.dto.ProductDto;
import user.service.FileService;
import user.service.ProductService;

import java.util.List;

@RestController
@RequestMapping("/product")
public class ProductController {

    @Autowired private ProductService productService;
    @Autowired private FileService fileService; // 업로드 할때 필요한 서비스

    //[1] 제품 등록
    @PostMapping("/create")
    public int createProduct( @ModelAttribute ProductDto productDto , HttpSession session ){
        // 1. 로그인상태 확인후 , 비로그인이면 0 반환
        if( session.getAttribute("loginMno") == null ) return 0;
        // 2. 제품정보를 DB 처리 한다.
        int loginMno = (int)session.getAttribute("loginMno");
        productDto.setMno( loginMno ); // 현재 로그인된 회원번호를 제품등록 dto에 포함
        int result = productService.createProduct( productDto );
        // 3. 만약에 업로드 파일이 존재하면 업로드서비스 호출하여 업로드 처리
            // 3-1 : 만약에 제품등록 했으면서 첨부파일이 비어있지 않고 첨부파일 목록에서 첫번째 첨부파일이 비어있지 않으면
        if( result > 0 && !productDto.getUploads().isEmpty() && !productDto.getUploads().get(0).isEmpty() ){
            // 3-2 : 파일 업로드 , List 타입을 반복문 이용하여 여러번 업로드
            for(MultipartFile multipartFile : productDto.getUploads() ){
                // 3-3 : 업로드 서비스
                String fileName = fileService.fileUpload( multipartFile );
                if( fileName == null ) return 0; // 만약에 파일명이 null 이면 업로드 실패시 0 반환
                // 3-4 : 업로드 성공시 , 업로드 된 파일명을 db에 저장
                boolean result2 = productService.createProductImage( result , fileName ); // result:제품등록된pno , fileName:업로드된파일명
                if( result2 == false ) return 0; // 만약에 db에 이미지 저장 실패시 0 반환
            }
        }
        // 4. 처리된 업로드파일 DB처리한다.
        return result;
    }

    //[2] 제품 전체 조회
    @GetMapping("/list")
    public List<ProductDto> getAllProduct(){
        return productService.getAllProduct();
    }

    // [3] 특정한 제품의 정보 조회
    @GetMapping("/find")
    public ProductDto getProduct( @RequestParam int pno ){
        return productService.getProduct( pno );
    }

}













