# 00. 데이터베이스 초기화 및 설정
DROP DATABASE IF EXISTS k_tour_map;
CREATE DATABASE k_tour_map
    DEFAULT CHARACTER SET utf8mb4
    COLLATE utf8mb4_general_ci;
USE k_tour_map;
SET sql_safe_updates = 0; -- mysql workbench : safeMode 해제(끄기 0 / 켜기 1)

# 01. 본사회원(기본) TABLE ------------------------------------------------------------------------------------------------통신판매업 번호
CREATE TABLE member_head(                                            # 01. 본사회원 TABLE
    mNo BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),    -- 1. [pk]회원번호: 시간순 UUID로 인덱스 성능 고려
    mId VARCHAR(30) NOT NULL UNIQUE,                                -- 3. 로그인 아이디
    mPwd CHAR(64) NOT NULL,                                         -- 4. 로그인 비밀번호(SHA-256 암호화)
    mEmail VARCHAR(100) UNIQUE,                                     -- 5. 이메일
    mGender ENUM('남', '여') DEFAULT NULL,                           -- 8. 성별(남/여)
    mTermsAgreed BOOLEAN DEFAULT FALSE NOT NULL,                    -- 11. 이용약관(0_FALSE:미동의, 1_TRUE:동의)
    mCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- 12. 가입일시
    mUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 13. 수정일시
    mdeletedAt DATETIME NULL                                        -- 15. 탈퇴일시/null이면 활성회원
);

# 01. 본사회원(부가정보/유료회원) TABLE ------------------------------------------------------------------------------------------------통신판매업 번호
CREATE TABLE member_head(                                            # 01. 본사회원 TABLE
    mNo BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),    -- 1. [pk]회원번호: 시간순 UUID로 인덱스 성능 고려
    mType ENUM('일반', '사업자', '단체/협회') NOT NULL,                    -- 2. 회원유형(1.일반회원/2.사업자/3.단체/협회)
    mId VARCHAR(30) NOT NULL UNIQUE,                                -- 3. 로그인 아이디
    mPwd CHAR(64) NOT NULL,                                         -- 4. 로그인 비밀번호(SHA-256 암호화)
    mEmail VARCHAR(100) UNIQUE,                                     -- 5. 이메일
    mName VARCHAR(30) NOT NULL,                                     -- 6. 이름
    mBirth DATE NOT NULL,                                           -- 7. 생년월일(8자리)
    mGender ENUM('남', '여') DEFAULT NULL,                           -- 8. 성별(남/여)
    mPhone VARCHAR(16) NOT NULL UNIQUE,                             -- 9. 휴대폰번호
    mNationality ENUM('내국인', '외국인') DEFAULT '내국인',               -- 10. 구분(내국인/외국인)
    mTermsAgreed BOOLEAN DEFAULT FALSE NOT NULL,                    -- 11. 이용약관(0_FALSE:미동의, 1_TRUE:동의)
    mCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                  -- 12. 가입일시
    mUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 13. 수정일시
    mLastLoginAt DATETIME NULL,                                     -- 14. 최종로그인일시
    mdeletedAt DATETIME NULL                                        -- 15. 탈퇴일시/null이면 활성회원
);

# 02. 구독플랜 TABLE --------------------------------------------------------------------------------------------------
CREATE TABLE subscription_plan(                                      -- 02. 구독플랜 TABLE
    spNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                   -- 1. [pk]구독플랜번호
    spName VARCHAR(20) NOT NULL UNIQUE,                             -- 2. 구독플랜명
    spDurationUnit ENUM('DAY', 'MONTH', 'YEAR') DEFAULT 'MONTH',    -- 3. 구독기간 단위
    spDurationValue TINYINT UNSIGNED DEFAULT 1,                     -- 4. 구독기간 값
    spPrice DECIMAL(10, 2) UNSIGNED DEFAULT 0,                      -- 5. 금액(소수점 2자리까지)
    spCurrency CHAR(3) DEFAULT 'KRW' NOT NULL,                      -- 6. 통화코드 (ISO 4217, 예: KRW, USD)
    spDescription LONGTEXT NOT NULL,                                -- 7. 플랜 설명
    spIsActive BOOLEAN DEFAULT FALSE NOT NULL,                      -- 8. 플랜 활성화 여부
    spCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                 -- 9. 생성일시
    spUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 10. 수정일시
);

# 03. 구독자 사이트 정보 TABLE -----------------------------------------------------------------------------------------------
CREATE TABLE site_info (                                             -- 03. 구독자 사이트 정보 테이블
    siNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                   -- 1. [pk]사이트 번호
    mNo BINARY(16) UNIQUE,                                          -- 2. [fk]본사 회원 번호
    siName VARCHAR(50) NOT NULL UNIQUE,                             -- 3. 사이트명
    siDomain VARCHAR(100) NOT NULL UNIQUE,                          -- 4. 도메인명(URL)
    siIntro VARCHAR(255),                                           -- 5. 사이트 소개글
    siLogo VARCHAR(255),                                            -- 6. 사이트 로고 이미지 URL
    siFavicon VARCHAR(255),                                         -- 7. 파비콘 이미지 URL
    siTel VARCHAR(20),                                              -- 8. 대표 전화
    siPrivacyOfficer VARCHAR(30),                                   -- 9. 개인정보 처리 책임자
    siEmail VARCHAR(100),                                           -- 10. 이메일
    siKeywords VARCHAR(255),                                        -- 11. 사이트 검색 키워드 (콤마로 구분)
    siIsPublic TINYINT(1) DEFAULT 0,                                -- 12. 사이트 공개 여부 (0:비공개, 1:공개)
    siCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                 -- 13. 생성 일시
    siUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 14. 수정 일시
    
    CONSTRAINT FOREIGN KEY (mNo) REFERENCES member_head(mNo)
);

# 04. 구독자 사업자 정보 TABLE -----------------------------------------------------------------------------------------------
CREATE TABLE business_info (                          					 # 04. 구독자 사업자 정보 테이블
    biNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,      -- 1. [pk]사업자 정보 번호
    mNo BINARY(16) NOT NULL UNIQUE,                    -- 2. [fk]본사 회원 번호 (member_head의 PK를 참조)
    biCompanyName VARCHAR(100) NOT NULL,               -- 3. 상호명
    biCeoName VARCHAR(50) NOT NULL,                    -- 4. 대표자명
    biBusinessNumber VARCHAR(12) NOT NULL UNIQUE,      -- 5. 사업자등록번호 (예: 123-45-67890)
    biCorpNumber VARCHAR(14) UNIQUE,                   -- 6. 법인등록번호 (예: 110111-1234567, 법인만 해당)
    biIndustry VARCHAR(100),                           -- 7. 업태
    biBusinessType VARCHAR(100),                       -- 8. 업종
    biAddress VARCHAR(255),                            -- 9. 사업장 주소
    biMailOrderNumber VARCHAR(12),                     -- 10. 통신판매업신고번호(예: 2025-XX-XXXX)
    biTel VARCHAR(20),                                 -- 11. 대표 전화
    biCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,    -- 12. 생성 일시
    biUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP, -- 13. 수정 일시
    
    -- member_head 테이블의 mNo를 외래 키로 지정
    CONSTRAINT FOREIGN KEY (mNo) REFERENCES member_head(mNo) ON DELETE CASCADE
);

# 04. 구독로그 타입 TABLE ---------------------------------------------------------------------------------------------------
CREATE TABLE sub_log_type (													# 04. 구독로그 타입 TABLE 
    slTypeNo TINYINT UNSIGNED PRIMARY KEY,                            		-- 1. [pk]로그 타입 ID
    slTypeName VARCHAR(50) NOT NULL UNIQUE,                           		-- 2. 로그 타입명
    slTypeDescription VARCHAR(255),                                       	-- 3. 로그 타입에 대한 상세 설명
    slTypeCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,   				  	-- 4. 생성 일시
    slTypeUpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP -- 5. 수정 일시
);

# 05. 구독로그 TABLE -------------------------------------------------------------------------------------------------------
CREATE TABLE subscription_log (
    slNo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,                   -- 1. [pk]로그 번호
    mNo BINARY(16),                                                 -- 2. [fk]본사 회원 번호
    spNo INT UNSIGNED,                                              -- 3. [fk]구독 플랜 번호
    slType TINYINT UNSIGNED NOT NULL,                               -- 4. 로그 타입
    slRecordedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                -- 5. 기록일시
    slRecordedId VARCHAR(50) DEFAULT NULL,                          -- 6. 로그 관리자 ID
    slCreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,                 -- 7. 신청일시
    slEndedAt DATETIME NULL,                                        -- 8. 종료일시
    
    CONSTRAINT FOREIGN KEY (mNo) REFERENCES member_head(mNo),
    CONSTRAINT FOREIGN KEY (spNo) REFERENCES subscription_plan(spNo),
    CONSTRAINT FOREIGN KEY (slType) REFERENCES sub_log_type(typeId)
);

# 01. 본사회원 TABLE > 샘플 데이터 10개
INSERT INTO member_head (mNo, mType, mId, mPwd, mEmail, mName, mBirth, mGender, mPhone, mNationality, mTermsAgreed, mCreatedAt, mUpdatedAt, mLastLoginAt, mdeletedAt) VALUES
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e54', 1), '일반', 'qqq', '1111', 'user01@example.com', '김민준', '2005-05-15', '남', '010-1234-5678', '내국인', TRUE, '2023-01-10 10:00:00', '2023-01-10 10:00:00', '2025-08-27 16:30:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e55', 1), '사업자', 'aaa', '1111', 'bizuser02@example.com', '박서윤', '1985-11-20', '여', '010-9876-5432', '내국인', TRUE, '2023-03-20 12:30:00', '2024-05-11 11:15:00', '2025-08-26 21:05:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e56', 1), '단체/협회', 'zzz', '1111', 'group03@example.com', '이도윤', '1978-02-28', '남', '010-2345-6789', '내국인', FALSE, '2022-09-05 15:45:00', '2022-09-05 15:45:00', '2025-08-20 10:00:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e57', 1), '일반', 'qqq1', '1111', 'user04@example.com', '정하은', '1995-07-07', '여', '010-8765-4321', '내국인', TRUE, '2024-02-14 09:10:00', '2024-02-14 09:10:00', '2025-08-27 15:55:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e58', 1), '사업자', 'aaa1', '1111', 'bizuser05@example.com', '최재현', '1980-04-01', '남', '010-3456-7890', '내국인', TRUE, '2023-08-30 14:00:00', '2023-08-30 14:00:00', '2025-08-25 18:00:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e59', 1), '일반', 'qqq2', '1111', 'user06@example.com', '한지민', '2000-09-10', NULL, '010-7654-3210', '내국인', TRUE, '2024-06-15 11:30:00', '2024-06-15 11:30:00', '2025-08-27 17:00:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e60', 1), '일반', 'qqq3', '1111', 'user07@example.com', 'John Smith', '1988-12-05', '남', '+1-234-567-8901', '외국인', TRUE, '2022-04-22 17:00:00', '2022-04-22 17:00:00', '2025-08-27 12:20:00', '2025-08-27 12:25:00'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e61', 1), '단체/협회', 'zzz1', '1111', 'group08@example.com', '김민서', '1992-06-25', '여', '010-1111-2222', '내국인', TRUE, '2023-11-01 19:00:00', '2024-03-05 08:30:00', '2025-08-26 19:30:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e62', 1), '사업자', 'aaa2', '1111', 'bizuser09@example.com', 'David Lee', '1975-01-30', NULL, '+44-20-7123-4567', '외국인', FALSE, '2024-09-20 16:00:00', '2024-09-20 16:00:00', '2025-08-20 14:00:00', '2025-08-22 10:00:00'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e63', 1), '일반', 'qqq4', '1111', 'user10@example.com', '박민지', '1998-03-12', '여', '010-9999-8888', '내국인', TRUE, '2025-01-05 08:00:00', '2025-01-05 08:00:00', '2025-08-27 17:05:00', NULL);

# 02. 구독플랜 TABLE > 샘플 데이터 3개
INSERT INTO subscription_plan (spName, spDurationUnit, spDurationValue, spPrice, spCurrency, spDescription, spIsActive) VALUES
('베이직', 'MONTH', 1, 9900.00, 'KRW', '모든 기본 기능을 제공하는 표준 월간 구독 플랜입니다.', TRUE),
('프리미엄', 'YEAR', 1, 99000.00, 'KRW', '고급 기능을 포함하며, 1년 구독으로 비용을 절약할 수 있는 플랜입니다.', TRUE),
('무료체험', 'DAY', 7, 0.00, 'KRW', '프리미엄 기능을 7일간 무료로 체험할 수 있는 플랜입니다.', TRUE);

# 03. 구독자 사이트 정보 TABLE > 샘플 데이터
INSERT INTO site_info (mNo, siName, siDomain, siIntro, siLogo, siFavicon, siTel, siPrivacyOfficer, siEmail, siKeywords, siIsPublic, siCreatedAt, siUpdatedAt) VALUES
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e55', 1), 'K-TourMap 비즈니스', 'biz.ktourmap.com', '사업자 회원들을 위한 K-TourMap 솔루션 페이지입니다.', NULL, NULL, '02-1234-5678', '박서윤', 'bizuser02@example.com', 'K-TourMap, 기업용, 비즈니스', TRUE, '2023-03-20 12:30:00', '2024-05-11 11:15:00'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e58', 1), 'K-TourMap 여행사', 'travel.ktourmap.com', 'K-TourMap과 함께하는 여행사 페이지입니다.', NULL, NULL, '02-5678-1234', '최재현', 'bizuser05@example.com', 'K-TourMap, 여행사, 여행', TRUE, '2023-08-30 14:00:00', '2023-08-30 14:00:00');

# 04. 구독로그 타입 TABLE > 샘플 데이터
INSERT INTO sub_log_type (typeId, typeName, description) VALUES
(1, 'subscribe', '신규 구독 신청'),
(2, 'unsubscribe', '구독 취소'),
(3, 'renew', '구독 자동 갱신'),
(4, 'change_plan', '구독 플랜 변경'),
(5, 'suspend', '구독 일시 중지'),
(6, 'reactivate', '중지된 구독 재활성화'),
(7, 'manual_renewal', '수동 갱신'),
(8, 'trial_start', '무료 체험 시작'),
(9, 'trial_end', '무료 체험 종료'),
(10, 'payment_failed', '결제 실패'),
(11, 'extend', '구독 기간 연장');

# 05. 구독로그 테이블 > 샘플 데이터 20개
INSERT INTO subscription_log (mNo, spNo, slType, slRecordedAt, slCreatedAt, slEndedAt, slRecordedId) VALUES
-- 1. 박서윤: 베이직 구독 -> 프리미엄 변경 -> 프리미엄 갱신
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e55', 1), 1, 1, '2023-03-20 12:30:00', '2023-03-20 12:30:00', '2024-03-20 12:30:00', 'user_id_1'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e55', 1), 2, 4, '2024-03-21 10:00:00', '2024-03-21 10:00:00', '2025-03-21 10:00:00', 'user_id_1'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e55', 1), 2, 3, '2025-03-21 10:00:05', '2025-03-21 10:00:00', '2026-03-21 10:00:00', 'system_auto'),
-- 2. 정하은: 무료체험 -> 체험종료 -> 베이직 구독
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e57', 1), 3, 8, '2024-02-14 09:10:00', '2024-02-14 09:10:00', '2024-02-21 09:10:00', 'user_id_2'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e57', 1), 3, 9, '2024-02-21 09:10:00', '2024-02-21 09:10:00', NULL, 'system_auto'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e57', 1), 1, 1, '2024-02-22 15:00:00', '2024-02-22 15:00:00', '2024-03-22 15:00:00', 'user_id_2'),
-- 3. 최재현: 베이직 구독 -> 갱신 -> 결제실패
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e58', 1), 1, 1, '2023-08-30 14:00:00', '2023-08-30 14:00:00', '2024-08-30 14:00:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e58', 1), 1, 3, '2024-08-30 14:00:05', '2024-08-30 14:00:00', '2025-08-30 14:00:00', 'system_auto'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e58', 1), 1, 10,'2025-08-30 14:01:00', '2025-08-30 14:00:00', NULL, 'payment_gateway'),
-- 4. 한지민: 무료체험 -> 체험종료 (구독 안함)
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e59', 1), 3, 8, '2024-06-15 11:30:00', '2024-06-15 11:30:00', '2024-06-22 11:30:00', NULL),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e59', 1), 3, 9, '2024-06-22 11:30:00', '2024-06-22 11:30:00', NULL, 'system_auto'),
-- 5. 김민준: 무료체험 -> 베이직 구독 -> 갱신 -> 구독취소
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e54', 1), 3, 8, '2024-07-01 10:00:00', '2024-07-01 10:00:00', '2024-07-08 10:00:00', 'user_id_3'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e54', 1), 1, 1, '2024-07-08 10:05:00', '2024-07-08 10:05:00', '2024-08-08 10:05:00', 'user_id_3'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e54', 1), 1, 3, '2024-08-08 10:05:05', '2024-08-08 10:05:00', '2024-09-08 10:05:00', 'system_auto'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e54', 1), 1, 2, '2024-09-01 18:00:00', '2024-09-01 18:00:00', '2024-09-08 10:05:00', 'user_id_3'),
-- 6. 이도윤: 프리미엄 구독 -> 일시중지 -> 재활성화
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e56', 1), 2, 1, '2023-10-01 00:00:00', '2023-10-01 00:00:00', '2024-10-01 00:00:00', 'admin_01'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e56', 1), 2, 5, '2024-01-15 11:00:00', '2024-01-15 11:00:00', NULL, 'admin_01'),
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e56', 1), 2, 6, '2024-04-01 09:00:00', '2024-04-01 09:00:00', '2025-01-15 00:00:00', 'admin_01'),
-- 7. 김민서: 프리미엄 구독 (단체)
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e61', 1), 2, 1, '2023-11-01 19:00:00', '2023-11-01 19:00:00', '2024-11-01 19:00:00', NULL),
-- 8. 박민지: 무료체험 시작
(UUID_TO_BIN('01889895-c9e8-466d-a19e-e5e347895e63', 1), 3, 8, '2025-01-10 09:00:00', '2025-01-10 09:00:00', '2025-01-17 09:00:00', NULL);

# 샘플 데이터 테이블 조회 -----------------------------------------------------------------------------------
SELECT * FROM member_head;			-- 01. 본사회원 테이블
SELECT * FROM subscription_plan;	-- 02. 구독플랜 테이블
SELECT * FROM site_info;			-- 03. 구독자사이트정보 테이블
SELECT * FROM sub_log_type;			-- 04. 구독로그타입 테이블
SELECT * FROM subscription_log;		-- 05. 구독로그 테이블



