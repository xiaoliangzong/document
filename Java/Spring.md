## 1. 概述

Spring 是一个分层的轻量级开源框架，为了解决企业级应用开发的复杂性而创建的。

**特点**

1. `方便解耦，简化开发；`IOC 容器实例化对象、管理依赖关系，降低层与层之间的关联耦合程度，bean 的各种操作。
2. `AOP 面向切面编程；`可以实现对程序进行权限拦截、日志记录、运行监控等功能
3. `支持声明式事务；`只需要通过配置就可以完成对事务的管理，而无需手动编程
4. `集成测试；`Spring 对 Junit4 支持，可以通过注解方便的测试 Spring 程序
5. `方便集成各种优秀框架；`
6. `降低 JavaEE API 的使用难度；`Spring 对 JavaEE 开发中非常难用的一些 API 都提供了封装，使这些 API 应用难度大大降低

## 2. 模块结构

Spring 框架是一个分层架构，它包含了很多模块，每个模块完成不同的功能，常用的模块如下：

![spring-module](../public/images/Java/Spring/spring-module.png)

### 2.1 Core Container

- Core 模块：主要包含 Spring 框架基本的核心工具类，是其他组件的基本核心，Spring 其他组件都会使用到这个包里的类；
- Beans 模块：是所有应用都要用到的，它包含访问配置文件、创建和管理 bean 以及进行 IoC\DI 操作相关的所有类；
- Context 模块：构建与 Core 和 Bean 模块基础之上的，提供了一种框架式的对象访问方法，Context 模块集成了 Beans 的特性，为 Spring 核心提供大量扩展，添加了对国际化、事件传播、资源加载和对 Context 的透明创建的支持；
- Expression Language 模块：提供了一个强大的表达式语言用于在运行时查询和操纵对象；

### 2.2 AOP

- Aspects 模块：对 AspectJ 的集成支持
- Instrumentation 模块：提供了 class instrumentation 支持和 classloader 实现，使得可以在特定的应用服务器上使用

### 2.3 Test

### 2.4 Data Access/Integration

- JDBC 模块：提供了一个 JDBC 抽象层，它可以消除冗长的 JDBC 编码和解析数据库厂商特有的错误代码，包含了对 JDBC 数据访问进行封装的所有类；
- ORM 模块：对象关系映射 API，提供了一个交互层，利用 ORM 封装包，可以混合使用所有 Sping 提供的特性进行 O/R 映射；
- OXM 模块：一个对 Object/XML 映射实现的抽象层，Object/XML 映射实现包括 JAXB、Castor、XMLBeans、JiBX 和 XSteam；
- Java Messaging Service(JMS) 模块：主要包含了一些制造和消费消息的特性；
- Transaction 模块：支持编程和声明性的事务管理，这些事务类必须实现特定的接口，并且对所有的 POJO 都适用；

### 2.5 Web（MVC/Remoting）

- Web 模块：提供了基础的面向 Web 的集成特性，例如多文件上传、使用 servlet listeners 初始化 IoC 容器等；
- Web-Servlet 模块：包含 MVC 框架的实现；
- Web-Struts 模块：提供对 Struts 的支持；
- Web-Portlet 模块：提供用于 Portlet 环境和 Web-Servlet 模块的 MVC 的实现；

## 3. IOC/DI

`1. IOC 控制反转（Inversion Of Control），站在调用者（对象）的角度，创建被调用的实例不是由调用者完成，而是由 IOC 容器完成并注入。简单说，就是创建对象的控制权被反转到 Spring 框架。`  
`2. DI 依赖注入（Dependency Injection），站在 Spring 容器的角度，指一个对象依赖的其他对象会通过被动的方式传递进来，是在容器实例化对象的时候不等对象请求就主动将它依赖的类注入给它，而不是自己创建或从容器中查找它依赖的对象。`

**区别**

从不同角度对同一件事物的描述。就是通过引入 IOC 容器，利用注入依赖关系的方式，实现对象之间的解耦。

**核心说明（重点）**

1. BeanFactory 是 Spring IOC 容器的基本实现，是一个工厂接口，面向 Spring 本身；采用延迟加载，第一次 getBean 时才会初始化 Bean。
2. ApplicationContext 是 BeanFactory 的子接口，面向使用 Spring 框架的开发者，几乎所有的应用场合都直接使用 ApplicationContext 而非底层的 BeanFactory；
   当配置文件被加载，就会进行对象实例化；它的功能更强大，提供了更多的高级特性，比如国际化处理、事件传递、Bean 自动装配、各种不同应用层的 Context 实现等。
3. ClassPathXmlApplicationContext 用于加载 classpath 下的 xml。
4. FileSystemXmlApplicationContext 用于加载指定盘符下的 xml。
5. 从 IOC 获取 Bean 对象，调用 applicationContext.getBean()方法。

### 3.1 实例化方式

1. 基于 xml 的装配，实例化方式包括构造方法、静态工厂、实例工厂三种；
2. 基于注解

|      注解      | 解释说明                                                                                                     | 使用场景                                                 |
| :------------: | ------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
|     @Bean      | 表示此方法返回的对象作为一个 bean 加入到 Spring IOC 容器中                                                   | 适用于导入第三方组件的类                                 |
| @Configuration | 声明该类为配置类，可替换 xml 配置文件，可以使用 @Component 替代，不过使用@Configuration 声明配置类更加语义化 | 常和@Bean 一起使用                                       |
|  @Repository   | 标识持久层组件                                                                                               |                                                          |
|    @Service    | 标识服务层/业务层组件                                                                                        |                                                          |
|  @Controller   | 标识表现层组件                                                                                               |                                                          |
|   @Component   | 标识组件                                                                                                     |                                                          |
| @ComponentScan | 扫描特定注解的组件，相当于 xml 的<context:component-scan>                                                    |                                                          |
|    @Import     | 通过快速导入的方式将实例加入到 Spring IOC 容器中，导入组件的 id 为全路径，                                   | 常用于其他框架整合 Spring 时，使用@Import 注解导入整合类 |

```xml
<?xml version="1.0" encoding="utf-8" ?>

<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
       					   http://www.springframework.org/schema/beans/spring-beans.xsd">
    <!-- 1. 默认构造 -->
    <bean id="" class=""></bean>

    <!-- 2. 静态工厂，常用于Spring整合其他框架（工具） -->
    <bean id="" class="工厂全限定类名" factory-method="静态方法"></bean>

    <!-- 3. 实例工厂，特例 （FactoryBean接口，具有工厂生成对象能力，只能生成特定的对象，比如 ProxyFactoryBean实现类，用于生成代理对象实例） -->
    <bean id="factoryId" class="工厂全限定类名"></bean>        <!-- 创建工厂实例 -->
    <bean id="" factory-bean="factoryId" factory-method="实例工厂方法"></bean>

    <!-- 组件扫描，扫描含有注解的类 -->
    <context:component-scan base-package="com.xxx"></context:component-scan>
</beans>
```

**@Import 详解**

1. 直接导入 class 数组
2. 实现 ImportSelector 接口的实现类

> 是 spring 导入外部配置的核心接口，在 springboot 的自动化配置和@Enablexxx（功能性注解）中起到了决定性的作用。
> ImportSelector 接口中，selectImports()方法作用是：选择并返回需要导入的类的名称；返回一个字符串数组，当在@Configuration 标注的 Class 上使用@Import 引入了一个 ImportSelector 实现类后，会把实现类中返回的 Class 名称都定义为
> DeferredImportSelector 接口集成 ImportSelector，延迟选择性导入，在装载 bean 时，需要等所有的@Configuration 都执行完毕后才会进行装载。

3. 实现 ImportBeanSelector 接口

```java
// 方式1
@Import({**.class,***.class})  // 导入的bean的全限定名
public class Test{}

// 方式2
// spring 底层使用较多，像Enablexxx等都是通过这种方式实现的。
public class ImportSee implements ImportSelector {
    @Override
    public String[] selectImports(AnnotationMetadata importingClassMetadata) {
        return new String[]{"com.company.module.类名"};
    }
}

// 方式3
// mybatis中的@MapperScan注解，就是基于这种方式实现注入Spring IOC容器的。
```

### 3.2 作用域

注解 @Scope 可以控制 Spring Bean 的作用域，四种常见的作用域：

|  作用域   | 解释说明                                                                      |
| :-------: | ----------------------------------------------------------------------------- |
| singleton | 唯一 bean 实例，Spring 中的 bean 默认都是单例的                               |
| prototype | 每次请求都会创建一个新的 bean 实例                                            |
|  request  | 每一次 HTTP 请求都会产生一个新的 bean，该 bean 仅当前 HTTP request 内有效     |
|  session  | 每一次 HTTP Session 会产生一个新的 bean，该 bean 仅在当前 HTTP session 内有效 |

```xml
<!-- 默认为单例singleton，多例时，初始化时，不会实例化bean，只有每次调用的时候才会实例化 -->
<bean id="" class="" scope="singleton|prototype|request|session"></bean>
```

### 3.3 生命周期

1. 基于 xml，Bean 标签存在 init-method 和 destroy-method 方法；

```xml
<!-- 针对单例的Bean，初始化执行init方法，容器关闭时，销毁执行destroy方法 -->
<bean id="" class="" init-method="初始化方法名称" destroy-method="销毁方法名称"></bean>

```

2.  实现接口 InitializingBean 和 DisposableBean，重写方法；
3.  实现接口 BeanPostProcessor，并将实现类提供给 spring 容器，spring 容器将自动执行，在初始化方法前执行 before()，在初始化方法后执行 after()。对容器中所有的 bean 都生效。
4.  基于注解@PostConstruct 和 @PreDestroy 实现；需要注意的是：@PostConstruct 和@PreDestroy 这两个注解都不是 Spring 的，是 java 的。
    - @PostConstruct：修饰的方法会在服务器加载 Servlet 的时候运行，并且只会被服务器调用一次，类似于 Servlet 的 init()方法。被@PostConstruct 修饰的方法会在构造函数之后，init()方法之前运行。
    - @PreDestroy：修饰的方法会在服务器卸载 Servlet 的时候运行，并且只会被服务器调用一次，类似于 Servlet 的 destroy()方法。被@PreDestroy 修饰的方法会在 destroy()方法之后运行，在 Servlet 被彻底卸载之前。

### 3.4 属性依赖注入

1. 基于 xml，可通过属性 setter 注入、构造器注入、p 标签、SpEL、集合方法实现
2. 基于注解

|      注解       | 解释说明                                                                                                                                                           | 使用场景                                                 |
| :-------------: | ------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------- |
|     @Value      |                                                                                                                                                                    |                                                          |
| @PropertySource | 读取指定 properties 文件                                                                                                                                           | 不常用，常用的是@ConfigurationProperties                 |
|  @Conditional   | 条件                                                                                                                                                               | 大量应用于 Spring Boot 底层，@ConfitionalOnClass 等      |
|   @Autowired    | 提供了更细粒度的控制，包括在何处以及如何完成自动装配。它的用法和@Required 一样，修饰 setter 方法、构造器、属性或者具有任意名称和/或多个参数的 PN 方法。            |
|   @Qualifier    | 当有多个相同类型的 bean 却只有一个需要自动装配时，将@Qualifier 注解和@Autowire 注解结合使用以消除这种混淆，指定需要装配的确切的 bean。                             |
|      @Lazy      | 容器一般都会在启动的时候实例化所有单实例 bean。如果想要 Spring 在启动的时候延迟加载 bean，即在调用某个 bean 的时候再去初始化，那么就使用 @Lazy 注解。              | @Lazy(value = true)，value 取值 true、false，默认为 true |
|    Required     | 表明 bean 的属性必须在配置的时候设置，通过一个 bean 定义的显式的属性值或通过自动装配，若@Required 注解的 bean 属性未被设置，容器将抛出 BeanInitializationException |

@AutoWired，类型注入；@Qualifier，名称注入  
@Resource，名称注入  
**Resource 和 Autowire**

![区别](../public/images/Java/Spring/ResourceAutowird.png)

**@AliasFor**

@AliasFor 表示别名，它可以注解到自定义注解的两个属性上，表示这两个互为别名，也就是说这两个属性其实同一个含义。

- 用到注解 属性上，表示两个属性互相为别名，互相为别名的属性值必须相同，若设置成不同，则会报错
- 若自定义注解有一个属性，且该属性命名上为了体现其含义，所以有些复杂，这样调用方必须每次使用自定义注解的时候，都必须写明 属性 ，然后设置，这样会比较负责；
- 同时若自定义注解继承了另一个注解，要想让调用方能够设置继承过来的属性值，就必须在自定义注解中重新定义一个属性，同时声明该属性是父注解某个属性的别名。注解是可以继承的，但是注解是不能继承父注解的属性的,也就是说,我在类扫描的时候,拿到的注解的属性值,依然是父注解的属性值,而不是你定义的注解的属性值，所以此时可以在子注解对应的属性上加上@AliasFor

```xml
<!--
    1. 属性注入
    通过set()方法注入属性值，
    使用<property>标签，name 属性指定 Bean 的属性名称，value 属性或<value>子节点指定属性值
-->
<bean id="" class="com.xxx">
    <property name="name" value="dangbo"></property>
    <property name="age">
        <value>18</value>
    </property>
    <property name="student" ref="studentId"></property>
    <property name="student">
        <ref bean="studentId"/>
    </property>
</bean>

<!--
    2. 构造器注入
    <constructor-arg> 用于配置构造方法一个参数argument；name参数的名称，value设置普通数据，ref引用数据，一般是另一个bean id值，
    index ：参数的索引号，从0开始 。如果只有索引，匹配到了多个构造方法时，默认使用第一个。
    type ：确定参数类型
-->
<bean>
    <constructor-arg name="" index="" type="" value=""></constructor-arg>
</bean>

<!--
    3. p 标签注入
    p命名空间使用前提，必须添加命名空间
    对setter方法注入进行简化，替换<property name="属性名">，而是在<bean p:属性名="普通值"  p:属性名-ref="引用值">
 -->
<bean id="personId" class="com.xxx.Person"
    p:name="dangbo" p:age="18"
    p:student-ref="studentId">
</bean>

<!--
    4. SpEL
    对<property>进行统一编程，所有的内容都使用value
	<property name="" value="#{表达式}">
	#{123}、#{'jack'} ： 数字、字符串
	#{beanId}	：另一个bean引用
	#{beanId.propName}	：操作数据
	#{beanId.toString()}	：执行方法
	#{T(类).字段|方法}	：静态方法或字段
 -->
<bean id="userId" class="com.xxx.User" >
    <property name="name" value="#{userId.name?.toUpperCase()}"></property>     <!-- ?. 如果对象不为null，将调用方法 -->
    <property name="age" value="#{18}"></property>
</bean>


<!--
    5. 集合注入
    集合的注入都是给<property>添加子标签，数组<array>，List<list>，Set<set>，Map<map>，map存放k/v 键值对，使用<entry>描述，Properties<props>
	普通数据<value>，引用数据<ref>
-->
<bean id="collDataId" class="com.xxx.CollData" >
    <property name="arrayData">
        <array>
            <value>1</value>
        </array>
    </property>

    <property name="listData">
        <list>
            <value>1</value>
        </list>
    </property>

    <property name="setData">
        <set>
            <value>1</value>
        </set>
    </property>

    <property name="mapData">
        <map>
            <entry key="1" value="1"></entry>
            <entry>
                <key>2</key>
                <value>2</value>
            </entry>
        </map>
    </property>

    <property name="propsData">
        <props>
            <prop key="1">1</prop>
        </props>
    </property>
</bean>
```

### 3.5 循环依赖解决方案

## 4. AOP

> AOP 模块提供了一个符合 AOP 联盟标准的面向切面编程的实现，它让你可以定义例如方法拦截器和切点，从而将逻辑代码分开，降低他们之间的耦合性。
> AOP 面向切面编程：允许程序模块化横向切割关注点，或横切典型的责任划分，如权限拦截、运行监控、日志和事务管理
> 执行顺序：around before、before、目标方法、around after、after、returning

1. 环绕通知 (@Around) 方法执行前后都通知（优先级最高的通知）
2. 前置通知 (@Before) 方法执行之前执行
3. 后置通知 (@After) : 又称之为最终通知(finally)
4. 返回通知 (@AfterReturning) 方法 return 之后执行
5. 异常通知 (@AfterThrowing) 方法出现异常之后执行

before：前置通知，在一个方法执行前被调用。

after: 在方法执行之后调用的通知，无论方法执行是否成功。

after-returning: 仅当方法成功完成后执行的通知。

after-throwing: 在方法抛出异常退出时执行的通知。

around: 在方法执行之前和之后调用的通知。

AOP 面向切面编程
切面:横切关注点被模块化的特数对象
通知:切面必须要完成的工作. 1.在 Spring 中启用 AspectJ 注解
Bean 配置文件中定义元素 <aop:aspectj-autoproxy>
<aop:aspectj-autoproxy proxy-target-class="true"></aop:aspectj-autoproxy> 2.基于 xml 声明切面
需要在<beans>根元素中导入<aop:Schema>

前置通知的方法: value 属性值就是切入点表达式的配置
切入点表达式有好多种,最常用的就是方法切入点表达式和类切入点表达式
方法切入点表达式: @Before("execution(\* com.hxzy.spring.service.jsq.add(..))")

后置通知的方法:
JoinPoint-->程序执行的某个位置,就是连接点对象,可以使用该对象获取方法名称和参数列表
类切入点表达式 within(类的全限定名称)
@After("within(com.hxzy.spring.service..\*)")

返回通知: 获取目标方法执行的返回结果
@AfterReturning(pointcut="execution( public _._.\*(..))",returning="result")
异常通知:

环绕增强:

### AOP 实现原理

**@AspectJ**

## 5. 全局异常处理

1. ControllerAdvice，注解定义全局异常处理类
2. ExceptionHandler，注解声明异常处理方法

3. 什么是引入?
   引入允许我们在已存在的类中增加新的方法和属性。
4. 什么是目标对象?
   被一个或者多个切面所通知的对象。它通常是一个代理对象。也指被通知（advised）对象。
5. 什么是代理?
   代理是通知目标对象后创建的对象。从客户端的角度看，代理对象和目标对象是一样的。
6. 有几种不同类型的自动代理？
   BeanNameAutoProxyCreator
   DefaultAdvisorAutoProxyCreator
   Metadata autoproxying
7. 什么是织入。什么是织入应用的不同点？
   织入是将切面和到其他应用类型或对象连接或创建一个被通知对象的过程。
   织入可以在编译时，加载时，或运行时完成。

**Transactional**

@Transactional(rollbackFor = Exception.class)

## 6. Spring 事务

> 事务管理是应用系统开发中必不可少的一部分，Spring 为事务管理提供了丰富的功能支持。Spring 事务管理分为编程式和声明式两种方式。在实际使用中常用声明式事务

### 编程式事务管理

通过编程的方式管理事务，可以带来极大的灵活性，但是难维护。

### 声明式事务管理

使用注解@Transactional 或 配置文件（XML） 配置来管理事务，将事务管理代码从业务方法中分离出来。

**配置文件（XML）**

```xml
<!-- 扫描组件 -->
<context:component-scan base-package="com.transaction"></context:component-scan>

<!-- 配置事务管理器 -->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourcetransactionManager">
    <property name="dataSource" ref="dataSource"></property> <!-- ref引入数据库配置 -->
</bean>

<!-- 配置事务增强(通知)属性，transaction-manager 属性是指定这个事务是使用哪一个事务管理器 -->
<tx:advice id="" transaction-manager="transactionManager">
    <tx:attributes>
        <!--配置支持的方法名称、propagation（传播级别）、isolation（隔离级别）、timeout、read-only、rollback-for 等属性 -->
        <tx:method name="">
    </tx:attributes>
</tx:advice>

<!-- 配置事务切入点表达式,使事务属性与事务关联 -->
<aop:config>
    <!-- 事务切入点 -->
    <aop:pointcut expression="execution(_ com.hxzy.spring.service.._.\*(..))" id="pointCut"/>
    <aop:advisor advice-ref="txAdvice" pointcut-ref="pointCut"/>
</aop:config>
```

**@Transactional 注解**

1. 开启事务注解扫描（xml 或@EnableTransactionManagement 注解）

```xml
<!-- 使用注解方式配置 spring 声明事务（开启事务注解扫描） -->
<tx:annotation-driven transaction-manager="">
```

2.  将@Transactional 注解添加到方法或类上，并设置对应的属性信息
    - value（transactionManager）：当配置文件中存在多个 TransactionManager，可以使用该属性指定哪个事务管理器
    - Propagation：事务的传播属性，默认值为 REQUIRED
    - isolation：事务的隔离级别，默认值 DEFAULT
    - timeout：事务的超时时间，默认值为-1，如果超过时间限制但事务还没有完成，则自动回滚事务
    - readOnly：是否为只读事务，默认为 false，为了忽略不需要事务的方法，比如读取数据，可以设置为 true
    - rollbackFor：指定能够触发事务回滚的异常类型，如果有多个异常类型需要指定，各类型之间使用逗号分隔
    - noRollbackFor：抛出指定的异常类型，不回滚

**实现机制**

@Transactional 原理是基于 Spring AOP，AOP 又是通过动态代理实现

在代码运行时生成一个代理对象，根据@Transactional 的属性配置信息，代理对象决定该注解标注的目标方法是否由拦截器@TransactionInterceptor 来使用拦截，在拦截中，会在目标方法开始执行前创建并加入事务，并执行目标方法的逻辑，最后根据执行情况是否出现异常，利用抽象事务管理器 AbstractPlatformTransactionManager 操作数据源 DataSource 提交或回滚事务

Spring AOP 代理有 CglibAopProxy 和 JdkDynamicAopProxy 两种，图 1 是以 CglibAopProxy 为例，对于 CglibAopProxy，需要调用其内部类的 DynamicAdvisedInterceptor 的 intercept 方法。对于 JdkDynamicAopProxy，需要调用其 invoke 方法

正确的设置@Transactional 的 propagation 属性
需要注意下面三种 propagation 可以不启动事务。本来期望目标方法进行事务管理，但若是错误的配置这三种 propagation，事务将不会发生回滚。

TransactionDefinition.PROPAGATION_SUPPORTS：如果当前存在事务，则加入该事务；如果当前没有事务，则以非事务的方式继续运行。
TransactionDefinition.PROPAGATION_NOT_SUPPORTED：以非事务方式运行，如果当前存在事务，则把当前事务挂起。
TransactionDefinition.PROPAGATION_NEVER：以非事务方式运行，如果当前存在事务，则抛出异常。

正确的设置@Transactional 的 rollbackFor 属性
默认情况下，如果在事务中抛出了未检查异常（继承自 RuntimeException 的异常）或者 Error，则 Spring 将回滚事务；除此之外，Spring 不会回滚事务。

如果在事务中抛出其他类型的异常，并期望 Spring 能够回滚事务，可以指定 rollbackFor。例：

@Transactional(propagation= Propagation.REQUIRED,rollbackFor= MyException.class)

通过分析 Spring 源码可以知道，若在目标方法中抛出的异常是 rollbackFor 指定的异常的子类，事务同样会回滚。

@Transactional 只能应用到 public 方法才有效
只有@Transactional 注解应用到 public 方法，才能进行事务管理。这是因为在使用 Spring AOP 代理时，Spring 在调用在图 1 中的 TransactionInterceptor 在目标方法执行前后进行拦截之前，DynamicAdvisedInterceptor（CglibAopProxy 的内部类）的的 intercept 方法或 JdkDynamicAopProxy 的 invoke 方法会间接调用 AbstractFallbackTransactionAttributeSource（Spring 通过这个类获取表 1. @Transactional 注解的事务属性配置属性信息）的 computeTransactionAttribute 方法。

避免 Spring 的 AOP 的自调用问题
在 Spring 的 AOP 代理下，只有目标方法由外部调用，目标方法才由 Spring 生成的代理对象来管理，这会造成自调用问题。若同一类中的其他没有@Transactional 注解的方法内部调用有@Transactional 注解的方法，有@Transactional 注解的方法的事务被忽略，不会发生回滚。

## Spring 序列化

> 在 java 中，一切皆对象，所有对象的状态信息转为存储或传输的形式，都需要序列化，通常建议：程序创建的每个 JavaBean 类都实现 Serializeable 接口。

1. 序列化：将对象写入到 IO 流中
2. 反序列化；从 IO 流中读取对象
3. 意义：序列化机制允许将实现序列化的 Java 对象转换为字节序列，这些字节序列可以保存在磁盘上，或通过网络传输，以达到以后恢复成原来的对象。序列化机制使得对象可以脱离程序的运行而独立存在。
4. 使用场景：所有可在网络上传输的对象都必须是可序列化的，比如 RMI（remote method invoke,即远程方法调用），传入的参数或返回的对象都是可序列化的，否则会出错；所有需要保存到磁盘的 java 对象都必须是可序列化的。

### 实体序列化：实现 Serializable 接口

- Serializable 接口是一个标记接口，不用实现任何方法。一旦实现了此接口，该类的对象就是可序列化的
- 序列化版本号 serialVersionUID，private static final long serialVersionUID 的序列化版本号，只有版本号相同，即使更改了序列化属性，对象也可以正确被反序列化回来。
- 序列化版本号可自由指定，如果不指定，JVM 会根据类信息自己计算一个版本号，这样随着 class 的升级，就无法正确反序列化；不指定版本号另一个明显隐患是，不利于 jvm 间的移植，可能 class 文件没有更改，但不同 jvm 可能计算的规则不一样，这样也会导致无法反序列化。
- 反序列化并不会调用构造方法。反序列的对象是由 JVM 自己生成的对象，不通过构造方法生成。
- 一个可序列化的类的成员不是基本类型，也不是 String 类型，那这个引用类型也必须是可序列化的；否则，会导致此类不能序列化
- 所有保存到磁盘的对象都有一个序列化编码号，当程序试图序列化一个对象时，会先检查此对象是否已经序列化过，只有此对象从未（在此虚拟机）被序列化过，才会将此对象序列化为字节序列输出。如果此对象已经序列化过，则直接输出编号即可。而不会将同一对象序列化多次
- 使用 transient 关键字选择不需要序列化的字段。

### 序列化

1. 序列化：将对象保存到磁盘中，或允许在网络中直接传输对象，对象序列化机制允许把内存中的 java 对象抓换成平台无关的二进制，从而可以持久的保存在磁盘，或者在网络中传输
2. 反序列化：程序一旦获取序列化的对象，则二进制流都可以恢复成原来的。

`Jackson2JsonRedisSerializer`：需要指明序列化的类 Class，可以使用 Obejct.class，反序列化带泛型的数组类会报转换异常，解决办法存储以 JSON 字符串存储，用 Jackson2，将对象序列化成 Json。这个 Serializer 功能很强大，但在现实中，是否需要这样使用，要多考虑。一旦这样使用后，要修改对象的一个属性值时，就需要把整个对象都读取出来，再保存回去；在 Redis 中保存的内容，比 Java 中多了一对双引号。
`GenericJackson2JsonRedisSerializer`：比 `Jackson2JsonRedisSerializer` 效率低，占用内存高。
GenericJacksonRedisSerializer 反序列化带泛型的数组类会报转换异常，解决办法存储以 JSON 字符串存储。
GenericJacksonRedisSerializer 和 Jackson2JsonRedisSerializer 都是以 JSON 格式去存储数据，都可以作为 Redis 的序列化方式

`StringRedisSerializer`：对 String 数据进行序列化。在 Java 和 Redis 中保存的内容是一样的

`JdkSerializationRedisSerializer`：jdk 序列化，对于 Key-Value 的 Value 来说，是在 Redis 中是不可读的。对于 Hash 的 Value 来说，比 Java 的内容多了一些字符。

`OxmSerializer`:使用 SpringO/X 映射的编排器和解排器实现序列化，用于 XML 序列化

`GenericToStringSerializer`：使用 Spring 转换服务进行序列化。在网上没有找到什么例子，使用方法和 StringRedisSerializer 相比，StringRedisSerializer 只能直接对 String 类型的数据进行操作，如果要被序列化的数据不是 String 类型的，需要转换成 String 类型，例如：String.valueOf()。但使用 GenericToStringSerializer 的话，不需要进行转换，直接由 String 帮我们进行转换。但这样的话，也就定死了序列化前和序列化后的数据类型，例如：template.setValueSerializer(new GenericToStringSerializer<Long>(Long.class));

``

## valid、validated

> 区别只要体现在分组，注解标注位置，嵌套验证等功能上

**区别**

1.  @Valid 是 javax.validation.Valid 包下的；@Validated 是 javax.validation 包下的，是@Valid 的一次封装，是 Spring 提供的校验机制使用。

2.  分组：@Validated 提供了分组功能，在入参验证时，根据不同的分组采用不同的验证机制。@valid 没有

    - 定义一个分组类（或接口）
    - 在校验注解上添加 groups 属性指定分组
    - Controller 方法的@Validated 注解添加分组类

3.  使用位置:

    - @validated 可以用在类型、方法和方法参数上。但是不能用在成员属性字段上
    - @valid 可以用在方法、构造函数、方法参数和成员属性（字段）上；`两者是否能用于成员属性（字段）上直接影响能否提供嵌套验证的功能`

4.  嵌套验证:

    - @Validated：用在方法入参上无法单独提供嵌套验证功能。不能用在成员属性（字段）上，也无法提示框架进行嵌套验证。能配合嵌套验证注解@Valid 进行嵌套验证。
    - @Valid：用在方法入参上无法单独提供嵌套验证功能。能够用在成员属性（字段）上，提示验证框架进行嵌套验证。能配合嵌套验证注解@Validation 进行嵌套验证。

5.  Service 层校验：需要两个注解一起使用，@Validation 标注在方法上，@Valid 标注在参数上；

**使用问题汇总**

1. 如果参数比较少，没有封装对象，用单个参数接受参数时，需要在 Controller 上增加@Validaiton。否则不生效！

   - `在类级别上标注@Validated注解告诉Spring需要校验方法参数上的约束。`

2. 如果只在一个字段上指定了自定义的 Group，并且在验证参数的时候，那除了 自定义的 Group 标注的字段，其它的都不会被验证。

   - `使用 Validation 验证时如果 Group 不写，默认为 Default.class（接口），如果其他字段想使用默认的验证，则需要自定义的Group继承Default接口，或者每个都写清楚`

![validation](../public/images/Java/SpringBoot/springboot-validation.png)

**快速失败 Fail Fast 模式配置**

```java
import org.hibernate.validator.HibernateValidator;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.beanvalidation.MethodValidationPostProcessor;

import javax.validation.Validation;
import javax.validation.Validator;
import javax.validation.ValidatorFactory;

/**
 * validate参数校验默认的是一个参数校验失败后，还会继续校验后面的参数
 * 增加了这个配置类后，校验参数时只要出现校验失败的情况，就立即抛出对应的异常，结束校验，不再进行后续的校验；也可以在全局异常处理时，获取第一个message即可
 */
@Configuration
public class ValidationConfig {
    @Bean
    public Validator validator() {
        ValidatorFactory validatorFactory = Validation.byProvider(HibernateValidator.class)
                .configure()
                //failFast的意思只要出现校验失败的情况，就立即结束校验，不再进行后续的校验。
                .failFast(true)
                .buildValidatorFactory();
        return validatorFactory.getValidator();
    }

    @Bean
    public MethodValidationPostProcessor methodValidationPostProcessor() {
        MethodValidationPostProcessor methodValidationPostProcessor = new MethodValidationPostProcessor();
        methodValidationPostProcessor.setValidator(validator());
        return methodValidationPostProcessor;
    }
}
```

**自定义验证**

1. 自定义注解

```java
import javax.validation.Constraint;
import javax.validation.Payload;
import java.lang.annotation.Documented;
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * IpAddress
 *
 * @Author dangbo
 * @Date 2021/9/3 17:16
 **/
@Target(value = ElementType.FIELD)
@Retention(value = RetentionPolicy.RUNTIME)
@Documented
@Constraint(validatedBy = IpaddressValidator.class)
public @interface IpAddress {
    String message() default "";

    Class<?>[] groups() default {};

    Class<? extends Payload>[] payload() default {};
}
```

2. 实现 ConstraintValidator<>接口

```java
import com.fp.checking.annotation.IpAddress;

import javax.validation.ConstraintValidator;
import javax.validation.ConstraintValidatorContext;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * IpaddressValidator
 *
 * @Author dangbo
 * @Date 2021/9/3 17:19
 **/
public class IpaddressValidator implements ConstraintValidator<IpAddress, String> {

    private static final Pattern PATTREN = Pattern.compile("^([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})\\.([0-9]{1,3})$");

    @Override
    public boolean isValid(String value, ConstraintValidatorContext context) {
        Matcher matcher = PATTREN.matcher(value);
        return matcher.matches();
    }
}
```

**校验注解说明**

1.  空检查

    - @NotEmpty：用在集合类上面；不能为 null，而且长度必须大于 0
    - @NotBlank： 用在 String 上面；只能作用在 String 上，不能为 null，而且调用 trim()后，长度必须大于 0
    - @NotNull：用在基本类型上；不能为 null，但可以为 empty。

2.  长度检查

    - @Size(min=,max=)：验证对象（Array,Collection,Map,String）长度是否在给定的范围之内，不能错用异常类型，比如在 int 上不可用@size
    - @Length(min=, max=) ： 只适用于 String 类型
    - @PositiveOrZero 正数或 0

3.  Booelan 检查

    - @AssertTrue： 验证 Boolean 对象是否为 true
    - @AssertFalse： 验证 Boolean 对象是否为 false

4.  日期检查

    - @Past： 验证 Date 和 Calendar 对象是否在当前时间之前
    - @Future： 验证 Date 和 Calendar 对象是否在当前时间之后
    - @Pattern： 验证 String 对象是否符合正则表达式的规则
    - @Past 必须是过去的时间
    - @PastOrPresent 必须是过去的时间，包含现在

5.  其他验证：

    - @Vaild 递归验证，用于对象、数组和集合，会对对象的元素、数组的元素进行一一校验
    - @Email 用于验证一个字符串是否是一个合法的右键地址，空字符串或 null 算验证通过
    - @URL(protocol=,host=,port=,regexp=,flags=) 用于校验一个字符串是否是合法 URL

6.  数值检查

    - @Min: 验证 Number 和 String 对象是否大等于指定的值
    - @Max: 验证 Number 和 String 对象是否小等于指定的值
    - @DecimalMax: 被标注的值必须不大于约束中指定的最大值. 这个约束的参数是一个通过 BigDecimal 定义的最大值的字符串表示.小数存在精度
    - @DecimalMin: 被标注的值必须不小于约束中指定的最小值. 这个约束的参数是一个通过 BigDecimal 定义的最小值的字符串表示.小数存在精度
    - @Digits: 验证 Number 和 String 的构成是否合法
    - @Digits(integer=,fraction=): 验证字符串是否是符合指定格式的数字，interger 指定整数精度，fraction 指定小数精度。

## 6. @Mapper 和@MapperScan

> @Mapper 注解的的作用 -->直接在 Mapper 类上面添加注解@Mapper
>
> 1. 为了把 mapper 这个 DAO 交给 Spring 管理 ；
> 2. 为了不再写 mapper 映射文件 ,通过注解来写 sql；
> 3. 为了给 mapper 接口 自动根据一个添加@Mapper 注解的接口生成一个实现类

> 使用@MapperScan 可以指定要扫描的 Mapper 类的包的路径

## 9. 事件监听- 观察者设计模式

`为了系统业务逻辑之间的解耦，提高可扩展性以及可维护性。`

1.  实现事件机制方式：EventObject、EventListener 和 Source

    - EventObject：java.util.EventObjet 是事件状态对象的基类，他封装了事件源以及和事件相关的信息，所有的 java 事件类都集成该类

    - Eventlistener：是一个标记接口，里边没有方法，所有的监听器监听该接口，事件监听注册在事件源上，当事件源的属性和状态改变的时候，调用相应监听器内的回调方法

    - Source：事件源并不需要实现和继承任何接口和类，他是事件最初发生的地方，因为事件源需要注册事件监听器，所有事件源内需要有相应的盛放事件监听器的容器。

> `实现方式：`
>
> 1. 事件 event extends ApplicationEvent ApplicationContext 或者 ApplicationEventPublisher
>
> 2. 监听器 implements ApplicationListener<T>，重写 onApplicationEvent 方法，该方法参数可以为 Object、也可以为自定义事件 event
>
>    使用注解@EventListener
>
> 3. 注册监听 SpringApplication.addListener(Listener 对象) 或者使用注解@Component SpringApplicationBuilder.listeners(…)
>
> 4. 发布事件 ApplicationContext 接口 继承 接口 ApplicationEventpublisher 事件发布器
>
> `扩展`
>
> 1. ApplicationEventMulticaster 是事件机制中的事件广播器，默认实现 SimpleApplicationEventMulticaster
> 2. ApplicationContext 本身担任监听器注册表的角色，在其子类 AbstractApplicationContext 中就聚合了事件广播器 ApplicationEventMulticaster 和事件监听器 ApplicationListnener，并且提供注册监听器的 addApplicationListnener 方法
> 3. Spring 中，事件源不强迫继承 ApplicationEvent 接口的，也就是可以直接发布任意一个对象类。但内部其实是使用 PayloadApplicationEvent 类进行包装了一层
>
> `spring自带的监听器`
>
> 1. ApplicationStartingEvent：springboot 启动开始的时候执行的事件
>
> 2. ApplicationEnvironmentPreparedEvent spring boot 对应**Enviroment**已经准备完毕，但此时上下文 context 还没有创建。在该监听中获取到 ConfigurableEnvironment 后可以对配置信息做操作，例如：修改默认的配置信息，增加额外的配置信息等等。
>
> 3. ApplicationPreparedEvent：spring boot 上下文 context 创建完成，但此时 spring 中的 bean 是没有完全加载完成的。在获取完上下文后，可以将上下文传递出去做一些额外的操作。值得注意的是：**在该监听器中是无法获取自定义 bean 并进行操作的。**
>
> 4. ApplicationReadyEvent：springboot 加载完成时候执行的事件。
>
> 5. ApplicationFailedEvent：spring boot 启动异常时执行事件。
>
>    > `默认情况下，监听事件都是同步执行的。在需要异步处理时，可以在方法上加上@Async进行异步化操作`

## 10. cron 表达式

```shell
# CronExpression用于定义时间规则，该表达式由6个空格分隔的时间字段组成：秒 分 时 日 月 周 年(可选)
# 秒 0-59  / 每隔几秒钟 - 在几到几秒钟 * 每秒钟 , 几和几秒钟
# 分 0-59  / 每隔几分钟 - 在几到几分钟 * 每分钟 , 几和几分钟
# 时 0-23  / 每隔几小时 - 在几到几小时 * 每小时 , 几和几小时
# 日 1-31  / - * , ? 不确定日期，由于和周一起使用，就相互排斥 L 最后一日 W 只有日期有，表示最近的工作日 LW 这个月的最后一周的工作日 C
# 月 1-12 / - * ,
# 周 1-7  / - * , ? 6L 每个月的最后一个星期五 L C  # 只有星期有，6#3 本月第三周的星期五
# 年 1970-2099
```

## 11. EasyExcel

### 11.1 导出

```java
// 获取ExcelWriter实例
ExcelWriter excelWriter = EasyExcel.write(pathName).build;
//内容样式策略
WriteCellStyle contentWriteCellStyle = new WriteCellStyle();
//垂直居中,水平居中
contentWriteCellStyle.setVerticalAlignment(VerticalAlignment.CENTER);
contentWriteCellStyle.setHorizontalAlignment(HorizontalAlignment.CENTER);
contentWriteCellStyle.setBorderLeft(BorderStyle.THIN);
contentWriteCellStyle.setBorderTop(BorderStyle.THIN);
contentWriteCellStyle.setBorderRight(BorderStyle.THIN);
contentWriteCellStyle.setBorderBottom(BorderStyle.THIN);
//设置 自动换行
contentWriteCellStyle.setWrapped(true);
// 字体策略
WriteFont contentWriteFont = new WriteFont();
// 字体大小
contentWriteFont.setFontHeightInPoints((short) 12);
// 字体加粗
//        contentWriteFont.setBold(true);
contentWriteCellStyle.setWriteFont(contentWriteFont);
//头策略使用默认
WriteCellStyle headWriteCellStyle = new WriteCellStyle();
// 字体不加粗，默认加粗
//        WriteFont headWriteFont = new WriteFont();
//        headWriteFont.setBold(false);
//        headWriteCellStyle.setWriteFont(headWriteFont);
//修改背景色
//        headWriteCellStyle.setFillForegroundColor(IndexedColors.CORNFLOWER_BLUE.getIndex());
// 获取WriterSheet
WriteSheet writeSheet = EasyExcel.writerSheet(sheetNo, sheetName)
        .registerWriteHandler(new HorizontalCellStyleStrategy(headWriteCellStyle, contentWriteCellStyle))
        .head(BasicElectricity.class)
        .build();
// 执行
excelWriter.write(list, writeSheet);
excelWriter.finish();
```

### 11.2 导入

```java
// 该导入是同步导入、还可以使用自定义监听器实现接口的方式完成
List<BasicElectricity> list = EasyExcel.read(fileName)
    .sheet(0)
    .head(***.class)
    .headRowNumber(1)
    .doReadSync();
// 使用注解@ExcelProperty()标注实体类，遇到类型转换时，实现Converter<BigDecimal>接口。
```

### 11.3 日期处理

```java
public static Date getDate(int days) {
		Calendar c = Calendar.getInstance();
		c.set(1900, 0, 1);
		c.add(Calendar.DATE, days - 2);
		return c.getTime();
	}

	public static Date getTime(Date date, double ditNumber) {
		Calendar c = Calendar.getInstance();
		int mills = (int) (Math.round(ditNumber * 24 * 3600));
		int hour = mills / 3600;
		int minute = (mills - hour * 3600) / 60;
		int second = mills - hour * 3600 - minute * 60;
		c.setTime(date);
		c.set(Calendar.HOUR_OF_DAY, hour);
		c.set(Calendar.MINUTE, minute);
		c.set(Calendar.SECOND, second);
		return c.getTime();
	}

public static void main(String[] args) throws java.lang.Exception {
		// SimpleDateFormat s = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
		// System.out.println(s.format(43188.468333)); Excel数字时间

		int days = 43188;
		double ditNumber = 0.468333;
		Date date =new DateConvert().getDate(days);
		Date dateTime = new DateConvert().getTime(date, ditNumber);
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		System.out.println(sdf.format(dateTime));
               //输出：2018-03-29 11:14:24

}
```

## 14. idea 同时启动多个相同项目

原理：启动 jar 时，增加配置参数（端口）
jar -jar xxx.jar --server.port=8080

![ieda配置多个启动](../public/images/Java/Spring/idea.png)

## 15. @JsonProperty 序列化失效

- POST 接口请求方式为 application/json 方式，@JsonProperty 序列化能够生效；
- GET 请求方式，参数拼接在 URL 后面，此时参数对象中的 @JsonProperty 不会生效。

@JsonUnwrapped 对象扁平化
