$(function(){
    // 업종별 대메뉴 활성화(class="active") 메뉴버튼 처리
    $("nav ul li:nth-child(1) a").addClass("active");
    // 사용자가 선택한 메뉴 활성화(class="active")에 따른 페이지 메뉴명 제이쿼리 변경 처리
    $(".membership li.active a").clone().prependTo(".lnb h2");
    $(".sub_menu_list li a.active").clone().prependTo(".right_contents h1");
    $(".sub_menu_list li a.active span").clone().appendTo(".page_path");
});
let activeLinkText = $(".membership li.active a").text();
$("title").text(activeLinkText);