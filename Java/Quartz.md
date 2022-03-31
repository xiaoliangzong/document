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
