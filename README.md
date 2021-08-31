<<<<<<< HEAD
#### 目录结构
```tree
├─images
├─Java
│  ├─Java8新特性
│  ├─JavaSE
│  ├─JUC
│  ├─JVM
│  ├─Mybatis
│  ├─Quartz
│  ├─Spring
│  ├─SpringBoot
│  ├─SpringCloud
│  ├─Swagger
│  ├─权限认证
│  └─消息队列
├─Linux
│  ├─docker
│  ├─shell
│  └─基础命令
├─PhotoShop
├─Tool  
│  ├─Nginx
│  ├─Maven
│  ├─Git    
├─前端
│  ├─ES6新语法
│  ├─Vue
│  └─基础
├─插件
│  ├─IDEA
│  └─开源三方API
└─数据库
    ├─mysql
    ├─oracle
    └─Redis
=======
# 学习笔记

## 1. Linuxaaddada

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
>>>>>>> 3ad7dd2a79f5eb1bcb0415b9785a5c34df4cba80
```
