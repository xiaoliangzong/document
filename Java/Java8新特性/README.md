# java8 新特性

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
// mapSupplier：Map 构造器，在需要返回特定的 Map 时使用
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
