# RabbitMQ

## 1. 安装

**Windows**

- 安装语言 erlang
- 安装 mq
- 安装插件 rabbitmq-plugins.bat enable rabbitmq_management
- rabbitmqctl status 查看状态
- rabbitmq-server.bat 启动命令

**Linux**

**Docker**

## 2. 核心组件

### 2.1 交换器

RabbitMQ 的 Exchange 有四种类型，不同的类型对应着不同的路由策略：direct（默认）、fanout、topic、headers

生成者将消息发给交换器的时候，一般都会指定一个路由键 RoutingKey，用来指定这个消息的路由规则，而这个 RoutingKey 需要与交换器类型和绑定键 BindingKey 联合使用才能最终生效。
RabbitMQ 中通过 Binding(绑定) 将 Exchange(交换器) 与 Queue(消息队列) 关联起来，在绑定的时候一般会指定一个绑定键 BindingKey，这样 RabbitMQ 就知道如何正确将消息路由到队列了。

Exchange 和 Queue 的绑定可以是多对多的关系。

**Direct**

直连交换机，表示此交换机需要绑定一个队列，要求该消息与一个特定的路由键完全匹配。简单说就是点对点的发送

**Fanout**

**Topic**

**Headers**
