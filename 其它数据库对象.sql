-- start: 0920 
-- ppt: ��ͼ
-- 1. ��Դ�ڱ���������ӱ���ȥ��ѯ��

-- �ɲ�ѯ����������
-- ͼ�⣺
-- 3��������ѯ��f1...f5 ���У��γ���ͼ
   �ô����´���ȥ��ѯ����Ҫ��ȥ������ѯ
          ���ƣ�1���ٶȿ�ȹ�����ѯЧ�ʸ�
                2���Գ���Ա������Ҫ��ȥд���ӵĹ�����ѯ
-- ��ͼ��آ�����ݿ����Դ洢������ֵ����ʽ���ڡ�
    ���壺���ݿⲻ�����ݣ���������󡢶��塣 

-- ppt: ��ͼ������
-- read, exp: �Ӽ���1. ֻ�ṩ���ĵ����� 2. ��ͨԱ����ֻ�ܲ鿴
-- �򻯲���������Ա������д���ӵĹ�����ѯ
             ��Ŀ�У����õ�
-- �������ݣ��û���
               
--0928
-- ppt: ������ͼ
-- ������ͼ
-- ��2��task: 1: Ȩ�ޣ� 2: ����ʹ�õ����
CREATE VIEW emp_view
AS (                            -- ����ָ����ͼ��������
    SELECT empno, ename, job, sal
    FROM emp
    WHERE job = 'SALESMAN'      -- ע�⣺�Ӳ�ѯ����; ��β��error: ȱʧ������
   );
   
-- => ��ʾ��Ȩ�޲��㡣
-- command:

SQL> conn sys/oracle as sysdba;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as sys AS SYSDBA

SQL> grant create view to scott;
Grant succeeded

SQL> conn scott/tiger;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as scott

-- �ٴ�ִ���������
-- views: see view

-- CREATE OR REPLACE VIEW 
-- �����´�����
-- ���������ɶ���ʹ�á�
-- ���Դ���ʱһ����� 


-- ɾ��
DROP VIEW emp_view;
   
-- ����
-- ����������

-- нˮС��1500��Ա��
SELECT * 
FROM emp_view
WHERE sal < 1500;

-- ppt: ������ͼ
-- ������ͼ����ѯ����Ա������Ϣ������Ա�����ڲ��ŵ�����
-- ע�⣺����������
-- ����д����
CREATE VIEW emp_view
AS (
   SELECT a.empno, a.ename, a.job, a.sal, a.deptno, b.dname
   FROM emp a, dept b
   WHERE a.deptno = b.deptno (+)  -- wrong: �﷨�������壺�����⣩
   );

-- ����д��������ϰ��ǰ�����ݡ�
CREATE VIEW emp_view
AS (
   SELECT a.empno, a.ename, a.job, a.sal, a.deptno, b.dname
   FROM emp a 
   LEFT OUTER JOIN dept b ON a.deptno = b.deptno
   );

     
-- ������ͼ����ѯÿ�����ŵ���߹��ʡ���͹��ʺ�ƽ��нˮ�� 
CREATE OR REPLACE VIEW dept_sal_view
AS (
   SELECT deptno, MIN(sal) minSal, MAX(sal) maxSal, AVG(sal) avgSal -- ����Ŀ�ģ���ѯ���㡣
   FROM emp
   WHERE deptno is NOT NULL        -- GROUP BY ����ʱ��NULL��������  
   GROUP BY deptno
   );

-- ����
-- δ����ͼ
SELECT deptno, MIN(sal) minSal, MAX(sal) maxSal, AVG(sal) avgSal -- ����Ŀ�ģ���ѯ���㡣
   FROM emp
   WHERE deptno is NOT NULL        -- GROUP BY ����ʱ��NULL��������  
   GROUP BY deptno;

-- ʹ����ͼ   
SELECT minsal, maxsal
FROM dept_sal_view;

-- �ܽ᣺������ͼ����sql��临�ӡ�

----------------------------------------------------------------------
-- ppt: ͨ���޸���ͼ�޸Ļ���
-- meaning: �ܹ��޸���ͼ���޸���Դ��
-- ������
-- ����ͼ�������Ǹ�����ͼ��
-- ��ֻ��
-- 

-- �����޸�salesman��нˮ��
-- ��see ԭ���нˮ��

-- ԭ��ֱ���޸ı�
UPDATE emp
SET sal = sal + 200
WHERE job = 'SALESMAN';

-- now
UPDATE emp_view
SET sal = sal + 100;  -- ��Ҫwhere job = 'salesman'�𣿲���Ҫ����Ϊ��ͼ�������salesman��
-- ��ʾ�����Ҫ������ȷ�������¡�

SELECT *
FROM emp_view
-- �Ƚϣ��Ѹ��¡�

-- �ܹ����£����������������Ϊ��ͼ�����Ŀ�ģ����ǲ��÷��ʱ�ġ�

-- ����ֻ����ͼ
-- ����ֻ����ͼ
CREATE OR REPLACE VIEW emp_view
AS (
    SELECT empno, ename, job, sal
    FROM emp
    WHERE job = 'SALESMAN'
   ) WITH READ ONLY;    -- READ ONLY Ҫ�ֿ�д   
   
SELECT * FROM emp_view;

UPDATE emp_view
SET sal = sal - 100;    -- ��ͼ��Ϊread only����ʾ���˴������������С�

-- one more thing, ������ͼ
-- ������ͨ�����¸�����ͼ���޸Ļ��� !! ע�ͷŵ�ƽ��нˮ�����нˮ����ͼ��ѯ��ȥ��
-- why? ������ͼ��һ�㶼��Щͳ����ģ������ƽ��ֵ�������𣿲��ܸ��»���ġ�
-- �˽��£�һ�㲻����ô�õġ�

-- 0948
-- ex
-- 1020

-- ppt: ��ʱ��ͼ p.13
-- ��ʱ��ͼ��ʹ�ã�top-n����
-- ppt: top-n����
-- +: mysql: limit, sqlserver: top����

-- TOP-N����
-- ��ѯнˮ��ߵ�3��Ա������Ϣ
-- �Ӳ�ѯ, rownum
-- exp: rownum
-- rownumα�У�������ʾ��������кš���whyҪ��α�У�
          becs: ���ݴ洢ʱû���кŵģ���ʾʱ�����ϵġ�
eg.
SELECT ROWNUM, ename, empno, sal, ROWID
FROM emp
ORDER BY sal DESC;       


SELECT rownum, t.empno, t.ename, t.sal  
-- SELECT rownum, t.*                       -- 2nd
  FROM (SELECT rownum, empno, ename, sal    -- 
        FROM emp
         ORDER BY sal DESC -- nullֵ���򣺷�����󣬲�����asc, desc.
        ) t                
 WHERE rownum <= 3;

-- => ��ִ����where������.
-- => Ȼ����ִ����� where�����ġ�

-- Ҫ����� �Ӽ��䣬������ܣ��ͼ��䡣


-- TOP-N��������ѯнˮ�ǵ�4-6λ��Ա������Ϣ��
-- ���ڷ�ҳ��ѯ

SELECT rownum, t.empno, t.ename, t.sal  
  FROM (SELECT rownum, empno, ename, sal     
        FROM emp
         ORDER BY sal DESC 
        ) t                
 WHERE rownum <= 6 AND ROWNUM >= 3;
-- => outcome: 0 rows
-- why?
-------------------
help:  ROWNUM Pseudocolumn 
Conditions testing for ROWNUM values greater than a positive integer are always false. 
For example, this query returns no rows:

SELECT * FROM employees
    WHERE ROWNUM > 1;

The first row fetched is assigned a ROWNUM of 1 and makes the condition false. 
The second row to be fetched is now the first row and is also assigned a ROWNUM of 1 and makes the condition false. 
All rows subsequently fail to satisfy the condition, so no rows are returned.
---------------------
sln:

SELECT * from (
 SELECT rownum r, t.*                                   --2��
  FROM (SELECT rownum, empno, ename, sal    
        FROM emp
         ORDER BY sal DESC -- nullֵ���򣺷�����󣬲�����asc, desc.
        ) t                                             --2�����
)
WHERE r < =6 AND R >3;

-- ���ͣ�
-- ��ִ��2���Ӳ�ѯ: rownum r ����ղ�rownum ���ܴ�������������
-- Ȼ���ٽ������忴��1������� ��ʱr�Ͳ���rownum�ˣ����Ǳ����ͨ�����ˡ�

-- Ҫ����ⲻ�ˣ��ͼ�ס��
-- �´�дʱ�����Σ�ֻҪ�������ľͿ��ԣ���2���ǲ��øĵġ�

-- 10:34
-- ex
-- 10:49



 

   
   

