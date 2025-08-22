<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset='utf-8'>
    <title>관리자로그인 - Root.Lab(소상공인 비즈니스 플랫폼)</title>
    <meta name="Description" content="루트랩은 소상공인 비즈니스에 꼭 필요한 기능만 간편하게 제공합니다."/>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <link rel='stylesheet' type='text/css' media='screen' href='/admin/css/reset.css'>
    <link rel='stylesheet' type='text/css' media='screen' href='/admin/css/login.css'>
    <link rel="shortcut icon" href="/admin/img/favicon.ico" type="image/x-icon">
    <link rel="apple-touch-icon" sizes="180x180" href="/admin/img/apple-touch-icon.png">
<body>
<div id="container">
    <header>
        <h1 class="logo">
            <a href="/index.jsp" title="Root.Lab 홈으로 이동">
                <strong class="logo">Root.Lab</strong><span>소상공인 비즈니스 플랫폼</span>
            </a>
        </h1>
    </header>
    <!-- /admin/header end -->
    <main>
        <div class="loginWrap">
            <h2>관리자 로그인</h2>
            <!-- 로그인 입력폼 시작 -->
            <form action="#" method="post">
                <section>
                    <input type="text" id="loginIDInput" name="loginIDInput" required placeholder="아이디">
                    <input type="text" id="pwdInput" name="pwdInput" required placeholder="비밀번호">
                    <button type="submit" class="selected" onclick="location.href='/admin/member/index.jsp'">LOGIN</button>
                </section>
            <!-- 로그인 입력폼 끝 -->
                <section>
                    <a href="#" onclick="alert('준비중입니다.');">아이디 찾기</a>
                    <a href="#" onclick="alert('준비중입니다.');">비밀번호 찾기</a>
                </section>
            </form>
        </div>
    </main>
    <!-- /admin/footer start -->
    <footer>
        <ul class="footerMenu">
            <li><a href="/index.jsp" title="Root.Lab 홈으로 이동">Root.Lab</a></li>
            <li><a href="#" onclick="alert('준비중입니다.');">솔루션문의</a></li>
            <li><a href="#" onclick="alert('준비중입니다.');">구독신청</a></li>
        </ul>
        <small>&copy; 2025 Root.Lab</small>
    </footer>
    <!-- footer end -->
</div>
<!-- container end -->
<script src='/admin/js/nav.js'></script>
<script src='/admin/js/login.js'></script>
</body>
</html>