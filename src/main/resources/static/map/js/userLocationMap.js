import { getLdongCodeData , getLclsSystmData, getLocationListData, getLdong1Data, getAreaListData } from './getAPIdata.js';
import { markerInfoLayer } from './markerInfoLayer.js';
export const userlocationMap = async( lDongRegnCd ) => { console.log("[지역별 지도] 마커 출력하기");
    /* 1) 지도 위치 및 기본옵션 설정 */
    var map = new kakao.maps.Map(document.getElementById('map'), {
        // 인천 중심좌표 : mapX=126.7052062  mapY=37.4562557 부평구 부평동 주부토로 19 인근(부평구청 근처)
        center : new kakao.maps.LatLng(37.489457, 126.724494 ), // 지도의 중심좌표 -> 인천시청 기준 : 37.4563, 126.7052 // 인천광역시 옹진군 영흥면 : 위도 37.4689816 / 경도 126.5207318 // 인천역 : 위도 (Latitude): 37.478296 경도 (Longitude): 126.622685
        //더조은 학원 부평역 기준(사용자) : 위도 37.489457, 경도 126.724494 
        level : 6 // 지도의 확대 레벨
    });
    var clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 1, // 클러스터 할 최소 지도 레벨
        disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
    });

    // 3) 마커 이미지의 이미지 주소
    var imageSrc = "/img/kakao_map/logo.jpg"; // https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png
    var imageSize = new kakao.maps.Size(24, 24); // 마커 이미지의 이미지 크기
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); // 마커 이미지를 생성
    
        // 마커를 클릭했을 때 마커 위에 표시할 인포윈도우를 생성합니다
        var iwContent = '<div style="padding:5px;">Hello World!</div>', // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능합니다
            iwRemoveable = true; // removeable 속성을 ture 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됩니다

        // 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({
            content : iwContent,
            removable : iwRemoveable
        });

    /* 2) 위치기반조회(locationBasedList2) 호출 */
    // const areaListData = await getAreaListData(); //console.log( locationData ); // 기존 전국 관광정보 데이터(5만개 넘음)
    // const incheonAreaData = areaListData.filter(item => item.lDongRegnCd === '28'); // 기존 전체 맵에서 인천코드로 필터한 경우 
    const incheonAreaData = await getAreaListData( lDongRegnCd );

    // 4) 카카오 map 마커 찍기 반복문
    let markers = incheonAreaData.map( (value) => {
        // 4-1. 마커 객체 생성 후 마커스로 배열 추가 대입
        let marker = new kakao.maps.Marker({
            position : new kakao.maps.LatLng(value.mapy, value.mapx), // 공공데이터 속성명으로 변경
            image : markerImage // 마커 이미지
        });

    console.log("markers 확인!");    

    markerInfoLayer( value, marker );

    return marker;
    });

    clusterer.addMarkers(markers); // 클러스터러에 마커들을 추가합니다
    kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
        var level = map.getLevel()-1; // 현재 지도 레벨에서 1레벨 확대한 레벨
        map.setLevel(level, {anchor: cluster.getCenter()});  // 지도를 클릭된 클러스터의 마커의 위치를 기준으로 확대합니다
    });
}//func end    
    /* 마커 클릭시, 좌측 상세 업체 정보 나오는 레이어 */
    
