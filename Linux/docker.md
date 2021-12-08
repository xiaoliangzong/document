# docker

## 1. 概念

- 联合文件系统 UnionFs ：是一种分层、轻量级并且高性能的文件系统，他支持对文件系统的修改作为一次提交来一层层的叠加，同时可以将不同目录挂载到同一个虚拟文件系统下

- 分层技术

- 镜像 images ：镜像是一种轻量级、可执行的独立软件包，用来打包软件运行环境和基于运行环境开发的软件，他包含运行某个软件所需的所有内容，包括代码、运行时库、环境变量和配置文件。

  所有的应用，直接打包 docker 镜像，就可以直接跑起来！`Docker 镜像都是只读的，当容器启动时，一个新的可写层加载到镜像的顶部！`

- 容器 container

- 仓库 repository

- 服务 services

## 2. 安装

```shell
# 1、卸载旧版本，\表示换行
sudo yum remove docker docker-client docker-client-latest docker-common \
docker-latest docker-latest-logrotate docker-logrotate docker-engine
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
	registry-mirrors:["***"]
}
sudo systemctl daemon-reload
sudo systemctl restart docker
# 8、docker run hello-world
```

## 3. 基础命令

```shell
# 1、帮助命令
docker verison    info    命令 --help
# 2、镜像
docker -a images  # 列出所有镜像，-a包括隐藏的中间镜像
docker search **  # 搜索
docker pull mysql:5.7  || docker.io/library/mysql:latest  # 克隆镜像
docker rmi -f 镜像id 镜像id    # 删除指定镜像
docker rmi -f $(docker images -aq) # 删除所有镜像
docker history 镜像id 	# 查看镜像分层信息
# 3、容器
docker run images
	# --name='name' 容器名
	# -d 后台方式运行
docker run -d centos后台运行，使用docker ps 发现服务停止，常见的坑, docker容器使用后台运行，就必须要有一个前台进程，docker发现没有应用，就会自动停止。 nginx,容器启动后，发现自己没有提供服务，就会立刻停止，就是没有程序了
	# -it 使用交互方式运行，进入容器查看分区
	# -p 指定端口      格式： -p ip:主机端口:容器端口
	# -P 随机分配端口
exit 				# 直接容器停止并退出
Ctrl + P + Q      # 容器不停止退出
docker ps 			# 列出所有运行的容器，如果列出停止的容器，使用-a
docker rm -f 容器id
docker rm -f $(docker ps -aq)
docker ps -aq | xargs docker rm    # 删除所有的容器

docker start 容器id         # 启动容器
docker restart 容器id       # 重启容器
docker stop 容器id         # 停止当前正在运行的容器
docker kill 容器id         # 强制停止当前容器

docker logs -f -t --tail 20 容器	# 查看日志 -f 滚动输出、-t 展示时间、--tail 最后的20行。
docker logs xxx >> lot_error.txt  # 日志写到文件中。
docker inspect 容器id 			# 查看容器的日志文件路径

docker top 容器id 	# 查看容器中的进程信息
docker inspect f1178d5b0bd8（或者镜像id） # 查看镜像源数据

# 进入当前正在运行的容器
docker exec -it 容器id /bin/bash		# 进入容器后开启一个新的终端，可以在里面操作(常用)
docker attach 容器id					# 进入容器正在执行的终端，不会启动新的进程

docker cp [r] 容器id :容器内路径 目的地主机路径  # 容器内拷贝到宿主机上，-r 递归拷贝

docker commit -m="描述信息" -a="作者" 容器id  镜像名:TAG			#提交容器成为一个新的副本(镜像)

-e  # 环境配置：比如mysql设置密码 -e MYSQL_ROOT_PASSWORD=123456

docker save 镜像id xxx.tar # 将仓库中的镜像导出成tar格式的文件
docker load -i xxx.tar  # 将tar格式的镜像文件导入到本地镜像仓库
docker image prune    # 用以清理不再使用的docker镜像。执行docker image prune默认会清除"悬空"镜像
#清除所有没有容器引用的镜像，增加一个 -a
```

## 4. 容器数据卷

```shell
数据可以持久化
# -v 挂载
# volumn
匿名挂载  -v 容器内路径!
具名挂载  -v 卷名:容器内路径
docker volume ls  # 查询
# 通过 -v 容器内路径： ro rw 改变读写权限
docker run -d -P --name nginx05 -v juming:/etc/nginx:ro nginx
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# eg: nginx
-v /etc/local/nginx/html:/usr/share/nginx/html
-v /etc/local/nginx/conf/nginx.conf:/etc/nginx/nginx.conf
-v /etc/local/nginx/logs:/var/log/nginx/
```

## 5. dockerFile

- 编写 dockerFile 文件，名字可以随便 建议 Dockerfile
- docker build 构建成为一个镜像
- docker run 运行镜像
- docker push 发布镜像（dockerhub、阿里云仓库）

```shell
FROM			# 基础镜像，一切从这里开始构建
MAINTAINER		# dangbo<1456131152@qq.com>
RUN				# 镜像构建的时候需要运行的命令
ADD				# 步骤，tomcat镜像，这个tomcat压缩包！添加内容 添加同目录
WORKDIR			# 镜像的工作目录
VOLUME			# 挂载的目录
EXPOSE			# 保留端口配置
CMD				# 指定这个容器启动的时候要运行的命令，只有最后一个会生效，可被替代。
ENTRYPOINT		# 指定这个容器启动的时候要运行的命令，可以追加命令
ONBUILD			# 当构建一个被继承 DockerFile 这个时候就会运行ONBUILD的指令，触发指令。
COPY			# 类似ADD，将我们文件拷贝到镜像中
ENV				# 构建的时候设置环境变量！

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

# 2.通过这个文件构建镜像
# 命令 docker build -f 文件路径 -t 镜像名:[tag] .
docker build -f mydockerfile-centos -t mycentos:0.1 .

Successfully built 4af56313b71a
Successfully tagged mycentos:0.1

# 3.测试运行
```

## 6. 网络

```shell
# 我们直接启动的命令
docker run -d -P --name tomcat01 tomcat
docker run -d -P --name tomcat01 --net bridge tomcat

# docker0特点：默认，域名不能访问，--link可以打通连接

# 我们可以自定义一个网络
# --driver bridge
# --subnet 192.168.0.0/16    子网
# --gateway 192.168.0.1      网关
[root@AlibabaECS ~]# docker network create --driver bridge --subnet 192.168.0.0/16 --gateway 192.168.0.1 mynet
dd7c8522864cb87c332d355ccd837d94433f8f10d58695ecf278f8bcfc88c1fc
[root@AlibabaECS ~]# docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
04038c2f1d64        bridge              bridge              local
81476375c43d        host                host                local
dd7c8522864c        mynet               bridge              local
64ba38c2cb2b        none                null                local

```

## 7. docker-compose

```shell
# 负责实现对Docker容器集群的快速编排
# 工程project
# 服务service
# 容器containe

#Docker Compose 将所管理的容器分为三层，分别是工程（project）、服务（service）、容器（container）
#Docker Compose 运行目录下的所有文件（docker-compose.yml）组成一个工程,一个工程包含多个服务，每个服务中定义了容器运行的镜像、参数、依赖，一个服务可包括多个容器实例

```

常用命令：

```bash
docker-compose ps					# 列出所有运行容器
docker-compose logs					# 查看服务日志输出
docker-compose build				# build：构建或者重新构建服务
docker-compose port eureka 8761#port：打印绑定的公共端口，下面命令可以输出 eureka 服务 8761 端口所绑定的公共端口
docker-compose build				# build：构建或者重新构建服务
docker-compose start eureka			 # start：启动指定服务已存在的容器
docker-compose stop eureka			# stop：停止已运行的服务的容器
docker-compose rm eureka			# rm：删除指定服务的容器
docker-compose up					# up：构建、启动容器
docker-compose kill eureka			# kill：通过发送 SIGKILL 信号来停止指定服务的容器

```

## 8. docker stack

![image-20210517182851579](../../images/Linux/docker-stack.png)

1. stack 是构成特定环境中的 service 集合, 它是自动部署多个相互关联的服务的简便方法，而无需单独定义每个服务；stack --> service --> task(container)

2. stack file 是一种 yaml 格式的文件，类似于 docker-compose.yml 文件，它定义了一个或多个服务，并定义了服务的环境变量、部署标签、容器数量以及相关的环境特定配置等。
3. 文件编写

```yaml
version: '3.2'

services:
  reverse_proxy:
    image: dockersamples/atseasampleshopapp_reverse_proxy
    ports:
      - '80:80'
      - '443:443'
    secrets:
      - source: revprox_cert
        target: revprox_cert
      - source: revprox_key
        target: revprox_key
    networks:
      - front-tier

  database:
    image: dockersamples/atsea_db
    environment:
      POSTGRES_USER: gordonuser
      POSTGRES_DB_PASSWORD_FILE: /run/secrets/postgres_password
      POSTGRES_DB: atsea
    networks:
      - back-tier
    secrets:
      - postgres_password
    deploy:
      placement:
        constraints:
          - 'node.role == worker'

  appserver:
    image: dockersamples/atsea_app
    networks:
      - front-tier
      - back-tier
      - payment
    deploy:
      replicas: 2
      update_config:
        parallelism: 2
        failure_action: rollback
      placement:
        constraints:
          - 'node.role == worker'
      restart_policy:
        condition: on-failure
        delay: 5s
        max_attempts: 3
        window: 120s
    secrets:
      - postgres_password

  visualizer:
    image: dockersamples/visualizer:stable
    ports:
      - '8001:8080'
    stop_grace_period: 1m30s
    volumes:
      - '/var/run/docker.sock:/var/run/docker.sock'
    deploy:
      update_config:
        failure_action: rollback
      placement:
        constraints:
          - 'node.role == manager'

  payment_gateway:
    image: dockersamples/atseasampleshopapp_payment_gateway
    secrets:
      - source: staging_token
        target: payment_token
    networks:
      - payment
    deploy:
      update_config:
        failure_action: rollback
      placement:
        constraints:
          - 'node.role == worker'
          - 'node.labels.pcidss == yes'

networks:
  front-tier:
  back-tier:
  payment:
    driver: overlay
    driver_opts:
      encrypted: 'yes'

secrets:
  postgres_password:
    external: true
  staging_token:
    external: true
  revprox_key:
    external: true
  revprox_cert:
    external: true
```

4. 常用命令

```bash
# 部署stack
docker stack deploy -c stackFile路径 service名 --with-registry-auth  # -c 路径，--with-registry-auth 向swarm代理发送Registry认证详细信息
# 查询stack列表
docker stack ls
# 查询stack服务列表
docker stack services <stack_name>名称
# 查询某个服务中的容器运行状态
docker service ps <service_name>名称
# stack删除
docker stack rm <stack_name>名称
# 重启某个服务
docker service update --force <service_name>名称
# 移除stack(下面所有的service会被移除)
docker stack down xxx
```

## 9. compose 和 stack 区别

|          | docker stack                                                                                                                | docker-compose                                                                                                                   |
| -------- | --------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 概念     |                                                                                                                             | 负责实现对 Docker 容器集群的快速编排                                                                                             |
| 区别     | 通过 deploy，构建服务，不支持 build，无法使用 stack 命令构建 build 新镜像，它是需要镜像是预先已经构建好的。                 | 通过 build，构建服务;更适合于开发场景，不支持 deploy，所以在 yml 中使用 deploy 就会报错,可以是镜像，也可以和 Dockerfile 配合使用 |
| 命令     | docker stack deploy -c yml 文件 服务名                                                                                      | docker-compose up，在 docker-compose.yml 所在路径下执行该命令就会自动构建镜像并使用镜像启动容器                                  |
| 安装     | Swarm 模式已经在 1.12 中集成到 Docker Engine 中，docker stack 是 swarm mode 的一部分, 即使是单机使用, 也需要一个 swarm 节点 | 需要额外的安装                                                                                                                   |
| 开发语言 | go 语言                                                                                                                     | python 语言                                                                                                                      |
| 支持版本 | 只能支持 version3 以上版本                                                                                                  | 都可以                                                                                                                           |

## 10. docker 私有仓库-registry

```shell
# 1.拉取镜像
docker pull registry
# 2.启动镜像，暴露端口5000、挂载目录:默认会将上传的镜像保存在容器的/var/lib/registry
docker run -it --name registry-5000 -p 5000:5000 -v /usr/local/registry_20210312/:/var/lib/registry registry:latest
# 3.验证
浏览器中输入：http://ip:5000/v2  # 正常返回 {}
# 4.修改镜像名称，因为仓库要求registry_url:port/ImageName:tag
docker tag 原镜像名称:tag 修改后镜像名称:tag # 192.168.179.128:5000/jdk_8u191:20190307
# 5.push到私有仓库
docker push 修改后镜像名称:tag
# 6.验证push是否成功
http://ip_add:5000/v2/_catalog

# 7.使用hyper/docker-registry-web，展示ui
docker pull hyper/docker-registry-web
docker run -d -p 5001:8080 --name regisry-web-5001 --link registry-5000 -e registry_url=http://registry-5000:5000/v2 -e registry_name=localhost:5000 hyper/docker-registry-web:latest
```

## 11. IDEA 集成 Docker 的远程访问

1. 修改 docker 配置文件并重启：
   - 配置文件：`/lib/systemd/system/docker.service`
   - 重启命令：`systemctl restart docker`
   - 命令：`ExecStart=/usr/bin/dockerd -H tcp://0.0.0.0:2375 -H unix:///var/run/docker.sock`

![image-20210311172031335](../../images/Linux/docker-idea2.png)

2. 防火墙开启 2375 端口

3. 远程测试自验：http://docker 宿主机 ip:2375/version
4. idea 配置 docker

![image-20210311172906434](../../images/Linux/docker-idea.png)

## 12. gitlab 集成 cicd

1. 仓库根目录 创建一个.gitlab-ci.yml 文件
2. 安装 gitlab-runner
