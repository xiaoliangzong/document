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
