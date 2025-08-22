<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<body>
<div id="container">
    <!-- header start -->
    <header>
        <div class="logoHeader">
            <span class="menuIcon" aria-label="전체메뉴" >
                <svg viewBox="0 0 24 24" fill="none" xmlns="//www.w3.org/2000/svg" data-seed-icon="true" data-seed-icon-version="0.0.23" width="24" height="24"><g><g><path d="M2 4C2 3.44772 2.44772 3 3 3H21C21.5523 3 22 3.44772 22 4C22 4.55228 21.5523 5 21 5H3C2.44772 5 2 4.55228 2 4Z" fill="currentColor"></path><path d="M2 12C2 11.4477 2.44772 11 3 11H21C21.5523 11 22 11.4477 22 12C22 12.5523 21.5523 13 21 13H3C2.44772 13 2 12.5523 2 12Z" fill="currentColor"></path><path d="M3 19C2.44772 19 2 19.4477 2 20C2 20.5523 2.44772 21 3 21H21C21.5523 21 22 20.5523 22 20C22 19.4477 21.5523 19 21 19H3Z" fill="currentColor"></path></g></g></svg>
            </span>
            <a href="/admin/dashboard/" class="logo"><strong>Root.Lab</strong><span>소상공인 비즈니스 플랫폼</span></a>
        </div>
        <div class="gnb">
            <div class="headerSearch">
                <form action="#" method="get">
                    <svg width="20px" height="20px" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
                    <path d="M10 17C13.866 17 17 13.866 17 10C17 6.13401 13.866 3 10 3C6.13401 3 3 6.13401 3 10C3 13.866 6.13401 17 10 17Z" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    <path d="M20.9992 21L14.9492 14.95" stroke="#000000" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round"/>
                    </svg>
                    <input type="text" name="search" placeholder="메뉴/기능 검색" aria-label="검색어 입력">
                    <button type="submit" class="searchMdule">검색</button>
                </form>
            </div>
            <nav>
                <ul>
                    <li><a href="/admin/plan/index.jsp">구독플랜관리</a></li>
                    <li><a href="/admin/subscription/index.jsp">구독관리</a></li>
                    <li class="active"><a href="/admin/member/index.jsp">회원관리</a></li>
                    <li><a href="/admin/siteInfo/index.jsp">사이트관리</a></li>
                    <li><a href="/admin/mapData/index.jsp">지도데이터관리</a></li>
                </ul>
            </nav>
            <ul class="memberMenu">
                <li><a href="/admin/member/index.jsp" onclick=""><b>김진숙</b><span>(admin)</span></a></li>
                <li><a href="#" onclick="">로그아웃</a></li>
                <li><a href="/index.jsp" target="_blank" class="btn">홈페이지</a></li>
            </ul>
        </div>
    </header>