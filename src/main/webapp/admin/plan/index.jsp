<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<jsp:include page = "/admin/head.jsp"></jsp:include>
<link rel='stylesheet' type='text/css' media='screen' href='/admin/css/user.css'>
<jsp:include page = "/admin/header.jsp"></jsp:include>
<!-- header end -->
<jsp:include page = "/admin/aside.jsp"></jsp:include>
    <!-- aside(lnb) end -->
    <!-- main start -->
     <div class="temp"></div>
    <main id="membersStatus">
        <!-- 페이지 타이틀 시작 -->
        <div class="pageTitle">
            <h1>
                <!-- <svg fill="#000000" width="25px" height="25px" viewBox="0 0 1000 1000" xmlns="http://www.w3.org/2000/svg"><path d="M738 756q-45-77-131-205-6-8-14-15-2-2-1.5-4.5t2.5-3.5q60-29 97-83 40-58 40-124 0-63-31-116t-84-84-116-31-116 31-84 84-31 116q0 66 40 124 37 54 97 83 2 1 2.5 3.5T407 536q-8 7-14 15-88 130-131 205-18 32-18 52 0 27 34.5 50.5t93 37.5T500 910t128.5-14 93-37.5T756 808q0-21-18-52z"/></svg> -->
                <span>회원현황</span>
            </h1>
            <span class="path">
                <a href="/admin/plan/index.jsp">구독플랜관리</a>
                <a href="/admin/plan/index.jsp">구독플랜현황</a>
            </span>
        </div>
        <!-- 페이지 타이틀 끝 -->
        <div class="bothWrap">
            <!-- R.검색/목록 시작 -->
            <section class="listWrap">
                <!-- 상세 검색창 시작 -->
                <div class="detailSearch">
                    <form action="#" method="get">
                        <label for="memberTypeInput"><b>회원유형</b>
                            <select class="memberTypeInput">
                                <option value="" selected>전체</option>
                                <option value="1">일반회원</option>
                                <option value="2">사업자</option>
                                <option value="3">단체/모임</option>
                            </select>
                        </label>
                        <label for="subsStatusInput"><b>구독상태</b>
                            <select class="subsStatusInput">
                                <option value="" selected>전체</option>
                                <option value="1">무료체험</option>
                                <option value="2">구독중</option>
                                <option value="3">구독취소</option>
                            </select>
                        </label>
                        <label for="periodInput"><b>검색기간</b>
                                <select class="baseDateInput">
                                <option value="1" selected>가입일기준</option>
                                <option value="2">최종로그인</option>
                            </select>
                            <input class="startDay" type="date" placeholder="시작일" /> ~ <input class="endDay" type="date" placeholder="종료일" />
                            <select class="baseDateInput">
                                <option value="1" selected>최근1주</option>
                                <option value="2">최근1달</option>
                                <option value="">전체</option>
                            </select>
                        </label>
                        <label for="nameInput"><b>회원명</b><input class="nameInput" type="text" placeholder="회원명" /></label>
                        <label for="loginIdInput"><b>로그인ID</b><input class="loginIdInput" type="text" placeholder="로그인ID" /></label>
                        <label for="phoneInput"><b>휴대전화</b><input class="phoneInput" type="number" placeholder="휴대폰번호" /></label>
                        <button type="submit" class="searchMembers">검색</button>
                    </form>
                </div>
                <!-- 상세 검색창 끝 -->
                <!-- 목록 테이블 시작 -->
                <ul class="titleBox">
                    <li class="result">검색결과 : 127명</li>
                    <li class="btnBox">
                        <select class="baseDateInput">
                            <option value="1" selected>10개 보기</option>
                            <option value="2">30개 보기</option>
                            <option value="">50개 보기</option>
                        </select>
                        <button type="button" class="btn line">엑셀 다운로드</button>
                    </li>
                </ul>
                <div class="tableWrap">
                    <table>
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>회원유형</th>
                                <th>회원명</th>
                                <th>로그인ID</th>
                                <th>구독상태</th>
                                <th>휴대전화</th>
                                <th>가입일</th>
                                <th>최종로그인</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="active">
                                <td>10</td>
                                <td>회원유형</td>
                                <td><a href="#">김진숙</a></td>
                                <td>로그인ID</td>
                                <td>구독상태</td>
                                <td>휴대전화</td>
                                <td>가입일</td>
                                <td>최종로그인</td>
                            </tr>
                            <tr>
                                <td>9</td>
                                <td>회원유형</td>
                                <td><a href="#">한재웅</a></td>
                                <td>로그인ID</td>
                                <td>구독상태</td>
                                <td>휴대전화</td>
                                <td>가입일</td>
                                <td>최종로그인</td>
                            </tr>
                            <tr>
                                <td>8</td>
                                <td>회원유형</td>
                                <td><a href="#">김진화</a></td>
                                <td>로그인ID</td>
                                <td>구독상태</td>
                                <td>휴대전화</td>
                                <td>가입일</td>
                                <td>최종로그인</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <!-- 목록 테이블 끝 -->
            </section>
            <!-- R.검색/목록 끝 -->
            <!-- CUD.등록/수정 시작 -->
            <section class="registWrap">
                <!-- CUD.타이틀/버튼 시작 -->
                <div class="titleBox">
                    <ul class="tabtitle">
                        <li class="active">일반회원</li>
                        <li>사업자</li>
                        <li>단체/모임</li>
                    </ul>
                    <span class="btnBox">
                        <button type="button" class="btn line" onclick="">비밀번호초기화</button>
                        <button type="button" class="btn full" onclick="usersAdd()">신규회원등록</button>
                        <button type="submit" onclick="usersEdit()">저장</button>
                    </span>
                </div>
                <!-- CUD.타이틀/버튼 끝 -->
                <!-- CUD.입/출력단 시작 -->
                <div class="formWrap">
                    <form action="#" method="post" id="userForm">
                        <fieldset>
                            <label for="memberTypeInput"><b>회원유형</b>
                                <select class="memberTypeInput">
                                    <option value="1">일반회원</option>
                                    <option value="2" selected>사업자</option>
                                    <option value="3">단체/모임</option>
                                </select>
                            </label>
                            <label class="subsStatusInput"><b>구독상태</b>
                                <select class="subsStatusInput">
                                    <option value="1">무료체험</option>
                                    <option value="2" selected>구독중</option>
                                    <option value="3">구독취소</option>
                                </select>
                            </label><br/>
                            <label for="nameInput"><b>회원명</b><input class="nameInput" type="text" required placeholder="회원명" disabled/></label>
                            <label for="loginIdInput"><b>로그인ID</b><input class="loginIdInput" type="text" disabled placeholder="로그인ID" /></label><br/>
                            <label for="phoneInput"><b>휴대전화</b><input class="phoneInput" type="number" required placeholder="휴대폰번호" /></label>
                            <label for="emailInput"><b>이메일</b><input type="text" class="emailInput" name="emailInput" required placeholder="이메일" /></label>
                            <label for="birthInput"><b>생년월일</b><input type="number" class="birthInput" name="birthInput" placeholder="생년월일 8자리" /></label>
                            <span>
                            <label for="genderMaleInput"><b>성별/구분</b>
                                <select class="genderInput">
                                    <option value="1">남성</option>
                                    <option value="2">여성</option>
                                </select>
                                <select id="genderMaleInput">
                                    <option value="1" selected>내국인</option>
                                    <option value="3">외국인</option>
                                </select>
                            </label>
                            </span>
                            <label for="zipCodeBtn"><b>기본주소</b>
                                <button type="button" id="zipCodeBtn">우편번호</button>
                                <input type="text" id="zipCodeInput" name="zipCodeInput" placeholder="우편번호" />
                                <input type="text" id="addrInput" name="addrInput" placeholder="주소" /><br/><b></b>
                                <input type="text" id="addrDetailInput" name="addrDetailInput" placeholder="상세주소" />
                            </label>
                            <label for="memoInput"><b>이슈/메모</b><textarea class="memoInput" placeholder="이슈/메모" ></textarea></label>
                        </fieldset>
                    </form>
                    <p><b>최종로그인  </b>2025-07-30(12:50) / <b>가입일  </b>2025-07-10(09:50)</p>
                </div>
                <!-- CUD.입/출력단 시작 -->
            </section>
            <!-- CUD.등록/수정 끝 -->
        </div>
        <!-- R.상세정보 조회시작 -->
        <section class="detaiViewWrap">
            <!-- R.타이틀/버튼 시작 -->
            <div class="titleBox">
                <ul class="tabtitle">
                    <li class="active">구독내역</li>
                    <li>결제내역</li>
                    <li>문의내역</li>
                    <li>로그내역</li>
                </ul>
                <span class="btnBox">
                    <button type="button" class="btn line" onclick="alert('준비중입니다.')">이메일발송</button>
                    <button type="button" class="btn full" onclick="alert('준비중입니다.')">알림톡발송</button>
                </span>
            </div>
            <div class="viewWrap">
                <div class="commingSoon">준비중입니다.</div>
            </div>
            <!-- R.타이틀/버튼 끝 -->
        </section>
        <!-- R.상세정보 끝 -->
    </main>
    <!-- main end -->
    <!-- footer start -->
    <jsp:include page = "/admin/footer.jsp"></jsp:include>
