# JVM 调优

JDK 本身提供了很多方便的 JVM 性能调优监控工具，除了集成式的 VisualVM 和 jConsole 外，还有 jps、jstack、jmap、jhat、jstat 等小巧的工具，另外还有一些商业性的工具，如 JProfiler 等，相对于这些集成性的工具，在资源消耗方面会比较大，有时候一些线上临时性的需要抓取线程信息和堆信息的情况，这些集成性的工具使用起来就显得不“那么强大和好用了”，这个时候，反而一些简单的命令，可以帮我们解决燃眉之急，也非常简单好用。

| 工具      | 全称                                            | 说明                                                                                                                      |
| --------- | ----------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------- |
| jps       | Java Virtual Machine Process Status Tool        | 查看 Java 进程，相当于 Linux 下的 ps 命令，只不过它只列出 Java 进程。                                                     |
| jinfo     | Java Configuration Info                         | 查看正在运行的 Java 程序的扩展参数，甚至支持修改运行过程中的部分参数。                                                    |
| jstat     | Java Virtual Machine Statistics Monitoring Tool | 查看 Java 程序运行时相关信息。 主要用来监控堆的内存和 GC 详细信息，便于优化堆内存的分配。                                 |
| jmap      | Java Memory Map                                 | 生成 JVM 堆转储快照、查看对象分布及类加载器信息。堆转储快照可用于后续的内存分析，找出内存泄漏等问题，一般结合 jhat 使用。 |
| jhat      | Java Heap Analysis Tool                         | 分析 Java 堆转储快照文件                                                                                                  |
| jstack    | Java Stack Trace                                | 生成 Java 虚拟机当前时刻的线程快照（thread dump），可以查看线程的状态、调用栈信息等，帮助分析线程死锁、阻塞等问题。       |
| jcmd      | Java Command                                    | 多功能的工具。可以执行多种 JVM 诊断命令，如生成堆转储、线程转储、查看系统属性等。                                         |
| Jconsole  |                                                 | 可视化的监控工具。监控 Java 应用程序的性能和资源使用情况                                                                  |
| JVisualVM |                                                 | 可视化工具。除了具备 JConsole 的监控功能外，还能进行性能分析、内存分析、线程分析等。                                      |
| MAT       | Memory Analyzer Tool                            | Java 堆内存分析工具。用于深入分析堆转储文件，找出内存泄漏的原因、定位大对象等。                                           |

## jps

jps（Java Virtual Machine Process Status Tool） 进程状态工具，可以查看 Java 进程，相当于 Linux 下的 ps 命令，只不过它只列出 Java 进程。

常用命令：

```bash
jps                  # 列出Jav程序ID和Main函数名称
jps -q               # 只输出进程ID
jps -m               # 输出传递给Java进程（主函数）的参数
jps -l               # 输出主函数的完整路径
jps -v               # 显示传递给Java虚拟的参数
```

## jstat

jstat（Java Virtual Machine Statistics Monitoring Tool）统计监控工具，可以查看 Java 程序运行时相关信息。主要用来监控堆的内存和 GC 详细信息，便于优化堆内存的分配。

命令格式：

```bash
jstat -<options> [-t] [-h<lines>] <vmid> [<interva1>I count>]]
```

参数说明：

- option: 操作参数，经常使用的选项有 gc、gcutil 等。
- t: 时间戳
- h: 标题行的样本数，也就是相隔多少条，需要打印标题。
- vmid: java 进程 ID
- interval: 间隔时间，单位为毫秒
- count: 打印次数

option 参数说明：

| 参数              | 说明                                                               |
| ----------------- | ------------------------------------------------------------------ |
| -class            | class loader 的行为统计                                            |
| -compiler         | HotSpot JIT 编译器行为统计                                         |
| -gc               | 垃圾回收堆的行为统计                                               |
| -gccapacity       | 各个垃圾回收代容量（young、old、perm）和他们相应的空间统计         |
| -gccause          | 垃圾收集器概述，同时显示最后一次或当前正在发生的垃圾收集的诱发原因 |
| -gcmetacapacity   | 元数据区行为统计                                                   |
| -gcnew            | 新生代行为统计                                                     |
| -gcnewcapacity    | 新生代与其相应的内存空间的统计                                     |
| -gcold            | 老年代和永久代行为统计                                             |
| -gcoldcapacity    | 老年代行为统计                                                     |
| -gcutil           | 垃圾回收统计概述                                                   |
| -printcompilation | HotSpot 编译方法统计                                               |

常用命令：

```bash
# 查看进程内存区域及GC详细信息
# S0C：年轻代中第一个survivor（幸存区）的容量(单位kb)
# S1C：年轻代中第二个survivor（幸存区）的容量(单位kb)
# S0U：年轻代中第一个survivor(幸存区）目前已使用空间(单位kb)
# S1U：年轻代中第二个survivor（幸存区）目前已使用空间(单位kb)
# EC：年轻代中Eden的容量(单位kb)
# EU：年轻代中Eden目前己使用空间(单位kb)
# OC：old代的容量(单位kb)
# OU：old代目前已使用空间(单位kb)
# MC：方法区大小(元空间)的容量（单位kb)
# MU：方法区大小(元空间)目前已使用空间(单位kb)
# CCSC:压缩类空间大小
# CCSU:压缩类空间使用大小
# YGC：从应用程序启动到采样时年轻代中gc次数
# YGCT：从应用程序启动到采样时年轻代中gc所用时间(s)
# FGC：从应用程序启动到采样时o1d代(全gc)gc次数
# FGCT：从应用程序启动到采样时old代(全gc)gc所用时间(s)
# GCT：从应用程序启动到采样时gc用的总时间(s)
jstat -gc <pid> 1 5

# 进程内存区域百分百及GC详细信息
# S0：幸存1区当前使用比例
# S1：幸存2区当前使用比例
# E：伊甸园区使用比例
# O：老年代使用比例
# M：元数据区使用比例
# CCS：压缩使用比例
# YGC：年轻代垃圾回收次数
# FGC：老年代垃圾回收次数
# FGCT：老年代垃圾回收消耗时间
# GCT：垃圾回收消耗总时间
jstat -gcutil <pid> 1 5

# 堆内存统计
# NGCMN：新生代最小容量
# NGCMX：新生代最大容量
# NGC：当前新生代容量
# S0C：第一个幸存区大小
# S1C：第二个幸存区的大小
# EC：伊甸园区的大小
# OGCMN：老年代最小容量
# OGCMX：老年代最大容量
# OGC：当前老年代大小
# OC:当前老年代大小
# MCMN:最小元数据容量
# MCMX：最大元数据容量
# MC：当前元数据空间大小
# CCSMN：最小压缩类空间大小
# CCSMX：最大压缩类空间大小
# CCSC：当前压缩类空间大小
# YGC：年轻代gc次数
# FGC：老年代GC次数
jstat -gccapacity <pid>
```

## jinfo

jinfo（Java Configuration Info），可以查看正在运行的 Java 程序的扩展参数，甚至支持修改运行过程中的部分参数。

命令格式：

```bash
jinfo [option] <pid>
```

option 参数说明：

- -flag <name> 输出指定虚拟机 VM 参数
- -flag [+|-]<name> 打开或关闭虚拟机参数
- -flag <name>=<value> 设置指定虚拟机参数的值
- -flags 输出虚拟机 VM 参数
- -sysprops 输出 Java 系统变量
- <no option> 输出以上信息，也就是虚拟机 VM 参数和 Java 系统变量

常用命令：

```bash
jinfo -flags <pid>               # 查看JVM参数，包括JVM版本、JVM 非默认属性值、命令行参数
jinfo -flag MaxHeapSize <pid>    # 查看最大堆内存
jinfo <pid>                      # 查看虚拟机 VM 参数和 Java 系统变量
```

## jmap

jmap（Java Memory Map），内存分析工具，可以生成 JVM 堆转储快照、查看对象分布及类加载器信息。堆转储快照可用于后续的内存分析，找出内存泄漏等问题，一般结合 jhat、jvisualvm、MAT 使用。

命令格式：

```bash
jmap [option] <pid>
```

option 参数说明：

- <none> 不加选项，和 Solaris pmap 的输出是一样的。
- -heap 显示堆内存分配及使用情况。
- -histo[:live] 输出 java 堆中对象的统计信息，如果指定了 live 子选项，则只计算活动的对象。
- -clstats 统计类加载器元数据。
- -finalizerinfo 查看等待 Finalizer 线程执行的对象队列，也就是输出等待最终确定的对象的信息。
- -dump:<dump-options> 以 hprof 二进制格式转储 java 堆，dump-options 选项包括：

  - live 如果不指定，堆中的所有对象都被转储。
  - format=b 二进制。
  - file=<file> 指定导出的文件。

- -F 强制，与-dump 一起使用：<dump-options><pid> 或 -histor 在<pid]没有响应时强制堆转储或直方图。此模式不支持“实时”子选项。
- -J<flag> 将 <flag> 直接传递给运行时系统。

```bash
jmap <pid>                  # 显示进程的内存映像信息，包括目标虚拟机中加载的每个共享对象的起始地址、映射大小以及共享对象文件的路径全称。
jmap -heap <pid>            # 显示Java堆摘要信息，包括堆配置信息、各内存区域内存使用信息
jmap -histo:live <pid>      # 显示堆中对象的统计信息，包括每个Java类、对象数量、内存大小(单位：字节)、完全限定的类名。打印的虚拟机内部的类名称将会带有一个’*’前缀。
jmap -finalizerinfo <pid>   # 等待回收的对象数量

# 显示类加载器信息
# 异常的类加载器数量增加 → Metaspace泄露
# 非系统类加载器（如自定义ClassLoader）持续驻留 → 代码问题
jmap -clstats <pid>         # 对于每个类加载器而言，它的名称、活跃度、地址、父类加载器、它所加载的类的数量和大小都会被打印。此外，包含的字符串数量和大小也会被打印。

# 生成堆转储快照（heap dump）
# 以二进制格式转储 Java 堆到指定文件中。如果指定了 live 子选项，堆中只有活动的对象会被转储。浏览 heap dump 可以使用 jhat 读取生成的文件，也可以使用 MAT 等堆内存分析工具。
# 注意：这个命令执行，JVM会将整个heap的信息dump写入到一个文件，heap如果比较大的话，就会导致这个过程比较耗时，并且执行的过程中为了保证dump的信息是可靠的，所以会暂停应用，线上系统慎用！
jmap -dump:format=b,file=heapdump.hprof <pid>             # 二进制文件，使用 .hprof 更符合 Java 生态惯例（如 MAT / VisualVM 默认识别），但工具实际通过文件内容（非后缀）判断格式。
jmap -dump:live,format=b,file=heap.bin <pid>              # 二进制文件，使用 .bin 表示二进制文件。live 会触发Full GC，生产环境慎用。
```

## jhat

jhat（Java Heap Analysis Tool），可以解析 Java 堆转储文件，并启动一个 web server。然后用浏览器来查看浏览 dump 出来的 heap 二进制文件。

jhat 命令支持预先设计的查询，比如：显示某个类的所有实例。还支持 对象查询语言（OQL）。 OQL 有点类似 SQL，专门用来查询堆转储。

Java 生成堆转储的方式有多种:

1. 使用 jmap -dump 选项可以在 JVM 运行时获取 dump。
2. 使用 jconsole 选项通过 HotSpotDiagnosticMXBean 从运行时获得堆转储。
3. 在虚拟机启动时如果指定了 -XX:+HeapDumpOnOutOfMemoryError 选项，则抛出 OutOfMemoryError 时，会自动执行堆转储。

命令格式:

```bash
jhat [options] heap-dump-file
```

## jstack

jstack（Java Stack Trace）线程堆栈分析工具，用于生成 java 虚拟机当前时刻的线程快照。

线程快照是当前 Java 虚拟机内每一条线程正在执行的方法堆栈的集合，生成线程快照的主要目的是定位线程出现长时间停顿的原因，如线程间死锁、死循环、请求外部资源导致的长时间等待、等等。

Jstack 的输出中，Java 线程状态主要是以下几种：

- RUNNABLE 线程运行中或 I/O 等待
- BLOCKED 线程在等待 monitor 锁(synchronized 关键字)
- TIMED_WAITING 线程在等待唤醒，但设置了时限
- WAITING 线程在无限等待唤醒

命令格式：

```bash
jstack [option] <pid>                                      # 查看当前时间点，指定进程的 dump 堆栈信息。
jstack [option] <pid> > file.txt                           # 将当前时间点的指定进程的 dump 堆栈信息，写入到指定文件中。

jstack [option] executable core                            # 查看当前时间点，core 文件的 dump 堆栈信息。
jstack [option] [server_id@]<remote server IP or hostname> # 查看当前时间点，远程机器的 dump 堆栈信息。
```

option 参数说明：

- -F 当进程挂起了，此时'jstack [-l] pid'是没有响应的，这时候可使用此参数来强制打印堆栈信息，强制 jstack，一般情况不需要使用。
- -m 打印 java 和 native c/c++框架的所有栈信息。可以打印 JVM 的堆栈，以及 Native 的栈帧，一般应用排查不需要使用。
- -l 长列表. 打印关于锁的附加信息。例如属于 java.util.concurrent 的 ownable synchronizers 列表，会使得 JVM 停顿得长久得多（可能会差很多倍，比如普通的 jstack 可能几毫秒和一次 GC 没区别，加了-l 就是近一秒的时间），-l 建议不要用。一般情况不需要使用。

常用命令：

```bash
jstack <pid>                                              # 打印堆栈
jstack <pid> > jvm_stack_info.txt                         # 将堆栈输出到文件中查看
jstack -l <pid>                                           # 查看线程堆栈信息
jstack -l <pid> | grep 'java.lang.Thread.State' | wc -l   # 统计线程数
```

常见场景说明：

1. 死锁分析

```
"Thread-3" #23 prio=5 os_prio=0 tid=0x00007ff3fc0e8000 nid=0x1ae3 waiting for monitor entry [0x00007ff3eb7f7000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at com.DeadLock$2.run(DeadLock.java:40)
        - waiting to lock <0x000000076b352678> (a java.lang.Object)

"Thread-4" #24 prio=5 os_prio=0 tid=0x00007ff3fc0eb000 nid=0x1ae4 waiting for monitor entry [0x00007ff3eb6f6000]
   java.lang.Thread.State: BLOCKED (on object monitor)
        at com.DeadLock$1.run(DeadLock.java:25)
        - waiting to lock <0x000000076b352688> (a java.lang.Object)
        - locked <0x000000076b352678> (a java.lang.Object)
```

2. CPU 高负载分析

```
"worker-thread-5" daemon prio=10 tid=0x00007f44a40c3000 nid=0x1b02 runnable [0x00007f449bdfe000]
   java.lang.Thread.State: RUNNABLE
        at java.util.regex.Pattern$GroupHead.match(Pattern.java:4769)
        at java.util.regex.Pattern$Loop.match(Pattern.java:4900)
        at java.util.regex.Pattern$GroupTail.match(Pattern.java:4829)
        at java.util.regex.Matcher.match(Matcher.java:1273)
```

## jcmd

jmd（Java Command）是一个多功能的工具，相比 jstat 功能更为全面的工具，可用于获取目标 Java 进程的性能统计、JFR、内存使用、垃圾收集、线程堆栈、JVM 运行时间，也可以手动执行 GC、导出线程信息、导出堆信息等信息。

```bash
jcmd -h                              # 帮助
jcmd <pid> help                      # 帮助。列出当前运行的 java 进程可以执行的操作。不同的 jvm 进程 支持的操作可能是不一样的。
jcmd <pid> help <command>            # 帮助。列出当前运行的 java 进程执行命令的说明。

jcmd -l                              # 查看所有的进程列表信息，作用和 jcmd、jcmd -lm 命令相同。

jcmd <pid> GC.heap_info              # 查看 JVM 内存信息，虽然名称为 heap_info，但是除了堆内存信息，也会有堆外内存之外的 Metaspace 的信息。相比 jstat 命令结果会更直观一些。
jcmd <pid> PerfCounter.print         # 查看指定进程的性能统计信息。
jcmd <pid> GC.class_histogram        # 查看系统中类统计信息，可以查看每个类的实例数量和占用空间大小。作用和 jmap -histo <pid> 命令相同。
jcmd <pid> GC.heap_dump FILE_NAME    # 导出内存 Dump 文件。作用和 jmap -dump:format=b,file=heapdump.phrof pid 命令相同。
jcmd <pid> Thread.print              # 查看线程堆栈信息。作用和 jstack -l 命令相同。
jcmd <pid> VM.uptime                 # 查看已启动时长，作用和 ps -p <pid> -o etime 命令相同。
jcmd <pid> VM.system_properties      # 查看 JVM 系统属性。作用和 jinfo -sysprops <pid> 作用相同。
jcmd <pid> VM.flags                  # 查看 JVM 启动参数。作用和 jinfo -flags <pid> 作用相同。
jcmd <pid> VM.command_line           # 查看 JVM 启动命令行
jcmd <pid> VM.version                # 查看目标 jvm 进程的版本信息。
jcmd <pid> GC.run_finalization       # 对 JVM 执行 java.lang.System.runFinalization()。即 ：执行一次 finalization 操作
jcmd <pid> GC.run                    # 对 JVM 执行 java.lang.System.gc()。同 GC.run_finalization 告诉垃圾收集器打算进行垃圾收集，但是 JVM 可以选择执行或者不执行。
jcmd <pid> VM.native_memory          # 查看目标 jvm 进程的 Native Memory Tracking (NMT) 信息，用于追踪 JVM 的内部内存使用。
jcmd <pid> VM.native_memory summary  # 查看堆和非堆内存


# 查看堆内存详情
jcmd <pid> VM.flags | findstr MaxHeapSize
jcmd <pid> VM.flags | grep MaxHeapSize
```

## JConsole

JConsole 可视化监控和管理工具，它可以帮助开发者监控 Java 应用程序的运行时情况，包括内存使用、线程、类加载器、VM 状态等。

## JVisualVM

JVisualVM 性能监控和诊断工具，它不仅能分析和诊断堆转储文件，在线实时监控本地 JVM 进程，还能监控远程服务器上的 JVM 进程。

在 JVirtualVM 中线程有以下几种状态：

- 运行（runnable）：正在运行中的线程。
- 休眠（timed_waiting）：休眠线程，例如调用 Thread.sleep 方法。
- 等待（waiting）：等待唤醒的线程，可通过调用 Object.wait 方法获得这种状态，**底层实现是基于对象头中的 monitor 对象**。
- 驻留（waiting）：等待唤醒的线程，和等待状态类似，只不过底层的实现方式不同，处于这种状态的例子有线程池中的空闲线程，等待获取 reentrantLock 锁的线程，调用了 reentrantLock 的 condition 的 await 方法的线程等等，**底层实现是基于 Unsafe 类的 park 方法**，在 AQS 中有大量的应用。
- 监视（blocked）：等待获取 monitor 锁的线程，例如等待进入 synchronize 代码块的线程。

Visual GC 插件，用于查看垃圾回收的具体情况。Java VisualVm 默认是没有 Visual GC 的，需要自己安装，点击工具-->插件，在可用插件的 tab 页中选择安装 Visual GC。

Visual GC 整个区域分为三部分：spaces、graphs、histogram

1. spaces 区域：代表虚拟机内存分布情况，每个区域用不同颜色表示占用空间和剩余空间，程序运行时动态显示各分区动态情况。

   - Metaspace（方法区，JDK8 之后改用元空间来实现），通过 VM Args:-XX:PermSize=128m -XX:MaxPermSize=256m 设置初始值与最大值。
   - heap：java 堆(java heap)。它包括老年代(Old 区域)和新生代(Eden/S0/S1 三个统称新生代，分为 Eden 区和两个 Survivor 区域)，他们默认是 8:1 分配内存通过 VM Args:-xms512m -Xmx512m -XX:+HeapDumpOnOutofMemoryError -Xmn100m -XX:SurvivorRatio=8 设置初始堆内存、最大堆内存、内存异常打印 dump、新生代内存、新生代内存分配比例(8:1:1)，因为 Heap 分为新生代跟老年代，所以 512M-100M=412M，老年代就是 412M(初始内存跟最大内存最好相等，防止内存不够时扩充内存或者 Full GC，导致性能降低)

2. Graphs 区域：内存使用详细介绍

   - Compile Time(编译时间)：6368compiles 表示编译总数，4.407s 表示编译累计时间。一个脉冲表示一次 JIT 编译，窄脉冲表示持续时间短，宽脉冲表示持续时间长。
   - Class Loader Time(类加载时间): 20869loaded 表示加载类数量, 139 unloaded 表示卸载的类数量，40.630s 表示类加载花费的时间
   - GC Time(GC Time)：2392collections 表示垃圾收集的总次数，37.454s 表示垃圾收集花费的时间，last cause 表示最近垃圾收集的原因
   - Eden Space(Eden 区)：括号内的 31.500M 表示最大容量，9.750M 表示当前容量，后面的 4.362M 表示当前使用情况，2313collections 表示垃圾收集次数，8.458s 表示垃圾收集花费时间
   - Survivor 0/Survivor 1(S0 和 S1 区)：括号内的 3.938M 表示最大容量，1.188M 表示当前容量，之后的值是当前使用情况
   - Old Gen(老年代)：括号内的 472.625M 表示最大容量，145.031M 表示当前容量，之后的 87.031 表示当前使用情况，79collections 表示垃圾收集次数 ，28.996s 表示垃圾收集花费时间
   - Perm Gen(永久代)：括号内的 256.000M 表示最大容量，105.250M 表示当前容量，之后的 105.032M 表示当前使用情况

3. Histogram 区域：survivor 区域参数跟年龄柱状图

   - Tenuring Threshold：表示新生代年龄大于当前值则进入老年代
   - Max Tenuring Threshold：表示新生代最大年龄值。
   - Tenuring Threshold 与 Max Tenuring Threshold 区别：Max Tenuring Threshold 是一个最大限定，所有的新生代年龄都不能超过当前值，而 Tenuring Threshold 是个动态计算出来的临时值，一般情况与 Max Tenuring Threshold 相等，如果在 Suivivor 空间中，相同年龄所有对象大小的总和大于 Survivor 空间的一半，则年龄大于或者等于该年龄的对象就都可以直接进入老年代(如果计算出来年龄段是 5，则 Tenuring Threshold=5，age>=5 的 Suivivor 对象都符合要求)，它才是新生代是否进入老年代判断的依据。
   - Desired Survivor Size：Survivor 空间大小验证阙值(默认是 survivor 空间的一半)，用于 Tenuring Threshold 判断对象是否提前进入老年代。
   - Current Survivor Size：当前 survivor 空间大小
   - histogram 柱状图：表示年龄段对象的存储柱状图
   - 如果显示指定-XX:+UseParallelGC --新生代并行、老年代串行收集器 ，则 histogram 柱状图不支持当前收集器

## MAT

MAT (Memory Analyzer Tool ) 工具是一款功能强大的 Java 堆内存分析器。可以用于查找内存泄露以及查看内存消耗情况。

MAT 是基于 Eclipse 开发的，不仅仅可以单独使用，还可以作为插件的形式内嵌在 Eclipse 中使用。如果单独使用，那么解压即可用，不需要安装。

下载地址：https://eclipse.dev/mat/download/previous/

说明：高版本的 MAT，需要 JDK17 才能使用。修改 MemoryAnalyzer.ini 中 -vm 配置

```
-vm
E:\Program Files\Java\jdk-17\bin\javaw.exe
```

使用：

1. 从进程中生成 dump 文件快照。
2. 打开已经生成好的 hprof 文件。
3. 直接从活动的 Java 程序中导出堆快照。这个功能借助于 jps 列出当前正在运行的 Java 进程, 生成 dump 文件快照。

## JVM 调优参数

-Xmx 设置堆的最大可用大小，默认物理内存的 1/4
-Xms 设置堆的初始可用大小，默认物理内存的 1/64
-Xmn 新生代大小

## JVM 调优分析

### 1. CPU 高负载分析

定位步骤：

1. 先用 top 定位高 CPU 进程
2. 使用 top -Hp <pid> 定位具体线程
3. 使用 printf "%x\n" <线程 ID> 转换线程 ID 为 16 进制
4. 使用 jstack 查找对应线程，分析线程状态

### 2. 自动化采集

```bash
#!/bin/bash

PID=$(jps | grep MyApp | awk '{print $1}')
for i in {1..5}; do
    jstack -l $PID > thread_dump_$(date +%H%M%S).log
    sleep 2
done
```

### 3. 综合分析

1. 先用 top 定位高 CPU 线程。
2. 使用 jstack 分析线程状态。
3. 用 jstat 检查 GC 情况。
4. 用 jmap 分析内存使用，配合 jhat、jvisualvm、MAT 工具一同使用。
