## http 和 https

> 超文本传输协议。用于在 web 浏览器和网站服务器之间传递信息，

#### springboot 支持 https

1. 直接借助 Java 自带的 JDK 管理工具 keytool 来生成一个免费的 https 证书

```
keytool -genkey -alias tomcathttps -keyalg RSA -keysize 2048 -keystore ./jerry.keystore -validity 365

命令含义如下：

genkey 表示要创建一个新的密钥。
alias 表示 keystore 的别名。
keyalg 表示使用的加密算法是 RSA ，一种非对称加密算法。
keysize 表示密钥的长度。
keystore 表示生成的密钥存放位置。
validity 表示密钥的有效时间，单位为天。
```

2. 将上面生成的 javaboy.p12 拷贝到 Spring Boot 项目的 resources 目录下。然后在 application.properties 中添加如下配置：

```
server.ssl.key-store=classpath:javaboy.p12
server.ssl.key-alias=tomcathttps
server.ssl.key-store-password=111111

其中：

key-store表示密钥文件名。
key-alias表示密钥别名。
key-store-password就是在cmd命令执行过程中输入的密码。
```

3. Spring Boot 不支持同时启动 HTTP 和 HTTPS ，为了解决这个问题，我们这里可以配置一个请求转发，当用户发起 HTTP 调用时，自动转发到 HTTPS 上。

```java
@Configuration
public class TomcatConfig {
    @Bean
    TomcatServletWebServerFactory tomcatServletWebServerFactory() {
        TomcatServletWebServerFactory factory = new TomcatServletWebServerFactory(){
            @Override
            protected void postProcessContext(Context context) {
                SecurityConstraint constraint = new SecurityConstraint();
                constraint.setUserConstraint("CONFIDENTIAL");
                SecurityCollection collection = new SecurityCollection();
                collection.addPattern("/*");
                constraint.addCollection(collection);
                context.addConstraint(constraint);
            }
        };
        factory.addAdditionalTomcatConnectors(createTomcatConnector());
        return factory;
    }
    private Connector createTomcatConnector() {
        Connector connector = new
                Connector("org.apache.coyote.http11.Http11NioProtocol");
        connector.setScheme("http");
        connector.setPort(8081);
        connector.setSecure(false);
        connector.setRedirectPort(8080);
        return connector;
    }
}
```

## 1. HttpServletResponse

HttpServletResponse 接口继承自 ServletResponse 接口，主要用于封装 HTTP 响应消息。由于 HTTP 响应消息分为状态行、响应消息头、消息体三部分。

### 常用方法

```java
// 设置 HTTP 响应消息的状态码
setStatus(int status)
sendError(int status)       // 发送表示错误信息的状态码


// 发送响应消息头相关方法
addHeader(String name, String value)        // addHeader() 方法可以增加同名的响应头字段
setHeader(String name, String value)        // setHeader() 方法则会覆盖同名的头字段
setContentType(String type)                 // 用于设置Servlet输出内容的 MIME 类型，定义网络文件的类型和网页的编码；Servlet默认为text/plain
    1. text/html                // HTML 格式
    2. text/plain               // 纯文本格式
    3. text/xml                 // XML 格式
    4. image/gif                // gif 图片格式
    5. image/jpeg               // jpg 图片格式
    6. image/png                // png 图片格式
    7. application/json         // JSON 数据格式
    8. application/pdf          // pdf 格式
    9. application/msword       // Word 文档格式
    10. application/octet-stream                        // 二进制流数据
    11. application/vnd.ms-excel、application/x-xls     // XLS 文档格式
    12. application/x-www-form-urlencoded               // <form encType="">中默认的 encType，form 表单数据被编码为 key/value 格式发送到服务器（表单默认的提交数据的格式）
    13. multipart/form-data                             // 需要在表单中进行文件上传时，就需要使用该格式
    14. video/mpeg4                                     // mp4 音频格式

Content-Disposition

// 消息体相关方法
getOutputStream()        // 获取字节输出流对象（ServletOutputStream），直接输出字节数组中的二进制数据
getWriter()              // 获取字符输出流对象（PrintWriter ），直接输出字符文本内容
```

#### Access-Control-Expose-Headers

默认情况下，响应消息头只有七个作为响应的一部分暴露给外部，如果客户端想要访问其他的属性，则需要将他们暴露出来

response.addHeader("Access-Control-Expose-Headers", <header-name>,<header-name>);

## 2. 文件导出方案

1. 后端返回二进制文件，前端通过 blob 数据格式接收，并通过构建 a 链接 URL 的方式实现文件的下载
