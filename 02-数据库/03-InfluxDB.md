## 数据模型

InfluxDB 数据模型将时序数据组织为 bucket 和 measurement。一个 bucket 可以包含多个 measurement。measurement 可以包含多个标签和字段。

可以将 bucket 理解为存储时序数据的位置，我们可以为其指定时序数据的保存策略。measurement 则用于时序数据的逻辑分组。从逻辑意义上对比，我们可以把 bucket 看作关系数据库中的 database，把 measurement 看作 table。

measurement 又包括几个部分：

- 标签（tag）：其值不经常改变的键值对。用来保存一些相对静态的信息，比如采集设备的主机、位置、站点等。
- 字段（field）：其值随着时间经常改变的键值对，比如温度、压强、股价等。
- 时间戳（timestamp）：与当前数据关联的时间戳。

在此基础上，InfluxDB 又有两个新的概念，point（数据点）和时间线（series），当然这在很多时序数据库中都是类似的。

整体来看，InfluxDB 的数据模型比较直观，而且不需要提前定义好模式，容易上手，后期如果有需要，动态增加新的字段也比较容易。当然，考虑后续的查询性能，在数据量非常大的情况下，也需要仔细设计 measurement 中的 tag 和 field，在此就不做赘述。新用户可以直接使用 InfluxDB 的图形界面或命令行客户端来创建 bucket，然后就可以利用行协议写入数据了。就像这样：

influx write \
  --bucket get-started \
  --precision s "
home,room=Living\ Room temp=21.1,hum=35.9,co=0i 1641024000
home,room=Kitchen temp=21.0,hum=35.9,co=0i 1641024000
home,room=Living\ Room temp=21.4,hum=35.9,co=0i 1641027600
home,room=Kitchen temp=23.0,hum=36.2,co=0i 1641027600
home,room=Living\ Room temp=21.8,hum=36.0,co=0i 1641031200
home,room=Kitchen temp=22.7,hum=36.1,co=0i 1641031200
home,room=Living\ Room temp=22.2,hum=36.0,co=0i 1641034800
"
在查询方面，InfluxDB 提供了类 SQL 的 InfluxQL 语言，后来又推出了函数式的脚本语言 Flux。需要一定的学习成本。