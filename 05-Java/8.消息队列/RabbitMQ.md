# RabbitMQ

[RabbitMQ 设计文档](../public/package/Rabbitmq%E8%AE%BE%E8%AE%A1%E6%96%87%E6%A1%A3.docx)

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

## 3. RabbitMQ 消息模型

RabbitMQ 提供了 7 种消息模型。第 6 种是 RPC 拉取方式，基本不用，因此不予学习；第 7 种是新出的发布者确认模式；3、4、5 这三种都属于订阅模型，只不过进行路由的方式不同。

### 3.1 Simple 模型

最简单的消息模式，使用的是默认交换机。

<img name="Hello World" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-helloworld.png" witdh= "60%" height="150px">

### 3.2 Work 模型

多个消费者绑定到一个队列，共同消费队列中的消息；队列中的消息一旦消费，就会消失，每个消费者获取到的消息唯一，使用的也是默认交换机。

<img name="Work Queues" src="https://xiaoliangzong.github.io/document/public/images/Rabbitmq-work.png" witdh= "60%" height="150px">

可能出现的两个问题：

1. 队列中的数据，默认会平均分发给每个消费者，也就是将所有消息以轮询的方法交给消费者消费；如果有的消费者处理能力很差，就会导致有些消息分发给低能消费者，低能消费者不能及时处理，导致消息处理很慢；
2. MQ 默认使用自动确认机制，只要消费者从队列中获取了消息，无论是否消费成功，都认为消息已经被消费，队列会把该消息数据删掉；如果消费者消费时遇到异常时（比如宕机、重启等），消息就会丢失。

<div style="color:red">

在实际使用过程中，通过同一时刻 MQ 只会发一条消息给消费者来解决第一个问题，从而达到能者多劳的效果，处理消息能力强的消费者获取更多的消息；通过手动确认的方式来解决第二个问题，保证数据的不丢失。[详细在后边章节 消费者手动应答会讲](#_44-消费者手动应答)</div>

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

## 4. 消息可靠性保障策略

1. 生产者开启消息确认机制（confirm、return 机制）
2. 消息队列、数据持久化
3. 消费者手动 ack
4. 生产者消息记录+定期补偿机制
5. 服务幂等处理（乐观锁机制）
6. 消息挤压处理等

```yml
spring:
  rabbitmq:
    host: localhost
    port: 5672
    username: admin
    password: Fengpin@123
    # 虚拟主机
    virtual-host: /
    # 开启confirm机制，默认为none，correlated表示使用CorrelationData将确认与发送的消息关联起来；simple不常用
    publisher-confirm-type: correlated
    # 开启return机制，默认为false，也可以通过 rabbitTemplate.setMandatory(true); 或spring.rabbitmq.template.mandatory=true 配置
    publisher-returns: true
    template:
      # Mandatory为true时，消息通过交换器无法匹配到队列会返回给生产者并触发MessageReturn，为false时，匹配不到会直接被丢弃
      # spring.rabbitmq.template.mandatory属性的优先级高于spring.rabbitmq.publisher-returns的优先级
      # spring.rabbitmq.template.mandatory属性可能会返回三种值null、false、true，如果不配置则为null
      # spring.rabbitmq.template.mandatory结果为true、false时会忽略掉spring.rabbitmq.publisher-returns属性的值
      # spring.rabbitmq.template.mandatory结果为null（即不配置）时结果由spring.rabbitmq.publisher-returns确定
      mandatory: true
    listener:
      # 监听类型
      type: simple
      simple:
        acknowledge-mode: manual # 开启手动ack确认消息
        # 说明：如果一个消费者配置prefetch=10，concurrency=2，则开启2个线程去消费消息，每个线程都会抓取10个线程到内存中（注意不是两个线程去共享内存中抓取的消息）。
        concurrency: 1 # 消费端监听器调用程序线程的最小个数（即每个@RabbitListener开启几个线程去处理数据），该参数也可以通过设置注解的属性完成
        max-concurrency: 10 # 消费者的监听最大个数
        prefetch: 10 # 每个消费者最多可处理的nack消息数量，默认值以前是1，这可能会导致高效使用者的利用率不足。从spring-amqp 2.0版开始，默认的prefetch值是250，这将使消费者在大多数常见场景中保持忙碌，从而提高吞吐量。
        retry:
          enabled: false # 开启重试机制
          max-attempts: 3 # 最大重试传递次数
          initial-interval: 5000 # 第一次和第二次尝试传递消息的间隔时间，单位毫秒
          max-interval: 300000 # 最大重试时间间隔，单位毫秒
          multiplier: 3 # 应用前一次重试间隔的乘法器，默认为1
        # 重试次数超过上面的设置之后是否丢弃（消费者listener抛出异常，是否重回队列，默认true， false为不重回队列（结合死信交换机））
        default-requeue-rejected: true
```

### 4.1 confirm

confirm 机制，只保证消息到达 exchange，并不保证消息可以路由到 queue。生产者投递消息之后，如果 Broker 收到消息，则会给生产者一个应答，生产者能接收应答，用来确定这条消息是否正常的发送到 Broker，这种机制是消息可靠性投递的核心保障。

使用 confirm 机制时，发送消息时最好把 CorrelationData 加上，因为如果出错了，使用 CorrelationData 可以更快的定位到错误信息

```java

// 配置 confirm 机制
private final RabbitTemplate.ConfirmCallback confirmCallback = new RabbitTemplate.ConfirmCallback() {

    /**
     * 消息生产者发送消息至交换机时触发，用于判断交换机是否成功收到消息
     *
     * @param correlationData correlation data for the callback. 相关配置信息，一般用于获取唯一标识 id
     * @param ack             true for ack, false for nack 判断交换机是否成功收到消息
     * @param cause           An optional cause, for nack, when available, otherwise null. 失败原因
     */
    @Override
    public void confirm(CorrelationData correlationData, boolean ack, String cause) {
        log.info("confirm ack: {}, cause: {}, correlationData: {}", ack, cause, correlationData);
        if (!ack) {
            // 交换机没有接收到消息
            log.error("confirm ack false, cause: {}", cause);
            // TODO 失败时，需要做的操作！！！
        }
    }
};
```

### 4.2 return

return 机制，只有成功到达了交换机且未到达队列才会触发回调函数。

```java
// 配置 return 消息机制
private final RabbitTemplate.ReturnCallback returnCallback = new RabbitTemplate.ReturnsCallback() {
    /**
     * 交换机并未将数据丢入指定的队列中时，触发
     * channel.basicPublish(exchange_name, next.getKey(), true, properties, next.getValue().getBytes());
     * 参数三：true  表示如果消息无法正常投递，则return给生产者 ；false 表示直接丢弃
     *
     * @param returned the returned message and metadata.
     */
    @Override
    public void returnedMessage(ReturnedMessage returned) {
        // 消息对象
        Message message = returned.getMessage();
        // 错误码
        int replyCode = returned.getReplyCode();
        // 错误信息
        String replyText = returned.getReplyText();
        // 交换机
        String exchange = returned.getExchange();
        // 路由键
        String routingKey = returned.getRoutingKey();
        log.error("returnedMessage, exchange: {}, routingKey: {}", exchange, routingKey);
        log.error("returnedMessage, replyCode: {}, replayText: {}", replyCode, replyText);
    }
};

```

### 4.3 持久化

RabbitMQ 的持久化有交换机、队列、消息的持久化。用于防止服务器宕机重启之后数据的丢失，其中交换机和队列的持久化都是设置 durable 参数为 true，消息的持久化是设置 Properties 为 MessageProperties.PERSITANT_TEXT_PLAIN，消息的持久化基于队列的持久化。持久化不是 100%完全保证消息的可靠性。

1. 交换机 exchange 持久化，RabbitMQ 服务重启之后，交换机不会消失，默认是不持久化的；
2. 队列 Queue 持久化，和交换机类似；
3. 消息持久化，是指当消息从交换机发送到队列之后，被消费者消费之前，服务器突然宕机重启，消息仍然存在。消息持久化的前提是队列持久化，假如队列不是持久化，那么消息的持久化毫无意义。其中 MessageProperties.PERSISTENT_TEXT_PLAIN 是设置持久化的参数，原 API 中 deliveryMode 是设置消息持久化的参数，等于 1 不设置持久化，等于 2 设置持久化。PERSISTENT_TEXT_PLAIN 是实例化的一个 deliveryMode=2 的对象，便于编程。

### 4.4 消费者手动应答

手动确认机制：防止消息在消费中出现异常情况，mq 把消息自动删除；消费者从队列获取消息后，MQ 服务器会将该消息标记为不可用（Unacked），等待消费者反馈。如果一直没有反馈，则一直为不可用状态，该消息不会被删除也不能被消费，当出现 Unacked 的消息时，只需要断开连接或重启 RabbitMQ，被标记 Unacked 状态的消息就会重新变为 Ready 状态。

```java
/*
   底层实现的方式
   该值定义通道上允许的未确认消息的最大数量，一旦数量达到配置的数量，RabbitMQ 将停止在通道上传递更多消息，除非至少有一个未处理的消息被确认。
   每次都从队列里拿一个消息进行消费，消费完成再从队列里获取另一个消息进行消费，这行代码就是实现能者多劳的效果。如果不写的话队列就会一股脑的把消息平均分配给所有消费者，那么就不能实现能者多劳的效果
*/
channel.basicQos(1);

// SpringBoot中通过配置yaml可以实现公平分发

//    @RabbitListener(queues = "test.queue", concurrency = "1", exclusive = true)      // 配置exclusive参数，表示消费者是否具有对队列的独占访问权限。如果为true，则容器的并发性concurrency必须为1
@RabbitListener(queues = "test.queue", concurrency = "1")
public void receiver(Channel channel, Object obj, Message message) throws IOException {
   log.info("Message start processing, message: {}", obj);
   try {
      // TODO 调用业务
      Thread.sleep(5000);
//            int a = 1/0;
      channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);
   } catch (Exception e) {
      Boolean redelivered = message.getMessageProperties().getRedelivered();
      if (redelivered) {
            // 消息已重复处理失败，拒绝再次接收
            log.error("The message has failed to be duplicated");
            channel.basicReject(message.getMessageProperties().getDeliveryTag(), false);
      } else {
            // 消费该消息失败，即将再次返回队列处理
            log.error("An unexpected error occurred in message processing");
            channel.basicNack(message.getMessageProperties().getDeliveryTag(), false, true);
      }
   }
}


// 手动确认机制包括 basicAck、basicNack、basicReject、basicRecover
/*
   肯定确认
   参数1 - deliveryTag对应的消息，用来确认队列中哪个具体消息；
   参数2 - 表示是否应用于多消息，即是否开启多个消息同时确认；
      多消息的解释：因为发送过程是异步的，因此存在多个消息未处理的场景；
      比如现在有多条消息去调用这个nack方法，他的执行有个先后顺序，就是调用nack时，之前所有没有ack的消息都会被标记为nack，多条消息同时调用，
      则调用的这个语句执行前如果还有未执行回复确认的消息就会被回复nack，后续的消息回复nack可能只作用于当条消息。
*/
channel.basicAck(message.getMessageProperties().getDeliveryTag(), false);

/*
   参数1 - deliveryTag对应的消息，用来确认队列中哪个具体消息；
   参数2 - requeue，表示是否重新入队列；false-丢弃或进入死信队列，true-重新入队列，消费者还是会消费到这个消息，如果没有其他消费者监控这个queue的话，要注意一直无限循环发送的危险。
*/
channel.basicReject(message.getMessageProperties().getDeliveryTag(), false);

/*
   参数1 - deliveryTag对应的消息，用来确认队列中哪个具体消息；
   参数2 - 表示是否应用于多消息，即是否开启多个消息同时确认；
   参数3 - requeue，表示是否重新入队列；false-丢弃或进入死信队列，true-重新入队列，消费者还是会消费到这个消息；
   与basciReject区别就是同时支持多个消息
*/
log.error("消息即将再次返回队列处理...");
channel.basicNack(message.getMessageProperties().getDeliveryTag(), false, true);

/*
   恢复消息到队列
   参数requeue表示是否重新入队列，true则重新入队列，并且尽可能的将之前recover的消息投递给其他消费者消费，而不是自己再次消费，false则消息会重新被投递给自己。
*/
channel.basicRecover(true);
```

**消费者注解 @RabbitListener**

1. @RabbitListener 注解是指定某方法作为消息消费的方法，例如监听某 Queue 里面的消息，接受的参数需要和发送者的类型一致；
2. @RabbitListener 可以标注在类上面，需配合 @RabbitHandler 注解一起使用，标识当有收到消息的时候，就交给@RabbitHandler 的方法处理。

## 6. TTL 队列

TTL 队列（Time To Live），也叫过期队列，是指声明队列时指定了过期时间 ttl，消息存入队列开始计算，只要超过配置的时间，消息就会自动删除。

```java
@Bean
public Queue ttlQueue(){
   Map<String, Object> args = new HashMap<>();
   args.put("x-message-ttl", 5000);  // 单位毫秒
   return new Queue("ttl.queue", true, false, false, args);
}
```

如果只给某个消息设置过期时间，而不是给队列设置，可以通过 MessagePostProcessor 对象的属性赋值

如果两种都设置了，以小的 ttl 为准。这两种都可以设置过期时间，但设置消息过期消失就没有了，而 ttl 队列可以增加通用处理逻辑，比如将其存放到私信队列。

```java
//发送消息
final String uuid = UUID.randomUUID().toString();     // 唯一标识，用于confirm消息确认失败时的快速定位
// 设置消息的参数：比如过期时间、编码等
 MessagePostProcessor messagePostProcessor = message -> {
      message.getMessageProperties().setExpiration("20000");
      return message;
};
amqpTemplate.convertAndSend(RabbitConfig.EXCHANGE_DIRECT, RabbitConfig.ROUNTING_KEY_PUBLISH, msg, messagePostProcessor, new CorrelationData(uuid));
```

<span style="color:red">消息设置过期时间，等到消息投递给消费者的时候，才会判断是否过期，这种方法感觉不太对，如果没有消费者呢？？？</span>  
queue 的全局 ttl，消息过期立刻就会被删掉；如果是发送消息时设置的 ttl，过期之后并不会立刻删掉，这时候消息是否过期是需要投递给消费者的时候判断的。

原因：queue 的全局 ttl，队列的有效期都一样，先入队列的队列头部，头部也是最早过期的消息，rabbitmq 会有一个定时任务从队列的头部开始扫描是否有过期消息即可。而每条设置不同的 ttl，只有遍历整个队列才可以筛选出来过期的消息，这样的效率实在是太低，而且如果消息量大了根本不可行，所以 rabbitmq 在等到消息投递给消费者的时候判断当前消息是否过期，虽然删除的不及时但是不影响功能。

## 7. 死信队列

DLX（Dead-Letter-Exchange），也可以称为死信交换机，当一条消息在队列中变成死信（Dead Message），它能够被重新发送到另一个 Exchange 中，则这个 Exchange 就是 DLX，绑定 DLX 的队列称为死信队列 。

DLX 可以在任何队列上被指定，实际上就是设置一个属性 x-dead-letter-exchange，当队列中存在死信时，mq 会自动将该消息重新发送到设置的 DXL 上，进而被路由到死信队列。死信队列的消费者监听消息做补偿处理。常见的使用场景就是延迟关单，比如下单 15 分钟没有支付订单关闭。

消息变成死信，可能原因是：

- 消息被拒绝（basic.reject/basic.nack,&&requeue=false（不重新回队列））
- 消息过期
- 队列达到最大长度（mex-length）

message -> exchange -> queue（有消息变成死信） -> 死信消息重新发布到绑定的 DLX 上 -> queue

## 8. 常用配置

1. x-priority: basic.consume 方法参数(int)。用于设定 consumer 的优先级，数字越大，优先级越高，默认是 0，可以设置负数。
2. alternate-exchange: exchange.declare 方法参数(str，AE 的名称)。当一个消息不能被 route 的时候，如果 exchange 设定了 AE，则消息会被投递到 AE。如果存在 AE 链，则会按此继续投递，直到消息被 route 或 AE 链结束或遇到已经尝试 route 过消息的 AE。
3. x-message-ttl: queue.declare 方法参数(毫秒，非负整数)，用于限定 queue 上消息的生存时间，可配合 DLX。
4. x-expires:queue.declare 方法参数(毫秒，正整数)，用于限定 queue 自身的生存时间。
5. x-dead-letter-exchange: queue.declare 方法参数(str，DLX 的名称)。
6. x-dead-letter-routing-key: queue.declare 方法参数(str，DLX 的 route)。不设定则使用 message 自身的 route。
7. x-max-length: queue.declare 方法参数(非负整数)。用于限制 queue 的最大 ready 消息总数。
8. x-max-length-bytes: queue.declare 方法参数(非负整数)。用于限制 queue 的最大 ready 消息的 body 总字节数。两种限制可同时设置，最先到达的限制条件将被生效。
9. x-max-priority: queue.declare 方法参数(int)。rabbitmq3.5.0 版本后支持优先队列。由于优先队列是一种特殊的持久化方式，使得优先队列只能通过 arguments 的方式声明，且声明后不可改变其支持的 priorities。

   对每一个优先队列的每一个优先级在内存、磁盘都有单独的开销；及额外的 CPU 开销，特别是在 consume 的时候。  
   通过在 message 的 basic.properties 中指明 priority(unsigned byte, 0-255)，较大的数对应较高的优先级。若未指明 message 的 priority 则 priority 默认为 0。  
   若 message 的 priority 大于 queue 的 maximum priority 则 priority 被认为是 maximum priority。  
   对于优先队列，有如下注意事项：

   - 由于默认情况下 consumer 的预取消息，消息可能会立即被投递给 consumer，而导致优先级关系不能被处理。因而需要在 ack 模式下设定 basic.qos 的 prefetch_count,限制消息的投递。
   - 如果优先队列设置了 message-ttl，则由于 server 的 ttl 清理是从 head 方向检测处理的，低优先级的过期消息可能会一直存在而无法被清理，且会被统计(如 ready 的消息数，但不会被 deliver)。
   - 如果优先队列设置了 max-length，则由于 server 从 head 方向 drop 消息以使限制生效，使得高优先级的消息被 drop 掉，而预留位置给低优先级的消息，可能和使用优先队列的初衷背离。

10. user-id：channel.basicPublish 中指定的 BasicProperties 字段。用于验证 publisher。其值应与建立 connection 的 user 名称一致。  
    若需要伪造验证，user-id 可使用 impersonator tag,但不能使用 administrator tag。  
    federation 从 upstream 收到消息时会丢弃 user-id，除非在 upstream 设置 trust-user-id 属性。
11. authentication_failure_close: broker capability. 用于 client 区分鉴权错误还是网络错误，在 AMQP091 中要求鉴权失败则 broker 关闭连接，以至于 client 无法区分于实际的网络连接错误。  
    当开启这个设置时，broker 在鉴权失败后向客户端发送 connection.close 的命令并附带 ACCESS_REFUSED 的原因标识。
