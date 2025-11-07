# SSL/TLS

传输层安全性协议（TLS）用于在两个通信应用程序之间提供保密性、数据完整性以及真实性。

该协议由两层组成： TLS 记录协议（TLS Record）和 TLS 握手协议（TLS Handshake）。

## 概念

传输层安全性协议（英语：Transport Layer Security，缩写 TLS）及其前身安全套接层（Secure Sockets Layer，缩写 SSL）是一种安全协议，目的是为互联网通信提供安全及数据完整性保障。网景公司（Netscape）在 1994 年推出首版网页浏览器，网景导航者时，推出 HTTPS 协议，以 SSL 进行加密，这是 SSL 的起源。IETF 将 SSL 进行标准化，1999 年公布第一版 TLS 标准文件。随后又公布 RFC 5246 （2008 年 8 月）与 RFC 6176（2011 年 3 月）。在浏览器、邮箱、即时通信、VoIP、网络传真等应用程序中，广泛支持这个协议。主要的网站，如 Google、Facebook 等也以这个协议来创建安全连线，发送数据。目前已成为互联网上保密通信的工业标准。

在 OSI/RM 七层网络模型中，`SSL/TLS` 协议位于 **传输层**。

## 主要功能

### 加密通信

SSL 通过加密算法（如 AES、RSA 等）对传输的数据进行加密，确保数据在传输过程中即使被截获也无法被解读。

### 身份验证

SSL 的身份认证可以防止中间人攻击，有以下两种形式：

1. 单向认证： 通过数字证书，只验证服务器的身份。

![SSL 单向认证](../images/SSL%20单向认证.png)

2. 双向认证： 通过数字证书，同时验证客户端和服务器身份。

![SSL 双向认证](../images/SSL%20双向认证.png)

### 数据完整性

SSL 通过消息摘要算法（如：SHA-256）确保数据在传输过程中未被篡改。

## 协议版本

- SSL 1.0、SSL 2.0、SSL 3.0 -- 已淘汰。
- TLS 1.0、TLS 1.1、TLS 1.2、TLS 1.3 -- 目前广泛使用。

### SSL 1.0、2.0 和 3.0

1. 1.0 版本从未公开过，因为存在严重的安全漏洞。
2. 2.0 版本在 1995 年 2 月发布，但因为存在数个严重的安全漏洞而被 3.0 版本替代。
3. 3.0 版本在 1996 年发布，是由网景工程师 Paul Kocher、Phil Karlton 和 Alan Freier 完全重新设计的。较新版本的 SSL/TLS 基于 SSL 3.0。SSL 3.0 作为历史文献 IETF 通过 RFC 6101 发表。

2014 年 10 月，Google 发布在 SSL 3.0 中发现设计缺陷，建议禁用此一协议。攻击者可以向 TLS 发送虚假错误提示，然后将安全连接强行降级到过时且不安全的 SSL 3.0，然后就可以利用其中的设计漏洞窃取敏感信息。Google 在自己公司相关产品中陆续禁止回溯兼容，强制使用 TLS 协议。Mozilla 也在 11 月 25 日发布的 Firefox34 中彻底禁用了 SSL 3.0。微软同样发出了安全通告。

### TLS 1.0

IETF 将 SSL 标准化，即 RFC 2246，并将其称为 TLS（Transport Layer Security）。从技术上讲，TLS 1.0 与 SSL 3.0 的差异非常微小。但正如 RFC 所述"the differences between this protocol and SSL 3.0 are not dramatic, but they are significant enough to preclude interoperability between TLS 1.0 and SSL 3.0"（本协议和 SSL 3.0 之间的差异并不是显著，却足以排除 TLS 1.0 和 SSL 3.0 之间的互操作性）。TLS 1.0 包括可以降级到 SSL 3.0 的实现，这削弱了连接的安全性。

### TLS 1.1

TLS 1.1 在 RFC 4346 中定义，于 2006 年 4 月发表，它是 TLS 1.0 的更新。在此版本中的差异包括：

- 添加对 CBC 攻击的保护：
- 隐式 IV 被替换成一个显式的 IV。
- 更改分组密码模式中的填充错误。
- 支持 IANA 登记的参数。

### TLS 1.2

TLS 1.2 在 RFC 5246 中定义，于 2008 年 8 月发表。它基于更早的 TLS 1.1 规范。

### TLS 1.3

TLS 1.3 在 RFC 8446 [2]中定义，于 2018 年 8 月发表。它基于更早的 TLS 1.2 规范。

## 证书分类

> 数字证书：由受信任的证书颁发机构（CA）签发，包含公钥、持有者信息和 CA 的数字签名。

根据证书颁发机构的信任程度分类

1. 受信任证书：由权威的证书颁发机构（CA）颁发，这些机构经过严格的审核和认证流程，被广泛认可和信任。浏览器和操作系统等会预先安装这些权威 CA 的根证书，当客户端访问使用受信任证书的网站时，浏览器能够自动验证证书的合法性，显示安全的连接标识，如绿色锁形图标等。
2. 自签名证书：由网站所有者自行创建和签名，不经过权威 CA 的审核。自签名证书在安全性和信任度上较低，因为客户端无法直接验证其真实性，访问使用自签名证书的网站时，浏览器通常会显示警告信息，提示用户该证书不受信任。

根据证书绑定的域名数量分类

1. 单域名证书：只绑定一个特定的域名，例如 www.example.com，只能用于该指定域名及其子域名（如果有配置），无法用于其他域名。
2. 多域名证书：也称为通配符证书，可绑定一个主域名及其所有子域名。例如，购买了 \*.example.com 的通配符证书，那么可以用于 www.example.com、mail.example.com 等所有以 example.com 为后缀的子域名。
3. SAN 证书（Subject Alternative Name）：可以在一张证书中包含多个不同的域名，这些域名可以是不同的顶级域名或二级域名。例如，一张 SAN 证书可以同时包含 www.example.com、www.anotherdomain.com 等多个不同的域名。

根据证书编码格式分类。

在计算机科学和安全领域，PEM, DER, CRT, CER, KEY 等文件后缀经常出现在证书和密钥文件的命名中。

1. PEM - Privacy Enhanced Mail，打开看文本格式，以"-----BEGIN..."开头，"-----END..."结尾，内容是 BASE64 编码。
2. DER - Distinguished Encoding Rules，打开看是二进制格式，不可读。

相关的文件扩展名

比较误导人的地方，虽然已经知道有 PEM 和 DER 这两种编码格式，但文件扩展名并不一定就叫"PEM"或者"DER"，常见的扩展名除了 PEM 和 DER 还有以下这些，它们除了编码格式可能不同之外，内容也有差别，但大多数都能相互转换编码格式。

- KEY - 通常用来存放一个公钥或者私钥，并非 X.509 证书，编码同样的，可能是 PEM，也可能是 DER。
- CSR - Certificate Signing Request，即证书签名请求，这个并不是证书，而是向权威证书颁发机构获得签名证书的申请，其核心内容是一个公钥（当然还附带了一些别的信息），在生成这个申请的时候，同时也会生成一个私钥，私钥要自己保管好。
- CRT - CRT 应该是 certificate 的三个字母，其实还是证书的意思，有可能是 PEM 编码，也有可能是 DER 编码。大多数应该是 PEM 编码.
- CER - 还是 certificate，还是证书，同样的，可能是 PEM 编码，也可能是 DER 编码。在 Windows 系统中，CER 文件通常是 DER 格式，而在其他系统中可能是 PEM 格式。
- PFX/P12 - Personal Information Exchange/PKCS #12，PFX 和 P12 是 PKCS #12 标准定义的格式，它可以将证书、私钥和证书链封装在一个加密文件中，通常用于 Windows 系统和 IIS 服务器，文件有密码保护。
- JKS - Java Key Storage，Java 平台使用的密钥库格式，用于存储证书和私钥，以二进制形式存储，需要密码保护，Java 应用程序（如 Tomcat）常使用 JKS 来管理证书。利用 "keytool" 工具，可以将 PFX 转为 JKS，当然 keytool 也能直接生成 JKS。

## 自签名证书生成

生成证书标准流程：

1. 生成私钥（.key）
2. 用私钥生成证书请求（.csr）
3. 将证书请求文件(.csr)提交给证书颁发机构（CA），CA 会对提交的证书请求中的所有信息生成一个摘要，然后使用 CA 根证书对应的私钥进行加密，这就是所谓的“签名”操作，完成签名后就会得到真正的签发证书(.cer 或.crt)

标准 CA 签发流程是用 CA 机构的私钥去签名。而自签名证书是用自己的私钥签署自己的证书请求，生成自签名 SSL 证书。

注意：自签名证书不会被浏览器信任，只能用于内部或测试用途。如果你需要一个可被浏览器信任的证书，你需要从受信任的证书颁发机构（CA）获取签名证书。

在实际应用中，有多种工具可用于生成自签名证书，常见的有几种：

- OpenSSL
- mkcert
- Java Keytool
- cfssl

### OpenSSL

官网：https://www.openssl.org/source/

它是一个广泛使用的开源工具包，能提供强大的加密功能和 SSL/TLS 协议支持，可在多种操作系统（如 Linux、Windows、macOS）上使用。

在许多 Linux 发行版中已捆绑 OpenSSL 工具。

**使用示例**

```sh
# 生成一个 2048 位的 RSA 私钥
openssl genrsa -out private.key 2048
# 使用私钥生成对应的公钥
openssl rsa -in private.key -pubout -out public.pub

# 使用私钥来生成新的证书签名请求（.csr）
# -new 表示创建一个新的证书请求；
# -key 表示私钥文件；
# -out 表示输出的CSR文件；
# -subj 是请求中的主题信息，如你的国家、省份、城市、组织名称等，这些信息将包含在你的证书中。/C= 是证书的国家代码，/ST= 是州或省份名称，/L= 是城市名称，/O= 是组织名称，/OU= 是组织单位名称，/CN= 是通用名称，通常是域名，/emailAddress= 是电子邮件地址。
openssl req -new -key private.key -out private.csr -subj "/C=CN/ST=shanghai/L=shanghai/O=example/OU=Web Security/CN=192.168.100.96/CN=domain1"
openssl req -new -key private.key -out privatecsr.pem -subj "/C=CN/ST=shanghai/L=shanghai/O=example/OU=Web Security/CN=192.168.100.96/CN=domain1"

# 生成自签名证书
# openssl x509 -req 表示签名请求，生成证书。
# -days 表示证书的有效期。
# -in private.csr 表示输入的CSR文件名。
# -signkey private.key 表示用于签名的私钥文件名。
# -out private.crt 表示输出的CRT文件名。
openssl x509 -req -days 365 -in privatecsr.pem -signkey private.key -out certificate.pem
openssl x509 -req -days 365 -in private.csr -signkey private.key -out private.crt

# 简化命令：生成私钥（.key） 和证书签名请求（.csr） 用一条命令实现
openssl req -new -newkey rsa:2048 -nodes -keyout private.key -out private.csr -subj "/C=CN/ST=shanghai/L=shanghai/O=example/OU=Web Security/CN=192.168.100.96/CN=domain1"
# 简化命令：生成私钥（.key） 和证书签名请求（.csr） 再生成签名证书（.crt）用一条命令实现
openssl req -x509 -newkey rsa:2048 -nodes -keyout private.key -out private.crt -days 3650  -subj "/C=CN/ST=shanghai/L=shanghai/O=example/OU=Web Security/CN=192.168.100.96/CN=domain1"

# 私有CA签发证书：使用生成自签名证书（ca.crt）和私钥（ca.key）当作私有的CA机构，然后签署其他的证书签名请求，生成私有CA签名的证书
# -in server.csr 表示要处理的CSR文件名为server.csr。
# -CA ca.crt 表示CA的证书文件名为ca.crt。
# -CAkey ca.key 表示CA的私钥文件名为ca.key。
# -CAcreateserial 表示如果CA的证书和私钥不存在，则创建它们。
# -out server.crt 表示生成的服务器证书输出文件名为server.crt。
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 365

# 从证书中提取公钥
openssl x509 -pubkey -noout -in private.crt > public.key

# 查看私钥或公钥
openssl rsa -in private.key -text -noout
openssl rsa -in private.key -text -noout -inform der
# 查看证书签名请求
openssl req -in private.csr -text -noout
openssl req -in private.csr -text -noout -inform der
# 查看证书
openssl x509 -in certificate.pem -text -noout                # PEM 格式
openssl x509 -in certificate.der -text -noout -inform der    # DER 格式

# ~~~~~~~~~~~~~~~~~~~~ PEM 和 DER 相互转换 ~~~~~~~~~~~~~~~~~~~~
# 生成 DER 证书。需要先生成 PEM格式证书，然后将 PEM 转换为 DER 格式。提示：要转换KEY文件也类似，只不过把x509换成rsa，要转CSR的话，把x509换成req
# PEM 转为 DER
openssl x509 -in cert.crt -outform der -out cert.der
# DER 转为 PEM
openssl x509 -in cert.crt -inform der -outform pem -out cert.pem


# ~~~~~~~~~~~~~~~~~~~~ PEM 和 PFX 相互转换 ~~~~~~~~~~~~~~~~~~~~
# PEM 转为 PFX 编码。 也就是将PEM 格式的私钥和证书合并成 PKCS #12 格式的文件。
# -certfile 用于指定包含中间证书的 PEM 文件的路径和文件名。如果没有中间证书，可以省略该参数。
# -name 使用名称作为友好名称。
# -CAfile 用于指定根证书文件的路径。CACert.pem 是 CA(权威证书颁发机构)的根证书。
openssl pkcs12 -export -inkey private.key -in private.crt -out certificate.pfx -name cert-name -certfile intermediate.crt -CAfile rootCA.pem

# PFX 转换为 PEM 编码
# 生成的 PEM 文件确实会包含私钥和证书信息。
openssl pkcs12 -in certificate.pfx -out certificate.pem -nodes
# 从生成的 PEM 文件中提取私钥
openssl pkey -in certificate.pem -out private.key
# 从生成的 PEM 文件中提取证书
openssl x509 -in certificate.pem -out private.crt

```

### Java Keytool

Java 开发工具包（JDK）自带的工具，位于 %JAVA_HOME%\bin\keytool.exe，主要用于管理 Java 密钥库（JKS）和证书。

```sh
# 帮助
keytool
# 帮助，获取 command_name 的用法
keytool -command_name -help

# 生成自签名证书并存储在密钥库中。
# -genkeypair 表示生成一对非对称密钥
# -alias 指定密钥对的别名，该别名是公开的
# -keyalg 指定公钥加密算法，默认是DSA
# -keysize 制定密钥位大小
# -storetype 制定密钥库类型
# -keystore 指定密钥库的路径及名称，不指定的话，默认在操作系统的用户目录下生成一个".keystore"的文件
# -validity 指定有效天数
# -storepass 指定密钥库口令，不加这个参数会在后面要求你输入密码
# -keypass 制定密钥口令。注意：高版本的jdk生成密钥时，不能指定密钥条目的口令，执行时，会忽略keypass并提示，默认的密钥条目的口令和密钥库的口令一致。
keytool -genkeypair -alias mycert -keyalg RSA -keysize 2048 -validity 365 -storetype PKCS12 -keystore keystore.p12 -storepass xxx

# 查看密钥库中的所有证书。-v表示详细输出，-rfc表示以RFC样式输出（可编码方式），两个参数不能同时使用。
keytool -list -v -keystore keystore.p12 -storepass xxx
keytool -list -rfc -keystore keystore.p12
# 删除密钥库中的证书。
keytool -delete -keystore keystore.p12 -alias mycert
# 修改密钥库的口令
keytool -storepasswd -keystore keystore.p12 -storepass xxx -new xxxx
# 修改证书的口令
keytool -keypasswd -alias mycert -keystore keystore.p12

# 导出证书库的证书文件。将名为keystore.p12的证书库中别名为mycert的证书条目导出到证书文件test.crt中
keytool -export -alias mycert -file test.crt -keystore keystore.p12
keytool -exportcert -alias mycert -file test.crt -keystore keystore.p12

# 导入证书文件到证书库。将证书文件test.crt导入到名为keystore.p12的证书库中
keytool -import -alias testcrt -keystore keystore.p12 -file test.crt

# PKCS #12 文件转换成到 JKS
# 【说明】 keytool 的密钥库类型为 JKS 格式时，会收到警告，建议采用行业标准格式 PKCS12。警告原文：Warning: JKS 密钥库使用专用格式。建议使用 "keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.jks -deststoretype pkcs12" 迁移到行业标准格式 PKCS12。
keytool -importkeystore -srckeystore certificate.pfx -srcstoretype PKCS12 -destkeystore keystore.jks -deststoretype JKS
keytool -importkeystore -srckeystore emqx-client.p12 -srcstoretype PKCS12 -destkeystore emqx-client.jks -deststoretype JKS

keytool -importkeystore -srckeystore keystore.jks -destkeystore keystore.jks -deststoretype pkcs12

# 查看证书的信息
keytool -printcert -file test.crt
```

### mkcert

仓库地址：https://github.com/FiloSottile/mkcert

mkcert is a simple tool for making locally-trusted development certificates. It requires no configuration.

mkcert 是一个简单的工具，用于创建本地可信的开发证书。它无需配置。

mkcert 会自动在系统根存储中创建并安装本地 CA，并生成本地可信的证书。但 mkcert 不会自动配置服务器使用这些证书，这需要您自己完成。

mkcert 默认生成的证书格式为 PEM(Privacy Enhanced Mail)格式，任何支持 PEM 格式证书的程序都可以使用。比如常见的 Apache 或 Nginx 等。

windows 系统使用命令：

```sh
# 帮助命令
mkcert-v1.4.4-windows-amd64.exe --help

# 进入 cmd 并切换到exe程序目录下，执行命令。
# 使用此命令，将CA证书加入本地可信CA，使用此命令，就能帮助我们将mkcert使用的根证书加入了本地可信CA中，以后由该CA签发的证书在本地都是可信的。
mkcert-v1.4.4-windows-amd64.exe -install

# 卸载命令。本地CA从系统信任存储中卸载！
mkcert-v1.4.4-windows-amd64.exe -uninstall

# 打印CA证书和密钥存储位置。默认路径：C:\Users\xxx\AppData\Local\mkcert\rootCA.pem
mkcert-v1.4.4-windows-amd64.exe -CAROOT

# 生成自签证书。可供局域网内使用其他主机访问。该命令会生成两个文件example.com+4.pem和example.com+4-key.pem，在web server上使用这两个文件就可以了。
mkcert-v1.4.4-windows-amd64.exe example.com "*.example.com" localhost 127.0.0.1 ::1

# 生成自签名证书。其中 -pkcs12 为
mkcert-v1.4.4-windows-amd64.exe example.com "*.example.com" localhost 127.0.0.1 ::1

# 示例：生成emqx服务端证书。其中 -cert-file 为自定义输出cert证书文件路径和文件名，-key-file 为自定义输出key私钥文件路径和文件名，
mkcert-v1.4.4-windows-amd64.exe -cert-file emqx-servser.pem -key-file emqx-server.key 127.0.0.1 localhost 192.1681.100.99

# 示例：生成客户端证书
mkcert-v1.4.4-windows-amd64.exe -client  -cert-file emqx-client.pem -key-file emqx-client.key 127.0.0.1 localhost 192.1681.100.99
```

### cfssl

CloudFlare 开发的开源工具，用于签名、验证和捆绑 TLS 证书。
