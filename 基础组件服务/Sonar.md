## 1. Sonar 代码检查工具

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
