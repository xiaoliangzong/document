## 1. Lombok

`IntelliJ IDEA 使用时，必须安装插件！`

1.  @Accessors 注解：链式编程
    - @Accessors(fluent = true)，使用 fluent 属性，getter 和 setter 方法的方法名都是属性名，且 setter 方法返回当前对象
    - @Accessors(chain = true)，使用 chain 属性，setter 方法返回当前对象
    - @Accessors(prefix = "tb")，使用 prefix 属性，getter 和 setter 方法会忽视属性名的指定前缀（遵守驼峰命名）
2.  @Data，注在类上，提供类的 get、set、equals、hashCode、canEqual、toString 方法
3.  @AllArgsConstructor，注在类上，提供类的全参构造
4.  @NoArgsConstructor，注在类上，提供类的全参构造
5.  @Setter ： 注在属性上，提供 set 方法
6.  @Getter ： 注在属性上，提供 get 方法
7.  @EqualsAndHashCode ： 注在类上，提供对应的 equals 和 hashCode 方法，默认仅使用该类中定义的属性且不调用父类的方法，通过 callSuper=true，让其生成的方法中调用父类的方法。
8.  @Log4j/@Slf4j ： 注在类上，提供对应的 Logger 对象，变量名为 log
9.  @RequiredArgsConstructor : 替代@Autowired，注入时使用 final 修饰或@NotNull 注解

**注意点**

当使用@Data 注解时，则有了@EqualsAndHashCode 注解，那么就会在此类中存在 equals(Object other) 和 hashCode()方法，且不会使用父类的属性；如果有多个类有相同的部分属性，把它们定义到父类中，那么就会存在部分对象在比较时，它们并不相等，却因为 lombok 自动生成的 equals(Object other) 和 hashCode()方法判定为相等，从而导致出错。

解决方案：

1.  使用@Getter @Setter @ToString 代替@Data 并且自定义 equals(Object other) 和 hashCode()方法，比如有些类只需要判断主键 id 是否相等即足矣。
2.  或者使用在使用@Data 时同时加上@EqualsAndHashCode(callSuper=true)注解。