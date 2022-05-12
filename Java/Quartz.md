## 前言

**定时的几种实现方式**

1.  while 循环执行 thread 线程，线程调用 sleep 睡眠
2.  Timer 和 TimerTask， 简单无门槛，一般也没人用
3.  线程池，Executors.newScheduledThreadPool，底层 ScheduledThreadPoolExecutor；
4.  spring 自带的 springtask（@Schedule），一般集成于项目中，小任务很方便
5.  Quartz，开源工具 Quartz，分布式集群开源工具，以下两个分布式任务应该都是基于 Quartz 实现的，可以说是中小型公司必选，当然也视自身需求而定
6.  分布式任务 XXL-JOB，是一个轻量级分布式任务调度框架，支持通过 Web 页面对任务进行 CRUD 操作，支持动态修改任务状态、暂停/恢复任务，以及终止运行中任务，支持在线配置调度任务入参和在线查看调度结果。
7.  分布式任务 Elastic-Job，是一个分布式调度解决方案，由两个相互独立的子项目 Elastic-Job-Lite 和 Elastic-Job-Cloud 组成。定位为轻量级无中心化解决方案，使用 jar 包的形式提供分布式任务的协调服务。支持分布式调度协调、弹性扩容缩容、失效转移、错过执行作业重触发、并行调度、自诊。
8.  分布式任务 Saturn，Saturn 是唯品会在 github 开源的一款分布式任务调度产品。它是基于当当 elastic-job 来开发的，其上完善了一些功能和添加了一些新的 feature。目前在 github 上开源大半年，470 个 star。Saturn 的任务可以用多种语言开发比如 python、Go、Shell、Java、Php。其在唯品会内部已经发部署 350+个节点，每天任务调度 4000 多万次。同时，管理和统计也是它的亮点。

## Quartz

**依赖**

```xml
<!-- Quartz -->
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.3.2</version>
</dependency>
<!-- scheduled所属资源为spring-context-support，在Spring中对Quartz的支持，是集成在spring-context-support包中。org.springframework.scheduling.quartz-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
</dependency>
<!-- Spring tx 坐标，quartz可以提供分布式定时任务环境。多个分布点上的Quartz任务，是通过数据库实现任务信息传递的。通过数据库中的数据，保证一个时间点上，只有一个分布环境执行定时任务。-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-tx</artifactId>
</dependency>


<!--spring-boot 2.x提供了starter依赖，可以直接使用-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
    <version>2.3.7.RELEASE</version>
</dependency>
```

**描述说明**

- Scheduler：调度任务的主要 API
- ScheduleBuilder：用于构建 Scheduler，例如其简单实现类 SimpleScheduleBuilder
- Job：调度任务执行的接口，也即定时任务执行的方法
- JobDetail：定时任务作业的实例
- JobBuilder：关联具体的 Job，用于构建 JobDetail
- Trigger：定义调度执行计划的组件，即定时执行
- TriggerBuilder：构建 Trigger

### springboot 整合步骤

2. 增加自定义任务 Job，实现 Job 接口或者继承抽象类 QuartzJobBean，重写 execute()方法

3. JobDetail、Trigger、Scheduler 的获取

Trigger 分为两种，SimpleTrigger 和 CronTrigger。SimpleTrigger 是根据 Quartz 的一些 api 实现的简单触发行为。CronTrigger 用的比较多，使用 cron 表达式进行触发。这里先用 SimpleTrigger 来实现。

```java
JobDetail jobDetail = JobBuilder.newJob(SimpleJob.class)
        // 任务标识，及任务分组
        .withIdentity("job1", "group1")
        // 增加需要的参数
        .usingJobData("name","dangxiaodang")
        .usingJobData("age",18)
        .build();

SimpleTrigger simpleTrigger = TriggerBuilder.newTrigger()
        .withIdentity("trigger1", "group1")
        // 立即执行
        .startNow()
        // 10s后停止
        .endAt(new Date(System.currentTimeMillis()+10*1000))
        .withSchedule(
        SimpleScheduleBuilder.simpleSchedule()
        // 每秒执行一次
        .withIntervalInSeconds(1)
        // 一直执行
        .repeatForever()
        ).build();

spring-boot自动注入Scheduler实例，可以通过@AutoWired依赖进来。


@Configuration
public class QuartzConfiguration {

    @Autowired
    private DataSource dataSource;
    /**
     * 创建调度器， 可以省略的。
     * @return
     * @throws Exception
     */
    @Bean
    public Scheduler scheduler() throws Exception {
        Scheduler scheduler = schedulerFactoryBean().getScheduler();
        scheduler.start();
        return scheduler;
    }

    /**
     * 创建调度器工厂bean对象。
     * @return
     * @throws IOException
     */
    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() throws IOException {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();

        factory.setSchedulerName("Cluster_Scheduler");
        factory.setDataSource(dataSource);
        factory.setApplicationContextSchedulerContextKey("applicationContext");
        // 设置调度器中的线程池。
        factory.setTaskExecutor(schedulerThreadPool());
        // 设置触发器
        factory.setTriggers(trigger().getObject());
        // 设置quartz的配置信息
        factory.setQuartzProperties(quartzProperties());
        return factory;
    }

    /**
     * 读取quartz.properties配置文件的方法。
     * @return
     * @throws IOException
     */
    @Bean
    public Properties quartzProperties() throws IOException {
        PropertiesFactoryBean propertiesFactoryBean = new PropertiesFactoryBean();
        propertiesFactoryBean.setLocation(new ClassPathResource("/quartz.properties"));

        // 在quartz.properties中的属性被读取并注入后再初始化对象
        propertiesFactoryBean.afterPropertiesSet();
        return propertiesFactoryBean.getObject();
    }

    /**
     * 创建Job对象的方法。
     * @return
     */
    @Bean
    public JobDetailFactoryBean job() {
        JobDetailFactoryBean jobDetailFactoryBean = new JobDetailFactoryBean();

        jobDetailFactoryBean.setJobClass(SpringBootQuartzJobDemo.class);
        // 是否持久化job内容
        jobDetailFactoryBean.setDurability(true);
        // 设置是否多次请求尝试任务。
        jobDetailFactoryBean.setRequestsRecovery(true);

        return jobDetailFactoryBean;
    }

    /**
     * 创建trigger factory bean对象。
     * @return
     */
    @Bean
    public CronTriggerFactoryBean trigger() {
        CronTriggerFactoryBean cronTriggerFactoryBean = new CronTriggerFactoryBean();

        cronTriggerFactoryBean.setJobDetail(job().getObject());
        cronTriggerFactoryBean.setCronExpression("0/2 * * * * ?");

        return cronTriggerFactoryBean;
    }

    /**
     * 创建一个调度器的线程池。
     * @return
     */
    @Bean
    public Executor schedulerThreadPool() {
        ThreadPoolTaskExecutor executor = new ThreadPoolTaskExecutor();

        executor.setCorePoolSize(15);
        executor.setMaxPoolSize(25);
        executor.setQueueCapacity(100);

        return executor;
    }
}
```

4. 动态操作定时任务- 都是通过 scheduler 对象的方法进行操作

- 4.1 创建任务
- 4.2 暂停任务
- 4.3 删除任务
- 4.4 恢复暂停任务
- 4.5 修改任务

5. 任务持久化

Quartz 默认使用 RAMJobStore 存储方式将任务存储在内存中，除了这种方式还支持使用 JDBC 将任务存储在数据库，为了防止任务丢失，我们一般会将任务存储在数据库中；官网找 quartz 的源码包，里边有不同类型的数据库的 sql 文件，然后在客户端进行运行 sql 文件

- 5.1 增加依赖

```xml
<dependency>
    <groupId>mysql</groupId>
    <artifactId>mysql-connector-java</artifactId>
    <version>8.0.11</version>
</dependency>

<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-jdbc</artifactId>
</dependency>
```

- 5.2 指定使用 jdbc 存储

```yaml
spring:
  quartz:
    job-store-type: jdbc
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/simple_fast
    username: root
    password: root
```

- 5.3 创建任务

6. 分布式 Quartz

- 6.1 引入依赖

```xml
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz-jobs</artifactId>
    <version>2.3.2</version>
</dependency>
```

- 6.2 创建数据库和数据库表

- 6.3 定义任务实现类

- 6.4 实现主程序

```properties

#Configure Main Scheduler Properties
#==============================================================
#配置集群时，quartz调度器的id，由于配置集群时，只有一个调度器，必须保证每个服务器该值都相同，可以不用修改，只要每个ams都一样就行
org.quartz.scheduler.instanceName = Scheduler1
#集群中每台服务器自己的id，AUTO表示自动生成，无需修改
org.quartz.scheduler.instanceId = AUTO
#==============================================================
#Configure ThreadPool
#==============================================================
#quartz线程池的实现类，无需修改
org.quartz.threadPool.class = org.quartz.simpl.SimpleThreadPool
#quartz线程池中线程数，可根据任务数量和负责度来调整
org.quartz.threadPool.threadCount = 5
#quartz线程优先级
org.quartz.threadPool.threadPriority = 5
#==============================================================
#Configure JobStore
#==============================================================
#表示如果某个任务到达执行时间，而此时线程池中没有可用线程时，任务等待的最大时间，如果等待时间超过下面配置的值(毫秒)，本次就不在执行，而等待下一次执行时间的到来，可根据任务量和负责程度来调整
org.quartz.jobStore.misfireThreshold = 60000
#实现集群时，任务的存储实现方式，org.quartz.impl.jdbcjobstore.JobStoreTX表示数据库存储，无需修改
org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX
#quartz存储任务相关数据的表的前缀，无需修改
org.quartz.jobStore.tablePrefix = QRTZ_
#连接数据库数据源名称，与下面配置中org.quartz.dataSource.myDS的myDS一致即可，可以无需修改
org.quartz.jobStore.dataSource = myDS
#是否启用集群，启用，改为true,注意：启用集群后，必须配置下面的数据源，否则quartz调度器会初始化失败
org.quartz.jobStore.isClustered = false
#集群中服务器相互检测间隔，每台服务器都会按照下面配置的时间间隔往服务器中更新自己的状态，如果某台服务器超过以下时间没有checkin，调度器就会认为该台服务器已经down掉，不会再分配任务给该台服务器
org.quartz.jobStore.clusterCheckinInterval = 20000
#==============================================================
#Non-Managed Configure Datasource
#==============================================================
#配置连接数据库的实现类，可以参照IAM数据库配置文件中的配置
org.quartz.dataSource.myDS.driver = com.mysql.jdbc.Driver
#配置连接数据库连接，可以参照IAM数据库配置文件中的配置
org.quartz.dataSource.myDS.URL = jdbc:mysql://localhost:3306/test
#配置连接数据库用户名
org.quartz.dataSource.myDS.user = yunxi
#配置连接数据库密码
org.quartz.dataSource.myDS.password = 123456
#配置连接数据库连接池大小，一般为上面配置的线程池的2倍
org.quartz.dataSource.myDS.maxConnections = 10

```

```yml

# 是否使用properties作为数据存储

org.quartz.jobStore.useProperties=false

# 数据库中的表格命名前缀

org.quartz.jobStore.tablePrefix = QRTZ_

# 是否是一个集群，是不是分布式的任务

org.quartz.jobStore.isClustered = true

# 集群检查周期，单位毫秒。可以自定义缩短时间。 当某一个节点宕机的时候，其他节点等待多久后开始执行任务。

org.quartz.jobStore.clusterCheckinInterval = 5000

# 单位毫秒， 集群中的节点退出后，再次检查进入的时间间隔。

org.quartz.jobStore.misfireThreshold = 60000

# 事务隔离级别

org.quartz.jobStore.txIsolationLevelReadCommitted = true

# 存储的事务管理类型

org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX

# 使用的Delegate类型

org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.StdJDBCDelegate

# 集群的命名，一个集群要有相同的命名。

org.quartz.scheduler.instanceName = ClusterQuartz

# 节点的命名，可以自定义。 AUTO代表自动生成。

org.quartz.scheduler.instanceId= AUTO

# rmi远程协议是否发布

org.quartz.scheduler.rmi.export = false

# rmi远程协议代理是否创建

org.quartz.scheduler.rmi.proxy = false

# 是否使用用户控制的事务环境触发执行job。

org.quartz.scheduler.wrapJobExecutionInUserTransaction = false
```
