/* 
    <INDEX>
    - 인덱스 ? 데이터를 빠르게 검색하기 위한 객체로 데이터의 정렬과, 탐색과 같은 DBMS의 성능향상을 목적으로 생성하는 객체.
    - 배열에서와 같이 INDEX는 '목차'라는 의미를 가졌다.
    - 테이블의 찾고자하는 정보(칼럼값)을 통해 인덱스를 만들면, 인덱스로 지정된 칼럼은 별도의 저장공간에 컬럼값과 
    위치정보(ROWID)가 함께 저장됨. 이때, 검색의 편리성을 위해 컬럼값 기준 오름차순하여 데이터를 보관해둔다.
    - 인덱스의 자료구조는 일반적으로 B*TREE 자료 구조로 구현되어있다.
     * B*Tree?
        부트, 브랜치, 리프 노드가 존재하며 루트노드에서 리프까지 항상 균등한 깊이를 가진 형태의 자료구조.
        루트와 브랜치는 값의 범위(1~10, 5~50)를 KEY값으로 가지고 있고
        리프노드는 실제 인덱스의 KEY값과 해당 테이블의 칼럼에 접근할 수 있는 위치주소(ROWID)를 보관하고 있으며, 이 값들은
        KEY값 기준으로 정렬되어있다.
        
    인덱스활용처?
    - SELECT, JOIN문등이 실행될때 각 조건절에서 인덱스로 지정한 칼럼이 사용될 경우 DBMS에 의해 사용될 수 있음.
    
    [표현법]
    CREATE INDEX 인덱스명 ON 테이블명(칼럼명, 칼럼명2, 칼럼명3,.......);
    
    자동생성 : 
    PRIMARY KEY || UNIQUE 제약조건 설정시 자동으로 생성.
*/
SELECT * FROM USER_MOCK_DATA; -- CARD : 62819 , COST : 137

-- 현재계정의 인덱스정보들 확인
SELECT * FROM USER_INDEXES;

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222; -- CARDINALITY : 5 COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL = 'niacobassi65@shareasale.com'; -- CARDINALITY : 5 COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male'; -- CARDINALITY : 31342 COST = 137

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%'; -- CARDINALITY : 3692 COST = 137

ALTER TABLE USER_MOCK_DATA
ADD CONSTRAINT UMD_PK_ID PRIMARY KEY(ID);

ALTER TABLE USER_MOCK_DATA
ADD CONSTRAINT UMD_UQ_EMAIL UNIQUE(EMAIL);

SELECT * FROM USER_MOCK_DATA
WHERE ID = 22222; -- CARD : 1, COST : 2

SELECT * FROM USER_MOCK_DATA
WHERE EMAIL = 'niacobassi65@shareasale.com';

CREATE INDEX IDX_USER_MOCK_DATA_GENDER ON USER_MOCK_DATA(GENDER);

SELECT * FROM USER_MOCK_DATA
WHERE GENDER = 'Male'; -- FULL SCAN 해버림 CARD : 31342 COST : 137 

CREATE INDEX IDX_UMD_FN ON USER_MOCK_DATA(FIRST_NAME);

SELECT * FROM USER_MOCK_DATA
WHERE FIRST_NAME LIKE 'R%'; -- FULL SCAN. INDEX를 사용하는것보다 전체 행을 읽는게 더 효율적이라고 판단.

SELECT * FROM USER_MOCK_DATA
WHERE ID >= 1000 AND ID <= 2000;

/* 
    인덱스를 효율적으로 쓰기위해선?
    - 데이터의 분포도가 높고, 조건절에서 자주 사용되며, 중복값이 적은 컬럼이 좋다.
    
    1) 조건절에 자주 등장하는 칼럼
    2) 항상 =로 비교되는 칼럼
    3) 중복되는 데이터가 최소한인 칼럼 == 분포도가 높은 칼럼
    4) ORDER BY절에 자주 사용되는 칼럼
    5) JOIN시 자주 사용되는 칼럼
    
    인덱스 장점
    1) SELECT, JOIN시 인덱스 칼럼을 사용하면 훨씬 빠르게 연산 가능.
    2) 인덱스 칼럼기준으로 ORDER BY연산을 할 필요가 없음.
    3) 인덱스칼럼을 통해 MIN, MAX를 찾을때 연산속도가 매우빠름.
    
    인덱스 단점
    1) 인덱스가 많을수록 저장공간을 잡아먹음
    2) DML에 취약함.
        INSERT, UPDATE, DELETE등 새롭게 데이터가 추가 및 삭제되면 인덱스테이블안에 있는 값들을 다시 정렬하고, 물리적인 주소값도 수정해줘야함.
    3) INDEX를 활용한 검색보다, 테이블전체를 FULL~SCAN하는게 더 유리할때가 있음.
*/




















