# GaussDB

## 介绍

### 概念

GaussDB 是华为公司自主研发的新一代企业级关系型数据库，支持 SQL2003 标准语法，同时支持 x86 和鲲鹏计算架构，提供高吞吐强一致性事务处理能力、金融级高可用能力、大数据高性能查询能力，可广泛应用于金融、电信、政府等行业关键核心系统。

支持集中式&分布式两种部署形态

GaussDB 分布式，突破单机数据库存储容量和性能瓶颈。分布式形态采用 MPP & share nothing 架构，具有很好的线性扩展能力(扩展比>0.8)，可以解决业务互联网化带来的峰值流量访问问题，和很多行业用户的数据处理性能问题，可以为超大规模数据管理提供高性价比的通用计算平台，并可用于支撑各类在线交易系统

### 数据库对象

数据库（Database）: 数据库就是实现有组织、动态地存储大量相关数据，方便用户访问的计算机软、硬资源组成的系统。一个 GaussDB 集群可以管理多个数据库实例。管理员可以根据业务需要，规划和创建数据库实例。
模式（Schema）: 一个数据库可以包含一个或多个已命名的 schema，schema 是一个逻辑概念，包含表、索引等其他数据库对象等。
表空间（Tablespace）: 表空间用来指定数据库中表、 索引等数据库对象的存储位置，是一个物理概念。管理员创建表空间后，可以在创建数据库对象时引用它。
表（Table）: 一个表空间可包含多张表。数据库中的数据都是以表的形式存在的，表是建立在数据库中的，在不同的数据库或相同数据库不同模式中可以存放相同的表。

### 索引

[索引](./images/GuassDB-索引介绍.jpg)

索引是对数据库表中一列或多列的值进行排序的一种结构，使用索引可快速访问数据库表中的特定信息， B-Tree 索引

按索引列数将索引分类：

| 分类     | 说明                                                                                                       |
| -------- | ---------------------------------------------------------------------------------------------------------- |
| 单列索引 | 仅在一个列上建立索引                                                                                       |
| 多列索引 | 多列索引又称为组合索引。一个索引中包含多个列，只有在查询条件中使用了创建索引时的第一个字段，索引才会被使用 |

按索引使用方法将索引分类：

| 分类         | 说明                                                                                                                   |
| ------------ | ---------------------------------------------------------------------------------------------------------------------- |
| 全文索引     | 提供了查询可读性文档的能力，并且通过查询相关度将 结果进行排序                                                          |
| 唯一索引     | 列值或列值组合唯一的索引。建表时会在主键上自动建立唯一索引                                                             |
| 函数索引     | 建立在函数基础之上的索引                                                                                               |
| 分区索引     | 在表的分区上独立创建的索引，在删除某个分区时不影响该表的其他分区索引的使用                                             |
| 全局二级索引 | 分布式集群，允许用户定义与基表分布不一致的索引，从而实现基表非分布列查询的单节点计划和基表非分布列上的 unique/主键约束 |

### 目录结构

[系统目录结构](./images/GuassDB-系统目录结构.jpg)

- base ：每个 database 会在 base 目录下有一个子目录，存储该数据库的文件
- global ：存放的文件用于存储全局的系统表信息和全局控制信息
- pg_tblspc： 包含指向表空间的符号链接

## 开发设计

### 数据库对象

#### 表空间

GaussDB 的表空间在操作系统中是一个目录，可以存在多个，里面存储的是它所包含的数据库的各种物理文件。由于表空间实际上是一个目录，所以其管理功能依赖于文件系统。

使用表空间有以下优点：

- 如果数据库所在的分区或者卷空间已满，又不能逻辑上扩展更多空间，可以在不同分区上创建和使用表空间，直到系统重新配置空间
- 管理员通过表空间可以设置占用的磁盘空间，用以在和其他数据共用分区的时候，防止表空间占用相同分区上的其他空间
- 表空间可以控制数据库数据占用的磁盘空间，当表空间所在磁盘的使用率达到 90%时，数据库将被设置为只读模式，当磁盘使用率降到 90%以下时，数据库将恢复到读写模式

GaussDB 自带了两个表空间：

- 表空间 pg_default：用来存储系统目录对象、用户表、用户表 index、和临时表、临时表 index、内部临时表的默认空间。对应存储目录$GAUSS_DATA_HOME/base/
- 表空间 pg_global： 用来存放系统字典表；对应存储目录$GAUSS_DATA_HOME/global/

```sql
-- 创建表空间
gaussdb=# create tablespace tbs2 relative location 'tablespace/tbs2' maxsize '100G';    --创建表空间并指定目录与大小
gaussdb=# create tablespace tbs3 owner jack location '/gauss/data/tbs3';                --创建表空间并指定所有者与目录

-- 查询表空间
gaussdb=# \db                                                                                           --使用元命令查看表空间信息
gaussdb=# select * from pg_tablespace_location((select oid from pg_tablespace where spcname='tbs2'));   --查看表空间所属目录
gaussdb=# select oid,* from pg_tablespace;                                                              --查看表空间的所有者

-- 修改表空间
gaussdb=# alter tablespace tbs3 rename to tbs4;               --修改表空间名
gaussdb=# alter tablespace tbs4 owner to jack;                --修改表空间所有者
gaussdb=# alter tablespace tbs4 resize maxsize unlimited;     --修改表空间上限大小
gaussdb=# alter tablespace tbs4 reset (random_page_cost);     --修改表空间属性

-- 删除表空间
gaussdb=# drop tablespace tbs4;
```

#### 普通表

在关系数据库中，表用来表示数据和数据之间的联系，关系(relation)表示表。

一行的所有列组成一条记录，也叫元组(tuple)，关系是元组的集合。

每个表可以有多个列，也称为属性(attribute)，每个列都有唯一的名字，每个列都有特定的类型。

```sql
-- 表创建
gaussdb=# create table emp1 as select * from emp where sal<2000;      --使用查询语句结果创建表
gaussdb=# create table emp2 as table emp;                             --使用已存在的表创建表
gaussdb=# CREATE TABLE IF NOT EXISTS warehouse_t1                     -- 表不存在时才创建，使得当该表存在时该建表语句不会报错
(
W_WAREHOUSE_SK INTEGER NOT NULL,
W_WAREHOUSE_ID CHAR(16) NOT NULL,
W_WAREHOUSE_NAME VARCHAR(20) UNIQUE DEFERRABLE,                       -- 事务结束时检查字段是否有重复
W_SUITE_NUMBER CHAR(10),
W_STATE CHAR(2) DEFAULT 'GA',                                         -- 缺省值为'GA'
W_GMT_OFFSET DECIMAL(5,2)
) TABLESPACE

-- 修改普通表属性
gaussdb=# alter table emp1 modify sal number(10,2);                                              -- 修改列属性
gaussdb=# alter table emp1 rename column ename to name;                                          -- 重命名列
gaussdb=# alter table emp1 add primary key (empno);                                              -- 添加主键约束
gaussdb=# alter table emp1 add constraint chk_dept check (deptno is not null);                   -- 添加check约束
gaussdb=# alter table emp1 add constraint fk_dept foreign key (deptno) references dept(deptno);  -- 添加外键约束
gaussdb=# alter table emp1 modify sal constraint chk_sal not null;                               -- 修改列约束条件
gaussdb=# alter table emp1 rename constraint chk_dept to chk_deptno;                             -- 重命名约束
gaussdb=# alter table emp1 set schema jack;                                                      -- 设置所属schema
gaussdb=# alter table jack.emp1 rename to emp2;                                                  -- 重命名表
gaussdb=# \d jack.emp2

-- 设置行级访问控制
gaussdb=# create user alice password 'gauss@123';
gaussdb=# create table all_data(id int, role varchar(100), data varchar(100));
gaussdb=# insert into all_data values(1, 'alice', 'alice data');
gaussdb=# insert into all_data values(2, 'bob', 'bob data' );
gaussdb=# insert into all_data values(3, 'peter', 'peter data');
gaussdb=# grant select on all_data to alice;
gaussdb=# alter table all_data enable row level security;
gaussdb=# create row level security policy all_data_rls on all_data using(role = current_user);
gaussdb=# \c - alice
gaussdb=# select * from all_data;                                         -- 仅能看到指定用户的数据，系统管理员不受行访问控制影响
gaussdb=# explain select * from public.all_data;

-- 删除表
gaussdb=# drop table all_data;
```

#### 分区表

分区表是把逻辑上的一张表根据某种方案分成几张物理块进行存储，这张逻辑上的表称之为分区表，物理块称之为分区。
分区表是一张逻辑表，不存储数据，数据实际是存储在分区上的。

常见的分区方案：

1. 范围分区（Range Partitioning）
2. 哈希分区（Hash Partitioning）
3. 列表分区（List Partitioning）

目前行存表支持范围分区、间隔分区、哈希分区、列表分区。

**范围分区 VALUES LESS THAN**

使用 PARTITION BY RANGE(partition_key)进行范围分区，partition_key 为分区键属性名。

从句是 VALUES LESS THAN 格式：

```sql
gaussdb=# CREATE TABLE part_tbl1 (a int, b int)
PARTITION BY RANGE(a)
(
    PARTITION part1 VALUES LESS THAN (10),
    PARTITION part2 VALUES LESS THAN (100),
    PARTITION part3 VALUES LESS THAN (MAXVALUE)
);
```

**范围分区 START END**

从句是 START END 格式：

```sql
gaussdb=# CREATE TABLE part_tbl2 (a int, b int)
PARTITION BY RANGE(a)
(
    partition part1 START(1) END(100) EVERY(50),
    partition part2 END(200),
    partition part3 START(200) END(300),
    partition part4 start(300)
);
```

#### 索引

索引类似书籍的目录，通过目录中的关键字信息，找到书中对应的信息页。

- 优点：索引减少了搜索元组的时间，提升了数据的访问速度。没有索引，只能遍历表中所有的元组，效率很低
- 缺点：但是索引也增加了插入、更新、删除的处理时间，因为要同步更新索引信息。且索引需要额外存储空间，创建过多索引对数据库性能有负面影响

```sql
-- 创建索引
gaussdb=# create unique index t1_fn_idx on t1(relfilenode);                       -- 创建唯一索引
gaussdb=# create index t1_owner_tbs_idx on t1(relowner,reltablespace);            -- 创建复合索引
gaussdb=# create index t1_lttbs_idx on t1(reltablespace) where reltablespace<20;  -- 创建部分索引
gaussdb=# create index t1_upname_idx on t1(upper(relname));                       -- 创建函数索引
gaussdb=# create index pt1_id_idx on pt1(id) local;                               -- 创建分区表的本地索引
gaussdb=# create index pt1_score_idx on pt1(score) global tablespace tbs1;        -- 创建分区表的全局索引

-- 修改索引
gaussdb=# alter index t1_fn_idx rename to t1_fn_idx2;
gaussdb=# alter index t1_fn_idx2 set tablespace tbs2;
gaussdb=# alter index t1_lttbs_idx unusable;
gaussdb=# alter index t1_lttbs_idx rebuild;

-- 修改分区索引
gaussdb=# alter index pt1_id_idx rebuild partition p1_id_idx;
gaussdb=# alter index pt1_id_idx modify partition p1_id_idx unusable;
gaussdb=# alter index pt1_id_idx rename partition p1_id_idx to p1_id_idx2;
gaussdb=# alter index pt1_id_idx move partition p1_id_idx2 tablespace tbs1;

-- 删除索引
gaussdb=# drop index t1_lttbs_idx;

-- 重建索引
gaussdb=# reindex index t1_lttbs_idx;      -- 重建单个索引
gaussdb=# reindex table t1;                -- 重建表上所有索引
```

#### 视图

当用户对数据库中的一张或者多张表的某些字段的组合感兴趣，而又不想每次键入这些查询时，用户就可以定义一个视图，以便解决这个问题。

为了提升查询性能，可以将视图“物化”（Materialized），即将视图的查询结果实际存储在磁盘中。

物化视图以类表的形式保存结果，但无法像普通表那样进行数据更新，要使用 REFRESH 从基表获取更新数据。

```sql
-- 创建视图
gaussdb=# create view v1 as SELECT * FROM pg_tablespace WHERE spcname = 'pg_default';                               -- 创建视图
gaussdb=# create materialized view mv1 tablespace tbs1 as SELECT * FROM pg_tablespace WHERE spcname = 'pg_default'; -- 创建物化视图

-- 查询视图及定义
gaussdb=# select * from v1;               -- 查询视图数据
gaussdb=# select * from mv1;              -- 查询物化视图
gaussdb=# select pg_get_viewdef('v1');    -- 查询视图定义pg_get_viewdef
----------------------------------------------------------------------------------
SELECT * FROM pg_tablespace WHERE (pg_tablespace.spcname = 'pg_default'::name);

-- 管理物化视图
gaussdb=# alter view v1 rename to v2;     -- 重命名视图
gaussdb=# alter view v2 owner to jack;    -- 修改视图属主
gaussdb=# alter view v2 set schema jack;  -- 修改视图schema
gaussdb=# refresh materialized view mv1;  -- 刷新物化视图

-- 删除视图
gaussdb=# drop view jack.v2;              -- 删除视图
gaussdb=# drop materialized view mv1;     -- 删除物化视图
```

#### 序列

序列 Sequence 是用来产生唯一整数的数据库对象，这也是 Sequence 常被用作主键的原因，序列的值是按照一定规则自增的整数，可以看作是存放等差数列的特殊表。

通过序列使某字段成为唯一标识符的方法有两种：

1.  一种是声明字段的类型为序列整型，由数据库在后台自动创建一个对应的 Sequence。
2.  一种是使用 CREATE SEQUENCE 自定义一个新的 Sequence，然后将 nextval('sequence_name')函数读取的序列值，指定为某一字段的默认值，这样该字段就可以作为唯一标识符。

```sql
-- 创建序列
gaussdb=# create sequence seq01;
gaussdb=# create sequence seq02 increment by 1 minvalue 1 maxvalue 99999 cache 1 nocycle;

-- 使用序列
gaussdb=# select nextval('seq01');    -- 递增序列并返回新值
gaussdb=# select seq01.nextval;
gaussdb=# select currval('seq01');    -- 最近一次nextval返回的值
gaussdb=# select seq01.currval;
gaussdb=# select lastval();           -- 最近一次nextval返回的值
gaussdb=# select setval('seq01',1);   -- 设置序列的当前数值

-- 修改序列属性
gaussdb=# alter sequence seq01 maxvalue 99999;
gaussdb=# alter sequence seq01 owner to jack;

-- 删除序列
gaussdb=# drop sequence seq01;
gaussdb=# drop sequence seq02 cascade;

-- 查询序列
gaussdb=# \d t2_id_seq -- 使用元命令查看序列
gaussdb=# select * from t2_id_seq; -- 查询序列

-- 序列应用
gaussdb=# create table t2(id serial,name varchar(20),tag int);
gaussdb=# insert into t2 values(default,'Jerry');
gaussdb=# insert into t2 values(default,'Tom');
gaussdb=# select * from t2;
----------------------------------------------------------------------------------------------------------------------------------------------------
gaussdb=# alter table t2 alter tag set default nextval('seq01');
gaussdb=# insert into t2 values(default,'Jack');
gaussdb=# insert into t2 values(default,'Jhon');
gaussdb=# select * from t2;
```

#### 同义词

同义词（SYNONYM）是数据库对象的别名，用于记录与其他数据库对象名间的映射关系，用户可以使用同义词访问关联的数据库对象，支持的数据库对象包括：表、视图、函数和存储过程。

1. 若指定模式名称，则同义词在指定模式中创建。否则，在当前模式创建
2. 使用同义词时，用户需要具有对关联对象的相应权限，包括：SELECT、INSERT、UPDATE、DELETE、EXPLAIN、CALL

```sql
-- 创建同义词
gaussdb=# create synonym syn_t1 for t1;              -- 创建表的同义词
gaussdb=# create synonym syn_emp for v_emp;          -- 创建视图的同义词
gaussdb=# create synonym syn_add for func_add_sql;   -- 创建函数同义词
gaussdb=# create synonym syn_proc_emp for proc_emp;  -- 创建存储过程同义词

-- 使用示例
gaussdb=# select * from syn_emp;
gaussdb=# select syn_add(1,2);
gaussdb=# call syn_proc_emp(7566,name,job,sal);

-- 删除同义词
gaussdb=# drop synonym syn_add;

```

### 存储过程

#### 存储过程

存储过程（Stored Procedure）：是一组为了完成特定功能的 SQL 语句集，它经过编译后存储在数据库中，用户通过指定存储过程的名字并给出参数（如果该存储过程带有参数）来执行它，包括了数据类型、流程控制、输入输出以及库函数。

使用场景：在实际业务中，存储过程可以提高性能、提高开发效率，同时也具备良好的安全性能。可以用于处理一些复杂任务场景，例如处理多个条件和大量数据，使用存储过程可以提高效率；提高数据访问的安全性，可以通过给存储过程设置不同的访问权限来实现。

#### 匿名块

匿名块（Anonymous Block）一般用于不频繁执行的脚本或不重复进行的活动，它们在一个会话中执行，并不被存储。

#### 函数

函数是在数据库内定义的子程序，可以从内置 SQL 语句中被调用，这是非常有用的。（其作用与编程语言中的函数类似，主要为封装特定代码逻辑、减少重复编码）。

大多数 SQL 语言都自带有一些简单重要的函数，用户也可以添加自定义的函数。

数据库函数和存储过程的不同点：函数必须返回单个值。存储过程则可能返回多个值或没有返回值。

#### 代码块结构(PL/SQL)

### JDBC 高可用

#### 负载均衡

GaussDB JDBC 驱动提供了一种有效方法，对于分布式环境，可在多个服务器实例之间分配读写负载。

当前提供四种策略：

1. 轮询：设置为 true/balance/roundrobin 表示开启 JDBC 轮询负载均衡功能，将应用程序的多个连接均衡到数据库集群中的各个可用 CN。
2. 优先级：设置为 priorityn 表示开启 JDBC 优先级负载均衡功能，将应用程序的多个连接首先均衡到 url 上配置的前 n 个中可用的 CN 数据库节点，当 url 上配置前 n 个节点全部不可用时，连接会随机分配到数据库集群中其他可用 CN 数据库节点。n 为数字，不小于 0，且小于 url 上配置的 CN 数量
3. 随机：设置为 shuffle 表示开启 JDBC 随机负载均衡功能，将应用程序的多个连接随机均衡到数据库集群中的各个可用 CN。
4. shuffleN

```yml
# 示例如下：
jdbc: gaussdb://host1:port1,host2:port2/database?autoBalance=[value]


# 轮询
jdbc: gaussdb://host1:port1,host2:port2/database?autoBalance=true
# 优先级
jdbc: gaussdb://host1:port1,host2:port2/database?autoBalance=priority2
# 随机
jdbc: gaussdb://host1:port1,host2:port2,host3:port3/database?autoBalance=shuffle
# 设置为 false，不开启 JDBC 负载均衡，默认为 false。
```

#### 读写分离与故障转移

Gauss JDBC 驱动支持配置读写分离，对于集中式环境，可根据配置选择目标主机建连。

```yml
jdbc: gaussdb ://host1:port1,host2:port2/database?targetServerType=[value]
```

该参数识别主备是通过判断连接串中主备节点是否允许写操作来实现的。

- 连接读写节点：设置 targetServerType=master，则尝试连接到 url 连接串中的主节点，如果找不到主节点将抛出异常
- 连接只读节点：设置 targetServerType=slave，则尝试连接到 url 连接串中的备节点，如果找不到备节点将抛出异常
- 优先连接只读节点：设置 targetServerType=preferSlave，则尝试连接到 url 连接串中的备节点，如果备节点不可用，将连接到主节点，否则抛出异常
- 连接任意节点：设置 targetServerType=any，则尝试连接 url 连接串中的任意节点

注意： hostRecheckSeconds 参数用于控制 JDBC 扫描节点状态的时间，如果存在主备切换，该参数可以在扫描时间点内切换访问节点，默认 10s。

#### 日志记录功能

GaussDB JDBC 驱动，提供了日志诊断功能，该功能能够识别和修复 JDBC 应用程序中的问题。

```yml
jdbc: gaussdb://host1:port1/database?logger=Slf4JLogger&loggerLevel=trace
```

该功能包含两个参数：

- loggerLevel：目前支持 4 种级别：OFF、INFO、DEBUG、TRACE。设置为 OFF 关闭日志。设置为 INFO、DEBUG 和 TRACE 记录的日志信息详细程度不同
- logger：表示 JDBC 要使用的日志输出框架。支持对接用户应用程序使用的日志输出框架。目前仅支持第三方的基于 Slf4j-API 的日志框架。如果不设置或设置为 JdkLogger，则 JDBC 使用 JdkLogger。否则必须设置采用基于 slf4j-API 第三方日志框架

### 数据库对象命名与建议

**命名建议**

【规则】长度不超过 63 个字符, 以字母或下划线开头， 中间字符可以是字母、数字、下划线、$、#。

【规则】不使用保留或非保留关键字命名数据库对象。说明：可以使用 select \* from pg_get_keywords()查询关键字。

【建议】数据库对象命名风格务必保持统一。增量开发的业务系统或进行业务迁移的系统，建议遵守历史的命名风格。

【建议】避免使用双引号括起来的字符串来定义数据库对象名称，除非需要限制数据库对象名称的大小写。数据库对象名称大小写敏感会使定位问题难度增加。

**Database 和 Schema**

从便捷性和资源共享效率上考虑，推荐使用 Schema 进行业务隔离。建议系统管理员创建 Schema 和 Database，再赋予相关用户对应的权限。设计建议：

【规则】在实际业务中，避免直接使用集群默认的数据库 postgres，根据需要创建新的 Database。

【关注】创建 Database 时，需要重点关注字符集编码(ENCODING)和兼容性(DBCOMPATIBILITY)两个配置项。 GaussDB 支持 A、B、M、C、PG 五种兼容模式，分别表示兼容 O 语法、MySQL 语法（B 及 M 均为 MySQL 兼容，B 模式仅进行维护，不再演进，M 模式持续演进）、TD 语法、POSTGRES 语法及新 MySQL 语法，不同兼容模式下的语法行为存在一定差异，默认为语法兼容模式为：集中式-O 语法（A），分布式-MySQL 语法（B）。

【建议】为了使数据库编码能够存储与表示绝大多数的字符，建议创建 Database 时使用 UTF-8 编码。

【关注】Schema 下的对象访问权限，默认只有 owner 和系统管理员拥有。要访问 Schema 下的对象，需要同时给用户赋予 Schema 的 usage 权限和对象的相应权限。

**字段**

字段选择数据类型，高效数据类型，主要包括以下三方面：

1. 尽量使用执行效率比较高的数据类型 一般来说整型数据的运算(包括=、＞、＜、≧、≦、≠ 等常规的比较运算，以及 group by)，效率比字符串、浮点数要高。
2. 尽量使用短字段的数据类型 长度较短的数据类型不仅可以减小记录的大小，提升 IO 性能；同时也可以减小相关计算时的内存消耗，提升计算性能。比如对于整型数据，如果可以用 smallint 就尽量不用 int，如果可以用 int 就尽量不用 bigint。
3. 使用一致的数据类型 表关联列尽量使用相同的数据类型。如果表关联列数据类型不同，数据库必须动态地转化为相同的数据类型进行比较，这种转换会带来一定的性能开销。

**约束**

【建议】如果能够从业务层面补全字段值，那么就不建议使用 DEFAULT 约束，避免数据加载时产生不符合预期的结果。

【建议】给明确不存在 NULL 值的字段加上 NOT NULL 约束，优化器会在特定场景下对其进行自动优化。

【建议】给可以显式命名的约束显式命名。除了 NOT NULL 和 DEFAULT 约束外，其他约束都可以显式命名。

唯一约束：

- 【关注】用于确保字段中的值不会重复。例如每个员工的身份证、手机号等需要唯一
- 【建议】从命名上明确标识唯一约束，例如，命名为“UNI+字段名”。

主键约束：

- 【关注】用于唯一标识表中的每一行数据。例如员工信息表中，工号通常作为主键。主键字段不能为空并且唯一，每个表可以有且只能有一个主键。
- 【建议】从命名上明确标识主键约束，例如，将主键约束命名为 “PK+字段名”。

检查约束：

- 【关注】可以定义更多的业务规则。例如，员工性别的取值只能为“男”或“女” 等；
- 【建议】从命名上明确标识检查约束，例如，将检查约束命名为 “CK+字段名”。

**视图和关联表**

视图设计：

- 【建议】除非视图之间存在强依赖关系，否则不建议视图嵌套。
- 【建议】视图定义中尽量避免排序操作。

关联表设计：

- 【建议】表之间的关联字段应该尽量少。
- 【建议】关联字段的数据类型应该保持一致。
- 【建议】关联字段在命名上，应该可以明显体现出关联关系。例如，采用同样名称来命名。

## 迁移

### 数据库和应用迁移 UGO

数据库和应用迁移 UGO（Database and Application Migration UGO，简称为 UGO） ，是专注于异构数据库对象迁移和应用迁移的专业化工具。通过预迁移评估、结构迁移、应用迁移、SQL 审核四大核心功能，实现主流商用数据库到华为云数据库的自动化搬迁，助力用户轻松实现一键上云、一键切换数据库的目的

核心功能：

1. 数据库评估 评估异构数据库语法兼容性，提前识别迁移风险
2. 对象迁移 语义级等价 SQL 转换，一键自动迁移，减少人力投入
3. 应用迁移 应用代码 SQL 提取、评估与转换，帮助应用快速完成改造
4. SQL 审核 前置审核 SQL 规范性、合理性及性能等，避免“烂 SQL”流入生产环境

## 兼容性与高级 SQL

## 性能调优

性能调优：指硬件、操作系统级、数据库系统级的调优，其目的是充分地利用机器的 CPU、内存、I/O 和网络资源，避免资源冲突，提升整个系统的吞吐量。

通常，影响数据库性能的因素有以下几类：

- 硬件：服务器、存储、网络。
- 系统规模：并发、数据量。
- 软件环境：操作系统及参数配置。
- 数据库：内核参数、表结构、索引、统计信息等。

## 日常运维

### 数据导入导出

| 适用工具           | 适用场景                                                                     | Oracle 对应工具 | 特点                             |
| ------------------ | ---------------------------------------------------------------------------- | --------------- | -------------------------------- |
| gsql               | sql 文本的导入导出，适用于集中式和分布式。                                   | sqlplus         | 数据库从客户端导入导出数据       |
| copy to/from       | 查询结果集在线导入导出，适用于集中式和分布式。                               | --              | 数据库服务端从数据源导入导出数据 |
| gs_dump/gs_restore | 数据库批量数据在线导入导出，以及数据对象定义导入导出。适用于集中式和分布式。 | expdp/impdp     | 支持导入导出数据库元数据         |
| gs_loader          | Oracle 的 sqlldr 兼容场景在线导入，当前只适用于集中式，未来会支持分布式。    | sqlldr          | 兼容 oracle 导入数据使用方式     |
| GDS                | 分布式场景大批量数据导入/导出                                                |                 | 多 dn 并发导入导出               |

#### gsql

适用场景

- 文本格式对象定义的创建

使用方法

```sql
-- 文本格式对象定义的创建；
-- -d 指定数据库名；
-- -p 数据库CN连接端口号；
-- -U 数据库用户名；
-- -W 数据库用户密码；
-- -f sql脚本文件；
gsql -d db1 -p 16000 -U u1 -W ****** -f /data/table.sql

-- 通过元命令进行导入导出
\o                      -- 把所有的查询结果发送到文件里。
\o /data/exec.out
\i                      -- 从文件FILE中读取内容，并将其当作键盘输入，执行查询。
\i /data/exec.sql
\copy                   -- 进行数据的导入导出，数据来源支持STDIN（标准输入）和文件。
\copy t1 from '/data/input/t1.txt' delimiter ‘,';
```

#### copy

适用场景

- 小数据量表以文本数据作为来源导入；
- 小数量表的导出，查询结果集导出；

使用方法

```sql
-- 文本数据导入
copy t1 from '/data/input/t1.txt' delimiter ',';

-- 表数据导出
copy t1 to '/data/input/t1_output.txt' delimiter ',';

-- 查询结果集导出
copy (select * from t1 where a2=1) to '/data/input/t1_output.txt' delimiter ',';
```

JDBC 中使用 copy

```java
private void metadataToDB() {
    try {
        CopyManager cpManager = new CopyManager((BaseConnection) conn);
        //清理数据库中已有数据，可选
        st.executeUpdate(“TRUNCATE TABLE metadata;”);
        String metaFile = this.dataDirectory + File.separator + this.metadataFile;
        this.logger.log(Level.INFO, "Importing metadata from " + metaFile);
        long n = cpManager.copyIn(“COPY metadata FROM STDIN WITH CSV”, new
        FileReader(metaFile));
        this.logger.log(Level.INFO, n + " metadata imported");
    } catch (Exception e) {
        e.printStackTrace();
        System.exit(1);
    }
}
```

#### gs_dump/gs_restore

适用场景

- 导出、恢复整个数据库对象定义：用户可以自定义导出一个数据库或其中的对象（模式、表、视图等）。
- 以 Sql 语句进行导入、导出：导入导出为.sql 文件格式为纯文本格式
- 避开业务高峰期，避免操作失败：gs_dump 工具在进行数据导出时，其他用户可以访问数据库数据库（读或写）。

使用方法

```sql
-- 导出单表定义
-- -U 数据库用户名；
-- -W 数据库用户密码；
-- -p 数据库CN连接端口号；
-- -s 只导出对象定义，不导出对象数据；
-- -t 只导出指定的该表；导入多表时可以指定多个-t, 如：-t t1 -t t2
-- -f 将输出发送至指定文件；
-- -F 导出文件的格式，取值有四种：p 纯文本、c 自定义归档、d 目录归档和t tar归档格式
gs_dump mydb -U u1 -W ******* -p 16000 -s -t t1 -f /data/t1.sql –F c

-- 导出整个数据库对象
gs_dump mydb -p 16000 -s -f /data/all.sql

-- 导出数据库所有对象和数据
gs_dump mydb -p 16000 -f /data/all.sql


-- 执行gsql程序，使用如下选项导入由gs_dump/gs_dumpall生成导出文件夹（纯文本格式）的MPPDB_backup.sql文件到mydb数据库。
-- -f 导出的文件，
-- -p 数据库服务器端口
-- -d 访问的数据库名。
gsql -d mydb -p 8000 -f /home/omm/test/MPPDB_backup.sql
Password:
SET
ALTER TABLE
CREATE INDEX
REVOKE
GRANT
total time: 30476 ms

-- gs_restore工具支持的格式包括自定义归档、目录归档和tar归档格式。
-- 执行gs_restore，将导出的MPPDB_backup文件（目录格式）导入到mydb数据库。
gs_restore backup/MPPDB_backup -p 8000 -d mydb
Password:
gs_restore[2017-07-21 19:16:26]: restore operation
successful
gs_restore[2017-07-21 19:16:26]: total time: 21003 ms
```

#### gs_loader

gs_loader 工具是一款兼容 Oracle 的 sqlldr 的导入工具，语法基本兼容 Oracle 的 sqlldr。

适用场景

- Oracle 的 sqlldr 兼容场景的导入
- 可以设置导入的容错性
- 当前只支持集中式

#### GDS

GDS（Gauss Data Service）工具，用于解决分布式场景下大数据量数据导入导出慢的问题。通过 DN 并行导入导出，解决了 CN 在分布式常规导入导出的瓶颈问题，极大提升了导入导出的效率。

适用场景

- 当前仅支持分布式
- 大数据量表以文本数据作为来源导入。
- 大数据量表的导出。
- 可以设置导入的容错性。
- 建议应用于离线导入场景

### 运维管理工具

### 备份恢复

### 智能运维
