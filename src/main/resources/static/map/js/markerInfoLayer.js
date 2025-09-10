//import { getLdongCodeData , getLclsSystmData, getLocationListData, getLdong1Data, getAreaListData } from './getAPIdata.js';
export const markerInfoLayer = async(  value, marker ) => { console.log("지도마커 클릭시, 상세업체정보 출력하기");
        // 4-2. 개별 마커 클릭 했을 경우, 해당 정보 노출하게 하는 이벤트 --> 상세관광정보 작업중!
        let html = "";
        kakao.maps.event.addListener( marker, 'click', ( ) => {
            // 2) 마커 클릭했을 경우, 모달 레이어창 나오기
            const modalLayer = document.querySelector('#modalMarkerInfoLayer');
             if( modalLayer ) modalLayer.style.display = "block";  // 보이기
            html += `
            <!-- 모달 박스 시작 -->
            <div class="modal_box">
                <!-- 콘텐츠 내용 시작 -->
                <button class="modal_close fa fa-close" onclick="this.closest('.modal_marker_info_layer').style.display='none'"></button>
                <div class="modal_img_box">
                    <img src="${value.firstimage ? value.firstimage : value.firstimage2}" alt="타이틀"/>
                    <div class="modal_content_outline">
                        <h3>${value.title}</h3>
                        <div class="category">${value.cat1} > ${value.cat2} > ${value.cat3}</div>
                    </div>
                </div>
                <div class="modal_content">
                    <p class="description">
                        동촌유원지는 대구시 동쪽 금호강변에 있는 44만 평의 유원지로 오래전부터 대구 시민이 즐겨 찾는 곳이다. 각종 위락시설이 잘 갖춰져 있으며, 드라이브를 즐길 수 있는 도로가 건설되어 있다. 수량이 많은 금호강에는 조교가 가설되어 있고, 우아한 다리 이름을 가진 아양교가 걸쳐 있다. 금호강(琴湖江)을 끼고 있어 예로부터 봄에는 그네뛰기, 봉숭아꽃 구경, 여름에는 수영과 보트 놀이, 가을에는 밤 줍기 등 즐길 거리가 많은 곳이다. 또한, 해맞이다리, 유선장, 체육시설, 실내 롤러스케이트장 등 다양한 즐길 거리가 있어 여행의 재미를 더해준다.
                    </p>
                    <h4>상세정보</h4>
                    <ul>
                        <li><b>주소</b>${value.addr1}</li>
                        <li><b>홈페이지</b><a href="#" target="_blank">//tour.daegu.go.kr</a></li>
                        <li><b>Tel.</b><a href="tel:${value.tel ? value.tel:'#'}">${value.tel ? value.tel : '전화번호 정보 없음'}</a></li>
                        <li><b>주차</b>"가능 / 요금 (최초 2시간 무료 / 이후 30분 당 400원씩 추가 요금 발생)</li>
                        <li><b>휴무일</b>연중무휴</li>
                        <li><b>휴무일</b>연중무휴</li>
                    </ul>
                    <h4>사진이미지</h4>
                    <ul class="addition_img_wrap">
                        <li><img src="${value.firstimage}" alt="${value.title}"/></li>
                        <li><img src="${value.firstimage2}" alt="${value.title}"/></li>
                        <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
                        <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
                        <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
                    </ul>
                    <h4>부가정보</h4>
                    <ul>
                        <li><b>홈페이지</b><a href="#" target="_blank">//tour.daegu.go.kr</a></li>
                        <li><b>Tel.</b><a href="tel:010-1234-5678">010-1234-5678</a></li>
                        <li><b>주차</b>"가능 / 요금 (최초 2시간 무료 / 이후 30분 당 400원씩 추가 요금 발생)</li>
                        <li><b>휴무일</b>연중무휴</li>
                        <li><b>휴무일</b>연중무휴</li>
                    </ul>
                </div>
                <!-- 콘텐츠 내용 끝 -->
            </div>
            <!-- 모달 박스 끝 -->     
         `
            modalLayer.innerHTML = html;
        });
}//func end
