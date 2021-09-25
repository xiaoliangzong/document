# Swagger 和 Openapi 规范

## 一、Swagger

### 1. 概念

是一个规范且完整的框架，用于生成、描述、调用和可视化 RESTful 风格的 Web 服务
Swagger 是一个简单但功能强大的 API 表达工具。使用 Swagger 生成 API，我们可以得到交互式文档，自动生成代码的 SDK (软件开发工具包)以及 API 的发现特性等。

## 2. 特点

1. Api 框架
2. restful Api 文档在线自动生成工具
3. 可以直接运行，在线测试 api 接口
4. 支持多种语言：java、php...

## 3. swagger2.0

> Springboot 需要扫描配置类 SwaggerConfig，使用注解@Configuration

1. 导入依赖：

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

2. 开启 swagger 注解：@EnableSwagger2

3. 创建 swagger 的 Docket 的 bean 实例，使用注解@Bean

```java
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
```

​ `说明`：**配置多个分组：**

> ` 创建多个docket`

## 4. 常用注解

1. 实体类： ApiModel、实体属性：ModelProperty

2. Controller 类:Api

3. 接口方法的说明：ApiOperation

4. 方法参数的说明：@ApiImplicitParams、@ApiImplicitParam

5. 方法返回值的说明：@ApiResponses @ApiResponse

## 5. 参数 ParamType 和 dataType

ParamType：表示参数放在哪个位置

- header-->请求参数的获取：@RequestHeader(代码中接收注解)
- query-->请求参数的获取：@RequestParam(代码中接收注解)
- path（用于 restful 接口）-->请求参数的获取：@PathVariable(代码中接收注解)
- body-->请求参数的获取：@RequestBody(代码中接收注解)
- form（不常用）

dataType：参数类型，可传基本类型、类、泛型类等

## 6. knife4j

1. i18n 国际化
2. 接口添加作者
3. 自定义文档
4. 访问权限控制
5. 导出离线文档

## 二、Openapi

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

### 3. 如何编写

- yaml（推荐）
- json

### 4. 编辑器工具

- Swagger Editor [网页链接](https://editor.swagger.io/)

### 5. 编写规范以及说明

```yaml
swagger: '2.0'

info:
  version: 1.0.0
  title: Simple API
  description: A simple API to learn how to write OpenAPI Specification

schemes:
  - https
host: simple.api
basePath: /openapi101

paths: {}
```

#### 第一部分

    OpenAPI规范的版本号：swagger: "2.0"

#### 第二部分

    API描述信息=

```yaml
info:
  version: 1.0.0
  title: Simple API
  description: A simple API to learn how to write OpenAPI Specification
```

#### 第三部分

    API的URL，因为和具体环境有关，不涉及API描述的根本内容，所以这部分信息是可选的。

```yaml
schemes:
  - https # 协议:http或者https
host: simple.api # 主机
basePath: /openapi101 # 跟路径
```

#### 第四部分

    API的操作

```yaml
paths:
  /persons:
    get:
      summary: Gets some persons
      description: Returns a list containing all persons.
      operationId: createCourse
      parameters:
       - name: pageSize
         in: query
         description: Number of persons returned
         type: integer
       - name: pageNumber
         in: query
         description: Page number
         type: integer
      responses:
        200:
          description: A list of Person
          schema:
            type: array
            items:
              required:
                - username
              properties:
                firstName:
                  type: string
                lastName:
                  type: string
                username:
                  type: string
    post:
      summary: Creates a person
      description: Adds a new person to the persons list.
      parameters:
        - name: person
          in: body
          description: The person to create.
          schema:
            required:
              - username
            properties:
              firstName:
                type: string
              lastName:
                type: string
              username:
                type: string
/persons/{username}:
get:
    summary: Gets a person
    description: Returns a single person for its username
    parameters:
    - name: username
        in: path
        required: true
        description: The person's username
        type: string
```

#### 其他标签

1. 定义 definitions，在文档的尾部定义，里边可以定义对象。
2. 使用万能引用$ref: "#/definitions/Person"来引用对象
3. 定义 responses，可以复用 http 响应。

```yaml
responses:
  Standard500ErrorResponse:
    description: An unexpected error occured.
    schema:
      $ref: '#/definitions/Error'
```

4. 定义 parameters，放在最后，里边定义参数，也可以这样子使用：路径参数可以定义一个，放在方法 get 前面，与请求方式同级。
5. 有时候读取资源信息的内容会比我们写入资源信息的内容（属性）更多，这很常见,可以使用 readOnly: true
6. allOf，在嵌套实体时，需要使用该属性，确保实体中的嵌套对象的级别正确
7. required ，表示参数是否为必选，默认为 false，也可以是一个字符串列表，列表中包含各必带参数名
8. default，定义一个参数的默认值，设定了某个参数的默认值后，它是否 required 就没意义了
9. 通过关键字 tags 我们可以对文档中接口进行归类，tags 的本质是一个字符串列表。tags 定义在文档的根路径下。

### 6. 数据的校验

#### 6.1 字符串 String （type 字段）

minLength number 字符串最小长度
maxLength number 字符串最大长度
pattern string 正则表达式 (如果你暂时还不熟悉正则表达式，可以看看 Regex 101)

#### 6.2 日期和时间

date ISO8601 full-date 2016-04-01
dateTime ISO8601 date-time 2016-04-16T16:06:05Z

#### 6.3 数字类型和范围

名称 类型 格式
integer integer int32
long integer int64
float number float
double number double
minimum number 最小值
maximum number 最大值
exclusiveMinimum boolean 数值必须 > 最小值
exclusiveMaximum boolean 数值必须 < 最大值
multipleOf number 数值必须是 multipleOf 的整数倍

#### 6.4 枚举

```yaml
code:
  type: string
  enum:
    - DBERR
    - NTERR
    - UNERR
```

#### 6.5 数值的大小和唯一性

属性 类型 描述
minItems number 数值中的最小元素个数
maxItem number 数值中的最大元素个数
uniqueItems boolean 标示数组中的元素是否唯一

#### 6.6 二进制数据

可以用 string 类型来表示二进制数据：

格式 属性包含
byte Base64 编码字符
binary 任意十进制的数据序列

## yaml 生成 java 代码

[yaml 生成 java 代码](https://blog.csdn.net/yzy199391/article/details/84023982)

> Maven generate-sources 根据 pom 配置去生成源代码格式的包

1. SwaggerCodeGen 代码生成工具

swagger- codegen-cli 脚手架工具或者访问 github 地址：https://github.com/swagger-api/swagger- codegen 根据提示操作，里面也有示例

利用 Swagger Codegen 根据服务生成客户端代码
java -jar swagger-codegen-cli-2.2.1.jar generate -i http://petstore.swagger.io/v2/swagger.json -l java -o samples/client/pestore/java
在上面这段代码里，使用了三个参数，分别是-i 和-l 和-o。

-i 指定 swagger 描述文件的路径,url 地址或路径文件;该参数为必须(http://petstore.swagger.io/v2/swagger.json是官方的一个例子，我们可以改成自己的服务)

-l 指定生成客户端代码的语言,该参数为必须

-o 指定生成文件的位置(默认当前目录)
除了可以指定上面三个参数，还有一些常用的：

-c json 格式的配置文件的路径;文件为 json 格式,支持的配置项因语言的不同而不同

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

json 配置文件，可以没有，如果没有的话，上边的这些参数就需要在命令行指定

```json
{
    "groupId" : "cn.fzk",　　　　　　　　　　　　　　# 这三个就是 maven下载jar包需要的三个参数
    "artifactId" : "spring-cloud-client",
    "artifactVersion" : "1.0.0",

    "interfaceOnly" : "true",
    "library" : "feign",　　　　　　　　　　　　　　  # library template to use (官网说的还没太懂，和http请求有关，用了这个就需要在项目配置相关jar包,指定了实际的实现框架)
    "invokerPackage" : "cn.com.client",　　　　　　# 相当于源文件的真正代码的位置
    "modelPackage" : "cn.com.client.model",　　　　# model存放的位置definitions下定义的东西
    "apiPackage" : "cn.com.client.api"　　　　　　 # API最终在DefaultApi中，这个文件的位置
}
```
