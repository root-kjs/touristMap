console.log("kakao_map_test.js 시작_250831");

const schoolList = async() => {
console.log("schoolList js start");
/*
    한국관광공사_국문 관광정보 서비스_GW 1.0.0 [ Base URL: apis.data.go.kr/B551011/KorService2 ]
    김진숙(250829) : https://www.data.go.kr/data/15101578/openapi.do#/layer-api-guide
    일반 인증키(Encoding)	// DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D
    일반 인증키(Decoding)	// DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB/d7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg==
    국내관광정보서비스 OpenAPI 신규 상세기능(법정동코드, 신분류코드) 안내 URL(https://api.visitkorea.or.kr/#/cmsNoticeDetail?no=207)
    한국관광공사가 보유하고 있는 전국의 다양한 관광정보와 사진정보를 실시간으로 제공 받을 수 있으며,국내 최대 관광정보 포털 사이트 Visitkorea(www.visitkorea.or.kr) 홈페이지에서 제공하는 관광정보 중 저작권 등에 구애 없이 자유롭게 활용 가능한 정보만을 선별하여 OpenAPI를 통해서 최신정보를 제공하고 있습니다.
    개방 데이터는 지역코드정보, 서비스분류코드정보, 법정동코드정보, 분류체계코드정보, 지역기반관광정보, 위치기반관광정보, 키워드검색, 행사정보, 숙박정보, 공통정보, 소개정보, 반복정보, 이미지정보, 관광정보 동기화 목록정보, 반려동물 동반여행정보 15종 약 26만 건의 국내 관광에 대한 전반적인 정보를 국문으로 제공합니다.
    모바일 앱 뿐만 아니라, 웹서비스, 태블릿, 홍보물, 잡지 등 다양한 매체에서 어플리케이션을 개발, 활용할 수 있으며 다양한 활용을 통해서 신규/융복합 관광서비스를 창출할 수 있습니다.
    ※ 제공되는 데이터중 사진 자료의 경우, 피사체에 대한 명예훼손 및 인격권 침해 등 일반 정서에 반하는 용도의 사용 및 기업 CI,BI로의 이용 금지하고 있습니다. (공공누리 1유형, 3유형 이미지 제공됨)
    API 목록
    https://apis.data.go.kr/B551011/KorService2/locationBasedList2
    ?serviceKey=DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3%3D

    &numOfRows=10		// 한페이지결과수
    &pageNo=1		    // 페이지번호
    &MobileOS=ETC		// OS 구분 : IOS (아이폰), AND (안드로이드), WEB (웹), ETC(기타)
    &MobileApp=AppTest	// 서비스명(어플명)
    &_type=json		    // 응답메세지 형식 : REST방식의 URL호출 시 json값 추가(디폴트 응답메세지 형식은XML)
    &arrange=C		    // (A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
    &mapX=126.98375		// GPS X좌표(WGS84 경도좌표)
    &mapY=37.563446		// GPS Y좌표(WGS84 위도좌표)
    &radius=1000		// 거리반경(단위:m) , Max값 20000m=20Km
    &contentTypeId=39	// 관광타입 ID(12:관광지, 14:문화시설, 15:축제공연행사, 25:여행코스, 28:레포츠, 32:숙박, 38:쇼핑, 39:음식점)
    &lDongRegnCd=11	    // 법정동 시도 코드(법정동코드조회 참고)
    &lDongSignguCd=140	// 법정동 시군구 코드(법정동코드조회 참고, lDongRegnCd 필수입력)
    &lclsSystm1=FD		// 분류체계 1Deth(분류체계코드조회 참고)
    &lclsSystm2=FD01	// 분류체계 2Deth(분류체계코드조회 참고, lclsSystm1 필수입력)
    &lclsSystm3=FD010100// 분류체계 3Deth(분류체계코드조회 참고, lclsSystm1/lclsSystm2 필수입력)
    &areaCode=1		    // 지역코드(지역코드조회 참고
    &sigunguCode=24		// 시군구코드(지역코드조회 참고, areaCode 필수입력)
    &cat1=A05		    // 대분류(서비스분류코드조회 참고)
    &cat2=A0502		    // 중분류(서비스분류코드조회 참고, cat1 필수입력)
    &cat3=A05020100		// 소분류(서비스분류코드조회 참고, cat1/cat2필수입력)
*/
    const serviceKey = "DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D";
    const URL = "https://apis.data.go.kr/B551011/KorService2/locationBasedList2?lDongRegnCd=28&mapX=126.7052&mapY=37.4563&radius=20000&contentTypeId=12&numOfRows=100&MobileOS=ETC&MobileApp=AppTest&_type=json&arrange=A&serviceKey=";
    const response = await fetch( URL+serviceKey, {method : "GET"} );
    const data = await response.json();
    // console.log(data.response.body.items.item.map); //확인용

    const sidebar = document.querySelector('#mapInfoBody');
    let html = "";
    data.response.body.items.item.forEach( (value) => {
        html += `
            <ul class="summary_card">
                 <li class="subject">
                     <b>${value.title}</b>
                     <span class="category"><b class="depth_1">${value.cat1}</b><b class="depth_2">${value.cat3}</b></span>
                 </li>
                 <li class="thumb"><img src="${value.firstimage ? value.firstimage : value.firstimage2}" alt="${value.title}"></li>
                 <li class="addr">${value.addr1}</li>
                 <li class="work_time">${value.contentTypeId}</li>
                 <li class="parking">주차시설 : 있음,유료</li>
                 <li class="tel">${value.tel ? value.tel : '전화번호 정보 없음'}</li>
             </ul>
        `
    });
    sidebar.innerHTML = html;
}//func end
schoolList();
const schoolMap = async() => {
    console.log("한국관광공사 지도 가쥬앙!");
     // 1. 지도 위치 및 기본옵션 설정
       var map = new kakao.maps.Map(document.getElementById('map'), {
           center : new kakao.maps.LatLng(37.4563, 126.7052), // 지도의 중심좌표 -> 인천시청 기준
           level : 8 // 지도의 확대 레벨
       });

       var clusterer = new kakao.maps.MarkerClusterer({
           map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
           averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
           minLevel: 5, // 클러스터 할 최소 지도 레벨
           disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
       });


       const serviceKey = "DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D";
       const URL = "https://apis.data.go.kr/B551011/KorService2/locationBasedList2?lDongRegnCd=28&mapX=126.7052&mapY=37.4563&radius=20000&contentTypeId=12&numOfRows=100&MobileOS=ETC&MobileApp=AppTest&_type=json&arrange=A&serviceKey=";
       const response = await fetch( URL+serviceKey, {method : "GET"} );
       const data = await response.json();
       console.log(data.response.body.items.item); //확인용

       // 마커 이미지의 이미지 주소
       var imageSrc = "/img/kakao_map/logo.jpg"; // https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png
        // 마커 이미지의 이미지 크기 입니다
       var imageSize = new kakao.maps.Size(24, 35);
       // 마커 이미지를 생성합니다
       var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

       // map 반복문
       let markers = data.response.body.items.item.map( (value) => {
         // 마커 객체 생성 후 마커스로 배열 추가 대입
         let marker = new kakao.maps.Marker({
               position : new kakao.maps.LatLng(value.mapy, value.mapx), //  공공데이터 속성명으로 변경
               image : markerImage // 마커 이미지
           });

           // 개별 마커 클릭 했을 경우, 해당 정보 노출하게 하는 이벤트

           let html = "";
           kakao.maps.event.addListener( marker, 'click', () => {
               const sidebar = document.querySelector('#mapInfoBody');
               html += `
                  <button onclick='schoolList()' type="button">전체보기</button>
                   <ul class="summary_card">
                       <li class="subject">
                           <b>${value.title}</b>
                           <span class="category"><b class="depth_1">${value.cat1}</b><b class="depth_2">${value.cat2}</b></span>
                       </li>
                       <li class="thumb"><img src="${value.firstimage ? value.firstimage : value.firstimage2}" alt="${value.title}"></li>
                       <li class="addr">${value.addr1}</li>
                       <li class="work_time">${value.contentTypeId}</li>
                       <li class="parking">주차시설 : 있음,유료</li>
                       <li class="tel">${value.tel ? value.tel : '전화번호 정보 없음'}</li>
                   </ul>
               `
               sidebar.innerHTML = html;
           });
           return marker;
       });

       // ####### 아래 기존 제이쿼리(아작스) 소스 변경 ############ 데이터를 가져오기 위해 jQuery를 사용합니다
       // 데이터를 가져와 마커를 생성하고 클러스터러 객체에 넘겨줍니다
       // $.get("/download/web/data/chicken.json", function(data) {
       //     // 데이터에서 좌표 값을 가지고 마커를 표시합니다
       //     // 마커 클러스터러로 관리할 마커 객체는 생성할 때 지도 객체를 설정하지 않습니다
       //     var markers = $(data.positions).map(function(i, position) {
       //         return new kakao.maps.Marker({
       //             position : new kakao.maps.LatLng(position.lat, position.lng)
       //         });
       //     });

       // 클러스터러에 마커들을 추가합니다
           clusterer.addMarkers(markers);
       // });

       // 마커 클러스터러에 클릭이벤트를 등록합니다
       // 마커 클러스터러를 생성할 때 disableClickZoom을 true로 설정하지 않은 경우
       // 이벤트 헨들러로 cluster 객체가 넘어오지 않을 수도 있습니다
       kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
           // 현재 지도 레벨에서 1레벨 확대한 레벨
           var level = map.getLevel()-1;
           // 지도를 클릭된 클러스터의 마커의 위치를 기준으로 확대합니다
           map.setLevel(level, {anchor: cluster.getCenter()});
       });

   }//func end

schoolMap(); // map 실행

$(function(){
    // 업종별 대메뉴 활성화(class="active") 메뉴버튼 처리
    $("nav ul li:nth-child(1) a").addClass("active");
    // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
    $(".membership li.active a").clone().prependTo(".lnb h2");
    $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
    $(".sub_menu_list li a.active span").clone().appendTo(".page_path");
});
let activeLinkText = $(".membership li.active a").text();
$("title").text(activeLinkText);
