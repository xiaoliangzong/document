# OpenResty

OpenResty是一个基于 Nginx 与 Lua 的高性能 Web 平台，其内部集成了大量精良的 Lua 库、第三方模块以及大多数的依赖项。用于方便地搭建能够处理超高并发、扩展性极高的动态 Web 应用、Web 服务和动态网关。

简单地说 OpenResty 的目标是让你的Web服务直接跑在 Nginx 服务内部，充分利用 Nginx 的非阻塞 I/O 模型，不仅仅对 HTTP 客户端请求,甚至于对远程后端诸如 MySQL、PostgreSQL、Memcached 以及 Redis 等都进行一致的高性能响应。


## 入门

修改配置 conf/nginx.conf 文件，添加以下代码

```conf
location /hello {
    default_type text/html;
    content_by_lua 'ngx.say("<p>hello, world</p>")';
}
```

访问 http://localhost/hello，通过ngx.say 我们可以往客户端输出响应文本，是不是跟咱们tomcat response.write很像嘻嘻，后期我们会使用它输出json。

还有一个输出的函数是ngx.print，同样也是输出响应内容。


## 动态输出