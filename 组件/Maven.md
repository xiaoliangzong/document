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
