# Redis

## 1. 安装

### 1.1 Windows

> windows 系统的 Redis 有两个配置文件，redis.windows.conf 和 redis.windows-service.conf，设置密码、配置时，只需要在 redis.windows.conf 文件中设置

**安装方式**

1. 使用 xxx.msi 安装，Redis 服务默认是自启动，即直接通过 redis-server.exe 启动；
2. 使用压缩包安装；

<font color="red">不管是哪种方式安装，都可以通过命令行加载配置文件方式或自启动服务启动。
但是第一种方式默认是自启动的，也就是安装后会自动生成启动命令，启动命令并没有加载 Redis 的配置文件（redis.windows.conf），因此会导致 redis 中绑定配置和密码设置不生效。可以设置为手动（计算机-管理-服务-设置为手动），禁用 Redis 的自启动用命令行方式启动</font>

**启动**

```shell
# 1. 命令行方式启动

# 启动服务端
./redis-server.exe redis.windows.conf
# 启动客户端
./redis-cli.exe                                     # 精简模式
./redis-cli.exe -h 127.0.0.1 -p 6379
./redis-cli.exe -h 127.0.0.1 -p 6379 -a 密码        # -a是指定密码，如果启动时不指定，也可以通过命令行 auth password 指定


# 2. 服务自启动方式， 使用压缩方式安装的Redis，如果需要实现自启动，只需将Redis服务注册成windows服务。在安装目录下，执行命令 redis-server --service-install redis.windows.conf --loglevel verbose --service-name Redis；执行成功后表示已经安装成为windows服务了，但是安装服务后，默认不是马上启动的，但启动类型是自启动，如果想马上启动，需要执行启动命令或重启电脑

# --service-install redis.windows.conf 指定redis配置文件
# --loglevel notice  指定日志级别，Redis总共支持四个级别：debug、verbose、notice、warning，默认为verbose
# --service-name   指定redis服务名称

# 2.1 启动redis服务
redis-server --service-start
# 2.2 停止redis服务
redis-server --service-stop
# 2.3 还可以安装多个服务
redis-server --service-install -service-name redisService1 -port 3306
redis-server --service-install -service-name redisService2 -port 3307
# 2.4 卸载删除redis服务
redis-server --service-uninstall
sc delete 服务名  # 删除服务（管理员身份运行）

```

### 1.2 Linux

参考：https://www.cnblogs.com/xsge/p/13841875.html

使用压缩包方式或 rpm 包安装，启动命令基本相同，如果要添加配置、设置密码，只需要修改 redis.conf 文件

```sh
# 解压，将解压文件存放在 /usr/local/redis 目录
tar -zxvf redis-6.0.6
# 安装gcc，ContOS7默认安装4.8.5版本
yum -y gcc-c++
# 升级gcc，不升级因为版本低，安装时会报错
yum -y install centos-release-scl
yum -y install devtoolset-9-gcc devtoolset-9-gcc-c++ devtoolset-9-binutils
echo "source /opt/rh/devtoolset-9/enable" >>/etc/profile
systemctl enable devtoolset-9 bash
# redis程序编译
make
make install PREFIX=/usr/local/redis    # 将redis安装在指定位置，默认在/usr/local/bin，也可以在编译前通过./configure --prefix=/usr/local/bin设置安装位置
# 在安装位置新增配置文件redis.conf，可以用来配置属性和设置密码
mkdir conf
cp redis.conf /usr/local/redis/bin/conf/
```

### 1.3 配置文件详解

```sh
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

## 2. Spring Cache 和 Redis 区别

1. Spring cache 是由 Spring Framwork 提供的一个缓存抽象层，可以接入各种缓存解决方案来进行使用，通过 Spring Cache 的集成，只需要通过一组注解来操作缓存就可以了。其主要的原理就是向 Spring Context 中注入 Cache 和 CacheManager 这两个 bean，再通过 Spring Boot 的自动装配技术，会根据项目中的配置文件自动注入合适的 Cache 和 CacheManager 实现。

一般是使用一个 ConcurrentHashMap，也就是说实际上是使用 JVM 的内存来缓存对象的，这势必会造成大量的内存消耗。但好处是显然的：使用方便。和 Spring 的事务管理类似，Spring cache 的关键原理就是 Spring AOP，通过 Spring AOP，其实现了在方法调用前、调用后获取方法的入参和返回值，进而实现了缓存的逻辑。 2. Redis 作为一个缓存服务器，是内存级的缓存。它是使用单纯的内存来进行缓存。

集群环境下，每台服务器的 Spring cache 是不同步的，因此 spring cache 只适合单机环境。如果使用 Redis 作为单独的缓存服务器，所有集群服务器统一访问 redis，就不会出现缓存不同步的情况。

**coffeine**

两个都是缓存的方式

不同点：
redis 是将数据存储到内存里
caffeine 是将数据存储在本地应用里

caffeine 和 redis 相比，没有了网络 IO 上的消耗

| 比较项       | ConcurrentHashMap | LRUMap                   | Ehcache                       | Guava Cache                         | Caffeine                |
| ------------ | ----------------- | ------------------------ | ----------------------------- | ----------------------------------- | ----------------------- |
| 读写性能     | 很好，分段锁      | 一般，全局加锁           | 好                            | 好，需要做淘汰操作                  | 很好                    |
| 淘汰算法     | 无                | LRU，一般                | 支持多种淘汰算法,LRU,LFU,FIFO | LRU，一般                           | W-TinyLFU, 很好         |
| 功能丰富程度 | 功能比较简单      | 功能比较单一             | 功能很丰富                    | 功能很丰富，支持刷新和虚引用等      | 功能和 Guava Cache 类似 |
| 工具大小     | jdk 自带类，很小  | 基于 LinkedHashMap，较小 | 很大，最新版本 1.4MB          | 是 Guava 工具类中的一个小部分，较小 | 一般，最新版本 644KB    |
| 是否持久化   | 否                | 否                       | 是                            | 否                                  | 否                      |
| 是否支持集群 | 否                | 否                       | 是                            | 否                                  | 否                      |


## 3. Redis 客户端对比



## 常见问题

**启动报错: Creating Server TCP listening socket \*:6379: bind: No error**

```sh
# 解决步骤
1. redis-cli.exe
2. shutdown
3. exit
4. 重新启动
```

## 12. Reids 集群实战部署

```shell
#先创建一个redis的网卡
docker network create --driver bridge --subnet 192.167.0.0/16 --gateway 192.167.0.1 redis
#编写创建redis配置的脚本
for port in $(seq 1 6); \
do \
mkdir -p /mydata/redis/node-${port}/conf
touch /mydata/redis/node-${port}/conf/redis.conf
cat <<EOF>>/mydata/redis/node-${port}/conf/redis.conf
port 6379
bind 0.0.0.0
cluster-enabled yes
cluster-config-file nodes.conf
cluster-node-timeout 5000
cluster-announce-ip 192.167.0.1${port}
cluster-announce-port 6379
cluster-announce-bus-port 16379
appendonly yes
EOF
done
#启动redis集群
for port in $(seq 1 6); \
do \
docker run -p 637${port}:6379 -p 1637${port}:16379 --name=redis-${port} -v /mydata/redis/node-${port}/data:/data -v /mydata/redis/node-${port}/conf/redis.conf:/etc/redis/redis.conf -d --net redis --ip 192.167.0.1${port} redis:5.0.9-alpine3.11 redis-server /etc/redis/redis.conf
done


docker run -p 6371:6379 -p 16371:16379 --name=redis-1 -v /mydata/redis/node-1/data:/data -v /mydata/redis/node-1/conf/redis.conf:/etc/redis/redis.conf -d --net redis --ip 192.167.0.11 redis:5.0.9-alpine3.11 redis-server /etc/redis/redis.conf
#创建集群
docker exec -it redis-1 /bin/sh
redis-cli --cluster create 192.167.0.11:6379 192.167.0.12:6379 192.167.0.13:6379 192.167.0.14:6379 192.167.0.15:6379 192.167.0.16:6379 --cluster-replicas 1
```
