import { getCityData, getAreaListData , userlocationMap  } from './mapInfoList.js';

//[01] 활성화된(.active) 좌측 대메뉴명 > 상단 title에 넣기--------------------------
let activeLinkText = $(".membership li.active a").text();
$("title").text(activeLinkText);
    // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
    $(".membership li.active a").clone().prependTo(".lnb h2");


// [02] 법정동코드(1차 대분류 지역) 데이터 가져오기----------------------------------
const getAreaLnb = async() =>{
   
    const ldongData = await getCityData();
    //console.log(ldongData);
    // 2) 법정동코드 데이터 html 출력
    const lnbMap = document.querySelector("#lnbMap");
    const defaultActiveAreaCode = '28'; 
    let html = "";
    ldongData.forEach( (area) =>{
        const isActive = area.code === defaultActiveAreaCode ? 'active' : '';
        html += `
        <li data-code="${area.code}">
            <a href="#" class ="${isActive}" onclick="handleAreaClick('${area.code}')">
            <i class="fa-solid fa-map-location-dot" aria-hidden="true"></i>
                <span>${area.name}</span><b class="num">18,562</b>
            </a>
        </li>`
    });
    lnbMap.innerHTML=html;
}//func end

// [03] 페이지 최초 로딩 시, 기본 인천 지역 지도 출력--------------------------------
window.addEventListener('load', async() => {
    await getAreaLnb(); // 좌측 메뉴가 먼저 로드
    await $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1"); // 
    userlocationMap('28'); // 디폴트 : 인천 지도
});

// [04] 좌측 지역메뉴 클릭시마다 > 우측 관광정보 타이틀명 변경------------------------
window.handleAreaClick = ( areaCode ) => {
    const activeLink = document.querySelector("#lnbMap .active");
    const currentPageTitle = document.querySelector('.right_contents.area > .page_title > h1 > a');
    // 1) 기존 'active' 클래스 제거
    if (activeLink) {
        activeLink.classList.remove('active');
        //console.log("복사 삭제");
        currentPageTitle.remove('a');
    }
    // 2) 클릭된 링크에 'active' 클래스 추가
    const clickedLink = document.querySelector(`#lnbMap [data-code="${areaCode}"] a`);
    if (clickedLink) {
        clickedLink.classList.add('active');
        $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
        //console.log("복사 생성");
    }
    // 3) 좌측 지역명 선택에 따른 지도 마커 업데이트
    userlocationMap( areaCode );
};

