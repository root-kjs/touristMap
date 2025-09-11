<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="robots" content="ALL"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title>K-Tour</title>
    <meta name="Description" content="전국 소재의 다양한 모임취향에 맞는(회식/데이트/동호회) AI추천 모임장소에 대한 상세정보를 제공합니다."/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0.1,maximum-scale=5.0,user-scalable=yes" />
    <link rel="shortcut icon" href="/img/favicon.ico" type="image/x-icon">
    <link rel="stylesheet" type="text/css" href="/map/css/reset.css" >
    <link rel="stylesheet" type="text/css" href="/map/css/layout.css" >
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <link rel='stylesheet' type='text/css' media='screen' href='/map/css/mobile.css'>
</head>
<body>
<div class="container">
    <!-- ####### 01. HEADER START ####### -->
    <div class="header_wrap">
        <header>
            <h1 class="logo"><a href="/index.jsp">인천광역시</a> <span>놀러가자<i>!</i></span></h1>
        </header>
        <div class="page_search">
            <input type="text" placeholder="검색 키워드/상호명 입력" autofocus id="keywordInput"><!-- 
            --><input type="button" value="" class="fa fa-search" onclick="searchValue()">
        </div>
        <dl class="search_keword"> 
            <dt><a href="#" onclick="sendCategory('전체')">우리동네 <b>AI추천</b> 모임아이템</a></dt>
            <dd>
                <a href="#"><i class="fa-solid fa-map-location-dot" aria-hidden="true"></i> <span>관광</span></a>
                <a href="#"><i class="fa-solid fa-landmark" aria-hidden="true"></i> <span>전시</span></a>
                <a href="#"><i class="fa-solid fa-mountain-sun" aria-hidden="true"></i> <span>자연</span></a>
                <a href="#"><i class="fa-solid fa-person-hiking" aria-hidden="true"></i> <span>레저</span></a>
                <a href="#"><i class="fa-brands fa-shopify" aria-hidden="true"></i> <span>쇼핑</span></a>
                <a href="#"><i class="fa-solid fa-utensils" aria-hidden="true"></i> <span>음식</span></a>
                <a href="#"><i class="fa-solid fa-bed" aria-hidden="true"></i> <span>숙박</span></a>
            </dd>
        </dl>
    </div>
    <!-- ####### 01. HEADER END ####### -->
    <hr class="skip"/>
    <!-- ####### 02. LNB START ####### -->
    <div class="lnb_wrap">
        <div class="membership">
            <ul>
                <li class="active"><a href="#"><i class="fa-solid fa-map-location-dot"></i> 추천모임장소</a></li>
                <li><a href="#"><i class="fa-regular fa-compass"></i> 진행중인모임</a></li>
                <li><a href="#"><i class="fa-solid fa-people-group"></i> 초대장만들기</a></li>
                <li><a href="#"><i class="fa-solid fa-right-to-bracket"></i> 로그인</a></li>
                <li><a href="#"><i class="fa-solid fa-user-plus"></i> 회원가입</a></li>
            </ul>
        </div>
        <!-- 02-1. 좌측 고정 업종별 아이콘 메뉴 끝 -->
        <hr class="skip"/>
        <!-- 02-2. 좌측 on/off 페이지 서브 메뉴 노출 시작 -->
        <div class="lnb">
            <h2><div class="standard_cond"><!--우리동네 숨겨진 핫플레이스 <br/>-->주제별 다양한 장소를 확인하세요</div></h2>
            <!-- 02-2-2.페이지 컨텐츠 서브 메뉴 노출 시작 -->
            <ul class="sub_menu_list area" id="lnbMap">
                
            </ul>
        </div>
        <!-- 02-2 좌측 on/off 페이지 서브 메뉴 노출 끝 -->
    </div>
    <!-- ####### 02. LNB END ########## -->
    <hr class="skip"/>
    <!-- ####### 03. CONTENTS START ####### -->
    <section class="contents_wrap">
        <div class="left_contents">
        <!-- ############################ 카카오맵 지도 연동 시작 ############################### -->
        <jsp:include page = "/map/tour.jsp"></jsp:include>
        <!-- ############################ 카카오맵 지도 연동 끝 ################################# -->
        </div>
        <!-- 03-1.우측 본문 영역 시작 -->
        <div class="right_contents area">
            <div class="page_title">
                <h1><!-- 페이지 타이틀 > 좌측 메뉴 .active 되어 있는 메뉴명 제이쿼리 클론하여 가져옴 --> </h1>
                <span class="page_path"><!-- ## 페이지 네비 경로 ## --></span>
            </div>
            <div class="card_list_wrap" id="mapInfoBox">
               <!-- 추천(조합) 모임카드 시작 -->

                <!-- 추천(조합) 모임카드 끝 -->
            </div>
        </div>
        <a href="#" class="to_top"> 맨위로 </a>
        <!-- 03-1.우측 본문 영역 끝 -->
    </section>
    <!-- ####### 03. CONTENTS END ####### -->
    <hr class="skip"/>
    <div class="footer_wrap">
        <footer>
            <p class="copyright">  © 2025 Root.Lab</p>
        </footer>
    </div>
    <!-- ####### 04. FOOTER END ####### -->
<!-- ####### 05. 관광업체 상세정보 조회 모달(레이어) 시작 ###### -->
 <link rel="stylesheet" type="text/css" href="/map/css/modal.css" >
 <div class="modal_marker_info_layer" id="modalMarkerInfoLayer">
    <!-- 모달 박스 시작 -->
    <div class="modal_box">
        <!-- 콘텐츠 내용 시작 -->
        <button class="modal_close fa fa-close" onclick="modal_close()"></button>
        <div class="modal_img_box">
            <img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt="타이틀"/>
            <div class="modal_content_outline">
                <h3>동촌유원지</h3>
                <div class="category">자연관광 > 체험관광동궁</div>
                
            </div>
        </div>
        <div class="modal_content">
            <p class="description">
                동촌유원지는 대구시 동쪽 금호강변에 있는 44만 평의 유원지로 오래전부터 대구 시민이 즐겨 찾는 곳이다. 각종 위락시설이 잘 갖춰져 있으며, 드라이브를 즐길 수 있는 도로가 건설되어 있다. 수량이 많은 금호강에는 조교가 가설되어 있고, 우아한 다리 이름을 가진 아양교가 걸쳐 있다. 금호강(琴湖江)을 끼고 있어 예로부터 봄에는 그네뛰기, 봉숭아꽃 구경, 여름에는 수영과 보트 놀이, 가을에는 밤 줍기 등 즐길 거리가 많은 곳이다. 또한, 해맞이다리, 유선장, 체육시설, 실내 롤러스케이트장 등 다양한 즐길 거리가 있어 여행의 재미를 더해준다.
            </p>
            <h4>상세정보</h4>
            <ul>
                <li><b>주소</b>연중무휴</li>
                <li><b>홈페이지</b><a href="#" target="_blank">//tour.daegu.go.kr</a></li>
                <li><b>Tel.</b><a href="tel:010-1234-5678">010-1234-5678</a></li>
                <li><b>주차</b>"가능 / 요금 (최초 2시간 무료 / 이후 30분 당 400원씩 추가 요금 발생)</li>
                <li><b>휴무일</b>연중무휴</li>
                <li><b>휴무일</b>연중무휴</li>
            </ul>
            <h4>사진이미지</h4>
            <ul class="addition_img_wrap">
                <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
                <li><img src="http://tong.visitkorea.or.kr/cms/resource/86/3488286_image2_1.JPG" alt=""/></li>
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
</div>
<!-- ####### 05. 관광업체 상세정보 조회 모달(레이어) 끝 ###### -->
</div>
<script src="/js/jquery-1.10.2.min.js"></script>
<script src="//kit.fontawesome.com/56b5cc4bd2.js" crossorigin="anonymous"></script><!-- 폰트어썸(아이콘 폰트) 사용 인증된 링크 -->
<script src="/map/js/position.js"></script>
<script type="module" src="/map/js/lnb_map.js"></script>
<script src="/js/nav.js"></script>
</body>
</html>