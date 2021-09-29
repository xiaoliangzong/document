# 基础知识总结

## 1. 拦截器、过滤器、AOP

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

## 2. 深拷贝和浅拷贝

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

## 3. String.format()

```s
转换符	详细说明	示例
%s	字符串类型	“喜欢请收藏”
%c	字符类型	‘m’
%b	布尔类型	true
%d	整数类型（十进制）	88
%x	整数类型（十六进制）	FF
%o	整数类型（八进制）	77
%f	浮点类型	8.888
%a	十六进制浮点类型	FF.35AE
%e	指数类型	9.38e+5
%g	通用浮点类型（f和e类型中较短的）	不举例(基本用不到)
%h	散列码	不举例(基本用不到)
%%	百分比类型	％(%特殊字符%%才能显示%)
%n	换行符	不举例(基本用不到)
%tx	日期与时间类型（x代表不同的日期与时间转换符)	不举例(基本用不到)
```

## 4. 保留小数（四舍五入）

```java
// 保留几位小数
double d =123.12345678845242;
String format = String.format("%.2f", d);       String.format("%02d", number)
System.out.println("方式1：" + format);
// 方式二
DecimalFormat df = new DecimalFormat("#.00");
String format1 = df.format(d);
System.out.println("方式2：" + format1);
// 方式三
BigDecimal bigDecimal = BigDecimal.valueOf(d);
BigDecimal bigDecimal1 = bigDecimal.setScale(2, BigDecimal.ROUND_HALF_UP);
System.out.println("方式3：" + bigDecimal1);
// 方式四
NumberFormat numberInstance = NumberFormat.getNumberInstance();
numberInstance.setMaximumFractionDigits(2);
String format2 = numberInstance.format(d);
System.out.println("方式4：" + format2);
// 方式五
通过乘除来取值
// Math.round()
```

## 5. 废弃注解

@Deprecated 表示此方法已废弃、暂时可用，但以后此类或方法都不会再更新、后期可能会删除，建议后来人不要调用此方法
可以作用到类、方法、属性上

## 6. BigDecimal

```java
// 1. 两数相除异常：java.lang.ArithmeticException: Non-terminating decimal expansion; no exact representable decimal result.
// 分析根因：BigDecimal是不可变的，任意精度的有符号十进制数。可以做精确计算
// 解决办法：divide有重载方法，可以传入 MathContext 对象或 RoundingMode 对象，指定精度和舍入模式
// 两个参数（Bigdecimal，舍入模式）
// 三个参数（Bigdecimal，指定精度，舍入模式）
// 常用的舍入模式有BigDecimal.HALE_UP
```

## 7. 测试分类

- 单元测试 UT：测试的最小功能单元，
- 集成测试（Integration Test）：通过组合代码单元和测试单元来检验其组合结果是否正确，
- 功能测试 （Fuctional Test）：功能测试用户检查特定的功能是否正常

## 8. 删除表中重复元素

方法一：delete from tt where id in (select \* from (select max(id) from tt group by name having count(name)>1) as b );

方法二：delete s1 from tt as s1 left join (select \* from tt group by name having count(name)>1)as s2 on s1.name = s2.name where s1.id>s2.id;

## 9. 端口占用

```sh
# 查看端口
netstat -ano | findstr port
# 查询PID对应的进程
tasklist | findstr pid
# 杀死进程
taskkill /f /pid 值
```

# 二、接口和抽象类

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

### 命令

1.  骆驼拼写法（CamelCase）

    - 大驼峰：CamelCase
    - 小驼峰：camelCase

2.  蛇形命名法（snake case）
    - 下划线将单词链接：file_name

# 自定义异常

## 1.说明：

在后台编写业务逻辑时，可能会遇到异常捕获并抛出处理的情况，基本上来说只需要使用 try-catch 来判断即可，遇到一些比较复杂的逻辑，try-catch 还是很有必要的，但是如果只是简单的异常要阻断当前流程并返回相应的信息，业务比较多的系统的话，自定义一个抛出异常工具类可以减少相应代码量，方便后期维护完善。

后端通常会通过 throw 出一个异常对象，前端再将接收到的异常对象 code 和 message 进行二次判断

## 2.使用步骤

### 2.1 自定义异常继承 RunTimeException

```java
@Data
public class BaseException extends RuntimeException
{
private static final long serialVersionUID = 1L;

/**
 * 所属模块
 */
private String module;

/**
 * 错误码
 */
private String code;

/**
 * 错误码对应的参数
 */
private Object[] args;

/**
 * 错误消息
 */
private String defaultMessage;

public BaseException(String module, String code, Object[] args, String defaultMessage)
{
    this.module = module;
    this.code = code;
    this.args = args;
    this.defaultMessage = defaultMessage;
}

public BaseException(String module, String code, Object[] args)
{
    this(module, code, args, null);
}

public BaseException(String module, String defaultMessage)
{
    this(module, null, null, defaultMessage);
}

public BaseException(String code, Object[] args)
{
    this(null, code, args, null);
}

public BaseException(String defaultMessage)
{
    this(null, null, null, defaultMessage);
}

@Override
public String getMessage()
{
    String message = null;
    if (!StringUtils.isEmpty(code))
    {
        message = MessageUtils.message(code, args);
    }
    if (message == null)
    {
        message = defaultMessage;
    }
    return message;
}
}
```

### 2.2 自定义异常处理类，方便对各种类型的异常进行封装对象，并返回

@RestControllerAdvice 和@ControllerAdvice
@RestControllerAdvice 注解包含了@ControllerAdvice 注解和@ResponseBody 注解
当自定义类加注解@RestControllerAdvice 或 ControllerAdvice 和 RequestBody 时，方法返回 json 数据。

```java
/**
* 全局异常处理器
*
* @author ruoyi
*/
@RestControllerAdvice
public class GlobalExceptionHandler
{
private static final Logger log = LoggerFactory.getLogger(GlobalExceptionHandler.class);

/**
 * 基础异常
 */
@ExceptionHandler(BaseException.class)
public AjaxResult baseException(BaseException e)
{
    return AjaxResult.error(e.getMessage());
}

/**
 * 业务异常
 */
@ExceptionHandler(CustomException.class)
public AjaxResult businessException(CustomException e)
{
    if (StringUtils.isNull(e.getCode()))
    {
        return AjaxResult.error(e.getMessage());
    }
    return AjaxResult.error(e.getCode(), e.getMessage());
}

@ExceptionHandler(NoHandlerFoundException.class)
public AjaxResult handlerNoFoundException(Exception e)
{
    log.error(e.getMessage(), e);
    return AjaxResult.error(HttpStatus.NOT_FOUND, "路径不存在，请检查路径是否正确");
}

@ExceptionHandler(AccessDeniedException.class)
public AjaxResult handleAuthorizationException(AccessDeniedException e)
{
    log.error(e.getMessage());
    return AjaxResult.error(HttpStatus.FORBIDDEN, "没有权限，请联系管理员授权");
}

@ExceptionHandler(AccountExpiredException.class)
public AjaxResult handleAccountExpiredException(AccountExpiredException e)
{
    log.error(e.getMessage(), e);
    return AjaxResult.error(e.getMessage());
}

@ExceptionHandler(UsernameNotFoundException.class)
public AjaxResult handleUsernameNotFoundException(UsernameNotFoundException e)
{
    log.error(e.getMessage(), e);
    return AjaxResult.error(e.getMessage());
}

@ExceptionHandler(Exception.class)
public AjaxResult handleException(Exception e)
{
    log.error(e.getMessage(), e);
    return AjaxResult.error(e.getMessage());
}

/**
 * 自定义验证异常
 */
@ExceptionHandler(BindException.class)
public AjaxResult validatedBindException(BindException e)
{
    log.error(e.getMessage(), e);
    String message = e.getAllErrors().get(0).getDefaultMessage();
    return AjaxResult.error(message);
}

/**
 * 自定义验证异常
 */
@ExceptionHandler(MethodArgumentNotValidException.class)
public Object validExceptionHandler(MethodArgumentNotValidException e)
{
    log.error(e.getMessage(), e);
    String message = e.getBindingResult().getFieldError().getDefaultMessage();
    return AjaxResult.error(message);
}
}
```

# 读取文件的几种方式

## InputStream 读取二进制文件，包括图片、文件、声音、影像等

```java
public static void readFileByBytes(String fileName) {
    File file = new File(fileName);
    InputStream in = null;
    try {
        System.out.println("以字节为单位读取文件内容，一次读一个字节：");
        // 一次读一个字节
        in = new FileInputStream(file);
        int tempbyte;
        while ((tempbyte = in.read()) != -1) {
            System.out.write(tempbyte);
        }
        in.close();
    } catch (IOException e) {
        e.printStackTrace();
        return;
    }
    try {
        System.out.println("以字节为单位读取文件内容，一次读多个字节：");
        // 一次读多个字节
        byte[] tempbytes = new byte[100];
        int byteread = 0;
        in = new FileInputStream(fileName);
        ReadFromFile.showAvailableBytes(in);
        // 读入多个字节到字节数组中，byteread为一次读入的字节数
        while ((byteread = in.read(tempbytes)) != -1) {
            System.out.write(tempbytes, 0, byteread);
        }
    } catch (Exception e1) {
        e1.printStackTrace();
    } finally {
        if (in != null) {
            try {
                in.close();
            } catch (IOException e1) {
            }
        }
    }
}
/**
    * 显示输入流中还剩的字节数
    */
private static void showAvailableBytes(InputStream in) {
    try {
        System.out.println("当前字节输入流中的字节数为:" + in.available());
    } catch (IOException e) {
        e.printStackTrace();
    }
}
```

## Reader 读取文件

```java
public static void readFileByChars(String fileName) {
    File file = new File(fileName);
    Reader reader = null;
    try {
        System.out.println("以字符为单位读取文件内容，一次读一个字节：");
        // 一次读一个字符
        reader = new InputStreamReader(new FileInputStream(file));
        int tempchar;
        while ((tempchar = reader.read()) != -1) {
            // 对于windows下，\r\n这两个字符在一起时，表示一个换行。
            // 但如果这两个字符分开显示时，会换两次行。
            // 因此，屏蔽掉\r，或者屏蔽\n。否则，将会多出很多空行。
            if (((char) tempchar) != '\r') {
                System.out.print((char) tempchar);
            }
        }
        reader.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
    try {
        System.out.println("以字符为单位读取文件内容，一次读多个字节：");
        // 一次读多个字符
        char[] tempchars = new char[30];
        int charread = 0;
        reader = new InputStreamReader(new FileInputStream(fileName));
        // 读入多个字符到字符数组中，charread为一次读取字符数
        while ((charread = reader.read(tempchars)) != -1) {
            // 同样屏蔽掉\r不显示
            if ((charread == tempchars.length)
                    && (tempchars[tempchars.length - 1] != '\r')) {
                System.out.print(tempchars);
            } else {
                for (int i = 0; i < charread; i++) {
                    if (tempchars[i] == '\r') {
                        continue;
                    } else {
                        System.out.print(tempchars[i]);
                    }
                }
            }
        }

    } catch (Exception e1) {
        e1.printStackTrace();
    } finally {
        if (reader != null) {
            try {
                reader.close();
            } catch (IOException e1) {
            }
        }
    }
}
```

## 行为单位读取文件，常用于读面向行的格式化文件

```java
public static void readFileByLines(String fileName) {
    File file = new File(fileName);
    BufferedReader reader = null;
    try {
        System.out.println("以行为单位读取文件内容，一次读一整行：");
        reader = new BufferedReader(new FileReader(file));
        String tempString = null;
        int line = 1;
        // 一次读入一行，直到读入null为文件结束
        while ((tempString = reader.readLine()) != null) {
            // 显示行号
            System.out.println("line " + line + ": " + tempString);
            line++;
        }
        reader.close();
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if (reader != null) {
            try {
                reader.close();
            } catch (IOException e1) {
            }
        }
    }
}
```

## 随机读取文件内容

```java
public static void readFileByRandomAccess(String fileName) {
    RandomAccessFile randomFile = null;
    try {
        System.out.println("随机读取一段文件内容：");
        // 打开一个随机访问文件流，按只读方式
        randomFile = new RandomAccessFile(fileName, "r");
        // 文件长度，字节数
        long fileLength = randomFile.length();
        // 读文件的起始位置
        int beginIndex = (fileLength > 4) ? 4 : 0;
        // 将读文件的开始位置移到beginIndex位置。
        randomFile.seek(beginIndex);
        byte[] bytes = new byte[10];
        int byteread = 0;
        // 一次读10个字节，如果文件内容不足10个字节，则读剩下的字节。
        // 将一次读取的字节数赋给byteread
        while ((byteread = randomFile.read(bytes)) != -1) {
            System.out.write(bytes, 0, byteread);
        }
    } catch (IOException e) {
        e.printStackTrace();
    } finally {
        if (randomFile != null) {
            try {
                randomFile.close();
            } catch (IOException e1) {
            }
        }
    }
}
```

# 网络 URL 获取文件、图片

```java
URL url = new URL(path);
HttpURLConnection httpURLConnection = (HttpURLConnection) url.openConnection();
httpURLConnection.setConnectTimeout(1000*5);
//设置请求方式，默认是GET
httpURLConnection.setRequestMethod("GET");
// 设置字符编码
httpURLConnection.setRequestProperty("Charset", "UTF-8");
httpURLConnection.connect();
// 文件大小
int fileLength = httpURLConnection.getContentLength();
// 控制台打印文件大小
System.out.println("您要下载的文件大小为:" + fileLength / (1024 * 1024) + "MB");

BufferedInputStream bis = new BufferedInputStream(httpURLConnection.getInputStream());
// 指定文件名称(有需求可以自定义)
String fileFullName = "aaa.json";
// 指定存放位置(有需求可以自定义)
String savePath = "excel_template" + File.separatorChar + fileFullName;
file = new File(savePath);
// 校验文件夹目录是否存在，不存在就创建一个目录
if (!file.getParentFile().exists()) {
    file.getParentFile().mkdirs();
}
OutputStream out = new FileOutputStream(file);
int size = 0;
int len = 0;
byte[] buf = new byte[2048];
while ((size = bis.read(buf)) != -1) {
    len += size;
    out.write(buf, 0, size);
    // 控制台打印文件下载的百分比情况
    System.out.println("下载了-------> " + len * 100 / fileLength + "%\n");
}
// 关闭资源
bis.close();
out.close();
System.out.println("文件下载成功！");
```

## 13. CollectionUtils 工具类

> `取交集intersection、并集union、差集subtract、补集disjunction、`

<dependency>
    <groupId>org.apache.commons</groupId>
    <artifactId>commons-collections4</artifactId>
    <version>4.3</version>
</dependency>
