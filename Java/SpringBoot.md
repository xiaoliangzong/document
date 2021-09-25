## springboot 自动装配原理

### restTemplate

##### 1. 基本介绍

RestTemplate 是 Spring 提供的，用于访问 Rest 服务的同步客户端，提供了一些简单的模板方法 API；底层支持多种 Http 客户端类库，因为 RestTemplate 只是对其他的 HTTP 客户端的封装，其本身并没有实现 HTTP 相关的基础功能，底层实现可以按需配置；常用的有：

- SimpleClientHttpRequestFactory，默认配置，对应的 JDK 自带的 HttpURLConnection，不支持 Http 协议的 Patch 方法，也无法访问 Https 请求；
- HttpComponentsClientHttpRequestFactory，对应的是 Apache 的 HttpComponents（注：Apache 的 HttpClient 是前身，后边改名为 Components）；
- OkHttp3ClientHttpRequestFactory，对应的是 OkHttp。

如果向查看所有的 http 客户端类库，可以找下 ClientHttpRequestFactory 接口的实现类：

<img src=".\images\springboot\restTemplate\image-20210717124034829.png" alt="image-20210717124034829" style="zoom:33%;" />

**RestTemplate、Apache 的 HttpClient、OkHttp 比较：**

- RestTemplate 提供了多种便捷访问远程 Http 服务的方法，能够大大提高客户端的编写效率；
- HttpClient 代码复杂，还得操心资源回收等。代码很复杂，冗余代码多，不建议直接使用；
- okhttp 是一个高效且开源的第三方 HTTP 客户端类库，常用于 android 中请求网络，是安卓端最火热的轻量级框架；允许所有同一个主机地址的请求共享同一个 socket 连接，连接池减少请求延时；透明的 GZIP 压缩减少响应数据的大小，缓存响应内容，避免一些完全重复的请求。

##### 2. 常用方法分析及举例

> 这一块主要讲一些常用的方法及参数、对于一些重载的方法，其实原理都差不多。

###### 2.1. get 请求

> 除了 getForEntity 和 getForObject 外，使用 exchange()也可以，前两个是基于它实现的，此处不做介绍

![image-20210717133413370](.\images\springboot\restTemplate/image-20210717133413370.png)

参数包括请求 url、响应类型的 class、请求参数

- url：String 字符串或者 URI 对象；常用字符串
- 响应对象的 class 实例
  - getForEntity() ==> 响应为 ResponseEntity<T>，其中包括请求的响应码和 HttpHeaders
  - getForObject() ==> 响应为传入的 class 对象，只包括响应内容
- 请求参数：替换 url 中的占位符，可以使用可变长的 Object，也可以使用 Map；如果没有，可以不填 ==其中 object 是按照占位符的顺序匹配的，map 是根据 key 匹配，如果匹配不上，就报错==

```java
// 不带参数的
String url = "localhost:8001/test/method";
Object object = restTemplate.getForObject(url, Object.class);

// 带参数的，使用@PathVariable接收
String url = "localhost:8001/test/method/{param1}";
Object object = restTemplate.getForObject(url, Object.class, "param");
// 带参数的，使用@Requestparam接收
String url = "localhost:8001/test/method?param={dd}";
ResponseEntity<Object> result = restTemplate.getForObject(url, Object.class, "param");
```

###### 2.2. post 请求

![image-20210717160611447](.\images\springboot\restTemplate/image-20210717160611447.png)

参数和 get 请求的相比，就多了第二个参数（Object request），如果使用最后一个参数传参时，和 get 请求类似，request 设置为 null 就可以，如果使用第二个参数传参时，就需要考虑 request 的类型，request 参数类型必须是实体对象、MultiValueMap、HttpEntity 对象的的一种，其他不可以！！！

- ==实体对象传参时，被请求的接口方法上必须使用@RequestBody，接收参数为实体或者 Map；==
- ==HttpEntity 传参时，取决于 HttpEntity 对象的第一个参数，可以为任何类型，包括 HashMap；==
- ==MultiValueMap 传参时，接收参数使用注解@RequestBody 时，使用一个 String 类型、名称随意，使用@RequestParam 时，使用对应个数的 String 类型字符串，名称必须和 map 中的 key 相同；推荐使用@RequestParam==

```java
// 使用MultiValueMap传参
String url = "localhost:8001/test/method";
MultiValueMap<String, String> map= new LinkedMultiValueMap<>();		// 不能使用HashMap，源码中会讲！
map.add("param1", "string1");
map.add("param2", "string2");
ResponseEntity<String> response = restTemplate.postForEntity(url, map , String.class );
// 使用HttpEntity传参
String url = "localhost:8001/test/method";
HttpHeaders headers = new HttpHeaders();
headers.setContentType(MediaType.APPLICATION_JSON);
headers.add(HttpHeaders.CONTENT_ENCODING, StandardCharsets.UTF_8.toString());
headers.add(HttpHeaders.ACCEPT, MediaType.APPLICATION_JSON_VALUE);
String string = "param";
HttpEntity<String> entity = new HttpEntity<String>(string,headers);
String result = restTemplate.postForObject(url, entity, String.class);
```

##### 3. springboot 中使用 restTemplate 步骤

1. 导入 jar 包

```xml
<!-- springboot web依赖  -->
<dependency>
    <groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

2. 编写配置
   使用默认的 SimpleClientHttpRequestFactory，也就是 java JDK 自带的 HttpURLConnection；

```java
@Configuration
public class RestTemplateConfig {
        @Bean
        public RestTemplate restTemplate(@Qualifier("simpleClientHttpRequestFactory") ClientHttpRequestFactory factory){
            return new RestTemplate(factory);
        }

        @Bean
        public ClientHttpRequestFactory simpleClientHttpRequestFactory(){
            SimpleClientHttpRequestFactory factory = new SimpleClientHttpRequestFactory();
            factory.setReadTimeout(5000);
            factory.setConnectTimeout(5000);
            return factory;
        }
}
```

3. Service 层调用

```java
@Service
public class TestService implements ITestService {
    @Autowired
    RestTemplate restTemplate;

    @Override
    public ResultVo test() throws Exception {
        try {
            String url = "http://localhhost:9001/test/demo1";
            ResponseEntity<Object> objectResponseEntity = restTemplate.postForEntity(url, null, Object.class);
            if( 200 == objectResponseEntity.getStatusCodeValue()){
                return ResultVo.success();
            }
            return ResultVo.error();
        } catch (Exception e) {
            throw new Exception("调用接口失败," + e.getMessage());
        }
    }
}
```

##### 4. 源码分析(postForEntity 为例)

<sapn style="color:red">思考重点:</sapn>
<sapn style="color:red"> 1. 第二个参数为什么不能直接使用 HashMap，而只能使用 MultiValueMap？</sapn>
<sapn style="color:red"> 2. 接收参数时，怎么合理的使用@RequestBody 和@RequestParam？</sapn>
<sapn style="color:red"> 3. restTemplate 底层默认使用的是 SimpleClientHttpRequestFactory，为什么不支持调用 Https 接口？</sapn>

1. 依次进入方法：postForEntity() -> httpEntityCallback -> HttpEntityRequestCallback

![image-20210717165644382](.\images\springboot\restTemplate/image-20210717165644382.png)

![image-20210717165827241](.\images\springboot\restTemplate/image-20210717165827241.png)

2. requestBody 参数，会判断类型是否是 HttpEntity，如果不是，则创建一个 HttpEntity 类将 requestBody 参数传入，然后查看 HttpEntity 构造器，具体做了什么？

![image-20210717165927874](.\images\springboot\restTemplate/image-20210717165927874.png)

3. 可以看到，三个构造方法，上边两个调用的是最下边一个；

   第一个传入的是泛型，也就是传入的 Object 对象

   第二个传入的是 MultiValueMap，这个值是存放 Headers 的

   所有只需要关注这个泛型，在哪块使用的

![image-20210717170358763](.\images\springboot\restTemplate/image-20210717170358763.png)

4. 回到 postForEntity()方法中，找到调用请求的方法 execute，点进去发现是调用方法 doExecute(...)；

![image-20210717171852497](.\images\springboot\restTemplate/image-20210717171852497.png)

5. 在 doExecute()中
   - 首先使用请求的 url 和 method(post 或者 get)构造出一个 ClientHttpRequest
   - requestCallback.doWithRequest 将之前的 requestBody、requestHeader 放入此 ClientHttpRequest 中；
   - 调用 request 的 execute 方法获得 response，调用 handleResponse 方法处理 response 中存在的 error
   - 使用 ResponseExtractor 的 extraData 方法将返回的 response 转换为某个特定的类型；
   - 最后关闭 ClientHttpResponse 资源，这样就完成了发送请求并获得对应类型的返回值的全部过程。

![image-20210717171914777](.\images\springboot\restTemplate/\image-20210717171914777.png)

6. 进入方法 getRequestFactory() -> getRequestFactory()可以发现，通过 this.requestFactory 初始化了 SimpleClientHttpRequestFactory();通过方法 createRequest(url, method) -> openConnection()发现创建了 HttpURLConnection 连接，因此默认使用的 restTemplate 是无法访问 Https 接口的

![image-20210718224627598](.\images\springboot\restTemplate/image-20210718224627598.png)

7. 进入方法 doWithRequest(request)可以发现，程序会执行第一个 else 中的逻辑，根据传入的参数，判断 requestBodyClass、requestBodyType 和 MediaType；
   - 如果第二个参数为 HashMap 或者 MultiValueMap 时，MediaType 为 null；
   - 如果是 HttpEntity 时，requestBodyClass 为对应参数的类型，MediaType 为封装 HttpHeaders 中的 ContentType 值

接下来会遍历所有的 HttpMessageConverter，这些对象在 RestTemplate 的构造函数中被初始化

![image-20210718125745189](.\images\springboot\restTemplate/image-20210718125745189.png)

8. 在遍历过程中判断是否可以写入，如果能写入则执行写入操作并返回；判断 MessageConvertor 是否为 GenericHttpMessageConverter 的子类，是因为写入的方式不同；在这些 MessageConvertor 中只有 GsonHttpMessageConverter 是 GenericHttpMessageConverter 的子类，且排在最后；因此，遍历过程中会先判断前六个 convertor，能写入则执行写入，最后才是 GsonHttpMessageConvertor。分析所有的 HTTPMessageConvertor，可以发现

   - MultiValueMap 子类的数据会被 AllEncompassingFormHttpMessageConverter 处理，将 MediaType 置为 application/x-www-form-urlencoded、将 request 中的 key value 通过&=拼接并写入到 body 中，接收时，可以为@RequestParam、也可以为@RequestBody ==Http 协议中，如果不指定 Content-Type，则默认传递的参数就是 application/x-www-form-urlencoded 类型==

   - HashMap 类型的数据会被 GsonHTTPMessageConvertor 处理，将 MediaType 置为 application/json;charset=UTF-8、将 request 转成 json 并写入到 body 中，==因此，第二个参数设置为 HashMap 时，无法设置 ContentType 值，所有第二个参数无法使用 HashMap！但是可以使用 HttpEntity 对象，将 HashMap 存放在 HttpEntity 对象里边，接收参数时，使用@RequestBody==

<img src=".\images\springboot\restTemplate/image-20210718125937670.png" alt="image-20210718125937670" style="zoom:33%;" />

<br>

![image-20210718132008639](.\images\springboot\restTemplate//image-20210718132008639.png)

##### 5. restTemplate 访问 Https 接口

==restTemplate 底层默认使用的是 SimpleClientHttpRequestFactory，是基于 HttpURLConnection，是不支持调用 Https 接口的，可以修改为 HttpComponentsClientHttpRequestFactory==

```java
public class RestTemplateConfig {
  @Bean
  public RestTemplate getRestTemplate() throws KeyStoreException, NoSuchAlgorithmException, KeyManagementException {
        SSLContext sslContext = new SSLContextBuilder().loadTrustMaterial(null, new TrustStrategy() {
            @Override
            public boolean isTrusted(X509Certificate[] arg0, String arg1) throws CertificateException {
                return true;
            }
        }).build();

        SSLConnectionSocketFactory csf = new SSLConnectionSocketFactory(sslContext,
                new String[]{"TLSv1"},
                null,
                NoopHostnameVerifier.INSTANCE);

        CloseableHttpClient httpClient = HttpClients.custom()
                .setSSLSocketFactory(csf)
                .build();

        HttpComponentsClientHttpRequestFactory requestFactory = new HttpComponentsClientHttpRequestFactory();

        requestFactory.setHttpClient(httpClient);
        return new RestTemplate(requestFactory);
    }
}

```

3. Random、ThreadLocalRandom、SecureRandom

1. Random：伪随机数，通过种子生成随机数，种子默认使用系统时间，可预测，安全性不高，线程安全；
1. ThreadLocalRandom：jdk7 才出现的，多线程中使用，虽然 Random 线程安全，但是由于 CAS 乐观锁消耗性能，所以多线性推荐使用
1. SecureRandom：可以理解为 Random 升级，它的种子选取比较多，主要有：时间，cpu，使用情况，点击事件等一些种子，安全性高；特别是在生成验证码的情况下，不要使用 Random，因为它是线性可预测的。所以在安全性要求比较高的场合，应当使用 SecureRandom。

相同点：种子相同，在相同条件，运行相同次数产生的随机数相同；

## 4. restful 与 rpc

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

   ## 1. 热部署

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-devtools</artifactId>
	<version>2.2.1.RELEASE</version>
</dependency>
```

## 2. Junit 单元测试

> springboot 2.2 版本之前使用 JUnit4(org.junit.junit.Test)，之后版本使用 JUnit5(org.junit.juniter.api.Test)
>
> `由于初始化创建Springboot时，版本高于2.2，导致引入包为jupiter；而改为低版本时，需要手动导JUnit5或者使用Junit4测试单元`

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-test</artifactId>
    <scope>test</scope>
    <exclusions>
    	<exclusion>
    		<groupId>org.junit.vintage</groupId>
    		<artifactId>junit-vintage-engine</artifactId>
    	</exclusion>
    </exclusions>
</dependency>
<dependency>
    <groupId>org.junit.jupiter</groupId>
    <artifactId>junit-jupiter</artifactId>
    <version>5.6.2</version>
    <scope>test</scope>
</dependency>
```

| 2.2 版本之前                             | 2.2 版本之后                                                                                   |
| ---------------------------------------- | ---------------------------------------------------------------------------------------------- |
| JUnit4(org.junit.junit.Test)             | JUnit(org.junit.juniter.api.Test)                                                              |
| 需要使用注解@RunWith(SpringRunner.class) | @ExtendWith(SpringExtension.class)                                                             |
|                                          | 支持 lambda 表达式                                                                             |
| 测试引擎：vintage-engine                 | 测试引擎：juniter-engine                                                                       |
|                                          | org.junit.jupiter.api.Assertions 包的 stratic 方法<br />assertTrue、assertFalse、assertNotNull |

## 3. 异步和定时

### 3.1 TaskExecutor 任务执行器 与 TaskScheduler 任务调度器

1. 任务执行器：多线程执行异步任务
2. 任务调度器：定时任务多线程调度，定义一个自定义的任务调度线程池
3. 对于更细粒度的控制，可以实现 SchedulingConfigurer 或 AsyncConfigurer 接口
   - springboot 默认线程池配置，可以实现 AsyncConfigurer 接口，该接口中有配置线程池和异常处理的方法；
   - SchedulingConfigurer 接口

### 3.2 异步（注解和接口）

> @Async 标注异步方法，@EnableAsync 开启异步执行调用，可以直接标注在启动类、也可以写在自定义配置类上
>
> 1. 不能再同类中调用，因为实现的方式是动态代理
> 2. 异步执行类需要被 spring 管理，且使用注入的方法获取实例进行调用，不能使用 new
> 3. 异步方法不能使用 static 修饰
> 4. 需要扫码配置类，@Configuration

```java
@Configuration
@EnableAsync//开启异步
public class ThreadPoolConfig {
    @Bean("logThread")
    public TaskExecutor taskExecutor() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();
        // 设置核心线程数
        executor.setCorePoolSize(4);
        // 设置最大线程数
        executor.setMaxPoolSize(8);
        // 设置队列容量
        executor.setQueueCapacity(100);
        // 设置线程活跃时间（秒）
        executor.setKeepAliveSeconds(60);
        // 设置默认线程名称
        executor.setThreadNamePrefix("home.bus.logThread-");
        // 设置拒绝策略
        executor.setRejectedExecutionHandler(new ThreadPoolExecutor.CallerRunsPolicy());
        // 等待所有任务结束后再关闭线程池
        executor.setWaitForTasksToCompleteOnShutdown(true);
        return executor;
    }
}

/**
 * @description: 异步线程池配置 AsyncConfigurer在applicationContext早期初始化，如果需要依赖于其它的bean，尽可能的将它们声明为lazy
 */
@EnableAsync
@Configuration
@EnableConfigurationProperties(AsyncThreadPoolProperties.class)
public class AsyncThreadPoolAutoConfiguration implements AsyncConfigurer {
    @Autowired
    private AsyncThreadPoolProperties asyncThreadPoolProperties;
    /**
     * 定义线程池
     * 使用{@link java.util.concurrent.LinkedBlockingQueue}(FIFO）队列，是一个用于并发环境下的阻塞队列集合类
     * ThreadPoolTaskExecutor不是完全被IOC容器管理的bean,可以在方法上加上@Bean注解交给容器管理,这样可以将taskExecutor.initialize()方法调用去掉，容器会自动调用
     * @return
     */
    @Bean("asyncTaskExecutor")
    @Override
    public Executor getAsyncExecutor() {
        //Java虚拟机可用的处理器数
        int processors = Runtime.getRuntime().availableProcessors();
        //定义线程池
        ThreadPoolTaskExecutor taskExecutor = new ThreadPoolTaskExecutor();
        //核心线程数
        taskExecutor.setCorePoolSize(Objects.nonNull(asyncThreadPoolProperties.getCorePoolSize()) ? asyncThreadPoolProperties.getCorePoolSize() : processors);
        //线程池最大线程数,默认：40000
        taskExecutor.setMaxPoolSize(Objects.nonNull(asyncThreadPoolProperties.getMaxPoolSize()) ? asyncThreadPoolProperties.getMaxPoolSize() : 40000);
        //线程队列最大线程数,默认：80000
        taskExecutor.setQueueCapacity(Objects.nonNull(asyncThreadPoolProperties.getMaxPoolSize()) ? asyncThreadPoolProperties.getMaxPoolSize() : 80000);
        //线程名称前缀
        taskExecutor.setThreadNamePrefix(StringUtils.isNotEmpty(asyncThreadPoolProperties.getThreadNamePrefix()) ? asyncThreadPoolProperties.getThreadNamePrefix() : "Async-ThreadPool-");
        //线程池中线程最大空闲时间，默认：60，单位：秒
        taskExecutor.setKeepAliveSeconds(asyncThreadPoolProperties.getKeepAliveSeconds());
        //核心线程是否允许超时，默认:false
        taskExecutor.setAllowCoreThreadTimeOut(asyncThreadPoolProperties.isAllowCoreThreadTimeOut());
        //IOC容器关闭时是否阻塞等待剩余的任务执行完成，默认:false（必须设置setAwaitTerminationSeconds）
        taskExecutor.setWaitForTasksToCompleteOnShutdown(asyncThreadPoolProperties.isWaitForTasksToCompleteOnShutdown());
        //阻塞IOC容器关闭的时间，默认：10秒（必须设置setWaitForTasksToCompleteOnShutdown）
        taskExecutor.setAwaitTerminationSeconds(asyncThreadPoolProperties.getAwaitTerminationSeconds());
        /**
         * 拒绝策略，默认是AbortPolicy
         * AbortPolicy：丢弃任务并抛出RejectedExecutionException异常
         * DiscardPolicy：丢弃任务但不抛出异常
         * DiscardOldestPolicy：丢弃最旧的处理程序，然后重试，如果执行器关闭，这时丢弃任务
         * CallerRunsPolicy：执行器执行任务失败，则在策略回调方法中执行任务，如果执行器关闭，这时丢弃任务
         */
        taskExecutor.setRejectedExecutionHandler(new ThreadPoolExecutor.AbortPolicy());
        //初始化
        //taskExecutor.initialize();
        return taskExecutor;
    }
    /**
     * 异步方法执行的过程中抛出的异常捕获
     *
     * @return
     */
    @Override
    public AsyncUncaughtExceptionHandler getAsyncUncaughtExceptionHandler() {
        return (throwable, method, objects) -> {
            String msg = StringUtils.EMPTY;
            if (ArrayUtils.isNotEmpty(objects) && objects.length > 0) {
                msg = StringUtils.join(msg, "参数是：");
                for (int i = 0; i < objects.length; i++) {
                    msg = StringUtils.join(msg, objects[i], CharacterUtils.ENTER);
                }
            }
            if (Objects.nonNull(throwable)) {
                msg = StringUtils.join(msg, PrintExceptionInfo.printErrorInfo(throwable));
            }
            LoggerUtils.error(method.getDeclaringClass(), msg);
        };
    }
}
```

### 3.3 定时（注解和接口）

> 定时的几种实现方式：
>
> 1. while 循环执行 thread 线程，线程调用 sleep 睡眠
> 2. Timer 和 TimerTask， 简单无门槛，一般也没人用
> 3. 线程池，Executors.newScheduledThreadPool，底层 ScheduledThreadPoolExecutor；
> 4. spring 自带的 springtask（@Schedule），一般集成于项目中，小任务很方便
> 5. Quartz，开源工具 Quartz，分布式集群开源工具，以下两个分布式任务应该都是基于 Quartz 实现的，可以说是中小型公司必选，当然也视自身需求而定
> 6. 分布式任务 XXL-JOB，是一个轻量级分布式任务调度框架，支持通过 Web 页面对任务进行 CRUD 操作，支持动态修改任务状态、暂停/恢复任务，以及终止运行中任务，支持在线配置调度任务入参和在线查看调度结果。
> 7. 分布式任务 Elastic-Job，是一个分布式调度解决方案，由两个相互独立的子项目 Elastic-Job-Lite 和 Elastic-Job-Cloud 组成。定位为轻量级无中心化解决方案，使用 jar 包的形式提供分布式任务的协调服务。支持分布式调度协调、弹性扩容缩容、失效转移、错过执行作业重触发、并行调度、自诊。
> 8. 分布式任务 Saturn，Saturn 是唯品会在 github 开源的一款分布式任务调度产品。它是基于当当 elastic-job 来开发的，其上完善了一些功能和添加了一些新的 feature。目前在 github 上开源大半年，470 个 star。Saturn 的任务可以用多种语言开发比如 python、Go、Shell、Java、Php。其在唯品会内部已经发部署 350+个节点，每天任务调度 4000 多万次。同时，管理和统计也是它的亮点。
>
> @Schedule 注解：
>
> `核心属性是cron，代表定时任务的触发计划表达式，@Scheduled(cron="seconds minutes hours day month week")；也可以使用fixedRate、fixedDelay、initialDelay`
>
> 默认是单线程；是静态执行的，执行周期都是固定写死的；开启多个任务，任务执行时机会受上一次任务执行时间的影响
>
> `解决办法：定时任务多线程任务调度器：定义一个自定义的任务调度线程池TaskSchedule`

```java
@Configuration
@ComponentScan
public class SchedulerConfig{
    @Bean
    public TaskScheduler taskScheduler() {
        ThreadPoolTaskScheduler taskScheduler = new ThreadPoolTaskScheduler();
        taskScheduler.setPoolSize(5);
        taskScheduler.initialize();
        return taskScheduler;
    }
}

@Configuration      //1.主要用于标记配置类，兼备Component的效果。
@EnableScheduling   // 2.开启定时任务
public class SaticScheduleTask {
    //3.添加定时任务
    @Scheduled(cron = "0/5 * * * * ?")
    //或直接指定时间间隔，例如：5秒
    //@Scheduled(fixedRate=5000)
    private void configureTasks() {
        System.err.println("执行静态定时任务时间: " + LocalDateTime.now());
    }
}


// SchedulingConfigurer
// 通过将cron对象数据持久化，调用的时候，获取时间周期。
@Override
public void configureTasks(ScheduledTaskRegistrar taskRegistrar) {
    taskRegistrar.addTriggerTask(
        //1.添加任务内容(Runnable)
        () -> System.out.println("执行动态定时任务: " + LocalDateTime.now().toLocalTime()),
        //2.设置执行周期(Trigger)
        triggerContext -> {
            //2.1 从数据库获取执行周期
            String cron = cronMapper.getCron();
            //2.2 合法性校验.
            if (StringUtils.isEmpty(cron)) {
                // Omitted Code ..
            }
            //2.3 返回执行周期(Date)
            return new CronTrigger(cron).nextExecutionTime(triggerContext);
        }
    );
}
```

## 4. 多模块整合

> 问题汇总：
>
> 1. 打包时需使用：mvn clear package -Dmaven.test.skip=true 忽略测试进行打包，测试代码不会影响项目发布，但是会影响项目打包
> 2. 执行 jar 时指定配置文件：java -jar xxx.jar -Dspring.profiles.active=prod 或者--spring.profiles.active=dev;一个是命令行参数、一个是 jvm 参数

    --spring.config.location        加载本地配置文件
    --server.port=8080              指定端口

> 3. 项目打包报错：Non-resolvable parent POM for demo:demo-base:0.0.1-SNAPSHOT: Could not find artifact demo:demo:pom:0.0.1-SNAPSHOT and 'parent.relativePath' points at no local POM
>    - 删除<parent></parent>标签的这句 <relativePath/> <!-- lookup parent from repository -->
> 4. 报错信息截取：Unsatisfied dependency expressed through field 'baseMapper'; nested exception is org.springframework.beans.factory.NoSuchBeanDefinitionException: No qualifying bean
>    `未扫描到Mapper；解决方法：springboot启动类上加 @MapperScan注解或者在mapper接口上添加@Mapper注解，@Mapper 一定要有，否则 Mybatis 找不到 mapper；@Repository 可有可无，可以消去依赖注入的报错信息。@MapperScan > 可以替代 @Mapper`
> 5. 多启动类配置文件读取报错：`启动类使用：spring.profiles.active=dev,dao,service，在service模块，增加配置文件application-service.yml`
> 6. 编译错误：maven-surefire-plugin:2.22.2:test (default-test) on project earnings: There are test failures.
>    `会生成错误文件，打开排查--->`

```java
// 未找到合适的驱动类，由于资源文件未设置成Resources root
java.lang.IllegalStateException: Failed to load ApplicationContext
Caused by: org.springframework.beans.factory.BeanCreationException: Error creating bean with name 'dataSource' defined in class path resource [com/alibaba/druid/spring/boot/autoconfigure/DruidDataSourceAutoConfigure.class]: Invocation of init method failed; nested exception is org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
Caused by: org.springframework.boot.autoconfigure.jdbc.DataSourceProperties$DataSourceBeanCreationException: Failed to determine a suitable driver class
```

1. 创建一个 project，并删除 src 目录，修改 pom 文件的打包方式为 pom
   <packaging>pom</packaging>
2. 创建多个 module，并添加相互之间的依赖，将父工程改为 project
3. 在父模块中添加<modules></modules>标签
4. 修改启动类的包名，使启动类放在上一层，为了扫描同目录以及子目录下边的所有文件 (`SpringbootApplication默认扫描本包以及子包的所有实例；如果还需扫描其他包下的实例，使用@ComponentScan注解`)
5. 默认关闭 test 单元测试

```xml
<build>
	<plugins>
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-compiler-plugin</artifactId>
			<version>3.1</version>
			<configuration>
				<source>${java.version}</source>
				<target>${java.version}</target>
			</configuration>
		</plugin>
		<plugin>
			<groupId>org.apache.maven.plugins</groupId>
			<artifactId>maven-surefire-plugin</artifactId>
			<version>2.19.1</version>
			<configuration>
				<skipTests>true</skipTests>    <!--默认关掉单元测试 -->
			</configuration>
		</plugin>
	</plugins>
</build>
```

## 5. spring-boot-maven-plugin 插件

> maven 中的 classfier 标签，在打包的使用起别名，为了生成一个普通 jar，一个可执行 jar，可执行 jar 的后缀为 xxx-exec.jar
>
> 如果只需要普通 jar 包，就不需要启动类和打包插件，直接当成 maven 工程，直接可以用，`注意点(切记)：不能使用spring-boot-maven-plugin插件打包`

```xml
<plugin>
 <groupId>org.springframework.boot</groupId>
 <artifactId>spring-boot-maven-plugin</artifactId>
 <configuration>
 	<classifier>exec</classifier>
 </configuration>
</plugin>
```

## 6. 单元测试异步执行问题

springboot 单元测试中测试异步线程，发现异步线程没有执行?

观察日志发现，主线程执行完毕，springboot 线程池关闭，这时才明白，虽是单元测试，却走的一个完整的 springboot 生命周期，主线程执行时间短，springboot 运行结束，线程池关闭.

解决办法：在 springboot 单元测试中，测试异步方法时，在主线程增加 Thread.sleep(),等待子线程执行结束后结束主线程，在实际环境中，springboot 一直运行中，故不会出现这种情况。

## 7. 传参

```java
// @PathVariable 获取路径参数，比如url/{id}   	--一般用在GET，DELETE，PUT方法
// @RequestParam 获取查询参数，比如url/name=xxx  --一般在PUT，POST中比较常用
@GetMapping("/demo/{id}")
public void demo(@PathVariable(name = "id") String id, @RequestParam(name = "name") String name) {
    System.out.println("id="+id);
    System.out.println("name="+name);
}
// @RequestBody  使用map或者实体类接受参数，
// 无注解，使用form表单发送post请求，使用实体接受参数
使用@Valid对参数进行校验
在使用对象进行参数接收时，我们可以对参数进行校验，假设我们需要用户输入的密码是整数型且在000000至999999之间的数值，我们可以对属性passWord加上如下注解：

@Max(value = 999999,message = "超过最大数值")
@Min(value = 000000,message = "密码设定不正确")
private String passWord;

// 请求头参数以及cookie
	@RequestHeader
	@CookieValue
@GetMapping("/demo3")
public void demo3(HttpServletRequest request) {
    System.out.println(request.getHeader("myHeader"));
    for (Cookie cookie : request.getCookies()) {
        if ("myCookie".equals(cookie.getName())) {
            System.out.println(cookie.getValue());
        }
    }
}
@GetMapping("/demo3")
public void demo3(@RequestHeader(name = "myHeader") String myHeader,
        @CookieValue(name = "myCookie") String myCookie) {
    System.out.println("myHeader=" + myHeader);
    System.out.println("myCookie=" + myCookie);
}

使用 defaultValue 给参数指定个默认值。

```

## 8. 读取配置文件属性

@importResource -> 导入 Spring 的配置文件，让配置文件里边的内容生效，@ImportSource(locations={"calsspath:bean.xml"})

```java
@ConfigurationProperties  	// 是springboot的注解，用于把主配置文件中配置属性设置到对应的Bean属性上
方式1：ConfigurationProperties + Component作用于类上
@ConfigurationProperties(prefix="xxx")
@Componment
public class Person {
    private String name；
}
方式2：ConfigurationProperties + Bean作用在配置类的bean方法上
public class Person {
    private String name；
}
@Configuration
public class PersonConf{
    @Bean
    @ConfigurationProperties(prefix="xxx")
    public Person person(){
        return new Person();
    }
}
方式3：ConfigurationProperties注解到普通类、 EnableConfigurationProperties定义为bean
@ConfigurationProperties(prefix="xxx")
public class Person {
    private String name；
}
@Configuration
@EnableConfigurationProperties（xxx.class） // 直接加到启动类即可
public class PersonConf{

}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
@PropertySource				// 是spring的注解，用于加载指定的属性文件的配置到 Spring 的 Environment 中。可以配合 @Value 和 @ConfigurationProperties 使用
用法：
// @Configuration+ @PropertySource+Environment

// @Configuration+ @PropertySource+@Value

@Component标注实体类， 则@PropertySource放在哪都可以，（可以放在实体类上，也可以放在配置类上）

如果使用Bean方式注入对象，PropertySource({"classpath:/student.properties"}) //此时只能放在配置类加载

// @Configuration+ @PropertySource+@ConfigurationProperties
@Configuration
@ConfigurationProperties(prefix = "remote", ignoreUnknownFields = false)
@PropertySource("classpath:config/remote.properties")
@Data
public class RemoteProperties {
  private String uploadFilesUrl;
  private String uploadPicUrl;
}
```

## 9. 测试连接数据库

> 必须导入 spring-boot-starter-jdbc 包，如果时整合 mybatis 或 mybatisplus 时，就不需要导入了，因为它们底层都依赖 spring-boot-starter-jdbc 的

## 10. xxxAutoConfiguration 自动配置类

1. 配置类注解详解
   - @ConditionalOnClass：只有在 classpath 类路径下要有这个类才能激活当前配置类
   - @ConditionalOnBean：仅仅在当前上下文中存在某个对象时，才会实例化一个 Bean
   - @ConditionalOnExpression：当表达式为 true 时，才会实例化一个 Bean
   - @ConditionalOnMissingBean：仅仅在当前上下文中不存在某个 Bean 时，才会实例化一个 Bean
   - @COnditionalOnMissingClass：当某个 class 类路径上不存在的时候，才会实例化一个 Bean
   - @ConditioonalOnNotWebApplication：不是 web 应用

## 11. RestController 和 Controller

1. @Controller 注解

   - 在对应的方法上，视图解析器可以解析 return 的 jsp,html 页面，并且跳转到相应页面；若返回 json 等内容到页面，则需要加@ResponseBody 注解

2. @RestController 注解
   - 相当于@Controller+@ResponseBody 两个注解的结合，返回 json 数据不需要在方法前面加@ResponseBody 注解了，但使用@RestController 这个注解，就不能返回 jsp,html 页面，视图解析器无法解析 jsp,html 页面

## 12. @RestControllerAdvice 和 @ControllerAdvice

- @RestControllerAdvice 注解包含了@ControllerAdvice 注解和@ResponseBody 注解

- 当自定义类加注解@RestControllerAdvice 或 ControllerAdvice+RequestBody 时，方法返回 json 数据。

- 通常和 @ExceptionHandler 配合使用，用于处理全局异常情况

## 13. RestTemplateBuilder 实例化 RestTemplate

> 使用 restTemplateBuilder 实例化，因为 spring 自动化配置注入到 Ioc 容器的。

![restTemplate](../../images/SpringBoot/springboot.png)

## 14. springboot 的自动装配和启动过程

> 通过注解或者一些简单的配置就能在 springboot 的帮助下实现某块功能
>
> 在启动时，会扫描外部引用 jar 包中的 META-INF/spring.factories 文件，将文件中的配置的类型信息加载到 spring 容器，并执行类中定义的各种操作。
>
> @SpringBootApplication 注解包括：
>
> 1. @SpringBootConfiguration（@Configuration）就是将当前的类作为一个 javaconfig，然后触发其他两个注解的处理，本质上就是@Configuration 注解
> 2. @EnableAutoConfiguration
> 3. @ComponentScan

1.  其中@EnableAutoConfiguration 是自动配置机制的核心，
2.  通过@Import 注解引入了 AutoConfigurationImportSelector 加载自动装配类。
3.  selectImports 方法主要用于`获取所有符合条件的类的全限定类名，这些类需要被加载到 IoC 容器中。`
4.  其中通过 SpringFactoriesLoader
5.  ConfigurationClassPostProcessor 解析启动主类，并且读取解析注解 ConfigurationClassPostProcessor 类中 parse 方法解析启动类

## springboot 查看自动配置是否生效：通过启用 debug=ture 属性，在控制台打印自动配置报告，这样子就可以看到哪些自动配置生效。

## 15. Springboot 配置文件

1. 占位符
   ${random.value}、${random.int}、${random.long}
    ${random.int(10)}、${random.int[1024,65536]}
2. 指定默认值，使用:指定默认值
   ${person.hello:hello}
3. 多文档块，使用---分割

## 16. spring cache + caffeine

1. @CacheConfig：主要用于配置该类中会用到的一些共用的缓存配置
2. @Cacheable：主要方法返回值加入缓存，同时在查询时，会先从缓存中取，若不存在才再发起对数据的访问
3. @CachePut：配置于函数上，能够根据参数定义条件进行缓存，与@Cacheable 不同的是，每次回真实调用函数，所以主要用于数据新增和修改操作上
4. @CacheEvict:配置于函数上，通常用在删除方法上，用来从缓存中移除对应数据
5. @Caching:配置于函数上，组合多个 Cache 注解使用。

@EnableCaching：开启缓存功能
@Cacheable：定义缓存，用于触发缓存
@CachePut：定义更新缓存，触发缓存更新
@CacheEvict：定义清楚缓存，触发缓存清除
@Caching：组合定义多种缓存功能
@CacheConfig：定义公共设置，位于 class 之上

### 16.1 导入依赖：

```xml
 <dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-cache</artifactId>
</dependency>

<dependency>
    <groupId>com.github.ben-manes.caffeine</groupId>
    <artifactId>caffeine</artifactId>
</dependency>
```

### 16.2 yml 配置 通过 yaml 文件配置的方式不够灵活，无法实现多种缓存策略，所以现在一般使用 javaconfig 的形式进行配置。

```yaml
spring:
  cache:
    cache-names: caffeineChche
    type: caffeine
    caffeine:
      spec: initialCapacity=50,maximumSize=500,expireAfterWrite=5s

# Caffeine 配置说明
initialCapacity=[integer]: 初始的缓存空间大小
maximumSize=[long]: 缓存的最大条数
maximumWeight=[long]: 缓存的最大权重
expireAfterAccess=[duration]: 最后一次写入或访问后经过固定时间过期
expireAfterWrite=[duration]: 最后一次写入后经过固定时间过期
refreshAfterWrite=[duration]: 创建缓存或者最近一次更新缓存后经过固定的时间间隔，刷新缓存
weakKeys: 打开 key 的弱引用
weakValues：打开 value 的弱引用
softValues：打开 value 的软引用
recordStats：开发统计功能
# 注意

expireAfterWrite 和 expireAfterAccess 同事存在时，以 expireAfterWrite 为准。
maximumSize 和 maximumWeight 不可以同时使用
weakValues 和 softValues 不可以同时使用
```

### 16.3 开启缓存 @EnableCaching

### 16.4 使用

## 17 RequestBodyAdvice 和 ResponseBodyAdvice

对@RequestBody 的参数进行各种处理，例如加解密、打印日志，这些东西我们可以用到 RequestBodyAdvice 和 ResponseBodyAdvice 来对请求前后进行处理，本质上他俩都是 AOP

1. supports:返回 true 代表开启支持，false 不支持。
2. beforeBodyRead:body 读取前进行处理。
3. afterBodyRead:body 读取后进行处理。
4. handleEmptyBody:body 为空时处理。

5. supports:返回 true 代表开启支持，false 不支持。
6. beforeBodyWrite:body 返回给页面参数之前处理。

> 对 controller 结果二次封装，在 spring 中，我们需要实现 HandlerMethodReturnValueHandler 接口，这并不会有任何问题；在使用 SpringBoot 的情况下，SpringBoot 对返回值的处理，默认就是 HandlerMethodReturnValueHandler，我们写的 HandlerMethodReturnValueHandler 无法直接生效，如果非要使用 HandlerMethodReturnValueHandler，那么只能想办法替换掉默认的

## 18 拦截器

1. 实现方式
   - 定义一个类，实现 org.springframework.web.servlet.HandlerInterceptor 接口
   - 继承已实现了 HandlerInterceptor 接口的类，例如 org.springframework.web.servlet.handler.HandlerInterceptorAdapter 抽象类。
2. 添加 Interceptor 拦截器到 WebMvcConfigurer 配置器中
   - 以前一般继承 org.springframework.web.servlet.config.annotation.WebMvcConfigurerAdapter 类，不过 SrpingBoot 2.0 以上 WebMvcConfigurerAdapter 类就过时了。有以下 2 中替代方法：
     - 直接实现 org.springframework.web.servlet.config.annotation.WebMvcConfigurer 接口。（推荐）
     - 继承 org.springframework.web.servlet.config.annotation.WebMvcConfigurationSupport 类。但是继承 WebMvcConfigurationSupport 会让 SpringBoot 对 mvc 的自动配置失效。不过目前大多数项目是前后端分离，并没有对静态资源有自动配置的需求，所以继承 WebMvcConfigurationSupport 也未尝不可。
