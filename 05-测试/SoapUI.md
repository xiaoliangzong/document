# SoapUI

## Web Service

Web service 使用与平台和编程语言无关的方式进行通讯的一项技术，web service 是一个接口，他描述了一组可以在网络上通过标准的 XML 消息传递访问的操作，它基于 xml 语言协议来描述要执行的操作或者要与另外一个 web 服务交换数据，一组以 web 服务在面向服务体系结构中定义的 web 应用程序。

可以简单的理解为 web service 是一个 SOA(面向服务的编程)架构，它不依赖于语言，也不依赖于平台，可以实现不同语言之间的通讯和相互调用。SOAP(简单对象访问协议) 是 xml web service 的通讯协议。 当用户通过 UDDI 找到 WSDL(Web Service Description Language)文档后，通过 SOAP 调用建立的 web service 的一个或者多个操作。SOAP 是 xml 文档形式的调用方法规范，可以支持不同的底层接口。

Web Service 三要素：

1. soap 用来描述传递信息的格式；
2. WSDL（Web Services Description Language） 用来描述如何访问具体的接口；
3. uddi（Universal Description Discovery and Integration） 用来管理，分发，查询 webService 。

## SOAP

SOAP（Simple Object Access Protocol）简单对象访问协议，是交换数据的一种协议规范，是一种轻量的、简单的、基于 XML（标准通用标记语言下的一个子集）的协议，它被设计成在 WEB 上交换结构化的和固化的信息。

SOAP 消息通常由三部分组成：SOAP 信封（Envelope）、SOAP 头（Header）、SOAP 体（Body）。

## 参考链接

[Web Service 接口测试](https://blog.csdn.net/nhb000000/article/details/147352059)
