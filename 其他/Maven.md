# Maven

## 1. 常用命令

```bash
# 忽略测试进行打包，测试代码不会影响项目发布，但是会影响项目打包
mvn clear package -Dmaven.test.skip=true
# 命令行下载jar包
mvn dependency:get --settings /usr/local/fengpin-soft/maven/apache-maven-3.6.3/conf/settings.xml -DgroupId=com.fengpin -DartifactId=fp-security-starter -Dversion=1.0.0
mvn dependency:get -DremoteRepositories=http://xxx/repository/public/ -DgroupId=com.xx -DartifactId=xx-xx -Dversion=1.0.0-SNAPSHOT
# 指定setting
mvn clean package --settings /xxx/conf/settings.xml
# 安装时，指定本地仓库位置
mvn clean install -Dmaven.repo.local=/home/xxx/
# 查看依赖树
mvn -X dependency:tree>tree.txt

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

## 3. pom.xml 配置说明

### 3.1 依赖范围、依赖传递

**作用**

1. 使用 scope 来指定当前包的依赖范围和依赖的传递性。常见的可选值有：compile、provided、runtime、test、system 等。
2. optional 是 maven 依赖 jar 时的一个选项，表示该依赖是可选的，不会被依赖传递。

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

### 3.2 依赖原则（传递依赖）

- 路径最短者优先
- 路径相同时先声明者优先

### 3.3 配置文件

```xml
<build>
    <!-- 资源配置 -->
    <resources>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>true</filtering>     <!-- 过滤，只会将include中的配置文件打包，且替换${key}的值 -->
            <includes>
                <include>**/*.xml</include>
            </includes>
        </resource>
        <resource>
            <directory>src/main/resources</directory>
            <filtering>false</filtering>    <!-- 不过滤，只是将所有配置文件打包到classpath下 -->
            <includes>
                <include>**/*.properties</include>
                <include>**/*.yml</include>
                <include>**/*.yaml</include>
                <include>**/*.xml</include>
                <include>**/*.tld</include>
                <include>**/*.xlsx</include>
                <include>**/*.xls</include>
            </includes>
        </resource>
    </resources>
    <!-- 插件配置 -->
    <plugins>
        <!-- maven-compiler-plugin 是用于在编译（compile）阶段加入定制化参数，比如指定java jdk版本号 -->
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
        <!-- maven里执行测试用例的插件，保证test测试目录可以正常跳过打包，不显示配置就会用默认配置。这个插件的surefire:test命令会默认绑定maven执行的test阶段。 -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>2.19.1</version>
            <configuration>
                <skipTests>true</skipTests>    <!-- 跳过项目运行测试用例 -->
            </configuration>
        </plugin>
        <!-- spring-boot-maven-plugin 是用于 spring boot 项目的打包（package）阶段。 -->
        <plugin>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-maven-plugin</artifactId>
            <version>2.6.4</version>
            <configuration>
                <fork>true</fork> <!-- 如果没有该配置，devtools不会生效 -->
            </configuration>
            <executions>
                <execution>
                    <goals>
                        <goal>repackage</goal>
                    </goals>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

## 4. 配置（Setting）

maven 默认的中央仓库是在 maven 安装目录下的 /lib/maven-model-builder-${version}.jar 中，打开该文件，能找到超级
POM：\org\apache\maven\model\pom-4.0.0.xml ，它是所有 Maven POM 的父 POM，所有 Maven 项目继承该配置，
在这个 POM 中找到 repositories 标签的 url：https://repo.maven.apache.org/maven2

本地仓库 > profile > pom 中的 repository > mirror

```xml
<!-- setting 设置 -->
<settings xmlns="http://maven.apache.org/SETTINGS/1.2.0"
          xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
          xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.2.0 http://maven.apache.org/xsd/settings-1.2.0.xsd">

    <!-- 本地仓库路径配置，命令行参数：-Dmaven.repo.local=xxx -->
    <localRepository>D:\apache-maven-3.8.1\repository</localRepository>


    <!-- 远程库的服务器信息，用于需要认证的远程仓库，一般这种信息不配置在 pom.xml 中 -->
    <!-- 上传部署 jar/pom 到私有仓库时，是需要在 pom 和 setting 中都配置的，pom 中配置 distributionManagement 标签，setting 中配置服务器认证信息，和distributionManagement配合使用。-->
    <servers>
        <server>
            <id>releases</id>               <!-- id必须和pom中的distrubutionManagement的id相同 -->
            <username>admin</username>      <!-- 用户密码 -->
            <password>admin@nexus</password>
        </server>
        <server>
            <id>snapshots</id>
            <username>admin</username>
            <password>admin@nexus</password>
        </server>
    </servers>

    <!--
     | 仓库镜像：
     | mirror 相当于一个拦截器，它会拦截maven对remote repository的相关请求，把请求里的remote repository地址，重定向到mirror里配置的地址；
     |
     | mirrors 可以配置多个子节点，但它只会使用其中的一个节点，即默认情况下配置多个mirror的情况下，只有第一个生效，
     | 只有当前一个mirror无法连接的时候，才会去找后一个；
     |
     | mirror 中配置的库，默认只支持 release 库的拉取，snapshot 是不支持的。
     |
     | -->
    <mirrors>
        <mirror>
            <id>alimaven</id>                                        <!-- id是唯一标识一个mirror -->
            <name>aliyun maven</name>                                <!-- name是节点名 -->
            <url>https://maven.aliyun.com/repository/public/</url>   <!-- url是官方的库地址 -->
            <!--
             | mirrorOf代表一个镜像的替代位置，常用配置：* 匹配所有远程仓库，repo1,repo2 只匹配这两个仓库，*,!repo1 匹配除repo1外的所有仓库；
             |
             | 如果配置为 * ，则表示该仓库地址为所有仓库的镜像，那么这个时候，maven会忽略掉其他设置的各种类型仓库，只在mirror里面找，
             | 所以建议不要这样设置，它将导致pom文件中、pforile里面的仓库设置都失效。
             |
             | -->
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>

    <!--
     | <profiles>里可以配置多个<profile>，并且需要使用<activeProfiles>来激活，只有激活了哪个<profile>，哪个<profile>才生效。
     |
     | 配置Maven项目中需要使用的远程仓库，可以配置多个，可以配置在 pom 或 setting 中，但一般为了共用，经常配置在 setting 中
     |
     | 优先级顺序：如果都激活了，根据profile定义的先后顺序来进行覆盖取值，后面定义的会覆盖前面，其properties为同名properties中最终有效，
     | 并不是根据activeProfile定义的顺序。
     |
     | -->
    <profiles>
        <!-- 全局设置 -->
        <profile>
            <id>jdk1.8</id>
            <activation>
                <activeByDefault>true</activeByDefault>
                <jdk>1.8</jdk>
            </activation>
            <properties>
                <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
                <maven.compiler.source>1.8</maven.compiler.source>
                <maven.compiler.target>1.8</maven.compiler.target>
                <maven.compiler.compilerVersion>1.8</maven.compiler.compilerVersion>
            </properties>
        </profile>

        <!-- 阿里云仓库配置 -->
        <profile>
            <id>ali-profile</id>
            <repositories>
                <repository>
                    <id>alimaven</id>
                    <name>aliyun maven</name>
                    <url>https://maven.aliyun.com/repository/public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>alimaven</id>
                    <name>aliyun maven</name>
                    <url>http://maven.aliyun.com/nexus/content/groups/public/</url>
                </pluginRepository>
            </pluginRepositories>
        </profile>

		<!-- 私服仓库配置 -->
        <profile>
            <id>nexus-profile</id>
            <repositories>
                <repository>
                    <id>nexus</id>    <!--仓库id，repositories可以配置多个仓库，保证id不重复-->
                    <name>xxx-nexus-name</name>
                    <url>http://192.168.100.99:8082/repository/maven-public/</url>
                    <releases>
                        <enabled>true</enabled>
                    </releases>
                    <snapshots>
                        <enabled>true</enabled>
                    </snapshots>
                </repository>
            </repositories>
            <pluginRepositories>
                <pluginRepository>
                    <id>nexus</id>
                    <name>Public Repositories</name>
                    <url>http://192.168.100.99:8082/repository/maven-public/</url>
					<releases>
						<enabled>true</enabled>
					</releases>
					<snapshots>
						<enabled>true</enabled>
					</snapshots>
				</pluginRepository>
            </pluginRepositories>
        </profile>
    </profiles>

    <!-- 激活配置 -->
    <!-- 根据profile定义的先后顺序来进行覆盖取值的，后面定义的会覆盖前面定义的 -->
    <!-- 也可以使用-P参数显示的激活一个profile -->
    <activeProfiles>
        <activeProfile>jdk1.8</activeProfile>
        <activeProfile>ali-profile</activeProfile>
        <activeProfile>nexus-profile</activeProfile>
    </activeProfiles>
</settings>
```

## 5. Nexus 私服仓库

私服搭建：nexus-repository-manager

### 5.1 上传

```xml
<!-- setting中设置 -->
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
        <url>http://
        192.168.100.99:8081/repository/db-maven-snapshot/</url>
    </snapshotRepository>
</distributionManagement>

<!-- 执行命令 -->
maven clean deploy
```

### 5.2 下载部署

```xml
<profile>
    <!--profile的id-->
    <id>nexus-profile</id>
    <!-- 远程仓库列表 -->
    <repositories>
        <repository>    <!--仓库id，repositories可以配置多个仓库，保证id不重复-->
            <id>nexus-db</id>
            <!--仓库地址，即nexus仓库组的地址-->
            <url>http://192.168.100.99:8081/repository/db-maven-group/</url>
            <releases>
                <enabled>true</enabled>
            </releases>
            <snapshots>
                <enabled>true</enabled>
            </snapshots>
        <repository>
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
