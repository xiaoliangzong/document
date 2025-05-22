
# Spring Boot WebSocket通信

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

3.websocket 实现

```java
@ServerEndpoint(value = "/websocket")
@Component
public class MyWebSocket {
    //静态变量，用来记录当前在线连接数。应该把它设计成线程安全的。
    private static int onlineCount = 0;

    //concurrent包的线程安全Set，用来存放每个客户端对应的MyWebSocket对象。
    private static CopyOnWriteArraySet<MyWebSocket> webSocketSet = new CopyOnWriteArraySet<MyWebSocket>();

    //与某个客户端的连接会话，需要通过它来给客户端发送数据
    private Session session;

    /**
     * 连接建立成功调用的方法*/
    @OnOpen
    public void onOpen(Session session) {
        this.session = session;
        webSocketSet.add(this);     //加入set中
        addOnlineCount();           //在线数加1
        System.out.println("有新连接加入！当前在线人数为" + getOnlineCount());
        try {
            sendMessage(CommonConstant.CURRENT_WANGING_NUMBER.toString());
        } catch (IOException e) {
            System.out.println("IO异常");
        }
    }

    /**
     * 连接关闭调用的方法
     */
    @OnClose
    public void onClose() {
        webSocketSet.remove(this);  //从set中删除
        subOnlineCount();           //在线数减1
        System.out.println("有一连接关闭！当前在线人数为" + getOnlineCount());
    }

    /**
     * 收到客户端消息后调用的方法
     *
     * @param message 客户端发送过来的消息*/
    @OnMessage
    public void onMessage(String message, Session session) {
        System.out.println("来自客户端的消息:" + message);

        //群发消息
        for (MyWebSocket item : webSocketSet) {
            try {
                item.sendMessage(message);
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    /**
     * 发生错误时调用
    @OnError
    public void onError(Session session, Throwable error) {
        System.out.println("发生错误");
        error.printStackTrace();
    }


    public void sendMessage(String message) throws IOException {
        this.session.getBasicRemote().sendText(message);
        //this.session.getAsyncRemote().sendText(message);
    }


    /**
     * 群发自定义消息
     * */
    public static void sendInfo(String message) throws IOException {
        for (MyWebSocket item : webSocketSet) {
            try {
                item.sendMessage(message);
            } catch (IOException e) {
                continue;
            }
        }
    }

    public static synchronized int getOnlineCount() {
        return onlineCount;
    }

    public static synchronized void addOnlineCount() {
        MyWebSocket.onlineCount++;
    }

    public static synchronized void subOnlineCount() {
        MyWebSocket.onlineCount--;
    }
}
```
