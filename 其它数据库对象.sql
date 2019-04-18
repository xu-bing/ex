-- start: 0920 
-- ppt: 视图
-- 1. 来源于表，决定必须从表中去查询。

-- 由查询决定，决定
-- 图解：
-- 3表，关联查询：f1...f5 五列，形成视图
   好处：下次再去查询不需要再去关联查询
          优势：1）速度快比关联查询效率高
                2）对程序员：不需要再去写复杂的关联查询
-- 视图并丌在数据库中以存储的数据值集形式存在。
    含义：数据库不存内容，但存其对象、定义。 

-- ppt: 视图的优势
-- read, exp: 视集：1. 只提供关心的内容 2. 普通员工，只能查看
-- 简化操作：程序员，不必写复杂的关联查询
             项目中：会用到
-- 定制数据：用户：
               
--0928
-- ppt: 创建视图
-- 创建视图
-- （2个task: 1: 权限， 2: 建议使用的命令）
CREATE VIEW emp_view
AS (                            -- 用来指定视图的来耗损
    SELECT empno, ename, job, sal
    FROM emp
    WHERE job = 'SALESMAN'      -- 注意：子查询不以; 结尾。error: 缺失右括号
   );
   
-- => 提示：权限不足。
-- command:

SQL> conn sys/oracle as sysdba;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as sys AS SYSDBA

SQL> grant create view to scott;
Grant succeeded

SQL> conn scott/tiger;
Connected to Oracle Database 10g Enterprise Edition Release 10.2.0.1.0 
Connected as scott

-- 再次执行上述命令。
-- views: see view

-- CREATE OR REPLACE VIEW 
-- 再重新创建：
-- 名称已有由对象使用。
-- 所以创建时一般命令： 


-- 删除
DROP VIEW emp_view;
   
-- 操作
-- 与表操作无异

-- 薪水小于1500的员工
SELECT * 
FROM emp_view
WHERE sal < 1500;

-- ppt: 复杂视图
-- 创建视图，查询所有员工的信息，包括员工所在部门的名称
-- 注意：用左外连接
-- 错误写法：
CREATE VIEW emp_view
AS (
   SELECT a.empno, a.ename, a.job, a.sal, a.deptno, b.dname
   FROM emp a, dept b
   WHERE a.deptno = b.deptno (+)  -- wrong: 语法不错，语义：（左外）
   );

-- 建议写法，带复习下前面内容。
CREATE VIEW emp_view
AS (
   SELECT a.empno, a.ename, a.job, a.sal, a.deptno, b.dname
   FROM emp a 
   LEFT OUTER JOIN dept b ON a.deptno = b.deptno
   );

     
-- 创建视图，查询每个部门的最高工资、最低工资和平均薪水。 
CREATE OR REPLACE VIEW dept_sal_view
AS (
   SELECT deptno, MIN(sal) minSal, MAX(sal) maxSal, AVG(sal) avgSal -- 别名目的：查询方便。
   FROM emp
   WHERE deptno is NOT NULL        -- GROUP BY 分组时，NULL会参予分组  
   GROUP BY deptno
   );

-- 测试
-- 未用视图
SELECT deptno, MIN(sal) minSal, MAX(sal) maxSal, AVG(sal) avgSal -- 别名目的：查询方便。
   FROM emp
   WHERE deptno is NOT NULL        -- GROUP BY 分组时，NULL会参予分组  
   GROUP BY deptno;

-- 使用视图   
SELECT minsal, maxsal
FROM dept_sal_view;

-- 总结：复杂视图，是sql语句复杂。

----------------------------------------------------------------------
-- ppt: 通过修改视图修改基表
-- meaning: 能过修改视图来修改来源表。
-- 条件：
-- 简单视图，不能是复杂视图。
-- 非只读
-- 

-- 例：修改salesman的薪水。
-- 先see 原表的薪水。

-- 原：直接修改表
UPDATE emp
SET sal = sal + 200
WHERE job = 'SALESMAN';

-- now
UPDATE emp_view
SET sal = sal + 100;  -- 需要where job = 'salesman'吗？不需要，因为视图本身就是salesman的
-- 提示：真的要更新吗？确定，更新。

SELECT *
FROM emp_view
-- 比较，已更新。

-- 能够更新，但不建议和允许。因为视图本身的目的，就是不让访问表的。

-- 引入只读视图
-- 创建只读视图
CREATE OR REPLACE VIEW emp_view
AS (
    SELECT empno, ename, job, sal
    FROM emp
    WHERE job = 'SALESMAN'
   ) WITH READ ONLY;    -- READ ONLY 要分开写   
   
SELECT * FROM emp_view;

UPDATE emp_view
SET sal = sal - 100;    -- 视图设为read only后，提示：此处不允许虚拟列。

-- one more thing, 更新视图
-- 不允许通过更新复杂视图来修改基表 !! 注释放到平均薪水、最高薪水的视图查询中去。
-- why? 复杂视图，一般都是些统计类的，你更新平均值有意义吗？不能更新基表的。
-- 了解下，一般不会这么用的。

-- 0948
-- ex
-- 1020

-- ppt: 临时视图 p.13
-- 临时视图的使用：top-n分析
-- ppt: top-n分析
-- +: mysql: limit, sqlserver: top函数

-- TOP-N分析
-- 查询薪水最高的3个员工的信息
-- 子查询, rownum
-- exp: rownum
-- rownum伪列，用来显示结果集的行号。？why要叫伪列？
          becs: 数据存储时没有行号的，显示时给加上的。
eg.
SELECT ROWNUM, ename, empno, sal, ROWID
FROM emp
ORDER BY sal DESC;       


SELECT rownum, t.empno, t.ename, t.sal  
-- SELECT rownum, t.*                       -- 2nd
  FROM (SELECT rownum, empno, ename, sal    -- 
        FROM emp
         ORDER BY sal DESC -- null值排序：放在最后，不管是asc, desc.
        ) t                
 WHERE rownum <= 3;

-- => 先执行无where条件的.
-- => 然后再执行添加 where条件的。

-- 要求：理解 加记忆，如果不能，就记忆。


-- TOP-N分析：查询薪水是第4-6位的员工的信息。
-- 用于分页查询

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
 SELECT rownum r, t.*                                   --2层
  FROM (SELECT rownum, empno, ename, sal    
        FROM emp
         ORDER BY sal DESC -- null值排序：放在最后，不管是asc, desc.
        ) t                                             --2层结束
)
WHERE r < =6 AND R >3;

-- 解释：
-- 先执行2层子查询: rownum r 解决刚才rownum 不能大于正数的问题
-- 然后，再将其整体看成1个结果， 这时r就不是rownum了，而是表的普通列名了。

-- 要求：理解不了，就记住。
-- 下次写时，情形：只要改最里层的就可以，外2屋是不用改的。

-- 10:34
-- ex
-- 10:49



 

   
   

