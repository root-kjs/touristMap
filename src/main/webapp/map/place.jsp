<%@ page language = "java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="robots" content="ALL"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <title></title>
    <meta name="Description" content="인천광역시 소재의 다양한 모임취향에 맞는(회식/데이트/동호회) AI추천 모임장소에 대한 상세정보를 제공합니다."/>
    <meta name="viewport" content="width=device-width,initial-scale=1.0,minimum-scale=0.1,maximum-scale=5.0,user-scalable=yes" />
    <link rel="stylesheet" type="text/css" href="/map/css/reset.css" >
    <link rel="stylesheet" type="text/css" href="/map/css/layout.css" >
    <link rel="stylesheet" type="text/css" href="//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.css">
    <script src="/map/js/jquery.js"></script>
    <script src="//kit.fontawesome.com/56b5cc4bd2.js" crossorigin="anonymous"></script><!-- 폰트어썸(아이콘 폰트) 사용 인증된 링크 -->
    <script src="/map/js/jquery-ui-1.10.4.custom.min.js"></script>
</head>
<body>
<div class="container">
    <!-- 모달 레이어 : 장소(업체명)에 대한 상페정보 페이지 -->
    <div class="modal_layer_wrap">
        <div class="layer_box"></div>
    </div>
    <!-- ####### 01. HEADER START ####### -->
    <div class="header_wrap">
        <header>
            <h1 class="logo"><a href="/map/index.jsp">인천광역시(데모체험)</a></h1>
        </header>
        <form>
            <div class="page_search">
                <input type="text" placeholder="검색 키워드/상호명 입력" autofocus><!--
                 --><input type="submit" value="" class="fa fa-search">
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
        </form>
    </div>
    <!-- ####### 01. HEADER END ####### -->
    <hr class="skip"/>
    <!-- ####### 02. LNB START ######### -->
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
        <!-- #### 02-1. 좌측 고정 업종별 아이콘 메뉴 끝 -->
        <hr class="skip"/>
        <script>
            $(function(){
                // 업종별 대메뉴 활성화(class="active") 메뉴버튼 처리
                $("nav ul li:nth-child(1) a").addClass("active");
                // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
                $(".membership li.active a").clone().prependTo(".lnb h2");
                $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
                $(".sub_menu_list li a.active span").clone().appendTo(".page_path");
                $(".right_contents.area ul.summary_card input[type=checkbox]").attr(disabled);
            });
            let activeLinkText = $(".membership li.active a").text();
            $("title").text(activeLinkText);
        </script>
        <!-- #### 02-2. 좌측 on/off 페이지 서브 메뉴 노출 시작 -->
        <div class="lnb">
            <h2><div class="standard_cond"><!--우리동네 숨겨진 핫플레이스 <br/>-->주제별 다양한 장소를 확인하세요</div></h2>
            <!-- 02-2-2.페이지 컨텐츠 서브 메뉴 노출 시작 -->
            <ul class="sub_menu_list area">
                <li><a href="#" class="active"><i class="fa-solid fa-map-location-dot"></i> <span>인천광역시 전체</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-location-dot"></i> <span>연수구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-map-pin"></i> <span>남동구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-location-arrow"></i> <span>부평구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-regular fa-compass"></i> <span>계양구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-location-crosshairs"></i> <span>서구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-map-location-dot"></i> <span>동구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-bookmark"></i> <span>중구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-route"></i> <span>미추홀구</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-circle-info"></i> <span>강화군</span><b class="num">18,562</b></a></li>
                <li><a href="#"><i class="fa-solid fa-tags"></i> <span>옹진군</span><b class="num">18,562</b></a></li>
            </ul>
        </div>
        <!-- #### 02-2 좌측 on/off 페이지 서브 메뉴 노출 끝 -->
    </div>
    <!-- ####### 02. LNB END ########## -->
    <hr class="skip"/>
    <!-- ####### 03. CONTENTS START ####### -->
    <section class="contents_wrap">
        <!-- ########  페이지마다의 고정 서비스 내용이(예, 지도나 모임카드 수정) 들어갑니다. ########### -->
        <div class="left_contents">
<!-- ############################ 카카오맵 지도 연동 시작 ############################### -->
        <jsp:include page = "/map/test_kakao_1.jsp"></jsp:include>
<!-- ############################ 카카오맵 지도 연동 끝 ############################### -->
        </div>
        <!-- #### 03-1.우측 본문 영역 시작 -->
        <div class="right_contents area">
            <div class="page_title">
                <h1><!-- ## 페이지 타이틀 ##  좌측 메뉴 .active 되어 있는 메뉴명 제이쿼리 클론하여 가져옴 --> </h1>
                <!-- ## 페이지 네비 경로 ## -->
                <span class="page_path"> </span>
            </div>
            <div class="paging">
                <a href="#" class="btn_first"></a>
                <a href="#" class="btn_prev"></a>
                <a href="#" class="active">1</a>
                <a href="#">2</a>
                <a href="#">3</a>
                <a href="#">4</a>
                <a href="#">5</a>
                <a href="#" class="btn_next"></a>
                <a href="#" class="btn_last"></a>
            </div>
            <form>
            <div class="card_list_wrap">
                <!-- 추천(조합) 모임카드 #.01 시작 -->
               <dl class="ai_card">
                   <dt class="header">
                        <h2 class="subject_keyword">
                            <span class="area"><b class="depth_1">1</b><b class="depth_2">중구</b></span>
                            <strong>데이트/동인천/차이나타운</strong>
                        </h2>
                        <p class="keyword_recommand"><!-- 연관 키워드 10개 -->
                            <a href="#">고기맛집</a><a href="#">월미도</a><a href="#">신포동</a><a href="#">중구</a><a href="#">숯불</a>
                        </p>
                   </dt>
                   <dd class="body">
                       <!-- 대안 장소 선택_01: 업체 리스트 -->
                       <div class="card_list">
                           <ul class="summary_card">
                               <li class="subject">
                                   <b><span class="matching_keyword">돈비어</span>천가</b>
                                   <span class="category"><b class="depth_1">음식</b><b class="depth_2">한식</b></span>
                               </li>
                               <li class="thumb"><img src="/map/img/sample_store.jpg" alt="돈비어천가"></li>
                               <li class="addr">인천 중구 개항로 63-2</li>
                               <li class="work_time">10:00~22:00브레이크타임없음<span>(쉬는날 : 연중무휴)</span></li>
                               <li class="parking">주차시설 : 있음,유료</li>
                               <li class="tel">032-930-1234</li>
                           </ul>
                           <div class="btn_wrap">
                                <button><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                                <button><i class="fa-solid fa-search"></i></button>
                            </div>
                       </div>
                       <!-- 대안 장소 선택_02: 업체 리스트 -->
                       <div class="card_list">
                           <ul class="summary_card">
                               <li class="subject">
                                   <b>신포국제시장</b>
                                   <span class="category"><b class="depth_1">쇼핑</b><b class="depth_2">전통시장</b></span>
                               </li>
                               <li class="thumb"><img src="/map/img/sample_store1.jpg" alt="신포국제시장"></li>
                               <li class="addr">인천 중구 송현로59번길 5</li>
                               <li class="work_time">10:00~21:00<br>지원센터 09:00~18:00<span class="holyday">(쉬는날 : 매월 첫 주 월요일, 설·추석 당일 / 지원센터 주말 <br>(점포마다 상이함))</span></li>
                               <li class="parking">주차시설 : 있음,무료</li>
                               <li class="tel">032-773-2368</li>
                           </ul>
                           <div class="btn_wrap">
                                <button><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                                <button><i class="fa-solid fa-search"></i></button>
                            </div>
                       </div>
                       <!-- 대안 장소 선택_03: 업체 리스트 -->
                       <div class="card_list">
                           <ul class="summary_card">
                               <li class="subject">
                                   <b>신파시장</b>
                                   <span class="category"><b class="depth_1">쇼핑</b><b class="depth_2">전통시장</b></span>
                               </li>
                               <li class="thumb"><img src="/map/img/sample_store2.jpg" alt="신파시장"></li>
                               
                               <li class="addr">인천 중구 송현로59번길 5</li>
                               <li class="work_time">10:00~21:00<br>지원센터 09:00~18:00<span class="holyday">(쉬는날 : 매월 첫 주 월요일, 설·추석 당일 / 지원센터 주말 <br>(점포마다 상이함))</span></li>
                               <li class="parking">주차시설 : 있음,무료</li>
                               <li class="tel">032-773-2368</li>
                           </ul>
                            <div class="btn_wrap">
                                <button><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                                <button><i class="fa-solid fa-search"></i></button>
                            </div>
                       </div>
                   </dd>
                   <dd class="footer">
                       <button class="basic"><i class="fa-solid fa-location-dot"></i> 지도보기</button>
                       <button class="confirm"><i class="fa-solid fa-pen-to-square"></i> 초대장 만들기</button>
                   </dd>
               </dl>
                <!-- 추천(조합) 모임카드 #.01 끝 -->
                <!-- 추천(조합) 모임카드 #.02 시작 -->
                <dl class="ai_card">
                    <dt class="header">
                        <h2 class="subject_keyword">
                            <span class="area"><b class="depth_1">2</b><b class="depth_2">미추홀구</b></span>
                            <strong>인천/숯불갈비/회식장소</strong>
                        </h2>
                        <p class="keyword_recommand"><!-- 연관 키워드 10개 -->
                            <a href="#">신포동</a><a href="#">중구</a><a href="#">숯불</a><a href="#" class="matching_keyword">돈비어</a><a href="#">돼지갈비</a>
                        </p>
                    </dt>
                    <dd class="body">
                        <!-- 대안 장소 선택_01: 업체 리스트 -->
                        <div class="card_list">
                            <ul class="summary_card">
                                <li class="subject">
                                    <b><span class="matching_keyword">돈비어</span>천가</b>
                                    <span class="category"><b class="depth_1">음식</b><b class="depth_2">한식</b></span>
                                </li>
                                <li class="thumb"><img src="/map/img/sample_store.jpg" alt="돈비어천가"></li>
                                
                                <li class="addr">인천 중구 개항로 63-2</li>
                                <li class="work_time">10:00~22:00브레이크타임없음<span>(쉬는날 : 연중무휴)</span></li>
                                <li class="parking">주차시설 : 있음,유료</li>
                                <li class="tel">032-930-1234</li>
                            </ul>
                            <div class="btn_wrap">
                                <button><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                                <button><i class="fa-solid fa-search"></i></button>
                            </div>
                        </div>
                        <!-- 대안 장소 선택_02: 업체 리스트 -->
                        <div class="card_list">
                            <ul class="summary_card">
                                <li class="subject">
                                    
                                    <b>신포국제시장</b>
                                    <span class="category"><b class="depth_1">쇼핑</b><b class="depth_2">전통시장</b></span>
                                </li>
                                <li class="thumb"><img src="/map/img/sample_store2.jpg" alt="신포국제시장"></li>
                                <li class="addr">인천 중구 송현로59번길 5</li>
                                <li class="work_time">10:00~21:00<br>지원센터 09:00~18:00<span class="holyday">(쉬는날 : 매월 첫 주 월요일, 설·추석 당일 / 지원센터 주말 <br>(점포마다 상이함))</span></li>
                                <li class="parking">주차시설 : 있음,무료</li>
                                <li class="tel">032-773-2368</li>
                            </ul>
                            <div class="btn_wrap">
                                <button><i class="fa-solid fa-solid fa-map-location-dot"></i></button>
                                <button><i class="fa-solid fa-search"></i></button>
                            </div>
                        </div>
                    </dd>
                    <dd class="footer">
                        <button class="basic"><i class="fa-solid fa-location-dot"></i> 지도보기</button>
                       <button class="confirm"><i class="fa-solid fa-pen-to-square"></i> 초대장 만들기</button>
                    </dd>
                </dl>
                <!-- 추천(조합) 모임카드 #.02 끝 -->
            </div>
            </form>
        </div>
        <!-- #### 03-1.우측 본문 영역 끝 -->
    </section>
    <!-- ####### 03. CONTENTS END ####### -->
    <hr class="skip"/>
    <!-- ####### 04. FOOTER START ####### -->
    <div class="footer_wrap">
        <footer>
            <p class="copyright">  © 2025 Root Lab</p>
        </footer>
    </div>
    <a href="#" class="to_top"> 맨위로 </a>
    <!-- ####### 04. FOOTER END ####### -->
</div>
<script src="/map/js/test.js"></script>
</body>
</html>