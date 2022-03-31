## 1. HttpServletResponse

HttpServletResponse 接口继承自 ServletResponse 接口，主要用于封装 HTTP 响应消息。由于 HTTP 响应消息分为状态行、响应消息头、消息体三部分。

### 常用方法

```java
// 设置 HTTP 响应消息的状态码
setStatus(int status)
sendError(int status)       // 发送表示错误信息的状态码


// 发送响应消息头相关方法
addHeader(String name, String value)        // addHeader() 方法可以增加同名的响应头字段
setHeader(String name, String value)        // setHeader() 方法则会覆盖同名的头字段
setContentType(String type)                 // 用于设置Servlet输出内容的 MIME 类型，定义网络文件的类型和网页的编码；Servlet默认为text/plain
    1. text/html                // HTML 格式
    2. text/plain               // 纯文本格式
    3. text/xml                 // XML 格式
    4. image/gif                // gif 图片格式
    5. image/jpeg               // jpg 图片格式
    6. image/png                // png 图片格式
    7. application/json         // JSON 数据格式
    8. application/pdf          // pdf 格式
    9. application/msword       // Word 文档格式
    10. application/octet-stream                        // 二进制流数据
    11. application/vnd.ms-excel、application/x-xls     // XLS 文档格式
    12. application/x-www-form-urlencoded               // <form encType="">中默认的 encType，form 表单数据被编码为 key/value 格式发送到服务器（表单默认的提交数据的格式）
    13. multipart/form-data                             // 需要在表单中进行文件上传时，就需要使用该格式
    14. video/mpeg4                                     // mp4 音频格式

Content-Disposition

// 消息体相关方法
getOutputStream()        // 获取字节输出流对象（ServletOutputStream），直接输出字节数组中的二进制数据
getWriter()              // 获取字符输出流对象（PrintWriter ），直接输出字符文本内容
```

#### Access-Control-Expose-Headers

默认情况下，响应消息头只有七个作为响应的一部分暴露给外部，如果客户端想要访问其他的属性，则需要将他们暴露出来

response.addHeader("Access-Control-Expose-Headers", <header-name>,<header-name>);

## 2. 文件导出方案

1. 后端返回二进制文件，前端通过 blob 数据格式接收，并通过构建 a 链接 URL 的方式实现文件的下载
