## 1. 网络启动/停止

```bat
net stop 服务名

net start 服务名
```

## 2. 解决端口占用

```sh
# 查看端口
netstat -ano | findstr port
# 查询PID对应的进程
tasklist | findstr pid
# 杀死进程
taskkill /f /pid 值
```

## 3. bat 脚本
