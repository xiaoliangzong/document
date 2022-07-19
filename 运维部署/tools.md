## 1. IntelliJ IDEA

### 1.1 常用插件

1. Lombok（简化代码）
2. Alibaba Java Coding Guidelines（编码规范检查）
3. Json Viewer
4. Eclipse Code Formatter（统一代码格式化，需要加载配置文件）

### 1.2 更改配置

1. 修改字体背景为护眼模式（C7EDCC），字体大小和样式为 JetBrains Mono(14)、Consolas(15)
2. 快捷键智能提示改为 Alt + /
3. 类注释模板配置：Editor -> File and Code Templates
4. 消除类注释警告：Wrong tag 'Date' ，需要配置：Editor -> Inspections -> java -> javadoc -> Javadoc declaration problems -> Options
5. Xms 为 IDEA 初时的内存大小，提高 Java 程序的启动速度。
6. Xmx 为 IDEA 最大内存数，提高该值，可以减少内存 Garage 收集的频率，提高程序性能。
7. -XX:ReservedCodeCacheSize=512m 保留代码占用的内存容量。

## 2. Visual Studio Code

### 2.1 常用快捷键

- ctrl+shift+P 万能搜索
- alt+上下键 上下移
- shift+alt+上下键 向上下复制一行
- shift+ctrl+k 删除一行
- ctrl+enter 下边插入一行
- ctrl+shift+\ 跳转到匹配的括号

### 2.2 常用插件

- Chinese (Simplified) (简体中文)
- eslint 代码格式化
- vetur 集 vue.js 代码提示，语法高亮等功能为一体的流行插件
- prettier-Code formatter 代码格式化
- guides 显示代码对齐辅助线
- HTMLHint 显示 html 错误
- vscode-icons 左侧显示图标
- import Cost 该插件会在行尾显示导入包的大小
- path intellisense 识别引入文件路径，提供路径提示功能
- material icon Theme 主题插件
- carbon-now-sh 将选择代码生成图片，操作：选中图片，ctrl+shift+P，输入 carbon。
- Turbo console log 打印日志，快捷键：ctrl+alt+l
- Markdown Preview Enhanced
- live server 开启服务，地址路径变了
- auto rename tag 修改 html 标签，前后同步

### 2.3 常见问题

- 解决换行问题：npm run lint --fix

## 3. Sonar 代码检查工具

**docker 安装**

1. 安装 mysql 或 postgres（pgsql）；启动容器
   - docker run -it --name mysql-sonar -p 3306:3306 -v /opt/sonar/mysql/data:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=123456 mysql:latest
2. 设置一个 sonar 的用户，分配一定的权限，需要注意的是，在容器里边通过命令行操作。在宿主机上无法登录数据库
   - 设置用户时，注意鉴权参数：从 MySQL 8.0.4 开始, 默认的认证插件从 mysql_native_password 变为 caching_sha2_password
     alter user 'root'@'localhost' identified by 'root' password expire never;
     alter user 'root'@'localhost' identified with mysql_native_password by 'root'
     flush privileges;
3. 下载 sonarqube，docker pull sonarqube，7.9 版本之后不支持 mysql！！！
4. docker run -it --name sonarqube -p 9000:9000 -p 9092:9092 --link=mysql-sonar:mysql-sonar -v /opt/sonar/sonarqube/data:/opt/sonarqube/data -v /opt/sonar/sonarqube/extensions:/opt/sonarqube/extensions -e SONARQUBE_JDBC_USERNAME=sonar -e SONARQUBE_JDBC_PASSWORD=sonar -e SONARQUBE_JDBC_URL="jdbc:mysql://192.168.100.46:3306/sonar?useUnicode=true&characterEncoding=utf8&rewriteBatchedStatements=true&useConfigs=maxPerformance&useSSL=false" sonarqube:7.8-community

5. postgres 数据库：
   docker pull postgres:10.4
   docker pull sonarqube:7.1 6.7.3
   docker run -it --name sonarqube --link postgres -e SONAQUBE_JDBC_URL=jdbc:postgresql://postgres:5432/sonar -p 9000:9000 -v /opt/sonar/sonarqube/data:/opt/sonarqube/data -v /opt/sonar/sonarqube/extensions:/opt/sonarqube/extensions sonarqube:7.8-community

**使用方式**

1. 方案 1：根据页面提示，创建用户名密码，选择编程语言，版本控制工具，生成一个 maven 命令；
   - mvn sonar:sonar -Dsonar.host.url=https://localhost:9000 -Dsonar.login=0c9cc0b3b23cdecbb58e8fcd0929e99aa3bec050
2. 方案 2：使用 sonar-scanner 工具
3. 方案 3：修改 maven 的 setting 文件

```xml
<!-- pom文件添加如下内容(注意,jdk版本必须是jdk1.8) -->
<!-- <profiles>标签下添加如下内容 -->
<profile>
    <id>sonar</id>
    <activation>
        <activeByDefault>true</activeByDefault>
    </activation>
    <properties>
        <!-- 配置 Sonar Host地址，默认：http://localhost:9000 -->
        <sonar.host.url>
          http://10.100.28.186:9000
        </sonar.host.url>
    </properties>
</profile>
<!--pom文件添加如下内容(注意,jdk版本必须是jdk1.8) -->
<build>
   <plugins>
       <plugin>
           <groupId>org.sonarsource.scanner.maven</groupId>
           <artifactId>sonar-maven-plugin</artifactId>
           <version>3.1.1</version>
       </plugin>
   </plugins>
</build>

<!-- 执行命令：mvn clean install sonar:sonar -->
```

## 4. docsify 文档网站生成器

说明：该文档就是基于 docsify 搭建的，配置简单，无需编译，只需要会 markdown 语法即可，详细配置可参考项目：[https://github.com/xiaoliangzong/document.git](https://github.com/xiaoliangzong/document.git)

**使用步骤：**

```shell
# 全局安装
npm install docsify -g
# 初始化项目，初始化成功后，可以看到 ./docs 目录下创建的几个文件
docsify init ./docs
    # index.html 入口文件
    # README.md 会做为主页内容渲染，更新网站内容
    # .nojekyll 用于阻止 GitHub Pages 会忽略掉下划线开头的文件
# 运行项目
docsify serve docs
# 访问，默认端口为 3000
http://localhost:3000
```
