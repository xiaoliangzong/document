## 概念

WebSocket 是一种通信协议，可在单个 TCP 连接上进行全双工通信。WebSocket 使得客户端和服务器之间的数据交换变得更加简单，允许服务端主动向客户端推送数据。在 WebSocket API 中，浏览器和服务器只需要完成一次握手，两者之间就可以建立持久性的连接，并进行双向数据传输。

## 特点

- 握手阶段采用 HTTP 协议。
- 数据格式轻量，性能开销小。客户端与服务端进行数据交换时，服务端到客户端的数据包头只有 2 到 10 字节，客户端到服务端需要加上另外 4 字节的掩码。HTTP 每次都需要携带完整头部。
- 更好的二进制支持，可以发送文本，和二进制数据
- 没有同源限制，客户端可以与任意服务器通信
- 协议标识符是 ws（如果加密，则是 wss），请求的地址就是后端支持 websocket 的 API。

## 其他实时通信方式

**传统轮询**

1. 通过客户端循坏发起请求，实现实时获取数据的方式，使用 setInterval 或 setTimeout 实现

**Long Polling 长轮询**

1. 在每次客户端发出请求后，服务器检查上次返回的数据与此次请求时的数据之间是否有更新，如果有更新则返回新数据并结束此次连接，否则服务器 hold 住此次连接，直到有新数据时再返回相应。而这种长时间的保持连接可以通过设置一个较大的 HTTP timeout 实现。

## WebSocket

> 客户端发起 HTTP 握手，告诉服务端进行 WebSocket 协议通讯，并告知 WebSocket 协议版本。服务端确认协议版本，升级为 WebSocket 协议。之后如果有数据需要推送，会主动推送给客户端。
>
> 连接开始时，客户端使用 HTTP 协议和服务端升级协议，升级完成后，后续数据交换遵循 WebSocket 协议

**握手**

1. 客户端发起协议升级请求；请求方式为标准的 HTTP 报文格式，且只支持 GET 方式

```java
// 客户端：申请协议升级
GET /chat HTTP/1.1  // 首行遵照 Request-Line 格式
Host: server.example.com
Upgrade: websocket  // 表示要升级到 websocket 协议
Connection: Upgrade // 表示要升级协议
Sec-WebSocket-Key: dGhlIHNhbXBsZSBub25jZQ== // 与后面服务端响应首部的 Sec-WebSocket-Accept 是配套的，提供基本的防护，比如恶意的连接或无意的连接
Origin: http://example.com
Sec-WebSocket-Protocol: chat, superchat
Sec-WebSocket-Version: 13   // 表示 websocket 的版本。如果服务端不支持该版本，需要返回一个 Sec-WebSocket-Versionheader，里面包含服务端支持的版本号

// 服务端：响应协议升级
HTTP/1.1 101 Switching Protocols    // 首行遵照 Status-Line 格式
Upgrade: websocket
Connection: Upgrade
// 根据客户端请求首部的 Sec-WebSocket-Key 计算，将 Sec-WebSocket-Key 跟 258EAFA5-E914-47DA-95CA-C5AB0DC85B11 拼接。通过 SHA1 计算出摘要，并转成 base64 字符串
Sec-WebSocket-Accept: s3pPLMBiTxaQ9kYGzzhZRbK+xOo=
Sec-WebSocket-Protocol: chat
```

**数据帧**

WebSocket 客户端、服务端通信的最小单位是 帧（frame），由 1 个或多个帧组成一条完整的 消息（message）。

    - 发送端：将消息切割成多个帧，并发送给服务端；
    - 接收端：接收消息帧，并将关联的帧重新组装成完整的消息；

**服务端实现**

> Socket.IO
> µWebSockets
> WebSocket-Node

1. 添加依赖

```pom
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-websocket</artifactId>
    <version>1.3.5.RELEASE</version>
</dependency>
```

2. 编写配置类

```java
// 注入 ServerEndpointExporter，这个 bean 会自动注册使用了@ServerEndpoint 注解声明的 Websocket endpoint。要注意，如果使用独立的 servlet 容器，而不是直接使用 springboot 的内置容器，就 不要注入 ServerEndpointExporter，因为它将由容器自己提供和管理。
@Configuration
public class WebSocketConfig {
    @Bean
    public ServerEndpointExporter serverEndpointExporter() {
        return new ServerEndpointExporter();
    }

}
```
