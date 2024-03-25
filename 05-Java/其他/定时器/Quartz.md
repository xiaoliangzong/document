# Quartz

## 1. 概述

Quartz是 OpenSymphony 开源组织在 Job scheduling 领域的一个开源项目。


**特性**

1. 支持多任务调度和管理，Quartz可以在数据库中存储多个定时任务进行作业调度，可以实现定时任务的增删改查等管理。
2. 纯Java实现，可以作为独立的应用程序，也可以嵌入在另一个独立式应用程序运行。
3. 强大的调度功能，Spring默认的调度框架，灵活可配置。
4. 作业持久化，调度环境持久化机制，可以保存并恢复调度现场。系统关闭数据不会丢失；灵活的应用方式，可以任意定义触发器的调度时间表，支持任务和调度各种组合，组件式监听器、各种插件、线程池等功能，多种存储方式等。
5. 分布式和集群能力，可以被实例化，一个Quartz集群中的每个节点作为一个独立的Quartz使用，通过相同的数据库表来感知到另一个Quartz应用。

## 2. 核心

Quartz 主要包括 JobDetail、Trigger 和 Scheduler 三部分。

- JobDetail 包含了任务的实现类和任务的描述信息，
- Trigger 决定了任务什么时候执行，
- Scheduler 是调度器，将 JobDetail 和 Trigger 结合起来，定时定频率的执行任务。

核心组成部分详细说明：

### Job

表示一个需要定时执行的任务，只需要实现 Job 接口的 execute() 方法，该方法就是定时执行的操作。Quartz 每次调度 Job 时，都重新创建一个 Job 实例，因此它不接受多个 Job 的实例。

```java
public interface Job {
    void execute(JobExecutionContext var1) throws JobExecutionException;
}
```

### JobDetail

JobDetail 用来定义定时任务的实例。主要由 JobKey（job 的名字 name 和分组 group）、JobClass、JobDataMap（任务相关的数据）、JobBuilder 组成。他实际保存了 Job 的描述信息，以便运行时通过 newInstance() 的反射机制实例化 Job。

JobBuilder 用于构建一个任务实例，可以定义关于该任务的详情比如任务名、组名等。

### Trigger

Trigger 触发器，定义调度执行计划的组件，表明任务在什么时候会执行。主要有 SimpleTrigger 和 CronTrigger 两个实现类。 SimpleTrigger 是根据 Quartz 的一些 api 实现的简单触发行为，CronTrigger 用的比较多，使用 cron 表达式进行触发。

TriggerBuilder 用于构建触发器。

Trigger 由以下部分组成：

- TriggerKey：包括 job 的名字 name 和分组 group
- JobDataMap：Trigger 相关的数据，同 JobDetail 中 JobDataMap，存相同key，若value不同，会覆盖前者。
- ScheduleBuilder：调度构建器，常用的有 CronScheduleBuilder、SimpleScheduleBuilder。

### Scheduler

Scheduler 调度器就是为了读取触发器 Trigger 从而触发定时任务 JobDetail。可以通过 SchedulerFactory 进行创建调度器，分为 StdSchedulerFactory（常用）和 DirectSchedulerFactory 两种。

- StdSchedulerFactory 使用一组属性（放在配置文件中）创建和初始化调度器，然后通过getScheduler()方法生成调度程序。
- DirectSchedulerFactory不常用，容易硬编码。

```java
public static void main(String[] args) {
    // 创建调度器
    SchedulerFactory scheduleFactory = new org.quartz.impl.StdSchedulerFactory(); 
    Scheduler scheduler = scheduleFactory.getScheduler(); 

    scheduler.start(); 

    JobKey jobKey = JobKey.jobKey(jobName, jobGroup);
    JobDetail jobDetail = JobBuilder.newJob(jobClass).withIdentity(jobKey).build();

    CronScheduleBuilder cronScheduleBuilder = CronScheduleBuilder.cronSchedule("* * 2 * * ?");
    CronTrigger trigger = TriggerBuilder
            .newTrigger()
    
            .withIdentity(TriggerKey.triggerKey(jobName, jobGroup))
            .withSchedule(cronScheduleBuilder)
            .build();

    // 放入参数，运行时的方法可以获取
    JobDataMap jobDataMap = jobDetail.getJobDataMap();
    jobDataMap.put(Constants.TASK_JOB_PROPERTIES, job);
    jobDataMap.put(Constants.TASK_INTERFACE_PROPERTIES, scheduleInterfaceInfo);

    scheduler.scheduleJob(jobDetail, trigger);
}
```

## 3. 数据库表说明

|           表名           |                             描述                             |
| :----------------------: | :----------------------------------------------------------: |
|    qrtz_blob_triggers    |                  Trigger 作为 Blob 类型存储                  |
|      qrtz_calendars      |                 存储 Quartz 的 Calendar 信息                 |
|    qrtz_cron_triggers    |         存储 CronTrigger，包括 Cron 表达式和时区信息         |
|   qrtz_fired_triggers    | 存储与已触发的 Trigger 相关的状态信息，以及相关联的 Job 的执行信息 |
|     qrtz_job_details     |              存储每一个已配置的 Job 的详细信息               |
|        qrtz_locks        |                    存储程序的悲观锁的信息                    |
| qrtz_paused_trigger_grps |                存储已暂停的 Trigger 组的信息                 |
|   qrtz_scheduler_state   |  存储少量的有关 Scheduler 的状态信息，和别的 Scheduler 实例  |
|   qrtz_simple_triggers   |   存储简单的 Trigger，包括重复次数、间隔、以及已触发的次数   |
|  qrtz_simprop_triggers   |                                                              |


## 4. 实践

### 4.1 POM 中引入依赖

```xml
<!--spring-boot 2.x提供了starter依赖，可以直接使用-->
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-quartz</artifactId>
    <version>2.6.0</version>
</dependency>

<!-- 非springboot项目 -->
<!-- Quartz -->
<dependency>
    <groupId>org.quartz-scheduler</groupId>
    <artifactId>quartz</artifactId>
    <version>2.3.2</version>
</dependency>
<!-- scheduled所属资源为spring-context-support，在Spring中对Quartz的支持，是集成在spring-context-support包中，
org.springframework.scheduling.quartz-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-context-support</artifactId>
</dependency>
<!-- Spring tx 坐标，quartz可以提供分布式定时任务环境。多个分布点上的Quartz任务，
是通过数据库实现任务信息传递的。通过数据库中的数据，保证一个时间点上，只有一个分布环境执行定时任务。-->
<dependency>
    <groupId>org.springframework</groupId>
    <artifactId>spring-tx</artifactId>
</dependency>
```

### 4.2 编写配置文件

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

### 4.3 SpringBoot 整合 Quartz

1. 增加自定义任务 Job，实现 Job 接口或者继承抽象类 QuartzJobBean，重写 execute()方法

```java
// 禁止并发执行多个相同定义的 JobDetail, 这个注解是加在 Job 类上的, 但意思并不是不能同时执行多个 Job, 而是不能并发执行同一个 Job Definition(由 JobDetail 定义), 但是可以同时执行多个不同的 JobDetail。
// 即对于同一个 Job 任务不允许并发执行，但对于不同的 job 任务不受影响。
@DisallowConcurrentExecution
// 保存在 JobDataMap 传递的参数。加在 Job 上，表示当正常执行完 Job 后，JobDataMap 中的数据应该被改动，以被下一次调用时用。
@PersistJobDataAfterExecution
public class Job1 implements Job {

    @Override
    public void execute(JobExecutionContext context) throws JobExecutionException {
    }
}
```

2. 获取 JobDetail、Trigger

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
        .withSchedule(SimpleScheduleBuilder.simpleSchedule())
        // 每秒执行一次
        .withIntervalInSeconds(1)
        // 一直执行
        .repeatForever()
        ).build();
```

3. 自动注入Scheduler实例，可以通过@AutoWired依赖进来。

我们通常是通过 quartz.properties 属性配置文件(默认情况下均使用该文件)结合 StdSchedulerFactory 来使用 Quartz 的。StdSchedulerFactory 会加载属性配置文件并实例化一个 Scheduler。

默认情况下，Quartz 会加载 classpath 下的 quartz.properties 文件作为配置属性，如果找不到则会使用 quartz 框架自己 jar 下 org/quartz 包底下的 quartz.properties 文件。当然你也可以指定 org.quartz.properties 属性指向你自定义的属性配置文件。或者，你也可以在调用 StdSchedulerFactory 的 getScheduler()方法之前调用 initialize(xx)初始化 factory 配置。

```java
@Configuration
public class QuartzConfiguration {

    @Autowired
    private DataSource dataSource;

    @Bean
    public Scheduler scheduler() throws Exception {
        Scheduler scheduler = schedulerFactoryBean().getScheduler();
        scheduler.start();
        return scheduler;
    }

    /**
     * 创建调度器工厂bean对象。SchedulerFactoryBean 实现了 InitializingBean 接口，因此在初始化 Bean 的时候会执行 afterPropertiesSet，该方法会调用 SchedulerFactory(DirectSchedulerFactory 或者 StdSchedulerFactory，通常用 StdSchedulerFactory)创建 Scheduler，SchedulerFactory 在创建 quartzScheduler 的过程中，将会读取配置参数，初始化各个组件
     * @return
     * @throws IOException
     */
    @Bean
    public SchedulerFactoryBean schedulerFactoryBean() throws IOException {
        SchedulerFactoryBean factory = new SchedulerFactoryBean();
        // 设置数据源
        factory.setDataSource(dataSource);
        // 设置quartz的配置信息
        factory.setQuartzProperties(quartzProperties());
        // 延时启动
        factory.setStartupDelay(10);
        factory.setApplicationContextSchedulerContextKey("applicationContextKey");
        // 启动时更新己存在的Job，这样就不用每次修改targetObject后删除qrtz_job_details表对应记录了
        factory.setOverwriteExistingJobs(true);
        return factory;
    }

    /**
     * 读取quartz.properties配置文件的方法。
     */
    @Bean
    public Properties quartzProperties() throws IOException {
        PropertiesFactoryBean prop = new PropertiesFactoryBean();
        prop.setLocation(new ClassPathResource("/quartz.properties"));
        // 在quartz.properties中的属性被读取并注入后再初始化对象
        prop.afterPropertiesSet();
        return prop.getObject();
    }
}
```


4. 动态操作定时任务，都是通过 scheduler 对象的方法进行操作

- 4.1 创建任务
- 4.2 暂停任务
- 4.3 删除任务
- 4.4 恢复暂停任务
- 4.5 修改任务

5. 任务持久化

Quartz 默认使用 RAMJobStore 存储方式将任务存储在内存中，除了这种方式还支持使用 JDBC 将任务存储在数据库，为了防止任务丢失，我们一般会将任务存储在数据库中；官网找 quartz 的源码包，里边有不同类型的数据库的 sql 文件，然后在客户端进行运行 sql 文件

```yaml
spring:
  quartz:
    job-store-type: jdbc
  datasource:
    driver-class-name: com.mysql.cj.jdbc.Driver
    url: jdbc:mysql://localhost:3306/test
    username: root
    password: root
```