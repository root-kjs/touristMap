console.log("kakao_map_test.js 시작");
/*
[ 문제 ] 아래 링크에 요구사항을 확인하여 프로그램을 완성하시오. 2508018(월)
[요구사항1] 공공데이터 "인천광역시 연수구_관내 학교 현황" API 활용하여 카카오 지도에 마커에 출력하시오.
https://www.data.go.kr/data/15039731/fileData.do#/API%20%EB%AA%A9%EB%A1%9D/getuddi%3A1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0
[ 참고 URL ]
const serviceKey = "nwPZ%2F9Z3sVtcxGNXxOZfOXwnivybRXYmyoIDyvU%2BVDssxywHNMU2tA55Xa8zvHWK0bninVkiuZAA4550BDqIbQ%3D%3D"
const URL = "https://api.odcloud.kr/api/15039731/v1/uddi:1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0?page=1&perPage=72&serviceKey="

1-1. 학교 마커 표시
    - 공공데이터 "인천광역시 연수구_관내 학교 현황" API에서 데이터를 가져온다.
    - 가져온 데이터의 위도, 경도 정보를 활용하여 학교 위치에 마커를 표시한다.
    - 마커는 MarkerClusterer를 이용해 클러스터링한다.

1-2. 마커 클릭 이벤트
    - 사용자가 특정 마커를 클릭하면, 사이드바(div#sidebar)에 해당 학교의 상세 정보를 출력한다.
    출력할 정보: 학교명,전화번호,주소

1-3. 전체 보기 기능
    버튼 클릭 시, API에서 가져온 모든 학교 정보를 사이드바에 리스트 형식으로 출력한다.

[ 제출방법 ] 코드가 작성된 파일이 위치한 깃허브 상세 주소를 제출하시오.
*/

/** 01. 공공데이터 출력  > 연수구 전체 학교 리스트 */
const schoolList = async() => {
    console.log("schoolList js start");
    //https://api.odcloud.kr/api/15039731/v1/uddi:1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0?page=1&perPage=10&serviceKey=JbK3US3dccf5%2Bz%2BQig8jxLUU4s%2BMMlps5%2BxExVQHLtypXrG3I3uzGd8V4RiKfI7Ex9jeINDO8%2FVKEBLRLv5e0Q%3D%3D
    const serviceKey = "JbK3US3dccf5%2Bz%2BQig8jxLUU4s%2BMMlps5%2BxExVQHLtypXrG3I3uzGd8V4RiKfI7Ex9jeINDO8%2FVKEBLRLv5e0Q%3D%3D";
    const URL = "https://api.odcloud.kr/api/15039731/v1/uddi:1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0?page=1&perPage=72&serviceKey=";
    const response = await fetch( URL+serviceKey, {method : "GET"} );
    const data = await response.json();
    // console.log(data.data); //확인용

    const sidebar = document.querySelector('#sidebar');
    let html = "";
    data.data.forEach( (value) => {
        html += `
            <ul class="school">
                <li>${ value.학교명 }</li>
                <li>${ value['행정실'] }</li>
                <li>${ value['주소'] }</li>
            </ul>
        `
    });
    sidebar.innerHTML = html;
}//func end

schoolList();


const schoolMap = async() => {

    console.log("schoolMap js start");
    // 1. 지도 위치 및 기본옵션 설정
    var map = new kakao.maps.Map(document.getElementById('map'), {
        center : new kakao.maps.LatLng(37.415166, 126.671758), // 지도의 중심좌표 -> 연수역 기준
        level : 5 // 지도의 확대 레벨
    });

    var clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 5, // 클러스터 할 최소 지도 레벨
        disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
    });


    //https://api.odcloud.kr/api/15039731/v1/uddi:1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0?page=1&perPage=10&serviceKey=JbK3US3dccf5%2Bz%2BQig8jxLUU4s%2BMMlps5%2BxExVQHLtypXrG3I3uzGd8V4RiKfI7Ex9jeINDO8%2FVKEBLRLv5e0Q%3D%3D
    const serviceKey = "JbK3US3dccf5%2Bz%2BQig8jxLUU4s%2BMMlps5%2BxExVQHLtypXrG3I3uzGd8V4RiKfI7Ex9jeINDO8%2FVKEBLRLv5e0Q%3D%3D";
    const URL = "https://api.odcloud.kr/api/15039731/v1/uddi:1fcb72a0-ba75-4c97-a045-9ef7e3ef43c0?page=1&perPage=72&serviceKey=";
    const response = await fetch( URL+serviceKey, {method : "GET"} );
    const data = await response.json();
    // console.log(data.data); //확인용

    // 마커 이미지의 이미지 주소
    var imageSrc = "/img/kakao_map/logo.jpg"; // https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png
     // 마커 이미지의 이미지 크기 입니다
    var imageSize = new kakao.maps.Size(24, 35);
    // 마커 이미지를 생성합니다
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize);

    // map 반복문
    let markers = data.data.map( (value) => {
      // 마커 객체 생성 후 마커스로 배열 추가 대입
      let marker = new kakao.maps.Marker({
            position : new kakao.maps.LatLng(value.위도, value.경도), //  공공데이터 속성명으로 변경
            image : markerImage // 마커 이미지
        });

        // 개별 마커 클릭 했을 경우, 해당 정보 노출하게 하는 이벤트

        let html = "";
        kakao.maps.event.addListener( marker, 'click', () => {
            const sidebar = document.querySelector('#sidebar');
            html += `
                <button onclick='schoolList()' type="button">전체보기</button>
                <ul class="school">
                    <li>${ value.학교명 }</li>
                    <li>${ value['행정실'] }</li>
                    <li>${ value['주소'] }</li>
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

