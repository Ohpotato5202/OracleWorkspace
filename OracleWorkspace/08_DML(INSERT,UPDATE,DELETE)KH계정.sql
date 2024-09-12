/*
    *DML(DATA MANIPULATION LANGUAGE)
    데이터 조작 언어
    
    테이블에 새로운 데이터를 삽입(INSERT) 하거나
    기존의 데이터를 수정(UPDATE) 하거나
    삭제(DELETE) 하는 구문들.
*/
/*
   1. INSERT : 테이블에 새로운 "행"을 추가하는 구문.
   [표현법]
   
   *INSERT INTO 계열 
   
   1) INSERT INTO 테이블명 VALUES(갑1, 값2, ....);
   => 테이블에 모든 칼럼에 대해 추가하고자 하는 값을 내가 집적제시해서
      "한행"을 INSERT 하고자 할때 쓰는 표현법.
      
   주의사항 : 컬럼의 순서, 자료형, 갯수를 맞춰서 VALUES의 괄호안에 값들을 나열해야한다.
   - 부족하게 제시하면 : NOT ENOUGH VALUE 오류
   - 더 많이 제시하면 : TOO MANY VALUE 오류
*/
INSERT INTO EMPLOYEE 
VALUES(900, '두진', '123456-1234567', 'KDJ@NAVER.COM', '010-1234-1234', 'D1','J1','S1',8000000,'0.5',NULL,
SYSDATE, NULL, 'Y');

/*
    2) INSERT INTO 테이블명(칼럼명, 칼럼명, 칼럼명, ....)
       VALUES (값1, 값2, 값3,....);
       
       => 테이블에 "특정" 칼럼만 선택해서 그 칼럼에만 추가할 값을 제시하고자 할때 사용.
       한 행단위로 데이터 추가되기 때문에 선택안한 컬럼은 NULL값이 들어가거나, DEFAULT값이 들어간다.
       단, NOT NULL제약조건이 들어간 칼럼은 반드시 값을 제시해줘야함.
*/

INSERT INTO EMPLOYEE (DEPT_CODE, JOB_CODE, SAL_LEVEL, EMP_ID, EMP_NAME, EMP_NO)
VALUES('D1','J1','S1',901,'김두진','123456-1234567');

SELECT * FROM EMPLOYEE;

/*
    3) INSERT INTO 테이블명 (서브쿼리);
    => VALUES()로 값을 집적 기입하는게 아니라
       서브쿼리로 조회한 결과값을 통째로 INSERT하는 구문.
       즉, 여러행을 한번에 INSERT가능.
*/
-- 새로운 테이블 생성
CREATE TABLE EMP_01(
   EMP_IN NUMBER,
   EMP_NAME VARCHAR2(30),
   DEPT_TITLE VARCHAR2(20)
);


--전체 사원들의 사번, 이름 ,부서명을 추가
INSERT INTO EMP_01
SELECT EMP_ID, EMP_NAME, DEPT_TITLE
FROM EMPLOYEE, DEPARTMENT
WHERE DEPT_CODE = DEPT_ID(+);

INSERT INTO EMP_01

SELECT * FROM 

     SELECT 902, '아무개1' , '총무부' FROM DUAL
     
     UNION ALL

     SELECT 903, '아무개2' , '인사관리부' FROM DUAL
     
     UNION ALL

     SELECT 904, '아무개3' , '해외영입부' FROM DUAL
;
/*
    * INSERT ALL 계열
    두 개 이상의 테이블에 각각 INSERT할 때 사용.
    조건 : 사용되는 서브쿼리가 동일해야한다.
    
    1) INSERT ALL
       INTO 테이블명1 VALUES(칼럼명, 칼럼명...)
       INTO 테이블명2 VALUES(칼럼명, 칼럼명...)
       서브쿼리;
*/
-- 새로운 테이블 생성
-- 첫 번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 직급명을 보관할 테이블
CREATE TABLE EMP_JOB(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    JOB_NAME VARCHAR2(20)
);



-- 두 번째 테이블 : 급여가 300만원 이상인 사원들의 사번, 사원명, 부서명을 보관할 테이블
CREATE TABLE EMP_DEPT(
    EMP_ID NUMBER,
    EMP_NAME VARCHAR2(30),
    DEPT_TITLE VARCHAR2(20)
);

SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
FROM EMPLOYEE
LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
JOIN JOB USING(JOB_CODE)
WHERE SALARY >= 3000000;

INSERT ALL
INTO EMP_JOB VALUES(EMP_ID, EMP_NAME, JOB_NAME)
INTO EMP_DEPT VALUES(EMP_ID, EMP_NAME, DEPT_TITLE)
    SELECT EMP_ID, EMP_NAME, JOB_NAME, DEPT_TITLE
    FROM EMPLOYEE
    LEFT JOIN DEPARTMENT ON DEPT_CODE = DEPT_ID
    JOIN JOB USING(JOB_CODE)
    WHERE SALARY >= 3000000;

--------------------------------------------------------------------------------
/*
    2) INSERT ALL
           WHEN 조건1 THEN
                INTO 테이블명1 VALUES(컬럼명, 컬럼명 ...)
           WHEN 조건 2 THEN
                INTO 테이블명2 VALUES(컬럼명, 컬럼명...)
           서브쿼리;
    - 조건에 맞는 값들만 추가하겠다.
*/

-- 2010년도 기준으로 2010년을 포함한 이후년도에 입사한 사원들의 사번, 사원명, 입사일, 급여를 저장.
CREATE TABLE EMP_NEW
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;

-- 2010년도 기준으로 2010년 이전에 입사한 사원들의 사번, 사원명, 입사일, 급여를 저장.
CREATE TABLE EMP_OLD
AS SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE
   WHERE 1=0;

SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
   FROM EMPLOYEE;

INSERT ALL
WHEN HIRE_DATE < '2010/01/01' THEN
    INTO EMP_OLD VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
WHEN HIRE_DATE >= '2010/01/1' THEN
    INTO EMP_NEW VALUES(EMP_ID, EMP_NAME, HIRE_DATE, SALARY)
SELECT EMP_ID, EMP_NAME, HIRE_DATE, SALARY
    FROM EMPLOYEE;

SELECT * FROM EMP_NEW;

--------------------------------------------------------------------------------

/*
    2. UPDATE
    
    - 테이블에 기록된 데이터를 "수정"하는 구문
    [표현법]
    UPDATE 테이블명 SET
    컬럼명 = 바꿀값 ,
    컬럼명 = 바꿀값 , -- 여러개의 컬럼값을 동시에 변경 가능. 단, 로 나열한다.
    ...
    WHERE 조건; -- WHERE 절은 생략이 가능하지만 생략시 모든행의 데이터가 변경.
*/

-- 복사본 테이블 만든 후 작업
CREATE TABLE DEPT_COPY
AS SELECT * FROM DEPARTMENT;

-- DEPT_COPY D9부서의 부서명 수정하기
UPDATE DEPT_COPY SET
   DEPT_TITLE = '전략기획팀' 
WHERE DEPT_ID = 'D9';

SELECT * FROM DEPT_COPY;

COMMIT;

ROLLBACK; -- 변경사항을 취소. 되돌리는 명령어.

CREATE TABLE EMP_SALARY
AS SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY, BONUS FROM EMPLOYEE;

SELECT * FROM EMP_SALARY;

-- 1. EMP_SALARY테이블에서 선동일 사원의 급여를 700만원, 보너스를 0.2로 변경
UPDATE EMP_SALARY SET
    SALARY = 7000000,
    BONUS = 0.2
WHERE EMP_NAME = '선동일';

-- 2. 전체 사원의 급여를 20프로 인상한 금액으로 변경.
UPDATE EMP_SALARY SET
    SALARY = SALARY * 1.2;

/*
   UPDATE+서브쿼리
   - 서브쿼리를 수행한 결과값으로 기존의 값을 변경.
   
   [표현법]
   UPDATE 테이블명
   SET 컬럼명 = (서브쿼리)
   WHERE 조건;
*/
-- EMP_SALARY테이블에 박말똥 사원의 부서코드를 선동일 사원의 부서코드로 변경
-- 박말똥 사원의 부서코드는 D1/ 선동일 사원의 부서코드 ㅇ9
UPDATE EMP_SALARY SET
DEPT_CODE = (SELECT DEPT_CODE FROM EMP_SALARY WHERE EMP_NAME = '선동일')
WHERE EMP_NAME = '박말똥';

-- 방명수 사원의 급여와, 보너스를 유재식 사원의 급여와 보너스값으로 변경.
-- 단일행 다중열 서브쿼리를 통해 값을 변경
UPDATE EMP_SALARY SET
(SALARY, BONUS) = (SELECT SALARY, BONUS FROM EMP_SALARY WHERE EMP_NAME = '유재식')
WHERE EMP_NAME = '방명수';

SELECT * FROM EMP_SALARY;  

-- UPDATE작업시 주의점.
-- 칼럼에 적용된 제약조건을 반드시 지켜야함.
UPDATE EMPLOYEE 
SET EMP_ID = 200
WHERE EMP_NAME = '송종기';
  
COMMIT;

/*
    4. DELETE
    
    테이블의 기록된 데이터를 "행" 단위로 삭제하는 구문.
    
    [표현법]
    DELETE FROM 테이블명
    WHERE 조건; -- 조건절 생략시 모든행 삭제.
*/
-- EMPLOYEE 테이블의 모든 행 삭제
DELETE FROM EMPLOYEE;

SELECT * FROM EMPLOYEE;

ROLLBACK; -- 마지막으로 커밋한 시점으로 돌아감.

-- EMPLOYEE 테이블로부터 경민, 박말똥 사원의 정보를 지우기
DELETE FROM EMPLOYEE
WHERE EMP_NAME IN('경민','김두진');

/*
    TRUNCATE : 테이블의 전체 행을 모두 삭제할때 사용하는 구문(절삭)
               DELETE구문보다 수행속도가 빠름.
               단, 별도의 조건을 제시 불가.
               ROLLBACK이 불가능함.
    [표현법]
    TRUNCATE TABLE 테이블명;
         
         TRUNCATE TABLE 테이블명         |          DELETE FROM 테이블명;
        ================================================================
               조건제시 불가              |          특정 조건 제시 가능
               수행속도 빠름              |          수행속도 느림
               ROLLBACK 불가             |          ROLLBACK 가능.
*/

SELECT * FROM EMP_SALARY;

DELETE FROM EMP_SALARY;

ROLLBACK;

TRUNCATE TABLE EMP_SALARY; -- ROLLBACK 불가.

-- DEPARTMENT테이블로부터 DEPT_ID가 D1인 부서 삭제.
DELETE FROM DEPARTMENT WHERE DEPT_ID = 'D1';

INSERT INTO DEPARTMENT VALUES('D1','인사관리부','L1');

ROLLBACK;

SELECT * FROM EMPLOYEE;

ALTER TABLE EMPLOYEE ADD FOREIGN KEY(DEPT_CODE) REFERENCES DEPARTMENT; 

DELETE FROM DEPARTMENT
WHERE DEPT_ID = 'D1';


























