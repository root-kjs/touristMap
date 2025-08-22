package user.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import user.model.dao.ProductDao;
import user.model.dto.ProductDto;

import java.util.List;

@Service
public class ProductService {

    @Autowired private ProductDao productDao;

    // [1-1] 제품 등록
    public int createProduct(ProductDto productDto ){
        return productDao.createProduct( productDto ); // DB에 제품 정보 저장
    }

    // [1-2] 제품 이미지 등록
    public boolean createProductImage( int pno , String fileName ){
        return productDao.createProductImage( pno ,fileName ); // DB에 제품 이미지 저장
    }

    // [2] 전체 제품 정보+이미지포함 조회
    public List<ProductDto> getAllProduct(){
        // 1. 모든 제품의 정보 조회
        List<ProductDto> productDtoList = productDao.getAllProduct();
        // 2. 모든 제품의 이미지 조회
        for( ProductDto productDto : productDtoList ){ // 조회된 모든 제품dto를 반복
            List<String> images =
                productDao.getProductImages( productDto.getPno() ); // 특정한 제품의 pno를 이용하여 모든 제품이미지명 조회
            productDto.setImages( images ); // 조회한 모든 이미지명을 특정한 제품의 dto 포함
        }
        // 3. 반환
        return  productDtoList;
    }

    // [3] 특정한 제품의 정보 조회
    public ProductDto getProduct( int pno ){
        // 1. 특정한 제품 조회
        ProductDto productDto = productDao.getProduct( pno );
        // 2. 만약에 조회 했으면 제품의 이미지명 조회
        if( productDto != null ){
            List<String> images =
                    productDao.getProductImages( productDto.getPno() ); // [2-2] 메소드 호출
            productDto.setImages( images );
        }
        // 3. 반환
        return productDto;
    }

}















