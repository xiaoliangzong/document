# RabbitMQ

## 1. 安装

**Windows**
如果以前安装过，则需要卸载 rabbitmq 和 erlang，erlang 必须卸载或者清空注册表，否则会导致安装失败。

```shell
# 1.安装语言 erlang，exe文件直接安装。
# 2. 安装 mq
   - 解压，配置环境变量；
   - rabbitmq-service intall                             # 安装服务，可以在管理->服务列表查看；
   - rabbitmq-plugins.bat enable rabbitmq_management     # 开启可视化插件；
   - rabbitmq-service remove                             # 移除服务
   - rabbitmq-service start | net start rabbitmq         # 启动服务
   - rabbitmq-service stop | net stop rabbitmq           # 停止服务
   - rabbitmqctl status                                  # 查看服务状态
   - rabbitmq-server restart                             # 重启服务

# 3. 添加用户
   - rabbitmqctl add_user admin fengpin@123              # 新增一个用户
   # 给用户添加角色，超级管理员(administrator)，监控者(monitoring)，策略制定者(policymaker)，普通管理者(management)
   - rabbitmqctl set_user_tags admin administrator
   - rabbitmqctl set_permissions -p / User ".*" ".*" ".*"     # 授权，-p  VHostPath  User  ConfP  WriteP  ReadP
   - rabbitmqctl change_password guest xxx               # 更改 guest 密码
   - rabbitmqctl delete_user guset                       # 删除 guest 用户
   - rabbitmqctl list_users                              # 查看已有用户及用户角色
   - rabbitmqctl list_permissions [-p VhostPath]         # 查看(指定hostpath)所有用户的权限信息
   - rabbitmqctl list_user_permissions User              # 查看指定用户的权限信息
   - rabbitmqctl clear_permissions [-p VHostPath]  User  # 清除用户的权限信息
```

**Linux**

```shell
# 1. 安装 erlang
   - 下载解压缩安装包 tar -xzvf otp_src_20.1.tar.gz
   - 删除安装包
   - 安装 GCC 编译器 yum install -y gcc-c++
   - 安装 curses yum -y install ncurses-devel
   - 安装 openssl yum install openssl-devel
   - 安装 ODBC Library yum install unixODBC-devel
   - 进入目录 cd otp_src_20.1.tar.gz
   - 配置安装路径编译代码 ./configure --prefix=/usr/local/erlang（安装路径）
   - 执行编译结果 make && make install
   - 进入安装路径 cd /usr/local/erlang/bin，验证安装 ./erl
   - 配置环境变量 vi /etc/profile，增加环境变量 export PATH=$PATH: /usr/local/erlang/bin
   - 使环境变量生效 source /etc/profile
# 2. RabbitMQ 安装配置
   - 下载安装包 wget http://www.rabbitmq.com/releases/rabbitmq-server/v3.6.1/rabbitmq-server-generic-unix-3.6.1.tar.xz
   - 解压 xz -d rabbitmq-server-generic-unix-3.6.1.tar.xz   tar -xvf rabbitmq-server-generic-unix-3.6.1.tar
   - 删除安装包
   - 配置环境变量 vi /etc/profile，增加环境变量 export PATH=$PATH:/usr/local/rabbitmq*server-3.6.1/sbin
   - 启动服务 rabbitmq-server
   - 另起终端，启动插件 rabbitmq-plugins enable rabbitmq_management
   - 登陆管理页面，登陆 http://localhost:15672/，账号密码均为 guest，Guest 用户仅限 localhost 访问，外网访问需要新建权限用户
   - 新建用户 rabbitmqctl add_user admin Dangbo@123
   - 赋予管理员角色 rabbitmqctl set_user_tags admin administrator
   - 赋予权限 rabbitmqctl set_permissions admin '.*' '.\_' '.\*'
```

**Docker**

```shell
# 1. 拉取镜像
docker pull rabbitmq:3.10.6
# 2. 运行，-e 设置参数
docker run -it --name rabbit -p 15672:15672 -p 5672:5672 --restart unless-stopped -e RABBITMQ_DEFAULT_USER=admin -e RABBITMQ_DEFAULT_PASS=Dangbo@123 rabbitmq:3.10.6
# 3. 开启可视化插件
docker exec -it [containerId] /bin/bash      # 进入容器
rabbitmq-plugins enable rabbitmq_management

# 4. 解决问题，点击Channel时提示 Stats in management UI are disabled on this node
docker exec -it [containerId] /bin/bash      # 进入容器
cd /etc/rabbitmq/conf.d
# 修改 management_agent.disable_metrics_collector = false
echo management_agent.disable_metrics_collector = false > management_agent.disable_metrics_collector.conf
exit                                         # 退出容器
docker restart [containerId]                 # 重启
```

## 2. 核心组件

RabbitMQ 的 Java 客户端使用 com.rabbitmq.client 作为顶级包。

- Connection：代表 AMQP 0-9-1 连接；通过 ConnectionFactory 构建 Connection 实例，Connection（连接）用于开启通道；
- Channel：代表 AMQP 0-9-1 通道，提供了大多数操作协议方法，承载生成者、消费者、队列的交互；
- Exchange：交换机，接受生产者生产的消息；
- Queue：队列；
- Binding：绑定交换机和队列；
- RoutingKey：路由键，每一条消息的具体绑定关系表达式；
- Consumer：消息的消费者，DefaultConsumer 消费者通用的基类；

**额外配置**

1. x-priority: basic.consume 方法参数(int)。用于设定 consumer 的优先级，数字越大，优先级越高，默认是 0，可以设置负数。
2. alternate-exchange: exchange.declare 方法参数(str，AE 的名称)。当一个消息不能被 route 的时候，如果 exchange 设定了 AE，则消息会被投递到 AE。如果存在 AE 链，则会按此继续投递，直到消息被 route 或 AE 链结束或遇到已经尝试 route 过消息的 AE。
3. x-message-ttl: queue.declare 方法参数(毫秒，非负整数)，用于限定 queue 上消息的生存时间，可配合 DLX。
   消息可通过设置 expiration 控制自己的过期时间。queue 设定的 ttl 和消息自己的 ttl 由两者的小值生效。
4. x-expires:queue.declare 方法参数(毫秒，正整数)，用于限定 queue 自身的生存时间。
5. x-dead-letter-exchange: queue.declare 方法参数(str，DLX 的名称)。
6. x-dead-letter-routing-key: queue.declare 方法参数(str，DLX 的 route)。不设定则使用 message 自身的 route。
7. x-max-length: queue.declare 方法参数(非负整数)。用于限制 queue 的最大 ready 消息总数。
8. x-max-length-bytes: queue.declare 方法参数(非负整数)。用于限制 queue 的最大 ready 消息的 body 总字节数。
   两种限制可同时设置，最先到达的限制条件将被生效。
9. x-max-priority: queue.declare 方法参数(int)。rabbitmq3.5.0 版本后支持优先队列。由于优先队列是一种特殊的持久化方式，使得优先队列只能通过 arguments 的方式声明，且声明后不可改变其支持的 priorities。
   对每一个优先队列的每一个优先级在内存、磁盘都有单独的开销；及额外的 CPU 开销，特别是在 consume 的时候。
   通过在 message 的 basic.properties 中指明 priority(unsigned byte, 0-255)，较大的数对应较高的优先级。若未指明 message 的 priority 则 priority 默认为 0。
   若 message 的 priority 大于 queue 的 maximum priority 则 priority 被认为是 maximum priority。
   对于优先队列，有如下注意事项：
   由于默认情况下 consumer 的预取消息，消息可能会立即被投递给 consumer，而导致优先级关系不能被处理。因而需要在 ack 模式下设定 basic.qos 的 prefetch_count,限制消息的投递。
   如果优先队列设置了 message-ttl，则由于 server 的 ttl 清理是从 head 方向检测处理的，低优先级的过期消息可能会一直存在而无法被清理，且会被统计(如 ready 的消息数，但不会被 deliver)。
   如果优先队列设置了 max-length，则由于 server 从 head 方向 drop 消息以使限制生效，使得高优先级的消息被 drop 掉，而预留位置给低优先级的消息，可能和使用优先队列的初衷背离。
10. user-id：channel.basicPublish 中指定的 BasicProperties 字段。用于验证 publisher。其值应与建立 connection 的 user 名称一致。
    若需要伪造验证，user-id 可使用 impersonator tag,但不能使用 administrator tag。
    federation 从 upstream 收到消息时会丢弃 user-id，除非在 upstream 设置 trust-user-id 属性。
11. authentication_failure_close: broker capability. 用于 client 区分鉴权错误还是网络错误，在 AMQP091 中要求鉴权失败则 broker 关闭连接，以至于 client 无法区分于实际的网络连接错误。
    当开启这个设置时，broker 在鉴权失败后向客户端发送 connection.close 的命令并附带 ACCESS_REFUSED 的原因标识。

## 3. RabbitMQ 消息模型

RabbitMQ 提供了 7 种消息模型。第 6 种是 RPC 拉取方式，基本不用，因此不予学习；第 7 种是新出的发布者确认模式；3、4、5 这三种都属于订阅模型，只不过进行路由的方式不同。

### 3.1 Simple 模型

最简单的消息模式，使用的是默认交换机。

<img name="Hello World" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-helloworld.png" witdh= "60%" height="150px">

### 3.2 Work 模型

多个消费者绑定到一个队列，共同消费队列中的消息；队列中的消息一旦消费，就会消失，每个消费者获取到的消息唯一，使用的也是默认交换机。

<img name="Work Queues" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-work.png" witdh= "60%" height="150px">

<div style="color:red">

可能出现的两个问题：

1. 队列中的数据，默认会平均分发给每个消费者，也就是将所有消息以轮询的方法交给消费者消费；如果有的消费者处理能力很差，就会导致有些消息分发给低能消费者，低能消费者不能及时处理，导致消息处理很慢；
2. MQ 默认使用自动确认机制，只要消费者从队列中获取了消息，无论是否消费成功，都认为消息已经被消费，队列会把该消息数据删掉；如果消费者消费时遇到异常时（比如宕机、重启等），消息就会丢失。

在实际使用过程中，通过同一时刻 MQ 只会发一条消息给消费者来解决第一个问题，从而达到能者多劳的效果，处理消息能力强的消费者获取更多的消息；通过手动确认的方式来保证数据的不丢失。

手动确认机制：消费者从队列获取消息后，MQ 服务器会将该消息标记为不可用（Unacked），等待消费者反馈。如果一直没有反馈，则一直未不可用状态，该消息不会被删除也不能被消费，当出现 Unacked 的消息时，只需要断开连接或重启 RabbitMQ，被标记 Unacked 状态的消息就会重新变为 Ready 状态。</div>

```java
/*
   每次都从队列里拿一个消息进行消费，消费完成再从队列里获取另一个消息进行消费，这行代码就是实现能者多劳的效果。
   如果不写的话队列就会一股脑的把消息平均分配给所有消费者，那么就不能实现能者多劳的效果
*/
channel.basicQos(1);
/*
   手动确认，防止消息还没有消费完成，mq把消息自动删除
   参数：确认队列中哪个具体消息、是否开启多个消息同时确认
*/
channel.basicAck(envelope.getDeliveryTag(), false);
```

### 3.3 发布订阅模型（Fanout）

交换机和列队直接绑定，不需要指定 routingkey，所以他的消息传输速度是发布订阅模式中最快的。

<img name="Publish/Subscribe" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-publishsubscribe.png" witdh= "60%" height="150px">

<img name="Fanout" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-Fanout.png" witdh= "60%" height="150px">

### 3.4 发布订阅模型（Direct）

与 fanout 模式相比，direct 模式需要 RoutingKey 将队列和交换机绑定。

<img name="Direct" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-routing.png" witdh= "60%" height="150px">

<img name="Direct" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-Direct.png" witdh= "60%" height="150px">

### 3.5 发布订阅模型（Topic）

与之前的两种模式相比，区别在于：它可以通过 RoutingKey，将交换机和队列机进行模糊匹配绑定，满足较复杂的生产消息存放到队列的匹配过程。

- \*，有且只匹配一个词
- #，匹配一个或多个词

<img name="Topic" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-topics.png" witdh= "60%" height="150px">

<img name="Topic" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-Topic.png" witdh= "60%" height="150px">

### 3.6 RPC 模型

基本不用

<img name="Topic" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-rpc.png" witdh= "60%" height="150px">

### 3.7 Publisher Confirms 模型

## 4. 简单 Demo

RabbitTemplate 发送方式

- send()，不会对消息进行转换，传递进去是什么消息，就会往 RabbitMQ Server 中发送什么消息；
- convertAndSend()，会将传递进去的消息进行转换，并将转换过后的消息发送到 RabbitMQ Server 中；输出时没有顺序，交换机会马上把所有的信息都交给所有的消费者，消费者再自行处理，不会因为消费者处理慢而阻塞线程。
- convertSendAndReceive()，使用此方法，只有确定消费者接收到消息，才会发送下一条信息，每条消息之间会有间隔时间

api 方式
rabbitmq 提供的 api 1、 直接调用 api 方式，直观、繁琐、功能完善。
2、 流程为创建链接、通道、配置相关参数、生产者推消息、消费者处理消息。
3、 第一次建立通道时，声明相关参数。
4、 消费者在声明 channel 时，不涉及 queue 之外的配置参数。
5、 默认自动应答（平均分发）。
springBoot 集成的 api 1、 注解方式，简洁、控制不完全。
2、 在@RabbitListener 注解时，声明生产者相关的 channel 参数，项目启动时扫描注解，创建相关通道。
3、 实际使用时，消费者也不涉及 queue 之外的配置参数，即不受注解内参数影响。
4、 生产者相关代码不涉及建立连接、通道配置相关内容。
5、 默认手动应答（公平分发，隐式）。

消费过程：
1、 流量控制：限制服务端分发给同一个消费者未处理消息的数量；
2、 获取消息方式：主动轮询、订阅；
3、 消息分发机制：
a) 自动应答、轮询分发：
服务端轮流分发给各个客户端，易于水平拓展；
b) 手动应答、公平分发：
客户端执行完消息后，手动应答服务端本条消息执行完成。能根据各消费者实际能力分发消息；

生产过程：
1、 路由、队列持久化： 服务关闭后，队列、路由是否保留；
2、 消息持久化：服务关闭后，队列中消息是否保留；
3、 自动删除：最后一个消费者链接断开后，是否自动删除队列；
4、 绑定关系表达式：通配符\*表示单个词，#表示多个词；

## 4. 消息确认机制 confirm

## 5. return 机制

## 6. TTL 队列、死信队列

在 RabbitMQ 中，Socket descriptors 是 File descriptors 的子集，它们也是一对此消彼长的关系。然而，它们的默认配额并不大，File descriptors 默认值为“1024”，而 Socket descriptors 的默认值也只有“829”，同时，File descriptors 所能打开的最大文件数也受限于操作系统的配额。因此，如果要调整 File descriptors 文件句柄数，就需要同时调整操作系统和 RabbitMQ 参数。

@RabbitListener 是用来绑定队列的，该接收者绑定了 OneByOne 这个队列，

下面的@RabbitHandler 注解是用来表示该方法是接收者接收消息的方法。

## 7. 消息丢失及解决方案

1. 生产者丢失消息，producer 将数据发送到 rabbitmq 的时候，可能因为网络问题导致数据在半路给搞丢了
   - 使用事务（性能差），使用通道 channel 的方法设置事务；
   - 发送回执确认（推荐），confirm 模式，
   -
