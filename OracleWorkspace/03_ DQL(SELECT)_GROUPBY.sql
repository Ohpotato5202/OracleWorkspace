/*
    <GROUP BY 절>
    
    그룹을 묶어줄 기준을 제시할 수 있는 구문
    그룹별 집합결과를 반환해주는 그룹함수와 함꼐 사용된다.
    GROUP BY 절에 제시된 컬럼을 기준으로 그룹을 묶을 수 있고, 여러개의 컬럼을 제시해서 여러 그룹 만들 수도 있음.
    
    [표현법]
    GROUP BY 컬럼 
    
*/

-- 각 부서별로 총 급여의 합계 
SELECT DEPT_CODE, SUM(SALARY)   -- 4
FROM EMPLOYEE                   -- 1
WHERE 1=1                       -- 2
GROUP BY DEPT_CODE              -- 3
ORDER BY 1;                     -- 5

-- 'D1' 부서 총급여 합
SELECT SUM(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 각 부서별 총 급여 합을, 부서별 오름차순으로 정렬하여 조회
SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
ORDER BY 1;

-- 각 부서별 총 급여 합을 급여별 내림차순으로 정렬해서 조회
SELECT DEPT_CODE, SUM(SALARY)   --3
FROM EMPLOYEE       -- 1
GROUP BY DEPT_CODE  -- 2
ORDER BY 2 DESC     -- 4
;

-- 각 직급별 직급코드와 총 급여의 합, 사원수, 보너스를 받는 사원수, 평균급여, 최고급여, 최소급여
SELECT 
    JOB_CODE,
    SUM (SALARY) 총급여합,
    COUNT (*) 사원수,
    COUNT (BONUS) 보너스를받는사원수,
    AVG (SALARY) 평균급여,
    MAX (SALARY) 최고급여,
    MIN (SALARY) 최저급여
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- 각 부서별 부서코드, 사원수, 보너스를 받는 사원수, 사수가 있는 사원수, 평균급여를 부서별 오름차순 정렬하여 구하시오.
SELECT 
    DEPT_CODE 부서코드,
    COUNT (*) 사원수,
    COUNT (BONUS) "보너스를 받는 사원 수",
    COUNT (MANAGER_ID),
    AVG(SALARY)
FROM EMPLOYEE
WHERE DEPT_CODE IS NOT NULL 
GROUP BY DEPT_CODE
ORDER BY 1;

-- 성별별 사원 숫자 구하기 
SELECT SUBSTR(EMP_NO, 8, 1) "성별",
       COUNT(*)
FROM EMPLOYEE
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 성별 기준으로 평균급여 구하기
-- 성별의 값이 1일 때는 남자, 2일때는 여자 값이 대신 나오도록 하고 
-- 평균급여는 반올림 처리한 후, 0000000 형식으로 반환. 
SELECT
    CASE SUBSTR(EMP_NO, 8, 1) WHEN '1' THEN '남자'
                              WHEN '2' THEN '여자'
                              END 성별,
    TO_CHAR(ROUND(AVG(SALARY)),'9,999,999') || '원' 평균급여     -- 형식 변환과 문자열 이어붙이기는 별도로......
FROM EMPLOYEE 
GROUP BY SUBSTR(EMP_NO, 8, 1);

-- 부서별 월급이 200만원 이하인 사원의 수?
SELECT 
    DEPT_CODE,
    COUNT (CASE WHEN SALARY <= 2000000 THEN 1 ELSE NULL END) "급여 2,000,000원 이하 사원" 

FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 모든 부서별로 직급별로 부서코드, 직급코드가 'J6'인 사원의 수 
-- 부서내에 직급코드가 'J6'인 사원이 없다면 0 

SELECT 
    DEPT_CODE,
    COUNT(CASE WHEN JOB_CODE = 'J6' THEN 1 ELSE NULL END)
--  COUNT(DECODE(JOB_CODE, 'J6', 1))  위와 동일한 조건 함수
FROM EMPLOYEE
GROUP BY DEPT_CODE;

-- 각 부서별로 평균급여가 300만원 이상인 부서들만 조회시
SELECT DEPT_CODE, ROUND(AVG(SALARY)) 평균급여 -- 4
FROM EMPLOYEE -- 1
WHERE ROUND (AVG (SALARY)) >= 3000000 -- 2 -- 오류 발생 문법상 현재 위치에서 그룹함수를 호출할 수 없음.
GROUP BY DEPT_CODE; -- 3

/*
    <HAVING 절>
    그룹에 대한 조건을 제시할 때 사용되는 구문
    - GROUP BY절과 함께 사용함. 그룹화된 데이터를 기준으로만 조건을 제시할 수 있음. 

*/

SELECT 
    DEPT_CODE,
    ROUND (AVG(SALARY)) -- 4
FROM EMPLOYEE       -- 1
GROUP BY DEPT_CODE  -- 2
HAVING AVG(SALARY) >= 3000000; -- 3

-- 각 직급별 급여 평균이 300만원 이상인 직급 코드, 평균 급여, 사원수, 최고급여, 최소급여

SELECT 
    JOB_CODE,
    ROUND(AVG(SALARY)),
    COUNT (*),
    MAX(SALARY),
    MIN(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE
HAVING AVG(SALARY) >= 3000000;

/*
    <SELECT 문 구조 및 실행 순서>
    5.  SELECT 조회하고자 하는 컬럼들
    1.  FROM 조회하고자 하는 테이블/ 가상테이블(DUAL)/ VIEW
    2.  WHERE 조건식 (단, 그룹함수는 사용불가)
    3.  GROUP BY 그룹화 시킬 컬럼명/함수식
    4.  HAVING 그룹함수식에 대한 조건식 (그룹화가 완료된 이후에 수행)
    6.  ORDER BY 정렬기준 (항상 마지막에 실행)
 
*/

/*
    <집합연산자 SET OPERATOR>
    여러개의 쿼리문을 가지고 하나의 쿼리문으로 만들어주는 연산자
     
     - UNION (합집합) : 두 쿼리문을 수행할 결과값(RESULT SET)을 더한 후 "중복"되는 부분은 제거
     - UNION ALL (합집합) : 두 쿼리문을 수행할 결과값(RESULT SET)을 더한 후 "중복"되는 부분 그대로 둔것.
     - INTERSECT (교집합) : 두 쿼리문을 수행한 후 중복된 부분만 추출
     - MINUS (차집합) : 선행 쿼리문에서 후행 쿼리문 결과값을 뺀 나머지 부분
     
     결과값을 합쳐서 하나의 RESULT SET으로 보여줘야 함. 따라서 두 쿼리문의 SELECT 절 부분은 항상 동일해야 함.(동일한 컬럼을 사용)
     즉, 조회할 컬럼이 동일해야 함. 
*/

-- 1. UNION (합집합) : 두 쿼리문을 수행한 RESULT SET을 더해준 후 중복값은 제거.

-- 부서코드가 D5이거나, 급여가 300만원 초과인 사원들을 조회
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5'; -- 6명

SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명

-- UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE DEPT_CODE = 'D5' -- 6명
UNION
SELECT EMP_ID, EMP_NAME, DEPT_CODE, SALARY
FROM EMPLOYEE
WHERE SALARY > 3000000; -- 8명(부서코드 D5인 사람 2명)

-- 2. UNIONALL : 두개의 쿼리 겨로가를 더해서 보여주는 연산자(단, 중복제거 하지 않음)
-- 직급코드가 J6이거나 또는 부서코드가 D1인 사원들을 조회(사번, 사원명, 부서코드, 직급코드)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE ='J6'; -- 6명 조회(부서코드가 D1인 사원은 2명 존재함)

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE ='D1'; -- 3명 조회(직급코드가 J6인 사원은 2명 존재)



SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE ='J6' -- 6명 조회(부서코드가 D1인 사원은 2명 존재함)
UNION ALL -- 9명 조회(차태연, 전지연 중복행 그대로 추가)
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE ='D1'; -- 3명 조회(직급코드가 J6인 사원은 2명 존재)


-- 3. INTERSECT : 교집합. 여러쿼리 결과의 중복값만 조회 
-- 직급코드가 J6이고 부서코드가 D1인 사원들을 조회 
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'
INTERSECT
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';

-- 4. MINUS : 차집합. 선행 쿼리결과에 후행 쿼리 결과를 뺀 나머지 값.
-- 직급코드가 J6인 사원들 중 부서코드가 D1인 사원들 뺀 나머지 값을 조회 

SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE JOB_CODE = 'J6'  
MINUS
SELECT EMP_ID, EMP_NAME, DEPT_CODE, JOB_CODE
FROM EMPLOYEE
WHERE DEPT_CODE = 'D1';


/*
    그룹별 집계함수
    - GROUP BY로 계산된 그룹별 산출 결과물들을 "소그룹" 별로 추가 집계 해주는 함수들

    1. <ROLLUP>
    ROLLUP(컬럼1, 컬럼2) : GROUP BY로 묶은 소그룹 간의 합계와 전체합계, 컬럼 1번 그룹의 합계를 산출
    GROUP BY ROLLUP(컬럼1, 컬럼2) == GROUP BY(컬럼1, 컬럼2) + GROUP BY 컬럼1 + 모든 집합 그룹결과
   
    2. <CUBE>
    CUBE(컬럼1, 컬럼2) : GROUP BY 로 묶은 소그룹 간의 합계와 전체합계, 컬럼 1번그룹, 컬럼 2번그룹의 합계를 모두 반환
    GROUP BY CUBE(컬럼1, 컬럼2) == GROUP BY(컬럼1, 컬럼2) + GROUP BY 컬럼1 + GROUP BY 컬럼2 +모든 집합 그룹결과
   
    3. <GROUPING SETS>
    GROUPING SETS(컬럼1, 컬럼2) : GROUP BY로 묶은 컬럼 1번, 컬럼 2번 그룹의 합계를 반환
    GROUP BY SETS(컬럼1, 컬럼2) == GROUP BY 컬럼1 + GROUP BY 컬럼2
*/

-- 부서별 급여 총합. 
-- ROLLUP 함수 
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;
---------------------------------------------------------
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE 
UNION ALL

SELECT DEPT_CODE, NULL AS JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE

UNION ALL
SELECT NULL AS DEPT_CODE, NULL AS JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
ORDER BY DEPT_CODE ASC;
---------------------------------------------------------
-- CUBE (모든 조합별 통계를 구함)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY CUBE(DEPT_CODE, JOB_CODE)
ORDER BY 1;

-- GROUPING SETS(컬럼1, 컬럼2)
SELECT DEPT_CODE, JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY GROUPING SETS(DEPT_CODE, JOB_CODE);

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE
UNION ALL
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY JOB_CODE;

-- GROUPING 
-- 그룹 집계함수와 함께 사용되며, NULL값이 아닌 다른 값으로 대체할 때 사용함. 
SELECT 
    CASE WHEN GROUPING (DEPT_CODE) = 1 THEN '총합'
         --WHEN GROUPING(DEPT_CODE) = 1 AND GROUPING(JOB_CODE) = 1 THEN '총합'
         WHEN DEPT_CODE IS NULL THEN '부서코드없음' 
         ELSE DEPT_CODE 
    END AS 부서코드,
    CASE GROUPING (JOB_CODE) WHEN 1 THEN ' ' 
         ELSE JOB_CODE 
    END AS 직급코드,
    SUM(SALARY)
FROM EMPLOYEE
GROUP BY ROLLUP(DEPT_CODE, JOB_CODE)
ORDER BY DEPT_CODE;












