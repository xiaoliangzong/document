# RabbitMQ

## 1. 安装

**Windows**
如果以前安装过，则需要卸载 rabbitmq 和 erlang，erlang 必须卸载，否则会导致安装失败。

```shell
# 1.安装语言 erlang
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
   - rabbitmqctl set_user_tags admin administrator       # 给用户添加角色，超级管理员(administrator)，监控者(monitoring)，策略制定者(policymaker)，普通管理者(management)
   - rabbitmqctl set_permissions -p / User ".*" ".*" ".*"     # 授权，-p  VHostPath  User  ConfP  WriteP  ReadP
   - rabbitmqctl change_password guest xxx               # 更改 guest 密码
   - rabbitmqctl delete_user guset                       # 删除 guest 用户
   - rabbitmqctl list_users                              # 查看已有用户及用户角色
   - rabbitmqctl list_permissions [-p VhostPath]         # 查看(指定hostpath)所有用户的权限信息
   - rabbitmqctl list_user_permissions User              # 查看指定用户的权限信息
   - rabbitmqctl clear_permissions [-p VHostPath]  User  # 清除用户的权限信息
```

**Linux**

**Docker**

## 2. RabbitMQ 消息模型

RabbitMQ 提供了 6 种消息模型，但是第 6 种其实是 RPC，并不是 MQ，因此不予学习。那么也就剩下 5 种。但是其实 3、4、5 这三种都属于订阅模型，只不过进行路由的方式不同。

## 2.1 基本模型

顾名思义，你可以把它理解为所有模式的雏形，最简单的消息模式，使用的是默认交换机。

## 2.2 work 模型

多个消费者绑定到一个队列，共同消费队列中的消息。队列中的消息一旦消费，就会消失，因此任务是不会被重复执行的，使用的也是默认交换机。

`注意：`

`因为队列中的数据，默认会平均分发给每个消费者，但是如果有的消费者处理能力很差，就会导致有些消息分发给低能消费者，低能消费者不能及时处理，导致消息处理很慢。`

```java
// 每次都从队列里拿一个消息进行消费，消费完成再从队列里获取另一个消息进行消费，这行代码就是实现能者多劳的效果。如果不写的话队列就会一股脑的把消息平均分配给所有消费者，那么就不能实现能者多劳的效果
channel.basicQos(1);
// 手动确认，防止消息还没有消费完成，mq把消息自动删除
// 参数：确认队列中哪个具体消息、是否开启多个消息同时确认
channel.basicAck(envelope.getDeliveryTag(), false);
```

## 2.3 发布订阅模型（Fanout）

交换机和列队直接绑定，不需要指定 routingkey，所以他的消息传输速度是发布订阅模式中最快的。

## 2.4 发布订阅模型（Direct）

与 fanout 模式相比，direct 模式需要 RoutingKey 将队列和交换机绑定

## 2.4 发布订阅模型（Topic）

与之前的两种模式相比，区别在于：它可以通过 RoutingKey，将交换机和队列机进行模糊匹配绑定

- \*，有且只匹配一个词
- #，匹配一个或多个词

## 3. API

RabbitMQ Java 客户端使用 com.rabbitmq.client 作为它的顶级包。关键的类和接口有：

- Channel: 代表 AMQP 0-9-1 通道，并提供了大多数操作（协议方法）。
- Connection: 代表 AMQP 0-9-1 连接
- ConnectionFactory: 构建 Connection 实例
- Consumer: 代表消息的消费者
- DefaultConsumer: 消费者通用的基类
- BasicProperties: 消息的属性（元信息）
- BasicProperties.Builder: BasicProperties 的构建器

通过 Channel（通道）的接口可以对协议进行操作。Connection（连接）用于开启通道，注册连接的生命周期内的处理事件，并且关闭不再需要的连接。ConnectionFactory 用于实例化 Connection 对象，并且可以通过 ConnectionFactory 来进行诸如 vhost、username 等属性的设置。

RabbitTemplate 发送方式

- send()，不会对消息进行转换，传递进去是什么消息，就会往 RabbitMQ Server 中发送什么消息；
- convertAndSend()，会将传递进去的消息进行转换，并将转换过后的消息发送到 RabbitMQ Server 中；输出时没有顺序，交换机会马上把所有的信息都交给所有的消费者，消费者再自行处理，不会因为消费者处理慢而阻塞线程。
- convertSendAndReceive()，使用此方法，只有确定消费者接收到消息，才会发送下一条信息，每条消息之间会有间隔时间

## 4. 消息确认机制 confirm

## 5. return 机制

## 6. TTL 队列、死信队列

在 RabbitMQ 中，Socket descriptors 是 File descriptors 的子集，它们也是一对此消彼长的关系。然而，它们的默认配额并不大，File descriptors 默认值为“1024”，而 Socket descriptors 的默认值也只有“829”，同时，File descriptors 所能打开的最大文件数也受限于操作系统的配额。因此，如果要调整 File descriptors 文件句柄数，就需要同时调整操作系统和 RabbitMQ 参数。

@RabbitListener 是用来绑定队列的，该接收者绑定了 OneByOne 这个队列，

下面的@RabbitHandler 注解是用来表示该方法是接收者接收消息的方法。

## 7. 消息丢失及解决方案

1. 生产者丢失消息，producer 将数据发送到 rabbitmq 的时候，可能因为网络问题导致数据在半路给搞丢了
   - 使用事务（性能差），使用通道 channel 的方法设置事务；
   - 发送回执确认（推荐），confirm 模式
   -
