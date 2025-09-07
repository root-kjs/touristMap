import { getCityData, getAreaListData , userlocationMap  } from './mapInfoList.js';

const getAreaLnb = async() =>{

    // 1) 법정동코드(1차 대분류 지역) 데이터 가져오기
    const ldongData = await getCityData();
    console.log(ldongData);

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
getAreaLnb();


// 메뉴 클릭 시 실행될 함수
window.handleAreaClick = ( areaCode ) => {
    // 1. 기존 'active' 클래스 제거
    const activeLink = document.querySelector("#lnbMap .active");
    if (activeLink) {
        activeLink.classList.remove('active');
    }

    // 2. 클릭된 링크에 'active' 클래스 추가
    const clickedLink = document.querySelector(`#lnbMap [data-code="${areaCode}"] a`);
    if (clickedLink) {
        clickedLink.classList.add('active');
    }

    // 3. 지도 업데이트 함수 호출
    userlocationMap(areaCode);
};

// 페이지 최초 로딩 시, 기본적으로 인천 지역 지도 출력
// getAreaLnb(); 함수 호출 아래에 추가
window.addEventListener('load', async () => {
    // 좌측 메뉴가 먼저 로드된 후
    await getAreaLnb();
    // 기본 인천 지도를 로드합니다.
    userlocationMap('28');
});