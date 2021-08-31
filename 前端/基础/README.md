## 跨域

> 跨域是指浏览器不能执行其他网站的脚本，它是由浏览器的同源策略（所谓同源是指域名、协议、端口均相同）造成的，是浏览器对 JavaScript 施加的安全限制。当协议、域名、端口号，有一个或多个不同时，前端请求后端服务器接口的情况称为跨域访问。
>
> 同源策略限制下 cookie、localStorage、dom、ajax、IndexDB 都是不支持跨域的；
> 为什么 cookie、localStorage、dom、ajax、IndexDB 会受到同源策略限制，下面还有一点对跨域理解的误区：
>
> 1.  误区： 同源策略限制下，访问不到后台服务器的数据，或访问到后台服务器的数据后没有返回；
> 2.  正确： 同源策略限制下，可以访问到后台服务器的数据，后台服务器会正常返回数据，而被浏览器给拦截了。
>
> localhost 和 127.0.0.1 虽然都指向本机，但也属于跨域

**解决方式**

- 前端安装 Nginx，设置 http 请求转发，这样可以绕过浏览器跨域警告
- CORS 解决跨域

## var const let 区别

1. const： 不可以修改，必须初始化
2. var： 可以修改，不初始化的话，默认位 undefined
3. let： 块级作用域，函数内部使用 let 定义后，对函数外部无影响

## Cookie、SessionStorage 和 LocalStorage 区别

### cookie 和 session

**都是用来跟踪浏览器用户身份的会话方式**

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

### HTML5 新增加的 WebStorage

> WebStorage 是 HTML5 新增的本地存储解决方案之一，但并不是为了取代 cookie 而制定的标准，cookie 作为 HTTP 协议的一部分用来处理客户端和服务器通信是不可或缺的。WebStorage 的意图在于解决本来不应该 cookie 做，却不得不用 cookie 的本地存储。WebStorage 存储数据大小一般都是 5MB；保存在客户端，不与服务器进行交互通信；只能存储字符串类型，对于复杂的对象可以使用 ECMAScript 提供的 JSON 对象的 stringify 和 parse 来处理

1. sessionStorage
   - 将数据保存在 session 对象中，
   - 临时保存
   - 获取方式：window.sessionStorage
   - 常用于敏感账号一次性登录；
2. localStorage

   - 将数据保存在客户端本地的硬件设备，即使浏览器关闭了，该数据仍然存在，下次打开浏览器访问网站时可以继续使用
   - 永久保存，除非主动删除，否则数据永远不会消失
   - 获取方式：window.localStorage
   - 常用于长期登录（+判断用户是否已登录），适合长期保存在本地的数据

3. WebStorage 提供了一些方法，数据操作比 cookie 方便

   - setItem (key, value) —— 保存数据，以键值对的方式储存信息。
   - getItem (key) —— 获取数据，将键值传入，即可获取到对应的 value 值。
   - removeItem (key) —— 删除单个数据，根据键值移除对应的信息。
   - clear () —— 删除所有的数据
   - key (index) —— 获取某个索引的 key

### vue 项目使用 js-cookie

> js-cookie 是 cookie 存储的一个 js 的 API，根据官网描述其优点有：适用所有浏览器、接受任何字符、经过任何测试没什么 bug、支持 CMD 和 CommonJS、压缩之后非常小，仅 900 个字节

**使用步骤**

1. 安装： npm install js-cookie -S
2. 在主入口 main.js 全局引入：import Cookies from 'js-cookie'
3. 使用

```js
//1、存cookie  set方法支持的属性有 ：  expires->过期时间    path->设置为指定页面创建cookie   domain-》设置对指定域名及指定域名的子域名可见  secure->值有false和true ,表示设置是否只支持https,默认是false
Cookies.set('key', 'value') //创建简单的cookie
Cookies.set('key', 'value', { expires: 27 }) //创建有效期为27天的cookie
Cookies.set('key', 'value', { expires: 17, path: '' }) //可以通过配置path,为当前页创建有效期7天的cookie

//2、取cookie
Cookies.get('key') // 获取指定key 对应的value
Cookies.get() //获取所有value

//3、删除cookie
Cookies.remove('key') //删除普通的cookie
Cookies.remove('name', { path: '' }) // 删除存了指定页面path的cookie

/* 注意：如果存的是对象，如： userInfo = {age:111,score:90};  Cookie.set('userInfo',userInfo)取出来的userInfo需要进行JSON的解析,
解析为对象：let res = JSON.parse( Cookie.get('userInfo') );当然你也可以使用：Cookie.getJSON('userInfo');
*/
```

## node.js npm webpack

1. 概念

   - npm：nodejs 的包管理工具，相当于 maven 中的包依赖管理；
   - node.js：javaScript 包管理工具，是 js 的服务执行环境，是 js 后端运行平台，相当于 java 体系中对应的 jdk，是三个里面最基础的；
   - webpack： 是基于 nodejs 实现的，前端工程化打包工具，是一种模块化的解决方案，是模块加载器兼打包工具(模块打包工具)，它能够把各种资源作为模块来处理和使用，主要作用打包、压缩、合并、按序加载；相当于 maven 中工程自动化；

2. 安装详解：

   - nodeJs 中包含 npm，安装 node.js 就会自动安装 npm
   - 更新 npm，node 自带的 npm 不是最新版本，需要更新：npm install -g npm
   - 安装完之后，重写设置淘宝镜像：npm config set registry " https://registry.npm.taobao.org "
   - 安装 vue-cli：npm install vue-cli -g
   - 检查 vue-cli 安装是否成功：vue list
   - 卸载 vue-cli：npm uninstall -g vue-cli
   - 查看版本：vue -V
   - 安装 3.x 以上版本：npm install -g @vue/cli（保证 node 版本>=8.9，npm 更新最新）
   - 查看所有版本号：npm view vue-cli versions --json
   - npm install webpack -g
   - npm install webpack-cli -g
   - 检查安装是否成功：webpack -v

## css 预处理语言 Sass(Scss) Less

> 用一种专门的编程语言，进行 Web 页面样式设计，再通过编译器转化为正常的 CSS 文件，以供项目使用

**区别**

1. Less 环境比 Sass 简单，Sass 的安装需要安装 Ruby 环境，Less 基于 JavaScrip，是需要引入 Less.js 来处理代码输出 css 到浏览器，也可以在开发环节使用 Less，然后编译成 css 文件，直接放在项目中

2. Less 使用比 Sass 简单，Less 并没有裁剪 CSS 原有的特性，而是在现有 CSS 语法的基础上，为 CSS 加入程序式语言的特性。只要你了解 CSS 基础就可以很容易上手

3. 从功能出发，Sass 较 Less 略强大一些，Sass 有变量和作用域、函数、进程控制、数据结构

4. Less 与 Sass 处理机制不一样，前者是通过客户端处理的，后者是通过服务端处理，相比较之下前者解析会比后者慢一点

**语法的共性**

1. 混入(Mixins)——class 中的 class；
2. 参数混入——可以传递参数的 class，就像函数一样；
3. 嵌套规则——Class 中嵌套 class，从而减少重复的代码；
4. 运算——CSS 中用上数学；
5. 颜色功能——可以编辑颜色；
6. 名字空间(namespace)——分组样式，从而可以被调用；
7. 作用域——局部修改样式；
8. JavaScript 赋值——在 CSS 中使用 JavaScript 表达式赋值。

**安装使用**

```js
// 1.安装
//推荐版本
"node-sass": "^4.12.0"和"sass-loader": "^8.0.2",
sass-loader 7.3.1和node-sass 4.14.1

npm install node-sass --save-dev
npm install sass-loader --save-dev
npm install less less-loader --save-dev
// 管理员身份运行
npm install --global --production windows-build-tools

npm i node-sass@4.12.0 --sass_binary_site=https://npm.taobao.org/mirrors/node-sass/
// 2.使用：通常会在项目里创建一个variable.scss文件，里边定义一些公共的样式，可以是单独的变量、mixin混入（类似函数）
// 为了不需要在每个页面引用，就定义全局变量，需要在vue.config.js中引用（也可以在每个文件的style标签中单独引用scss文件）

<style lang="scss" scoped>
import '@/assets/scss/variable.scss'
</style>

css: {
  loaderOptions: {    // 向 CSS 相关的 loader 传递选项
      scss: {         // 这里的选项会传递给sass-loader
          prependData: `@import "@/assets/scss/variables.scss";`
      },
  }
}
```

## javascript，原生 js，是基于标准规范 ECMAScript 开发，也称 ES

ES6：常用，当前主流版本，设计思想是尽量模块化，使编译时就能确定模块的依赖关系，以及输出和输入的变量；webpack 打包成为 ES5 支持！
ES5：全浏览器都支持

1. jQuery 框架：简化 DOM 操作，
2. Angular js：Google 收购的前端框架，java 开发者开发，将 java 的 mvc 模型搬到了前端，增加了模块化开发理念，与微软合作，采用 TypeScript 开发
3. React：Facebook 出品，虚拟 DOM，利用内存。
4. Vue：一款渐进式 javaScript 框架，用于构建用户界面（视图层），集成 Angular 和 REact 优点（模块化 mvvm-异步通信 和虚拟 DOM 技术），Vue 边界明确，只是为了处理 DOM，不具备通信能力，因此需要额外的通信框架和服务器交互，可以使用 Axios 或者 jQuery 的 ajax
5. Axios：前端通信框架
6. 常用的 UI 框架：bootstrap、ElementUI、LayUI
7. umy-ui：一个基于 vue 的 PC 端表格 UI 库,解决万级数据渲染卡顿问题,过万数据点击全选卡顿,等等问题
8. jQueryEasyUI： 是一种基于 jQuery 的用户界面的插件的集合，使用 easyui 你不需要写很多代码，你只需要通过编写一些简单 HTML 标记，就可以定义用户界面；jQueryEasyUI 是依赖 jQuery 的，而 jQuery 只是依赖于原生 javaScript，两个使用场景不同，对应的关系就如 vue 和 elementUI 的关系。

## TypeScript

微软的标准，通过 webpack 打包成 javascript；vue3.0 以上版本支持 typeScript

## 解析图片方式

### 以 base64 文件编码形式传输并显示前端

```java
BufferedImage bi = new BufferedImage(130, 48, BufferedImage.TYPE_INT_RGB);
// 省略...
FastByteArrayOutputStream os = new FastByteArrayOutputStream();

try {
   ImageIO.write(bufferedImage, "jpg", os);
} catch (IOException e) {
   return ResultVo.error(e.getMessage());
}
Map<String, Object> data = new HashMap<>(2);
data.put("uuid", "uuid");
// base64简单地说，它把一些 8-bit 数据翻译成标准 ASCII 字符，网上有很多免费的base64 编码和解码的工具
data.put("img", Base64.getEncoder().encodeToString(os.toByteArray()));
return ResultVo.success(data);
```

```js
methods: {
    getCode() {
      getCodeImg().then(res => {
        this.codeUrl = "data:image/gif;base64," + res.img;
        // data表示取得数据的协定名称，image/png 是数据类型名称，base64 是数据的编码方法，逗号后面就是这个image/png文件base64编码后的数据。
        this.loginForm.uuid = res.uuid;
      });
    },
}

```

### 将流对象放入到 response 中

```java
//将图片输出
ImageIO.write(image,"jpg",response.getOutputStream());

window.URL.createObjectURL(response);

<div class="login-code">
   <img :src="codeUrl" @click="getCaptchaImage" class="login-code-img" />
</div>

// 获取验证码
export function getCaptcha(){
    return request({
        url: '/captchaImage',
        method: 'get',
        responseType: 'blob'
        // Blob对象表示不可变的类似文件对象的原始数据
    })
}
```
