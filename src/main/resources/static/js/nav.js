// $(function(){
//     console.log("공통 js 시작");
//     // 업종별 대메뉴 활성화(class="active") 메뉴버튼 처리
//     $("nav ul li:nth-child(1) a").addClass("active");
//     // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
//     $(".membership li.active a").clone().prependTo(".lnb h2");
//     //$(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
//     $(".sub_menu_list li a.active span").clone().appendTo(".page_path");
// });



// 2. 좌측 메뉴 > 활성화된 지역메뉴명 > 우측 관광정보 타이틀로 복사
// const menuLinks = document.querySelectorAll('#left-menu > li > a');
// const currentPageTitle = document.getElementById('.right_contents.area > .page_title > h1');

// menuLinks.forEach( ( link ) => {
//     console.log("활성화된 좌측메뉴 > 우측 관광정보 > 타이틀 복사!");
//     link.addEventListener('click', function(event) {  // 각 링크에 'click' 이벤트 리스너를 추가
//         event.preventDefault();                       // a태그 새로고침/페이지 이동 방지
//         const newTitle = this.textContent;            // 'this'는 클릭된 menuLinks --> a요소
//         console.log(newTitle);
//         document.title = newTitle;                    // 페이지의 타이틀을 변경
//         currentPageTitle.textContent = newTitle;      // (추가) 페이지 콘텐츠의 제목도 함께 변경
//     });
// });