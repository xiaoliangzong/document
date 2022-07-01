# Maven

## 1. 常用命令

```bash
mvn clear package -Dmaven.test.skip=true   # 忽略测试进行打包，测试代码不会影响项目发布，但是会影响项目打包

```

## 2. 生命周期

Maven 有三个标准的构建生命周期：

- clean：项目清理的处理
- default(或 build)：项目部署的处理
- site：项目站点文档创建的处理

其中 default 生命周期核心阶段由以下几个阶段组成：

|   阶段   |   处理   |                         描述                         |
| :------: | :------: | :--------------------------------------------------: |
| validate | 验证项目 |        验证项目是否正确且所有必须信息是可用的        |
| compile  | 执行编译 |                源代码编译在此阶段完成                |
|   test   |   测试   |     使用适当的单元测试框架（例如 JUnit）运行测试     |
| package  |   打包   |      创建 jar/war 包如在 pom.xml 中定义提及的包      |
|  verify  |   检查   |       对集成测试的结果进行检查，以保证质量达标       |
| install  |   安装   |      安装打包的项目到本地仓库，以供其他项目使用      |
|  deploy  |   部署   | 将安装包上传至远程仓库中，以共享给其他开发人员和工程 |

## 3. 配置

### 3.1 依赖范围、依赖传递

**作用**

1. 使用 scope 来指定当前包的依赖范围和依赖的传递性。常见的可选值有：compile, provided, runtime, test, system 等。
2. optional 是 maven 依赖 jar 时的一个选项，表示该依赖是可选的.不会被依赖传递。

**说明**

- compile 为默认的依赖有效范围。
- system 和 provided 相同，不过被依赖项不会从 maven 仓库下载，而是从本地文件系统拿。需要添加 systemPath 的属性来定义路径。
- test，表示依赖项目仅仅参与测试相关的工作，包括测试代码的编译，执行。

|  作用域  | 对主程序是否有效 | 对测试程序是否有效 | 是否参与打包部署 | 是否传递 |      举例       |
| :------: | :--------------: | :----------------: | :--------------: | :------: | :-------------: |
| compile  |        √         |         √          |        √         |    √     |   spring-core   |
| provided |        √         |         √          |        ×         |    ×     | servlet-api.jar |
|   test   |        ×         |         √          |        ×         |    ×     |      JUnit      |
| runtime  |        ×         |         √          |        √         |    √     |      jdbc       |
|  system  |        √         |         √          |        ×         |    √     |                 |

### 3.2 依赖原则

- 路径最短者优先
- 路径相同时先声明者优先

### 3.3 配置文件

```xml
<!-- maven-compiler-plugin 是用于在编译（compile）阶段加入定制化参数，比如指定java jdk版本号，以及bootclasspath；
而 spring-boot-maven-plugin 是用于 spring boot 项目的打包（package）阶段，两者没什么关系。 -->
<!--  -->
<build>
 <plugins>
  <plugin>
   <groupId>org.apache.maven.plugins</groupId>
   <artifactId>maven-compiler-plugin</artifactId>
   <version>3.1</version>
   <configuration>
    <source>${java.version}</source>
    <target>${java.version}</target>
                <encoding>UTF-8</encoding>
   </configuration>
  </plugin>
        <!-- maven里执行测试用例的插件，不显示配置就会用默认配置。这个插件的surefire:test命令会默认绑定maven执行的test阶段。 -->
  <plugin>
   <groupId>org.apache.maven.plugins</groupId>
   <artifactId>maven-surefire-plugin</artifactId>
   <version>2.19.1</version>
   <configuration>
    <skipTests>true</skipTests>    <!--默认关掉单元测试 -->
   </configuration>
  </plugin>
 </plugins>
</build>


<!--加载xml文件-->
<resources>
    <resource>
        <directory>src/main/java</directory>
        <includes>
            <include>**/*.xml</include>
        </includes>
        <filtering>false</filtering>
    </resource>
    <resource>
        <directory>src/main/resources</directory>
        <includes>
            <include>**/*.properties</include>
            <include>**/*.yml</include>
            <include>**/*.yaml</include>
            <include>**/*.xml</include>
            <include>**/*.tld</include>
            <include>**/*.xlsx</include>
            <include>**/*.xls</include>
        </includes>
        <filtering>false</filtering>
    </resource>
</resources>
```

## 4. Nexus 私服仓库

> nexus-repository-manager

**上传**

```xml
<!-- 一般，仓库的下载和部署是在pom.xml文件中的repositories和distributionManagement元素中定义的，然而，一般类似于用户名，密码等信息不应该在pom.xml文件配置中，这些信息可以配置在setting.xml中 -->
<!-- maven设置私服对应的信息：id、用户、密码，其中，id必须和distrubutionManagement的id相同 -->
<server>
    <id>db
    -maven-release</id>
    <username>admin</username>
    <password>ad
    min123</password>
</server>
<server>
    <id>db-maven-snapshot</id>
    <username>admin</username>
    <password>ad
    min123</password>
</server>

<!-- pom中增加url -->
<distributionManagement>
    <repository>
        <id>db-maven-release</id>   <!-- id的名字可以任意取，但是在setting文件中的属性<server>的ID与这里一致 -->
        <name>libs-release</name>
        <url>http://
        192.168.100.99:8081/repository/db-maven-hosted/</url>
    </repository>
    <snapshotRepository>

        <id>db-maven-snapshot</id>
        <name>libs-snapshot</name>
        <url>http://
        192.168.100.99:8081/repository/db-maven-snapshot/</url>
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
