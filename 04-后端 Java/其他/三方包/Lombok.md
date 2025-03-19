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


@Builder 和 @SuperBuilder 是常用的注解，用于简化对象构建流程。

- @Builder：Lombok 的经典注解，用于为类生成 Builder 模式。它可以让我们更方便地创建对象，尤其是字段较多时。
- @SuperBuilder：Lombok 引入的增强版，支持子类和父类的 Builder 模式，特别适用于继承结构中构建对象的场景。


@Builder 不能直接用于继承结构
问题：@Builder 不支持继承结构，如果直接在父类和子类上分别使用 @Builder，会导致子类无法正常调用父类的字段，甚至在编译时直接报错。
解决方案：在继承结构中推荐使用 @SuperBuilder，它专门为继承而设计，并能更好地支持父类与子类字段的构建。


@SuperBuilder 不能与 @NoArgsConstructor 直接共存
问题：有时我们需要 @NoArgsConstructor 无参构造函数，但如果直接与 @SuperBuilder 一起使用，会遇到编译冲突，导致构造器生成失败。
解决方案：可以借助 @NoArgsConstructor 的 force 属性，强制生成无参构造函数：

@SuperBuilder 不支持构造器上的自定义逻辑
问题：如果希望在构建对象时进行额外的校验或初始化逻辑（例如计算某些属性），@SuperBuilder 默认生成的构造方法并不会支持这些自定义逻辑。
解决方案：需要在 @SuperBuilder 中使用 @Builder.Default 为字段提供默认值，或者手动添加私有构造器：


@Builder.Default 在 @Builder 和 @SuperBuilder 中的局限
问题：@Builder.Default 是 Lombok 为 Builder 提供的默认值机制，但如果使用 @Builder.Default 来初始化某些字段，@Builder 会生成不必要的重复代码，这会导致不一致的行为。
解决方案：尽量避免在复杂逻辑中依赖 @Builder.Default，如果确实需要默认值，建议直接使用构造函数来初始化，以避免误用。

