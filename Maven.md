## 常用命令

- 打包时需使用：mvn clear package -Dmaven.test.skip=true 忽略测试进行打包，测试代码不会影响项目发布，但是会影响项目打包

## maven 打包配置文件

````xml
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

## pom 中 scpoe 标签

1. 默认值为 complie，compile 表示被依赖项目需要参与当前项目的编译，springboot 多模块相互依赖中有用到
2. test，表示依赖项目仅仅参与测试相关的工作，包括测试代码的编译，执行。
3. runtime，表示被依赖项目无需参与项目的编译，不过后期的测试和运行周期需要其参与，与 compile 相比，跳过了编译而已。例如 JDBC 驱动，适用运行和测试阶段
4. provided，打包的时候可以不用包进去，别的设施会提供
5. system，从参与度来说，和 provided 相同，不过被依赖项不会从 maven 仓库下载，而是从本地文件系统拿。需要添加 systemPath 的属性来定义路径

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
            <!-- 插件仓库的i
            d不允许重复，如果重复后边配置会覆盖前边 -->
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
````
