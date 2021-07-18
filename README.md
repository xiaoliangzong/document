# 学习笔记

## 1. Linux

### 1.1 linux命令

### 1.2 shell

### 1.3 docker

## 2. 前端

### 2.1 Vue

## 3. Java

### 3.1 基础

### 3.2 springboot

#### 3.2.1 springboot自动装配原理

#### 3.2.2 restTemplate

##### 1. 基本介绍

RestTemplate 是 Spring 提供的，用于访问Rest服务的同步客户端，提供了一些简单的模板方法API；底层支持多种Http客户端类库，因为RestTemplate只是对其他的HTTP客户端的封装，其本身并没有实现HTTP相关的基础功能，底层实现可以按需配置；常用的有：

- SimpleClientHttpRequestFactory，默认配置，对应的JDK自带的HttpURLConnection，不支持Http协议的Patch方法，也无法访问Https请求；
- HttpComponentsClientHttpRequestFactory，对应的是Apache的HttpComponents（注：Apache的HttpClient是前身，后边改名为Components）；
- OkHttp3ClientHttpRequestFactory，对应的是OkHttp。

如果向查看所有的http客户端类库，可以找下ClientHttpRequestFactory接口的实现类：

<img src=".\images\springboot\restTemplate\image-20210717124034829.png" alt="image-20210717124034829" style="zoom:33%;" />

**RestTemplate、Apache的HttpClient、OkHttp比较：**

-  RestTemplate 提供了多种便捷访问远程Http服务的方法，能够大大提高客户端的编写效率；
-  HttpClient代码复杂，还得操心资源回收等。代码很复杂，冗余代码多，不建议直接使用；
-  okhttp是一个高效且开源的第三方HTTP客户端类库，常用于android中请求网络，是安卓端最火热的轻量级框架；允许所有同一个主机地址的请求共享同一个socket连接，连接池减少请求延时；透明的GZIP压缩减少响应数据的大小，缓存响应内容，避免一些完全重复的请求。

##### 2. 常用方法分析及举例

> 这一块主要讲一些常用的方法及参数、对于一些重载的方法，其实原理都差不多。

###### 2.1. get请求

> 除了getForEntity和getForObject外，使用exchange()也可以，前两个是基于它实现的，此处不做介绍

![image-20210717133413370](.\images\springboot\restTemplate/image-20210717133413370.png)

参数包括请求url、响应类型的class、请求参数
   - url：String字符串或者URI对象；常用字符串
   - 响应对象的class实例
     - getForEntity()   ==> 响应为ResponseEntity<T>，其中包括请求的响应码和HttpHeaders
     - getForObject()   ==> 响应为传入的class对象，只包括响应内容
   - 请求参数：替换url中的占位符，可以使用可变长的Object，也可以使用Map；如果没有，可以不填 ==其中object是按照占位符的顺序匹配的，map是根据key匹配，如果匹配不上，就报错==

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

###### 2.2. post请求

![image-20210717160611447](.\images\springboot\restTemplate/image-20210717160611447.png)

参数和get请求的相比，就多了第二个参数（Object request），如果使用最后一个参数传参时，和get请求类似，request设置为null就可以，如果使用第二个参数传参时，就需要考虑request的类型，request参数类型必须是实体对象、MultiValueMap、HttpEntity对象的的一种，其他不可以！！！
- ==实体对象传参时，被请求的接口方法上必须使用@RequestBody，接收参数为实体或者Map；==
- ==HttpEntity传参时，取决于HttpEntity对象的第一个参数，可以为任何类型，包括HashMap；==
- ==MultiValueMap传参时，接收参数使用注解@RequestBody时，使用一个String类型、名称随意，使用@RequestParam时，使用对应个数的String类型字符串，名称必须和map中的key相同；推荐使用@RequestParam==

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

##### 3.  springboot中使用restTemplate步骤

1. 导入jar包

```xml
<!-- springboot web依赖  -->
<dependency>
    <groupId>org.springframework.boot</groupId>
	<artifactId>spring-boot-starter-web</artifactId>
</dependency>
```

2. 编写配置
使用默认的SimpleClientHttpRequestFactory，也就是java JDK自带的HttpURLConnection；
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

3. Service层调用

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

##### 4. 源码分析(postForEntity为例)

<sapn style="color:red">思考重点:</sapn>
<sapn style="color:red"> 1. 第二个参数为什么不能直接使用HashMap，而只能使用MultiValueMap？</sapn>
<sapn style="color:red"> 2. 接收参数时，怎么合理的使用@RequestBody和@RequestParam？</sapn>
<sapn style="color:red"> 3. restTemplate底层默认使用的是SimpleClientHttpRequestFactory，为什么不支持调用Https接口？</sapn>

1. 依次进入方法：postForEntity() -> httpEntityCallback -> HttpEntityRequestCallback

![image-20210717165644382](.\images\springboot\restTemplate/image-20210717165644382.png)

![image-20210717165827241](.\images\springboot\restTemplate/image-20210717165827241.png)

2. requestBody参数，会判断类型是否是HttpEntity，如果不是，则创建一个HttpEntity类将 requestBody 参数传入，然后查看HttpEntity构造器，具体做了什么？

![image-20210717165927874](.\images\springboot\restTemplate/image-20210717165927874.png)

3. 可以看到，三个构造方法，上边两个调用的是最下边一个；

   第一个传入的是泛型，也就是传入的Object对象

   第二个传入的是MultiValueMap，这个值是存放Headers的

   所有只需要关注这个泛型，在哪块使用的

![image-20210717170358763](.\images\springboot\restTemplate/image-20210717170358763.png)

4. 回到postForEntity()方法中，找到调用请求的方法execute，点进去发现是调用方法doExecute(...)；

![image-20210717171852497](.\images\springboot\restTemplate/image-20210717171852497.png)

5. 在doExecute()中
   - 首先使用请求的url和method(post 或者get)构造出一个ClientHttpRequest
   - requestCallback.doWithRequest将之前的requestBody、requestHeader放入此ClientHttpRequest中；
   - 调用request的execute方法获得response，调用handleResponse方法处理response中存在的error
   - 使用ResponseExtractor的extraData方法将返回的response转换为某个特定的类型；
   - 最后关闭ClientHttpResponse资源，这样就完成了发送请求并获得对应类型的返回值的全部过程。

![image-20210717171914777](.\images\springboot\restTemplate/\image-20210717171914777.png)

6. 进入方法getRequestFactory() -> getRequestFactory()可以发现，通过this.requestFactory初始化了SimpleClientHttpRequestFactory();通过方法createRequest(url, method) -> openConnection()发现创建了HttpURLConnection连接，因此默认使用的restTemplate是无法访问Https接口的

![image-20210718224627598](.\images\springboot\restTemplate/image-20210718224627598.png)



7. 进入方法doWithRequest(request)可以发现，程序会执行第一个else中的逻辑，根据传入的参数，判断requestBodyClass、requestBodyType和MediaType；
   - 如果第二个参数为HashMap或者MultiValueMap时，MediaType为null；
   - 如果是HttpEntity时，requestBodyClass为对应参数的类型，MediaType为封装HttpHeaders中的ContentType值

接下来会遍历所有的HttpMessageConverter，这些对象在RestTemplate的构造函数中被初始化

![image-20210718125745189](.\images\springboot\restTemplate/image-20210718125745189.png)

8. 在遍历过程中判断是否可以写入，如果能写入则执行写入操作并返回；判断MessageConvertor是否为GenericHttpMessageConverter的子类，是因为写入的方式不同；在这些MessageConvertor中只有GsonHttpMessageConverter是GenericHttpMessageConverter的子类，且排在最后；因此，遍历过程中会先判断前六个convertor，能写入则执行写入，最后才是GsonHttpMessageConvertor。分析所有的HTTPMessageConvertor，可以发现

   - MultiValueMap子类的数据会被AllEncompassingFormHttpMessageConverter处理，将MediaType置为application/x-www-form-urlencoded、将request中的key value通过&=拼接并写入到body中，接收时，可以为@RequestParam、也可以为@RequestBody  ==Http协议中，如果不指定Content-Type，则默认传递的参数就是application/x-www-form-urlencoded类型==

   - HashMap类型的数据会被GsonHTTPMessageConvertor处理，将MediaType置为application/json;charset=UTF-8、将request转成json并写入到body中，==因此，第二个参数设置为HashMap时，无法设置ContentType值，所有第二个参数无法使用HashMap！但是可以使用HttpEntity对象，将HashMap存放在HttpEntity对象里边，接收参数时，使用@RequestBody==

<img src=".\images\springboot\restTemplate/image-20210718125937670.png" alt="image-20210718125937670" style="zoom:33%;" /> 

<br>

![image-20210718132008639](.\images\springboot\restTemplate//image-20210718132008639.png)

##### 5. restTemplate访问Https接口

==restTemplate底层默认使用的是SimpleClientHttpRequestFactory，是基于HttpURLConnection，是不支持调用Https接口的，可以修改为HttpComponentsClientHttpRequestFactory==

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

### 3.3 springcloud

