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