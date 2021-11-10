net stop mysql

net start mysql

#### 1、导入导出（备份）

```sh
# 1. 导出（不需要登录）

mysqldump --column-statistics=0 -u username -h ip -p database>D:\xxx.sql  # 导出数据库

mysqldump --column-statistics=0 -u username -h ip -p databases 表 1 表 2>D:\xxx.sql # 导出表结构和内容

# --column-statistics=0 解决版本不兼容问题，新版的 mysqldump 默认启用了一个新标志，作用是禁用它
# --databases 导出多个数据库
# -t 只导出表数据
# -d 只导出表结构
# 结尾不能加；，要不然就报错！！！

# 2. 导入

mysql -u root -h ip -p # 登录

use database # 选择对应的数据库，或者创建数据库 create table 数据库名 character set 字符集

source D:\xxx.sql
```

#### 2、库操作

```markdown
# 1、登录

mysql -u root -h ip -p

# 2、创建数据库

create database 数据库名 character set 字符集（gbk、utf8） # 默认字符集为 utf8
show databases # 展示所有数据库
use database_name # 选择某个数据库
show create database database_name # 查看字符编码

# 3、删除数据库

drop database 库名（凌紫泪）
```

#### 3、表操作

```markdown
# 1、创建表

create table ruyidan.表名 (
id bigint comment "name1",
field1 varchar(20) comment "dd",
PRIMARY KEY (id)
) engine=InnoDB default charset=utf8 collate=utf8_general_ci COMMENT='表说明';

# 2、修改表

alter table 表名 add (field 字段类型);
alter table 表名 modify (field 字段类型);
alter table 表名 change column 旧列名 新列名 列的数据类型;
rename table 旧表名 to 新表名;
alter table 表名 character set utf8;

# 3、删除表

drop table 表名

# 4、查询表

show tables
desc 表名 # 查询表结构
```

#### 4、值操作

```markdown
# 1、增

    	insert into insert into 表名(列的名称) values(值1，值2,...);

# 2、删

    	delete from 表名;
    	truncate table 表名  截取,可以恢复
    	drop table 表名；  ---> 删除整张表

# 3、改

    	update 表名 set 列名=值1,列名=值2 where ??;

# 4、查

    	select * from 表名;

1 如果出现中文乱码，可以用下面命令查看数据库所有跟字符编码相关的变量的值：
show variables like 'character%';
2 可以将客户端 client 连接 将这三个字符编码的变量改为支持中文的编码：
set names gbk;
```

#### 5、sql

```markdown
# 1、概念

     sql是结构化的查询语言,是关系型数据库当中所使用的一种数据库语言.
    按功能不同分为四种:
        ddl: 数据声明语言  create declare alter
        dml: 数据处理语言  update delete  insert
        dql: 数据查询语言  show desc  select  from where group by   having   order by
        tcl: 事务控制语言  rollback事务回滚 commit事务提交

1 查看 autocommit 模式: show variables like 'autocommit';
2 修改 set @@autocommit=0;

# 2、查询语句

    6个查询子句的书写顺序及执行顺序:k
    	SELECT
    		表名.查询的列名
    	FROM
    		表名
    	WHERE
    		对行进行过滤的条件表达式
    	GROUP BY
    		表的列名
    	HAVING
    		对组进行过滤的条件表达式(可以为组函数)
    	ORDER BY
    		列名(desc或asc)
    执行顺序:  FROM  -> WHERE  -> SELECT  -> GROUP BY  -> HAVING  ->ORDER BY

# 3、常用关键字说明

    distinct				去重
    列名1+列名2 as 别名		两列的值相加起别名，as可以省略
    如果要进行数据的统计并且出现(每\各),就一定要使用分组，对组信息如果要进行条件过滤就要使用having
    where子句中的运算符
    	等于  =
    	不等于  <>    或!=
       between  ... and ...   在某个区间值
       not between ... and ...
       in(值1,值2...值n)      在列表当中的某一个值
       like  匹配符   模糊查询
       not like 匹配符
       _   任意一个字符
       %   任意0个或者多个
       is null  判断null值
       is not null
    	与(and)   或(or)   非(not)
    order by 列名 ASC(DESC)			对查询结果排序(某一列)，写在最后面
    order by 列名 如果是升序,在列名后面加上asc(可不加,省略),如果是降序,在列名后面加上desc
    group by对列进行分组:
    	group by 列名    就是为了统计每一组的信息,因此就提供了相应统计函数,分别是:
    	count(列名)  组当中的个数
    	sum(列名)    组当中的数据的和
    	max(列名)	  组当中的最大值				                                         		 min(列名)    组当中的最小值
    	avg(列名)    组当中的平均值
    having子句是对组信息进行按条件过滤,和where子句不同,where子句对行过滤;
    having子句后面可以跟组函数, where子句后面不可以跟组函数,且having必须写在group by(列名) 后面
    跟日期时间相关的函数:
    	select current_time()
    	select current_date()
    	select current_timetamp()   当前时间撮
    	now()                 当前时间
    	datadiff()              两个时间差
    跟字符串相关的函数:
    	concat(String [,...])     连接字符串
    	instr(String,subString)  返回subString在Srtring中的位置
    	ucase()   转换成大写
    	lcase()         小写
    	left(String length)  从左边起截取子串
    	length()          获取字符串的长度
    	replace(String subString String2)          替换
    	strcmp()         比较两个字符串的大小
    	substring(str position [,length])
    跟数学统计相关的函数:
    	celing(num)   向上取整
    	abs()         绝对值
    	round()       四舍五入
    	floor()       向下取整
    	mod()         求余
    	least()       求最小值
    	format()       保留几位小数
    	rand()         0-1随机的小数
```

#### 6、用户权限

```markdown
# 1、查询用户

    select user,host from mysql.user;

# 2、创建用户

    create user 用户名@主机地址 identified by 密码
    @主机地址:指定创建用户可以在那台主机上登录,如果是需要在所有的主机上登录,可以将主机地址写成通配符%，%需要加引号
    本地:localhost
    创建用户之前必须登录到数据库服务器上,而且需要管理员才能创建.

# 3、删除用户

    drop user username@host;

# 4、给用户授权

    GRANT privileges ON databasename.tablename TO 'username'@'host'
    	privileges:权限，所有权限使用all
       用户的操作权限  select  insert  update delect alter create
    	databasename.tablename:  *.*(所有数据库的所有表).
    在授权结束后,通过一条语句来刷新权限:flush privileges
    将某个用户设置为次级管理员(可以授权)
    	GRANT privileges ON databasename.tablename TO 'username'@'host' with grant option
    查看授权信息: show grants

# 5、更改用户密码

    set password for 用户名@主机地址=password(新密码)
    	     简写:(修改当前登录的密码): set password = password(新密码)

# 6、撤销用户权限

    revoke privileges on databasename.tablename from 'username'@'host'
```

#### 7、约束

```markdown
1 数据完整性约束
对表中的数据进行相应的规则，以保证数据的正确和有效.
2 主键约束:
定义表的时候，要求为每一张表都要指定一个主键.可以是表的一列或多列组成的一组.主键约束定义的方式有 2 种:
1>列级主键约束
在定义列的时候,在列定义后面加上 primary 关键字,就可以将该列定义为主键列,要求该列的值必须保证唯一且不为 null
2>表级主键约束
在定义表的时候,将所有的列定义完之后,在列定义的后面加上 primary key(列名,列名...);就可以定义表级主键约束
复合主键:对于表级主键约束可以指定主键列为复合主键列,要求复合主键列的值要保证唯一.
3 替代键约束:(唯一键约束)(可以有多个)
1>列级唯一键约束:
在定义列的时候,在列定义后面加上 unique 关键字,就可以将该列定义为唯一键列,要求该列的值必须保证唯一
2>表级唯一键约束:
在定义表当中的所有列之后,在列定义后面加上 unique(列名,列名...),将一列和多列组成的组指定为唯一键
一个表可以有多个唯一键列.
4 非空约束\默认值\取值自增长设置:
1>非空约束只能是列级的约束,在列定义后面加上 not null.
2>在定义列完后,可以在列的后面为列指定相应的默认值,使用 default 来指定默认值.
3>在主键列定义的后面加上 auto_increment,将该列的值定义为自增长
5 参照完整性约束(外键约束 MUL):
一张表当中的某列的数据来自于另一张表的数据,因此就应该在该列上添加相应的参照完整性约束,以保证数据的正确,
使用 Foreign key 关键字来实现.
对于添加外键约束的表叫参照表(从表)(子表)
对于引用数据的表叫被参照表(主表)(父表)
1>创建:
0 说明:在 mysql 数据库中,对于外键约束可以使用列级外键约束,但是不会生效.
1 列级: deptno int references 主表(列名); ××××××××× 1 错误不能使用 1
2 表级: create table emp1(foreign key(列名) references 主表(列名))
2>修改表结构:
1 已存在的表的某列添加相应的外键约束
2 格式: alter table 表名 add foreign key(列名) references 主表(列名)
3>外键约束增加的四个选项:
1 on delete restrict on update restrict 拒绝删除修改父表当中子表引用的数据  
 2 on delete no action on update no action 不允许删除修改父表当中子表引用的数据(默认)
3 on delete cascade on update cascade 级联修改删除
4 on delete set null on update set null 设置为 null
6 命名完整性约束:
为主键约束\唯一键约束\外键约束进行命名,使用 constraint 关键字定义.
constraint 约束名 foreign key (列名) references 主表(列名)
7 删除完整性约束:

alter table 表名 drop primary key
drop foreign key 外键约束的名称
drop key 约束的名称(取列的名称)
8 检查性约束;
1>mysql 数据库有检查性约束,但不能使用
解决办法: 枚举类型 enum('男','女')
触发器
2>对某一列的数据进行相应的条件检查,满足条件就可以插入数据,不满足条件就违反了检查性约束,使用 mqsql 当中提供一个 check(条件表达式)函数来实现.
```

#### 8、三大范式和 er 图

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

#### 9、关联查询

```markdown
关联查询(连接查询)
1>概念: 查询的数据不是来自一张表,而是多张表,就需要将多张表连接起来,在进行相应的查询.
2>笛卡尔积关联查询: 将查询的 2 张表直接连接起来构成一张新表,新表的记录数刚好等于连接之前两张表的记录的乘积.
连接查询的实现方式:  
 select 表当中的列 from 表名 1,表名 2,表名 3...(不推荐)
select e._ d._ from emp e inner join dept d;
3>内连接查询(带条件的连接查询)(※※※※※※※)
两种实现方式:
select 表当中的列 from 表 1,表 2,表 3 ... where 连接条件表达式 and 条件表达式(不推荐)
select 表当中的列 from 表 1 (inner) join 表 2 on 连接条件表达式 and 条件表达式
内连接查询的结构的记录数==两张表当中满足条件的记录数.
连接 n 个表,至少需要 n-1 个连接条件.

4>自然连接
将多张表进行按照条件连接查询
连接条件:按照多张表当中相同列名的条件进行连接,如果多张表当中没有相同的列名,就是笛卡尔连接
可以使用 natrual join 关键字来进行连接查询.
5>自连接(自我连接)
将一张表看成多张表(起别名,相当于克隆 clone),进行内连接查询,就是自连接
select s1.name s2.name sa '重命名' from student s1 inner join student s2 on 连接表达式
6>外连接(左\右外连接)
外连接可以查询出两张表当中满足条件的记录和其中一张表当中不满足条件的记录.
1>左外连接:
表 1 left (outer) join 表 2
表 1--->主表
2>右外连接:
表 1 right (outer) join 表 2
表 2--->主表
可以相互转换,
查询记录数==两张表当中满足条件记录数+主表当中不满足条件的记录数.
3>满外连接(全连接):
查询结果当中既有两张表当中满足连接条件的记录,也有两张表当中不满足连接条件的记录,
4 集合运算 取并集: union all
直接合并,去掉重复项: union
进行对结果取并集运算时,要确保两个结果集有相同的列数
二 子查询
在查询 select 语句当中进行嵌套 select 语句
1>在 select 语句当中的 from 子句后面可以嵌套一个 select 语句 (一张表)
2>在 where 子句的条件表达式中可以嵌套 select 语句(常用)
1 普通条件的 select 语句的嵌套 > < = != 子查询的结果只能有一条记录,且是一列.
2 带 in 运算符的 select 语句的嵌套. 子查询的结果可以有多条记录,且是一列
3 带 between...and 的子查询:
在 between..and 之间需要嵌套一个 select 语句,在 and 之后也要嵌套一个 select,且这两个 select 语句查询的记录只有一条
4 带=any >any <any 的子查询
子查询的记录数可以是一个或者多个.没有限制
5 带>all <all 的子查询:
子查询的记录数可以是一个或者多个.没有限制
6 带 exists 的子查询  
 exists 代表存在的含义.
3>连接查询\子查询的使用:
可以在 inner join left outerjoin right outer join 后面可以嵌套 select 语句,
也可以在 on 后面的连接条件当中嵌套 select 语句.(如果在连接查询当中嵌套 select 语句,一定要为 select 语句的结果起别名)
语句 1：select _ from student limit 9,4
语句 2：slect _ from student limit 4 offset 9
// 语句 1 和 2 均返回表 student 的第 10、11、12、13 行  
//语句 2 中的 4 表示返回 4 行，9 表示从表的第十行开始
```

#### 10、索引

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
