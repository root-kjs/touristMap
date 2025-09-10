//import { getLdongCodeData , getLclsSystmData, getLocationListData, getLdong1Data, getAreaListData } from './getAPIdata.js';
const serviceKey = `DOpLI7EuzXtbDtCQ40p5sHOuJ9NW89eB%2Fd7hUs3CQsVoZ6d6q2HZiDViRsYqCJuabArktqa8tJcOmldsY5A7eg%3D%3D`; // 서비스키
// 1. 상세관광정보(공통)
const detailCommon2Data = async( value ) => { 
    const URL = `https://apis.data.go.kr/B551011/KorService2/detailCommon2?contentId=${value.contentid}&MobileOS=ETC&MobileApp=AppTest&_type=json&serviceKey=`;
    const response = await fetch( URL+serviceKey );
    const data = await response.json();
    return data.response.body.items.item[0];
}//func end

// 2. 상세관광정보(관광타입별)
const detailIntro2Data = async( value ) => { // 상세관광정보
    const URL = `https://apis.data.go.kr/B551011/KorService2/detailIntro2?contentId=${value.contentid}&contentTypeId=${value.contenttypeid}&MobileOS=ETC&MobileApp=AppTest&_type=json&serviceKey=`;
    const response = await fetch( URL+serviceKey );
    const data = await response.json();
    return data.response.body.items.item[0];
}//func end


// 2. 상세관광정보(관광타입별)
const detailInfo2Data = async( value ) => { // 상세관광 반복정보
    const URL = `https://apis.data.go.kr/B551011/KorService2/detailInfo2?contentId=${value.contentid}&contentTypeId=${value.contenttypeid}&MobileOS=ETC&MobileApp=AppTest&_type=json&serviceKey=`;
    const response = await fetch( URL+serviceKey );
    const data = await response.json();
    return data.response.body.items.item[0];
}//func end

// [01] 지도마커 클릭시, 상세업체정보 출력하기-----------------------------------------------------------------------------------
export const markerInfoLayer = async( value, marker ) => { //console.log("지도마커 클릭시, 상세업체정보 출력하기");

    // 4-2. 개별 마커 클릭 했을 경우, 해당 정보 노출--> 상세관광정보 작업중!
    let html = "";
    kakao.maps.event.addListener( marker, 'click', async( ) => {
        try {
            const detailCommon = await detailCommon2Data( value ); // 1. 상세관광정보(공통) 호출
            const detailIntro = await detailIntro2Data( value );   // 2. 상세관광정보(관광타입별) 
            const detailInfo = await detailInfo2Data( value );    // 2. 상세관광 반복정보(관광타입별)

            console.log( detailCommon );
            // 2) 마커 클릭했을 경우, 모달 레이어창 나오기
            const modalLayer = document.querySelector('#modalMarkerInfoLayer');
                if( modalLayer ) modalLayer.style.display = "block";  
            html += `
            <div class="modal_box">
                <button class="modal_close fa fa-close" onclick="this.closest('.modal_marker_info_layer').style.display='none'"></button>
                <div class="modal_img_box">
                    <div class="modal_img_bg"><img src="${value.firstimage}" alt="${value.title}"/></div>
                    <div class="modal_content_outline">
                        <h3>${value.title}</h3>
                        <span>${value.contenttypeid}</span>
                        <div class="category">${value.cat1} > ${value.cat2} > ${value.cat3}</div>
                    </div>
                </div>
                <div class="modal_content">
                    <p class="description">${detailCommon.overview || '상세 정보가 없습니다.'}</p>
                    <h4>상세정보</h4>
                    <ul>
                        <li><b>주소</b><span>${detailCommon.addr1} ${detailCommon.addr2}</span></li>
                        <li><b>홈페이지</b><span> ${detailCommon.homepage ? `<a href='${detailCommon.homepage}' target='_blank'>${detailCommon.homepage}</a>` : '정보 없음'}</span></li>
                        <li><b>Tel.</b><span>${value.tel ? `<a href="tel:${value.tel}">${value.tel}</a>` : '-'}</span></li>
                     
                    </ul>
                    <h4>사진이미지</h4>
                    <ul class="addition_img_wrap">
                        <li><img src="${detailCommon.firstimage2}" alt="${value.title}"/></li>
                        <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
                    </ul>
                    <h4>부가정보</h4>
                    <ul>
                      <li><b>휴무일</b><span>연중무휴</span></li>
                    </ul>
                </div>
            </div>  
            `
            modalLayer.innerHTML = html;
   } catch (error) {
            console.error("마커 정보 로드 중 오류 발생:", error);
            alert("상세 정보를 불러오는 중 오류가 발생했습니다. 다시 시도해 주세요.");
        }
    });
}//func end
