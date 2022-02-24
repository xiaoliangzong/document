# Swagger

### 1. 概念

Swagger 是一个简单但功能强大的 API 表达工具。使用 Swagger 得到交互式文档，自动生成代码的 SDK (软件开发工具包)以及 API 的发现特性等；通过遵循它的标准，可以使 RESTAPI 分组清晰、定义标准；

### 2. 常用注解

1. APiModel：实体类
2. ApiModelProperty：实体属性
3. Api:接口类
4. ApiOperation：接口方法的说明
5. @ApiImplicitParams、@ApiImplicitParam：方法参数的说明
6. @ApiResponses @ApiResponse：方法返回值的说明
7. dataType 属性：参数类型，可传基本类型、类、泛型类等
8. ParamType 属性： 表示参数放在哪个位置

   - header-->请求参数的获取：@RequestHeader(代码中接收注解)
   - query-->请求参数的获取：@RequestParam(代码中接收注解)
   - path（用于 restful 接口）-->请求参数的获取：@PathVariable(代码中接收注解)
   - body-->请求参数的获取：@RequestBody(代码中接收注解)
   - form（不常用）

### 3. Swagger 生成 API 文档

通过 Swagger 生成 API 文档有两种方式：

1. 通过代码注解来生成。好处：随时保持接口和文档的同步。坏处：代码入侵
2. 使用 Swagger Editor 编写 API 文档的 Yaml/Json 定义。

虽然第一种方式最方便，不用编写 swagger 配置文件，但是对代码污染太严重了。 使用第二种方式，用 Yaml 生成代码，然后也可以实现 Swagger UI 来展示 API 文档，也可以用 swagger2markup 将其转换为 AsciiDoc 或 MarkDown 格式；然后再通过 asciidoctor-maven-plugin 将其转换为漂亮的 HTML 格式文档方便查看。[使用 Swagger 生成 RESTful API 文档](https://www.xncoding.com/2017/06/09/web/swagger.html)

### 4. Swagger UI

**SpringBoot 项目使用步骤：​**

- 导入依赖
- 开启 Swagger 注解：@EnableSwagger2
- 编写配置类

```xml
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger2</artifactId>
    <version>2.9.2</version>
</dependency>
<!--swagger ui，访问页面为swagger-ui.html-->
<dependency>
    <groupId>io.springfox</groupId>
    <artifactId>springfox-swagger-ui</artifactId>
    <version>2.9.2</version>
</dependency>
<!-- bootStrap-ui,只是在改变页面效果，默认的是swagger-ui.html;使用bootstrap后，为doc.html -->
<dependency>
    <groupId>com.github.xiaoymin</groupId>
    <artifactId>swagger-bootstrap-ui</artifactId>
    <version>1.9.2</version>
</dependency>
```

```java
@Configuration//配置类
@EnableSwagger2 //swagger注解
public class SwaggerConfig {
    // 创建 swagger 的 Docket 的 bean 实例，使用注解@Bean；如需配置多个分组，则创建多个docket实例
    @Bean
    public Docket docket(Environment environment) {
        // 设置显示的swagger环境信息
        Profiles profiles = Profiles.of("dev", "test");
        // 判断是否处在自己设定的环境当中
        boolean flag  = environment.acceptsProfiles(profiles);

        return new Docket(DocumentationType.SWAGGER_2)
                .apiInfo(apiInfo())
                .groupName("党博")  // 配置api文档的分组
                .enable(flag)  // 配置是否开启swagger
                .select()
                .apis(RequestHandlerSelectors.basePackage("com.dangbo.controller")) //配置扫描路径
                .paths(PathSelectors.none()) // 配置过滤哪些
                .build();
    }
    // api基本信息
    private ApiInfo apiInfo() {
        return new ApiInfo("my first swagger",
                "党博的第一个swagger",
                "v1.0",
                "http://mail.qq.com",
                new Contact("dangbo", "http://mail.qq.com", "1456131152@qq.com"),  //作者信息
                "Apache 2.0",
                "http://www.apache.org/licenses/LICENSE-2.0",
                new ArrayList());
    }
}
```

### 5. Swagger 2.0 规范

**编写方式**

- yaml（推荐）
- json

**编辑器工具**

- [Swagger Editor](https://editor.swagger.io/)

**编写规范说明**

1.  "" 或者 '' 都可以表示值，但是"" 不进行 特殊字符转义 ，'' 进行特殊字符转义
2.  有时候读取资源信息的内容会比我们写入资源信息的内容（属性）更多，这很常见,可以使用 readOnly: true
3.  allOf，在嵌套实体时，需要使用该属性，确保实体中的嵌套对象的级别正确
4.  required ，表示参数是否为必选，默认为 false，也可以是一个字符串列表，列表中包含各必带参数名
5.  default，定义一个参数的默认值，设定了某个参数的默认值后，它是否 required 就没意义了

6.  数据的校验

- 字符串 String （type 字段）

  minLength number 字符串最小长度

  maxLength number 字符串最大长度

  pattern string 正则表达式 (如果你暂时还不熟悉正则表达式，可以看看 Regex 101)

```yaml
# 第一部分：版本号，swagger: "2.0"
swagger: '2.0'

# 第二部分：API描述信息；元数据主要包括一些REST 接口的描述信息
info:
  description: 'This is a sample server Petstore server.'
  version: '1.0.0' #  表示该rest API版本
  title: '用户模块' # rest api 接口标题名
  termsOfService: 'http://swagger.io/terms/' # 服务条款
  contact: # 联系方式
    email: '1456131152@qq.com'
  license: # 许可证信息
    name: 'Apache 2.0'
    url: 'http://www.apache.org/licenses/LICENSE-2.0.html'

# 第三部分：API的URL，因为和具体环境有关，不涉及API描述的根本内容，所以这部分信息是可选的。
host: localhost # 主机
basePath: /api # 基本网址，必须以"/"开头，不指定默认为"/"
schemes:
  - http # 协议:http或者https

tags: # 标签信息，可以对文档中接口进行归类，tags 的本质是一个字符串列表；tags 定义在文档的根路径下。
  - name: 'user'
    description: '用户'
    externalDocs:
      description: '用户接口信息'
      url: 'http://swagger.io'
  - name: 'role'
    description: '角色'
# 第四部分：API接口，实体等信息的定义
paths:
  /user:
    get:
      summary: '查询用户'
      tags:
        - 'user'
      description: '查询用户...'
      operationId: 'queryUserList'
      parameters:
        - in: body
          name: 'user'
          description: '条件查询分页参数'
          required: true
          schema:
            $ref: '#/definitions/PageInfo'
      responses:
        default:
          description: 'successful operation'
          schema:
            $ref: '#/definitions/SysUsers'
    post:
      summary: '创建用户'
      tags:
        - 'user'
      description: '注册用户...'
      operationId: 'createUser'
      produces:
        - 'application/xml'
        - 'application/json'
      parameters:
        - in: 'body'
          name: 'body'
          description: 'Created user object'
          required: true
          schema:
            $ref: '#/definitions/SysUser'
      responses:
        default:
          description: 'successful operation'
  /user/{userId}:
    get:
      summary: '条件查询'
      tags:
        - 'user'
      description: '条件查询：分页查询、按条件检索'
      operationId: 'queryUser' # 方法名
      deprecated: false # 是否弃用
      parameters:
        - name: 'userId'
          in: path
          description: '用户id'
          required: true
          type: integer
      responses:
        '200':
          description: '查询详情成功'
          schema:
            $ref: '#/definitions/SysUser' # 使用万能引用$ref: "#/definitions/Person"来引用对象
        '404':
          description: 'User not found'

# 定义 definitions，在文档的尾部定义，里边可以定义对象。
definitions:
  SysUser:
    properties:
      account:
        type: string
      username:
        type: string
      email:
        type: string
  SysUsers:
    type: array
    items:
      $ref: '#/definitions/SysUser'
  ResultVo:
    type: object
    properties:
      code:
        type: integer
      message:
        type: string
  PageInfo:
    properties:
      pageSize:
        type: integer
      pageNum:
        type: integer

# 定义 parameters，放在最后，里边定义参数，也可以这样子使用：路径参数可以定义一个，放在方法 get 前面，与请求方式同级。
parameters:
  pageSize:
    name: pageSize
    in: query
    type: integer
    default: 15
    maximum: 30
    description: '当前页大小，默认为15'
  pageNumber:
    name: pageNumber
    in: query
    type: integer
    default: 1
    description: '页码，默认第一页'
  username:
    name: username
    in: query
    type: string
    minimum: 8
    maximum: 12
    pattern: '^[a-zA-Z0-9]{8,12}&'
    description: '用户名'

# 定义 responses，可以复用 http 响应
responses:
  500ErrorResponse:
    description: '内部错误'
    schema:
      $ref: '#/definitions/ResultVo'
```

### 6. Swagger Codegen

**swagger-codegen-maven-plugin**

```xml
<!-- swagger-codegen-maven-plugin -->
<plugin>
    <groupId>io.swagger</groupId>
    <artifactId>swagger-codegen-maven-plugin</artifactId>
    <version>2.4.13</version>
    <configuration>
        <language>spring</language>
        <generateApis>true</generateApis>
        <generateModels>true</generateModels>
        <generateSupportingFiles>false</generateSupportingFiles>
        <!-- swagger 接口定义文件位置 -->
        <inputSpec>${project.basedir}/src/main/resources/api/sys-common.yaml</inputSpec>
        <!-- 生成的代码输出位置 -->
        <output>${project.basedir}</output>
        <!-- api包路径 -->
        <apiPackage>com.dxd.db.api</apiPackage>
        <!-- model包路径 -->
        <modelPackage>com.dxd.db.dto</modelPackage>

        <importMappings>
            <importMapping>LocalDate=java.time.LocalDate</importMapping>
            <importMapping>LocalDateTime=java.time.LocalDateTime</importMapping>
        </importMappings>
        <configOptions>
            <interfaceOnly>true</interfaceOnly>
            <dateLibrary>java8</dateLibrary>
            <java8>true</java8>
            <defaultInterfaces>false</defaultInterfaces>
        </configOptions>
    </configuration>
</plugin>
```

**swagger-codegen-cli**

[github 地址](https://github.com/swagger-api/swagger-codegen)可以根据提示操作，里面也有示例；或者使用 swagger-codegen-cli 脚手架工具

```json
java -jar swagger-codegen-cli-2.2.1.jar generate -i D:/xxx.Yaml -l java -o D:/swagger-codegen/java

-i 指定Json或Yaml文件的输入路径
-l 指定生成客户端代码的语言，该参数为必须
-o 指定生成文件的位置，默认当前目录

除了可以指定上面三个参数，还有一些常用的：
-c json格式的配置文件路径；支持的配置项因语言的不同而不同，可以将配置项写入到json文件中；就不需要命令行指定了。如果没有的话，这些参数就需要在命令行指定

-a 当获取远程 swagger 定义时,添加授权头信息;URL-encoded 格式化的 name,逗号隔开的多个值
--api-package 指定生成的 api 类的包名
--invoker-package
--artifact-id 指定 pom.xml 的 artifactId 的值
--artifact-version 指定 pom.xml 的 artifact 的版本
--group-id 指定 pom.xml 的 groupId 的值
--model-package 指定生成的 model 类的包名
-s 指定该参数表示不覆盖已经存在的文件
-t 指定模版文件所在目录
--library 指定实际的实现框架

{
    "interfaceOnly" : "true",
    "library" : "feign",　　　　　　　　　　　　　　
    "invokerPackage" : "com.dxd.db.client",　　　　　　# 相当于源文件的真正代码的位置
    "modelPackage" : "com.dxd.db..model",　　　     　# model存放的位置definitions下定义的东西
    "apiPackage" : "com.dxd.db.api"　　　　　　       # API最终在DefaultApi中，这个文件的位置
}
```
