# MapStruct

MapStruct是一个Java注解处理器，用于在Java Bean之间执行对象映射，生成类型安全的映射代码。它可简化在不同类型的对象之间进行转换的过程，避免了手动编写大量的映射代码。

MapStruct通过使用注解来标记源对象和目标对象之间的映射关系，并生成相应的映射实现代码。它支持各种映射关系，包括简单的属性映射、集合映射、嵌套对象映射等。

MapStruct映射是在编译期间实现的，因此相比运行期的映射框架，它的优点是安全性高、速度快。


## 1. 底层实现原理

MapStruct是基于JSR 269实现的，JSR 269是JDK引进的一种规范。它使用Annotation Processor在编译期间处理注解，并读取、修改和添加抽象语法树中的内容。Annotation Processor相当于编译器的一种插件，因此称它为插入式注解处理。

实现JSR 269，主要有以下几个步骤：

- 继承AbstractProcessor类，并且重写process方法，在process方法中实现自己的注解处理逻辑；
- 在META-INF/services目录下创建javax.annotation.processing.Processor文件注册自己实现的Annotation Processor。

编译的流程步骤：

- Java编译器对Java源码进行编译，生成抽象语法树（Abstract Syntax Tree，AST）；
- 调用实现了JSR 269 API的程序。只要程序实现JSR 269 API，就会在编译期间调用实现的注解处理器；
- 在实现JSR 269 API的程序中，修改抽象语法树，插入自己的实现逻辑；
- 修改完抽象语法树后，Java编译器会生成修改后的抽象语法树对应的字节码文件。

## 2. 安装 IDEA 插件

IntelliJ IDEA 中下载 MapStruct Support 插件，安装完后重启Idea。插件的好处：

- 在参数上，按Ctrl + 鼠标左键，能够自动进入参数所在类的文件；
- 在编写映射关系的 source 和 target 时，可以代码提示。

## 3. Mavne 依赖

```xml
<properties>
    <!-- 版本依赖 -->
    <springboot.version>2.3.7.RELEASE</springboot.version>
    <lombok.version>1.18.22</lombok.version>
    <mapstruct.version>1.5.5.Final</mapstruct.version>
</properties>

<dependencies>
    <!-- MapStruct 核心 -->
    <!--
        mapstruct-jdk8，它提供了对Java 8特性的支持。具体来说，MapStruct-JDK8允许您在映射过程中使用Java 8的新特性，如Java 8的日期时间API（例如LocalDate、LocalDateTime）和函数式接口（例如函数式映射、条件映射等）。但是好像高版本都支持Java8，不需要单独引用。
    -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct</artifactId>
        <version>${mapstruct.version}</version>
    </dependency>
    <!-- 弃用，所包括的功能都迁移至 mapstruct -->
    <!-- Deprecated MapStruct artifact containing annotations to be used with JDK 8 and later Relocated to mapstruct -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-jdk8</artifactId>
        <version>1.5.5.Final</version>
    </dependency>
    <!-- 注解处理器，用来处理和生成映射代码的注解处理器。需要在项目的构建配置中添加MapStruct-Processor作为依赖，以便在编译过程中触发注解处理器的执行。 -->
    <dependency>
        <groupId>org.mapstruct</groupId>
        <artifactId>mapstruct-processor</artifactId>
        <version>${mapstruct.version}</version>
        <!-- 作用域scope被设置为provided，这是因为注解处理器在编译时由编译器提供，而不是在运行时由应用程序提供。 -->
        <scope>provided</scope>
    </dependency>
</dependencies>


<!-- 需要配置编译插件以支持注解处理器 -->
<!-- maven-compiler-plugin 插件，解决 spring-boot-configuration-processor + Lombok + MapStruct 组合 -->
<!-- https://stackoverflow.com/questions/33483697/re-run-spring-boot-configuration-annotation-processor-to-update-generated-metada -->
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.8.1</version>
            <configuration>
                <source>1.8</source> <!-- 指定源代码版本 -->
                <target>1.8</target> <!-- 指定目标字节码版本 -->
                <annotationProcessorPaths>
                    <path>
                        <groupId>org.springframework.boot</groupId>
                        <artifactId>spring-boot-configuration-processor</artifactId>
                        <version>${springboot.version}</version>
                    </path>
                    <path>
                        <groupId>org.projectlombok</groupId>
                        <artifactId>lombok</artifactId>
                        <version>${lombok.version}</version>
                    </path>
                    <path>
                        <groupId>org.mapstruct</groupId>
                        <artifactId>mapstruct-processor</artifactId>
                        <version>${mapstruct.version}</version>
                    </path>
                </annotationProcessorPaths>
            </configuration>
        </plugin>
    </plugins>
</build>
```

## 4. 调用方式

### 常用注解说明

@Mapper是 MapStruct 中最核心的注解，它的作用是将一个接口标记为映射器接口。使用 @Mapper 注解的接口会在编译时自动生成映射实现代码，开发人员只需要定义接口方法和参数即可。

@Mapper 注解支持多种属性配置，常见的属性包括：

- uses：用于指定其他映射器接口或自定义转换器（常用于处理复杂类型）的引用，以便在当前映射器中进行使用。
- imports：用于引入其他类的完全限定名，以便在生成的映射实现类中使用这些类。这允许通过Mapping.expression()、Mapping.defaultExpression() 或使用简单名称（而非全称）给出的映射表达式中引用这些类型。
- unmappedSourcePolicy：指定如何处理源对象中未映射的字段，默认值为 ReportingPolicy.IGNORE，表示忽略未映射的字段。
- unmappedTargetPolicy：指定如何处理目标对象中未映射的字段，默认值为 ReportingPolicy.WARN，表示输出警告信息。
- componentModel：指定生成的映射实现类是否使用 Spring 的组件模型，默认值为 "default"，可选值为 "default"、"spring"、"cdi"、"jsr330"、"jsr330-stub" 等。
- nullValueMappingStrategy：指定如何处理 null 值，默认值为 NullValueMappingStrategy.RETURN_NULL，表示返回 null。
- mappingControl：指定映射控制策略，用于控制某些字段的映射行为。

**说明**

uses 和 import 属性有相似的作用，但它们在使用方式和作用范围上存在一些差异。

- uses 属性用于指定其他映射器类，这些映射器类中定义的映射方法可以在当前的映射器类中直接使用。通过使用 uses 属性，我们可以在当前映射器类中调用其他映射器类中定义的映射方法。这种方式主要用于处理映射器类之间的依赖关系。
- import 属性用于指定需要在生成的映射器实现类中导入的类型。该属性允许我们在生成的映射器实现类中引入所需的类型，以确保生成的代码可以正常编译和执行。import 属性通常用于处理生成的代码中的类型引用，而不是处理映射器类之间的关系。

@Named 注解，用于标识自定义的转换方法或其他方法。它可以与 @Mapping 注解中的 qualifiedByName 属性一起使用。如果是外部其他映射器，也可以与 @Mapper 注解中的 uses 属性一起使用。

@InheritInverseConfiguration 注解， 是 MapStruct 中的一个注解，用于指定反向映射配置的继承。

@Mapping 注解属性：

- source：指定源属性名称。如果源对象的属性名称与目标对象的属性名称相同，则可以省略该属性。
- target：指定标目标属性名称。
- qualifiedBy：指定用于限定映射方法的限定符（Qualifier）注解。
- qualifiedByName：指定用于限定映射方法的限定符（Qualifier）的名称。
- constant：指定一个常量值作为目标属性的值。
- ignore：表示忽略该映射关系，不进行属性值的转换。
- expression：使用 SpEL（Spring Expression Language）表达式指定目标属性的值。表达式中要使用其他类的方法，要带全类名（包名.类名.函数名）或者使用@Mapper的imports显式导入所需要的类。
- defaultValue：指定目标属性的默认值，当源属性为 null 或不存在时使用该默认值。
- nullValuePropertyMappingStrategy：定义处理源属性为 null 时的映射策略。
- nullValueCheckStrategy：定义处理目标属性为 null 时的映射策略。
- numberFormat：指定基本数据类型与String之间的转换
- dateFormat：指定Date和String之间的转换


### 4.1 方式1：默认方式

```java
@Mapper
public class WholePriceAssembler {

    WholePriceAssembler INSTANCE = Mappers.getMapper(WholePriceAssembler.class);

    WholePriceVO toVO(WholePrice wholePrice);
}

```

### 4.2 方式2：Spring注入方式

MapStruct 将自动为该 Mapper 接口生成一个 Spring Bean，并将其添加到 Spring 容器中。此时，可以通过依赖注入或其他 Spring 的方式来获得该 Mapper Bean 的实例。不再需要手动调用 Mappers.getMapper(xxx.class) 来获取 Mapper 实例。

```java
@Mapper(componentModel = "spring")
public class WholePriceAssembler {

    WholePriceVO entityToVO(WholePrice wholePrice);
}

```

## 5. 使用示例

### 5.1 简单转换

mapstruct会自动完成基本类型的一些隐式转换（包括：boolean、byte、char、int、long、float、double、String及其包装类等），不需要写Mapping映射关系。

- 相同基本类型可以直接转换；
- 基本类型与其包装类型可以直接转换，且会自动生成判空代码；
- 基本类型转String类型，如int/Integer转String，实际上使用的是String.valueOf()方法，支持所有基本类型转String；
- 所有的数字类型及其包装类都可以直接转换，如int/Integer、long/Long之间转换，实际上会进行强制转换。需要注意长字节类型转短字节类型会发生截断，存在数据溢出、精度丢失等问题。
- StringBuilder与String可以直接转换

```java
@Mapper
public class WholePriceAssembler {

    WholePriceAssembler INSTANCE = Mappers.getMapper(WholePriceAssembler.class);

    // 属性名一样的，会自动映射并填充。属性名不一样的，用 @Mapping 注解定义映射关系，source 为数据源，target 为要填充的目标属性
      @Mappings({
            @Mapping(source = "rtPrice", target = "realtimePrice"),
            @Mapping(source = "price", target = "price", numberFormat = "#.00元"),
            @Mapping(source = "days", target = "days", numberFormat = "#天"),
            @Mapping(target = "forecastTime", dateFormat = "yyyy-MM-dd HH:mm:ss")
    })
    WholePriceVO entityToVO(WholePrice wholePrice);

    // 多个Mapping时，用 Mappings 包起来，多个参数的类型中有同名的属性，这种情况需要指定一个source
    @Mappings({
        @Mapping(source = "wholePrice.rtPrice", target = "realtimePrice"),
        @Mapping(source = "wholeForecast.rtPrice", target = "realtimeForecastPrice")
    })
    WholePriceVO entityToVO(WholePrice wholePrice, WholeForecastPrice wholeForecastPrice);
  
}

```

### 5.2 嵌套对象转换

1. 类型相同的两个类，User 转 UserRoleVO（其中都包含Role类），映射时只拷贝role的引用，不会生成一个新的role对象。
2. 类型不同的两个类，需要写两个转换方法，当执行User转UserRoleDTO时，会自动调用Role转RoleDTO的方法来生成对象，即在当前Mapper中寻找有相同类型入参和相同返回值类型的映射方法，如果存在则自动引用该方法。

```java
@Mapper
public interface UserAssembler {

    UserAssembler INSTANCE = Mappers.getMapper(UserAssembler.class);

    UserRoleVO toUserVO(User User);

    RoleVO toRoleVO(Role role);
}
```

### 5.3 集合映射

- 基本类型及其包装类的相同集合可以直接转换，如 List<String> 转 List<Integer>；
- 同类型的List和Set可以直接转换
- 复杂List、Set的转换，如 List<A> 转 List<B>，需要先实现 A 转 B 的 toB() 方法；在实现 List<A> 转 List<B> 的 toBList() 方法，不需要显示调用，mapstruct会在 toBList() 方法中自动循环调用 toB() 方法；
- 复杂Map的转换，如 Map<A, C> 转 Map<B, D>，类似与List的转换，需要先分别实现 A 转 B 的 toB()、C 转 D 的 toD() 方法，然后再实现 Map<A, C> 转 Map<B, D>的 toMap()方法；


### 5.4 枚举映射

- 两个Enum之间的转换，使用@ValueMappings和@ValueMapping，可以理解成是用if判断枚举值，然后返回对应结果；也可以使用qualifiedByName指定
- 枚举与字符串之间的转换，是指枚举的 name() 方法返回值和字符串，两个可以相互转换；
- 字符串转枚举再转字符串，常用场景是根据字符串找到对应的枚举，然后得到枚举的字符串属性

```java
@Mapper(imports = {com.fengpin.vpp.common.enums.GensetStateEnum.class}) 
public interface UserAssembler {  

    UserAssembler INSTANCE = Mappers.getMapper(UserAssembler.class);

    @Mappings({
        @Mapping(source = "enumTypeA", target = "enumTypeB"),    // 枚举之间的转换
        @Mapping(source = "enumName", target = "enum"),          // 字符串与枚举之间的转换

        // 字符串转枚举再转字符串，表达式中要使用其他类的方法，要带全类名（包名.类名.函数名）或者使用@Mapper的imports显式导入所需要的类。
        @Mapping(target = "typeDesc", expression = "java(GensetStateEnum.from(user.getType()).getTypeDesc())"),  
        @Mapping(target = "typeDesc", expression = "java(com.fengpin.vpp.common.enums.GensetStateEnum.GensetStateEnum.from(user.getType()).getTypeDesc())")
    })
    UserVO toVO(User user);

    @ValueMappings({
        @ValueMapping(source = "A_AAA", target = "B_AAA"),
        @ValueMapping(source = "A_BBB", target = "B_BBB"),
        @ValueMapping(source = "A_CCC", target = "B_CCC")
    })
    EnumB toEnumB(EnumA enumA);
}

```

### 5.5 自定义映射方法

Mapstruct有些场景不能完成，可以自定义转化方法。

- expression：当需要对源对象和目标对象进行复杂的转换或计算时，可以使用expression来定义自定义的转换逻辑。例如，将多个字段的值合并到一个字段中，或者使用正则表达式筛选出满足特定条件的字段。
- qualifiedByName：当需要对某一类型的属性进行特殊转换时，可以使用qualifiedByName来指定一个自定义转换器。例如，当需要将一个字符串类型的属性值转换为日期类型时，可以使用qualifiedByName来指定一个专门的日期转换器。通常和 @Named 注解一起使用。

```java
// 方式一： 使用 expression 表达式
public class CommonConverter {
    public static String listToStr(List<String> list) {
        if (CollUtil.isEmpty(list)) {
            return null;
        }
        return String.join(Constant.COMMA_SEPARATOR, list);
    }
}

@Mapper(imports = {CommonConverter.class})
public interface ArchiveEnterpriseInfoAssembler {
    ArchiveEnterpriseInfoAssembler INSTANCE = Mappers.getMapper(ArchiveEnterpriseInfoAssembler.class);
    
    // 使用 imports 导入后，编写 expression 表达式时，就不需要指定全路径。如果没有使用 imports，则需要指定全路径。
    @Mapping(target = "resourceType", expression = "java(com.fengpin.vpp.converter.CommonConverter.listToStr(archiveEnterpriseInfo.getResourceType()))")
    @Mapping(target = "resourceType", expression = "java(CommonConverter.listToStr(archiveEnterpriseInfo.getResourceType()))")
    ArchiveEnterpriseInfoVO toVO(ArchiveEnterpriseInfo archiveEnterpriseInfo);
}

// 方式二：使用 @Named 注解

public class CommonConverter {
    @Named("listToStr")
    public static String listToStr(List<String> list) {
        if (CollUtil.isEmpty(list)) {
            return null;
        }
        return String.join(Constant.COMMA_SEPARATOR, list);
    }
}

@Mapper(uses = {CommonConverter.class})
public interface ArchiveEnterpriseInfoAssembler {
    ArchiveEnterpriseInfoAssembler INSTANCE = Mappers.getMapper(ArchiveEnterpriseInfoAssembler.class);
    
    // 引入其他自定义转换器，则需要使用 uses 属性引入，然后使用。常用于一个字段的类型转换。
    // @Named 注解是否可以省略？？？不行，否则就找不到。
    @Mapping(target = "resourceType", source = "resourceType", qualifiedByName  = "listToStr")
    ArchiveEnterpriseInfoVO toVO(ArchiveEnterpriseInfo archiveEnterpriseInfo);
}
```

## 6. 常见问题

### 6.1 Couldn’t retrieve @Mapper annotation

包冲突：项目中使用了swagger，swagger里面也包含mapstruct，可能是依赖冲突导致的，需要排除掉

```xml
<dependency>
    <groupid>io.springfox</groupid>
    <artifactid>springfox-swagger2</artifactid>
    <version>${swagger2.version}</version>
    <exclusions>
        <exclusion>
          <groupid>org.mapstruct</groupid>
          <artifactid>mapstruct</artifactid>
        </exclusion>
    </exclusions>
</dependency>
 ```

