# Docker

## 1. 概念

Docker是基于Go语言实现的云开源项目。

Docker 是一个开源的应用容器引擎，让开发者可以打包他们的应用以及依赖包到一个可移植的容器中，然后发布到任何流行的 Linux 机器上，也可以实现虚拟化。容器是完全使用沙盒机制，相互之间不会有任何接口(类似 iPhone 的 app)。几乎没有性能开销,可以很容易地在机器和数据中心中运行。最重要的是,他们不依赖于任何语言、框架或包装系统。


**docker 为什么比 jvm 快**

- docker 比 jvm 有更少的抽象层
- docker 利用的是宿主机内核，而 jvm 需要客户操作系统 os，所以说，新建一个容器的时候，docker 不需要像虚拟机一样重新加载一个操作系统的内核，避免引导，虚拟机加载 Guest OS ，是分钟级别的，而 docker 是不需要这个过程的。

![docker与虚拟机对比](images/docker与虚拟机对比.png)

## 2. 安装

[参考官方文档安装：https://docs.docker.com/engine/install/centos/](https://docs.docker.com/engine/install/centos/)

```shell
# 1、卸载旧版本，\表示换行
sudo yum remove docker \
                        docker-client \
                        docker-client-latest \
                        docker-common \
                        docker-latest \
                        docker-latest-logrotate \
                        docker-logrotate \
                        docker-engine
sudo yum remove docker-ce docker-ce-cli containerd.io
sudo rm -rf /var/lib/docker
# 2、安装依赖包
sudo yum install -y yum-utils
# 3、设置镜像的仓库、更新yum软件包索引
yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
yum makecache fast
# 4、安装docker相关的源 docker-ce 社区 ee 企业版
yum install docker-ce docker-ce-cli containerd.io   # docker的默认工作路径：/var/lib/docker，--installroot=[file]指定安装位置
# 5、启动docker
systemctl start docker
service docker start
# 6、查看是否安装成功
docker version
# 7、 配置镜像加速器
vim /etc/docker/daemon.json
{
	"registry-mirrors": ["***"]
}
sudo systemctl daemon-reload
sudo systemctl restart docker
# 8、docker run hello-world
```

## 3. 核心

### 3.1 镜像 image

镜像是一种轻量级、可执行的独立软件包，用来打包软件运行环境和基于运行环境开发的软件，他包含运行某个软件所需的所有内容，包括代码、运行时库、环境变量和配置文件。

所有的应用都可以直接打包成 docker 镜像，镜像可以用来创建 Docker 容器，一个镜像可以创建很多容器。`Docker 镜像都是只读的，当容器启动时，一个新的可写层加载到镜像的顶部！`

### 3.2 容器 container

Docker 利用容器（Container）独立运行的一个或一组应用。容器是用镜像创建的运行实例。它可以被启动、开始、停止、删除。每个容器都是相互隔离的、保证安全的平台。可以把容器看做是一个简易版的 Linux 环境（包括root用户权限、进程空间、用户空间和网络空间等）和运行在其中的应用程序。容器的定义和镜像几乎一模一样，也是一堆层的统一视角，唯一区别在于容器的最上面那一层是可读可写的。

### 3.3 仓库 repository

仓库（Repository）是集中存放镜像文件的场所。
仓库(Repository)和仓库注册服务器（Registry）是有区别的。仓库注册服务器上往往存放着多个仓库，每个仓库中又包含了多个镜像，每个镜像有不同的标签（tag）。

### 3.4 联合文件系统 UnionFS

UnionFS（联合文件系统）： Union文件系统（UnionFS）是一种分层、轻量级并且高性能的文件系统，它支持对文件系统的修改作为一次提交来一层层的叠加，同时可以将不同目录挂载到同一个虚拟文件系统下。

Union 文件系统是 Docker 镜像的基础，Docker 的镜像实际上由一层一层的文件系统组成。镜像通过分层来进行继承，基于基础镜像（没有父镜像），可以制作各种具体的应用镜像。

**特性**：一次同时加载多个文件系统，但从外面看起来，只能看到一个文件系统，联合加载会把各层文件系统叠加起来，这样最终的文件系统会包含所有底层的文件和目录

**分层结构的特点**

比如：有多个镜像都从相同的 base 镜像构建而来，那么宿主机只需在磁盘上保存一份 base 镜像，同时内存中也只需加载一份 base 镜像，就可以为所有容器服务了。而且镜像的每一层都可以被共享。

### 3.5 镜像加载原理

Bootfs(boot file system) 主要包含 Bootloader 和 Kernel, Bootloader 主要是引导加载Kernel, Linux 刚启动时会加载 Bootfs 文件系统，在 Docker 镜像的最底层是 bootfs。这一层与我们典型的 Linux/Unix 系
统是一样的，包含 Boot 加载器和内核。当 boot 加载完成之后整个内核就都在内存中了，此时内存的使用权已由 bootfs 转交给内核，此时系统也会卸载 bootfs。

Rootfs (root file system) ，在 Bootfs 之上。包含的就是典型 Linux 系统中的 /dev, /proc, /bin, /etc 等标准目录和文件。Rootfs就是各种不同的操作系统发行版，比如Ubuntu，Centos等等。

Docker 镜像都是只读的，当容器启动时，一个新的可写层被加载到镜像的顶部，这一层通常被称为容器层,容器层之下的都叫镜像层。

### 3.6. 容器数据卷

Docker 容器产生的数据，如果不通过 docker commit 生成新的镜像，使得数据做为镜像的一部分保存下来，那么当容器删除后，数据自然也就没有了。这时为了解决容器的数据持久化，需要通过容器数据卷来解决这个问题。

卷就是目录或文件，存在于一个或多个容器中，由 docker 挂载到容器，但不属于联合文件系统，因此能够绕过 Union File System 提供一些用于持续存储或共享数据的特性：

卷的设计目的就是数据的持久化，完全独立于容器的生存周期，因此 Docker 不会在容器删除时删除其挂载的数据卷

特点：

1. 数据卷可在容器之间共享或重用数据
2. 卷中的更改可以直接生效
3. 数据卷中的更改不会包含在镜像的更新中
4. 数据卷的生命周期一直持续到没有容器使用它为止


- 服务 services

## 4. 基础命令

```shell
# 1. 帮助
docker verison / info / --help

# 2. 镜像
# 默认情况下会从 docker hub 搜索、拉取、推送镜像；如果从私有仓库获取镜像，则需要指定地址 http://{ip}:{port}/{images}:{tag}
# docker与各个仓库地址默认以https协议进行通信，除非该仓库地址允许以不安全的链接方式访问

docker search <name>                  # 搜索
docker pull <name>                    # docker pull 192.168.100.79:5000/xxx:latest
docker images                         # 列出所有镜像，-a 包括隐藏的中间镜像、-q 只显示镜像ID、--digests 显示镜像的摘要信息、--no-trunc 显示完整的镜像信息
docker rmi -f <imageId...>            # 删除指定镜像，可以多个， -f 强制删除
docker rmi -f $(docker images -aq)    # 删除所有镜像
docker history <imageId>              # 查看镜像分层信息
docker login                          # 登录
docker push                           # 推送
docker tag SOURCE_IMAGE[:TAG] TARGET_IMAGE[:TAG]    # 创建一个引用原镜像的镜像，重命名，打tag

# 3. 容器
docker run -it --name=xxx -p xx:xx --restart=always <images>
  # --name='name' 容器名
  # -d 后台方式运行，（常见的坑）后台运行时可以会导致服务停止，因为容器使用后台运行，就必须要有一个前台进程，docker发现没有应用，就会自动停止。
  # -it 使用交互方式运行，进入容器查看分区
  # -p 指定端口，格式：-p ip:主机端口:容器端口
  # -P 随机分配端口
  # -e 环境配置，比如mysql设置密码 -e MYSQL_ROOT_PASSWORD=123456
  # --env-file 指定环境变量文件
  # --link --link <container_name>:<alias> ，第一个参数为链接到的另一个容器的名称或 ID，第二个参数为链接的别名，可省略。原理就是在/etc/hosts里面添加了一个alias的名称
  # --restart  重启策略，重启是由Docker守护进程完成的；
      # no默认策略，容器退出时不重启容器、
      # on-failure容器非正常退出时才会重启（容器退出状态不为0）、
      # on-failure:3 容器非正常退出时最多重启三次、
      # always容器退出时总是重启、
      # unless-stopped容器退出时总是重启，但不考虑Docker守护进程启动时就已经停止了的容器


docker exec -it <containerId> /bin/bash   # 进入容器后开启一个新的终端，可以在里面操作(常用)，使用exit退出时容器不会停掉
docker attach <containerId>               # 进入容器正在执行的终端，不会启动新的进程，使用exit退出时容器会停掉
exit / Ctrl + P + Q                       # 退出容器，exit 有可能会导致容器停止
docker ps                                 # 列出所有运行的容器，-a 列出停止的容器，-n 显示最近n个创建的容器(包括所有状态)，--no-trunc 不截断输出。
docker rm -f <containerId>                # 删除指定容器
docker rm -f $(docker ps -aq)             # 删除所有容器，等同于 docker ps -aq | xargs docker rm
docker start <containerId>                # 启动容器
docker restart <containerId>              # 重启容器
docker stop <containerId>                 # 停止当前正在运行的容器
docker kill <containerId>                 # 强制停止当前容器

docker logs -f -t --tail 20 <container>   # 查看日志 -f 滚动输出、-t 展示时间、--tail 最后的20行。
docker logs <container> >> log_error.txt  # 日志写到文件中。
docker inspect xxxx                       # 查看容器/镜像元数据，比如日志文件路径等
docker top <containerId>                  # 查看容器中的进程信息

docker cp [r] <containerId>:容器内路径 目的地主机路径      # 容器内拷贝到宿主机上，-r 递归拷贝
docker commit -m="描述信息" -a="作者" 容器id  镜像名:TAG   # 提交容器成为一个新的副本(镜像)

docker save -o xxx.tar 镜像    # 将仓库中的镜像导出成tar格式的文件
docker load -i xxx.tar        # 将tar格式的镜像文件导入到本地镜像仓库
docker image prune            # 删除所有未被 tag 标记和未被容器使用的镜像（既没有标签名也没有容器引用的镜像），-a 删除所有未被容器使用的镜像

# 监控容器资源消耗
docker stats <containerId>  # 每隔1s刷新一次输出内容，--no-stream 只输出当前状态（输出一次），--format 按照自定义格式（table或json）输出
docker stats --format "table {{.Name}}\t{{.ID}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}\t{{.BlockIO}}\t{{.MemPerc}}\t{{.PIDs }}"
docker stats --format "{\"container\":\"{{.Container}}\"}"

# -v 挂载
# volumn
匿名挂载  -v 容器内路径
具名挂载  -v 卷名:容器内路径
docker volume ls  # 查询
# -v 容器内路径：ro rw 改变读写权限
docker run -d -P --name nginx05 -v juming:/etc/nginx:ro nginx
# --volumes-from　多容器之间共享数据卷
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# eg: nginx
-v /etc/local/nginx/html:/usr/share/nginx/html
-v /etc/local/nginx/conf/nginx.conf:/etc/nginx/nginx.conf
-v /etc/local/nginx/logs:/var/log/nginx/
```

## 5. Dockerfile

是用来构建镜像的文本文件。默认文件名为 Dockerfile，如果不是默认的，可通过 -f 指定。

<div style="color:red;font-size:20px">docker build -f Dockerfile -t [imageName]:[tag] .</div>

docker 执行一个 Dockerfile 脚本的流程大致为：

- docker 从基础镜像运行一个容器
- 执行一条指令并对容器作出修改
- 执行类似 docker commit 的操作提交一个新的镜像层
- docker 再基于刚提交的镜像运行一个新的容器
- 执行 dockerfile 中的下一条指令直到所有指令都执行完成

| 指令       | 说明                                                         |
| ---------- | ------------------------------------------------------------ |
| FROM       | 基础镜像，当前新镜像是基于哪个镜像的，有继承的意味           |
| MAINTAINER | 镜像维护者的姓名和邮箱地址                                   |
| RUN        | 容器构建时需要运行的命令                                     |
| EXPOSE     | 当前容器对外暴露的端口                                       |
| WORKDIR    | 指定在创建容器后，终端默认登录的进来工作目录，一个落脚点     |
| ENV        | 用来在构建镜像过程中设置环境变量                             |
| ADD        | 将宿主机目录下的文件拷贝进镜像且ADD命令会自动处理URL和解压tar压缩包 |
| COPY       | 类似ADD，拷贝文件和目录到镜像中。<br/>将从构建上下文目录中<源路径>的文件/目录复制到新的一层的镜像内的<目标路径>位置<br/>COPY src dest <br/>COPY ["src","dest"] |
| VOLUME     | 容器数据卷，用于数据保存和持久化工作                         |
| CMD        | 指定一个容器启动时要运行的命令<br/>Dockerfile中可以有多个CMD指令，但只有最后一个生效，CMD会被docker run之后的参数替换 |
| ENTRYPOINT | 指定一个容器启动时要运行的命令，用来追加命令<br />ENTRYPOINT的目的和CMD一样，都是在指定容器启动程序及参数 |
| ONBUILD    | 当构建一个被继承的Dockerfile时运行命令,父镜像在被子继承后父镜像的onbuild被触发 |

**CMD 和 ENTRYPOINT 区别**

CMD 和 ENTRYPOINT 指令用于定义容器启动时的默认命令或程序，CMD可以被覆盖，而ENTRYPOINT是固定的。

**ADD 和 COPY 区别**

COPY 和 ADD 指令用于将文件或目录复制到容器中。但 ADD 指令功能更强大，可以自动解压文件和下载URL资源。建议在不需要特殊处理的情况下，优先使用COPY指令。


```shell
# 举个栗子
FROM centos
MAINTAINER dangbo<1456131152@qq.com>
EMV MYPATH /usr/local
WORKDIR $MYPATH
RUN yum -y install vim
RUN yum -y install net-tools

EXPOSE 80

CMD echo $MYPATH
CMD echo "-----end----"
CMD /bin/bash
```

![dockerFile](images/dockerfile.png)

## 6. 网络

Docker 容器每次重启后容器 ip 是会发生变化的。这也意味着如果容器间使用 ip 地址来进行通信的话，一旦有容器重启，重启的容器将不再能被访问到。而 Docker 网络就能够解决这个问题。

**作用**

1. 容器间的互联和通信以及端口映射
2. 容器 IP 变动的时候，可以通过服务名直接网络通信而不受到影响

因此只要是处于同一个Docker 网络下的容器就可以使用服务名进行直接访问，而无需担心重启。

**网络模式**

scope 参数用于指定网络的作用范围，可以是 local 或 swarm。

- local，适用于单个 Docker 守护程序主机上的容器。在 local 范围内创建的网络仅限于当前宿主机上的容器之间进行通信。这意味着该网络不会跨越宿主机边界，只能在单个宿主机上使用。
- swarm，适用于 Docker Swarm 中的服务和任务。在 swarm 范围内创建的网络可以跨越多个 Docker 守护程序主机，允许 Swarm 集群中的服务之间进行通信。可以实现在整个 Swarm 集群中的不同宿主机上运行的容器之间建立网络连接。

桥接模式–bridge

Docker 服务启动时，默认会创建一个名称为 docker0 网桥（其上有一个名称为 docker0 内部接口）。

该桥接网络的名称为 docker0，它在内核层连通了其他的物理或虚拟网卡，这就将所有容器和本地主机都放到同一个物理网络。

Docker 会默认指定docker0 的 ip 地址和子网掩码，让主机和容器之间可以通过网桥相互通信。

docker0 特点：默认，域名不能访问，--link 可以打通连接。

| 网络模式  | SCOPE | 描述                                                         |
| --------- | ----- | ------------------------------------------------------------ |
| bridge    | local | 桥接模式，是 Docker 默认采用的网络模式。每个容器都会分配一个独立的 IP 地址，并将容器连接到 docker0 虚拟网桥上，可以通过主机的 IP 地址进行访问。同时，桥接模式允许容器之间相互通信。 |
| host      | local | 主机模式。容器将不会获得独立的网络命名空间，而是直接使用宿主机的网络。这意味着容器可以直接访问宿主机上的网络接口，从而获得更高的网络性能，但也失去了网络隔离的好处。 |
| container | local | container 模式。和已经存在的一个容器共享一个 Network Namespace，而不是和宿主机共享 |
| none      | local | 无网络模式。拥有自己的 Network Namespace，但并不为Docker容器进行任何网络配置。也就是说，容器没有网卡、IP、路由等信息。这种模式适用于特殊情况，例如只需要文件系统隔离而不需要网络连接的场景。 |
| overlay   | swarm | Overlay 模式。用于跨多个 Docker 守护进程的容器通信，通常与 Docker Swarm 或者 Kubernetes 等集群管理工具一起使用。 |


```shell
docker network --help     # 帮助

# 创建网络，--driver指定网络模式，默认bridge，--subnet 192.168.0.0/16 子网，--gateway 192.168.0.1 网关 
docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 <network_name> 
docker network create --dirver overlay --attachable --scope swarm app_net   # 创建网络，网络模式为overlay时，scope只能为swarm，--attachable 启用手动连接容器

docker network inspect <network_name>         # 显示网络的详细信息
docker network ls                             # 列出所有网络
docker network rm <network_name>              # 删除网络
docker network prune                          # 删除所有没有使用的网络
docker network connect <network_name> <container>        # 连接容器到网络
docker network disconnect <network_name> <container>     # 断开网络中的容器

# 举例
docker run -d -P --name tomcat01 --network bridge tomcat  # 启动容器时指定网络
docker network connect my-network my-container            # 将容器加入到网络
```

**使用网络**

```yml
# 手动创建网络或者已存在的网络。然后在配置文件加入外部网络
networks:
  dev:
    external: true

# 配置文件中直接定义网络，在启动时，会自动创建，常用于将所有的服务放在一个compose文件的场景。
networks:
  dev-net:
    driver: overlay
networks:
  dev-net:
    driver: bridge  

version: '3'
services:
  nacos:
    restart: always    

version: '3'
services:
  mysql:
    restart: always
    image: mysql:5.7.31
    ports:
      - 13306:3306
    networks:
      - dev-net  

```

## 7. docker-compose

Docker Compose 负责实现对 Docker 容器集群的快速编排。将所管理的容器分为三层，分别是工程（project）、服务（service）、容器（container），运行目录下的所有文件（docker-compose.yml）组成一个工程，一个工程包含多个服务，每个服务中定义了容器运行的镜像、参数、依赖，一个服务可包括多个容器实例。

使用 docker-compse 编排的一组容器时会默认创建一个网络，并且这组容器全部都会加入到网络当中。容器之间可以直接使用服务名去直接通信。

**安装**

```shell
# 下载docker-compose文件，如果报错，直接到官网下载，之后将名称改为docker-compose即可
curl -L https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
# 赋予权限
chmod +x /usr/local/bin/docker-compose
# 查看版本，用来检查安装是否成功
docker-compose version
```

**常用命令**

```shell
# 执行命令，是针对项目工程而言的，必须在对应的目录下执行
docker-compose config [SERVICE]                   # 验证Compose文件格式是否正确
docker-compose build [options] [SERVICE...]				# 基于docker-compose.yml文件构建或重新构建镜像，而不是运行，--no-cache当构建镜像时，不使用缓存
docker-compost up -d [options] [SERVICE...]	      # 创建并运行容器，也就是部署一个Compose应用，如果之前已经构建了镜像，则它只会运行它。默认读取 docker-compose.yaml/yml 文件，-f 指定其他文件名，-d 应用在后台启动
docker-compose up -d --build .                    # 上两条命令的集合体，构建并运行

docker-compose ls                                 # 列出所有项目
docker-compose ps	[SERVICE...]				            # 列出项目中目前的所有容器

docker-compose stop [options] [SERVICE...]        # 停止Compose应用相关的服务容器，如果不加参数和服务名，则停止所有的服务容器
docker-compose start [options] [SERVICE...]  			# 启动已经存在的服务
docker-compose restart [options] [SERVICE...]			# 重启项目中的服务
docker-compose run [options] [SERVICE...]			    # 在一个新的容器中运行一个服务
docker-compose down [options] [SERVICE...]        # 停止和删除容器、网络，–rmi all/local删除所有或镜像名为空的镜像 -v 删除卷
docker-compose rm [options] [SERVICE...] 		      # 删除所有（停止状态的）服务容器，-f 强制删除，推荐先执行stop停止容量，再删除
docker-compose logs	[options] [SERVICE...]				# 查看服务容器日志的输出
docker-compose kill                       	      # 通过发送SIGKILL信号来强制停止服务容器，-s指定发送的信号

docker-compose port SERVICE PRIVATE_PORT          # 显示某个容器端口所映射的公共端口
```

**区别**

Docker Compose 是用于在单个主机上定义和运行多个容器应用程序的工具，通常情况下，它并不直接支持不同宿主机上容器之间的通信。Docker Compose 主要用于本地开发、测试和部署单个主机上的应用程序。

如果你需要在不同宿主机上运行的容器之间进行通信，可以考虑使用 Docker Swarm 或 Kubernetes 等容器编排工具来实现跨主机通信。这些工具提供了跨主机的网络功能，使不同主机上的容器能够相互通信。

在 Docker Swarm 中，你可以创建 overlay 网络来连接不同节点上的容器，从而实现跨主机通信。通过在 Swarm 集群中部署服务，并将容器加入到同一个 overlay 网络中，即可实现不同宿主机上容器之间的通信。

|          | docker stack                                                                                                                | docker-compose                                                                                                                    |
| -------- | --------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| 开发语言 | go 语言                                                                                                                     | python 语言                                                                                                                       |
| 支持版本 | 只支持 version3 以上版本                                                                                                    | 都可以                                                                                                                            |
| 安装     | Swarm 模式已经在 1.12 中集成到 Docker Engine 中，docker stack 是 swarm mode 的一部分, 即使是单机使用, 也需要一个 swarm 节点 | 需要额外的安装                                                                                                                    |
| 命令     | docker stack deploy -c docker-compose.yml serviceName                                                                       | docker-compose up -d -f docker-compose.yml                                                                                        |
| 作用     | 适合于迭代开发、测试和 快速验证原型                                                                                         | 适用于开发、测试环境的容器编排工具                                                                                                |
| 区别     | 通过 deploy，构建服务，不支持 build，无法使用 stack 命令构建 build 新镜像，它是需要镜像是预先已经构建好的。                 | 通过 build，构建服务;更适合于开发场景，不支持 deploy，所以在 yml 中使用 deploy 就会报错，可以是镜像，也可以和 Dockerfile 配合使用 |

```yml
version: '3'
services:
  mysql:
    image: mysql:8.0.20
    restart: always         # stack 没有该参数，使用 --update-delay、--update-parallelism、--update-failure-action 等参数来定义服务更新时的行为，以及容器失败时的处理方式。
    container_name: mysql   # stack 没有该参数
    ports:
      - 3306:3306
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_ROOT_PASSWORD=db123456
    volumes:
      - "./data:/var/lib/mysql"                 # 挂载数据
      - "./conf/my.cnf:/etc/my.cnf"             # 挂载配置文件
      - "./init:/docker-entrypoint-initdb.d/"   # 挂载初始化sql
    command:
      --default-authentication-plugin=mysql_native_password
    networks:
      - dev-net

# 同一个网络下，可以直接使用容器名称来代替ip地址进行访问。
networks:
  dev-net:
    external: true
```

## 8. docker stack

docker stack 被定义为适用于生产环境的编排工具，强化了（复制集、 容器重启策略、回滚策略、服务更新策略）等生产特性；docker stack 几乎能做 docker-compose 所有的事情 （生产部署 docker stack 表现还更好），docker stack 是进阶 docker swarm 的必经之路，docker stack 可认为是单机上的负载均衡部署； 可认为是多节点集群部署（docker swarm）的特例。

其中，stack为项目名/栈名，组织和管理一组相互关联的服务，service为服务名，每个服务由一个或多个任务（task）组成，每个任务对应着运行中的容器。

**常用命令**

```bash
docker stack deploy -c stackFile路径 service名 --with-registry-auth  # 部署 stack，-c 路径，--with-registry-auth 向swarm代理发送Registry认证详细信息
docker stack ls                       # 列出所有 stack
docker stack services <stack_name>    # 查询 stack 的服务列表
docker stack rm <stack_name>          # 删除 stack
docker stack ps <stack_name>          # 查询 stack 的任务运行状态，和 docker service ps <service_name> 类似，它会将 stack 下的 所有 service 的任务状态列出来

docker service create --name <service_name> --network <network_name> <image>      # 基于某个镜像创建一个服务，比如将服务添加到该网络中，实现使用服务名访问。
docker service ls                     # 列出所有服务
docker service ps <service_name>      # 查询服务中的任务运行状态。说明：任务和容器不是一回事，每个服务由一个或多个任务（task）组成，每个任务对应着运行中的容器。
docker service logs --tail 1000 -f <service_name>   # 查询日志
docker service update --force <service_name>        # 重启某个服务
docker service rm <service_name>                    # 删除某个服务
docker service inspect <service_name>               # 展示某个服务的详细信息
```

![image-20210517182851579](images/docker-stack.png)

**举例**

```yaml
version: '3.2'
services:
  database:
    image: mysql:5.7.31
    ports:
      - 3306:3306
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_ROOT_PASSWORD=db123456
    volumes:
      - "./data:/var/lib/mysql"                 # 挂载数据
      - "./conf/my.cnf:/etc/my.cnf"             # 挂载配置文件
      - "./init:/docker-entrypoint-initdb.d/"   # 挂载初始化sql
    command:
      --default-authentication-plugin=mysql_native_password
    deploy:
      replicas: 1                   # 制定容器数量
      restart_policy:
        condition: on-failure
      resources:
        limits:
          cpus: "8"                 # 20%的内存可用处理时间
          memory: 21024M            # 内存不超过1024M
      update_config:
        parallelism: 1              # 每次启动一个容器一份服务
        delay: 5s                   # 更新一组容器之间的等待时间
        monitor: 10s                # 单次更新多长时间后没有结束则判定更新失败
        max_failure_ratio: 0.1      # 更新时能容忍的最大失败率
    networks:
      dev-net:
        aliases:
          - mysql   # 在该网络下，给服务起别名，同一个网络下的服务，可以直接通过别名来访问，如果不起别名，默认为服务名。
  redis:
    image: redis:5.0.7
    ports:
      - "6379:6379"
    volumes:
      - "/usr/local/redis/redis.conf:/etc/redis/redis.conf"
      - "/usr/local/redis/data:/data"
    command:
      redis-server /etc/redis/redis.conf
    deploy:
      restart_policy:
        condition: on-failure
      resources:
        limits:
          memory: 500M
        reservations:
          memory: 200M
    networks:
      dev-net:
        aliases:
          - redis.host

networks:
  dev-net:
    driver: overlay
```

## 9. 私有仓库（registry）

Docker 官方提供了公共的镜像仓库（Docker Hub），但是从安全和效率等方面考虑，在大多数公司都会部署私有环境内的 Registry。其实 Docker 官方也提供了一个私有镜像仓库 docker Registry，安装部署容易，安装一个 Registry 容器就可以使用。但是 Registry 缺点比较明显：

1. 没有图形界面
2. 没有项目管理
3. 没有用户权限控制
4. 看不到镜像操作记录

目前比较常见的有几种：Harbor、hyper/docker-registry-web UI 展示、portainer 可视化管理，最常用的是 Harbor，他是由 VMware 公司开源的企业级的 Docker Registry 管理项目，它以 Docker 公司开源的 Registry 为基础，帮助用户迅速搭建一个企业级的 docker Registry 服务；Harbor 提供了如下功能：

1. 基于角色的访问控制(Role Based Access Control)
2. 基于策略的镜像复制(Policy based image replication)
3. 镜像的漏洞扫描(Vulnerability Scanning)
4. AD/LDAP 集成(LDAP/AD support)
5. 镜像的删除和空间清理(Image deletion & garbage collection)
6. 友好的管理 UI(Graphical user portal)
7. 审计日志(Audit logging)
8. RESTful API
9. 部署简单(Easy deployment)

**registry**

```shell
# 拉取、启动、测试
docker pull registry
docker run -it --name registry --restart=always -p 5000:5000 -v /usr/local/registry/:/var/lib/registry registry:latest
http://{ip}:5000/v2             # 正常情况时，会返回 {}
http://{ip}:5000/v2/_catalog    # 所有的镜像
docker tag <sourceImage:tag> <targerImage:tag> # 将原镜像重命名，因为如果要将镜像push到私有仓库，就必须按照格式命名：ip:port/imageName:tag
docker push <targerImage:tag>
# 使用hyper/docker-registry-web
docker pull hyper/docker-registry-web
docker run -d -p 5001:8080 --name regisry-web --restart=always --link registry -e registry_url=http://registry:5000/v2 -e registry_name=localhost:5000 hyper/docker-registry-web:latest
```

**harbor**

harbor 是使用 docker-compose 部署的，因此必须安装 docker-compose。[安装 docker-compose](#7-docker-compose)

```shell
# 1. 官网下载并解压
# 2. 如果需要修改配置文件中的内容，比如用户密码，端口等，可以在 Harbor.yml 中修改
# 3. ./install.sh，Harbor 服务就会根据当期目录下的 docker-compose.yml 开始下载依赖的镜像，检测并按照顺序依次启动各个服务
# 4. 开机自启动

① vim /usr/lib/systemd/system/harbor.service
② 增加内容
[Unit]
Description=Harbor
After=docker.service systemd-networkd.service systemd-resolved.service
Requires=docker.service
Documentation=http://github.com/vmware/harbor

[Service]
Type=simple
Restart=on-failure
RestartSec=5
# docker-compose 和 harbor 的安装位置
ExecStart=/usr/local/bin/docker-compose -f  /usr/local/harbor/docker-compose.yml up
ExecStop=/usr/local/bin/docker-compose -f /usr/local/harbor/docker-compose.yml down

[Install]
WantedBy=multi-user.target
③ systemctl enable harbor
```

## 10. IDEA 集成 Docker 的远程访问

1. 修改 docker 配置文件并重启：
   - 配置文件：`/lib/systemd/system/docker.service`
   - 重启命令：`systemctl restart docker`
   - 命令：`ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock`

![image-20210311172031335](images/docker-idea2.png)

2. 防火墙开启 2375 端口

3. 远程测试自验：http://docker 宿主机 ip:2375/version
4. idea 配置 docker

![image-20210311172906434](images/docker-idea.png)

## 11. gitlab 集成 cicd

1. 仓库根目录 创建一个.gitlab-ci.yml 文件
2. 安装 gitlab-runner
