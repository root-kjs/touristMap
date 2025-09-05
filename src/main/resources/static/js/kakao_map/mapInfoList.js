/* [01] 자바 > 공공데이터 API 연동 데이터 호출(한국관광공사_국문 관광정보 서비스_GW)*/
const fetchData = async(apiPath) => {
    try {
        const response = await fetch(`/api/${apiPath}`);
        const data = await response.json(); //console.log(data);
        return data; // data.response.body.items.item;
    }catch (error) {
        console.log('[오류]공공데이터 API 자바:', error);
        return null;
    }
};
const getLdongCodeData = async() => fetchData('ldong');      /* [01] 법정동코드조회(ldongCode2) */
const getLclsSystmData = async() => fetchData('lcls');       /* [02] 분류체계코드(lclsSystmCode2) */
const getLocationListData = async() => fetchData('location');/* [03] 위치기반조회(locationBasedList2) */

getLdongCodeData().then( data => {console.log(data);} );
getLclsSystmData().then( data => {console.log(data);} );
getLocationListData().then( data => {console.log(data);} );

/* ========================= 우측영역(/map/place.jsp) > 지도 업체정보 출력하기 ========================= */
const mapInfoList = async() => {
    console.log("mapInfoList(우측지도업체정보) js start");
    try {
        /* (1) 법정동코드조회(ldongCode2) 호출 */
        const ldongData = await getLdongCodeData();
        const ldongMap = new Map();
        if (ldongData) {
            ldongData.forEach(item => {
                ldongMap.set(item.lDongRegnCd, item.lDongRegnNm);
                if (item.lDongRegnCd === '28' && item.lDongSignguCd) {
                    ldongMap.set(item.lDongSignguCd, item.lDongSignguNm);
                }
            });
        }
        //console.log( ldongMap );

        /* (2) 분류체계코드(lclsSystmCode2) 호출 */
        const lclsData= await getLclsSystmData();
        const lclsMap = new Map();
        if (lclsData) {
             lclsData.forEach(item => {
                lclsMap.set(item.lclsSystm1Cd, item.lclsSystm1Nm);
                lclsMap.set(item.lclsSystm2Cd, item.lclsSystm2Nm);
                lclsMap.set(item.lclsSystm3Cd, item.lclsSystm3Nm);
            });
        }
       //console.log( lclsMap );

        /* (3) 위치기반조회(locationBasedList2) 호출 */
        const locationData = await getLocationListData(); //console.log( locationData );
        // arrange=S(A=제목순,C=수정일순, D=생성일순, E=거리순) 대표이미지가 반드시 있는 정렬 (O=제목순, Q=수정일순, R=생성일순,S=거리순)
        // 인천 중심좌표 : mapX=126.7052062  mapY=37.4562557 부평구 부평동 주부토로 19 인근(부평구청 근처)
        const mapInfoBox = document.querySelector('#mapInfoBox');
        let html = "";
        let index = 1; // 자동 순번 변수

        // locationData를 category1 기준으로 그룹화
        const groupedByCategory = locationData.reduce((acc, value) => {
            const category1 = lclsMap.get(value.lclsSystm1) || '기타';
            if (!acc[category1]) {
                acc[category1] = [];
            }
            acc[category1].push(value);
            return acc;
        }, {});

        // 그룹화된 데이터를 순회하여 외부 루프 생성
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

            // 내부 루프: 해당 카테고리에 속한 아이템들 순회
            items.forEach( (value) => {
                const addr_ldong1 = ldongMap.get(value.lDongRegnCd) || '';
                const addr_ldong2 = ldongMap.get(value.lDongSignguCd) || '';
                const category2 = lclsMap.get(value.lclsSystm2) || '';
                const category3 = lclsMap.get(value.lclsSystm3) || '';

                html += `<ul class="summary_card">
                     <li class="subject">
                         <b>${value.title}</b>
                         <span class="category"><b class="depth_2">${category2}</b></span>
                     </li>
                     <li class="thumb"><img src="${value.firstimage || value.firstimage2}" alt="${value.title}"></li>
                     <li class="work_time">${category3}</li>
                     <li class="addr">${value.addr1 || (addr_ldong1 + ' ' + addr_ldong2)}</li>
                     <li class="tel">${value.tel ? 'Tel. ' + value.tel : 'Tel. -'}</li>
                 </ul>`;
            });

            html += `</div>
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