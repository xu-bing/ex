-- ������ͼ��ǰ�᣺��Ȩ
/*
SQL> conn sys/oracle as sysdba;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as SYS
 
SQL> grant create view to scott;
 
Grant succeeded
 
SQL> conn scott/tiger;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as scott
*/

-- create view
-- ����salesman����ͼ
CREATE VIEW emp_view 
AS (
   SELECT empno, ename, job, sal
   FROM emp
   WHERE job = 'SALESMAN'
   );
   

-- create or replace: ����
CREATE OR REPLACE VIEW emp_view 
AS (
   SELECT empno, ename, job, sal
   FROM emp
   WHERE job = 'SALESMAN'
   );

-- test
SELECT *
FROM emp_view;

SELECT *
FROM emp_view
WHERE sal < 1500;

-- ɾ����ͼ
DROP VIEW emp_view;

---------------
-- ������ͼ
-- ����1����ͼ����ѯ�����еġ�Ա����Ϣ��������������
CREATE OR REPLACE VIEW emp_view 
AS (
   SELECT e.empno, e.ename, e.job, e.sal, e.deptno, d.dname
   FROM emp e LEFT OUTER JOIN dept d 
        ON e.deptno = d.deptno
);

-- test
SELECT *
FROM emp_view;

-- ������ͼ����ѯÿ�������µ���ߡ��ߵ͡�ƽ��нˮ
-- ������ͨ�����¸�����ͼ���޸Ļ���
CREATE OR REPLACE VIEW dept_sal_view
AS (
   SELECT deptno, MAX(sal) AS maxSal, MIN(sal) AS minSal, AVG(sal) AS avgSal
   FROM emp
   WHERE deptno IS NOT NULL
   GROUP BY deptno
);

-- test
SELECT *
FROM dept_sal_view;

-- �������ݱ�
CREATE TABLE dept_sal_tbl
AS (
   SELECT deptno, MAX(sal) AS maxSal, MIN(sal) AS minSal, AVG(sal) AS avgSal
   FROM emp
   WHERE deptno IS NOT NULL
   GROUP BY deptno
);

SELECT * FROM dept_sal_tbl;

-----------------------------------------------------------
-- ͨ����ͼ�����Ļ���
-- ������1. ����ͼ 2.��ͼ��ֻ��
SELECT *
FROM emp_view;

UPDATE emp_view
SET sal = sal + 1000;

--  ����ֻ����ͼ
CREATE OR REPLACE VIEW emp_view 
AS (
   SELECT empno, ename, job, sal
   FROM emp
   WHERE job = 'SALESMAN'
   ) WITH READ ONLY; -- with read only: ����ֻ����ͼ

UPDATE emp_view
SET sal = sal - 1000;
-- => error: �˴�������������: ԭ��Ҫ����ֻ����ͼ

-- test: ������ͨ�����¸�����ͼ���޸Ļ���
UPDATE dept_sal_view
SET minSal = 1000;

-----------------------------------------------------------
-- top-n����
-- �̰�1��
SELECT rownum, empno, ename, job, sal, ROWID
FROM emp;

-- ��ѯǰ3��Ա������Ϣ�����к�<4��Ա������Ϣ
SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE ROWNUM < 3;

SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE  ROWNUM >1;     -- false

-- ��ѯнˮ��4-6λ��Ա������Ϣ
-- �㷨��
-- �Ӳ�ѯ1����ѯԱ��нˮ������(�Ӳ�ѯ��ȡ����)
-- �Ӳ�ѯ2���������Ľ�������кţ��к���ȡ������ʹ����1����ͨ�У�
-- ���ѯ�����кŽ��й���
SELECT *
FROM (SELECT ROWNUM r, t.*
      FROM (SELECT empno, ename, job, sal
            FROM emp
            ORDER BY sal) t)
WHERE r <= 6 AND r >= 4;

-- �̰�2��
SELECT rownum, empno, ename, job, sal FROM emp ORDER BY sal;



-----------------------------------------------------------
-- ����
CREATE SEQUENCE myseq
                INCREMENT BY 1
                START WITH 1000
                MINVALUE 1000
                MAXVALUE 9999
                NOCYCLE;

-- ������һ��ֵ
SELECT myseq.nextval FROM dual;     
     
-- �ڸմ���sequence֮�󣬲���ʹ��currval   
SELECT myseq.currval FROM dual;

-- �޸�����
ALTER SEQUENCE myseq
               INCREMENT BY 3
               MINVALUE 1000     -- minvalue <= currval
               MAXVALUE 9999
               -- START WITH 1000     -- �޷�������������ֵ
               NOCYCLE;
               
-- ʹ����������������ֵ
INSERT INTO emp(empno, ename)
VALUES (myseq2.nextval, 'tom');

COMMIT;

SELECT * FROM emp WHERE empno < 4000;

-----------------------------------------------------------
-- ��������
CREATE INDEX dept_deptno_dname
ON dept(deptno, dname); 

CREATE INDEX dept_deptno_dname2
ON dept(deptno, dname); 
-- => error: �Ѵ����������б��������ٴ�������


               
                
            







