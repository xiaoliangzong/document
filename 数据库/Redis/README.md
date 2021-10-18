# Redis

## 1. windows 安装

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

## 2. Linux 安装

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

## 3. Redis 的配置文件详解

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

## 常见问题

**启动报错: Creating Server TCP listening socket \*:6379: bind: No error**

```sh
# 解决步骤
1. redis-cli.exe
2. shutdown
3. exit
4. 重新启动
```
