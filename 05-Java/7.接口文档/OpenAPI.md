# OpenAPI 规范

[OpenAPI 规范中文版：https://openapi.apifox.cn/](https://openapi.apifox.cn/)

[个人源代码：https://gitee.com/ruyi-xlz/db-springboot-modules.git](https://gitee.com/ruyi-xlz/db-springboot-modules.git)

## 1. 概念

OpenAPI 规范（OpenAPI Specification，简称 OAS）是 Linux 基金会的一个项目，是定义一个标准的、与具体编程语言无关的RESTful API（RESTful 是一种网络应用程序的设计风格和开发方式） 的规范。

## 2. 为啥要使用 OpenAPI 规范？

OpenAPI 规范这类 API 定义语言能够帮助你更简单、快速的表述 API，尤其是在 API 的设计阶段作用特别突出；根据 OpenAPI 规范编写的二进制文本文件，能够像代码一样用任何 VCS 工具管理起来；一旦编写完成，API 文档可以作为：

- 需求和系统特性描述的根据
- 前后台查询、讨论、自测的基础
- 部分或者全部代码自动生成的根据
- 其他重要的作用，比如开放平台开发者的手册...

## 3. 编写方式

- yaml（推荐）
- json

## 4. 规范示例

java 中 swagger1.x 对应 Swagger2、swagger2.x 对应 OpenAPI3

| OpenAPI 2.0 / Swagger2               | OpenAPI 3.x 规范                             | 说明        |
| ------------------------------------ | -------------------------------------------- | ----------- |
| io.swagger:swagger-annotations:1.6.9 | io.swagger.core.v3:swagger-annotations:2.2.3 | Java 注解包 |
| io.swagger:swagger-models:1.6.9      | io.swagger.core.v3:swagger-models:2.2.3      | Java 模型库 |

![OpenAPI 不同版本模型对比](./images/OpenAPI%20模型对比.png)

### 4.1 OpenAPI 2.0 规范示例

OpenApi 2.0 规范，开头以 swagger: "2.0" 开头。但是要清楚 swagger 2.0 不是 swagger 规范，swagger 只是一个强大的 api 工具，OpenAPI 才是规范。

io.swagger:swagger-models:1.6.9 是Swagger 2.0规范的Java模型库，提供了一组Java模型类，用于表示Swagger规范文件。

**编写说明**

1.  "" 或者 '' 都可以表示值，但是"" 不进行特殊字符转义 ，'' 进行特殊字符转义
2.  有时候读取资源信息的内容会比我们写入资源信息的内容（属性）更多，这很常见,可以使用 readOnly: true
3.  allOf，在嵌套实体时，需要使用该属性，确保实体中的嵌套对象的级别正确
4.  required ，表示参数是否为必选，默认为 false，也可以是一个字符串列表，列表中包含各必带参数名
5.  default，定义一个参数的默认值，设定了某个参数的默认值后，它是否 required 就没意义了
6.  数据的校验
  - 字符串 String （type 字段）
    - minLength number 字符串最小长度
    - maxLength number 字符串最大长度
    - pattern string 正则表达式 (如果你暂时还不熟悉正则表达式，可以看看 Regex 101)

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

### 4.2 OpenAPI 3.0 规范示例

io.swagger.core.v3:swagger-models:2.2.3 是Swagger 3.x规范的Java模型库，提供了一组Java模型类，用于表示OpenAPI规范文件。它包含了OpenAPI规范中的所有数据模型，例如PathItem、Operation、Parameter、Components等。

```yaml
# 使用的 OpenAPI 规范版本
openapi: '3.0.0'
# 表示API的基本信息，包括标题、版本号、描述、联系人等。
info:
  title: '用户模块'
  description: '用户模块'
  version: 1.0.0

# servers 代码块，用于定义 API 服务器的地址。每个URL模板可以包含占位符，这些占位符可以被路径参数或者查询参数替换。
servers:
  - url: http://localhost/api
    variables:
      protocol:
        enum:
          - http
          - https
        default: https
    description: Main (production) server
# 表示API的所有路径和操作信息
paths:
  /user:
    get:
      summary: '条件查询用户'
      tags:
        - 'SysUser'
      description: '条件查询：分页查询、按条件检索'
      operationId: 'queryUser'
      deprecated: false
      parameters:
        - $ref: '#/components/parameters/pageSize'
        - $ref: '#/components/parameters/pageNumber'
      responses:
        200:
          description: '查询成功'
# 表示API的组件信息，比如响应模板、请求模板和安全方案等。          
components:
  schemas:
    SysUser:
      description: '用户'
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
        $ref: '#/components/schemas/SysUser'
    ResultVo:
      type: object
      properties:
        code:
          type: integer
        message:
          type: string
  parameters:
    pageSize:
      name: pageSize
      in: query
      description: '当前页大小，默认为15'
      required: true
      schema:
        type: integer
        default: 15
        maximum: 30
    pageNumber:
      name: pageNumber
      in: query
      description: '页码，默认第一页'
      schema:
        type: integer
        default: 1
    username:
      name: username
      in: query
      description: '用户名'
      schema:
        type: string
        minimum: 8
        maximum: 12
        pattern: '^[a-zA-Z0-9]{8,12}&'

  responses:
    NotFound:
      description: Entity not found.
    '200':
      description: '内部错误'
      content:
        application/json:
          schema:
            $ref: '#/components/schemas/ResultVo'
```

### 5.0 openapi-generator

使用 编译 maven 阶段，mvn clean compile；而不是直接使用插件 mvn openapi-generator:generate

```xml
<plugin>
    <groupId>org.openapitools</groupId>
    <artifactId>openapi-generator-maven-plugin</artifactId>
    <version>5.0.0</version>
    <executions>
        <execution>
            <goals>
                <goal>generate</goal>
            </goals>
            <configuration>
                <!-- 文件路径，不能使用*代替-->
                <inputSpec>${project.basedir}/src/main/resources/api/sys-common.yaml</inputSpec>
                <!-- 用于处理代码生成器的名称 -->
                <generatorName>spring</generatorName>
                <!-- 是否覆盖现有的文件，默认为false -->
                <skipOverwrite>true</skipOverwrite>
                <!-- 目标输出路径，默认为${project.build.directory}/generated-sources/openapi -->
                <output>${project.basedir}</output>
                <!-- 生成的api类对象的包路径 -->
                <apiPackage>com.dxd.db.controller</apiPackage>
                <!-- 生成model实体类对象的包路径 -->
                <modelPackage>com.dxd.db.model</modelPackage>
                <!-- 跳过校验，默认为false -->
                <skipValidateSpec>false</skipValidateSpec>
                <!-- 生成调用者的类对象的包路径，controller？？？ -->
<!--                            <invokerPackage></invokerPackage>-->
                <!-- 是否生成测试模块，默认为true -->
                <generateModelTests>false</generateModelTests>
                <configOptions>
                    <delegatePattern>true</delegatePattern>
                </configOptions>
            </configuration>
        </execution>
    </executions>
</plugin>
```

