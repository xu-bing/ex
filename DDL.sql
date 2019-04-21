-- �򵥻ع� 
-- dml: ���ѡ�
-- ������Ҫ�ں����pl/sql��̣�java���룬�����̸�����������ơ�
--       hr: ���˽⡣


-- ����1��ѧ����
CREATE TABLE student(
             stuno number(4),
             sname varchar2(10),
             age number(3),
             enrollment_date DATE,
             sex char(1)
              );

-- ��ʾ��ṹ
-- COMMAND�����

-- �������;���
CREATE TABLE student(
             stuno number(4),
             sname varchar2(10),
             age number(3),
             enrollment_date DATE DEFAULT SYSDATE,
             sex char(1)��
             height number(3,1)   -- ���
              );

-- ������ʱ�Ŀ���ѡ��              
CREATE TABLE student(
             stuno number(4) NOT NULL,
             sname varchar2(10),
             age number(3),
             enrollment_date date DEFAULT sysdate,
             sex char(1) DEFAULT '��'      --  1�������ַ���2���ֽڡ�
              );
              
-- ͨ���Ӳ�ѯ������
/*
׼����ɾ��emp_bak��
*/

CREATE TABLE emp_bak
AS (SELECT * FROM emp WHERE 1 <> 1);


-----------------------------------------------------------------------------------------
/*ALTER TABLE (����) ADD (���� ��������);
ALTER TABLE (����) MODIFY (���� ��������);
ALTER TABLE (����) RENAME COLUMN (��ǰ����) TO (������);
ALTER TABLE (����) DROP COLUMN (����);
ALTER TABLE (��ǰ����) RENAME TO (�±���);*/

-- �޸ı�
-- ׷����
ALTER TABLE student
ADD (height number(3,2));

-- �޸���
ALTER TABLE student
MODIFY (sex char(2));              

-----------------------------------------------------------------------------------------              
-- �����ֵ�
-- ��ѯ�û��Զ�������Ϣ
SELECT * 
FROM user_tables;

-- ���ݿ����
SELECT DISTINCT object_type
FROM user_objects;

-- 
SELECT * 
FROM user_objects;

-- ����ͼ�����С�ͬ���
SELECT *
FROM user_catalog;


---------------------------------------------------------------------------------------------
-- ������Լ��
-- ������ʱ
-- ע��㣺������ʱ��ע��ǰ��˳�򣬷���������ȱʧ����
-- Լ������
-- Ĭ��Լ������sys_
-- ָ��Լ�������û��Զ��� pk_����_����

DROP TABLE student;

CREATE TABLE student(
             sno number(4) PRIMARY KEY,     -- ����
             sname varchar2(10) UNIQUE,        -- Ψһ
             sage number(3) DEFAULT 1 NOT NULL, -- �ǿ�
             -- age number(3) NOT NULL DEFAULT 1,     -- DEFAULT��λ�� error: ������ȱʧ�� 
             -- age number(3) DEFAULT 10 NOT NULL CHECK(age BETWEEN 10 AND 30),
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '��' CHECK(sex IN('��','Ů')),
             );

-- ���ԣ�
INSERT INTO student(sno, sname, sage, enrollment_date, sex)
-- VALUES(201, 'TOM', 20, '', '');    -- �����Ϊ''������null, ������Ĭ��ֵ
-- VALUES(201, 'TOM', 20, , );  -- error: ȱ�����ʽ

-- �������Լ��
DROP TABLE student;
DROP TABLE stuclass;

CREATE TABLE stuclass(
             cno number(2) PRIMARY KEY,
             cname varchar2(20) NOT NULL             
             );      -- ; �����٣��������֡�������ȱʧ������

INSERT INTO stuclass 
-- VALUES (101, "�����1");        -- ���ڴ˴������� why? ��ʽ���ԣ��ַ���'' ����""
VALUES (101, '�����1');  

INSERT INTO stuclass 
VALUES (102, '�����2');             
                     
DROP TABLE student;
CREATE TABLE student(
             sno number(4) CONSTRAINT pk_sno PRIMARY KEY,     
             sname varchar2(10) UNIQUE,        
             sage number(3) DEFAULT 1 CONSTRAINT nnvl_sage NOT NULL CHECK(sage BETWEEN 10 AND 30), 
             -- age number(3) NOT NULL DEFAULT 1,      
             -- age number(3) DEFAULT 10 NOT NULL CHECK(age BETWEEN 10 AND 30),
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '��' CHECK(sex IN('��','Ů')),
             cno number(2) REFERENCES stuclass(cno)      -- ���㣺�ȼ��stuclass�����������ٴ������ӡ�����Ҫ����stuclass��       
             );
             
-- ��Լ��
DROP TABLE student;

CREATE TABLE student(
             sno number(4),     
             sname varchar2(10),        
             sage number(3), 
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '��',
             cno number(2),
             -- ��Լ��
             CONSTRAINT pk_student_sno PRIMARY KEY (sno),
             CONSTRAINT unq_student_sname UNIQUE (sname),
             -- CONSTRAINT nnvl_student_sage NOT NULL (sage),
             CONSTRAINT fk_student_cno FOREIGN KEY (sno) REFERENCES stuclass(cno)   -- (sno)������������������ 
             );

 
-- ʹ�ù��ߴ���Լ��
/*
   ��������
*/

DROP TABLE student;

CREATE TABLE student(
             sno number(4),     
             sname varchar2(10),        
             sage number(3), 
             enrollment_date DATE DEFAULT sysdate,
             sex char(2) DEFAULT '��',
             cno number(2),
             -- ��Լ��
             CONSTRAINT pk_student_sno PRIMARY KEY (sno),
             CONSTRAINT unq_student_sname UNIQUE (sname),
             -- CONSTRAINT nnvl_student_sage NOT NULL (sage),
             CONSTRAINT fk_student_cno FOREIGN KEY (sno) REFERENCES stuclass(cno)   -- (sno)������������������ 
             );
