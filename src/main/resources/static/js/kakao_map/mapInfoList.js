// 1) 자바 > 법정동코드조회(ldongCode2) 가져오기
const getLdongCodeData = async() => {
    try{
        const response = await fetch(`/api/ldong`);
        const data = await response.json();
        return data.response.body.items.item;
    }catch ( error ) { console.log( error ); }
}//func end

// 2) 자바 > 분류체계코드(lclsSystmCode2) 가져오기
const getLclsSystmData = async() => {
    try{
        const response = await fetch(`/api/lcls`);
        const data = await response.json();
        return data.response.body.items.item;
    }catch ( error ) { console.log( error ); }
}//func end

// 3) 우측영역 > 지도 업체정보 출력하기
const mapInfoList = async() => {
console.log("mapInfoList(우측지도업체정보) js start");
    // 1) 법정동코드조회(ldongCode2) 가져오기
    const ldongData = await getLdongCodeData();
    const ldongMap = new Map();
    ldongData.forEach(item => {
        ldongMap.set(item.lDongRegnCd, item.lDongRegnNm);
        ldongMap.set(item.lDongSignguCd, item.lDongSignguNm);
    }); //console.log( ldongMap );

    // 2) 분류체계코드(lclsSystmCode2) 가져오기
    const lclsData= await getLclsSystmData();
    const lclsMap = new Map();
    lclsData.forEach(item => {
        lclsMap.set(item.lclsSystm1Cd, item.lclsSystm1Nm);
        lclsMap.set(item.lclsSystm2Cd, item.lclsSystm2Nm);
        lclsMap.set(item.lclsSystm3Cd, item.lclsSystm3Nm);
    }); //console.log( lclsMap );
    //arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
    //mapX=126.7052062&mapY=37.4562557 부평구 부평동 주부토로 19 인근 (부평구청 근처)
    try {
       const serviceKey = "DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D";
       const URL = "//apis.data.go.kr/B551011/KorService2/locationBasedList2?lDongRegnCd=28&arrange=S&mapX=126.7052062&mapY=37.4562557&radius=20000&numOfRows=100&MobileOS=WEB&MobileApp=AppTest&_type=json&serviceKey="; //
        const response = await fetch( URL+serviceKey, {method : "GET"} );
        const data = await response.json();
        console.log(data.response.body.items.item); // !데이터 확인
        const mapInfoBox = document.querySelector('#mapInfoBox');
        let html = "";

        // 2) 카카오맵 API 데이터 가져오기
        data.response.body.items.item.forEach( (value) => { //.slice(5, 10)
            const addr_ldong1 = ldongMap.get(value.lDongRegnCd);       console.log( lclsMap.get(value.lDongRegnCd) );
            const addr_ldong2 = ldongMap.get(value.lDongSignguCd);
            const category1 = lclsMap.get(value.lclsSystm1);           //console.log( lclsMap.get(value.lclsSystm1) );
            const category2 = lclsMap.get(value.lclsSystm2);
            const category3 = lclsMap.get(value.lclsSystm3);

            html += `<dl class="ai_card">
               <dt class="header">
                    <h2 class="subject_keyword">
                        <span class="area"><b class="depth_1">1</b><b class="depth_2">중구</b></span>
                        <strong>${category1}</strong>
                    </h2>
                    <p class="keyword_recommand"><!-- 연관 키워드 10개 -->
                        <a href="#">${category2}</a>
                    </p>
               </dt>
               <dd class="body" id="mapInfoBody">
                    <div class="card_list">
                        <ul class="summary_card">
                             <li class="subject">
                                 <b>${value.title}</b>
                                 <span class="category"><b class="depth_2">${category2}</b></span>
                             </li>
                             <li class="thumb"><img src="${value.firstimage ? value.firstimage : value.firstimage2}" alt="${value.title}"></li>
                             <li class="addr">${value.addr1 ? value.addr1 : addr_ldong1 + ' ' +addr_ldong2}</li>
                             <li class="work_time">${category1} > ${category3}</li>
                             <li class="tel">${value.tel ? 'Tel. ' + value.tel : 'Tel. -'}</li>
                         </ul>
                         <div class="btn_wrap">
                             <button onclick="#"><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                             <button onclick="#"><i class="fa-solid fa-search"></i></button>
                         </div>
                    </div>
                  </dd>
                  <dd class="footer">
                      <button class="basic" onclick="alert('준비중입니다.')"><i class="fa-solid fa-location-dot"></i> 진행중인 모임</button>
                      <button class="confirm" onclick="alert('준비중입니다.')"><i class="fa-solid fa-pen-to-square"></i> 초대장 만들기</button>
                  </dd>
              </dl>
            `
        });
        mapInfoBox.innerHTML = html;
    } catch (error) {
        console.error("위치 기반 오류 발생:", error);
    }
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
}//func end
mapInfoList();