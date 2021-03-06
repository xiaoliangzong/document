##### 一. 微服务和 SOA

###### 1. SOA 面向服务的架构 Service Oriented Ambiguity

> 是一种架构设计模式，一种设计方法，问题解决方法，其中包含多个服务，而服务之间通过配合，最终会提供一系列功能，一个服务通过以独立的形式存在于操作系统进程中，服务之间通过网络调用，而非采用进程内调用的方法进行通信。

> 一种粗粒度、松耦合服务架构，服务之间通过简单、精确定义接口进行通讯，不涉及底层编程接口和通讯模型。

ESB - 企业服务总线，ESB 就是一根管道，用来连接各个服务节点。为了集成不同系统，不同协议的服务，ESB 做了消息的转化解释和路由工作，让不同的服务互联互通；

- 特点：
  - 系统集成：系统角度，通过 ESB，解决企业系统间的通信问题。
  - 系统服务化：功能角度，把业务逻辑抽象成可复用、可组装的服务
  - 业务服务化：企业角度，把一个业务单独封装成一项服务，提升企业对外服务能力。

###### 2. 微服务架构

> 是在 SOA 上做的升华，微服务架构强调的一个重点是"业务需要彻底的组件化和服务化"，原有的单个业务系统会拆分为多个可以独立开发、设计、运行的小应用。这些小应用之间通过服务完成交互和集成

- 特点
  - 服务实现组件化
  - 按业务能力划分服务和开发团队
  - 去中心化
  - 基础设施自动化

###### 3. 区别

1. 相同点
   - 两者都是为了处理复杂架构而出现的分布式系统，都需要系统直接的通信协调

##### 二. 系统架构的演进

1. 单体应用架构：web 应用程序，所有的功能集成到一个工程；然后打包到一个 web 容器中运行。项目架构简单，前期开发成本低，周期短，小型项目首选。
   - 缺点：
     - 代码耦合性高，维护困难；
     - 无法针对不同模块进行针对性优化；
     - 无法水平扩展；单点容错率低，并发能力差
2. 垂直应用架构：当访问量逐渐增大，单一应用无法满足需求，此时为了应对更高的并发和业务需求，我们根据业务功能对系统进行拆分
   - 优点：
     - 系统拆分实现了流量分担，解决了并发问题
     - 可以针对不同模块进行优化
     - 方便水平扩展，负载均衡，容量率高
     - 系统间相互独立
   - 缺点：
     - 服务之间相互调用，如果某个服务的端口或者 ip 地址发生改变，调用的系统得手动改变
     - 搭建集群之后，实现负载均衡比较复杂
3. SOA，面向服务的架构：eSight 云化版本 就是基于 SOA 架构体系。
4. 微服务：将业务彻底的组件化和服务化，原有的单个业务系统会拆分为多个可以独立开发、设计、运行的小应用。

##### 三. 组件

1. 服务注册与发现：
   - Eureka
   - Zeekeeper，和 dubbo 一起使用；是一个分布式服务框架，是 Apache Hadoop 的一个子项目
   - consul(kangsu)，go 语言编写的，不推荐使用
   - nacos，阿里的，不光可以提供服务注册与发现，也可以作为配置中心。
2. 服务调用：
   - Ribbon，通过@LoadBalance 注解标注 RestTemplate，实现服务的调用；另一个特点就是实现负载均衡，从一个服务的多台机器中选择一台
   - LoadBalancer，新技术，还未成熟
   - Feign，基于动态代理机制，根据注解和选择的机器，拼接请求 url 地址，发送请求
   - OpenFeign，OpenFeign 是 spring cloud 在 Feign 的基础上支持了 SpringMVC 的注解
3. 服务容错组件：
   - Hystrix
   - resilience4j，国外使用的
   - Sentinel，阿里的，实现熔断和限流
4. 服务网关
   - Zuul
   - Zuul2
   - Gateway
   - Nginx+lua 实现： 基于 Nginx+Lua 开发，性能高，稳定，有多个可用的插件(限流、鉴权等等)可以开箱即用。
5. 服务配置
   - config
   - apolo（阿波罗）
   - nacos 是一个更易于构建云原生应用的动态服务发现，配置管理和服务 Nacos = Eureka + Config
6. 服务总线
   - bus
   - nacos

##### 四. 分类

1. spring cloud netflix 中的组件：Eureka、Ribbon、Feign、Hystrix、Zuul
2. spring cloud 原生及其他组件：Consul、Config、GateWay、Sleuth/Zipkin
3. spring cloud alibaba 中的组件：Nacos、Sentinel、
4. spring cloud 其他组件：Consul

Zookeeper
ZooKeeper 是一个分布式的，开放源码的分布式应用程序协调服务，是 Google 的 Chubby 一个开源的实
现，是 Hadoop 和 Hbase 的重要组件。它是一个为分布式应用提供一致性服务的软件，提供的功能包
括：配置维护、域名服务、分布式同步、组服务等。
Consul
consul 是近几年比较流行的服务发现工具，工作中用到，简单了解一下。consul 的三个主要应用场景：
服务发现、服务隔离、服务配置。
Nacos
Nacos 是阿里巴巴推出来的一个新开源项目，这是一个更易于构建云原生应用的动态服务发现、配置管
理和服务管理平台。Nacos 致力于帮助您发现、配置和管理微服务。Nacos 提供了一组简单易用的特性
集，帮助您快速实现动态服务发现、服务配置、服务元数据及流量管理。Nacos 帮助您更敏捷和容易地
构建、交付和管理微服务平台。 Nacos 是构建以“服务”为中心的现代应用架构 (例如微服务范式、云原
生范式) 的服务基础设施。

##### 五. restful 与 rpc

1. RPC： Remote Procedure Call、远程过程调用，是一种通过网络从远程计算机程序上请求服务，而不需要了解底层网络技术的协议。
2. Restful：是一种软件架构风格，设计风格，而不是标准，只是提供了一组设计原则和约束条件，主要用于客户端和服务器交互类的软件。通过 http 协议中的 post、get、put、delete 等方法和一个可读性强的 url 提供一个 http 请求。

   - 面向资源。通过 url 将资源暴露出来；与资源的操作无关，操作通过该 http 动词来体现。比如 get /rest/api/getDogs => get /rest/api/dogs
   - rest 利用 http 本身的就有的一些特性。比如 http 状态码，http 报头
     200 OK
     400 Bad Request 客服端错误，前端调用的问题
     500 Internal Server Error 服务器错误，后端代码问题

3. 区别：

   - restful 是基于 http。而 rpc 则不一定通过 http，更常用的是使用 TCP 来实现。RPC 可以获得更好的性能（省去了 HTTP 报头等一系列东西）,TCP 更加高效，而 HTTP 在实际应用中更加的灵活。
   - restfull 和 rpc 都是 client/server 模式的，都是在 Server 端 把一个个函数封装成接口暴露出去
   - 从使用上来说：Http 接口只关注服务提供方（服务端），对于客户端怎么调用，调用方式怎样并不关心；而 RPC 服务则需要客户端接口与服务端保持一致，服务端提供一个方法，客户端通过接口直接发起调用。
   - restful 采用标准的数据格式，异构的客户端与服务器通信方便；RPC 整个请求的方法对客户端不可见，异构的客户端与服务器通信比较难；
