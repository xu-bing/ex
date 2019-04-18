-- 创建视图的前提：授权
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
-- 创建salesman的视图
CREATE VIEW emp_view 
AS (
   SELECT empno, ename, job, sal
   FROM emp
   WHERE job = 'SALESMAN'
   );
   

-- create or replace: 常用
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

-- 删除视图
DROP VIEW emp_view;

---------------
-- 复杂视图
-- 创建1个视图，查询“所有的”员工信息，包括部门名称
CREATE OR REPLACE VIEW emp_view 
AS (
   SELECT e.empno, e.ename, e.job, e.sal, e.deptno, d.dname
   FROM emp e LEFT OUTER JOIN dept d 
        ON e.deptno = d.deptno
);

-- test
SELECT *
FROM emp_view;

-- 创建视图：查询每个部门下的最高、高低、平均薪水
-- 不允许通过更新复杂视图来修改基表
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

-- 创建备份表
CREATE TABLE dept_sal_tbl
AS (
   SELECT deptno, MAX(sal) AS maxSal, MIN(sal) AS minSal, AVG(sal) AS avgSal
   FROM emp
   WHERE deptno IS NOT NULL
   GROUP BY deptno
);

SELECT * FROM dept_sal_tbl;

-----------------------------------------------------------
-- 通过视图来更改基表
-- 条件：1. 简单视图 2.视图非只读
SELECT *
FROM emp_view;

UPDATE emp_view
SET sal = sal + 1000;

--  创建只读视图
CREATE OR REPLACE VIEW emp_view 
AS (
   SELECT empno, ename, job, sal
   FROM emp
   WHERE job = 'SALESMAN'
   ) WITH READ ONLY; -- with read only: 创建只读视图

UPDATE emp_view
SET sal = sal - 1000;
-- => error: 此处不允许虚拟列: 原因：要更新只读视图

-- test: 不允许通过更新复杂视图来修改基表
UPDATE dept_sal_view
SET minSal = 1000;

-----------------------------------------------------------
-- top-n分析
-- 教案1：
SELECT rownum, empno, ename, job, sal, ROWID
FROM emp;

-- 查询前3名员工的信息：即行号<4的员工的信息
SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE ROWNUM < 3;

SELECT ROWNUM, empno, ename, job, sal
FROM emp
WHERE  ROWNUM >1;     -- false

-- 查询薪水在4-6位的员工的信息
-- 算法：
-- 子查询1：查询员工薪水并排序(子查询须取别名)
-- 子查询2：给排序后的结果加上行号（行号须取别名，使其变成1个普通列）
-- 外查询：按行号进行过滤
SELECT *
FROM (SELECT ROWNUM r, t.*
      FROM (SELECT empno, ename, job, sal
            FROM emp
            ORDER BY sal) t)
WHERE r <= 6 AND r >= 4;

-- 教案2：
SELECT rownum, empno, ename, job, sal FROM emp ORDER BY sal;



-----------------------------------------------------------
-- 序列
CREATE SEQUENCE myseq
                INCREMENT BY 1
                START WITH 1000
                MINVALUE 1000
                MAXVALUE 9999
                NOCYCLE;

-- 创建下一个值
SELECT myseq.nextval FROM dual;     
     
-- 在刚创建sequence之后，不能使用currval   
SELECT myseq.currval FROM dual;

-- 修改序列
ALTER SEQUENCE myseq
               INCREMENT BY 3
               MINVALUE 1000     -- minvalue <= currval
               MAXVALUE 9999
               -- START WITH 1000     -- 无法更改启动序列值
               NOCYCLE;
               
-- 使用序列来生成主键值
INSERT INTO emp(empno, ename)
VALUES (myseq2.nextval, 'tom');

COMMIT;

SELECT * FROM emp WHERE empno < 4000;

-----------------------------------------------------------
-- 创建索引
CREATE INDEX dept_deptno_dname
ON dept(deptno, dname); 

CREATE INDEX dept_deptno_dname2
ON dept(deptno, dname); 
-- => error: 已创建索引的列表，不允许再创建索引


               
                
            







