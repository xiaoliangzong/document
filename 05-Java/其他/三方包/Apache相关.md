



## 4. Apache 工具类

### commons-lang3

```java
// 常用工具类
StringUtils.isBlank(null);
SystemUtils.getUserName();
ArrayUtils.contains(null,null);
```

### commons-fileupload

```java
// 文件操作类
FileUploadException 异常处理类
```

### commons-io

```java
// IO操作类
IOUtils.close(null);
IOUtils.toByteArray((InputStream) null);
```

### commons-collections4

```xml
<!-- 集合操作类 -->
<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.4</version>
</dependency>
```

**CollectionUtils**

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

**MapUtils**

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
