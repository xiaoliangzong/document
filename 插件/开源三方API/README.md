## Lombok

**IntelliJ IDEA 使用时，必须安装插件！**

> 注意点：当使用@Data 注解时，则有了@EqualsAndHashCode 注解，那么就会在此类中存在 equals(Object other) 和 hashCode()方法，且不会使用父类的属性；如果有多个类有相同的部分属性，把它们定义到父类中，那么就会存在部分对象在比较时，它们并不相等，却因为 lombok 自动生成的 equals(Object other) 和 hashCode()方法判定为相等，从而导致出错。
>
> 修复此问题的方法很简单：
>
> 1.  使用@Getter @Setter @ToString 代替@Data 并且自定义 equals(Object other) 和 hashCode()方法，比如有些类只需要判断主键 id 是否相等即足矣。
> 2.  或者使用在使用@Data 时同时加上@EqualsAndHashCode(callSuper=true)注解。

1. @Accessors 注解：链式编程
   - @Accessors(fluent = true)，使用 fluent 属性，getter 和 setter 方法的方法名都是属性名，且 setter 方法返回当前对象
   - @Accessors(chain = true)，使用 chain 属性，setter 方法返回当前对象
   - @Accessors(prefix = "tb")，使用 prefix 属性，getter 和 setter 方法会忽视属性名的指定前缀（遵守驼峰命名）
2. @Data，注在类上，提供类的 get、set、equals、hashCode、canEqual、toString 方法
3. @AllArgsConstructor，注在类上，提供类的全参构造
4. @NoArgsConstructor，注在类上，提供类的全参构造
5. @Setter ： 注在属性上，提供 set 方法
6. @Getter ： 注在属性上，提供 get 方法
7. @EqualsAndHashCode ： 注在类上，提供对应的 equals 和 hashCode 方法，默认仅使用该类中定义的属性且不调用父类的方法，通过 callSuper=true，让其生成的方法中调用父类的方法。
8. @Log4j/@Slf4j ： 注在类上，提供对应的 Logger 对象，变量名为 log

## 获取网络 ip、地址信息接口

> http://whois.pconline.com.cn/

1. 太平洋网站
2. 网络 IP 地址查询 Web 接口

## 浏览器解析工具：UserAgentUtils

> 获取浏览器、操作系统等信息

1. 依赖

```xml
<dependency>
    <groupId>eu.bitwalker</groupId>
    <artifactId>UserAgentUtils</artifactId>
</dependency>
```

2. 实例

```java
  String agent = request.getHeader("User-Agent");
  //解析agent字符串
  UserAgent userAgent = UserAgent.parseUserAgentString(agent);
  //获取浏览器对象
  Browser browser = userAgent.getBrowser();
  //获取操作系统对象
  OperatingSystem operatingSystem = userAgent.getOperatingSystem();
  System.out.println("浏览器名:"+browser.getName());
  System.out.println("浏览器类型:"+browser.getBrowserType());
  System.out.println("浏览器家族:"+browser.getGroup());
  System.out.println("浏览器生产厂商:"+browser.getManufacturer());
  System.out.println("浏览器使用的渲染引擎:"+browser.getRenderingEngine());
  System.out.println("浏览器版本:"+userAgent.getBrowserVersion());

  System.out.println("操作系统名:"+operatingSystem.getName());
  System.out.println("访问设备类型:"+operatingSystem.getDeviceType());
  System.out.println("操作系统家族:"+operatingSystem.getGroup());
  System.out.println("操作系统生产厂商:"+operatingSystem.getManufacturer());
```

## 集合框架

```xml
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.4</version>
</dependency>
```

1.  org.apache.commons.collections4.CollectionUtils

- isEmpty 判断集合是否为空
- isNotEmpty 判断集合不为空
- isEqualCollection 比较两集合值是否相等, 不考虑元素的顺序
- union 并集, 不会去除重复元素
- intersection 交集
- 交集的补集
- subtract 差集, 不去重
- unmodifiableCollection 得到一个集合镜像，不允许修改，否则报错
- containsAny 判断两个集合是否有相同元素
- getCardinalityMap 统计集合中各元素出现的次数，并以 Map<Object, Integer>输出
- isSubCollection a 是否 b 的子集合, a 集合大小 <= b 集合大小
- isProperSubCollection a 是否 b 的子集合, a 集合大小 < b 集合大小
- cardinality 某元素在集合中出现的次数
- find 返回集合中满足函数式的唯一元素，只返回最先处理符合条件的唯一元素, 以废弃
- filter 过滤集合中满足函数式的所有元素
- transform 转换新的集合，对集合中元素进行操作，如每个元素都累加 1
- countMatches 返回集合中满足函数式的数量
- select 将满足表达式的元素存入新集合中并返回新集合元素对象
- selectRejected 将不满足表达式的元素存入新集合中并返回新集合元素对象
- collect collect 底层调用的 transform 方法, 将所有元素进行处理，并返回新的集合
- addAll 将一个数组或集合中的元素全部添加到另一个集合中
- get 返回集合中指定下标元素
- isFull 判断集合是否为空
- maxSize 返回集合最大空间
- predicatedCollection 只要集合中元素不满足表达式就抛出异常
- removeAll 删除集合的子集合
- synchronizedCollection 同步集合

2.  org.apache.commons.collections4.MapUtils

- isEmpty 判断 Map 是否为空
- isNotEmpty 判断 Map 是否不为空
- getBoolean 从 Map 中获取 Boolean, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getBooleanValue 从 Map 中获取 boolean, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getDouble 从 Map 中获取 Double, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getDoubleValue 从 Map 中获取 double, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getFloat 从 Map 中获取 Float, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getFloatValue 从 Map 中获取 float, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getInteger 从 Map 中获取 Integer, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getIntegerValue 从 Map 中获取 int, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getLong 从 Map 中获取 Long, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getLongValue 从 Map 中获取 long, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getString 从 Map 中获取 String, 其重载方法有三个参数, 表示如果转换失败则使用默认值
- getMap 获取 Map 类型的值
- putAll 将二维数组放入 Map 中
