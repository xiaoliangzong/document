## maven 打包配置文件

```xml
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
