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
