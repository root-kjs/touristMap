DROP DATABASE IF EXISTS k_tourmap;
CREATE DATABASE k_tourmap
	DEFAULT CHARACTER SET utf8mb4
	COLLATE utf8mb4_general_ci;
USE k_tourmap;
set sql_safe_updates = 0; -- mysql workbench : safeMode 해제(끄기 0 / 켜기 1)

# 01. 본사회원 TABLE
create table member_head(   									# 01. 본사회원 TABLE
    mNo BINARY(16) PRIMARY KEY DEFAULT (UUID_TO_BIN(UUID(), 1)),-- 1. (pk)회원번호: !!선생님께 질문 ==> 시간순 UUID로 인덱스 성능 고려 
    mType ENUM('일반', '사업자', '단체/협회') not null,     			-- 2. 회원유형(1.일반회원/2.사업자/3.단체.협회) !!선생님께 질문!! ==> fk로 테이블 하나 만들까요?
    mId varchar(30) not null unique,              				-- 3. 로그인 아이디
    mPwd CHAR(64) not null,                   					-- 4. 로그인 비밀번호(SHA-256 암호화(해싱) 고려) !!선생님께 질문!! ==> bcrypt나 Argon2 같은 알고리즘 --> VARCHAR(255)
    mEmail varchar(100) not null unique,           				-- 5. 이메일
	mName varchar(30) not null,                   				-- 6. 이름
    mBirth date not null, 										-- 7. 생년월일(8자리)
    mGender ENUM('남', '여') default null,  			  			-- 8. 성별(남/여)
    mPhone varchar(16) not null unique,                 		-- 9. 휴대폰번호 : 추후 국제번호(+82 등) 추가 고려
    mNationality ENUM('내국인', '외국인') default '내국인',  			-- 10. 구분(내국인/외국인)
    mTermsAgreed boolean default FALSE not null,        		-- 11. 이용약관(0_FALSE:미동의, 1_TRUE:동의)
	mCreatedAt datetime default CURRENT_TIMESTAMP,				-- 12. 가입일시
    mUpdatedAt datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,	-- 13. 수정일시
    mLastLoginAt datetime NULL,									-- 14. 최종로그인일시 !!선생님께 질문!! ==> 뺄가요??
    mdeletedAt datetime null									-- 15. 탈퇴일시/null이면 활성회원
);
# 02. 구독플랜 TABLE
create table subscription_plan(										# 02. 구독플랜 TABLE
	spNo int unsigned auto_increment primary key,  					-- 1. 구독플랜번호(pk)
    spName varchar(20) not null unique ,          					-- 2. 구독플랜명
    spDurationUnit ENUM('DAY' , 'MONTH', 'YEAR') default 'MONTH',  	-- 3. 구독기간단위('DAY' , 'MONTH', 'YEAR')
    spDurationValue tinyint unsigned default 1,  					-- 4. 구독기간 값
    spPrice DECIMAL(10, 2) unsigned default 0, 	           			-- 5. 금액(소수점 2자리까지 저장)
    spCurrency CHAR(3) default 'KRW' not null,						-- 6. 통화코드 (ISO 4217, 예: KRW, USD)
    spDescription longtext not null, 								-- 7. 플랜 설명
    spIsActive boolean default FALSE not null,      				-- 8. 플랜 활성화 여부
    spCreatedAt datetime default CURRENT_TIMESTAMP,  				-- 9. 생성일시
    spUpdatedAt datetime default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP -- 10. 수정일시
);

# 01. 본사회원 TABLE > 샘플 데이터 10개
INSERT INTO member_head (mType, mId, mPwd, mEmail, mName, mBirth, mGender, mPhone, mNationality, mTermsAgreed, mCreatedAt, mUpdatedAt, mLastLoginAt, mdeletedAt) VALUES
('일반', 'qqq', '1111', 'user01@example.com', '김민준', '1990-05-15', '남', '010-1234-5678', '내국인', TRUE, '2023-01-10 10:00:00', '2023-01-10 10:00:00', '2025-08-27 16:30:00', NULL),
('사업자', 'aaa', '1111', 'bizuser02@example.com', '박서윤', '1985-11-20', '여', '010-9876-5432', '내국인', TRUE, '2023-03-20 12:30:00', '2024-05-11 11:15:00', '2025-08-26 21:05:00', NULL),
('단체/협회', 'zzz', '1111', 'group03@example.com', '이도윤', '1978-02-28', '남', '010-2345-6789', '내국인', FALSE, '2022-09-05 15:45:00', '2022-09-05 15:45:00', '2025-08-20 10:00:00', NULL),
('일반', 'qqq1', '1111', 'user04@example.com', '정하은', '1995-07-07', '여', '010-8765-4321', '내국인', TRUE, '2024-02-14 09:10:00', '2024-02-14 09:10:00', '2025-08-27 15:55:00', NULL),
('사업자', 'aaa1', '1111', 'bizuser05@example.com', '최재현', '1980-04-01', '남', '010-3456-7890', '내국인', TRUE, '2023-08-30 14:00:00', '2023-08-30 14:00:00', '2025-08-25 18:00:00', NULL),
('일반', 'qqq2', '1111', 'user06@example.com', '한지민', '2000-09-10', NULL, '010-7654-3210', '내국인', TRUE, '2024-06-15 11:30:00', '2024-06-15 11:30:00', '2025-08-27 17:00:00', NULL),
('일반', 'qqq3', '1111', 'user07@example.com', 'John Smith', '1988-12-05', '남', '+1-234-567-8901', '외국인', TRUE, '2022-04-22 17:00:00', '2022-04-22 17:00:00', '2025-08-27 12:20:00', '2025-08-27 12:25:00'),
('단체/협회', 'zzz1', '1111', 'group08@example.com', '김민서', '1992-06-25', '여', '010-1111-2222', '내국인', TRUE, '2023-11-01 19:00:00', '2024-03-05 08:30:00', '2025-08-26 19:30:00', NULL),
('사업자', 'aaa2', '1111', 'bizuser09@example.com', 'David Lee', '1975-01-30', NULL, '+44-20-7123-4567', '외국인', FALSE, '2024-09-20 16:00:00', '2024-09-20 16:00:00', '2025-08-20 14:00:00', '2025-08-22 10:00:00'),
('일반', 'qqq4', '1111', 'user10@example.com', '박민지', '1998-03-12', '여', '010-9999-8888', '내국인', TRUE, '2025-01-05 08:00:00', '2025-01-05 08:00:00', '2025-08-27 17:05:00', NULL);

# 02. 구독플랜 TABLE > 샘플 데이터 10개
INSERT INTO subscription_plan (spName, spDurationUnit, spDurationValue, spPrice, spCurrency, spDescription, spIsActive) VALUES
('베이직', 'MONTH', 1, 9900.00, 'KRW', '모든 기본 기능을 제공하는 표준 월간 구독 플랜입니다.', TRUE),
('프리미엄', 'YEAR', 1, 99000.00, 'KRW', '고급 기능을 포함하며, 1년 구독으로 비용을 절약할 수 있는 플랜입니다.', TRUE),
('무료체험', 'DAY', 7, 0.00, 'KRW', '프리미엄 기능을 7일간 무료로 체험할 수 있는 플랜입니다.', TRUE);

select * from member_head;  		-- # 01. 본사회원 
select * from subscription_plan;  	-- # 02. 구독플랜 




