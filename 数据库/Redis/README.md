# Redis

## 1. windows 安装

> Windows 版的 Redis 有 2 个配置文件，一个是：redis.windows.conf，另一个是 redis.windows-service.conf。
>
> 设置登录密码，只需要在 redis.windows.conf 中设置
> 客户端访问时，需要输入密码：`auth password`
>
> 由于安装版(xxx.msi)的 Redis 服务自启动，是直接通过 redis-server.exe 启动的，但是启动时并没有加载 Redis 的配置文件（redis.windows.conf），导致 redis 中 bind 绑定配置和密码设置不生效
> 解决办法：
>
> 1. 禁用 Redis 的自启动，设置为手动（计算机-管理-服务-设置为手动）
> 2. 不要使用 Redis 安装版，使用压缩版，通过命令行加载配置文件 redis.windows.conf 启动

```shell
# 第一种：通过命令行启动
# 1. 下载压缩包，直接解压
# 2. 启动服务端
./redis-server.exe redis.windows.conf
# 3. 启动客户端
./redis-cli.exe            # 精简模式
./redis-cli.exe -h 127.0.0.1 -p 6379 -a 密码      # 指定模式  -a  密码
./redis-cli.exe -h 127.0.0.1 -p 6379

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# 第二种：通过服务自启动
# 1. 不是安装版的Redis，如果需要实现自启动，只需将Redis服务注册成windows服务
# --service-install redis.windows.conf 指定redis配置文件
# --loglevel notice  指定日志级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
# --service-name   指定redis服务名称
安装目录下，执行 redis-server --service-install redis.windows.conf --loglevel verbose --service-name Redis  ；执行此命令成功后表示已经安装成为windows服务了，但是安装服务后，默认不是马上启动的，但启动类型是自启动，如果想马上启动，需要执行启动命令或重启电脑
# 2. 启动redis服务
redis-server --service-start
# 3. 停止redis服务
redis-server --service-stop
# 4. 还可以安装多个服务
redis-server --service-install -service-name redisService1 -port 3306
redis-server --service-install -service-name redisService2 -port 3307
# 5. 卸载删除redis服务
redis-server --service-uninstall
sc delete 服务名  # 删除服务（管理员身份运行）
```

## redis 的配置文件详解

```sh
#redis的配置

#Redis默认不是以守护进程的方式运行，可以通过该配置项修改，使用yes启用守护进程
daemonize yes
#当Redis以守护进程方式运行时，Redis默认会把pid写入redis.pid文件，可以通过pidfile指定
pidfile 'E:/xxx/redis/redis_pid/redis.pid'
#端口
port 6379
#绑定主机的ip地址
bind 127.0.0.1
#当 客户端闲置多长时间后关闭连接，如果指定为0，表示关闭该功能
timeout 300
#指定日志记录级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
loglevel notice
#日志记录方式，默认为标准输出，如果配置Redis为守护进程方式运行，而这里又配置为日志记录方式为标准输出，则日志将会发送给/dev/null
logfile stdout
#设置数据库的数量，默认数据库为0，可以使用SELECT <dbid>命令在连接上指定数据库id
databases 16
#指定在多长时间内，有多少次更新操作，就将数据同步到数据文件，可以多个条件配合
#分别表示900秒（15分钟）内有1个更改，300秒（5分钟）内有10个更改以及60秒内有10000个更改
save 900 1
save 300 10
save 60 10000
#指定存储至本地数据库时是否压缩数据，默认为yes，Redis采用LZF压缩，如果为了节省CPU时间，可以关闭该选项，但会导致数据库文件变的巨大
rdbcompression yes
#指定本地数据库文件名，默认值为dump.rdb
dbfilename dump.rdb
#指定本地数据库存放目录
dir 'D:/XXX/redis/redis_database'
#设置当本机为slav服务时，设置master服务的IP地址及端口，在Redis启动时，它会自动从master进行数据同步
#slaveof 127.0.0.1 6379
#当master服务设置了密码保护时，slav服务连接master的密码
#masterauth 123456
#设置Redis连接密码，如果配置了连接密码，客户端在连接Redis时需要通过AUTH <password>命令提供密码，默认关闭
#requirepass foobared
#设置同一时间最大客户端连接数，默认无限制，Redis可以同时打开的客户端连接数为Redis进程可以打开的最大文件描述符数，如果设置 maxclients 0，表示不作限制。当客户端连接数到达限制时，Redis会关闭新的连接并向客户端返回max number of clients reached错误信息
maxclients 10000
#指定Redis最大内存限制，Redis在启动时会把数据加载到内存中，达到最大内存后，Redis会先尝试清除已到期或即将到期的Key，当此方法处理 后，仍然到达最大内存设置，将无法再进行写入操作，但仍然可以进行读取操作。Redis新的vm机制，会把Key存放内存，Value会存放在swap区
maxmemory 300m
#指定是否在每次更新操作后进行日志记录，Redis在默认情况下是异步的把数据写入磁盘，如果不开启，可能会在断电时导致一段时间内的数据丢失。因为 redis本身同步数据文件是按上面save条件来同步的，所以有的数据会在一段时间内只存在于内存中。默认为no
appendonly yes
#指定更新日志文件名，默认为appendonly.aof
appendfilename 'appendonly.aof'
#指定更新日志条件，共有3个可选值
#no：表示等操作系统进行数据缓存同步到磁盘（快）
#always：表示每次更新操作后手动调用fsync()将数据写到磁盘（慢，安全）
#everysec：表示每秒同步一次（折衷，默认值）
appendfsync everysec

```

## 2. 启动报错: Creating Server TCP listening socket \*:6379: bind: No error

`解决步骤`

1. redis-cli.exe
2. shutdown
3. exit
4. 重新启动
