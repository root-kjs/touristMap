package user.model.dao;

import org.springframework.stereotype.Repository;
import user.model.dto.ProductDto;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Repository
public class ProductDao extends Dao {

    // [1-1] 제품 등록
    public int createProduct(ProductDto productDto ){
        try{
            String sql ="INSERT INTO product(pname,pprice,pcomment,plat,plng,mno)value(?,?,?,?,?,?)";
            PreparedStatement ps = conn.prepareStatement( sql , Statement.RETURN_GENERATED_KEYS ); // (1) PK 리턴 설정
            ps.setString( 1 , productDto.getPname() );
            ps.setInt( 2 , productDto.getPprice() );
            ps.setString( 3 , productDto.getPcomment() );
            ps.setDouble( 4 , productDto.getPlat() );
            ps.setDouble( 5 , productDto.getPlng() );
            ps.setInt( 6 , productDto.getMno() );
            int count = ps.executeUpdate();
            if( count == 1 ){
                ResultSet rs = ps.getGeneratedKeys(); // (2) 등록된 레코드의 PK값 조회
                if( rs.next() ) return rs.getInt( 1 ); // (3) 등록된 레코드의 첫번째 pk값 반환( 생성된 pno )
            }
        } catch (Exception e) { System.out.println(e);  }
        return 0; // 실패시 0 반환
    }

    // [1-2] 제품 이미지 등록
    public boolean createProductImage( int pno , String fileName ){
        try{
            String sql = "INSERT INTO productimg( pimgname , pno ) values(?,?)";
            PreparedStatement ps = conn.prepareStatement( sql );
            ps.setString( 1 , fileName );
            ps.setInt( 2 , pno );
            return ps.executeUpdate() == 1;
        } catch (Exception e) { System.out.println(e); }
        return false;
    }

    // [2-1] 전체 제품의 정보 조회
    public List<ProductDto> getAllProduct(){
        List<ProductDto> list = new ArrayList<>();
        try{ String sql = "select * from product";
            PreparedStatement ps =conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while ( rs.next() ){
                ProductDto productDto = new ProductDto();
                productDto.setPno( rs.getInt( "pno") );
                productDto.setPname( rs.getString( "pname") );
                productDto.setPcomment( rs.getString( "pcomment") );
                productDto.setPprice( rs.getInt( "pprice") );
                productDto.setPdate( rs.getString( "pdate") );
                productDto.setPlat( rs.getDouble( "plat") );
                productDto.setPlng( rs.getDouble( "plng") );
                productDto.setMno( rs.getInt( "mno") );
                list.add( productDto );
            }
        } catch (Exception e) { System.out.println(e); }
        return list;
    }

    // [2-2] 특정한 제품의 제품이미지명 전체 조회
    public List<String> getProductImages( int pno ){
        List<String> list = new ArrayList<>();
        try{ String sql = "select * from productimg where pno = ?";
            PreparedStatement ps = conn.prepareStatement( sql );
            ps.setInt( 1 , pno );
            ResultSet rs = ps.executeQuery();
            while ( rs.next() ){
                String pimgname = rs.getString("pimgname");
                list.add( pimgname );
            }
        } catch (Exception e) { System.out.println(e);  }
        return list;
    }

    // [3] 특정한 제품의 정보 조회
    public ProductDto getProduct( int pno ){
        try{ String sql = "select * from product where pno = ? ";
            PreparedStatement ps = conn.prepareStatement( sql );
            ps.setInt( 1 , pno );
            ResultSet rs = ps.executeQuery();
            if( rs.next() ) {// if( rs.next() ) 레코드1개조회 vs while(rs.next() ) 레코드 여러개조회
                ProductDto productDto = new ProductDto(); // [2-1] dto 생성
                productDto.setPno( rs.getInt( "pno") );
                productDto.setPname( rs.getString( "pname") );
                productDto.setPcomment( rs.getString( "pcomment") );
                productDto.setPprice( rs.getInt( "pprice") );
                productDto.setPdate( rs.getString( "pdate") );
                productDto.setPlat( rs.getDouble( "plat") );
                productDto.setPlng( rs.getDouble( "plng") );
                productDto.setMno( rs.getInt( "mno") );
                return productDto; // dto 반환
            }
        } catch (Exception e) {   System.out.println(e); }
        return null;
    }



} // class end






















