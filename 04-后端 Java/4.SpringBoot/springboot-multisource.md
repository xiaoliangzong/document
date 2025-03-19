# Spring Boot 多数据源

在项目中，我们可能会碰到需要多数据源的场景。例如说：

- 读写分离：数据库主节点压力比较大，需要增加从节点提供读操作，以减少压力。使用多数据源实现的读写分离操作，需要开发人员自行判断执行的sql是读还是写。如果使用了数据库访问层中间件，通常会有中间件来实现读写分离的逻辑，对业务更加透明。
- 多数据源：一个复杂的单体项目，因为没有拆分成不同的服务，需要连接多个业务的数据源。

本质上，读写分离，仅仅是多数据源的一个场景，从节点是只提供读操作的数据源。所以只要实现了多数据源的功能，也就能够提供读写分离。

## 1. 实现方案

### 1.1 方案一：基于 Spring AbstractRoutingDataSource 做拓展

通过继承 AbstractRoutingDataSource 抽象类，实现一个管理项目中多个 DataSource 的动态 DynamicRoutingDataSource 实现类。这样，Spring 在获取数据源时，可以通过 DynamicRoutingDataSource 返回实际的 DataSource 。

然后，我们可以自定义一个 @DS 注解，可以添加在 Service 方法、Dao 方法上，表示其实际对应的 DataSource 。

如此，整个过程就变成，执行数据操作时，通过“配置”的 @DS 注解，使用 DynamicRoutingDataSource 获得对应的实际的 DataSource 。之后，在通过该 DataSource 获得 Connection 连接，最后发起数据库操作。

这种方式在结合 Spring 事务的时候，会存在无法切换数据源的问题。

baomidou 提供的 dynamic-datasource-spring-boot-starter 。 就是采用此方式。

### 1.2 方案二：不同操作类，固定数据源

以 MyBatis 举例子，假设有 orders 和 users 两个数据源。 那么我们可以创建两个 SqlSessionTemplate ordersSqlSessionTemplate 和 usersSqlSessionTemplate ，分别使用这两个数据源。

然后，配置不同的 Mapper 使用不同的 SqlSessionTemplate 。

如此，整个过程就变成，执行数据操作时，通过 Mapper 可以对应到其 SqlSessionTemplate ，使用 SqlSessionTemplate 获得对应的实际的 DataSource 。之后，在通过该 DataSource 获得 Connection 连接，最后发起数据库操作。

### 1.3 方案三：分库分表中间件

对于分库分表的中间件，会解析我们编写的 SQL ，路由操作到对应的数据源。那么，它们天然就支持多数据源。如此，我们仅需配置好每个表对应的数据源，中间件就可以透明的实现多数据源或者读写分离。

目前，Java 最好用的分库分表中间件，就是 Apache ShardingSphere 。

那么，这种方式在结合 Spring 事务的时候，会不会存在无法切换数据源的问题呢？答案是不会。在上述的方案一和方案二中，在 Spring 事务中，会获得对应的 DataSource ，再获得 Connection 进行数据库操作。而获得的 Connection 以及其上的事务，会通过 ThreadLocal 的方式和当前线程进行绑定。这样，就导致我们无法切换数据源。

难道分库分表中间件不也是需要 Connection 进行这些事情么？答案是的，但是不同的是分库分表中间件返回的 Connection 返回的实际是动态的 DynamicRoutingConnection ，它管理了整个请求（逻辑）过程中，使用的所有的 Connection ，而最终执行 SQL 的时候，DynamicRoutingConnection 会解析 SQL ，获得表对应的真正的 Connection 执行 SQL 操作。

那么，分库分表中间件就是多数据源的完美方案落？从一定程度上来说，是的。但是，它需要解决多个 Connection 可能产生的多个事务的一致性问题，也就是我们常说的，分布式事务。


## 2 示例：baomidou 多数据源使用

### 2.1 引入依赖

```xml
<!-- 实现对 dynamic-datasource 的自动化配置 -->
<dependency>
    <groupId>com.baomidou</groupId>
    <artifactId>dynamic-datasource-spring-boot-starter</artifactId>
    <version>2.5.7</version>
</dependency>
```

#### 2.2 主启动类添加注解

- 添加 @MapperScan 注解，包路径就是我们 Mapper 接口所在的包路径。
- 添加 @EnableAspectJAutoProxy 注解，重点是配置 exposeProxy = true ，因为我们希望 Spring AOP 能将当前代理对象设置到 AopContext 中。


#### 2.3 编写配置文件

```yaml
spring:
  datasource:
    # dynamic-datasource-spring-boot-starter 动态数据源的配置内容
    dynamic:
      primary: users # 设置默认的数据源或者数据源组，默认值即为 master
      strict: false  # 是否启用严格模式,默认不启动. 严格模式下未匹配到数据源直接报错, 非严格模式下则使用默认数据源primary所设置的数据源
      datasource:
        # 订单 orders 数据源配置
        orders:
          url: jdbc:mysql://127.0.0.1:3306/test_orders?useSSL=false&useUnicode=true&characterEncoding=UTF-8
          driver-class-name: com.mysql.jdbc.Driver
          username: root
          password:
        # 用户 users 数据源配置
        users:
          url: jdbc:mysql://127.0.0.1:3306/test_users?useSSL=false&useUnicode=true&characterEncoding=UTF-8
          driver-class-name: com.mysql.jdbc.Driver
          username: root
          password:

# mybatis 配置内容
mybatis:
  #config-location: classpath:mybatis-config.xml # 配置 MyBatis 配置文件路径
  mapper-locations: classpath:mapper/*.xml # 配置 Mapper XML 地址
  type-aliases-package: cn.iocoder.springboot.lab17.dynamicdatasource.dataobject # 配置数据库实体包路径
  configuration:
    map-underscore-to-camel-case: true  
```

#### 2.4 编写代码

- 编写实体类
- 定义 DBConstants 常量类，定义 DATASOURCE_ORDERS 和 DATASOURCE_USERS 两个数据源
- 编写 Mapper 接口，并使用 @DS 注解。@DS 注解，是 dynamic-datasource-spring-boot-starter 提供，可添加在 Service 或 Mapper 的类/接口上，或者方法上。在其 value 属性中，填写数据源的名字。
- 编写 Mapper.xml 文件。

```java
// OrderMapper.java
@Repository
@DS(DBConstants.DATASOURCE_ORDERS)
public interface OrderMapper {

    OrderDO selectById(@Param("id") Integer id);

}

// UserMapper.java
@Repository
@DS(DBConstants.DATASOURCE_USERS)
public interface UserMapper {

    UserDO selectById(@Param("id") Integer id);

}
```

#### 2.5 测试用例

##### 场景一

```java
@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;

    public void method01() {
        // 查询订单
        OrderDO order = orderMapper.selectById(1);
        System.out.println(order);
        // 查询用户
        UserDO user = userMapper.selectById(1);
        System.out.println(user);
    }
}
```

- 方法未使用 @Transactional 注解，不会开启事务。
- 对于 OrderMapper 和 UserMapper 的查询操作，分别使用其接口上的 @DS 注解，找到对应的数据源，执行操作。

##### 场景二

```java
@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;

    @Transactional
    public void method02() {
        // 查询订单
        OrderDO order = orderMapper.selectById(1);
        System.out.println(order);
        // 查询用户
        UserDO user = userMapper.selectById(1);
        System.out.println(user);
    }
}
```

- 和 #method01() 方法，差异在于，方法上增加了 @Transactional 注解，声明要使用 Spring 事务。
- 执行方法，抛异常：Caused by: com.mysql.jdbc.exceptions.jdbc4.MySQLSyntaxErrorException: Table 'test_users.orders' doesn't exist

原因：

- 和 Spring 事务的实现机制有关系。因为方法添加了 @Transactional 注解，Spring 事务就会生效。此时，Spring TransactionInterceptor 会通过 AOP 拦截该方法，创建事务。而创建事务，势必就会获得数据源。那么，TransactionInterceptor 会使用 Spring DataSourceTransactionManager 创建事务，并将事务信息通过 ThreadLocal 绑定在当前线程。
- 而事务信息，就包括事务对应的 Connection 连接。那也就意味着，还没走到 OrderMapper 的查询操作，Connection 就已经被创建出来了。并且，因为事务信息会和当前线程绑定在一起，在 OrderMapper 在查询操作需要获得 Connection 时，就直接拿到当前线程绑定的 Connection ，而不是 OrderMapper 添加 @DS 注解所对应的 DataSource 所对应的 Connection 。
- 现在可以把问题聚焦到 DataSourceTransactionManager 是怎么获取 DataSource 从而获得 Connection 的了。对于每个 DataSourceTransactionManager 数据库事务管理器，创建时都会传入其需要管理的 DataSource 数据源。在使用 dynamic-datasource-spring-boot-starter 时，它创建了一个 DynamicRoutingDataSource ，传入到 DataSourceTransactionManager 中。
- 而 DynamicRoutingDataSource 负责管理我们配置的多个数据源。例如说，本示例中就管理了 orders、users 两个数据源，并且默认使用 users 数据源。那么在当前场景下，DynamicRoutingDataSource 需要基于 @DS 获得数据源名，从而获得对应的 DataSource ，结果因为我们在 Service 方法上，并没有添加 @DS 注解，所以它只好返回默认数据源，也就是 users 。故此，就发生了 Table 'test_users.orders' doesn't exist 的异常。


DataSourceTransactionManager 不支持分布式事务。事务管理实际上是与 Connection 绑定的，而 Connection 又是从某个 DataSource 中获得的。一个 DataSource 只能操作一个库，由于我们在配置 spring 事务管理器 DataSourceTransactionManager 时，指定了某个 DataSource，显然意味着其只能对某个库进行事务操作。

对于添加了@Transactional注解的方法，在方法执行之前，Spring已经通过DataSource获取到Connection，并开启了事务，在整个事务方法执行结束前，一直都是使用这个Connection，无法进行切换。


Spring 事务的实现机制，推荐可以尝试将 TransactionInterceptor 作为入口，进行调试。

##### 场景三

```java
@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;

    private OrderService self() {
        return (OrderService) AopContext.currentProxy();
    }

    public void method03() {
        // 查询订单
        self().method031();
        // 查询用户
        self().method032();
    }

    @Transactional // 报错，因为此时获取的是 primary 对应的 DataSource ，即 users 。
    public void method031() {
        OrderDO order = orderMapper.selectById(1);
        System.out.println(order);
    }

    @Transactional
    public void method032() {
        UserDO user = userMapper.selectById(1);
        System.out.println(user);
    }
}
```

- 执行方法，抛异常：Table 'test_users.orders' doesn't exist
- 其实场景三和场景二等价。
- 如果将 self() 代码替换成 this 之后，诶，结果就正常执行。因为 this 不是代理对象，所以 #method031() 和 #method032() 方法上的 @Transactional 直接没有作用，Spring 事务根本没有生效。


##### 场景四

```java
@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;

    private OrderService self() {
        return (OrderService) AopContext.currentProxy();
    }

    public void method04() {
        // 查询订单
        self().method041();
        // 查询用户
        self().method042();
    }

    @Transactional
    @DS(DBConstants.DATASOURCE_ORDERS)
    public void method041() {
        OrderDO order = orderMapper.selectById(1);
        System.out.println(order);
    }

    @Transactional
    @DS(DBConstants.DATASOURCE_USERS)
    public void method042() {
        UserDO user = userMapper.selectById(1);
        System.out.println(user);
    }
}
```

- 和场景三，差异在于，#method041() 和 #method042() 方法上，添加 @DS 注解，声明对应使用的 DataSource 。
- 执行方法，正常结束，未抛出异常。
- 在执行 #method041() 方法前，因为有 @Transactional 注解，所以 Spring 事务机制触发。DynamicRoutingDataSource 根据 @DS 注解，获得对应的 orders 的 DataSource ，从而获得 Connection 。所以后续 OrderMapper 执行查询操作时，即使使用的是线程绑定的 Connection ，也可能不会报错。实际上，此时 OrderMapper 上的 @DS 注解，也没有作用。
- 对于 #method042() ，也是同理。但是，我们上面不是提了 Connection 会绑定在当前线程么？那么，在 #method042() 方法中，应该使用的是 #method041() 的 orders 对应的 Connection 呀。在 Spring 事务机制中，在一个事务执行完成后，会将事务信息和当前线程解绑。所以，在执行 #method042() 方法前，又可以执行一轮事务的逻辑。

##### 场景五

```java
@Service
public class OrderService {

    @Autowired
    private OrderMapper orderMapper;
    @Autowired
    private UserMapper userMapper;

    private OrderService self() {
        return (OrderService) AopContext.currentProxy();
    }

    @Transactional
    @DS(DBConstants.DATASOURCE_ORDERS)
    public void method05() {
        // 查询订单
        OrderDO order = orderMapper.selectById(1);
        System.out.println(order);
        // 查询用户
        self().method052();
    }

    @Transactional(propagation = Propagation.REQUIRES_NEW)
    @DS(DBConstants.DATASOURCE_USERS)
    public void method052() {
        UserDO user = userMapper.selectById(1);
        System.out.println(user);
    }
}
```

- 和 @method04() 方法，差异在于，我们直接在 #method05() 方法中，此时处于一个事务中，直接调用了 #method052() 方法。
- 执行方法，正常结束，未抛出异常。
- #method052() 方法，我们添加的 @Transactionl 注解，使用的事务传播级别是 Propagation.REQUIRES_NEW 。此时，在执行 #method052() 方法之前，TransactionInterceptor 会将原事务挂起，暂时性的将原事务信息和当前线程解绑。所以，在执行 #method052() 方法前，又可以执行一轮事务的逻辑。之后，在执行 #method052() 方法完成后，会将原事务恢复，重新将原事务信息和当前线程绑定。
- 编写这个场景的目的，是为了说明使用方案一，在事务中时，如何切换数据源。当然，一旦切换数据源，可能产生多个事务，就会碰到多个事务一致性的问题，也就是分布式事务。


## 3 示例： baomidou 读写分离

在 dynamic-datasource-spring-boot-starter 中，多个相同角色的数据源可以形成一个数据源组。判断标准是，数据源名以下划线 _ 分隔后的首部即为组名。例如说，slave_1 和 slave_2 形成了 slave 组。

- 我们可以使用 @DS("slave_1") 或 @DS("slave_2") 注解，明确访问数据源组的指定数据源。
- 也可以使用 @DS("slave") 注解，此时会负载均衡，选择分组中的某个数据源进行访问。目前，负载均衡默认采用轮询的方式。

## 4 示例：MyBatis 多数据源

基于方案二【不同操作类，固定数据源】的方式，实现 MyBatis 多数据源。

在配置文件 spring.datasource 下，配置多个数据源。然后编写配置类，注入不同的 DataSource、SqlSessionFactory、SqlSessionTemplate、 PlatformTransactionManager 。  

下边示例5是详细的配置说明。

## 5. 示例：多数据源配置（mysql和TDengine）

### 5.1 引入依赖

```xml
<!--数据源-->
<dependency>
    <groupId>com.alibaba</groupId>
    <artifactId>druid-spring-boot-starter</artifactId>
    <version>1.1.21</version>
</dependency>


<!-- mysql -->
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
</dependency>

<!--TDengine-->
<dependency>
    <groupId>com.taosdata.jdbc</groupId>
    <artifactId>taos-jdbcdriver</artifactId>
    <version>3.0.4</version>
    <exclusions>
        <exclusion>
            <artifactId>fastjson</artifactId>
            <groupId>com.alibaba</groupId>
        </exclusion>
        <exclusion>
            <artifactId>jsr305</artifactId>
            <groupId>com.google.code.findbugs</groupId>
        </exclusion>
    </exclusions>
</dependency>
```

### 5.2 创建 mysql 配置文件

```java
package com.java.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = {"com.java.mapper.mysql（这里改成你自己的）"}, sqlSessionTemplateRef  = "mysqlSqlSessionTemplate")
public class MysqlServerConfig {
    @Bean(name = "mysqlDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.mysql-server")
    @Primary
    public DataSource mysqlDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "mysqlSqlSessionFactory")
    @Primary
    public SqlSessionFactory mysqlSqlSessionFactory(@Qualifier("mysqlDataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources("classpath*:mapper/**/*.xml"));
        return bean.getObject();
    }

    @Bean(name = "mysqlTransactionManager")
    @Primary
    public DataSourceTransactionManager mysqlTransactionManager(@Qualifier("mysqlDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "mysqlSqlSessionTemplate")
    @Primary
    public SqlSessionTemplate mysqlSqlSessionTemplate(@Qualifier("mysqlSqlSessionFactory") SqlSessionFactory sqlSessionFactory)  {
        return new SqlSessionTemplate(sqlSessionFactory);
    }
}
```

### 5.3 创建 TDengine 配置文件

```java
package com.java.config;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

import javax.sql.DataSource;

@Configuration
@MapperScan(basePackages = {"com.java.mapper.tdengine（这里换成你自己的）"}, sqlSessionTemplateRef  = "tdengineSqlSessionTemplate")
public class TDengineServerConfig {
    @Bean(name = "tdengineDataSource")
    @ConfigurationProperties(prefix = "spring.datasource.tdengine-server")
    public DataSource tdengineDataSource() {
        return DataSourceBuilder.create().build();
    }

    @Bean(name = "tdengineSqlSessionFactory")
    public SqlSessionFactory tdengineSqlSessionFactory(@Qualifier("tdengineDataSource") DataSource dataSource) throws Exception {
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        bean.setMapperLocations(new PathMatchingResourcePatternResolver().getResources("classpath*:mapper/**/*.xml"));
        return bean.getObject();
    }

    @Bean(name = "tdengineTransactionManager")
    public DataSourceTransactionManager tdengineTransactionManager(@Qualifier("tdengineDataSource") DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }

    @Bean(name = "tdengineSqlSessionTemplate")
    public SqlSessionTemplate tdengineSqlSessionTemplate(@Qualifier("tdengineSqlSessionFactory") SqlSessionFactory sqlSessionFactory) throws Exception {
        return new SqlSessionTemplate(sqlSessionFactory);
    }

}
```

### 5.4 编写 yaml 配置文件

```yml
spring:
  redis:
    database: 0
    host: 127.0.0.1
    port: 6379
    password: 112233
  datasource:
    mysql-server:
      driverClassName: com.mysql.cj.jdbc.Driver
      jdbc-url: jdbc:mysql://127.0.0.1:3306/orchard?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&allowMultiQueries=true&useSSL=false&serverTimezone=Asia/Shanghai
      username: root
      password: root
      type: com.zaxxer.hikari.HikariDataSource      # Hikari连接池的设置
      minimum-idle: 5                 #最小连接
      maximum-pool-size: 15        #最大连接
      auto-commit: true        #自动提交
      idle-timeout: 30000        #最大空闲时常
      pool-name: DatebookHikariCP        #连接池名
      max-lifetime: 1800000        #最大生命周期
      connection-timeout: 30000        #连接超时时间
    tdengine-server:
      jdbc-url: jdbc:TAOS://XXXXXX:6030/aiidata?timezone=Asia/Shanghai&charset=utf-8
      username: root
      password: XXXXXXX
      type: com.zaxxer.hikari.HikariDataSource      # Hikari连接池的设置
      minimum-idle: 5                 #最小连接
      maximum-pool-size: 15        #最大连接
      auto-commit: true        #自动提交
      idle-timeout: 30000        #最大空闲时常
      pool-name: TDengineHikariCP        #连接池名
      max-lifetime: 1800000        #最大生命周期
      connection-timeout: 30000        #连接超时时间
      connection-test-query: select server_status() # tdengine show tables有兼容性问题，官方使用的是select server_status()

```

### 5.5 正常创建CRUD就可以了

注意： 经过上述配置就不用再使用 @Mapper 注解和在启动类上使用 @MapperScan("com.java.mapper.mysql") 注解了
