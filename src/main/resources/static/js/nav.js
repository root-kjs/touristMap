// $(function(){
//     console.log("공통 js 시작");
//     // 업종별 대메뉴 활성화(class="active") 메뉴버튼 처리
//     $("nav ul li:nth-child(1) a").addClass("active");
//     // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
//     $(".membership li.active a").clone().prependTo(".lnb h2");
//     //$(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
//     $(".sub_menu_list li a.active span").clone().appendTo(".page_path");
// });


// 1. 필요한 HTML 요소들을 선택합니다.
const menuLinks = document.querySelectorAll('#left-menu a');
const currentPageTitle = document.getElementById('current-page-title');

// 2. 각 메뉴 링크(<a>)에 대해 반복 작업을 수행합니다.
menuLinks.forEach( (link) => {
    // 3. 각 링크에 'click' 이벤트 리스너를 추가합니다.
    link.addEventListener('click', function(event) {
        
        event.preventDefault(); // <a> 태그 새로고침/페이지 이동 방지
        const newTitle = this.textContent; // 'this'는 클릭된 menuLinks --> a요소
        
        // 5. 페이지의 타이틀을 변경합니다.
        document.title = newTitle;
        
        // (추가) 페이지 콘텐츠의 제목도 함께 변경해줍니다.
        currentPageTitle.textContent = newTitle;
    });
});


let activeLinkText = $(".membership li.active a").text();
$("title").text(activeLinkText);