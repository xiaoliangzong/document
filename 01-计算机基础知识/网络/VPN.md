# VPN

虚拟专用网络（英文：Virtual Private Network），简称虚拟专网（VPN），其主要功能是在公用网络上建立专用网络，进行加密通讯。在企业网络中有广泛应用。VPN 网关通过对数据包的加密和数据包目标地址的转换实现远程访问。VPN 可通过服务器、硬件、软件等多种方式实现。

## 1. 简介

VPN 属于远程访问技术，简单地说就是利用公用网络架设专用网络。

让外地员工访问到内网资源，利用 VPN 的解决方法就是在内网中架设一台 VPN 服务器。外地员工在当地连上互联网后，通过互联网连接 VPN 服务器，然后通过 VPN 服务器进入企业内网。为了保证数据安全，VPN 服务器和客户机之间的通讯数据都进行了加密处理。有了数据加密，就可以认为数据是在一条专用的数据链路上进行安全传输，就如同专门架设了一个专用网络一样，但实际上 VPN 使用的是互联网上的公用链路，因此 VPN 称为虚拟专用网络，其实质上就是利用加密技术在公网上封装出一个数据通讯隧道。有了 VPN 技术，用户无论是在外地出差还是在家中办公，只要能上互联网就能利用 VPN 访问内网资源，这就是 VPN 在企业中应用得如此广泛的原因。

## 2. 按 VPN 的协议分类

VPN 的隧道协议主要有三种，PPTP、L2TP 和 IPSec，其中 PPTP 和 L2TP 协议工作在 OSI 模型的第二层，又称为二层隧道协议；IPSec 是第三层隧道协议。

1. PPTP（Point-to-Point Tunneling Protocol）：PPTP 是一种较早的 VPN 协议，支持多种操作系统。它的配置简单，但安全性相对较低。
2. L2TP（Layer 2 Tunneling Protocol）：L2TP 是一种组合协议，结合了 PPTP 和 Cisco 的 L2F 协议。它提供了更强的安全性，但也可能对网络连接速度产生一些影响。
3. IPsec（Internet Protocol Security）：IPsec 是一种广泛应用的 VPN 协议，提供了较高的安全性和可靠性。它可以用于创建安全的点对点或站点到站点的 VPN 连接。

## 3. 实现方式

VPN 的实现有很多种方法，常用的有以下四种：

| 方法       | 描述                                                                                  |
| ---------- | ------------------------------------------------------------------------------------- |
| VPN 服务器 | 在大型局域网中，通过网络中心搭建 VPN 服务器来实现 VPN。                               |
| 软件 VPN   | 使用专用的软件来实现 VPN。                                                            |
| 硬件 VPN   | 使用专用的硬件来实现 VPN。                                                            |
| 集成 VPN   | 一些硬件设备（如路由器、交换机、防火墙等）含有 VPN 功能，通过集成这些功能来实现 VPN。 |

## 4. 应用场景

1. OpenVPN － OpenVPN是为多种身份验证方法开发的开源项目。它是一种非常通用的协议，可以在具有不同功能的许多不同设备上使用，并可以通过UDP或TCP在任何端口上使用。OpenVPN使用OpenSSL库和TLS协议提供出色的性能和强大的加密。
2. WireGuard － WireGuard是一种较新的VPN协议，与现有VPN协议相比，旨在提供更高的安全性和更好的性能。默认情况下，WireGuard在隐私方面存在一些问题，尽管大多数支持WireGuard的VPN已经克服这些问题。
3. IKEv2 / IPSec －带有Internet密钥交换版本2（IPSec / IKEv2）的Internet协议安全性是一种快速且安全的VPN协议。它已在许多操作系统（例如Windows、Mac OS和iOS）中自动进行预配置。它特别适合与移动设备重新建立连接。IKEv2的一个缺点是它是由Cisco和Microsoft开发的，不是像OpenVPN这样的开源项目。对于需要快速、轻量级VPN（该VPN安全且可以暂时断开连接以快速重新连接）的移动用户而言，IKEv2 / IPSec是一个不错的选择。
4. L2TP / IPSec －具有Internet协议安全性也是不错选择。该协议比PPTP更安全，但是由于数据包是双重封装的，因此它并不总能提供最佳响应速度。它通常与移动设备一起使用，并内置在许多操作系统中。
6. PPTP －点对点隧道协议是一种基本的较旧的VPN协议，内置在许多操作系统中。不过，PPTP具有已知的安全漏洞，出于隐私和安全原因，就不太建议选择。

**常用 L2TP、OpenVPN 协议；选择使用 StrongSwan 作为 L2TP VPN 服务器，以及 OpenVPN 作为 SSL VPN 服务器。（L2TP 的 UDP 1701 端口和 OpenVPN 的 TCP/UDP 1194 端口）**


## 5. VPN 连接客户端

SecoClient 和 Uni VPN Client

华为USG6000配套的SecoClient已停止演进，无法从Support官网下载获取，已下载的SecoClient仍可继续使用。现在采用联软科技公司与华为合作共同开发新一代客户端：Uni VPN Client以供用户使用。