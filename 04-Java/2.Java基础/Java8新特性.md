## 前言

jdk1.8 中新特性包含：

- **Lambda 表达式** 随着大数据的兴起，函数式编程在处理大数据上的优势开始体现，因此引入了 Lambada 函数式编程

- **函数式接口** 函数式接口的提出是为了给 Lambda 表达式的使用提供更好的支持

- **接口中的默认方法和静态方法**

- **方法引用和构造器调用** 若 Lambda 体中的内容有方法已经实现，那么就可以使用方法引用，方法引用再次简化 Lambda 操作

- **Stream API** 使用 Stream 彻底改变了集合使用方式，只关注结果、不关心过程

- **新日期/时间 API** java.time 包下

- 新的客户端图形化工具界面库：JavaFX

- Java 与 JS 交互引擎 -nashorn

- 其他特性

jdk10 中新特性包含：

- **var** 是一种动态类型，用来定义局部变量的

## Lambda 表达式

**概念**

Lambda 是带有参数变量的表达式，允许将一段代码当成参数传递给某个方法；本质上是匿名内部类，java 刚开始使用匿名内部类代替 Lambda 表达式，它其实就是把匿名内部类中一定要做的工作省略掉，然后由 JVM 通过推导把简化的表达式还原，这样可以写出更简洁、更灵活的代码

**格式**

() -> {}

(parameters 参数) -> {expression 表达式或方法体}

**说明**

1. 变量如果是可以预知的，就可以省略；如果只有一个参数，（）可以省略；如果代码块只有一行表达式，{}可以省略；

2. 可以引用类成员和局部变量，但是会将这些变量隐式的转换成 final

> 局部变量限制
>
> Lambda 表达式也允许使用自由变量（不是参数，而是在外层作用域中定义的变量），就像匿名类一样。 它们被称作捕获 Lambda。 Lambda 可以没有限制地捕获（也就是在其主体中引用）实例变量和静态变量。但局部变量必须显式声明为 final，或事实上是 final。
>
> 为什么局部变量有这些限制？
>
> （1）实例变量和局部变量背后的实现有一个关键不同。实例变量都存储在堆中，而局部变量则保存在栈上。如果 Lambda 可以直接访问局部变量，而且 Lambda 是在一个线程中使用的，则使用 Lambda 的线程，可能会在分配该变量的线程将这个变量收回之后，去访问该变量。因此， Java 在访问自由局部变量时，实际上是在访问它的副本，而不是访问原始变量。如果局部变量仅仅赋值一次那就没有什么区别了——因此就有了这个限制。
>
> （2）这一限制不鼓励你使用改变外部变量的典型命令式编程模式。

3. 表达式有返回值，返回值的类型由编译器推理得出。

**举例**

```java
List<String> list =Arrays.asList("aaa","fsa","ser","eere");
// 简化前，使用匿名内部类的方式，重写接口方法；
// 另一种方式：使用思路是设计模式；实现接口重写方法，每次只需要将实现类的实例传入即可，就可以达到不同的验证条件，
Collections.sort(list, new Comparator<String>() {
    @Override
    public int compare(String o1, String o2) {
        return o2.compareTo(o1);
    }
})
// 简化后
Collections.sort(list, (a,b)->b.compareTo(a));

```

## 方法引用

> 使用 lambda 表达式会创建一个匿名方法，但有时候使用 lambda 表达式只调用一个已经存在的方法，因此才引入方法引用，方法引用的用途是支持 Lambda 表达式的简写。

**概念**

方法引用，使用双冒号(::)运算符，目标引用对象放在分隔符::前，方法名称放在后面；开发者可以直接引用现存的方法、Java 类的构造方法或者实例对象；

**分类**

```java
// 静态方法引用
Person[] rosterAsArray = new Person[30];
Arrays.sort(rosterAsArray, Person::compareByAge);

// 构造器引用，Class<T>::new;  需要注意的是这个构造器没有参数，String::new，对应的Lambda：() -> new String()

// 对象的实例方法引用，System.out::println(); out 是 System 的实例对象，然后引用方法 println，类要先实例化
 list.stream().sorted(Comparator.comparing(TestDemo1::getAge)).collect(Collectors.toList());

// 成员方法引用， Class::method，String::valueOf，对应的 Lambda：(s) -> String.valueOf(s)
```

## 函数式接口

当一个接口中存在多个抽象方法时，如果使用 lambda 表达式，并不能智能匹配对应的抽象方法，因此引入了函数式接口的概念。接口中只有一个抽象方法的接口，使用注解 @FunctionalInterface 修饰的，称为函数式接口。

常用的接口：**java.lang.Runnable 和 java.util.concurrent.Callable 和 Comparator 接口**

接口中可以定义静态方法

**java.util.Collection**接口添加新方法，如**stream()、parallelStream()、forEach()和 removeIf()**等等

**常见的四大函数式接口**

Consumer<T> 消费型接口，有参无返回值

Supplier<T> 供给型接口，无参有返回值

Function<T, R> 函数式接口，有参有返回值

Predicate<T> 断言型接口，有参有返回值，返回值是 boolean 类型

## Stream 流

**概念**

流是 Java API 的新成员，它允许我们以声明性方式处理数据集合（通过查询语句来表达，而不是临时编写一个实现）。Stream 不是集合元素，它不是数据结构并不保存数据，它是有关算法和计算的，我们可以把它们看成遍历数据集的高级迭代器。单向，不可往复，数据只能遍历一次，遍历过一次后即用尽了，就好比流水从面前流过，一去不复返。而和迭代器又不同的是，Stream 可以透明地并行化操作，也就是说我们不用写多线程代码了。迭代器只能命令式地、串行化操作。顾名思义，当使用串行方式去遍历时，每个 item 读完后再读下一个 item。而使用并行去遍历时，数据会被分成多个段，其中每一个都在不同的线程中处理，然后将结果一起输出。Stream 的并行操作依赖于 Java7 中引入的 Fork/Join 框架（JSR166y）来拆分任务和加速处理过程。

#### 构造流的几种方式

```java
// 1. Individual values
Stream stream = Stream.of("a", "b", "c");
// 2. Arrays
String [] strArray = new String[] {"a", "b", "c"};
stream = Stream.of(strArray);
stream = Arrays.stream(strArray);
// 3. Collections
List<String> list = Arrays.asList(strArray);
stream = list.stream();
```

#### 常用 api

```java
// forEach
list.stream.forEach(item -> System.out.println(item));
map.forEach((k,v) -> System.out.println(k+v))   // forEach遍历map
// fifter
list.stream.fifter(item -> !"aa".equals(item)).collect(Collet.toList)
// 去重 distinct  toSet
list.stream.map(**::getXxx).distinct.collect(collect.toList)
// map获取实例中的某个元素，转化为对象的集合
list.stream.map(**::getXx).collect(Collect.toList)
// 单个字段排序 (降序：reversed())
list.sort((a,b) -> a.getXxx.compareTo(b.getXxx))
list.sort(Comparator.conparing(**:getXxx))
// 多个字段排序
thenComparing

// List<Map<String, Object>>转Map<String, List<Map<String, Object>>>
Map<String, List<Message>> groupByMsg = list.stream().collect(groupingBy(Message::getMsg));
// List求和、求最大值、平均值
Long sum= list.stream().mapToLong(Message::getId).sum();

Optional<Message> maxMassage = list.stream().collect(Collectors.maxBy(Comparator.comparing(Message::getId)));
Long maxId = maxMassage.get().getId();
LongSummaryStatistics lss = list.stream().collect(Collectors.summarizingLong(Message::getId));
```

#### Collectors.toMap （List 转 Map）

```java
Map<Long, String> map = userList.stream().collect(Collectors.toMap(User::getId, User::getName));
Map<Long, User> userMap = userList.stream().collect(Collectors.toMap(User::getId, t -> t));
Map<Long, User> userMap = userList.stream().collect(Collectors.toMap(User::getId, Function.identity()));
// Collectors.toMap 有三个重载方法：
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper);
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper,
        BinaryOperator<U> mergeFunction);
toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper,
        BinaryOperator<U> mergeFunction, Supplier<M> mapSupplier);
// 参数含义分别是：
// keyMapper：Key 的映射函数
// valueMapper：Value 的映射函数
// mergeFunction：当 Key 冲突时，调用的合并方法
// mapSupplier：Map 构造器，在需要返回特定的 Map 时使用，比如希望返回的 Map 是根据 Key 排序的
userList.stream().collect(Collectors.toMap(User::getId, User::getName, (n1, n2) -> n1 + n2));
```

#### peek 和 map 区别

peek 的入参为 Consumer ：Stream<T> peek(Consumer<? super T> action);

map 的入参为 Function ： <R> Stream<R> map(Function<? super T, ? extends R> mapper);

peek 和 map 的返回值都是 Stream<T>，peek 无法改变返回值类型，而 map 因为内部入参的原因，是可以改变返回值类型的

#### groupingBy （List 转 Map）

```java
// 分组
Map<String, List<Product>> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory);
Map<Integer, List<String>> resultList = couponList.stream().collect(Collectors.groupingBy(Coupon::getCouponId,Collectors.mapping(Coupon::getName,Collectors.toList())));
// 组合分组
Map<String, List<Product>> prodMap = prodList.stream().collect(Collectors.groupingBy(item -> item.getCategory() + "\_" + item.getName()));
// 求总数
Map<String, Long> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.counting()));
// 求和
Map<String, Integer> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.summingInt(Product::getNum)));
// 转换类型
Map<String, Product> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.collectingAndThen(Collectors.maxBy(Comparator.comparingInt(Product::getNum)), Optional::get)));
// 联合其他收集器
Map<String, Set<String>> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.mapping(Product::getName, Collectors.toSet())));
```

#### anyMatch，allMatch，noneMatch

```java
long count();   // 返回的都是这个集合流的元素的长度

boolean anyMatch(Predicate<? super T> predicate);        // anyMatch表示，判断的条件里，任意一个元素成功，返回true

boolean allMatch(Predicate<? super T> predicate);       // allMatch表示，判断条件里的元素，所有的都是，返回true

boolean noneMatch(Predicate<? super T> predicate);      // noneMatch跟allMatch相反，判断条件里的元素，所有的都不是，返回true

// 特殊：当list的为空集合时候，这个返回默认为true；
List<String> list = new ArrayList<>();
boolean allMatch = list.stream().allMatch(e -> "a".equals(e));
```

#### 问题汇总

```java
// 如果过滤为空，map转换也可以用，而且stream流不会产生null
List<String> commondList = strategyList.stream().filter(item -> "6".equals(item.getBasicElectricity())).map(BasicElectricity::getTime).collect(Collectors.toList());
}
```

## 日期时间

> `UTC(世界标准时间)`
>
> 协调世界时，又称世界标准时间或世界协调时间，简称 UTC（从英文“Coordinated Universal Time”／法文“Temps Universel Coordonné”而来），是最主要的世界时间标准，其以原子时秒长为基础，在时刻上尽量接近于格林尼治标准时间。
>
> `GMT(格林尼治平均时间)`
>
> 格林尼治平均时间（格林尼治标准时间），旧译格林威治标准时间；英语：Greenwich Mean Time，GMT）是指位于英国伦敦郊区的皇家格林尼治天文台的标准时间，因为本初子午线被定义在通过那里的经线。
> 理论上来说，格林尼治标准时间的正午是指当太阳横穿格林尼治子午线时（也就是在格林尼治上空最高点时）的时间。由于地球在它的椭圆轨道里的运动速度不均匀，这个时刻可能与实际的太阳时有误差，最大误差达 16 分钟。
> 由于地球每天的自转是有些不规则的，而且正在缓慢减速，因此格林尼治时间已经不再被作为标准时间使用。现在的标准时间，是由原子钟报时的协调世界时（UTC）。
>
> `CST(北京时间)`
>
> 北京时间，China Standard Time，中国标准时间。在时区划分上，属东八区，比协调世界时早 8 小时，记为 UTC+8。

`Java 默认使用的是 UTC 时间`

**新日期时间的优点**

1. 之前使用的 java.util.Date 类，月份是从 0 开始，所以处理时都会＋ 1；而 java.time.LocalDate 月份和星期都改成了 enum；
2. Date 和 SimpleDateFormat 都不是线程安全的；而 LocalDate 和 LocalTime 都是不可变类，不但线程安全，还不能修改；
3. Date 包含日前、时间、毫秒数，需要根据需求取舍，而新 API 更好用的原因是考虑到了日期时间的操作，比如经常发生往前推或往后推几天的情况，用 Date 配合 Calendar 要写好多代码。

**常用的类**

1. **LocalDate**
2. **LocalTime**
3. **LocalDateTime**
4. **DateTimeFormatter** 格式化
5. **Instant** 绝对时间，用于时间戳转换，在 Date 与 LocalDate、LocalDateTime 转换中，可以通过 Instant 作为中间类完成转换
6. **TemporalAdjuster** 函数式接口，只提供了一个方法，用于调整 Temporal 对象的策略，在日期调整时非常有用；比如得到当月的第一天、最后一天，当年的第一天、最后一天，下一周或前一周的某天等。
7. **TemporalAdjusters** TemporalAdjuster 对应的工具类，提供了现成的方法
8. **Period** 表示一段时间的年月日，Period 基于日期值，而 Duration 基于时间值
9. **Duration** 表示两个 Instant 间的一段时间

```java
// 1. 时间戳
Instant now = Instant.now();     // 默认使用的是UTC时间Clock.systemUTC().instant()，与北京时间相差8个时区
Instant now = Instant.now().plusMillis(TimeUnit.HOURS.toMillis(8));  // 转换成北京时间
long seconds = now.getEpochSecond();    // 获取秒数（10位）
long timestamp = now.toEpochMilli();    // 获取毫秒数（13位）
LocalDateTime datetime = LocalDateTime.ofInstant(instant1, ZoneId.of("UTC+8"));   // 转换成LocalDateTime对象
// 2. LocalDateTime
LocalDateTime datetime = LocalDateTime.now();   // LocalDate、LocalDateTime 的now()方法使用的是系统默认时区（UTC+8），也就是当前时间
Instant instant = datetime.atZone(ZoneId.systemDefault()).toInstant(); // 转换为UTC时间的Instant对象
Instant instant = datetime.atZone(ZoneId.of("UTC+8")).toInstant(); // 转换为当前时间的Instant对象
Instant instant = datetime.toInstant(ZoneOffset.ofHours(0)); // 转换为当前时间的Instant对象
// 3. Date 与LocalDateTime转换
Date date = new Date();
Instant instant = date.toInstant();
LocalDateTime datetime = LocalDateTime.ofInstant(instant, ZoneId.of("UTC+8"));   // 转换成LocalDateTime对象
// 4. LocalDate、LocalTime方法和LocalDateTime差不多，包括创建、加、减、比较（之前、等于、之后）...

/*  1. now 相关的方法可以获取当前日期或时间
    2. of 方法可以创建对应的日期或时间
    3. parse 方法可以解析日期或时间
    4. get 方法可以获取日期或时间信息
    5. with 方法可以设置日期或时间信息
    6. plus 或 minus 方法可以增减日期或时间信息*/

// 5. DateTimeFormatter 格式化
DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
LocalDateTime datetime = LocalDateTime.now();
String format = dateFormatter.format(datetime);
String datetime = "2011-01-01 23:23:12";
LocalDateTime parse = LocalDateTime.parse(datetime, dateFormatter);
```

## var

1. 概念

   - 是 jdk10 的新特性，不是关键字，而是一种动态类型，只能用来定义局部变量，不能定义成员变量。

2. 使用

   - var 变量名 = 初始值
   - new 对象().var + 快捷键，可以快速创建一个对象实例
