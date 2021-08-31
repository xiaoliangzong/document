# 插件

## Lombok

> IntelliJ IDEA 使用时，必须安装插件

1. @Accessors 注解：链式编程
   - @Accessors(fluent = true)，使用 fluent 属性，getter 和 setter 方法的方法名都是属性名，且 setter 方法返回当前对象
   - @Accessors(chain = true)，使用 chain 属性，setter 方法返回当前对象
   - @Accessors(prefix = "tb")，使用 prefix 属性，getter 和 setter 方法会忽视属性名的指定前缀（遵守驼峰命名）
2. @Data，注在类上，提供类的 get、set、equals、hashCode、canEqual、toString 方法
3. @AllArgsConstructor，注在类上，提供类的全参构造
4. @NoArgsConstructor，注在类上，提供类的全参构造
5. @Setter ： 注在属性上，提供 set 方法
6. @Getter ： 注在属性上，提供 get 方法
7. @EqualsAndHashCode ： 注在类上，提供对应的 equals 和 hashCode 方法，默认仅使用该类中定义的属性且不调用父类的方法，通过 callSuper=true，让其生成的方法中调用父类的方法。
8. @Log4j/@Slf4j ： 注在类上，提供对应的 Logger 对象，变量名为 log

> 通过官方文档，可以得知，当使用@Data 注解时，则有了@EqualsAndHashCode 注解，那么就会在此类中存在 equals(Object other) 和 hashCode()方法，且不会使用父类的属性，这就导致了可能的问题。
> 比如，有多个类有相同的部分属性，把它们定义到父类中，恰好 id（数据库主键）也在父类中，那么就会存在部分对象在比较时，它们并不相等，却因为 lombok 自动生成的 equals(Object other) 和 hashCode()方法判定为相等，从而导致出错。
> 修复此问题的方法很简单：
>  1. 使用@Getter @Setter @ToString 代替@Data 并且自定义 equals(Object other) 和 hashCode()方法，比如有些类只需要判断主键 id 是否相等即足矣。
>  2. 或者使用在使用@Data 时同时加上@EqualsAndHashCode(callSuper=true)注解。

## 太平洋网站地址 ip 信息获取,太平洋网络 IP 地址查询 Web 接口

http://whois.pconline.com.cn/

## 浏览器解析工具：UserAgentUtils
   
> 可以获取浏览器信息，操作系统信息
   
   ```xml
   <dependency>
       <groupId>eu.bitwalker</groupId>
       <artifactId>UserAgentUtils</artifactId>
       <version>1.21</version>
   </dependency>
   ```
   
 ```java
   String agent=request.getHeader("User-Agent");
   //解析agent字符串
   UserAgent userAgent = UserAgent.parseUserAgentString(agent);
   //获取浏览器对象
   Browser browser = userAgent.getBrowser();
   //获取操作系统对象
   OperatingSystem operatingSystem = userAgent.getOperatingSystem();
   
   System.out.println("浏览器名:"+browser.getName());
   System.out.println("浏览器类型:"+browser.getBrowserType());
   System.out.println("浏览器家族:"+browser.getGroup());
   System.out.println("浏览器生产厂商:"+browser.getManufacturer());
   System.out.println("浏览器使用的渲染引擎:"+browser.getRenderingEngine());
   System.out.println("浏览器版本:"+userAgent.getBrowserVersion());
   
   System.out.println("操作系统名:"+operatingSystem.getName());
   System.out.println("访问设备类型:"+operatingSystem.getDeviceType());
   System.out.println("操作系统家族:"+operatingSystem.getGroup());
   System.out.println("操作系统生产厂商:"+operatingSystem.getManufacturer());
```
3. Random、ThreadLocalRandom、SecureRandom

1. Random：伪随机数，通过种子生成随机数，种子默认使用系统时间，可预测，安全性不高，线程安全；
2. ThreadLocalRandom：jdk7 才出现的，多线程中使用，虽然 Random 线程安全，但是由于 CAS 乐观锁消耗性能，所以多线性推荐使用
3. SecureRandom：可以理解为 Random 升级，它的种子选取比较多，主要有：时间，cpu，使用情况，点击事件等一些种子，安全性高；特别是在生成验证码的情况下，不要使用 Random，因为它是线性可预测的。所以在安全性要求比较高的场合，应当使用 SecureRandom。

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

## 5. GFM 语法

> Github Flavored Markdown，是 github 改进过的 markdown，用易读简洁的纯文本方式编写 html。

## 6. sonar 代码检查工具使用：

### 6.1 docker 安装

1. 安装 mysql 或 postgres（pgsql）；启动容器
   - docker run -it --name mysql-sonar -p 3306:3306 -v /opt/sonar/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:latest
2. 设置一个 sonar 的用户，分配一定的权限，需要注意的是，在容器里边通过命令行操作。在宿主机上无法登录数据库
   - 设置用户时，注意鉴权参数：从 MySQL 8.0.4 开始, 默认的认证插件从 mysql_native_password 变为 caching_sha2_password
     alter user 'root'@'localhost' identified by 'root' password expire never;
     alter user 'root'@'localhost' identified with mysql_native_password by 'root'
     flush privileges;
3. 下载 sonarqube，docker pull sonarqube，7.9 版本之后不支持 mysql！！！
4. docker run -it --name sonarqube -p 9000:9000 -p 9092:9092 --link=mysql-sonar:mysql-sonar -v /opt/sonar/sonarqube/data:/opt/sonarqube/data -v /opt/sonar/sonarqube/extensions:/opt/sonarqube/extensions -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL="jdbc:mysql://192.168.100.46:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" sonarqube:7.8-community

5. postgres 数据库：
   docker pull postgres:10.4
   docker pull sonarqube:7.1 6.7.3
   docker run -it --name sonarqube --link postgres -e SONAQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar -p 9000:9000 -v /opt/sonar/sonarqube/data:/opt/sonarqube/data -v /opt/sonar/sonarqube/extensions:/opt/sonarqube/extensions sonarqube:7.8-community

6. 使用：
   - 方案 1：根据页面提示，创建用户名密码，选择编程语言，版本控制工具，生成一个 maven 命令；
     mvn sonar:sonar -Dsonar.host.url=https://localhost:9000 -Dsonar.login=0c9cc0b3b23cdecbb58e8fcd0929e99aa3bec050
   - 方案 2：修改 maven 的 setting 文件

```xml
<!-- pom文件添加如下内容(注意,jdk版本必须是jdk1.8) -->
<!-- <profiles>标签下添加如下内容 -->
<profile>
    <id>sonar</id>
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
    <properties>
        <!-- 配置 Sonar Host地址，默认：http://localhost:9000 -->
        <sonar.host.url>
          http://10.100.28.186:9000
        </sonar.host.url>
    </properties>
</profile>
<!--pom文件添加如下内容(注意,jdk版本必须是jdk1.8) -->
<build>
   <plugins>
       <plugin>
           <groupId>org.sonarsource.scanner.maven</groupId>
           <artifactId>sonar-maven-plugin</artifactId>
           <version>3.1.1</version>
       </plugin>
   </plugins>
</build>

<!-- 执行命令：mvn clean install sonar:sonar -->
```

    - 方案 3：使用sonar-scanner工具

## 7. nexus-repository-manager

### 7.1 上传

```xml
<!-- 一般，仓库的下载和部署是在pom.xml文件中的repositories和distributionManagement元素中定义的，然而，一般类似于用户名，密码等信息不应该在pom.xml文件配置中，这些信息可以配置在setting.xml中 -->
<!-- maven设置私服对应的信息：id、用户、密码，其中，id必须和distrubutionManagement的id相同 -->
<server>
    <id>db-maven-release</id>
    <username>admin</username>
    <password>admin123</password>
</server>
<server>
    <id>db-maven-snapshot</id>
    <username>admin</username>
    <password>admin123</password>
</server>

<!-- pom中增加url -->
<distributionManagement>
    <repository>
        <id>db-maven-release</id>   <!-- id的名字可以任意取，但是在setting文件中的属性<server>的ID与这里一致 -->
        <name>libs-release</name>
        <url>http://192.168.100.99:8081/repository/db-maven-hosted/</url>
    </repository>
    <snapshotRepository>
        <id>db-maven-snapshot</id>
        <name>libs-snapshot</name>
        <url>http://192.168.100.99:8081/repository/db-maven-snapshot/</url>
    </snapshotRepository>
</distributionManagement>

<!-- 执行maven clean deploy -->
```

### 7.2 下载，只需要在 settings 中配置

```xml
<!-- id和下面的mirror中的id一致，代表拉取是也需要进行身份校验；下载私服仓库镜像不需要身份验证!!! -->
<server>
    <id>nexus-db</id>
    <username>admin</username>
    <password>admin123</password>
</server>

<!-- 配置镜像 -->
<mirror>
    <id>nexus-db</id>
    <name>internal nexus repository</name>
    <mirrorOf>central</mirrorOf>
    <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
</mirror>


<!-- profiles节点，<profiles>里配置了多个<profile>，需要使用<activeProfiles>来进行激活，激活了哪个<profile>，哪个<profile>才生效 -->
<profile>
    <!--profile的id-->
    <id>nexus-profile</id>

    <!-- 远程仓库列表 -->
    <repositories>
        <repository>
        <!--仓库id，repositories可以配置多个仓库，保证id不重复-->
        <id>nexus-db</id>
        <!--仓库地址，即nexus仓库组的地址-->
        <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
        <!--是否下载releases构件-->
        <releases>
            <enabled>true</enabled>
        </releases>
        <!--是否下载snapshots构件-->
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        </repository>
    </repositories>

    <!-- 插件仓库列表 -->
    <pluginRepositories>
        <!-- 插件仓库，maven的运行依赖插件，也需要从私服下载插件 -->
        <pluginRepository>
            <!-- 插件仓库的id不允许重复，如果重复后边配置会覆盖前边 -->
            <id>nexus-db</id>
            <name>Public Repositories</name>
            <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
            <layout>default</layout>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </pluginRepository>
    </pluginRepositories>
</profile>

<!-- 必须激活，否则profiles中相关配置不起效果 -->
<activeProfiles>
    <activeProfile>nexusProfile</activeProfile>
    <activeProfile>jdk-1.8</activeProfile>
</activeProfiles>
```

## 四、http 和 https

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

## 5 . docsify 文档网站生成器

1. npm install docsify -g # 全局安装
2. docsify init ./docs # 初始化项目

   - 初始化成功后，可以看到 ./docs 目录下创建的几个文件
     - index.html 入口文件
     - README.md 会做为主页内容渲染，更新网站内容
     - .nojekyll 用于阻止 GitHub Pages 会忽略掉下划线开头的文件

3. docsify serve docs # 运行
4. http://localhost:3000 # 访问
5. 配置 index.html

```javascript
<script>
    window.$docsify = {
      name: '葵花宝典',
      // window.$docsify 的 repo 参数配置仓库地址或者 username/repo 的字符串，会在页面右上角渲染一个 GitHub Corner 挂件
      repo: 'https://github.com/Hanxueqing/Douban-Movie.git',
      // coverpage 参数设置开启渲染封面，封面内容：在文档根目录创建 \_coverpage.md 文件，在文档中编写需要展示在封面的内容
      coverpage: true
    }
</script>
```
