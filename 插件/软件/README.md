## 1. vscode

**常用快捷键**

- ctrl+shift+P 无能搜索
- alt+上下键 上下移
- shift+alt+上下键 向上下复制一行
- shift+ctrl+k 删除一行
- ctrl+enter 下边插入一行
- ctrl+shift+\ 跳转到匹配的括号

**常用插件**

- chinese
- open in browser
- guides 显示代码对齐辅助线
- HTMLHint 显示 html 错误
- vscode-icons 左侧显示图标
- import Cost 该插件会在行尾显示导入包的大小
- path intellisense 识别引入文件路径，提供路径提示功能
- material icon Theme 主题插件
- prettier-Code formatter 格式化代码 (常用)
- carbon-now-sh 将选择代码生成图片，操作：选中图片，ctrl+shift+P，输入 carbon。
- Turbo console log 打印日志，快捷键：ctrl+alt+l
- browser preview vscode 中打开浏览器
- live server 开启服务，地址路径变了
- auto rename tag 修改 html 标签，前后同步
- vetur vue 高亮
- eslint(常用)

**解决换行问题**

- npm run lint --fix

## 2. Sonar 代码检查工具

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

## 3. Nexus 私服仓库

> nexus-repository-manager

**上传**

```xml
<!-- 一般，仓库的下载和部署是在pom.xml文件中的repositories和distributionManagement元素中定义的，然而，一般类似于用户名，密码等信息不应该在pom.xml文件配置中，这些信息可以配置在setting.xml中 -->
<!-- maven设置私服对应的信息：id、用户、密码，其中，id必须和distrubutionManagement的id相同 -->
<server>
    <id>db-maven-release</id>
    <username>admin</username>
    <password>admin123</password>
</server>
<server>
    <id>db-maven-snapshot</id>
    <username>admin</username>
    <password>admin123</password>
</server>

<!-- pom中增加url -->
<distributionManagement>
    <repository>
        <id>db-maven-release</id>   <!-- id的名字可以任意取，但是在setting文件中的属性<server>的ID与这里一致 -->
        <name>libs-release</name>
        <url>http://192.168.100.99:8081/repository/db-maven-hosted/</url>
    </repository>
    <snapshotRepository>
        <id>db-maven-snapshot</id>
        <name>libs-snapshot</name>
        <url>http://192.168.100.99:8081/repository/db-maven-snapshot/</url>
    </snapshotRepository>
</distributionManagement>

<!-- 执行maven clean deploy -->
```

**下载（只需要在 settings 中配置）**

```xml
<!-- id和下面的mirror中的id一致，代表拉取是也需要进行身份校验；下载私服仓库镜像不需要身份验证!!! -->
<server>
    <id>nexus-db</id>
    <username>admin</username>
    <password>admin123</password>
</server>

<!-- 配置镜像 -->
<mirror>
    <id>nexus-db</id>
    <name>internal nexus repository</name>
    <mirrorOf>central</mirrorOf>
    <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
</mirror>


<!-- profiles节点，<profiles>里配置了多个<profile>，需要使用<activeProfiles>来进行激活，激活了哪个<profile>，哪个<profile>才生效 -->
<profile>
    <!--profile的id-->
    <id>nexus-profile</id>

    <!-- 远程仓库列表 -->
    <repositories>
        <repository>
        <!--仓库id，repositories可以配置多个仓库，保证id不重复-->
        <id>nexus-db</id>
        <!--仓库地址，即nexus仓库组的地址-->
        <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
        <!--是否下载releases构件-->
        <releases>
            <enabled>true</enabled>
        </releases>
        <!--是否下载snapshots构件-->
        <snapshots>
            <enabled>true</enabled>
        </snapshots>
        </repository>
    </repositories>

    <!-- 插件仓库列表 -->
    <pluginRepositories>
        <!-- 插件仓库，maven的运行依赖插件，也需要从私服下载插件 -->
        <pluginRepository>
            <!-- 插件仓库的id不允许重复，如果重复后边配置会覆盖前边 -->
            <id>nexus-db</id>
            <name>Public Repositories</name>
            <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
            <layout>default</layout>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
            <releases>
                <enabled>true</enabled>
            </releases>
        </pluginRepository>
    </pluginRepositories>
</profile>

<!-- 必须激活，否则profiles中相关配置不起效果 -->
<activeProfiles>
    <activeProfile>nexusProfile</activeProfile>
    <activeProfile>jdk-1.8</activeProfile>
</activeProfiles>
```

## 4. docsify 文档网站生成器

> 说明：该文档就是基于 docsify 搭建的，配置简单，无需编译，只需要会 markdown 语法即可，详细配置可参考项目：[github](https://github.com/xiaoliangzong/document.git)

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
