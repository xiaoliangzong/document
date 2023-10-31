## 1. 网络启动/停止

```bat
net stop 服务名

net start 服务名
```

## 2. 解决端口占用

```sh
# 查看端口，-a显示所有连接和侦听端口，-n以数字形式显示地址和端口号，-o显示拥有的与每个连接关联的进程ID
netstat -ano | findstr port
# 查询PID对应的进程
tasklist | findstr pid
# 杀死进程
taskkill /f /pid 值
```

## 3. bat 脚本



## 4. 命令

netstat 显示协议统计信息和当前 TCP/IP 网络连接，是一个监控TCP/IP网络的非常有用的工具

-a显示所有连接和侦听端口
-n以数字形式显示地址和端口号
-o显示拥有的与每个连接关联的进程ID


