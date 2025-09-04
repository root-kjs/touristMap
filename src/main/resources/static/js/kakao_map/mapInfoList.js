// 1) 자바단 > 법정동코드조회(ldongCode2)데이터 가져오기
const getLdongCodeData = async() => {
    try {
        const response = await fetch(`/api`);
        const data = await response.json();
        console.log(data.response.body.items.item);
        return data.response.body.items.item;
    } catch ( error ) {
        console.log( error );
    }
}//func end

// 2) 자바단 > 분류체계코드(lclsSystmCode2) 데이터 가져오기
const getLclsSystmData = async() => {
    try {
        const response = await fetch(`/api`);
        const data = await response.json();
        //console.log(data.response.body.items.item);
        return data.response.body.items.item;
    } catch ( error ) {
        console.log( error );
    }
}//func end

const mapInfoList = async() => {
console.log("mapInfoList(우측지도업체정보) js start");
    const lclsItems = await getLclsSystmData(); // 분류 데이터 가져오기

    const lclsMap = new Map();
    lclsItems.forEach(item => {
        lclsMap.set(item.lclsSystm1Cd, item.lclsSystm1Nm);
        lclsMap.set(item.lclsSystm2Cd, item.lclsSystm2Nm);
        lclsMap.set(item.lclsSystm3Cd, item.lclsSystm3Nm);
    });
    console.log( lclsMap );
     try {
/*  한국관광공사_국문 관광정보 서비스_GW 1.0.0 [ Base URL: apis.data.go.kr/B551011/KorService2 ]
    김진숙(250829) : https://www.data.go.kr/data/15101578/openapi.do#/layer-api-guide
    일반 인증키(Encoding)	// DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D
    일반 인증키(Decoding)	// DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB/d7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg==
    https://apis.data.go.kr/B551011/KorService2/locationBasedList2?
    lDongRegnCd=28 // 법정동 시도 코드(인천)
    &mapX=126.7052 // *필수요청값* 인천광역시청 : GPS X좌표(WGS84 경도좌표)
    &mapY=37.4563 // *필수요청값* 인천광역시청 : GPS Y좌표(WGS84 위도좌표)
    &radius=20000 // *필수요청값* 거리반경(단위:m) Max값 20000m=20Km
    &MobileOS=ETC // *필수요청값*
    &MobileApp=AppTest // *필수요청값*
    &contentTypeId=12 // 25년 12월 서비스 종료 예정/ 관광타입ID(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점)
    &numOfRows=100
    &_type=json
    &arrange=A //(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
    &serviceKey=DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D //*필수요청값*
*/
   const serviceKey = "DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D";
   const URL = "https://apis.data.go.kr/B551011/KorService2/locationBasedList2?lDongRegnCd=28&mapX=126.7052&mapY=37.4563&radius=20000&contentTypeId=&numOfRows=100&MobileOS=ETC&MobileApp=AppTest&_type=json&arrange=S&serviceKey=";
    const response = await fetch( URL+serviceKey, {method : "GET"} );
    const data = await response.json();
    // console.log(data.response.body.items.item.map); // !데이터 확인
    const sidebar = document.querySelector('#mapInfoBody');
    let html = "";

    // 2) 카카오맵 API 제이슨 데이터 가져오기
    data.response.body.items.item.forEach( (value) => {
        const category1 =  lclsMap.get(value.lclsSystm1);
        const category3 =  lclsMap.get(value.lclsSystm3);
        console.log( lclsMap.get(value.lclsSystm1) );
        html += `
            <ul class="summary_card">
                 <li class="subject">
                     <b>${value.title}</b>
                     <span class="category"><b class="depth_1">${category1}</b><b class="depth_2">${category3}</b></span>
                 </li>
                 <li class="thumb"><img src="${value.firstimage ? value.firstimage : value.firstimage2}" alt="${value.title}"></li>
                 <li class="addr">${value.addr1}</li> <!-- lDongSignguCd -->
                 <li class="work_time">${value.contentTypeId}</li>
                 <li class="parking">주차시설 : 있음,유료</li>
                 <li class="tel">${value.tel ? value.tel : '전화번호 정보 없음'}</li>
             </ul>
        `
    });
    sidebar.innerHTML = html;
    } catch (error) {
        console.error("위치 기반 오류 발생:", error);
    }
}//func end
mapInfoList();