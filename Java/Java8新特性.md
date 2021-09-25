**前言**

新特性包含：

a. 随着大数据的兴起，函数式编程在处理大数据上的优势开始体现，引入了 Lambada 函数式编程

b. 使用 Stream 彻底改变了集合使用方式：只关注结果，不关心过程

c. 新的客户端图形化工具界面库：JavaFX

d. 良好设计的日期/时间 API

e. 增强的并发/并行 API

f. Java 与 JS 交互引擎 -nashorn

g. 其他特性

## 1. 双冒号

**概念**

- :: 表示方法引用，开发者可以直接引用现存的方法、Java 类的构造方法或者实例对象；
- 使用 lambda 表达式会创建一个匿名方法，但有时候使用 lambda 表达式只调用一个已经存在的方法，所有才引入方法引用。

**语法**

构造器引用，语法是 Class::new，或者更一般的形式：Class<T>::new。注意：这个构造器没有参数
静态方法引用,语法是 Class::static_method
某个类的成员方法的引用，语法是 Class::method
某个实例对象的成员方法的引用

- 静态方法引用
- 对象的实例方法引用 System.out::println(); out 是 System 的实例对象，然后引用方法 println
- 对象的超类方法引用
- 类构造器引用语法
- 数组构造器引用语法

## 2. var

1. 概念：

是 jdk10 的新特性，不是关键字，是一种动态类型，用来定义局部变量的

var 变量名 = 初始值；

2. 特点

只能定义局部变量，不能定义成员变量；

3. 使用

new Object().var 快捷键

## 6、验证

```java
// 如果过滤为空，map转换也可以用，而且stream流不会产生null
public static void main(String[] args) {
        List<BasicElectricity> strategyList = new ArrayList<>();
        for (int i = 0; i < 5; i++) {
            BasicElectricity basicElectricity = new BasicElectricity();
            basicElectricity.setBasicElectricity(null);
            strategyList.add(basicElectricity);
        }
        List<String> commondList = strategyList.stream().filter(item -> "6".equals(item.getBasicElectricity())).map(BasicElectricity::getTime).collect(Collectors.toList());
        System.out.println(commondList);
    }
```

## Lambda 表达式

**概念**

1. Lambda 是带有参数变量的表达式，允许将一段代码当成参数传递给某个方法；
   其实就是把匿名内部类中一定要做的工作省略掉，然后由 JVM 通过推导把简化的表达式还原;
   这样可以写出更简洁、更灵活的代码

**格式**
(parameters 参数) -> expression 表达式或方法体

java 刚开始使用匿名内部类代替 Lambda 表达式。

1. -> 用来分隔变量和临时代码块， （变量类型 变量） -> {代码块}，变量如果是可以预知的，就可以省略，如果代码块只有一行表达式，{}省略

2. 可以引用类成员和局部变量，会将这些变量隐式的转换成 final

3. 表达式有返回值，返回值的类型由编译器推理得出。

## stream 流

1. List 转 Map：Collectors.toMap

```java
userList.stream().collect(Collectors.toMap(User::getId, User::getName));
userList.stream().collect(Collectors.toMap(User::getId, t -> t));
userList.stream().collect(Collectors.toMap(User::getId, Function.identity()));
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

2. peek 和 map 区别
   peek 的入参为 Consumer ：Stream<T> peek(Consumer<? super T> action);
   map 的入参为 Function ： <R> Stream<R> map(Function<? super T, ? extends R> mapper);
   peek 和 map 的返回值都是 Stream<T>，peek 无法改变返回值类型，而 map 因为内部入参的原因，是可以改变返回值类型的

3. groupingBy
   - 分组： Map<String, List<Product>> prodMap= prodList.stream().collect(Collectors.groupingBy(Product::getCategory)
   - 组合分组：Map<String, List<Product>> prodMap = prodList.stream().collect(Collectors.groupingBy(item -> item.getCategory() + "\_" + item.getName()));
   - 求总数：Map<String, Long> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.counting()));
   - 求和： Map<String, Integer> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.summingInt(Product::getNum)));
   - 转换类型： Map<String, Product> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.collectingAndThen(Collectors.maxBy(Comparator.comparingInt(Product::getNum)), Optional::get)));
   - 联合其他收集器： Map<String, Set<String>> prodMap = prodList.stream().collect(Collectors.groupingBy(Product::getCategory, Collectors.mapping(Product::getName, Collectors.toSet())));

```java
// forEach
list.stream.forEach(item -> System.out.println(item));
// fifter
list.stream.fifter(item -> !"aa".equals(item)).collect(Collet.toList)
// 去重 distinct  toSet
list.stream.map(**::getXxx).distinct.collect(collect.toList)   // List<T>转List<Object>
// map获取实例中的某个元素，转化为对象的集合
list.stream.map(**::getXx).collect(Collect.toList)
// 单个字段排序 (降序：reversed())
list.sort(Comparator.conparing(**:getXxx))
list.sort((a,b) -> a.getXxx.compareTo(b.getXxx))
// 多个字段排序
thenComparing
// List 转化为map
Map<String, Message> map =
    list.stream().collect(Collectors.toMap(Message :: getMsg, a-> a, (k1, k2) -> k1))
// forEach遍历map
map.forEach((k,v) -> System.out.println(k+v))
// List<T>转Map<String, List<T>>   分组groupingBy
// List<Map<String, Object>>转Map<String, List<Map<String, Object>>>
Map<String, List<Message>> groupByMsg = list.stream().collect(groupingBy(Message::getMsg));
// List求和、求最大值、平均值
Long sum= list.stream().mapToLong(Message::getId).sum();

Optional<Message> maxMassage =
    list.stream().collect(Collectors.maxBy(Comparator.comparing(Message::getId)));
    Long maxId = maxMassage.get().getId();

LongSummaryStatistics lss = list.stream().collect(Collectors.summarizingLong(Message::getId));
System.out.println("sum = " + lss.getSum());
System.out.println("max = " + lss.getMax());
System.out.println("min = " + lss.getMin());
System.out.println("avg = " + lss.getAverage());

Map<Integer, List<Coupon>> resultList = couponList.stream().collect(Collectors.groupingBy(Coupon::getCouponId));

Map<Integer, List<String>> resultList = couponList.stream().collect(Collectors.groupingBy(Coupon::getCouponId,Collectors.mapping(Coupon::getName,Collectors.toList())));
```

## 日期

## 方法引用

## 函数式接口

接口中只有一个抽象方法的接口，使用注解 @FunctionalInterface 修饰的，称为函数式接口
概念：只有一个函数的接口，这样的接口可以隐式转化为 lambda 表达式

常用的接口：**java.lang.Runnable 和 java.util.concurrent.Callable 和 Comparator 接口**

接口中可以定义静态方法

**java.util.Collection**接口添加新方法，如**stream()**、**parallelStream()**、**forEach()**和**removeIf()**等等
