#. 데이터베이스 초기화 및 설정
DROP DATABASE IF EXISTS k_tour_map;
CREATE DATABASE k_tour_map
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
USE k_tour_map;
SET sql_safe_updates = 0; -- mysql workbench : safeMode 해제(끄기 0 / 켜기 1)
# ==================================================== 테이블 생성 ====================================================
-- # 01. 법정동코드 TABLE : 전국 행정구역 및 주소에 대한 기준 정보를 관리---------------------------------------------------------
CREATE TABLE region_master (
    legalCode CHAR(10) PRIMARY KEY,                                             -- 1. [pk]법정동코드 (10자리)
    addressName VARCHAR(255) NOT NULL,                                          -- 2. 법정동코드에 해당하는 주소명
    latitude DECIMAL(9, 6),                                                     -- 3. 위도 (전체 9자리, 소수점 6자리)
    longitude DECIMAL(10, 6)                                                    -- 4. 경도 (전체 10자리, 소수점 6자리)
);

-- # 02. 관심분야 TABLE : 회원이 선택할 수 있는 관심 분야(카테고리)의 기준 정보를 관리-----------------------------------------------
CREATE TABLE item_master (
    itemNo SMALLINT AUTO_INCREMENT PRIMARY KEY,                                 -- 1. [pk]관심분야 고유번호
    itemName VARCHAR(50) NOT NULL UNIQUE                                        -- 2. 관심분야명 (예: 'IT/개발', '디자인')
);

-- # 03. 관심키워드 TABLE : 트렌드를 반영한 인기 검색어 또는 태그의 기준 정보를 관리-------------------------------------------------
CREATE TABLE keyword_master (
    keywordNo MEDIUMINT AUTO_INCREMENT PRIMARY KEY,                             -- 1. [pk]관심키워드 고유번호
    keyword VARCHAR(50) NOT NULL UNIQUE                                         -- 2. 관심키워드 (예: 'AI', '데이터 분석')
);

-- # 04. 본사회원 기본정보 TABLE : 서비스에 가입한 모든 회원(무료/유료)의 기본 로그인 정보를 관리---------------------------------------
CREATE TABLE member_head(
    mNo BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),                -- 1. [pk]회원번호(시간순 UUID로 인덱스 성능 고려)
    mId VARCHAR(15) NOT NULL UNIQUE,                                            -- 2. 로그인 아이디
    mPwd CHAR(20) NOT NULL,                                                     -- 3. 로그인 비밀번호(*추후 SHA-256 암호화 진행 예정 )
    mNick VARCHAR(15),                                                          -- 4. 닉네임
    mGender ENUM('남', '여') DEFAULT NULL,                                        -- 5. 성별(남/여)
    mEmail VARCHAR(50) UNIQUE NOT NULL,                                         -- 6. 이메일
    mTermsAgreed BOOLEAN DEFAULT FALSE NOT NULL,                                -- 7. 이용약관(FALSE(0):미동의 / TRUE(1):동의)
    mCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                              -- 8. 가입일시
    mUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,  -- 9. 수정일시
    mdeletedAt DATETIME NULL                                                    -- 10. 탈퇴일시(null이면 활성회원)
);

-- # 05. 본사회원 관심지역 LOG TABLE : 회원이 등록한 관심 지역 정보를 기록 (다대다 관계)---------------------------------------------
CREATE TABLE member_favorite_region (
	mfaNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                              -- 1. [pk]관심지역 로그 번호
    mNo BINARY(16),                                                             -- 2. [fk]회원번호
    legalCode CHAR(10),                                                         -- 3. [fk]법정동코드
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL,
    FOREIGN KEY (legalCode) REFERENCES region_master(legalCode) ON DELETE SET NULL
);

-- # 06. 본사회원 관심분야 LOG TABLE : 회원이 등록한 관심 분야 정보를 기록 (다대다 관계)---------------------------------------------
CREATE TABLE member_favorite_item (
	mfiNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                              -- 1. [pk]관심분야 로그 번호
    mNo BINARY(16),                                                             -- 2. [fk]회원번호
    itemNo SMALLINT,                                                            -- 3. [fk]관심분야 고유번호
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL,
    FOREIGN KEY (itemNo) REFERENCES item_master(itemNo) ON DELETE SET NULL
);

-- # 07. 본사회원 관심키워드 LOG TABLE : 회원이 등록한 관심 키워드 정보를 기록 (다대다 관계)-------------------------------------------
CREATE TABLE member_favorite_keyword (
	mfkNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                              -- 1. [pk]관심키워드 로그 번호
    mNo BINARY(16),                                                             -- 2. [fk]회원번호
    keywordNo MEDIUMINT,                                                        -- 3. [fk]관심키워드 고유번호
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL,
    FOREIGN KEY (keywordNo) REFERENCES keyword_master(keywordNo) ON DELETE SET NULL
);

-- # 08. 본사회원 추가정보 TABLE : 유료 회원의 상세 개인 정보를 관리---------------------------------------------------------------
CREATE TABLE paid_member_head(
    pmNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                               -- 1. [pk]유료회원 정보 번호
	mNo BINARY(16) UNIQUE,                                                      -- 2. [fk]본사 회원 번호
    pmType TINYINT UNSIGNED NOT NULL,                                           -- 3. 회원유형(1.일반회원/2.사업자/3.단체/협회)
    pmName VARCHAR(30) NOT NULL,                                                -- 4. 이름
    pmBirth DATE NOT NULL,                                                      -- 5. 생년월일(8자리)
    pmGender ENUM('남', '여') DEFAULT NULL,                                        -- 6. 성별(남/여)
    pmPhone VARCHAR(16) NOT NULL UNIQUE,                                        -- 7. 휴대폰번호
    pmNationality ENUM('내국인', '외국인') DEFAULT '내국인',                      -- 8. 구분(내국인/외국인)
    pmTermsAgreed BOOLEAN DEFAULT FALSE NOT NULL,                               -- 9. 추가이용약관(0_FALSE:미동의, 1_TRUE:동의)
    pmCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 10. 최초등록일시
    pmUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 11. 수정일시
	FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL
);

-- # 09. 본사회원 사업자정보 TABLE : 사업자 유형 회원의 사업자 관련 정보를 관리-------------------------------------------------------
CREATE TABLE business_info (
    biNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                               -- 1. [pk]사업자 정보 번호
    mNo BINARY(16) UNIQUE,                                                      -- 2. [fk]본사 회원 번호
    biCompanyName VARCHAR(50) NOT NULL,                                         -- 3. 상호명
    biCeoName VARCHAR(30) NOT NULL,                                             -- 4. 대표자명
    biBusinessNumber VARCHAR(12) NOT NULL UNIQUE,                               -- 5. 사업자등록번호 (예: 123-45-67890)
    biCorpNumber VARCHAR(14) UNIQUE,                                            -- 6. 법인등록번호 (예: 110111-1234567)
    biIndustry VARCHAR(100),                                                    -- 7. 업태
    biBusinessType VARCHAR(100),                                                -- 8. 업종
    biAddress VARCHAR(255),                                                     -- 9. 사업장 주소
    biMailOrderNumber VARCHAR(20),                                              -- 10. 통신판매업신고번호(예: 2025-XX-XXXX)
    biTel VARCHAR(20),                                                          -- 11. 대표 전화
    biCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 12. 생성 일시
    biUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 13. 수정 일시
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL
);

-- # 10. 본사회원 단체/협회정보 TABLE : 단체/협회 유형 회원의 상세 정보를 관리-------------------------------------------------------
CREATE TABLE association_info (
    aiNo SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                          -- 1. [pk]단체/협회 정보 번호
    mNo BINARY(16) UNIQUE,                                                      -- 2. [fk]본사 회원 번호
    aiOrgName VARCHAR(50) NOT NULL,                                             -- 3. 단체/협회명
    aiRepresentativeName VARCHAR(30) NOT NULL,                                  -- 4. 대표자명
    aiOrgNumber VARCHAR(20) NOT NULL UNIQUE,                                    -- 5. 고유번호 (예: 비영리민간단체 등록번호)
    aiOrgType VARCHAR(50),                                                      -- 6. 단체 유형 (예: 사단법인, 비영리단체)
    aiActivityField VARCHAR(100),                                               -- 7. 활동 분야 (예: 사회복지, 문화예술)
    aiAddress VARCHAR(255),                                                     -- 8. 소재지 주소
    aiTel VARCHAR(20),                                                          -- 9. 대표 전화
    aiEstablishmentDate DATE,                                                   -- 10. 설립일
    aiCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 11. 생성 일시
    aiUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 12. 수정 일시
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL
);

-- # 11. 구독플랜 TABLE : 회원이 구독할 수 있는 서비스 플랜의 종류와 가격 정보를 관리--------------------------------------------------
CREATE TABLE subscription_plan(
    spNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                               -- 1. [pk]구독플랜번호
    spName VARCHAR(20) NOT NULL UNIQUE,                                         -- 2. 구독플랜명
    spDurationUnit ENUM('DAY', 'MONTH', 'YEAR') DEFAULT 'MONTH',                -- 3. 구독기간 단위
    spDurationValue TINYINT UNSIGNED DEFAULT 1,                                 -- 4. 구독기간 값
    spPrice DECIMAL(10, 2) UNSIGNED DEFAULT 0,                                  -- 5. 금액(소수점 2자리까지)
    spCurrency CHAR(3) DEFAULT 'KRW' NOT NULL,                                 -- 6. 통화코드 (ISO 4217, 예: KRW, USD)
    spDescription LONGTEXT NOT NULL,                                            -- 7. 플랜 설명
    spIsActive BOOLEAN DEFAULT FALSE NOT NULL,                                  -- 8. 플랜 활성화 여부
    spCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 9. 생성일시
    spUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  -- 10. 수정일시
);

-- # 12. 구독자 사이트정보 TABLE : 구독한 회원이 운영하는 개별 사이트의 기본 정보를 관리-------------------------------------------------
CREATE TABLE site_info (
    siNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                               -- 1. [pk]사이트 번호
    mNo BINARY(16) UNIQUE,                                                      -- 2. [fk]본사 회원 번호
    siName VARCHAR(50) NOT NULL UNIQUE,                                         -- 3. 사이트명
    siDomain VARCHAR(100) NOT NULL UNIQUE,                                      -- 4. 도메인명(URL)
    siIntro VARCHAR(255),                                                       -- 5. 사이트 소개글
    siLogo VARCHAR(255),                                                        -- 6. 사이트 로고 이미지 URL
    siFavicon VARCHAR(255),                                                     -- 7. 파비콘 이미지 URL
    siTel VARCHAR(20),                                                          -- 8. 대표 전화
    siPrivacyOfficer VARCHAR(30),                                               -- 9. 개인정보 처리 책임자
    siEmail VARCHAR(100),                                                       -- 10. 이메일
    siKeywords VARCHAR(255),                                                    -- 11. 사이트 검색 키워드 (콤마로 구분)
    siIsPublic TINYINT(1) DEFAULT 0,                                            -- 12. 사이트 공개 여부 (0:비공개, 1:공개)
    siCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 13. 생성 일시
    siUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 14. 수정 일시
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL
);

-- # 13. 구독로그 TABLE : 회원의 구독 신청, 변경, 만료 등 모든 이력을 기록-----------------------------------------------------------
CREATE TABLE subscription_log (
    slNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                               -- 1. [pk]로그 번호
    mNo BINARY(16),                                                             -- 2. [fk]본사 회원 번호
    spNo INT UNSIGNED,                                                          -- 3. [fk]구독 플랜 번호
    slRecordedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                            -- 4. 기록일시
    slRecordedId VARCHAR(50) DEFAULT NULL,                                      -- 5. 로그 관리자 ID
    slCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                             -- 6. 신청일시
    slEndedAt DATETIME NULL,                                                    -- 7. 종료일시
    FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE SET NULL,
    FOREIGN KEY (spNo) REFERENCES subscription_plan(spNo) ON DELETE SET NULL
);

# ======================================== # 샘플 데이터 삽입 ==============================================================
-- 회원 UUID 미리 정의 (연관 테이블에서 일관성 있게 사용하기 위함)
SET @member_01_uuid = '01889895-c9e8-466d-a19e-e5e347895e54';
SET @member_02_uuid = '01889896-1a2b-487e-89f0-123456789abc';
SET @member_03_uuid = 'a1b2c3d4-e5f6-4123-89ab-cdef12345678';
SET @member_04_uuid = 'b2c3d4e5-f6a1-4bcd-9abc-def123456789';
SET @member_05_uuid = 'c3d4e5f6-a1b2-4cde-aabb-ef1234567890';
SET @member_06_uuid = 'd4e5f6a1-b2c3-4def-bbaa-f12345678901';
SET @member_07_uuid = 'e5f6a1b2-c3d4-4efa-ccdd-123456789012';
SET @member_08_uuid = 'f6a1b2c3-d4e5-4fab-ddee-234567890123';
SET @member_09_uuid = 'a1b2c3d4-e5f6-4123-89ab-345678901234';
SET @member_10_uuid = 'b2c3d4e5-f6a1-4bcd-9abc-456789012345';

-- # 01. 법정동코드 TABLE 데이터
INSERT INTO region_master (legalCode, addressName, latitude, longitude) VALUES
('1111010100', '서울특별시 종로구 청운동', 37.587132, 126.969533),
('1168010100', '서울특별시 강남구 역삼동', 37.500644, 127.036369),
('2644010100', '부산광역시 강서구 대저1동', 35.211769, 128.981731),
('2729011500', '대구광역시 달서구 상인동', 35.818838, 128.540119),
('2823710100', '인천광역시 부평구 부평동', 37.493839, 126.723899),
('2920010100', '광주광역시 북구 중흥동', 35.168505, 126.914165),
('3011010100', '대전광역시 동구 원동', 36.328394, 127.437582),
('3114010100', '울산광역시 남구 신정동', 35.540841, 129.315895),
('4128110100', '경기도 고양시 덕양구 주교동', 37.658611, 126.831944),
('5013010100', '제주특별자치도 제주시 이도일동', 33.510414, 126.521667);

-- # 02. 관심분야 TABLE 데이터
INSERT INTO item_master (itemName) VALUES
('관광'), ('전시'), ('자연'), ('레저'), ('쇼핑'), ('음식'), ('숙박');

-- # 03. 관심키워드 TABLE 데이터
INSERT INTO keyword_master (keyword) VALUES
('고궁투어'), ('미술관'), ('둘레길'), ('서핑'), ('미슐랭'),('AI'), ('한옥'), ('농촌체험'), ('템플스테이'), ('BTS'), ('역사탐방'), ('문화예술'),
('자연/생태'), ('레저/스포츠'), ('쇼핑/맛집'),('IT/테크'), ('건축/디자인'), ('교육/체험'), ('웰니스/힐링'), ('K-POP/한류');

-- # 04. 본사회원 기본정보 TABLE 데이터
INSERT INTO member_head (mNo, mId, mPwd, mNick, mGender, mEmail, mTermsAgreed, mCreatedAt, mUpdatedAt, mdeletedAt) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), 'user01', 'pwd01', '여행가1', '남', 'user01@email.com', TRUE, '2023-01-10 10:00:00', '2023-01-10 10:00:00', NULL),
(UUID_TO_BIN(@member_02_uuid, 1), 'user02', 'pwd02', '역사매니아', '여', 'user02@email.com', TRUE, '2023-02-15 11:30:00', '2023-05-10 14:00:00', NULL),
(UUID_TO_BIN(@member_03_uuid, 1), 'user03', 'pwd03', '맛집탐험가', '남', 'user03@email.com', TRUE, '2023-03-20 14:00:00', '2023-03-20 14:00:00', NULL),
(UUID_TO_BIN(@member_04_uuid, 1), 'user04', 'pwd04', '산악인', '여', 'user04@email.com', TRUE, '2023-04-05 18:45:00', '2023-04-05 18:45:00', NULL),
(UUID_TO_BIN(@member_05_uuid, 1), 'user05', 'pwd05', '예술사랑', '남', 'user05@email.com', TRUE, '2023-05-11 09:20:00', '2023-05-11 09:20:00', NULL),
(UUID_TO_BIN(@member_06_uuid, 1), 'user06', 'pwd06', '비즈니스트래블', '여', 'user06@email.com', TRUE, '2023-06-22 13:10:00', '2023-06-22 13:10:00', NULL),
(UUID_TO_BIN(@member_07_uuid, 1), 'user07', 'pwd07', '협회담당자', '남', 'user07@email.com', TRUE, '2023-07-01 16:00:00', '2023-07-01 16:00:00', NULL),
(UUID_TO_BIN(@member_08_uuid, 1), 'user08', 'pwd08', '탈퇴한유저', '여', 'user08@email.com', TRUE, '2023-08-10 10:00:00', '2023-09-01 11:00:00', '2023-09-01 11:00:00'),
(UUID_TO_BIN(@member_09_uuid, 1), 'user09', 'pwd09', '바다여행', '남', 'user09@email.com', TRUE, '2023-09-05 17:25:00', '2023-09-05 17:25:00', NULL),
(UUID_TO_BIN(@member_10_uuid, 1), 'user10', 'pwd10', '도시여행자', '여', 'user10@email.com', TRUE, '2023-10-18 20:00:00', '2023-10-18 20:00:00', NULL);

-- # 05. 본사회원 관심지역 LOG 데이터
INSERT INTO member_favorite_region (mNo, legalCode) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), '1111010100'), (UUID_TO_BIN(@member_01_uuid, 1), '5013010100'),
(UUID_TO_BIN(@member_02_uuid, 1), '1111010100'),
(UUID_TO_BIN(@member_03_uuid, 1), '1168010100'), (UUID_TO_BIN(@member_03_uuid, 1), '2644010100'),
(UUID_TO_BIN(@member_04_uuid, 1), '4128110100'),
(UUID_TO_BIN(@member_05_uuid, 1), '1111010100'), (UUID_TO_BIN(@member_05_uuid, 1), '2920010100'),
(UUID_TO_BIN(@member_06_uuid, 1), '1168010100'),
(UUID_TO_BIN(@member_07_uuid, 1), '3011010100'),
(UUID_TO_BIN(@member_09_uuid, 1), '2644010100'), (UUID_TO_BIN(@member_09_uuid, 1), '5013010100'),
(UUID_TO_BIN(@member_10_uuid, 1), '1168010100'), (UUID_TO_BIN(@member_10_uuid, 1), '2823710100');

-- # 06. 본사회원 관심분야 LOG 데이터
INSERT INTO member_favorite_item (mNo, itemNo) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), 1), (UUID_TO_BIN(@member_01_uuid, 1), 3),
(UUID_TO_BIN(@member_02_uuid, 1), 1),
(UUID_TO_BIN(@member_03_uuid, 1), 5),
(UUID_TO_BIN(@member_04_uuid, 1), 3), (UUID_TO_BIN(@member_04_uuid, 1), 4),
(UUID_TO_BIN(@member_05_uuid, 1), 2),
(UUID_TO_BIN(@member_06_uuid, 1), 6), (UUID_TO_BIN(@member_06_uuid, 1), 5),
(UUID_TO_BIN(@member_09_uuid, 1), 3),
(UUID_TO_BIN(@member_10_uuid, 1), 2), (UUID_TO_BIN(@member_10_uuid, 1), 7);

-- # 07. 본사회원 관심키워드 LOG 데이터
INSERT INTO member_favorite_keyword (mNo, keywordNo) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), 1), (UUID_TO_BIN(@member_01_uuid, 1), 3),
(UUID_TO_BIN(@member_02_uuid, 1), 1),
(UUID_TO_BIN(@member_03_uuid, 1), 5),
(UUID_TO_BIN(@member_04_uuid, 1), 3), (UUID_TO_BIN(@member_04_uuid, 1), 4),
(UUID_TO_BIN(@member_05_uuid, 1), 2),
(UUID_TO_BIN(@member_06_uuid, 1), 6), (UUID_TO_BIN(@member_06_uuid, 1), 5),
(UUID_TO_BIN(@member_07_uuid, 1), 8),
(UUID_TO_BIN(@member_09_uuid, 1), 4),
(UUID_TO_BIN(@member_10_uuid, 1), 2), (UUID_TO_BIN(@member_10_uuid, 1), 7);

-- # 08. 본사회원 추가정보 TABLE 데이터
INSERT INTO paid_member_head (mNo, pmType, pmName, pmBirth, pmGender, pmPhone, pmNationality, pmTermsAgreed, pmCreatedAt) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), 1, '김철수', '1990-01-15', '남', '010-1111-1111', '내국인', TRUE, '2023-01-12 10:00:00'),
(UUID_TO_BIN(@member_02_uuid, 1), 1, '박영희', '1988-05-20', '여', '010-2222-2222', '내국인', TRUE, '2023-02-16 11:30:00'),
(UUID_TO_BIN(@member_03_uuid, 1), 1, '이민준', '1995-11-30', '남', '010-3333-3333', '내국인', TRUE, '2023-03-21 14:00:00'),
(UUID_TO_BIN(@member_06_uuid, 1), 2, '최지우', '1985-07-07', '여', '010-6666-6666', '내국인', TRUE, '2023-06-23 13:10:00'),
(UUID_TO_BIN(@member_07_uuid, 1), 3, '정동진', '1982-03-25', '남', '010-7777-7777', '내국인', TRUE, '2023-07-02 16:00:00'),
(UUID_TO_BIN(@member_10_uuid, 1), 2, '홍길순', '1992-09-10', '여', '010-1010-1010', '내국인', TRUE, '2023-10-19 20:00:00');

-- # 09. 본사회원 사업자정보 TABLE 데이터
INSERT INTO business_info (mNo, biCompanyName, biCeoName, biBusinessNumber, biCorpNumber, biIndustry, biBusinessType, biAddress, biMailOrderNumber, biTel) VALUES
(UUID_TO_BIN(@member_06_uuid, 1), '(주)좋은여행', '최지우', '123-45-67890', '110111-1234567', '서비스업', '일반 여행업', '서울특별시 강남구 테헤란로 123', '2023-서울강남-0123', '02-123-4567'),
(UUID_TO_BIN(@member_10_uuid, 1), '행복상사', '홍길순', '234-56-78901', NULL, '도소매', '전자상거래업', '인천광역시 부평구 부평대로 456', '2023-인천부평-0456', '032-234-5678');

-- # 10. 본사회원 단체/협회정보 TABLE 데이터
INSERT INTO association_info (mNo, aiOrgName, aiRepresentativeName, aiOrgNumber, aiOrgType, aiActivityField, aiAddress, aiTel, aiEstablishmentDate) VALUES
(UUID_TO_BIN(@member_07_uuid, 1), '한국문화유산답사회', '정동진', '123-82-00012', '비영리민간단체', '문화유산 보호 및 연구', '대전광역시 동구 중앙로 789', '042-345-6789', '2005-05-10');

-- # 11. 구독플랜 TABLE 데이터
INSERT INTO subscription_plan (spName, spDurationUnit, spDurationValue, spPrice, spDescription, spIsActive) VALUES
('무료체험', 'DAY', 15, 0.00, '기본 기능 제공, 무료로 부담없이 사용', TRUE),
('프리미엄', 'MONTH', 1, 19900.00, '모든 기능 제공, 월간 구독', TRUE),
('럭셔리', 'YEAR', 1, 199000.00, '12개월 가격으로 2개월 할인, 모든 기능 제공', TRUE),
('엔터프라이즈', 'YEAR', 1, 1000000.00, '기업용 맞춤 플랜', FALSE);

-- # 12. 구독자 사이트정보 TABLE 데이터
INSERT INTO site_info (mNo, siName, siDomain, siIntro, siTel, siIsPublic) VALUES
(UUID_TO_BIN(@member_01_uuid, 1), '철수의 여행 블로그', 'chulsoo-tour.com', '국내 곳곳을 누비는 여행 블로그입니다.', '010-1111-1111', 1),
(UUID_TO_BIN(@member_06_uuid, 1), '좋은여행사', 'good-travel.co.kr', '당신을 위한 최고의 여행을 만듭니다.', '02-123-4567', 1),
(UUID_TO_BIN(@member_07_uuid, 1), '한국문화유산답사회', 'korea-heritage.org', '우리의 문화유산을 알리고 보존', '042-345-6789', 1),
(UUID_TO_BIN(@member_10_uuid, 1), '행복상사 쇼핑몰', 'happy-store.shop', '여행 관련 굿즈 판매 쇼핑몰', '032-234-5678', 0);

-- # 13. 구독로그 TABLE 데이터
INSERT INTO subscription_log (mNo, spNo, slRecordedAt, slCreatedAt, slEndedAt) VALUES
-- member_01: 무료체험 -> 갱신(시나리오상 이상하지만 데이터로 남김) -> 프리미엄으로 변경 -> 럭셔리로 변경
(UUID_TO_BIN(@member_01_uuid, 1), 1, '2023-01-12 10:05:00', '2023-01-12 10:05:00', '2023-01-27 10:05:00'),
(UUID_TO_BIN(@member_01_uuid, 1), 1, '2023-01-27 10:10:00', '2023-01-27 10:10:00', '2023-02-11 10:10:00'),
(UUID_TO_BIN(@member_01_uuid, 1), 2, '2023-02-11 11:00:00', '2023-02-11 11:00:00', '2023-03-11 11:00:00'),
(UUID_TO_BIN(@member_01_uuid, 1), 3, '2023-03-11 11:05:00', '2023-03-11 11:05:00', '2024-03-11 11:05:00'),
-- member_02: 프리미엄 구독했다가 1달 후 해지
(UUID_TO_BIN(@member_02_uuid, 1), 2, '2023-02-16 12:00:00', '2023-02-16 12:00:00', '2023-03-16 12:00:00'),
-- member_03: 무료체험 -> 해지 -> 몇 달 후 프리미엄으로 재구독
(UUID_TO_BIN(@member_03_uuid, 1), 1, '2023-03-21 15:00:00', '2023-03-21 15:00:00', '2023-04-05 15:00:00'),
(UUID_TO_BIN(@member_03_uuid, 1), 2, '2023-08-01 10:00:00', '2023-08-01 10:00:00', '2023-09-01 10:00:00'),
-- member_06 (사업자): 럭셔리 플랜 꾸준히 갱신
(UUID_TO_BIN(@member_06_uuid, 1), 3, '2023-06-23 14:00:00', '2023-06-23 14:00:00', '2024-06-23 14:00:00'),
(UUID_TO_BIN(@member_06_uuid, 1), 3, '2024-06-23 14:05:00', '2024-06-23 14:05:00', '2025-06-23 14:05:00'),
-- member_07 (단체): 럭셔리 플랜 구독
(UUID_TO_BIN(@member_07_uuid, 1), 3, '2023-07-02 17:00:00', '2023-07-02 17:00:00', '2024-07-02 17:00:00'),
-- member_10 (사업자): 무료체험 -> 프리미엄 -> 럭셔리
(UUID_TO_BIN(@member_10_uuid, 1), 1, '2023-10-19 21:00:00', '2023-10-19 21:00:00', '2023-11-03 21:00:00'),
(UUID_TO_BIN(@member_10_uuid, 1), 2, '2023-11-03 21:05:00', '2023-11-03 21:05:00', '2023-12-03 21:05:00'),
(UUID_TO_BIN(@member_10_uuid, 1), 3, '2023-12-03 21:10:00', '2023-12-03 21:10:00', '2024-12-03 21:10:00'),
-- 기타 회원들의 단일 구독 기록
(UUID_TO_BIN(@member_04_uuid, 1), 1, '2023-04-06 10:00:00', '2023-04-06 10:00:00', '2023-04-21 10:00:00'),
(UUID_TO_BIN(@member_05_uuid, 1), 2, '2023-05-12 13:00:00', '2023-05-12 13:00:00', '2023-06-12 13:00:00'),
(UUID_TO_BIN(@member_09_uuid, 1), 1, '2023-09-06 09:00:00', '2023-09-06 09:00:00', '2023-09-21 09:00:00'),
-- member_01의 과거 구독 기록 (럭셔리 구독 이전)
(UUID_TO_BIN(@member_01_uuid, 1), 2, '2022-01-12 11:00:00', '2022-01-12 11:00:00', '2022-02-12 11:00:00'),
(UUID_TO_BIN(@member_01_uuid, 1), 2, '2022-02-12 11:05:00', '2022-02-12 11:05:00', '2022-03-12 11:05:00'),
-- member_06의 과거 구독 기록
(UUID_TO_BIN(@member_06_uuid, 1), 2, '2022-06-23 14:00:00', '2022-06-23 14:00:00', '2023-06-23 14:00:00'),
-- member_03의 추가 과거 구독 기록
(UUID_TO_BIN(@member_03_uuid, 1), 1, '2022-03-21 15:00:00', '2022-03-21 15:00:00', '2022-04-05 15:00:00');

SET sql_safe_updates = 1; -- mysql workbench : safeMode 설정 원복
# ======================================== 테이블 조회 ============================================================
SELECT * FROM region_master; 			-- # 01. 법정동코드 TABLE
SELECT * FROM item_master; 				-- # 02. 관심분야 TABLE
SELECT * FROM keyword_master; 			-- # 03. 관심키워드 TABLE
SELECT * FROM member_head;				-- # 04. 본사회원 기본정보 TABLE
SELECT * FROM member_favorite_region;	-- # 05. 본사회원 부가정보(1.관심지역) LOG
SELECT * FROM member_favorite_item;		-- # 06. 본사회원 부가정보(2.관심분야) LOG
SELECT * FROM member_favorite_keyword;	-- # 07. 본사회원 부가정보(3.관심키워드) LOG
SELECT * FROM paid_member_head;			-- # 08. 본사회원 추가정보(유료회원) TABLE
SELECT * FROM business_info; 			-- # 09. 본사회원 사업자정보 TABLE
SELECT * FROM association_info; 		-- # 10. 본사회원 단체/협회정보 TABLE
SELECT * FROM subscription_plan; 		-- # 11. 구독플랜 TABLE
SELECT * FROM site_info; 				-- # 12. 구독자 사이트정보 TABLE
SELECT * FROM subscription_log; 		-- # 13. 구독로그 TABLE