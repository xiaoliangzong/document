# Web

## 1. Web 前端三剑客

| 三剑客     | 说明   | 备注                       |
| ---------- | ------ | -------------------------- |
| HTML       | 结构层 | 从语义的角度，描述页面结构 |
| CSS        | 样式层 | 从审美的角度，美化页面     |
| JavaScript | 行为层 | 从交互的角度，提升用户体验 |

## 2. 跨域

跨域是指浏览器不能执行其他网站的脚本，它是由浏览器的同源策略（所谓同源是指域名、协议、端口均相同）造成的，是浏览器对 JavaScript 施加的安全限制。当协议、域名、端口号，有一个或多个不同时，前端请求后端服务器接口的情况称为跨域访问。

localhost 和 127.0.0.1 虽然都指向本机，但也属于跨域

同源策略限制

- 无法读取非同源网页的 Cookie、LocalStorage 和 IndexedDB
- 无法接触非同源网页的 DOM
- 无法向非同源地址发送 AJAX 请求

跨域理解的误区

1.  误区： 同源策略限制下，访问不到后台服务器的数据，或访问到后台服务器的数据后没有返回；
2.  正确： 同源策略限制下，可以访问到后台服务器的数据，后台服务器会正常返回数据，而被浏览器给拦截了。

解决方式

- 前端安装 Nginx，设置 http 请求转发，这样可以绕过浏览器跨域警告
- CORS 解决跨域

java 后端实现 CORS 跨越请求的方式

1. 创建新的 CorsFilter Bean 对象
2. 重写 WebMvcConfigurer 接口，实现 addCorsMappings()方法
3. 使用注解 @CrossOrigin
4. 手动设置响应头 (HttpServletResponse)
5. 自定义 web filter 实现

前两种方式属于全局 CORS 配置，后两种属于局部 CORS 配置。如果使用了局部跨域是会覆盖全局跨域的规则，所以可以通过 @CrossOrigin 注解来进行细粒度更高的跨域资源控制。

FilterRegistrationBean 是 Spring Framework 提供的一个类，用于注册和配置 Filter 的工具类。通过 FilterRegistrationBean 实例注册，该方法能够设置过滤器之间的优先级。

## 3. Cookie、Session

cookie 和 session 都是用来跟踪浏览器用户身份的会话方式

1. cookie 失效
   - 如果不在浏览器中设置过期时间，cookie 被保存在内存中，生命周期随浏览器的关闭而结束，这种 cookie 简称会话 cookie；
   - 如果在浏览器中设置了 cookie 的过期时间，cookie 被保存在硬盘中，关闭浏览器后，cookie 数据仍然存在，直到过期时间结束才消失。
2. session 使用场景

   - **登录：** 当第一次登录时，客户端会携带用户密码等信息进行登录，如果登录成功，服务器会创建新的 session 对象，并把 sessionid 在本次响应中返回给客户端，客户端下次访问时，只需要携带 sessionid 就可以请求其他资源。
   - **游客访问：** 当客户端请求中没有 sessionid，服务器会创建新的 session 对象，并把 sessionid 在本次响应中返回给客户端。

3. Session 实现
   - session 是保存在服务器端的，sessionid 需要保存在客户端，通常使用 cookie 方式存储 sessionid 到客户端，在交互中浏览器按照规则将 sessionid 发送给服务器。当浏览器支持 Cookie 时，url 不做任何处理；如果用户禁用 cookie，则要使用 URL 重写，可以通过 response.encodeURL(url) 进行实现；将 SessionID 拼接到访问地址后。
4. Cookie 实现

   - Cookie 是服务器发给客户端的特殊信息，可以只使用 Cookie 实现登录认证等功能

5. 区别

   - 保持状态：cookie 保存在浏览器端（客户端），而 session 保存在服务器端
   - 存储内容：cookie 只能保存字符串类型，以文本的方式；session 通过类似与 Hashtable 的数据结构来保存，能支持任何类型的对象(session 中可含有多个对象)
   - 存储大小：单个 cookie 保存的数据不能超过 4kb；session 大小没有限制。
   - 安全性：针对 cookie 所存在的攻击：Cookie 欺骗，Cookie 截获；session 的安全性大于 cookie
   - 缺点：cookie 大小受限、用户可以禁用，使功能受限、安全性低、每次访问都要传 cookie 给服务器，浪费带宽；session 保存的东西越多，占用服务器内存越大、依赖于 cookie、过度使用导致代码不可读不好维护。

## 4. WebStorage

WebStorage 是 HTML5 新增的存储数据的方案，比使用 cookie 更加直观。它提供了访问特定域名下的会话存储或本地存储的功能，如果是会话存储，则使用 sessionStorage，如果是本地存储(硬盘)，则使用 localStorage。

它并不是为了取代 cookie 而制定的标准，cookie 作为 HTTP 协议的一部分用来处理客户端和服务器通信是不可或缺的。WebStorage 的意图在于解决本来不应该 cookie 做，却不得不用 cookie 的本地存储。WebStorage 存储数据大小一般都是 5MB；保存在客户端，不与服务器进行交互通信；只能存储字符串类型，对于复杂的对象可以使用 ECMAScript 提供的 JSON 对象的 stringify 和 parse 来处理

localStorage 和 sessionStorage 都以键值对（key、value）的形式存储。注意: 这不是 javaScript 语言本身的特性，是 BOM 的东西。

- setItem (key, value) —— 保存数据，以键值对的方式储存信息。
- getItem (key) —— 获取数据，将键值传入，即可获取到对应的 value 值。
- removeItem (key) —— 删除单个数据，根据键值移除对应的信息。
- clear () —— 删除所有的数据
- key (index) —— 获取某个索引的 key

1. sessionStorage

   - 将数据保存在 session 对象中，
   - 临时保存
   - 获取方式：window.sessionStorage
   - 常用于敏感账号一次性登录；

2. localStorage
   - 将数据保存在客户端本地的硬件设备，即使浏览器关闭了，该数据仍然存在，下次打开浏览器访问网站时可以继续使用
   - 永久保存，除非主动删除，否则数据永远不会消失
   - 获取方式：window.localStorage
   - 常用于长期登录（判断用户是否已登录），适合长期保存在本地的数据

## 5. Node.js

Node.js 是一个免费、开源、跨平台的 JavaScript 运行时环境，它让开发人员能够创建服务器、Web 应用、命令行工具和脚本。

Node.js 发布于 2009 年 5 月，由 Ryan Dahl 开发，是一个基于 Chrome V8 引擎的 JavaScript 运行环境，使用了一个事件驱动、非阻塞式 I/O 模型， 让 JavaScript 运行在服务端的开发平台，它让 JavaScript 成为与 PHP、Python、Perl、Ruby 等服务端语言平起平坐的脚本语言。

它相当于 java 体系中对应的 jdk。

NPM 的全称是 Node Package Manager，是一个 NodeJS 包管理和分发工具，已经成为了非官方的发布 Node 模块（包）的标准。 [1]

### 5.1 Node 可以做什么

1. 开发桌面应用程序
2. 开发服务器应用程序

## 6. 前端构建工具

在浏览器支持 ES 模块之前，JavaScript 并没有提供原生机制让开发者以模块化的方式进行开发。这也正是我们对 “打包” 这个概念熟悉的原因：使用工具抓取、处理并将我们的源码模块串联成可以在浏览器中运行的文件。

使用模块化开发主要面临两个问题：

1. 浏览器兼容性问题，
2. 模块化过多时，加载问题。

使用构建工具，对代码进行打包，将多个模块打包成一个文件。这样一来及解决了兼容性问题，又解决了模块过多的问题。

### 6.1 Webpack

使用 Webpack 打包项目时，会把相关的资源(代码、样式等)生成多个 bundle 文件，再在 HTML 中通过 `<script>` 标签引入这些 budle 文件进行程序接下来的运行。当代码越来越多的时候，需要打包的模块也越来越多，Webpack 得找所有相关的依赖图，这个过程意味着消耗更多的时间。

webpack 适用于大型，复杂的项目，它可以处理多种不同类型的文件，并根据需求进行解析、编译和打包。webpack 唯一不好的就是配置比较复杂，需要花费一定的时间和精力进行学习和调试。

它相当于 maven 中工程自动化。

### 6.2 ESBuild

Go 语言编写的快速、轻量级的 JavaScript/TypeScript 构建工具，比以 JavaScript 编写的打包器预构建依赖快 10-100 倍。适用于需要高性能构建的场景。

### 6.3 Rollup

主要用于打包 JavaScript 模块，支持 ES 模块和插件。生成的打包文件较小，适合构建库和组件。

### 6.4 Vite

Vite 基于浏览器原生 ES 模块的原生支持，通过服务端渲染和快速构建的方式实现快速启动项目和即时热更新，主要用于开发阶段快速启动项目和实现即时热更新。

在本地能更快的根本原因，是借用了浏览器原生 ESM 能力，从而跳过了生成 bundle 的时间，再加上能够不依赖第三方插件将编译结果缓存，而且 esbuild 自身的也有着更快的运行速度，从而实现了 Vite 快速的冷启动。

本地启动一个 Vite 项目时，Server 在一开始的时候就启动，而不是找到所有依赖打完包再启动。Vite 启动后再去加载对应的文件，主要有一下的特点：

- 基于浏览器原生 ES 模块的支持
- 即时编译（Instant Compilation）
- esbuild 预构建依赖

Vite 适合于小型项目或者需要快速原型开发的场景，提供了更加优秀的开发体验和性能。

在生产环境下，Webpack 和 Vite 的打包，构建时间就没有这么大的区别了，因为在生产环境下 Vite 仍需要通过 Rollup 将代码打包。主要是基于以下几点考虑：

1. 兼容性：尽管现代浏览器对 ESM 模块有很好的支持，但在生产环境中仍然需要考虑到旧版浏览器的兼容性。为了确保应用在所有浏览器中都能正常运行，需要将 ESM 模块转换成兼容性更好的 JavaScript 代码，通常是通过打包工具进行转换和优化。
2. 性能优化：在生产环境中，需要对代码进行一些性能优化，如代码压缩、合并、分割等，以减小代码体积、加快页面加载速度。通过打包工具，可以将多个模块合并成一个或多个 bundle，并对代码进行压缩和混淆，以减小文件体积。
3. 资源管理：除了 JavaScript 代码外，现代的前端应用还包含许多其他类型的资源，如样式表、图片、字体等。打包工具可以帮助管理这些资源，将它们进行优化、压缩，并生成适当的 URL 地址，以便在生产环境中有效地加载和使用这些资源。
4. 部署和发布：在生产环境中，需要将应用部署到服务器上，并且通常会对代码进行一些配置和优化。通过打包工具，可以方便地生成部署所需的静态文件，并进行一些配置，如路径设置、缓存控制等，以便于部署和发布应用。

## 7. 前端包管理工具

### 7.1 npm

npm（Node Package Manager）用于管理 JavaScript 项目的依赖包，提供包的安装、更新和管理功能。

它相当于 maven 中的包依赖管理；

主要用途：

- 管理各种 JavaScript 库、工具和插件，如 React、Lodash 等。
- 管理 Node.js 的库和工具，例如 Express、Mongoose 等。
- 管理前端构建工具、开发工具和其他资源，例如打包工具（如 Webpack、Rollup）、任务运行器（如 Gulp、Grunt）、CSS 预处理器等。
- 安装命令行工具，例如 Create React App、Angular CLI、Vue CLI 等。

安装详解：

- nodeJs 中包含 npm，安装 node.js 就会自动安装 npm
- 更新 npm，node 自带的 npm 不是最新版本，需要更新：npm install -g npm
- 安装完之后，重写设置淘宝镜像：npm config set registry "https://registry.npmmirror.com"
- 安装 vue-cli：npm install vue-cli -g
- 检查 vue-cli 安装是否成功：vue list
- 卸载 vue-cli：npm uninstall -g vue-cli
- 查看版本：vue -V
- 安装 3.x 以上版本：npm install -g @vue/cli（保证 node 版本>=8.9，npm 更新最新）
- 查看所有版本号：npm view vue-cli versions --json
- npm install webpack -g
- npm install webpack-cli -g
- 检查安装是否成功：webpack -v

### 7.2 yarn

yarn 是由 Facebook、Google、Exponent 和 Tilde 联合推出了一个新的 JS 包管理工具，yarn 是为了弥补 npm 的一些缺陷而出现的。

## 8. UI 框架

1. LayUI：是一款采用自身模块规范编写的前端 UI 框架，遵循原生 HTML/CSS/JS 的书写与组织形式，门槛极低，拿来即用。
2. ElementUI：是饿了么前端开源维护的 Vue UI 组件库。
3. umy-ui：一个基于 vue 的 PC 端表格 UI 库，解决万级数据渲染卡顿问题，过万数据点击全选卡顿等问题
4. jQueryEasyUI： 是一种基于 jQuery 的用户界面的插件的集合，使用 easyui 你不需要写很多代码，你只需要通过编写一些简单 HTML 标记，就可以定义用户界面；jQueryEasyUI 是依赖 jQuery 的，而 jQuery 只是依赖于原生 javaScript，两个使用场景不同，对应的关系就如 vue 和 elementUI 的关系。
5. Bootstrap：一个流行的前端框架，提供响应式的 HTML、CSS 和 JavaScript 组件。
6. Angular js：Google 收购的前端框架，java 开发者开发，将 java 的 mvc 模型搬到了前端，增加了模块化开发理念，与微软合作，采用 TypeScript 开发
7. React：Facebook 出品，虚拟 DOM，利用内存。
8. Vue.js：一款渐进式 javaScript 框架，用于构建用户界面（视图层），集成 Angular 和 REact 优点（模块化 mvvm-异步通信 和虚拟 DOM 技术），Vue 边界明确，只是为了处理 DOM，不具备通信能力，因此需要额外的通信框架和服务器交互，可以使用 Axios 或者 jQuery 的 ajax
