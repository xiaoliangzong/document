# Nginx



## 概念

[Nginx](http://nginx.org/) 是一个高性能的 HTTP （web服务器）和反向代理服务器，其特点是占用内存小，能够同时处理大量的并发连接。

## 使用场景

Web服务器、反向代理服务器、负载均衡器、防火墙、缓存服务器、HTTP/HTTPS代理服务器
Nginx可以作为Web服务器来处理静态资源文件，如HTML、CSS、JavaScript、图片等，提供高效的HTTP服务。
Nginx可以作为反向代理服务器，接收客户端请求并将其转发给后端的多台应用服务器，实现负载均衡、故障转移、动态增删应用服务器等功能。
Nginx可以根据不同的负载均衡策略，将来自客户端的请求分发到多台应用服务器上，实现请求的平均分配。
Nginx可以通过限制客户端访问速率、拒绝恶意请求等方式，提供基本的安全防护，减轻被攻击的风险。
Nginx可以将请求结果缓存在内存中或硬盘上，提高Web应用程序的性能。
Nginx可以作为HTTP/HTTPS代理服务器，对客户端和后端服务进行转发和代理，提供数据传输的加密和身份认证。


## 反向代理

正向代理：客户端必须设置正向代理服务器的 ip 和端口

是指以代理服务器来接受 Internet 上的连接请求，然后将请求转发给内部的网络上的服务器，并将服务器上得到的结果返回给 internet 上请求连接的客户端，此时代理服务器对外就表现为一个服务器。

## 动静分离

为了加快网站的解析速度，可以把动态页面和静态页面由不同的服务器来解析，加快解析速度。降低原来单个服务器的压力。

## Linux 安装

1. 安装 PCRE 包：PCRE 作用是让 Nginx 支持 Rewrite 功能

2. 安装 openssl、zlib：安装编译工具和库文件

   yum install -y make zlib zlib-devel gcc-c++ libtool openssl openssl-devel pcre pcre-devel 

3. 解压 tar -zxvf nginx-1.18.0.tar.gz

4. ./configure

5. make && make install （安装完成后的路径为：/usr/local/nginx）

## Linux 防火墙

```shell
# 查看开放的端口号
firewall-cmd --list-all
# 设置开放的端口号
firewall-cmd --add-service=http –permanent
firewall-cmd --add-port=80/tcp --permanent
# 重启防火墙
firewall-cmd –reload
```

## nginx 命令

```shell
cd /usr/local/nginx/sbin    # 安装路径
./nginx     nginx -v   # 查看版本
./nginx      start nginx   # 启动
./nginx -s reload    nginx -s reload  # 重载
./nginx -s stop      nginx -x stop  # 停止
./nginx -t     nginx -t    # 查看配置文件是否正确
upstream        # 配置负载均衡
```


## root和alias区别

在 Nginx 配置中，alias 和 root 都用于指定 web 服务器的根目录。区别在于如何处理 URI

1. root 指令定义了文件在文件系统中的基本路径，并将与请求 URI 的匹配部分组合起来构成实际的文件路径。例如，如果请求的 URI 是 /images/logo.png，并且 root 指令设置为 /var/www/html，则 Nginx 会在文件系统上寻找 /var/www/html/images/logo.png。如果请求的 URI 包含斜杠结尾，则 Nginx 会将其视为目录，而不是文件，例如，/images/ 将在 /var/www/html/images/ 目录下查找。

2. alias 指令也定义了文件在文件系统中的基本路径，但与 root 不同，它将 URI 中的匹配部分替换为指定路径。例如，如果请求的 URI 是 /images/logo.png，并且 alias 指令设置为 /var/www/data，则 Nginx 会在文件系统上寻找 /var/www/data/logo.png。

使用 root 指令可以将请求 URI 映射到文件系统上的路径，而使用 alias 指令可以将请求 URI 映射到不同的文件系统路径，从而提供更大的灵活性。


root读取的是根目录。可以在server或location指令中使用。
alias只能在location指令中使用。

两者何时用？
如果位置与别名路径的末尾匹配，最好使用root。
如果从与 root 指定的目录不同的位置读取数据时，最好使用alias。


## 配置文件

```shell
# 全局块，配置影响 nginx 服务器整体运行的配置指令
# 1. 配置运行 Nginx 服务器的用户（组）
# 2. 允许的 worker process 数
# 3. 日志存放路径和类型
# 4. 进程pid存放路径
# 5. 一个Nginx进程打开的最多文件描述符数目

# event块，配置影响Nginx服务器或与用户的网络连接
# 1. 最大连接数的配置
# 2. 事件驱动模型的选择
events {}

# http块，配置代理、缓存、日志定义等绝大多数功能和第三方模块的配置
http {
    # server块，配置虚拟主机的相关参数
    server {
        listen       80; #配置监听端口
        server_name  localhost; #配置服务名
        charset utf-8; #配置字符集
        access_log  logs/host.access.log  main; #配置本虚拟主机的访问日志
        
        location / {
            root html; #root是配置服务器的默认网站根目录位置，默认为Nginx安装主目录下的html目录
            index index.html index.htm; #配置首页文件的名称
        }
        
        error_page 404             /404.html; #配置404错误页面
        error_page 500 502 503 504 /50x.html; #配置50x错误页面

        listen       443 ssl;
        server_name  localhost;

        ssl_certificate      cert.pem;
        ssl_certificate_key  cert.key;

        ssl_session_cache    shared:SSL:1m;
        ssl_session_timeout  5m;

        ssl_ciphers  HIGH:!aNULL:!MD5;
        ssl_prefer_server_ciphers  on;


        # location块
        location / {
            
            root html; #root是配置服务器的默认网站根目录位置，默认为Nginx安装主目录下的html目录
            index index.html index.htm; #配置首页文件的名称

            proxy_pass http://127.0.0.1:88; #反向代理的地址
            proxy_redirect off; #是否开启重定向
            #后端的Web服务器可以通过X-Forwarded-For获取用户真实IP
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header Host $host;
            #以下是一些反向代理的配置，可选。
            client_max_body_size 10m; #允许客户端请求的最大单文件字节数
            client_body_buffer_size 128k; #缓冲区代理缓冲用户端请求的最大字节数，
            proxy_connect_timeout 90; #nginx跟后端服务器连接超时时间（代理连接超时）
            proxy_send_timeout 90; #后端服务器数据回传时间（代理发送超时）
            proxy_read_timeout 90; #连接成功后，后端服务器响应时间（代理接收超时）
            proxy_buffer_size 4k; #设置代理服务器（Nginx）保存用户头信息的缓冲区大小
            proxy_buffers 4 32k; #proxy_buffers缓冲区，网页平均在32k以下的设置
            proxy_busy_buffers_size 64k; #高负荷下缓冲大小（proxy_buffers*2）
            proxy_temp_file_write_size 64k;  #设定缓存文件夹大小

        }
    }
}
```
location的URI，用于匹配URL

通配符：

=：用于不含正则表达式的uri前，要求请求字符串与uri严格匹配，如果匹配成功，就停止继续向下搜索并立即处理该请求。

~：用于表示uri包含正则表达式，并且区分大小写。

~*：用于表示uri包含正则表达式，并且不区分大小写。

^~：用于不含正则表达式的uri前，要求Nginx服务器找到标识uri和请求字符串匹配度最高的location后，立即使用此location处理请求，而不再使用location块中的正则uri和请求字符串做匹配。



```shell
user  nobody;       # 配置worker进程运行用户（和用户组），nobody也是一个Linux用户，一般用于启动程序，没有密码
worker_processes  1;       # 服务器并发处理服务的关键配置，不考虑硬件软件设备的制约，值越大，并发处理量越多；根据硬件调整，通常等于CPU数量或者2倍的CPU数量

error_log  logs/error.log;      # 配置全局错误日志及类型，[debug | info | notice | warn | error | crit]，默认是error
#error_log  logs/error.log  notice;
#error_log  logs/error.log  info;

pid        logs/nginx.pid;      # 配置进程pid文件
worker_rlimit_nofile 1024;      # 一个进程打开的最多文件描述符数目，理论值应该是最多打开文件数（系统的值ulimit -n）与Nginx进程数相除，但是Nginx分配请求并不均匀，所以建议与ulimit -n的值保持一致。

events {
    use epoll;                  # 参考事件模型，use [ kqueue | rtsig | epoll | /dev/poll | select | poll ]; epoll模型是Linux 2.6以上版本内核中的高性能网络I/O模型，如果跑在FreeBSD上面，就用kqueue模型
    worker_connections  1024;   # 每个worker_process可以同时支持的最大连接数
}

http {
    include       mime.types;                       # 文件扩展名与文件类型映射表
    default_type  application/octet-stream;         # 默认文件类型
    charset utf-8;                                  # 默认编码

    #log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
    #                  '$status $body_bytes_sent "$http_referer" '
    #                  '"$http_user_agent" "$http_x_forwarded_for"';

    #access_log  logs/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    #keepalive_timeout  0;
    keepalive_timeout  65;

    #压缩设置
    #gzip  on;
    #开启gzip压缩
    gzip on;
    #http的协议版本
    gzip_http_version 1.0;
    #IE版本1-6不支持gzip压缩，关闭
    gzip_disable 'MSIE[1-6].';
    #需要压缩的文件格式 text/html默认会压缩，不用添加
    gzip_types text/css text/javascript application/javascript image/jpeg image/png image/gif;
    #设置压缩缓冲区大小，此处设置为4个8K内存作为压缩结果流缓存
    gzip_buffers 4 8k;
    #压缩文件最小大小
    gzip_min_length 1k;
    #压缩级别1-9
    gzip_comp_level 4;
    #给响应头加个vary，告知客户端能否缓存
    gzip_vary on;
    #反向代理时使用
    gzip_proxied off;

    client_max_body_size 20M; #上传文件大小限制
    fastcgi_connect_timeout 800;#原设置为300s
    fastcgi_send_timeout 800;#原设置为300s
    fastcgi_read_timeout 800;#原设置为300s


    charset utf-8; #默认编码
    server_names_hash_bucket_size 128; #服务器名字的hash表大小
    client_header_buffer_size 32k; #上传文件大小限制
    large_client_header_buffers 4 64k; #设定请求缓冲
    client_max_body_size 8m; #设定请求缓冲
    sendfile on; #开启高效文件传输模式，对于普通应用设为on，如果用来进行下载等应用磁盘IO重负载应用，可设置为off，以平衡磁盘与网络I/O处理速度，降低系统的负载。注意：如果图片显示不正常把这个改成off。
    autoindex on; #开启目录列表访问，合适下载服务器，默认关闭。
    tcp_nopush on; #防止网络阻塞
    tcp_nodelay on; #防止网络阻塞
    keepalive_timeout 120; #长连接超时时间，单位是秒

    #FastCGI相关参数是为了改善网站的性能：减少资源占用，提高访问速度。
    fastcgi_connect_timeout 300;
    fastcgi_send_timeout 300;
    fastcgi_read_timeout 300;
    fastcgi_buffer_size 64k;
    fastcgi_buffers 4 64k;
    fastcgi_busy_buffers_size 128k;
    fastcgi_temp_file_write_size 128k;

    #gzip模块设置
    gzip on; #开启gzip压缩输出
    gzip_min_length 1k; #最小压缩文件大小
    gzip_buffers 4 16k; #压缩缓冲区
    gzip_http_version 1.0; #压缩版本（默认1.1，前端如果是squid2.5请使用1.0）
    gzip_comp_level 2; #压缩等级
    gzip_types text/plain application/x-javascript text/css application/xml; #压缩类型
    gzip_vary on; #增加响应头'Vary: Accept-Encoding'
    limit_zone crawler $binary_remote_addr 10m; #开启限制IP连接数的时候需要使用

 # 配置负载均衡
 upstream myserver{
  server 127.0.0.1:8080;
  server 127.0.0.1:8081;
 }
 # 使用upstream实现负载均衡
 # nginx分配服务器策略：
 # 轮询（默认）：每次请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器down掉，能自动剔除，如果在恢复，也会添加进来
 # weight权重，默认为1，权重越高，被分配的客户端越多，权重不能设置为0
 # ip_hash：每个请求按访问ip的hash结果分配，这样每个访客固定访问一个后端服务器
 # fair（第三方）：按照后端服务器的响应时间来分配请求，响应时间短的优先分配
 #upstream myfirst {
 # server localhost:8080 weight=10;
 # server localhost:8099 weight=1;
 #}


 # 和虚拟主机密切相关，每个server相当于一个虚拟主机；而每个 server 块也分为全局 server 块，以及可以同时包含多个 locaton 块。
    server {
        listen       31943; # nginx监听端口，默认为80
        server_name  localhost;  # 监听的ip地址

        #charset koi8-r;

        #access_log  logs/host.access.log  main;
  # 配置反向代理1, 反向代理tomcat
  location / {
   root   html;
   index  index.html index.htm;
   try_files $uri $uri/ /index.html;   #检测文件存在性重定向到首页目录    防止404
   proxy_pass http://127.0.0.1:8080
  }
  # 配置反向代理2-调转到不同的url
  location ~ /dangbo/ {
   proxy_pass http://127.0.0.1:8082
        }

  location / {
   proxy_pass http://myserver;
   proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_connect_timeout 600;
            proxy_read_timeout 600;
            proxy_send_timeout 600;
  }

  # 实现动静分离，访问静态资源
  location /code/ {
   root D:/;
   autoindex on;
   autoindex_exact_size off;            //关闭详细文件大小统计，让文件大小显示MB，GB单位，默认为b；
  }


  location / {
   root   html;
      index  index.html index.htm;
   try_files $uri $uri/ /index.html;
  }
  location /admin {
   alias  html/;
      index  admin.html admin.htm;
   try_files $uri $uri/ /admin.html;
  }

        #error_page  404              /404.html;

        # redirect server error pages to the static page /50x.html
        #
        error_page   500 502 503 504  /50x.html;
        location = /50x.html {
            root   html;
        }
    }
}


http{
    server {
        listen 8080;
        server_name localhost;
        location /user {
            proxy_pass http://localhost:8001;
        }
    }
}

# 分析：
proxy_pass ip + port 后边有斜杆\ 或路径，新的路径是：proxy_pass + 访问路径除去lacation相同部分路径
proxy_pass ip + port 后边啥都没有，新的路径：proxy_pass + location + 访问路径除去location相同路径
```

[Nginx 反向代理和缓存服务器功能说明和简单实现](https://www.cnblogs.com/kevingrace/p/5839698.html)

## 负载均衡策略

1. 轮询（默认） 每个请求按时间顺序逐一分配到不同的后端服务器，如果后端服务器 down 掉，能自动剔除。

2. weight weight 代表权重默认为 1,权重越高被分配的客户端越多

3. ip_hash 每个请求按访问 ip 的 hash 结果分配，这样每个访客固定访问一个后端服务器

4. fair（第三方） 按后端服务器的响应时间来分配请求，响应时间短的优先分配。

## 日志

设置nginx日志格式
默认变量格式：log_format combined '$remote_addr - $remote_user [$time_local] "$request" $status $body_bytes_sent "$http_referer" "$http_user_agent"';

$remote_addr变量：记录了客户端的IP地址（普通情况下）。

$remote_user变量：当nginx开启了用户认证功能后，此变量记录了客户端使用了哪个用户进行了认证。

$time_local变量：记录了当前日志条目的时间。

$request变量：记录了当前http请求的方法、url和http协议版本。

$status变量：记录了当前http请求的响应状态，即响应的状态码，比如200、404等响应码，都记录在此变量中。

$body_bytes_sent变量：记录了nginx响应客户端请求时，发送到客户端的字节数，不包含响应头的大小。

$http_referer变量：记录了当前请求是从哪个页面过来的，比如你点了A页面中的超链接才产生了这个请求，那么此变量中就记录了A页面的url。

$http_user_agent变量：记录了客户端的软件信息，比如，浏览器的名称和版本号。

增加变量：

'"$http_host" "$request_time" "$upstream_response_time" "$upstream_connect_time" "$upstream_header_time"';

$http_host 请求地址，即浏览器中你输入的地址（IP或域名）

$request_time：处理请求的总时间,包含了用户数据接收时间

$upstream_response_time：建立连接和从上游服务器接收响应主体的最后一个字节之间的时间

$upstream_connect_time：花费在与上游服务器建立连接上的时间

$upstream_header_time：建立连接和从上游服务器接收响应头的第一个字节之间的时间

修改后的自定义格式：

 log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '

        '$status $body_bytes_sent "$http_referer" '

        '"$http_user_agent" "$http_x_forwarded_for" '

        '"$http_host" "$request_time" "$upstream_response_time" "$upstream_connect_time" "$upstream_header_time"';



## 动静分离

针对前后端分离的项目：将静态文件独立成单独的域名，放在独立的服务器上。

​ 可以使用 autoindex on 显示目录下的所有文件。

```shell
# 实现动静分离，访问静态资源，root为绝对路径。
location /code/ {
    root D:/;
    autoindex on;
}
```

## 配置高可用集群

> Keepalived+Nginx 高可用集群（主从模式）
>
> 需要使用 keepalived 实现高可用、用来配置虚拟 ip，设置心跳检测解决静态路由的单点故障问题

## nginx 工作原理

1. master
2. worker：多个，如果一个出现问题，其他 worker 独立的，都是进行争抢，实现请求过程，能够保证服务不中断
3. 可以实现热部署，nginx -s reload。
4. 连接数 worker_connection：一次请求占用 2 个或者 4 个连接数。

## Nginx 集成 swagger

```shell
location ~* ^(/v2|/webjars|/swagger-resources|/swagger-ui.html){
       proxy_set_header Host $host;
       proxy_set_header  X-Real-IP  $remote_addr;
       proxy_set_header X-Forwarded-For $remote_addr;
       #proxy_set_header Host $host:$server_port;
       proxy_set_header X-Forwarded-Proto $scheme;
       proxy_set_header X-Forwarded-Port $server_port;
       proxy_pass http://10.18.66.66:8600; # 后端服务地址
}
```

## 问题汇总

> 1. 配置多个 location，报错：重复配置 location，路径指定相同，
>
> 解决办法：只保留一个 location 或者修改其中一个 location 指定的路径
>
> ![image-20210107183913785](public/images/nginx01.png)
>
> 2. 无效的 PID：nginx 未启动
>
> ![image-20210107184135848](public/images/nginx02.png)
>
> 3. location 中每个 url 之后需要添加英文分号；不管位置在哪，和 json 不太一样，json 最后一个不需要分号
> 4. 使用正则表达式之后，proxy_pass 中 url 不能追加
> 5. nginx: [emerg] CreateDirectory() "D:\nginx-1.18.0\nginx-1.18.0/temp/client_body_temp" failed (3: The system cannot find the path specified)
>
> nginx 问题，需要重新安装或解压
>
> 6. nginx: [emerg] "proxy_pass" cannot have URI part in location given by regular expression, or inside named location, or inside "if" statement, or inside "limit_except" block in D:\nginx-1.18.0\nginx-1.18.0/conf/nginx.conf:95
>
> nginx: [emerg] "proxy_pass"不能有 URI 部分在正则表达式给出的位置中，或在 named location 中，或在"if"语句中，或在"limit_except"块中
>
> 7. js 文件 net::ERR_ABORTED 503
>
> location / {
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_pass http://1.1.1.1:81/;
        limit_req  zone=one burst=10 nodelay;   
    }
>
> limit_req 参数在 Nginx 中是请求次数限制，上面配置的是一个周期最多10次请求，但是这个页面上请求的 js 文件远远超过10个，所以出现了服务不可用错误
>
> 8. 504超时，默认1分钟，需要将proxy_read_timeout 改大点
>
> proxy_connect_timeout 60000;
> proxy_read_timeout 60000;
> proxy_send_timeout 60000;
>
> 9. 413 Request Entity Too Large
>
> nginx 配置文件中的client_max_body_size是控制请求body的大小限制的参数，默认为1MB，如果超过这个数值，则会直接返回413状态码

http {
    ...
    client_max_body_size 20M;
 }  

## 实例 1：代理前端静态页面

```shell
# 将前端服务打包后，拷贝到html目录下：如果包含项目目录，root配置需要改为xxx/html
#try_files 按照指定的顺序查找文件，并使用第一个找到的文件进行请求处理，last表示匹配不到就内部直接匹配最后一个。
location / {
 root xxx/html
 try_files $uri $uri/  /index.html last
 index index.thml index.htm
}
```

## keepalived

### 1. 是什么

起初是专为 LVS 负载均衡软件设计的，用来管理并监控 LVS 集群系统中各个服务节点状态，后来又加入了可以实现高可用的 VRRP 功能，因此，keepalived 除了能够管理 LVS 软件外，还可以作为其他服务的高可用解决方案软件，比如 nginx、Haproxy、Mysql

### 2. 原理

vrrp：虚拟路由器冗余协议，通过该协议实现高可用功能，vrrp 的目的是为了解决静态路由单点故障问题的，能够保证当个别节点宕机时，整个网路可以不间断的运行。

在 Keepalived 服务正常工作时，主 Master 节点会不断地向备节点发送（多播的方式）心跳消息，用以告诉备 Backup 节点自己还活看，当主 Master 节点发生故障时，就无法发送心跳消息，备节点也就因此无法继续检测到来自主 Master 节点的心跳了，于是调用自身的接管程序，接管主 Master 节点的 IP 资源及服务。而当主 Master 节点恢复时，备 Backup 节点又会释放主节点故障时自身接管的 IP 资源及服务，恢复到原来的备用角色。

Keepalived 高可用对之间是通过 VRRP 进行通信的， VRRP 是遑过竞选机制来确定主备的，主的优先级高于备，因此，工作时主会优先获得所有的资源，备节点处于等待状态，当主挂了的时候，备节点就会接管主节点的资源，然后顶替主节点对外提供服务。

在 Keepalived 服务对之间，只有作为主的服务器会一直发送 VRRP 广播包,告诉备它还活着，此时备不会枪占主，当主不可用时，即备监听不到主发送的广播包时，就会启动相关服务接管资源，保证业务的连续性.接管速度最快可以小于 1 秒。

### 3. 作用

- 管理 LVS 负载均衡软件
- 实现 LVS 集群节点的健康检查中
- 作为系统网络服务的高可用性（failover）

### 4. 修改 Keepalived 配置文件

> 安装：yum install -y keepalived

(1) MASTER 节点配置文件（192.168.50.133）

```yaml
# vi /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
 ## keepalived 自带的邮件提醒需要开启 sendmail 服务。 建议用独立的监控或第三方 SMTP
 router_id liuyazhuang133 ## 标识本节点的字条串，通常为 hostname
}
## keepalived 会定时执行脚本并对脚本执行的结果进行分析，动态调整 vrrp_instance 的优先级。如果脚本执行结果为 0，并且 weight 配置的值大于 0，则优先级相应的增加。如果脚本执行结果非 0，并且 weight配置的值小于 0，则优先级相应的减少。其他情况，维持原本配置的优先级，即配置文件中 priority 对应的值。
vrrp_script chk_nginx {
 script "/etc/keepalived/nginx_check.sh" ## 检测 nginx 状态的脚本路径
 interval 2 ## 检测时间间隔
 weight -20 ## 如果条件成立，权重-20
}
## 定义虚拟路由， VI_1 为虚拟路由的标示符，自己定义名称
vrrp_instance VI_1 {
 state MASTER ## 主节点为 MASTER， 对应的备份节点为 BACKUP
 interface eth0 ## 绑定虚拟 IP 的网络接口，与本机 IP 地址所在的网络接口相同， 我的是 eth0
 virtual_router_id 33 ## 虚拟路由的 ID 号， 两个节点设置必须一样， 可选 IP 最后一段使用, 相同的 VRID 为一个组，他将决定多播的 MAC 地址
 mcast_src_ip 192.168.50.133 ## 本机 IP 地址
 priority 100 ## 节点优先级， 值范围 0-254， MASTER 要比 BACKUP 高
 nopreempt ## 优先级高的设置 nopreempt 解决异常恢复后再次抢占的问题
 advert_int 1 ## 组播信息发送间隔，两个节点设置必须一样， 默认 1s
 ## 设置验证信息，两个节点必须一致
 authentication {
  auth_type PASS
  auth_pass 1111 ## 真实生产，按需求对应该过来
 }
 ## 将 track_script 块加入 instance 配置块
 track_script {
  chk_nginx ## 执行 Nginx 监控的服务
 } #
 # 虚拟 IP 池, 两个节点设置必须一样
 virtual_ipaddress {
  192.168.50.130 ## 虚拟 ip，可以定义多个
 }
}
```

(2) BACKUP 节点配置文件（192.168.50.134）

```properties
# vi /etc/keepalived/keepalived.conf
! Configuration File for keepalived
global_defs {
 router_id liuyazhuang134
}
vrrp_script chk_nginx {
 script "/etc/keepalived/nginx_check.sh"
 interval 2
 weight -20
}
vrrp_instance VI_1 {
 state BACKUP
 interface eth1
 virtual_router_id 33
 mcast_src_ip 192.168.50.134
 priority 90
 advert_int 1
 authentication {
  auth_type PASS
  auth_pass 1111
 }
 track_script {
  chk_nginx
 }
 virtual_ipaddress {
  192.168.50.130
 }
}
```

### 5. 编写 nginx 状态检测脚本

```yaml
# vi /etc/keepalived/nginx_check.sh
#!/bin/bash
A=`ps -C nginx –no-header |wc -l`
if [ $A -eq 0 ];then
/usr/local/nginx/sbin/nginx
sleep 2
if [ `ps -C nginx --no-header |wc -l` -eq 0 ];then
killall keepalived
fi
fi
```

### 6. 启动 Keepalived

```shell
# service keepalived start
Starting keepalived: [ OK ]

[root@lb02 ~]# /etc/init.d/keepalived start
Starting keepalived:                                       [  OK  ]
```

### 7. 脑裂

## root 和 alias 区别

**在 location /中配置 root，在 location /other 中配置 alias。**

**root 会根据完整的 URI 请求来映射，也就是/path/uri**

**alias 会把 location 后面配置的路径丢弃掉，把当前匹配到的目录指向到指定的目录**

## nginx 配置安全证书 ssl

```bash
# 1. 先检查是否安装Nginx SSL模块，如果安装了，跳过2、3步；出现 configure arguments: –with-http_ssl_module, 则已安装
nginx -V
# 2. 安装基础支持包
yum -y install openssl openssl-devel
# 3. 安装ssl模块
cd /home/nginx-1.10.2
../configure --prefix=/usr/local/nginx --with-http_ssl_module
make  # 编译
make install
# 4. 配置服务器
新建cert文件夹，将pem与key文件拷贝进来
server {
   listen 443;#监听443端口（https默认端口）,ssl(Secure Sockets Layer)
   server_name www.xxx.com; #填写绑定证书的域名
   ssl on;
   ssl_certificate xxx.pem;  # pem文件的路径
   ssl_certificate_key xxx.key; # key文件的路径
   ssl_session_timeout 5m;  # 缓存有效期
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # 按照这个协议配置
   ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE; # 安全链接可选的加密协议
   ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;  # 阿里云
   ssl_prefer_server_ciphers on;
   location / {
     root  xxx ; #填写你的你的站点目录
     index index.php index.html index.htm;
   }
}

server {
listen       80;
server_name  www.xxx.com; #填写绑定证书的域名
rewrite ^/(.*) https://$server_name permanent;
}
```
