# spring cloud 组件

## 一、Eureka

### 1. 依赖

```xml
<!-- eureka server 注册中心-->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-server</artifactId>
</dependency>
<!-- eureka client -->
<dependency>
    <groupId>org.springframework.cloud</groupId>
    <artifactId>spring-cloud-starter-netflix-eureka-client</artifactId>
</dependency>
```

### 2. 配置

```yaml
# ~~~~~~~~~~~~~~~~~~~~~~Eureka Server 注册中心配置~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 服务端口
server:
  port: 8077
# 服务名称
spring:
  application:
    name: eureka-server
# 服务地址
eureka:
  instance:
    hostname: localhost
  client:
    # 不向注册中心注册自己，默认为true
    register-with-eureka: false
    # 取消检索服务，不从eureka中获取注册信息，默认为true
    fetch-registry: false
    # 注册中心路径，如果有多个eureka server，在这里需要配置其他eureka server的地址，用","进行区分
    service-url:
      default-zone: http://${eureka.instance.hostname}:${server.port}/eureka
  server:
    # 开启注册中心的保护机制，默认是开启
    enable-self-preservation: true
    # 设置保护机制的阈值，默认是0.85。
    renewal-percent-threshold: 0.5
    # 剔除服务间隔时间4s
    eviction-interval-timer-in-ms: 4000


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~Eureka Client 服务提供消费者配置~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 服务端口
server:
  port=7001
# 服务名称
spring:
  application:
    name: user
# 服务地址
eureka:
  instance:
    hostname: localhost
    #心跳间隔5s，默认30s。每一个服务配置后，心跳间隔和心跳超时时间会被保存在server端，不同服务的心跳频率可能不同，server端会根据保存的配置来分别探活
    lease-renewal-interval-in-seconds: 5
    #心跳超时时间10s，默认90s。从client端最后一次发出心跳后，达到这个时间没有再次发出心跳，表示服务不可用，将它的实例从注册中心移除
    lease-expiration-duration-in-seconds: 10
    #使用ip地址进行注册
    prefer-ip-address: true
    #使用ip+端口展示，向注册中心注册服务id
    instance-id: ${spring.cloud.client.ip-address}:${server.port}
  # 注册中心路径，表示我们向这个注册中心注册服务，如果向多个注册中心注册，用“，”进行分隔
  client:
    serviceUrl:
      defaultZone: http://localhost:8077/eureka
```

### 3. 启动类增加注解：@EnableEurekaServer、@EnableEurekaClient

### 4. 服务消费者通过元数据获取提供者的信息，实战不这样用，可以使用 openfeign 来实现服务调用

```java
@AutoWired
private DiscoveryClient discoveryClient

public Dto getAll(){
  List<ServiceInstance> instances = discoveryClient.getInstances("xxxx");
}
```

### 5. Eureka 集群

> 只需要增加微服务，然后再配置中 defaultZone 中相互注册其他的地址。

### 6. Eureka 自我保护机制

> 默认开启，可以自定义配置。
> 15min 之内的心跳次数，是否低于百分之 85

## 二、 Ribbon 服务调用和负载均衡

1. 服务调用：通过服务名和 restTemplate 调用，这种方法比较繁琐，后边使用 feign 的方式。
2. 负载均衡：是一个典型的客户端负载均衡器，Ribbon 会获取服务的所有地址，根据内部的负载均衡算法，获取本次请求的有效地址

> 多个微服务的提供者（生产者集群）：Ribbon 提供了客户端负载均衡的功能，Ribbon 自动的从注册中心中获取服务提供者的列表信息，并基于内置的负载均衡算法（IRule 接口），请求服务。

3. 步骤：
   - 无需导入依赖，spring-cloud-starter-netflix-eureka-client 中包含 ribbon 的依赖
   - 在创建 RestTemplate 的时候，声明 @LoadBalanced
   - 使用 RestTemplate 调用远程微服务，不需要拼接微服务的 URL，用服务名替换 IP:port 地址
   - ribbon 负载均衡策略配置：服务名.ribbon.NFLoadBanlancer.NFLoadBalancerRuleClassName=com.netflix.loadbalancer.RandomRule

## 三、 Feign 和 OpenFeign

`Feign 内置了 Ribbon 和 Hystrix`

> `OpenFeign是springcloud在Feign的基础上支持了SpringMVC的注解，如@RequestMapping等等。OpenFeign的@FeignClient可以解析SpringMVC的@RequestMapping注解下的接口，并通过动态代理的方式产生实现类，实现类中做负载均衡并调用其他服务。`
>
> `Feign 是 Springcloud 组件中的一个轻量级 Restful 的 HTTP 服务客户端，netflix 的声明式、模板化的 HTTP 客户端，Feign 内置了 Ribbon，用来做客户端负载均衡，去调用服务注册中心的服务。Feign 的使用方式是：使用 Feign 的注解定义接口，调用这个接口，就可以调用服务注册中心的服务`

### 3.1 openfeign 服务调用：简化 Ribbon 操作，采用注解+接口的方式来实现

- 添加依赖：spring-cloud-starter-openfeign
- 在启动类中添加@EnableFeignClients
- 在服务调用侧，编写接口，在接口上使用注解@FeignClient(name="服务名")，方法上使用@RequestMapping(value="请求路径"，method=RequestMethod.GET)
  `可以通过 ribbon.xx 来进行全局配置。也可以通过 服务名.ribbon.xx 来对指定服务配置`

`注意事项：`

1. 在 Feign 中绑定参数必须通过 value 属性来指明具体的参数名，不然会抛出异常； --`经过测试，RequestMapping是必须使用value设置请求路径的，或者使用@GETMapping`
2. @FeignClient 注解通过 name 指定需要调用的微服务的名称，用于创建 Ribbon 的负载均衡器。

## 四、性能问题

> tomcat 会以线程池的形式对所有请求进行统一的管理，对于某个方法可以存在耗时问题的时候，随着外部积压的请求越来越多时，势必会造成系统的崩溃

1. 服务雪崩

   - 当服务调用时，因为网络原因或者自身原因，导致调用服务处于阻塞状态，此时有大量的请求涌入，容器的线程资源会被消耗完毕，导致服务瘫痪。服务与服务之间的依赖性，故障会传播，造成连锁反应，会对整个微服务系统造成灾难性的严重后果，这就是服务故障的“雪崩”效应。
   - 雪崩是系统中的蝴蝶效应导致的，有不合理的容量设计，或是高并发下某一个方法响应变慢，亦或是某台机器的资源耗尽。从源头上我们无法完全杜绝雪崩源头的发生，但是雪崩的根本原因来源于服务之间的强依赖，所以我们可以提前评估，做好熔断，隔离，限流

2. 服务熔断

   - 当下游的服务因为某种原因突然变得不可用或响应过慢，上游服务为了保证自己整体服务的可用性，不再继续调用目标服务，直接返回，快速释放资源。如果目标服务情况好转则恢复调用。
   - 在互联网系统中，当下游服务因访问压力过大而响应变慢或失败，上游服务为了保护系统整体的可用性，可以暂时切断对下游服务的调用。这种牺牲局部，保全整体的措施就叫做熔断。

3. 服务降级

   - 就是当某个服务熔断之后，服务器将不再被调用，此时客户端可以自己准备一个本地的 fallback 回调，返回一个缺省值。 也可以理解为兜底

4. 服务隔离

   - 指将系统按照一定的原则划分为若干个服务模块，各个模块之间相对独立，无强依赖。当有故障发生时，能将问题和影响隔离在某个模块内部，而不扩散风险，不波及其它模块，不影响整体的系统服务。
   - 线程池隔离
   - 信号量隔离

5. 服务限流

   - 限流可以认为服务降级的一种，限流就是限制系统的输入和输出流量已达到保护系统的目的。一般来说系统的吞吐量是可以被测算的，为了保证系统的稳固运行，一旦达到的需要限制的阈值，就需要限制流量并采取少量措施以完成限制流量的目的。比方：推迟解决，拒绝解决，或者部分拒绝解决等等

## 五、Hystrix

> Hystix 的默认超时时长为 1s，如果配合 feign 一起使用，就需要考虑 feign 的超时时间问题，否则不生效！

```yaml
# feign底层是ribbon负载请求，所以默认读的是ribbon的超时配置（如果ribbon超时无效，去检查下feign是不是指定了url，指定url会走默认配置导致ribbon无效）
# 全局配置
ribbon:
  MaxAutoRetries: 3 # 单个服务最大重试次数,不包含对单个服务的第一次请求，默认0
  MaxAutoRetriesNextServer: 2 # 服务切换次数,不包含最初的服务,如果服务注册列表小于 nextServer count 那么会循环请求  A > B >　A，默认1
  OkToRetryOnAllOperations: false # 是否所有操作都进行重试，默认只重试get请求,如果修改为true,则需注意post\put等接口幂等性
  ConnectTimeout: 3000 # 连接超时时间，单位为毫秒，默认2秒
  ReadTimeout: 3000 # 读取的超时时间，单位为毫秒，默认5秒
# 实例配置
clientName:
  ribbon:
    MaxAutoRetries: 5
    MaxAutoRetriesNextServer: 3
    OkToRetryOnAllOperations: false
    ConnectTimeout: 3000
    ReadTimeout: 3000

# feign和ribbon同时存在的话，feign的超时时间生效
feign:
  client:
    config:
      default:
        connectTimeout: 1000
        readTimeout: 8000
  hystrix:
    enabled: true # 默认为false，不开启feign对hystrix的支持
# feign开启了hyxtrix（feign:hyxtrix:enabled =true）的时候，timeoutInMilliseconds和ReadTimeout谁小谁生效
hystrix:
  command:
    default: # default全局有效，service id指定应用有效<serviceName>
      execution:
        timeout:
          enabled: true # 如果enabled设置为false，则请求超时交给ribbon控制,为true,则超时作为熔断根据
        isolation:
          thread:
            timeoutInMilliseconds: 2000 # 断路器超时时间，默认1000ms，如果配置ribbon的重试，hystrix的超时时间要大于ribbon的超时时间，ribbon才会重试
# 为了确保重试机制的正常运作,理论上（以实际情况为准）建议hystrix的超时时间为:(1 + MaxAutoRetries + MaxAutoRetriesNextServer) * ReadTimeout
```

1. 包裹请求：使用 HystrixCommand 包裹对依赖的调用逻辑，每个命令在独立线程中执行。这使用了设计模式中的“命令模式”。
2. 跳闸机制：当某服务的错误率超过一定的阈值时，Hystrix 可以自动或手动跳闸，停止请求该服务一段时间。
3. 资源隔离：Hystrix 为每个依赖都维护了一个小型的线程池（或者信号量）。如果该线程池已满，发往该依赖的请求就被立即拒绝，而不是排队等待，从而加速失败判定。
4. 监控：Hystrix 可以近乎实时地监控运行指标和配置的变化，例如成功、失败、超时、以及被拒绝的请求等。
5. 回退机制：当请求失败、超时、被拒绝，或当断路器打开时，执行回退逻辑。回退逻辑由开发人员
6. 自行提供，例如返回一个缺省值。
7. 自我修复：断路器打开一段时间后，会自动进入“半开”状态

### 5.1 对 Template 的支持

1. 导入依赖：spring-cloud-starter-netflix-hystrix
2. 启动类上启动@EnableCircuitBreaker
3. 增加配置熔断触发的服务降级逻辑
4. 在需要使用的接口上边增加注解@HystrixCommand(fallbackMethod = "fallBack")；或者进行全局设置，在类上增加注解@DefaultProperties(defaultFallback = "")和在方法上使用@HystrixCommand

### 5.2 对 Feign 的支持

1. feign 默认整合了 Hystrix，因此不需要额外导入依赖，
2. 但是默认是关闭的，需要在工程的 application.yml 中开启对 hystrix 的支持，

```yaml
feign:
  hystrix: #在feign中开启hystrix熔断
    enabled: true
```

3. 增加 FeignClient 接口的实现类，在实现类中重写降级方法
4. 修改 FeignClient 添加 hystrix 熔断，在@FeignClient 注解中添加降级方法@FeignClient(name="shop-service-product",fallback = xxx.class)

### 5.3 Hystrix 监控

> 进入降级方法并不意味着断路器已经被打开? ==> `触发降级方法的方式有多种，断路器只是一种`
> 触发降级的方式：
>
> 1. short-circuited 短路：断路器 HystrixCircuitBreaker 已处于打开状态。请求再次进来便直接执行短路逻辑
> 2. threadpool-rejected 线程池拒绝：当线程池满了，再有请求进来时触发此拒绝逻辑
> 3. semaphore-rejected 信号量拒绝：当信号量木有资源了，再有请求进来时触发信号量拒绝逻辑。
> 4. timed-out 超时：当目标方法执行超时，会触发超时的回退逻辑。
> 5. failed 执行失败：command 执行失败，也就是你的 run 方法里执行失败（抛出了运行时异常）时，执行此部分逻辑
>
>    http://localhost:9001/actuator/hystrix.stream

1. 依赖：sprint-boot-starter-actuator、hystrix、hystrix-dashboard
2. 在启动类使用@EnableHystrixDashboard 注解激活仪表盘项目。Hystrix 仪表板可以显示每个断路器（被@HystrixCommand 注解的方法）的状态。

### 5.4 熔断器

熔断器有三个状态 CLOSED 、 OPEN 、 HALF_OPEN；默认关闭状态，当触发熔断后状态变更为 OPEN ,在等待到指定的时间，Hystrix 会放请求检测服务是否开启，这期间熔断器会变为 HALF_OPEN 半开启状态，熔断探测服务可用则继续变更为 CLOSED 关闭熔断器

1. Closed：关闭状态（断路器关闭），所有请求都正常访问。代理类维护了最近调用失败的次数，如果某次调用失败，则使失败次数加 1。如果最近失败次数超过了在给定时间内允许失败的阈值，则代理类切换到断开(Open)状态。此时代理开启了一个超时时钟，当该时钟超过了该时间，则切换到半断开（Half-Open）状态。该超时时间的设定是给了系统一次机会来修正导致调用失败的错误。
2. Open：打开状态（断路器打开），所有请求都会被降级。Hystix 会对请求情况计数，当一定时间内失败请求百分比达到阈值，则触发熔断，断路器会完全关闭。默认失败比例的阈值是 50%，请求次数最少不低于 20 次。
3. Half Open：半开状态，open 状态不是永久的，打开后会进入休眠时间（默认是 5s）。随后断路器会自动进入半开状态。此时会释放 1 次请求通过，若这个请求是健康的，则会关闭断路器，否则继续保持打开，再次进行 5 秒休眠计时。

熔断器的默认触发阈值是 20 次请求，不好触发。休眠时间时 5 秒，时间太短

```yaml
circuitBreaker.requestVolumeThreshold=5     # 触发熔断的最小请求次数，默认20
circuitBreaker.sleepWindowInMilliseconds=10000    # 熔断多少秒后去尝试请求
circuitBreaker.errorThresholdPercentage=50    # 触发熔断的失败请求最小占比，默认50%
```

### 5.5 熔断器的隔离策略

1. 线程池隔离策略：使用一个线程池来存储当前的请求，线程池对请求作处理，设置任务返回处理超时时间，堆积的请求堆积入线程池队列。这种方式需要为每个依赖的服务申请线程池，有一定的资源消耗，好处是可以应对突发流量（流量洪峰来临时，处理不完可将数据存储到线程池队里慢慢处理）
2. 信号量隔离策略：使用一个原子计数器（或信号量）来记录当前有多少个线程在运行，请求来先判断计数器的数值，若超过设置的最大线程个数则丢弃改类型的新请求，若不超过则执行计数操作请求来计数器+1，请求返回计数器-1。这种方式是严格的控制线程且立即返回模式，无法应对突发流量（流量洪峰来临时，处理的线程超过数量，其他的请求会直接返回，不继续去请求依赖的服务）

```yaml
hystrix.command.default.execution.isolation.strategy : 配置隔离策略
ExecutionIsolationStrategy.SEMAPHORE 信号量隔离
ExecutionIsolationStrategy.THREAD 线程池隔离
hystrix.command.default.execution.isolation.maxConcurrentRequests : 最大信号量上限
```

## 6 网关概念

> 如果让客户端直接与各个微服务通讯，存在好多问题：
>
> 1.  客户端会请求多个不同的服务，需要维护不同的请求地址，增加开发难度
> 2.  在某些场景下会存在跨域请求的问题
> 3.  加大身份认证的难度，每个微服务都需要独立认证
>
> `增加一个微服务网关，介于客户端与服务器之间的中间层，所有的外部请求都会先经过微服务网关。客户端只需要与网关交互，只知道一个网关地址即可，这样简化了开发还有以下优点：`
>
> 1. 易于监控
> 2. 易于认证
> 3. 减少了客户端与各个微服务之间的交互次数
>
> `API网关是一个服务器，是系统对外的唯一入口。API网关封装了系统内部架构，为每个客户端提供一个定制的API。API网关方式的核心要点是，所有的客户端和消费端都通过统一的网关接入微服务，在网关层处理所有的非业务功能。通常，网关也是提供REST/HTTP的访问API。服务端通过API-GW注册和管理服务。`
> 作用及应用场景：身份认证、监控、负载均衡、缓存、请求分片与管理、静态响应处理，当然，最主要的职责还是与“外界联系”。

### 6.1 Zuul

> Zuul 1.x 存在性能问题，本质上是一个同步 Servlet，采用多线程阻塞模型进行请求转发； 而且不支持任何长连接，如 websocket

1. 动态路由：动态将请求路由到不同后端集群
2. 压力测试：逐渐增加指向集群的流量，以了解性能
3. 负载分配：为每一种负载类型分配对应容量，并弃用超出限定值的请求
4. 静态响应处理：边缘位置进行响应，避免转发到内部集群
5. 身份认证和安全: 识别每一个资源的验证要求，并拒绝那些不符的请求。Spring Cloud 对 Zuul 进行了整合和增强。

### 6.2 Zuul 路由的使用

1. 引入依赖：spring-cloud-starter-netflix-zuul
2. 开启 Zuul 网关：@EnableZuulproxy
3. 编写配置

```yaml
server:
  port: 8080 #服务端口
spring:
  application:
    name: api-gateway #指定服务名

zuul:
  routes:
    product-service: # 这里是路由id，随意写
      path: /product-service/** # 这里是映射路径
      url: http://127.0.0.1:9002 # 映射路径对应的实际url地址
      sensitiveHeaders: #默认zuul会屏蔽cookie，cookie不会传到下游服务，这里设置为空则取消默认的黑名单，如果设置了具体的头信息则不会传到下游服务

# 与eureka整合时，简化zuul配置，但是需要引入eureka配置
zuul:
  routes:
    product-service:  # 路由id，随意写
      path: /product-service/** # 映射路径
      serviceId: shop-service-product # 配置转发的微服务名称

# 简化配置
zuul:
  routes:
    shop-service-product: /product-service/**   # 通常情况下，<route>路由名称和服务名写成一样的

# 默认路由配置规则：默认情况下，一切服务的映射路径就是服务名本身
zuul:
  routes:
    shop-service-product: /shop-service-product/**
```

### 6.3 Zuul 过滤器的使用

> Zuul 中的过滤器跟我们之前使用的 javax.servlet.Filter 不一样，javax.servlet.Filter 只有一种类型，可以通过配置 urlPatterns 来拦截对应的请求。而 Zuul 中的过滤器总共有 4 种类型，且每种类型都有对应的使用场景。

1. PRE：这种过滤器在请求被路由之前调用。我们可利用这种过滤器实现身份验证、在集群中选择请求的微服务、记录调试信息等。
2. ROUTING：这种过滤器将请求路由到微服务。这种过滤器用于构建发送给微服务的请求，并使用 Apache HttpClient 或 Netfilx Ribbon 请求微服务。
3. POST：这种过滤器在路由到微服务以后执行。这种过滤器可用来为响应添加标准的 HTTPHeader、收集统计信息和指标、将响应从微服务发送给客户端等。
4. ERROR：在其他阶段发生错误时执行该过滤器。

ZuulFilter 是过滤器的顶级父类。

```java
// ZuulFilter是过滤器的顶级父类。在这里我们看一下其中定义的4个最重要的方法
public abstract ZuulFilter implements IZuulFilter{

    // filterType ：返回字符串，代表过滤器的类型：pre\routing\post\error
    abstract public String filterType();

    // 通过返回的int值来定义过滤器的执行顺序，数字越小优先级越高。
    abstract public int filterOrder();

    // 返回一个 Boolean 值，判断该过滤器是否需要执行。返回true执行，返回false不执行
    boolean shouldFilter();// 来自IZuulFilter

    // 过滤器的具体业务逻辑。
    Object run() throws ZuulException;// IZuulFilter
}

```

1. 正常流程：请求到达首先会经过 pre 类型过滤器，而后到达 routing 类型，进行路由，请求就到达真正的服务提供者，执行请求，返回结果后，会到达 post 过滤器。而后返回响应。
2. 异常流程
   - 整个过程中，pre 或者 routing 过滤器出现异常，都会直接进入 error 过滤器，再 error 处理完毕后，会将请求交给 POST 过滤器，最后返回给用户。
   - 如果是 error 过滤器自己出现异常，最终也会进入 POST 过滤器，而后返回。
   - 如果是 POST 过滤器出现异常，会跳转到 error 过滤器，但是与 pre 和 routing 不同的时，请求不会再到达 POST 过滤器了。
3. 不同过滤器的场景：
   - 请求鉴权：一般放在 pre 类型，如果发现没有访问权限，直接就拦截了
   - 异常处理：一般会在 error 类型和 post 类型过滤器中结合来处理。
   - 服务调用时长统计：pre 和 post 结合使用

![Eureka](../../public/images/Java/SpringCloud/springcloud-eureka.png)
