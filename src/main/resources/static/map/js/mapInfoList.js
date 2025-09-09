/* 자바(java/user/service/TourApiService) > 공공데이터 API데이터 호출(한국관광공사_국문 관광정보 서비스_GW)*/
const fetchData = async(apiPath) => {
    try {
        const response = await fetch(`/api_tour/${apiPath}`);
        const data = await response.json(); //console.log(data);
        return data; // data.response.body.items.item;
    }catch (error) {
        console.error('[오류]자바 공공데이터 API :', error);
        return null;
    }
};
const getLdongCodeData = async() => fetchData('ldongCd');      // [01] 법정동코드(ldongCode2) 
export const getLclsSystmData = async() => fetchData('lcls');       // [02] 분류체계코드(lclsSystmCode2) 
export const getLocationListData = async() => fetchData('location');// [03] 위치기반 관광정보(locationBasedList2)
export const getLdong1Data = async() => fetchData('ldong');            // [04] 법정동코드 > 대분류(17개)
export const getAreaListData = async( lDongRegnCd ) => fetchData(`area?lDongRegnCd=${lDongRegnCd}`);// [05] 지역기반(17개) 관광정보(areaBasedList2)

//getAreaListData().then( data => {console.log(data);} );    // !확인용

/* ========================= [01] 우측영역(index.jsp) > 지도 업체정보 출력하기 ========================= */

export const mapInfoList = async() => { console.log("mapInfoList(우측지도업체정보) js start");
    try {
        /* 1) 법정동코드(ldongCode2) 호출 */
        const ldongData = await getLdongCodeData();
        const ldongMap = new Map();
        if (ldongData) {
            ldongData.forEach(item => {
                ldongMap.set(item.lDongRegnCd, item.lDongRegnNm);
                if (item.lDongRegnCd === '28' && item.lDongSignguCd) {
                    ldongMap.set(item.lDongSignguCd, item.lDongSignguNm);
                }
            });
        }//console.log( ldongMap );

        /* 2) 분류체계코드(lclsSystmCode2) 호출 */
        const lclsData= await getLclsSystmData();
        const lclsMap = new Map();
        if (lclsData) {
             lclsData.forEach(item => {
                lclsMap.set(item.lclsSystm1Cd, item.lclsSystm1Nm);
                lclsMap.set(item.lclsSystm2Cd, item.lclsSystm2Nm);
                lclsMap.set(item.lclsSystm3Cd, item.lclsSystm3Nm);
            });
        }//console.log( lclsMap );

        /* 3) 위치기반 관광정보(locationBasedList2) 호출 */
        const locationData = await getLocationListData(); //console.log( locationData );
        // arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순) 인천 중심좌표 : mapX=126.7052062  mapY=37.4562557 부평구 부평동 주부토로 19 인근(부평구청 근처)

        /* 4) 지도 마커 찍을 돔객체 가져오기 */
        const mapInfoBox = document.querySelector('#mapInfoBox');
        let html = "";   let index = 1; // 커테고리 자동 순번 변수

        /* 5) locationData를 category1 기준으로 그룹화(2중 포문) */
        const groupedByCategory = locationData.reduce((acc, value) => {
            const category1 = lclsMap.get(value.lclsSystm1) || '기타';
            if (!acc[category1]) {
                acc[category1] = [];
            }
            acc[category1].push(value);
            return acc;
        }, {});

        /* 6) category1 그룹화된 데이터를 순회하여 외부 루프 생성 */
        for (const [categoryName, items] of Object.entries(groupedByCategory)) {
            // 해당 카테고리에 속한 모든 category2 값을 추출하고 중복 제거
            const category2Keywords = [...new Set(items.map(item => lclsMap.get(item.lclsSystm2)).filter(Boolean))];
            const keywordHtml = category2Keywords.map(keyword => `<a href="#">${keyword}</a>`).join('');

            html += `<dl class="ai_card">
                <dt class="header">
                    <h2 class="subject_keyword">
                        <!-- <span class="area"><b class="depth_1">${index++}</b></span> -->
                        <strong>${categoryName}</strong>
                    </h2>
                    <p class="keyword_recommand">
                        <!-- 중복을 제거한 모든 category2 키워드를 표시 -->
                        ${keywordHtml}
                    </p>
                </dt>
                <dd class="body" id="mapInfoBody">
                    <div class="card_list">`;

            /*  7) 내부 루프: category1 카테고리에 속한 아이템들 순회 */
            items.forEach( (value) => {
                const addr_ldong1 = ldongMap.get(value.lDongRegnCd) || '';
                const addr_ldong2 = ldongMap.get(value.lDongSignguCd) || '';
                const category2 = lclsMap.get(value.lclsSystm2) || '';
                const category3 = lclsMap.get(value.lclsSystm3) || '';

                html += `<div class="summary_card" onclick="detaiMapInfo()">
                     <div class="thumb">
                         <img src="${value.firstimage || value.firstimage2}" alt="${value.title}">
                         <span class="category"><b class="depth_2">${category2}</b></span>
                     </div>
                     <ul>
                        <li class="subject">${value.title}</li>
                        <li class="work_time">${category3}</li>
                        <li class="addr">${value.addr1 || (addr_ldong1 + ' ' + addr_ldong2)}</li>
                        <li class="tel">${value.tel ? 'Tel. ' + value.tel : 'Tel. -'}</li>
                     </ul>
                     <div class="btn_wrap">
                        <button><i class="fa-solid fa-search"></i></button>
                    </div>
                 </div>
                 `;
            });
            html += `
                </div>
            </dd>
            <dd class="footer">
                <button class="basic" onclick="alert('준비중입니다.')"><i class="fa-solid fa-location-dot"></i> 진행중인 모임</button>
                <button class="confirm" onclick="alert('준비중입니다.')"><i class="fa-solid fa-pen-to-square"></i> 초대장 만들기</button>
            </dd>
        </dl>`;
        }
        mapInfoBox.innerHTML = html;
    } catch (error) {
        console.error("위치 기반 오류 발생:", error);
    }
}//func end
mapInfoList();

/* ========================= [02] 중앙영역(index.jsp) > 지역별 지도 마커 출력하기 ========================= */
// [03] 페이지 최초 로딩 시, 기본 인천 지역 지도 출력--------------------------------
window.addEventListener('load', async() => {
    await getAreaLnb(); // 좌측 메뉴가 먼저 로드
    await $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");  
    userlocationMap('28'); // 디폴트 : 인천 지도
});

export const userlocationMap = async( lDongRegnCd ) => { console.log("페이지 최초 접속시, 사용자 좌표 중심 20km 내 관광정보 출력");
    /* 1) 지도 위치 및 기본옵션 설정 */
    var map = new kakao.maps.Map(document.getElementById('map'), {
        // 인천 중심좌표 : mapX=126.7052062  mapY=37.4562557 부평구 부평동 주부토로 19 인근(부평구청 근처)
        center : new kakao.maps.LatLng(37.489457, 126.724494 ), // 지도의 중심좌표 -> 인천시청 기준 : 37.4563, 126.7052 // 인천광역시 옹진군 영흥면 : 위도 37.4689816 / 경도 126.5207318 // 인천역 : 위도 (Latitude): 37.478296 경도 (Longitude): 126.622685
        //더조은 학원 부평역 기준(사용자) : 위도 37.489457, 경도 126.724494 
        level : 6 // 지도의 확대 레벨
    });

    // HTML5의 geolocation으로 사용할 수 있는지 확인합니다 
    if (navigator.geolocation) {
        // GeoLocation을 이용해서 접속 위치를 얻어옵니다
        navigator.geolocation.getCurrentPosition(function(position) {
            var lat = position.coords.latitude, // 위도
                lon = position.coords.longitude; // 경도
            
            var locPosition = new kakao.maps.LatLng(lat, lon), // 마커가 표시될 위치를 geolocation으로 얻어온 좌표로 생성합니다
                message = '<div style="padding:5px;">여기에 계신가요?!</div>'; // 인포윈도우에 표시될 내용입니다
            
            // 마커와 인포윈도우를 표시합니다
            displayMarker(locPosition, message);
                
        });
        
    } else { // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정합니다
        
        var locPosition = new kakao.maps.LatLng(33.450701, 126.570667),    
            message = 'geolocation을 사용할수 없어요..'
            
        displayMarker(locPosition, message);
    }

    // 지도에 마커와 인포윈도우를 표시하는 함수입니다
    function displayMarker(locPosition, message) {

        // 마커를 생성합니다
        var marker = new kakao.maps.Marker({  
            map: map, 
            position: locPosition
        }); 
        
        var iwContent = message, // 인포윈도우에 표시할 내용
            iwRemoveable = true;

        // 인포윈도우를 생성합니다
        var infowindow = new kakao.maps.InfoWindow({
            content : iwContent,
            removable : iwRemoveable
        });
        
        // 인포윈도우를 마커위에 표시합니다 
        infowindow.open(map, marker);
        
        // 지도 중심좌표를 접속위치로 변경합니다
        map.setCenter(locPosition);      
    }    




    var clusterer = new kakao.maps.MarkerClusterer({
        map: map, // 마커들을 클러스터로 관리하고 표시할 지도 객체
        averageCenter: true, // 클러스터에 포함된 마커들의 평균 위치를 클러스터 마커 위치로 설정
        minLevel: 1, // 클러스터 할 최소 지도 레벨
        disableClickZoom: true // 클러스터 마커를 클릭했을 때 지도가 확대되지 않도록 설정한다
    });

    /* 2) 위치기반조회(locationBasedList2) 호출 */
    // const areaListData = await getAreaListData(); //console.log( locationData ); // 기존 전국 관광정보 데이터(5만개 넘음)
    // const incheonAreaData = areaListData.filter(item => item.lDongRegnCd === '28'); // 기존 전체 맵에서 인천코드로 필터한 경우 
    const incheonAreaData = await getAreaListData( lDongRegnCd );

    // 3) 마커 이미지의 이미지 주소
    var imageSrc = "/img/kakao_map/logo.jpg"; // https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png
    var imageSize = new kakao.maps.Size(24, 24); // 마커 이미지의 이미지 크기
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); // 마커 이미지를 생성
    
    // 4) 카카오 map 마커 찍기 반복문
    let markers = incheonAreaData.map( (value) => {
        // 마커 객체 생성 후 마커스로 배열 추가 대입
        let marker = new kakao.maps.Marker({
            position : new kakao.maps.LatLng(value.mapy, value.mapx), //  공공데이터 속성명으로 변경
            image : markerImage // 마커 이미지
        });

        // 개별 마커 클릭 했을 경우, 해당 정보 노출하게 하는 이벤트 --> 수정해야 함.
        let html = "";
        kakao.maps.event.addListener( marker, 'click', () => {
            const sidebar = document.querySelector('#mapInfoBody');
            html += `<button onclick='schoolList()' type="button">전체보기</button>
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
                </ul> `
            sidebar.innerHTML = html;
        });
        return marker;
    });
        clusterer.addMarkers(markers); // 클러스터러에 마커들을 추가합니다
    kakao.maps.event.addListener(clusterer, 'clusterclick', function(cluster) {
        var level = map.getLevel()-1; // 현재 지도 레벨에서 1레벨 확대한 레벨
        map.setLevel(level, {anchor: cluster.getCenter()});  // 지도를 클릭된 클러스터의 마커의 위치를 기준으로 확대합니다
    });

}//func end
// userlocationMap(); // 카카오 map 출력