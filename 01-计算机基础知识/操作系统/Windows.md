## windows 命令

```bash
echo %java_home%
echo %path%

cls                         # 清空屏幕


tasklist                    # 用来显示运行在本地或远程计算机上的所有进程的命令行工具，带有多个执行参数。


```


## 安装包区别

MSI 和 EXE 都是 Windows 上常见的安装包格式，它们有一些区别和特点。


MSI（Microsoft Installer）：

MSI 是一种 Microsoft Windows Installer 技术创建的软件安装包格式。
MSI 文件是一种数据库文件，其中包含了安装程序的所有相关信息，包括文件、注册表项、服务等。这些信息可以通过 Windows Installer 来进行管理和安装。
MSI 可以支持自定义安装选项和卸载选项，允许管理员对软件进行集中管理。

EXE（Executable）：

EXE 是 Windows 上可执行程序的一般扩展名，也用于安装包。
EXE 安装包实际上是一个自解压的压缩文件，其中包含了安装所需的文件和脚本。执行该文件会启动安装过程并解压文件到指定位置，并执行必要的设置步骤。

MSI 格式的安装包更适合企业环境和系统管理员进行软件部署和管理，而 EXE 格式的安装包则更加灵活，可以包含自解压的压缩文件和自定义的安装逻辑。