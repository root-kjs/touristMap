let memberList=[
  {
    uID: 1,
    tenantId: "T001",
    loginId: "user001",
    companyId: "",
    roleId: "G01",
    groupId: "GR01",
    deptId: "D01",
    userName: "김진숙",
    userPwd: "pass1234",
    userType: 0,
    birth: "",
    gender: 0,
    nationality: 0,
    phone: "01012345678",
    email: "",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-01 10:00:00",
    signUpDate: "2025-06-01 9:00:00",
    withdrawalDate: ""
  },
  {
    uID: 2,
    tenantId: "T001",
    loginId: "user002",
    companyId: "B002",
    roleId: "G02",
    groupId: "GR01",
    deptId: "D02",
    userName: "James hank",
    userPwd: "pass2345",
    userType: 1,
    birth: "",
    gender: 1,
    nationality: 1,
    phone: "01023456789",
    email: "",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-02 14:30:00",
    signUpDate: "2025-06-02 10:00:00",
    withdrawalDate: ""
  },
  {
    uID: 3,
    tenantId: "T001",
    loginId: "user003",
    companyId: "",
    roleId: "G02",
    groupId: "GR01",
    deptId: "",
    userName: "한마음회관",
    userPwd: "pass3456",
    userType: 2,
    birth: "19950303",
    gender: 0,
    nationality: 0,
    phone: "01034567890",
    email: "",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-03 11:20:00",
    signUpDate: "2025-06-03 10:00:00",
    withdrawalDate: ""
  },
  {
    uID: 4,
    tenantId: "T002",
    loginId: "user004",
    companyId: "",
    roleId: "G01",
    groupId: "GR02",
    deptId: "",
    userName: "金雅羅",
    userPwd: "pass4567",
    userType: 0,
    birth: "",
    gender: 1,
    nationality: 1,
    phone: "01045678901",
    email: "",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-02 12:45:00",
    signUpDate: "2025-06-04 11:00:00",
    withdrawalDate: ""
  },
  {
    uID: 5,
    tenantId: "T002",
    loginId: "user005",
    companyId: "B005",
    roleId: "G01",
    groupId: "GR02",
    deptId: "",
    userName: "한재용",
    userPwd: "pass5678",
    userType: 1,
    birth: "19970707",
    gender: 0,
    nationality: 0,
    phone: "01056789012",
    email: "",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-01 13:15:00",
    signUpDate: "2025-06-05 13:00:00",
    withdrawalDate: ""
  },
  {
    uID: 6,
    tenantId: "T002",
    loginId: "user006",
    companyId: "",
    roleId: "G02",
    groupId: "GR02",
    deptId: "D02",
    userName: "이순신",
    userPwd: "pass6789",
    userType: 2,
    birth: "",
    gender: 1,
    nationality: 0,
    phone: "01067890123",
    email: "user006@example.com",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-01 15:40:00",
    signUpDate: "2025-06-06 10:00:00",
    withdrawalDate: ""
  },
  {
    uID: 7,
    tenantId: "T003",
    loginId: "user007",
    companyId: "",
    roleId: "G03",
    groupId: "GR01",
    deptId: "D05",
    userName: "유관순",
    userPwd: "pass7890",
    userType: 0,
    birth: "19800229",
    gender: 0,
    nationality: 0,
    phone: "01078901234",
    email: "user007@example.com",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-03 08:00:00",
    signUpDate: "2025-06-07 08:00:00",
    withdrawalDate: ""
  },
  {
    uID: 8,
    tenantId: "T003",
    loginId: "user008",
    companyId: "B008",
    roleId: "G02",
    groupId: "GR03",
    deptId: "D01",
    userName: "김진숙",
    userPwd: "12345678",
    userType: 1,
    birth: "19991231",
    gender: 1,
    nationality: 0,
    phone: "01089012345",
    email: "user008@example.com",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-02 09:10:00",
    signUpDate: "2025-06-08 09:30:00",
    withdrawalDate: ""
  },
  {
    uID: 9,
    tenantId: "T001",
    loginId: "user009",
    companyId: "",
    roleId: "G01",
    groupId: "GR01",
    deptId: "D02",
    userName: "김구",
    userPwd: "pass9012",
    userType: 0,
    birth: "20000202",
    gender: 0,
    nationality: 0,
    phone: "01090123456",
    email: "user009@example.com",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-03 11:45:00",
    signUpDate: "2025-06-09 11:00:00",
    withdrawalDate: ""
  },
  {
    uID: 10,
    tenantId: "T002",
    loginId: "user010",
    companyId: "",
    roleId: "G03",
    groupId: "GR02",
    deptId: "D03",
    userName: "녹십자회",
    userPwd: "pass0123",
    userType: 2,
    birth: "19860909",
    gender: 1,
    nationality: 0,
    phone: "01001234567",
    email: "user010@example.com",
    userImg: "",
    agree: 1,
    lastLoginDate: "2025-07-01 16:00:00",
    signUpDate: "2025-06-10 14:00:00",
    withdrawalDate: ""
  }
]
//1. JASON호출_localStorage
function getUsers(){  console.log( 'JASON호출_localStorage' );
    let memberList = localStorage.getItem( 'memberList' )

    if( memberList == null ){
        memberList = [];
    }else{
        memberList = JSON.parse( memberList ); 
    }
    return memberList;
}

// 2. JASON저장_localStorage
function setUsers( memberList ){  console.log( ' JASON저장_localStorage' ); 
    localStorage.setItem('memberList', JSON.stringify( memberList ) )
}

//2. JASON호출_ssessionStorage
function getLoginInfo(){  console.log( 'JASON호출_ssessionStorage' );

    let loginUser = sessionStorage.getItem( 'loginUser' ); //로긴정보 가져오기
    if( loginUser == null ){
        loginUser = {};
    }else{
        loginUser = JSON.parse( loginUser ); 
    }
    return loginUser;
    
}

function userInfo( loginId ){   //console.log( '!회원정보 출력함수 >>> userInfo(loginId) exe' ); 
 
  let memberList = getUsers(); // 회원목록 로컬스토리지 호출

    for( let i = 0; i <= memberList.length - 1; i++ ){
        let member = memberList[i]; 
        if( loginId === member.loginId ){ 
          return member;  
        }
    }// for end.

} // userInfo( loginId ) end.

//1. JASON호출_localStorage
function getLoginUser(){  console.log( 'JASON호출_sessionStorage' );
    let loginUser = sessionStorage.getItem( 'loginUser' )

    if( loginUser == null ){
        loginUser = [];
    }else{
        loginUser = JSON.parse( loginUser ); 
    }
    return loginUser;
}

// 2. JASON저장_localStorage
function setLoginUser( loginUser ){  console.log( ' JASON저장_sessionStorage' ); 
    sessionStorage.setItem('loginUser', JSON.stringify( loginUser ) )
}
