/*
   * DDL(DATA DEFINTION LANGUAGE)
   데이터 정의 언어
   객체를 수정(ALTER), 삭제(DROP)하는 구문
   
   1. ALTER
   객체 구조를 수정하는 구문
   
   <테이블 수정>
   [표현법]
   ALTER TABLE 테이블명 수정할 내용;
   
   - 수정할 내용
   1) 컬럼추가 / 수정 / 삭제
   2) 제약조건 추가 / 삭제 => 수정은 불가능.
      (수정하고자 한다면 삭제후 추가해줘야 한다.)
   3) 테이블명 / 컬럼명 / 제약조건명 수정
*/
-- 1) 컬럼추가 / 수정 / 삭제
--   1) 컬럼추가 (ADD) : ADD 추가할 컬럼명 자료형 [DEFAULT 기본값]
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

SELECT * FROM DEPT_COPY;


ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20);
ALTER TABLE DEPT_COPY ADD CNAME VARCHAR2(20) DEFAULT '한국';

-- 1_2) 칼럼 수정
--      칼럼의 자료형 수정 : MODIFY 컬럼명 바꾸고자 하는 자료형
--      DEFAULT값도 수정  : MODIFY 컬럼명 DEFAULT 바꾸고자 하는 기본값
-- DEPT_ID를 3바이트로 변경
ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(3);

ALTER TABLE DEPT_COPY MODIFY DEPT_ID NUMBER;
-- 현재 저장하고 있는 값과 연관이 없는 다른타입으로의 변경은 불가능하다.

ALTER TABLE DEPT_COPY MODIFY DEPT_ID CHAR(2);
-- 현재 변경하고자 하는 컬럼에 담겨있는 값이 2보다 크기 때문에 변경불가
-- CHAR는 고정크기. CHAR(3)으로 지정시 항상 3BYTE만큼 차지하고 있다.

ALTER TABLE DEPT_COPY MODIFY DEPT_ID VARCHAR2(4);
-- 같은 문자열 자료형으로 변경은 가능.

-- 한번에 여러개 칼럼의 구조를 변경가능
ALTER TABLE DEPT_COPY
MODIFY DEPT_TITLE VARCHAR2(40)
MODIFY LOCATION_ID VARCHAR(2)
MODIFY LNAME DEFAULT '미국';

-- 1_3) 칼럼 삭제 : DROP COLUMN 삭제할 칼럼명
CREATE TABLE DEPT_COPY2
AS SELECT * FROM DEPT_COPY;

SELECT * FROM DEPT_COPY2;

ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN DEPT_TITLE;
ALTER TABLE DEPT_COPY2 DROP COLUMN LOCATION_ID;
ALTER TABLE DEPT_COPY2 DROP COLUMN CNAME;
ALTER TABLE DEPT_COPY2 DROP COLUMN LNAME;

/*
    -- 2) 제약조건 추가 / 삭제
    
    2_2) 제약조건 추가
    - PRIMARY KEY : ADD PRIMARY KEY(칼럼명);
    - FOREIGN KEY : ADD [CONSTRAINT 제약조건명]FOREIGN KEY(칼럼명) REFERENCES 테이블명(참조컬럼명) [삭제옵션]
    - UNIQUE      : ADD UNIQUE(칼럼명)
    - CHECK       : ADD CHECK(칼럼에 대한 조건)
    - NOT NULL    : MODIFY 칼럼명 NOT NULL;
    
    나만의 제약조건명을 부여할때는 제약조건 앞에 CONSTRAINT 제약조건명을 붙임.
*/
-- DEPT_COPY테이블로부터 DEPT_ID칼럼에는 PK제약조건, DRPT_TITLE에는 UP제약조건, LNAME칼럼에는 NN제약조건 추가.
ALTER TABLE DEPT_COPY
ADD CONSTRAINT DC_PK_DI PRIMARY KEY(DEPT_ID)
ADD CONSTRAINT DC_UQ_DT UNIQUE(DEPT_TITLE)
MODIFY LNAME CONSTRAINT DC_NN_L NOT NULL;
SELECT * FROM DEPT_COPY;

ALTER TABLE DEPT_COPY MODIFY LOCATION_ID CHAR(2) NULL;

-- UPDATE DEPT_COPY SET LOCATION_ID = '  ';
-- DEPT_COFY LOCALTION_ID에 외래키 제약조건 추가 (LOCATION LOCAL_CODE)
-- CNAME에는 CHECK제약조건 추가 CNAME ASIA만 사용가능.
ALTER TABLE DEPT_COPY
--ADD CONSTRAINT DC_FK_LI FOREIGN KEY(LOCATION_ID) REFERENCES LOCATION(LOCAL_CODE) ON DELETE SET NULL;
ADD CONSTRAINT DC_CHECK_CNAME CHECK(CNAME IN ('ASIA'));

/*
    2_2) 제약조건삭제
    
    PRIMARY KEY, FOREIGN KEY UNIQUE CHECK : DROP 제약조건명
    NOT NULL : MODIFY 칼럼명 NULL;
*/
-- DEPT_COPY테이블로부터 PK제약조건 삭제
ALTER TABLE DEPT_COPY DROP CONSTRAINT DC_PK_DI;

-- NN, UNIQUE 삭제
ALTER TABLE DEPT_CODPY DROP CONSTRAINT DC_UQ_DT
MODIFY LNAME NULL;

--3) 컬럼명 / 조약조건명 / 테이블명 변경(RENAME)
--DEPT_COPY DEPT_TITLE -> DEPT_NAME
ALTER TABLE DEPT_COPY RENAME COLUMN DEPT_TITLE TO DEPT_NAME;

ALTER TABLE DEPT_COPY RENAME CONSTRAINT SYS_C008562 TO DC_CONSTRAINT;

--기존테이블명은 생략가능. ALTER (TABLE 테이블명) 에서 이미 기술했으므로
ALTER TABLE DEPT_COPY RENAME TO DEPT_TEST;


/*
   2. DROP
   객체를 삭제하는 구문.
   
   DROP TABLE 테이블명 [제약조건에 대한 옵션]
*/
DROP TABLE DEPT_COPY2;

-- 부모테이블을 삭제하는 경우?
ALTER TABLE DEPT_TEST ADD PRIMARY KEY(DEPT_ID);

ALTER TABLE EMPLOYEE_COPY3 ADD FOREIGN KEY(DEPT_CODE) REFERENCES ADD TEST;

UPDATE DEPT_TEST SET DEPT_ID = RTRIM(DEPT_ID);

SELECT * FROM DEPT_TEST;
SELECT * FROM EMPLOYEE_COPY3;

-- 단 어딘가에 참조되고 있는 부모테이블은 삭제되지 않는다.
DROP TABLE DEPT_TEST;

-- 순서상 1) DROP
-- 2) DROP TABLE 부모테이블

-- 부모테이블만 삭제하되, 현재칼럼을 참조하고 있는 왜ㅐ미 함꼐 삭제
DROP TABLE DEPT_TEST CASCADE CONSTRAINT; 





















































































