## 获取网络 ip、地址信息接口

> http://whois.pconline.com.cn/

1. 太平洋网站
2. 网络 IP 地址查询 Web 接口

## 浏览器解析工具：UserAgentUtils

> 获取浏览器、操作系统等信息

1. 依赖

```xml
<dependency>
    <groupId>eu.bitwalker</groupId>
    <artifactId>UserAgentUtils</artifactId>
</dependency>
```

2. 实例

```java
  String agent = request.getHeader("User-Agent");
  //解析agent字符串
  UserAgent userAgent = UserAgent.parseUserAgentString(agent);
  //获取浏览器对象
  Browser browser = userAgent.getBrowser();
  //获取操作系统对象
  OperatingSystem operatingSystem = userAgent.getOperatingSystem();
  System.out.println("浏览器名:"+browser.getName());
  System.out.println("浏览器类型:"+browser.getBrowserType());
  System.out.println("浏览器家族:"+browser.getGroup());
  System.out.println("浏览器生产厂商:"+browser.getManufacturer());
  System.out.println("浏览器使用的渲染引擎:"+browser.getRenderingEngine());
  System.out.println("浏览器版本:"+userAgent.getBrowserVersion());

  System.out.println("操作系统名:"+operatingSystem.getName());
  System.out.println("访问设备类型:"+operatingSystem.getDeviceType());
  System.out.println("操作系统家族:"+operatingSystem.getGroup());
  System.out.println("操作系统生产厂商:"+operatingSystem.getManufacturer());
```
