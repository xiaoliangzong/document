# Openapi

[学习链接](https://huangwenchao.gitbooks.io/swagger/content/)
[swagger 和 openapi 的区别解释](https://blog.csdn.net/fanzhongcang/article/details/102695534)

### 1. 概念

OpenAPI 规范是 Linux 基金会的一个项目，试图通过定义一种用来描述 API 格式或 API 定义的语言，来规范 RESTful（是一种网络应用程序的设计风格和开发方式） 服务开发过程。OpenAPI 规范帮助我们描述一个 API 的基本信息，比如：

- 有关该 API 的一般性描述
- 可用路径（/资源）
- 在每个路径上的可用操作（获取/提交...）
- 每个操作的输入/输出格式

### 2. 为啥要使用 OpenAPI 规范？

OpenAPI 规范这类 API 定义语言能够帮助你更简单、快速的表述 API，尤其是在 API 的设计阶段作用特别突出
根据 OpenAPI 规范编写的二进制文本文件，能够像代码一样用任何 VCS 工具管理起来
一旦编写完成，API 文档可以作为：

- 需求和系统特性描述的根据
- 前后台查询、讨论、自测的基础
- 部分或者全部代码自动生成的根据
- 其他重要的作用，比如开放平台开发者的手册...
