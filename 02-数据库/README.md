# 数据库

## 常用数据库

| 数据库  | 模型   |
| ------- | ------ |
| Mysql   | 关系型 |
| Oracle  | 关系型 |
| Redis   | 键值型 |
| MongoDB | 文档型 |


## 国产关系型数据库

> 墨天轮网站排名  [https://www.modb.pro/dbRank](https://www.modb.pro/dbRank)
>
> 国家保密科技测评中心，安全可靠测评结果公告（2024年第2号）  [http://www.nsstec.org.cn/tzgg/354277.shtml](http://www.nsstec.org.cn/tzgg/354277.shtml)
>

| 国产数据库名称    | 模型   | 解释                                                                                                                                           |
| ----------------- | ------ | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| OceanBase         | 关系型 | 蚂蚁集团完全自主研发的国产原生分布式数据库。                                                                                                   |
| PolarDB           | 关系型 | 阿里云自主研发的新一代关系型云原生数据库，包括云原生数据库 PolarDB MySQL 版、云原生数据库 PolarDB PostgreSQL 版和云原生数据库 PolarDB 分布式版 |
| 达梦数据库        | 关系型 | 达梦公司推出的具有完全自主知识产权的高性能数据库管理系统，简称 DM。达梦数据库管理系统的最新版本是 8.0 版本，简称 DM8。                         |
| openGauss         | 关系型 | 华为的一款企业级开源关系型数据库。                                                                                                             |
| TiDB              | 关系型 | PingCAP 公司自主设计、研发的开源分布式关系型数据库。                                                                                           |
| 人大金仓 KingBase | 关系型 | 北京金仓信息技术有限公司开发的一款数据库管理系统。                                                                                             |
| GBASE             | 关系型 | 南大通用数据技术有限公司推出的自主品牌的数据库。                                                                                               |
| GoldenDB          | 关系型 | 中兴通讯的金融级的交易型分布式数据库。                                                                                                         |
| GaussDB           | 关系型 | 华为自主创新研发的分布式关系型数据库。                                                                                                         |
| TDSQL             | 关系型 | 腾讯云自研企业级分布式数据库。                                                                                                                 |
| 瀚高数据库        | 关系型 |                                                                                                                                                |
| 神通数据库 OSCAR  | 关系型 | 天津神舟通用数据技术有限公司拥有自主知识产权的企业级、大型通用关系型数据库管理系统                                                             |

## 时序数据库

> 时序数据的说明，可以参考北京涛思的官网文档：https://docs.taosdata.com/concept/

TSDB（Time Series Database）时序数据库，常用的有 涛思 TDengine、InfluxDB、openPlant、清华 IoTDB。

时序数据，即时间序列数据（Time-Series Data），它们是一组按照时间发生先后顺序进行排列的序列数据。日常生活中，设备、传感器采集的数据就是时序数据，证券交易的记录也是时序数据。因此时序数据的处理并不陌生，特别在是工业自动化以及证券金融行业，专业的时序数据处理软件早已存在，比如工业领域的 PI System 以及金融行业的 KDB。


### InfluxDB

InfluxDB 是一种开源的、高性能的时序数据库，特别适用于存储和查询时间相关的数据。它具有易于使用的 API 和查询语言，可以处理大规模的时间序列数据，并提供了丰富的功能和工具来进行数据分析和监控。

InfluxDB 针对现实世界的测量值选择了 bucket、measurement 这两个核心概念，没有关系数据库里的 database、table 等概念；

### TDengine

TDengine 是一款专为物联网、工业互联网等场景设计并优化的大数据平台，其核心模块是高性能、集群开源、云原生、极简的时序数据库。它能安全高效地将大量设备、数据采集器每天产生的高达 TB 甚至 PB 级的数据进行汇聚、存储、分析和分发，对业务运行状态进行实时监测、预警，提供实时的商业洞察。

北京涛思数据科技有限公司开发的，国产的数据库。

TDengine 设计了一种高度优化的数据结构和查询引擎，具有出色的写入和查询性能。它支持 SQL 语法，同时还提供了 C/C++、Java、Python 等多种编程语言的 API。

TDengine 选择了兼容 SQL、降低门槛的路线，也就继承了 database、table 等概念，同时创新性地提出了“一个数据采集点一张表”的数据模型。

**与 InfluxDB 对比**

1. 性能 TDengine 在性能方面表现更好。它可以处理更高的数据吞吐量和更大的数据量。TDengine 的写入速度比 InfluxDB 快得多，而且它的查询速度也更快。
2. 数据模型 InfluxDB 使用的是标签-值数据模型，而 TDengine 使用的是传统的关系型数据模型。这意味着在 InfluxDB 中，每个数据点都有一个标签和一个值，而在 TDengine 中，数据点是一个行，每个行有多个列。
3. 数据存储 InfluxDB 使用的是 TSI（Time-Structured Merge Tree）存储引擎，而 TDengine 使用的是 TAOS 引擎。TAOS 引擎是专门为时序数据设计的，它可以更好地处理时序数据的存储和查询。
4. 数据可靠性 TDengine 在数据可靠性方面表现更好。它支持数据的多副本备份和数据的自动恢复。而 InfluxDB 则需要使用外部工具来实现数据的备份和恢复。
5. 社区支持 InfluxDB 拥有更大的社区支持，有更多的插件和工具可以与之集成。而 TDengine 的社区支持相对较小，但它正在不断发展壮大。总的来说，TDengine 在性能和数据可靠性方面表现更好，而 InfluxDB 在数据模型和社区支持方面表现更好。选择哪个时序数据库取决于具体的需求和应用场景。

### openPlant

麦杰数据库（openPlant）是上海麦杰科技自主研发的实时数据库系统，是一款针对海量动态数据进行采集、存储、分析和展示的数据库产品。

## 数据库连接池选择

### 小型项目

使用 Druid 和 Hikari 哪种都可以，都有各自的优缺点。使用 SpringBoot 自带的 Hikari 数据库连接池操作简单，不需要引入额外的 jar 包，拿来即用，也不需要额外的多做配置等；使用 Druid 连接池还支持 sql 级监控、扩展、SQL 防注入等。

推荐使用 Druid 连接池。

### 中型项目

Druid 功能更全面，除具备连接池基本功能外，还支持 sql 级监控、扩展、SQL 防注入等。最新版甚至有集群监控单从性能角度考虑，从数据上确实 HikariCP 要强，且 Druid 有更多、更久的生产实践，更可靠。

推荐使用 Druid 连接池。

### 大型项目

因为大型项目中有专门用于监控的系统(skwwalking、prometheus)，连接池就只需要它做好连接池的本职工作即可，因此性能更好的 HikariCP 才是首选。

推荐使用默认的 HikariCP 连接池。
