## 1. 命名规范

- DO、BO、DTO、VO 需要大写
- 蛇形命名法（snake case），下划线将单词链接：file_name
- 骆驼拼写法（CamelCase）
  - 大驼峰：CamelCase
  - 小驼峰：camelCase

## 2. 反射

反射就是动态加载对象，是指程序在运行期间可以拿到一个对象的所有信息；

JVM 为每个加载的 class 及 interface 创建了对应的 Class 实例来保存它的所有信息；获取一个 class 对应的 Class 实例后，就可以获取该 class 的所有信息；通过 Class 实例获取 class 信息的方法称为反射（Reflection）。

**用途**

- Spring 框架底层大量使用，比如 IOC 基于反射创建对象和设置依赖属性。
- Spring MVC 的请求调用对应方法，也是通过反射。
- poi 通用工具解析类：解析 excel 为 List<LinkedHashMap<Integer, String>>数据，通过反射转换为各种不同的对象
- 行列互换，数据库字段横向插入，在 vo 使用时，需要转换成纵向

**API**

```java
// 获取Class实例的三种方式
Class clazz = A.class;
Class clazz = b.getClass();
Class clazz = Class.forName("全限定类名");

// 获取构造器对象，通过构造器创建对象，有参无参都可以
Constructor<?> constructor = clazz.getConstructor(Class<?>... parameterTypes);
T t = constructor.newInstance();    // 参数个数与声明的个数必须一样，否则报异常：IllegalArgumentException

// 通过对象创建实例
T t = clazz.newInstance();

// 通过class对象获取属性、方法
Field[] fields = clazz.getFields();         // 获得某个类的所有的公共（public）的字段，包括父类中的字段。
Method[] methods = clazz.getMethods();

Field[] fields = clazz.getDeclaredFields(); // 获得某个类的所有声明的字段，即包括public、private和proteced，但是不包括父类的申明字段
 Method[] methods = clazz.getDeclaredMethods();

// 通过class对象获得指定属性或方法
Method method = clazz.getMethod("方法名", Class<?>... parameterTypes);         // 只能获取公共的

Method method = clazz.getDeclaredMethod("方法名", Class<?>... parameterTypes); // 获取任意修饰的方法，不能执行私有

method.setAccessible(true);  // 让私有的方法可以执行

// 让方法执行
method.invoke(clazz);
```

## 3. String.format()

| 转换符 | 详细说明                                       | 示例       |
| ------ | ---------------------------------------------- | ---------- |
| %s     | 字符串类型                                     |            |
| %c     | 字符类型                                       | 'm'        |
| %b     | 布尔类型                                       | true       |
| %d     | 整数类型（10 进制）                            |            |
| %x     | 整数类型（16 进制）                            | FF         |
| %o     | 整数类型（8 进制）                             | 77         |
| %f     | 浮点类型                                       | 2.123      |
| %a     | 浮点类型（16 进制）                            |            |
| %e     | 指数类型                                       | 9.39e+5    |
| %g     | 通用浮点类型（f 和 e 类型重较短的）            | 基本用不到 |
| %h     | 散列码                                         | 基本用不到 |
| %%     | 百分比类型%（%特殊字符%%才能显示%）            |            |
| %n     | 换行符                                         | 基本用不到 |
| %tx    | 日期和时间类型（x 代表不同的日期与时间转换符） | 基本用不到 |

## 4. 设置小数位数（四舍五入）

```java
// 方式一 String.format()
// %n.mf：n表示字符串总长度，m表示小数位数，如果m<=n+1+整数部分长度，编译结果按照实际数据输出整数部分，小数位数按照m长度输出；如果m>n+1+整数部分长度，小数位数按照m长度输出，整数部分在左边补空格；
double d =123.12345678845242;
String format = String.format("%.2f", d);
String format = String.format("%02d", number)   // 2位整数，不够补0，如果整数大于位数，按照实际输出

// 方式二 DecimalFormat
// #表示数字或占位符，不存在就显示为空；0表示数字，不存在就补0；%表示百分号，可以转换为对应的百分值
String format1 =  new DecimalFormat("#.00").format(d);

// 方式三 BigDecimal
BigDecimal bigDecimal1 =  BigDecimal.valueOf(d).setScale(2, BigDecimal.ROUND_HALF_UP);

// 方式四 NumberFormat
NumberFormat numberInstance = NumberFormat.getNumberInstance();
numberInstance.setMaximumFractionDigits(2);
numberInstance.format(d);

// 方式五 Math 通过乘除来取值
Math.round(d * 100) / 100.0
```

# 5. 接口和抽象类

|            | 接口 interface                                                                                                                                                                                                                                                                                                                                                                                                                                                      | 抽象类 abstract                                                                        |
| ---------- | :------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ | -------------------------------------------------------------------------------------- |
| 定义       |                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 使用 abstract 关键字修饰的类是抽象类                                                   |
| 默认修饰符 | public static final                                                                                                                                                                                                                                                                                                                                                                                                                                                 |                                                                                        |
|            | 接口可以包含变量、方法                                                                                                                                                                                                                                                                                                                                                                                                                                              | 可以包含一个或多个抽象方法的类                                                         |
|            | 变量被隐士指定为 public static final，方法被隐士指定为 public abstract（JDK1.8 之前）                                                                                                                                                                                                                                                                                                                                                                               | 抽象方法只有方法的声明，没有方法体                                                     |
|            | JDK1.8 中对接口增加了新的特性：（1）、默认方法（default method）：JDK 1.8 允许给接口添加非抽象的方法实现，但必须使用 default 关键字修饰；定义了 default 的方法可以不被实现子类所实现，但只能被实现子类的对象调用；如果子类实现了多个接口，并且这些接口包含一样的默认方法，则子类必须重写默认方法；（2）、静态方法（static method）：JDK 1.8 中允许使用 static 关键字修饰一个方法，并提供实现，称为接口静态方法。接口静态方法只能通过接口调用（接口名.静态方法名）。 | 包含抽象方法的一定是抽象类，但是抽象类不一定含有抽象方法                               |
|            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 抽象类中的抽象方法的修饰符只能为 public 或者 protected，默认为 public                  |
|            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 抽象类不能被实例化只能被继承                                                           |
|            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 一个子类继承一个抽象类，则子类必须实现父类抽象方法，否则子类也必须定义为抽象类         |
|            |                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | 抽象类可以包含属性、方法、构造方法，但是构造方法不能用于实例化，主要用途是被子类调用。 |

**相同点**

（1）都不能被实例化 （2）接口的实现类或抽象类的子类都只有实现了接口或抽象类中的方法后才能实例化。

**不同点**

（1）接口只有定义，不能有方法的实现，java 1.8 中可以定义 default 方法体，而抽象类可以有定义与实现，方法可在抽象类中实现。

（2）实现接口的关键字为 implements，继承抽象类的关键字为 extends。一个类可以实现多个接口，但一个类只能继承一个抽象类。所以，使用接口可以间接地实现多重继承。

（3）接口强调特定功能的实现，而抽象类强调所属关系。

（4）接口成员变量默认为 public static final，必须赋初值，不能被修改；其所有的成员方法都是 public、abstract 的。抽象类中成员变量默认 default，可在子类中被重新定义，也可被重新赋值；抽象方法被 abstract 修饰，不能被 private、static、synchronized 和 native 等修饰，必须以分号结尾，不带花括号。

实现类可以不必覆写 default 方法。default 方法的目的是，当我们需要给接口新增一个方法时，会涉及到修改全部子类。如果新增的是 default 方法，那么子类就不必全部修改，只需要在需要覆写的地方去覆写新增方法。

default 方法和抽象类的普通方法是有所不同的。因为 interface 没有字段，default 方法无法访问字段，而抽象类的普通方法可以访问实例字段。

## 6. 拦截器、过滤器、AOP

> 过滤器能做的，拦截器基本上都能做

Filter 和 Interceptor 区别：

1. 拦截器是基于 java 的反射机制，使用代理模式；而过滤器是基于函数回调
2. 拦截器不依赖 servlet 容器，依赖 spring 容器；而过滤器依赖于 servlet 容器，只能在 web 环境下使用
3. 拦截器只能对 action 起作用；而过滤器可以对几乎所有的请求起作用
4. 拦截器可以访问 action 上下文，堆栈里边的对象；而过滤器不可以
5. 拦截器有更精细的控制，可以在 controller 对请求处理之前和之后被调用，也可以在渲染视图呈现给用户之后调用；而过滤器的控制比较粗，只能在请求进来时进行处理，对请求和响应进行包装。
6. 拦截器可以在 preHandle 方法内返回 false 进行中断；而过滤器就比较复杂，需要处理请求和响应对象来引发中断，比如将用户重定向到错误页面

过滤器拦截 web 访问 url 地址，用在 web 环境中，是基于函数回调机制实现的，只能控制最初的 http 请求，可以对拦截到方法的请求和响应，并做出过滤操作，主要用于设置字符编码、鉴权操作。
拦截器可以控制请求的控制器和方法，但控制不了请求方法里边的参数，只能获取到参数的名称，具体的值获取不到；主要用于处理提交的请求响应并进行处理，例如国际化，做主题更换，过滤等

Spring 的 AOP：

- 常用于日志，事务，请求参数安全验证等。
- 获取 http 请求：((ServletRequestAttributes) RequestContextHolder.getRequestAttributes())

## 7. 深拷贝和浅拷贝

> 区别：最根本的区别在于是否真正获取一个对象的复制实体，而不是引用。
> java 的赋值都是传值的，对于基础类型来说，会拷贝具体的内容，但是对于引用对象来说，存储的这个值只是指向实际对象的地址，拷贝也只会拷贝引用地址。

1. 浅拷贝：官方的定义为对基本数据类型进行值传递，对引用数据类型进行引用传递般的拷贝。
2. 深拷贝：官方的定义为对基本数据类型进行值传递，对引用数据类型，创建一个新的对象，并复制其内容。

深拷贝：基本类型和包装类、String，对象实现 Cloneable 接口，重写 clone 方法。

浅拷贝：对象复制
import org.springframework.beans.BeanUtils;
BeanUtils.copyProperties(Object source, Object target) // 浅拷贝

方法的参数传递

`结论：Java中其实还是值传递的，只不过对于引用类型参数，值的内容是对象的引用。`

`传递参数分为两种`

`值传递：`调用函数时，是实际参数复制一份传递，对参数的修改不会影响实际参数

`引用传递：`传递的是引用地址

## 8. 随机数

1.  Random、ThreadLocalRandom、SecureRandom

2.  Random：伪随机数，通过种子生成随机数，种子默认使用系统时间，可预测，安全性不高，线程安全；
3.  ThreadLocalRandom：jdk7 才出现的，多线程中使用，虽然 Random 线程安全，但是由于 CAS 乐观锁消耗性能，所以多线性推荐使用
4.  SecureRandom：可以理解为 Random 升级，它的种子选取比较多，主要有：时间，cpu，使用情况，点击事件等一些种子，安全性高；特别是在生成验证码的情况下，不要使用 Random，因为它是线性可预测的。所以在安全性要求比较高的场合，应当使用 SecureRandom。

相同点：种子相同，在相同条件，运行相同次数产生的随机数相同；

## 9. CollectionUtils 工具类

> `取交集intersection、并集union、差集subtract、补集disjunction、`

<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.3</version>
</dependency>
