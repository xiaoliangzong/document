# Windows

## 1. 安装包区别

MSI 和 EXE 都是 Windows 上常见的安装包格式，它们有一些区别和特点。

MSI（Microsoft Installer）：

MSI 是一种 Microsoft Windows Installer 技术创建的软件安装包格式。
MSI 文件是一种数据库文件，其中包含了安装程序的所有相关信息，包括文件、注册表项、服务等。这些信息可以通过 Windows Installer 来进行管理和安装。
MSI 可以支持自定义安装选项和卸载选项，允许管理员对软件进行集中管理。

EXE（Executable）：

EXE 是 Windows 上可执行程序的一般扩展名，也用于安装包。
EXE 安装包实际上是一个自解压的压缩文件，其中包含了安装所需的文件和脚本。执行该文件会启动安装过程并解压文件到指定位置，并执行必要的设置步骤。

MSI 格式的安装包更适合企业环境和系统管理员进行软件部署和管理，而 EXE 格式的安装包则更加灵活，可以包含自解压的压缩文件和自定义的安装逻辑。

## 2. 常用命令

### 2.1 netstat

netstat 显示协议统计信息和当前 TCP/IP 网络连接，是一个监控 TCP/IP 网络的非常有用的工具。

常用选项：

- -a 显示所有连接和侦听端口
- -n 以数字形式显示地址和端口号
- -o 显示拥有的与每个连接关联的进程 ID

```sh
# 查看端口，-a显示所有连接和侦听端口，-n以数字形式显示地址和端口号，-o显示拥有的与每个连接关联的进程ID
netstat -ano | findstr port
```

### 2.2 sc

SC 是用来与服务控制管理器和服务进行通信。

用法

```sh
sc <server> [command] [service name] <option1> <option2>...

# 根据服务名查询
sc query
sc query | findstr mysql
# 根据服务名删除
sc delete [service name]
sc delete mysql
# 根据服务名启动服务
sc start mysql
# 根据服务名停止服务
sc stop mysql
```

### 2.3 net

net 是功能强大的以命令行方式执行的工具。它包含了管理网络环境、服务、用户、登陆等 Windows 98/NT/2000 中大部分重要的管理功能。使用它可以轻松的管理本地或者远程计算机的网络环境，以及各种服务程序的运行和配置。或者进行用户管理和登陆管理等

net 与 sc 区别：

- net 命令不只用于服务，还可用于网络、用户、登录等大部分；
- net 命令对禁用的服务无效，sc 命令可以启动禁用状态的服务；
- net 命令会等待执行结果，sc 命令只管下发。

```sh
# 停止
net stop [服务名]
# 启动
net start [服务名]
```

### 2.4 杂记

```sh
echo %java_home%            # 输出环境变量
echo %path%                 # 输出path配置的环境变量

cls                         # 清空屏幕

tasklist                    # 用来显示运行在本地或远程计算机上的所有进程的命令行工具，带有多个执行参数。

taskkill /f /im explorer.exe    # 关闭文件资源管理器
start explorer.exe              # 重启文件资源管理器
```

## 3. 常见问题

### 3.1 解决端口占用

```sh
# 查看端口，-a显示所有连接和侦听端口，-n以数字形式显示地址和端口号，-o显示拥有的与每个连接关联的进程ID
netstat -ano | findstr port
# 查询PID对应的进程
tasklist | findstr pid
# 杀死进程
taskkill /f /pid [pid]
```
