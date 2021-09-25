新特性包含：

a.随着大数据的兴起，函数式编程在处理大数据上的优势开始体现，引入了 Lambada 函数式编程

b.使用 Stream 彻底改变了集合使用方式：只关注结果，不关心过程

c.新的客户端图形化工具界面库：JavaFX

d.良好设计的日期/时间 API

e.增强的并发/并行 API

f.Java 与 JS 交互引擎 -nashorn

g.其他特性

## Lambda 表达式

**概念**

1. Lambda 是带有参数变量的表达式，允许将一段代码当成参数传递给某个方法；
   其实就是把匿名内部类中一定要做的工作省略掉，然后由 JVM 通过推导把简化的表达式还原;
   这样可以写出更简洁、更灵活的代码

**格式**
(parameters 参数) -> expression 表达式或方法体

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

## 日期

## 方法引用

## 函数式接口

接口中只有一个抽象方法的接口，使用注解 @FunctionalInterface 修饰的，称为函数式接口
