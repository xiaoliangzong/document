## 1. 安装（5.7.31）

### 1.1 windows

windows 系统下 mysql 安装有两种方式: msi 直接安装和 zip 包解压缩安装；第二种方式比较难，下面讲解第二种方式：

- 解压；
- 根目录下新建 my.ini 配置文件和 data 存放数据文件夹；
- 管理员身份运行 cmd，进入 bin 目录，执行 mysqld --initialize --console；执行完成后，其中有一行话 temporary password is generated for root@localhost:，@localhost:后的就是 root 用户的初始密码；
- 执行 mysqld --install [服务名]，可以不写服务名，默认是 mysql，如果安装多个服务，可以起不同的名字；
- 配置环境变量；
- 启动 net start/stop mysql [mysql]，mysql 为服务名
- 登录后修改密码 ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '新密码';

### 1.2 linux

### 1.3 my.ini 配置文件

```ini
[mysqld]
# 设置3306端口
port=3306
# 设置mysql的安装目录
basedir=E:\\software\\mysql\\mysql-8.0.11-winx64
# 设置mysql数据库的数据的存放目录
datadir=E:\\software\\mysql\\mysql-8.0.11-winx64\\Data   # 此处同上
# 允许最大连接数
max_connections=200
# 允许连接失败的次数。这是为了防止有人从该主机试图攻击数据库系统
max_connect_errors=10
# 服务端使用的字符集默认为UTF8
character-set-server=utf8
# 创建新表时将使用的默认存储引擎
default-storage-engine=INNODB
# 默认使用“mysql_native_password”插件认证
default_authentication_plugin=mysql_native_password
# 设置默认时区
default-time-zone=+8:00
[mysql]
# 设置mysql客户端默认字符集
default-character-set=utf8
[client]
# 设置mysql客户端连接服务端时默认使用的端口
port=3306
default-character-set=utf8
```

## 2. 函数

### 2.1 字符函数

```sql
1. concat() -- 连接字符串
2. length() -- 字符串的字节个数（utf-8 时，一个汉字三个字节）
3. upper()/lower() ucase()/lcase()     -- 转换大小写
4. substr() substring() -- 截取子串
5. instr()              -- 子串第一次出现的索引位置，如果不存在，返回 0
6. ifnull(a1,a2)        -- 如果为 null 则替换成某个值 两个参数，
7. lpad/rpad            -- 左/右边填充
8. replace()            -- 替换
9. trim()               -- 去掉首尾空格，trim('a' from 'aaddda')去掉首尾的a
10. strcmp()            -- 比较两个字符串的大小，如果两个字符串相等返回0，如果第一个参数根据当前的排序小于第二个参数顺序则返回-1，否则返回1。
11. left()/right()      -- 从左/右截取子串，和substr类似
12. substring_index()   -- 通过关键字截取，第三个参数为关键字出现的次数，可以为负，负数表示倒数截取后边的字符串，如果关键字不存在，则返回整个字符串
13. +号
/* 运算符，两个操作数都为数值型，则做加法运算，只要其中一方为字符型，试图将字符型数值转换成数值型，
如果转换成功，则继续做加法运算，如果转换失败，则将字符型数值转换成 0；只要其中一方为 null，则结果肯定为 null */
```

### 2.2 数学函数

```sql
1. round() -- 四舍五入
2. ceil()  -- 向上取整
3. floor() -- 向下取整
4. truncate() -- 截断几位小数，直接截取，不四舍五入
5. format()   -- 四舍五入，返回类型为字符串，但是返回结果每超过三位会自动加逗号分隔；因此用的比较少，format(param,2)等同于 convert(param,decimal(12,2))或 cast(param as decimal(12,2))
6. mod()   -- 取模
7. rand()  -- 获取随机数，0-1 的小数
8. abs()   -- 绝对值
9. least() -- 返回列表中的最小值，取某几列的最小值，横向求最小，也就是一行记录求最小
10. grealest()  -- 返回列表中的最大值，列表必须是相同类型，也可以是一个表的同一行、不同列的值进行比较，如果有一个为 null，则返回 null
11. convent()   -- 类型转换，用来获取一个类型的值，并产生另一个类型的值
12. cast()      -- 和convent作用类似，语法不同，cast(value as type)
```

### 2.3 日期函数

```sql
1. now()/current_timestamp()  -- 获取当前日前+时间
2. curdate()/current_date()   -- 当前日期
3. curtime()/current_time()   -- 当前时间
4. year()      -- 年
5. month()     -- 月
6. monthname() -- 英文月份
7. day()
8. hour()
9. minute()
10. second()
11. str_to_date() -- 将字符串格式的日期转换为date，转换失败则为null
12. date_format() -- 日期格式化，将日期转换成字符串
13. datediff()    -- 两个日期相差多少天
```

### 2.4 分组函数

> 分组函数，又称为聚合函数、统计函数、组函数，用作统计使用，且都忽略 null 值。

如果要进行数据的统计并且出现(每\各)，就一定要使用分组 group by，对组信息如果要进行条件过滤就要使用 having

```sql
1. sum()    -- 求和
2. min()    -- 最小值
3. max()    -- 最大值
4. avg()    -- 平均值
5. conut()  -- 计算个数，常用的count(*)、count(1)

/*
1. sum、avg 一般用于处理数值型，max、min、count 可以处理任何类型；
2. 和分组函数一同查询的字段要求是 group by 后的字段；
3. 可以和 distinct 一同使用，比如 sum(distinct xxx);
*/
```

### 2.5 其他函数

```sql
-- if() 函数，三个参数，等同于java的三目运算符
if(expr1, expr2, expr3)

-- case-when 两种用法：
-- 1. case 后边跟参数，则判断条件只能用该参数，相当于java中的switch
SELECT *, CASE xxx
WHEN 'xxx' THEN 'xxx'
WHEN 'xxxx' THEN 'xxxx'
END FROM [tableName];
-- 2. case 后边没有参数，直接是when，相当于if() else if()
SELECT *, CASE
WHEN 'xxx' THEN 'xxx'
WHEN 'xxxx' THEN 'xxxx'
END FROM [tableName];
```

## 3. 库、表、值、视图

sql，结构化查询语言，是关系型数据库当中所使用的一种数据库语言；按功能不同分为四种:

- ddl: 数据声明语言 create declare alter
- dml: 数据处理语言 update delete insert
- dql: 数据查询语言 show desc select from where group by having order by
- tcl: 事务控制语言 rollback 事务回滚，commit 事务提交；查看 autocommit 模式：show variables like 'autocommit'；修改 set @@autocommit=0

### 3.1 库

```sql
-- 展示所有数据库
show databases
-- 创建数据库，默认字符集为 utf8
create database if not exists [<name>] [character set 字符集（gbk、utf8）]
-- 使用数据库
use [<name>]
-- 查看当前数据库名、在登录状态查看版本，mysql --version是在非登录状态查看、显示系统时间
select database();
select version();
select now();
select user();
select md5("xxx");
select password("xxx");		-- 加密字符串
-- 查看字符编码
show create database [<name>]
-- 更改库的字符集
ALTER DATABASE [<name>] CHARACTER SET utf8;
-- 删除库/表
drop database/table if exists [<name>]
```

### 3.2 表

**约束**

约束是对表中的数据进行相应的规则，以保证数据的正确和有效。约束按照添加的位置可以分为列级约束和表级约束；

- 列级约束：所有约束语法上都支持，但外键约束不会生效；
- 表级约束：除了非空、默认，其他的都支持；[constraint 约束名] 约束类型(字段名)

  |          |   添加位置   |       支持的约束类型       |   是否可以起约束名   |
  | :------: | :----------: | :------------------------: | :------------------: |
  | 列级约束 |  某列的后面  | 语法都支持，但外键没有效果 |        不可以        |
  | 表级约束 | 所有列的下面 | 默认和非空不支持，其他支持 | 可以（主键没有效果） |

1. 主键约束（PRIMARY KEY）定义表的时候，要求为每一张表都要指定一个主键；可以是表的一列或多列组成的一组；
2. 唯一约束（UNIQUE）
3. 非空约束（NOT NULL）
4. 默认约束（DEFAULT）
5. 检查约束（CHECK）mysql 中不支持，可以通过枚举类型或触发器来约束， 枚举类型 enum('男','女')
6. 外键约束（FOREIGN KEY）对于添加外键约束的表叫参照表(从表)(子表)，对于引用数据的表叫被参照表(主表)(父表)，主表的关联列必须是一个 key（一般是主键或唯一）；可以使用列级外键约束，但是不会生效；插入数据时，先插入主表，再插入从表；删除数据时，先删除从表，再删除主表。
7. 自增长（AUTO_INCREMENT），只能添加到类型为数值型、且是一个 key 的列，一个表中最多只能有一个；可以通过 SET auto_increment_increment=3 设置步长，也可以通过 手动插入值，设置起始值。

主键和唯一键对比：

|        | 保证唯一性 | 是否允许为空 | 一个表中可以有多少个 | 是否允许组合 |
| :----: | :--------: | :----------: | :------------------: | ------------ |
|  主键  |     √      |      ×       |     至多有 1 个      | √            |
| 唯一键 |     √      |      √       |      可以有多个      | √，但不推荐  |

```sql
-- 添加、删除约束
alter table [<tableName>] modify column 字段名 字段类型 新约束;
alter table [<tableName>] add [constraint 约束名] 约束类型(字段名) [外键的引用];

-- 删除主键、唯一、外键约束
alter table [<tableName>] drop primary key;
alter table [<tableName>] drop index field;
alter table [<tableName>] drop foreign key fk_b_a;

-- 外键约束增加的四个选项
on delete restrict on update restrict 拒绝删除修改父表当中子表引用的数据
on delete no action on update no action 不允许删除修改父表当中子表引用的数据(默认)
on delete cascade on update cascade 级联修改删除
on delete set null on update set null 设置为 null
```

**表**

```sql
-- 展示该数据库的所有表，show tables from xxx可以查询其他库的所有表
show tables
-- 查看表结构
desc [<tableName>]
-- 删除库/表
drop database/table if exists [<tableName>]

-- 修改表结构，CHANGE COLUMN 字段重命名，改变数据类型，移动位置；MODIFY COLUMN 可以做CHANGE所有事，除了重命名字段。
alter table [<tableName>] add|drop|modify|change column 列名 [列类型 约束];
alter table [<tableName>] change column field field2;

-- 将表1中的数据插入到新表2中
CREATE TABLE 表2
SELECT * FROM xxx.表1

-- 根据表1创建表2
CREATE TABLE 表2 LIKE xxx.表1

-- 将表1重命名为表2
ALTER TABLE 表1 RENAME TO 表2;

-- 创建表
create table if not exists [<tableName>] (
	'id' bigint unsigned primary key auto_increment COMMENT '主键',
	'field' varchar(10) not null COMMENT '姓名',
	'no' char(18) unique COMMENT '身份证号',
	'sex' bigint default 0 COMMENT '性别：0-未知，1-男，2-女',
  'base_id' bigint COMMENT '主表id',
  constraint fk_b_a foreign key(base_id) references a(id);
);
```

### 3.3 值

```sql
-- 增
insert into [<tableName>] (field1, field2, ...) values (value1, value2, ...);
-- 删
delete from [<tableName>] where [condition];
truncate table [<tableName>]          -- 截取，可以恢复
drop table if exists [<tableName>]    -- 删除整张表
-- 改
update [<tableName>] set field1 = value1, field2 = value2 where condition;
-- 查

-- 如果出现中文乱码，可以用下面命令查看数据库所有跟字符编码相关的变量的值；将字符编码的变量改为支持中文的编码
show variables like 'character%';
set names utf8;
```

### 3.4 数据类型

### 3.5 视图

```sql
-- 创建或修改视图
create or replace view [<viewName>] as 查询语句;
alter view [<viewName>] as 查询语句;
-- 删除视图（支持批量）
drop view [<viewName>], ...;
-- 查看视图
desc [<viewName>];
show create view [<viewName>];
-- 插入，和插入表数据一致
insert into [<viewName>] values();
-- 修改
update [<viewName>] set field = 'value' where condition;
-- 删除
delete from [<viewName>] where condition;

-- 具备以下特点的视图不允许更新
  /*
  包含以下关键字的sql语句：分组函数、distinct、group  by、having、union或者union all
  常量视图
  select中包含子查询
  join
  from一个不能更新的视图
  where子句的子查询引用了from子句中的表 */
```

## 4. 查询

**查询列表可以是表中的字段、常量值、表达式、函数，也就是说：select 查询列表 from [tableName]**

### 4.1 常用查询条件

```sql
1. > < = != <> >= <=       -- 条件筛选
2. and or not && || !      -- 逻辑表达式，常用的是and、or、not
3. like   not like         -- 模糊查询，like时，_表示任意一个字符，%表示0个或任意多个
4. between and   not between and   -- 区间查询
5. in                      -- 包含查询
6. is null   is not null   -- 是否为null
```

### 4.2 查询关键字

```sql
1. distinct      -- 去重
2. as            -- 起别名，as可省略
3. having        -- 对组信息进行按条件过滤，和where子句不同，where子句对行过滤
4. order by ASC/DESC  -- 对查询结果排序
5. limit         -- 分页，有两个参数，第一个是偏移索引，从0开始，第二个是分页的大小，如果第一个为0，可省略；
                 -- 常用分页参数：pageSize和currentPage，limit (currentPage-1)*pageSize, pageSize
6. offset        -- 和limit搭配使用，指要偏移的数量；
                 -- select * from table limit 4 offset 9; 表示从跳过九条记录，从第十个开始取四条记录
```

### 4.3 连接查询

1. 按照功能分类

- 笛卡尔积
- 内连接，内连接查询结果的记录数等于两张表当中满足条件的记录数，连接 n 个表至少需要 n-1 个连接条件
  - 等值连接
  - 非等值连接
  - 自连接：特殊的等值连接，将一张表看成多张表，用起别名的方式连接查询
- 外连接，外连接可以查询出两张表当中满足条件的记录和其中一张表当中不满足条件的记录
  - 左外连接
  - 右外连接
  - 全外连接
- 交叉连接

2. 按照年代分类

- sql92 标准
  - 笛卡尔积
  - 内连接：笛卡尔积的基础上，使用 where 添加连接条件
  - 外连接也支持，但是不常用
- sql99 标准
  - 内连接 （inner join） 其中 inner 可省略，
    - 等值连接
      - 自然连接 （natural inner join） 是一种特殊的等值连接，他要求两个关系表中进行连接的必须有相同的属性列（名字相同），按照两张表当中相同列名的条件进行连接，无须添加连接条件，并且在结果中消除重复的属性列；如果多张表当中没有相同的列名就是笛卡尔连接
      - inner join xx using(); using 和 on 的区别在于需要连接的两个表的属性名相同的时候使用 using 和 on 效果一样，而属性名不同的时候必须使用 on
      - inner join xx on
    - 非等值连接
    - 自连接
  - 外连接
    - 左外连接 （left outer join） outer 可省略
    - 右外连接 （rignt outer join）outer 可省略
    - 全外连接 （full outer join） outer 可省略，等于 left join 和 right join 的并集，查询结果当中既有两张表当中满足连接条件的记录，也有两张表当中不满足连接条件的记录；**mysql 不支持，mysql 的全外连接可以使用 union 关键字将左连接和右链接的结果合并**
  - 交叉连接 （cross join）

```sql
-- 1. 笛卡尔积和交叉连接: 将查询的多张表直接连接起来构成一张新表，新表的记录数刚好等于连接表的记录的乘积
select * from 表1,表2,表3...      -- 92写法
select * from 表1 cross join 表2  -- 99写法，交叉连接

-- sql92 标准，常用的是内连接，外连接基本上不用
select * from 表1, 表2 where 表1.xxx = 表2.xxx                   -- 等值连接，在笛卡尔积的基础上，条件相等的值
select * from 表1, 表2 where 表1.xxx between 表2.xxx and 表2.xxx -- 非等值连接，表的连接条件使用>、>=、 <、<=、!=、any等，比如查询员工的工资和工资级别
select * from 表1 a, 表1 b where a.xxx = b.xxx                   -- 自连接

-- sql99 标准
select * from 表1 join 表2 on 表1.xxx = 表2.xxx        -- 等值连接 on
select * from 表1 join 表2 using(相同的字段名)          -- 等值连接 using
select * from 表1 natural join 表2                     -- 自然连接
select * from 表1 inner join 表2 on 表1.xxx between 表2.xxx and 表2.xxx   -- 非等值连接
select * from 表1 left join 表2 on 表1.xxx = 表2.xxx   -- 左连接

-- 集合运算，纵向合并两个表的数据，取并集
union all   -- 直接合并，进行数据的排序和去重，查询效率低
union       -- 没有进行去重和排序，查询效率高
```

### 4.4 子查询

```sql
-- 含义：出现在其他语句中的select语句，称为子查询或内查询；外部的查询语句，称为主查询或外查询
-- 分类：（结果集的行列数不同）
	标量子查询（结果集只有一行一列） --单个值
	列子查询  （结果集只有一列多行） -- 一列值
	行子查询  （结果集有一行多列）   -- 一行值
	表子查询  （结果集一般为多行多列） -- 一般为多列多行
-- 位置
select
		仅仅支持标量子查询
from                  -- 一张表
		支持表子查询
where/having          -- 常用，带=any >any <any >all <all的子查询子查询的记录数可以是一个或者多个，没有限制
		标量子查询         -- 嵌套 > < = != 子查询的结果只能有一条记录；between...and之间需要嵌套一个select语句，在and之后也要嵌套一个select，且这两个select语句查询的记录只有一条
		列子查询           -- 嵌套带 in 运算符，子查询的结果可以有多条记录，且是一列
		行子查询
exists（相关子查询）   -- 结果：1或0
		表子查询

inner join left outer join right outer join 后面可以嵌套 select 语句，也可以在 on 后面的连接条件当中嵌套 select 语句
```

### 4.5 执行顺序

![mysql逻辑架构图](../images/mysql/mysql逻辑架构图.png)

每一个操作都会产生一张虚拟的表，这个虚拟的表作为一个处理的输入，只是这些虚拟的表对用户来说是透明的，但是只有最后一个虚拟的表才会被作为结果返回。

```sql
/*
执行顺序:
   1. FROM  ->  对from后边的表以及关联查询的表计算笛卡尔积，产生虚表VT1；
   2. ON    ->  对虚表VT1进行ON条件筛选，将符合条件的行记录到虚表VT2；
   3. JOIN  ->  如果指定外连接，那么保留表中未匹配的行作为外部行添加到虚表VT2中，产生VT3；
   4. WHERE ->  对虚表VT3进行where条件筛选过滤，将符合条件的行记录到虚表VT4；
   5. GROUP BY  ->  对虚表VT4的记录进行分组操作，产生VT5；
   6. HAVING    ->  对虚表VT5进行having过滤，将符合条件的记录到VT6；
   7. SELECT    ->  查询
   8. DISTINCT  ->  去重
   9. ORDER BY  ->  排序
   10. LIMIT    ->  分页
*/
SELECT
	DISTINCT 查询列表
FROM
	表1
<JOIN_TYPE> JOIN 表2 ON 关联条件
WHERE
	对行进行过滤的条件表达式
GROUP BY
	表的列名
HAVING
	对组进行过滤的条件表达式（可以为组函数）
ORDER BY
	列名 ASC/DESC
LIMIT
	[offset] pageSize
offset
  显示条目的起始索引（起始索引从0开始）
```

## 5. 备份

**数据库备份方式：使用 navicat/dbeaver 软件或 mysqldump 命令行备份**

```sql
/*
1. 导出（不需要登录）
	 --column-statistics=0 解决版本不兼容问题，新版的 mysqldump 默认启用了一个新标志，作用是禁用它
	 databases 只导出一个数据库的几张表
	 -t 只导出表数据
	 -d 只导出表结构
*/
mysqldump --column-statistics=0 -u username -h ip -p database>D:\xxx.sql    -- 导出数据库，结尾不能加；，要不然就报错！！！
mysqldump -u username -h ip -p databases table1 table2>D:\xxx.sql           -- 导出表结构和内容
-- 2. 导入
mysql -u root -h ip -p  -- 登录
use database            -- 选择对应的数据库，或者创建数据库 create table 数据库名 character set 字符集
source D:\xxx.sql       -- 载入
```

## 6. 事务

## 8. 用户权限

```sql
-- 1. 查询用户
select user,host from mysql.user;

-- 2. 创建用户
create user 用户名@主机地址 identified by 密码
@主机地址:指定创建用户可以在那台主机上登录,如果是需要在所有的主机上登录,可以将主机地址写成通配符%，%需要加引号
本地:localhost
创建用户之前必须登录到数据库服务器上,而且需要管理员才能创建.

-- 3. 删除用户
drop user username@host;

-- 4. 给用户授权
GRANT privileges ON databasename.tablename TO 'username'@'host'
  privileges:权限，所有权限使用all
    用户的操作权限  select  insert  update delect alter create
  databasename.tablename:  *.*(所有数据库的所有表).
在授权结束后,通过一条语句来刷新权限:flush privileges
将某个用户设置为次级管理员(可以授权)
  GRANT privileges ON databasename.tablename TO 'username'@'host' with grant option
查看授权信息: show grants

-- 5. 更改用户密码
set password for 用户名@主机地址=password(新密码)
简写:(修改当前登录的密码): set password = password(新密码)

-- 6. 撤销用户权限
revoke privileges on databasename.tablename from 'username'@'host'
```

## 10. 三大范式和 er 图

```markdown
二 关系型数据库的设计原则:(三个范式):
1>第一范式: 确保每列的原子性.(每个表当中必须有一个主键列)
如果每列(或者每个属性)都是不可再分的最小数据单元(也称为最小的原子单元),则满足第一范式.
2>第二范式:在第一范式的基础上更进一层,目标是确保表中的每列都和主键相关.
如果一个关系满足第一范式,并且除了主键以外的其他列,都依赖于该主键,则满足第二范式.
3>第三范式:在第二范式的基础上更进一层,目标是确保每列都和主键列直接相关,而不是间接相关.
如果一个关系满足第二范式,并且除了主键以外的其他列之间没有依赖关系,则满足第三范式
4>对应关系:
1 对 1 关系 用一张表存储 1 对 1,添加一个列(eg:id 和 id_card)
1 对多关系和多对 1 关系 在多的一方的表中添加一个列(唯一标识的列),来引用 1 的一方的数据
多对多关系: 中间表 stu_teacher(id,stu_id,tea_id;)
三 E-R 图(Entity-Relation 实体关系图)
1>E-R 图:
在需求当中,抽离处该项目当中所有的实体对象,分析出这样的属性(数据)
使用矩形表示实体
使用椭圆表示属性
使用菱形表示实体之间关系 n\m 表示多,1 表示 1
2>E-R 图绘图工具:
微软 visio(亿图)\EDraw\Smind\画图软件
3>绘制酒店管理系统 E-R 图:
4>根据 E-R 图建立数据库模型
navicat 工具\powerdesigner 工具
```

## 11. 索引

> 索引在提供查询速度的同时，会降低增删改的速度；索引存储了指定列数据值的指针，根据指定的排序顺序对这些指针排序

##### 10.0.1 优点

- 通过创建唯一索引可以保证数据库表中每一行数据的唯一性。
- 可以给所有的 MySQL 列类型设置索引。
- 可以大大加快数据的查询速度，这是使用索引最主要的原因。
- 在实现数据的参考完整性方面可以加速表与表之间的连接。
- 在使用分组和排序子句进行数据查询时也可以显著减少查询中分组和排序的时间

##### 10.0.2 缺点

- 创建和维护索引组要耗费时间，并且随着数据量的增加所耗费的时间也会增加。
- 索引需要占磁盘空间，除了数据表占数据空间以外，每一个索引还要占一定的物理空间。如果有大量的索引，索引文件可能比数据文件更快达到最大文件尺寸。
- 当对表中的数据进行增加、删除和修改的时候，索引也要动态维护，这样就降低了数据的维护速度。

##### 10.0.3 创建索引

查看索引
SHOW INDEX FROM <表名> [ FROM <数据库名>]

1. 给已存在的表添加索引

create index <索引名> on <表名> (<列名>[length] [ASC | DESC])

- 索引名：一般命令规则：表名\_列名
- 列名的长度：CHAR，VARCHAR 类型，length 可以小于字段实际长度；如果是 BLOB 和 TEXT 类型，必须指定 length。
- 升降序：可选

2. 通过修改表结构的方式添加索引

alter table <表名> add index/unique/fulltext <索引名>(列名 1，列名 2)

3. 创建表的时候直接指定

create table table_name ( [...], INDEX [索引的名字] (列的列表) );

##### 10.0.4 查看索引

show index from 表名

##### 10.0.5 删除索引

alter table 表名 drop index 索引名

- DROP PRIMARY KEY：表示删除表中的主键。一个表只有一个主键，主键也是一个索引。
- DROP INDEX index_name：表示删除名称为 index_name 的索引。
- DROP FOREIGN KEY fk_symbol：表示删除外键。

drop index 索引名 on 表名

##### 10.0.6 索引分类

```java
普通索引 index
唯一索引 unique		// 索引列的值必须唯一，但允许有空值（注意和主键不同）。如果是组合索引，则列值的组合必须唯一，创建方法和普通索引类似
主键索引 primary key
    主键是一种约束，一张表只能有一个主键；唯一索引是一种索引，一张表可以创建多个唯一索引
    主键创建后一定包含一个唯一索引，唯一索引不一定是主键，
    主键不能为null，唯一索引可以为null
    主键可以作为外键，但是唯一索引不行

全文索引
外键索引
联合索引 最左前缀：对多个字段同时建立的索引，有顺序，
    建立这样的索引相当于建立了索引a、ab、abc三个索引。
    覆盖索引，真正的实际应用中，覆盖索引是主要的提升性能的优化手段之一
    索引列越多，通过索引筛选出来的数据越少

    最左匹配原则。(A,B,C) 这样3列，mysql会首先匹配A，然后再B，C.
如果用(B,C)这样的数据来检索的话，就会找不到A使得索引失效。如果使用(A,C)这样的数据来检索的话，就会先找到所有A的值然后匹配C，此时联合索引是失效的。
```

##### 10.0.7 like 语句操作

一般情况下不鼓励使用 like 操作；like “%aaa%” 不会使用索引而 like “aaa%”可以使用索引。

`覆盖索引`：

- select 的数据列只用从索引中就能够取得，不必从数据表中读取，换句话说查询列要被所使用的索引覆盖

##### 10.0.7 聚集索引和非聚集索引

1. 聚集索引：索引中键值的逻辑顺序决定了表中相应行的物理顺序。

2. 非聚集索引：索引中索引的逻辑顺序与磁盘上行的物理存储顺序不同。

#### 11、EXPLAIN

> 是查看优化器如何决定执行查询的主要方法，

#### 11、面试必问

```shell
# 1、truncate、delete、drop区别：
	都表示删除、
	类型不同：delete属于dml，数据处理语言，而其他两个属于ddl，数据声明语言
	回滚：delete可回滚，其他两个不可以
	删除内容：delete删除某些行或所有行，drop删除表结构，truncate只删除所有数据
	删除速度：drop最快，下来是truncate，最后是delete
# 2、
```

#### 工作问题汇总

1. 删除为 null 的值时，不能使用 where xxx = NULL；而是使用 where xxx is NULL；
2. 查询树形结构数据时（一张表中存储），可以设置一个字段为 ancestors,存放父类的 id 集合，最后用 find_in_set 函数，一次查询即可，不需要遍历查询
3. mysql 在存储 json 时，默认按照 key 的字段长度做排序，以便获取更好的存储性能，目前不支持自定义顺序 json，可以将字段设置为 test 结构类型，然后用第三方工具序列化

```

```
