-- 简单回顾 
-- dml: 不难。
-- 事务：主要在后面的pl/sql编程，java代码，框架中谈具体的事务控制。
--       hr: 先了解。


-- 创建1个学生表
CREATE TABLE student(
             stuno number(4),
             sname varchar2(10),
             age number(3),
             enrollment_date DATE,
             sex char(1)
              );

-- 显示表结构
-- COMMAND命令窗口

-- 数据类型举例
CREATE TABLE student(
             stuno number(4),
             sname varchar2(10),
             age number(3),
             enrollment_date DATE DEFAULT SYSDATE,
             sex char(1)，
             height number(3,1)   -- 身高
              );

-- 创建表时的可用选项              
CREATE TABLE student(
             stuno number(4) NOT NULL,
             sname varchar2(10),
             age number(3),
             enrollment_date date DEFAULT sysdate,
             sex char(1) DEFAULT '男'      --  1个中文字符是2个字节。
              );
              
-- 通过子查询创建表
/*
准备：删除emp_bak表
*/

CREATE TABLE emp_bak
AS (SELECT * FROM emp WHERE 1 <> 1);


-----------------------------------------------------------------------------------------
/*ALTER TABLE (表名) ADD (列名 数据类型);
ALTER TABLE (表名) MODIFY (列名 数据类型);
ALTER TABLE (表名) RENAME COLUMN (当前列名) TO (新列名);
ALTER TABLE (表名) DROP COLUMN (列名);
ALTER TABLE (当前表名) RENAME TO (新表名);*/

-- 修改表
-- 追加列
ALTER TABLE student
ADD (height number(3,2));

-- 修改列
ALTER TABLE student
MODIFY (sex char(2));              

-----------------------------------------------------------------------------------------              
-- 数据字典
-- 查询用户自定义表的信息
SELECT * 
FROM user_tables;

-- 数据库对象
SELECT DISTINCT object_type
FROM user_objects;

-- 
SELECT * 
FROM user_objects;

-- 表、视图、序列、同义词
SELECT *
FROM user_catalog;


---------------------------------------------------------------------------------------------
-- 完整性约束
-- 创建表时
-- 注意点：多条件时，注意前后顺序，否则：右括号缺失错误。
-- 约束名：
-- 默认约束名：sys_
-- 指定约束名：用户自定义 pk_表名_列名

DROP TABLE student;

CREATE TABLE student(
             sno number(4) PRIMARY KEY,     -- 主键
             sname varchar2(10) UNIQUE,        -- 唯一
             sage number(3) DEFAULT 1 NOT NULL, -- 非空
             -- age number(3) NOT NULL DEFAULT 1,     -- DEFAULT的位置 error: 右括号缺失。 
             -- age number(3) DEFAULT 10 NOT NULL CHECK(age BETWEEN 10 AND 30),
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '男' CHECK(sex IN('男','女')),
             );

-- 测试：
INSERT INTO student(sno, sname, sage, enrollment_date, sex)
-- VALUES(201, 'TOM', 20, '', '');    -- 输入的为''，不是null, 更不是默认值
-- VALUES(201, 'TOM', 20, , );  -- error: 缺乏表达式

-- 创建外键约束
DROP TABLE student;
DROP TABLE stuclass;

CREATE TABLE stuclass(
             cno number(2) PRIMARY KEY,
             cname varchar2(20) NOT NULL             
             );      -- ; 不可少，否则会出现“右括号缺失”错误。

INSERT INTO stuclass 
-- VALUES (101, "计算机1");        -- 列在此处不允许。 why? 格式不对，字符串'' 不是""
VALUES (101, '计算机1');  

INSERT INTO stuclass 
VALUES (102, '计算机2');             
                     
DROP TABLE student;
CREATE TABLE student(
             sno number(4) CONSTRAINT pk_sno PRIMARY KEY,     
             sname varchar2(10) UNIQUE,        
             sage number(3) DEFAULT 1 CONSTRAINT nnvl_sage NOT NULL CHECK(sage BETWEEN 10 AND 30), 
             -- age number(3) NOT NULL DEFAULT 1,      
             -- age number(3) DEFAULT 10 NOT NULL CHECK(age BETWEEN 10 AND 30),
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '男' CHECK(sex IN('男','女')),
             cno number(2) REFERENCES stuclass(cno)      -- 运算：先检查stuclass表存在情况，再创建连接。所以要创建stuclass表。       
             );
             
-- 表级约束
DROP TABLE student;

CREATE TABLE student(
             sno number(4),     
             sname varchar2(10),        
             sage number(3), 
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '男',
             cno number(2),
             -- 表级约束
             CONSTRAINT pk_student_sno PRIMARY KEY (sno),
             CONSTRAINT unq_student_sname UNIQUE (sname),
             -- CONSTRAINT nnvl_student_sage NOT NULL (sage),
             CONSTRAINT fk_student_cno FOREIGN KEY (sno) REFERENCES stuclass(cno)   -- (sno)必须用括号括起来。 
             );

 
-- 使用工具创建约束
/*
   创建最简表
*/

DROP TABLE student;

CREATE TABLE student(
             sno number(4),     
             sname varchar2(10),        
             sage number(3), 
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '男',
             cno number(2),
             -- 表级约束
             CONSTRAINT pk_student_sno PRIMARY KEY (sno),
             CONSTRAINT unq_student_sname UNIQUE (sname),
             -- CONSTRAINT nnvl_student_sage NOT NULL (sage),
             CONSTRAINT fk_student_cno FOREIGN KEY (sno) REFERENCES stuclass(cno)   -- (sno)必须用括号括起来。 
             );
