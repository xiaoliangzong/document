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

```yml
# 配置调度器信息
# 配置集群时，quartz调度器的id，由于配置集群时，只有一个调度器，必须保证每个服务器该值都相同，默认为schedulerFactoryBean，如果不是使用spring，则为QuartzScheduler
org.quartz.scheduler.instanceName = QuartzScheduler
# 集群中每台服务器自己的id，默认为NON_CLUSTERED，AUTO代表自动生成，
org.quartz.scheduler.instanceId = AUTO
# 如果为AUTO，则默认使用SimpleInstanceIdGenerator生成
org.quartz.scheduler.instanceIdGenerator.class = org.quartz.simpl.SimpleInstanceIdGenerator
# 线程名称，默认为 “调度器名称_QuartzSchedulerThread”
org.quartz.scheduler.threadName = QuartzSchedulerThread

# 线程池配置
# quartz线程池的实现类，默认为SimpleThreadPool，无需修改，可满足大多数需求
org.quartz.threadPool.class = org.quartz.simpl.SimpleThreadPool
# quartz线程池中线程数，可根据任务数量和负责度来调整，默认为10
org.quartz.threadPool.threadCount = 25
# quartz线程优先级，取值范围1-10，默认为5
org.quartz.threadPool.threadPriority = 5


# JobStore配置
# 单位毫秒，表示如果某个任务到达执行时间，而此时线程池中没有可用线程时，任务等待的最大时间，如果等待时间超过下面配置的值，本次就不在执行，而等待下一次执行时间的到来，可根据任务量和负责程度来调整
org.quartz.jobStore.misfireThreshold = 60000
# quartz存储任务相关数据的表的前缀
org.quartz.jobStore.tablePrefix = QRTZ_
# 是否启用集群，ture表示启用，注意：启用集群后，必须配置数据源，否则quartz调度器会初始化失败，有多个Quartz实例在用同一个数据库时，必须设置为true。
org.quartz.jobStore.isClustered = true
# 存储方式，如果存在数据源，默认使用LocalDataSourceJobStore，LocalDataSourceJobStore使用已经配置的dataSource作为数据源；低版本时，即使指定了JobStoreTX也没用，高版本（2.5.7后），如果配置JobStoreTX后，还需要在配置文件中指定数据源，否则启动报错。
# 高版本推荐方案：1. 使用默认的LocalDataSourceJobStore，无需配置；2. 使用JobStoreTX，同时指定quartz的数据源。
org.quartz.jobStore.class = org.quartz.impl.jdbcjobstore.JobStoreTX
# 集群检查周期，单位毫秒，集群中服务器相互检测间隔，每台服务器都会按照下面配置的时间间隔往服务器中更新自己的状态，如果某台服务器超过以下时间没有checkin，调度器就会认为该台服务器已经down掉，不会再分配任务给该台服务器
org.quartz.jobStore.clusterCheckinInterval = 20000
# JobDataMaps是否都为String类型，若是true的话，便可不用让更复杂的对象以序列化的形式保存到BLOB列中。以防序列化可能导致的版本号问题
org.quartz.jobStore.useProperties = false
# 当使用JobStoreTX或CMT，JDBC连接时，是否设置setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE) 方法
org.quartz.jobStore.txIsolationLevelSerializable=false
# 数据源获取连接后是否设置自动提交setAutoCommit(false)方法，如果为ture,表示不设置，否则设置
org.quartz.jobStore.dontSetAutoCommitFalse=true
# JobStore能处理的错过触发的Trigger的最大数量。处理太多很快就会导致数据库表被锁定够长的时间，这样会妨碍别的（还未错过触发）trigger执行的性能
org.quartz.jobStore.maxMisfiresToHandleAtATime=1


org.quartz.jobStore.dataSource = myDS
org.quartz.dataSource.myDS.driver = com.mysql.jdbc.Driver
org.quartz.dataSource.myDS.URL = jdbc:mysql://${mysql.address}/etc-quartz?useUnicode=true&characterEncoding=utf8
org.quartz.dataSource.myDS.user = ${mysql.user}
org.quartz.dataSource.myDS.password = ${mysql.password}
org.quartz.dataSource.myDS.provider = hikaricp
# 数据库最大连接数（如果Scheduler很忙，比如执行的任务与线程池的数量差不多相同，那就需要配置DataSource的连接数量为线程池数量+1）
org.quartz.dataSource.myDS.maxConnections = 30
# dataSource用于检测connection是否failed/corrupt的SQL语句
org.quartz.dataSource.myDS.validationQuery=select RAND()

```

SchedulerFactoryBean 实现了 InitializingBean 接口，因此在初始化 Bean 的时候会执行 afterPropertiesSet，该方法会调用 SchedulerFactory(DirectSchedulerFactory 或者 StdSchedulerFactory，通常用 StdSchedulerFactory)创建 Scheduler，SchedulerFactory 在创建 quartzScheduler 的过程中，将会读取配置参数，初始化各个组件

如果你在 spring 的配置文件中使用 SchedulerFactoryBean 配置了 datasoucrce，即使用 spring 托管的 datasource，则 spring 会强制使用这个 jobstore、LocalDataSourceJobStore

使用了 Spring+Quartz 之后，发现启动日志里并没有使用 JobStoreTX, 而是使用了 LocalDataSourceJobStore，因为 Quartz 的{@link JobStoreCMT}类的子类，该类委托给一个 spring 管理的
{@link DataSource}，而不是使用 quartz 管理的 JDBC 连接池。

我们通常是通过 quartz.properties 属性配置文件(默认情况下均使用该文件)结合 StdSchedulerFactory 来使用 Quartz 的。StdSchedulerFactory 会加载属性配置文件并实例化一个 Scheduler。

默认情况下，Quartz 会加载 classpath 下的”quartz.properties”文件作为配置属性，如果找不到则会使用 quartz 框架自己 jar 下 org/quartz 包底下的”quartz.properties”文件。当然你也可以指定”org.quartz.properties”属性指向你自定义的属性配置文件。或者，你也可以在调用 StdSchedulerFactory 的 getScheduler()方法之前调用 initialize(xx)初始化 factory 配置。

在配置文件中你可以使用”$@”引用其他属性配置。

@DisallowConcurrentExecution

禁止并发执行多个相同定义的 JobDetail, 这个注解是加在 Job 类上的, 但意思并不是不能同时执行多个 Job, 而是不能并发执行同一个 Job Definition(由 JobDetail 定义), 但是可以同时执行多个不同的 JobDetail。

即对于同一个 Job 任务不允许并发执行，但对于不同的 job 任务不受影响。

@PersistJobDataAfterExecution

保存在 JobDataMap 传递的参数。加在 Job 上,表示当正常执行完 Job 后, JobDataMap 中的数据应该被改动, 以被下一次调用时用。
