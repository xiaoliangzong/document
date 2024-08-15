# IntelliJ IDEA



## 1 常用插件

1. Lombok（简化代码）
2. Alibaba Java Coding Guidelines（编码规范检查）
3. Json Viewer
4. Eclipse Code Formatter/Adapter for Eclipse Code Formatter（统一代码格式化，需要加载配置文件）
5. Resource Bundle Editor（国际化文件编写）
6. EnvFile（环境文件配置）

## 2 更改配置

1. 修改字体背景为护眼模式（C7EDCC），字体大小和样式为 JetBrains Mono(14)、Consolas(15)
2. 快捷键智能提示改为 Alt + /
3. 类注释模板配置：Editor -> File and Code Templates -> includes
4. 消除类注释警告：Wrong tag 'Date' ，需要配置：Editor -> Inspections -> java -> javadoc -> Javadoc declaration problems -> Options
5. -Xms 初始内存大小，提高 Java 程序的启动速度，通常为操作系统可用内存的 1/64 大小。
6. -Xmx 程序运行期间最大可占用的内存大小，是堆的最大内存，提高该值，可以减少内存 Garage 收集的频率，提高程序性能，如果设置过小，可能抛出 OutOfMemory 异常，通常为操作系统可用内存的 1/4 大小。
7. -Xss 每个线程的堆栈大小，默认 JDK1.4 中是 256K，JDK1.5+中是 1M。


## 3. IDEA 同时启动多个相同项目

原理：启动 jar 时，增加配置参数（端口）。 jar -jar xxx.jar --server.port=8080

![ IDEA 同时启动多个相同项目配置](./images/idea.png)
