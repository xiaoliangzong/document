# JavaScript

## 1. 介绍

JavaScript（简称“JS”）是一种具有函数优先的轻量级，解释型或即时编译型的编程语言。

JavaScript 在 1995 年由 Netscape 公司的 Brendan Eich，在网景导航者浏览器上首次设计实现而成。因为 Netscap e 与 Sun 合作，Netscape 管理层希望它外观看起来像 Java，因此取名为 JavaScript。但实际上它的语法风格与 Self 及 Scheme 较为接近。

JavaScript 的标准是 ECMAScript。截至 2012 年，所有浏览器都完整的支持 ECMAScript 5.1，旧版本的浏览器至少支持 ECMAScript 3 标准。2015 年 6 月 17 日，ECMA 国际组织发布了 ECMAScript 的第六版，该版本正式名称为 ECMAScript 2015，但通常被称为 ECMAScript 6 或者 ES2015。

## 2. 语法

window.URL.createObjectURL() 可以用于在浏览器上预览本地图片或者视频；
静态方法会创建一个 DOMString，其中包含一个表示参数中给出的对象的 URL。这个 URL 的生命周期和创建它的窗口中的 document 绑定。这个新的 URL 对象表示指定的 File 对象或 Blob 对象。

console.log(JSON.parse(JSON.stringify(res.data)))

### 2.1 var const let

1. const： 不可以修改，必须初始化
2. var： 可以修改，不初始化的话，默认位 undefined
3. let： 块级作用域，函数内部使用 let 定义后，对函数外部无影响

### 2.2 BOM 和 DOM

**BOM**

BOM：浏览器对象模型（Browser Object Model），是 JavaScript 中用于表示和操作浏览器窗口及其相关组件的对象模型。

BOM 提供了一组 API 接口，允许开发者通过 JavaScript 与浏览器进行交互。BOM 的核心对象是 window 对象，它代表了浏览器窗口，并提供了许多属性和方法来操作窗口、导航、处理事件等。

**DOM**

DOM：文档对象模型（Document Object Model），是 W3C 定义的一套用于处理 HTML 和 XML 文档内容的标准编程接口 API，DOM 把整个页面规划成由节点层级构成的文档。

DOM 对象是我们用 javascript 实 现 DOM 接口获得的对象。DOM 属于浏览器，而不是 JavaScript 语言规范里的规定的核心内容。

DOM 树主要由 4 类主要节点组成：文档节点，元素节点，属性节点，文本节点。

- 文档节点：在树的顶端是文档节点，它呈现整个页面。
- 元素节点：需要访问 DOM 树时，需要从查找元素开始。一旦找到所需的元素，然后就可以根据需要来访问它的文本和属性节点。
- 属性节点：属性节点不是所在元素的子节点，它们是这个元素的一部分。当访问一个元素时，有特定的方法和属性用来读取或修改这个元素的属性。
- 文本节点：当访问元素节点，可以访问元素内部的文本。文本节点没有子节点。

javascript 实现 DOM 接口的对象对应的是 document 对象，JS 通过该对象来对 HTML/XML 文档进行增删改查。

**关系**

document 是 DOM 的根节点，而 document 在 window 对象中是作为其一个属性而存在的，因此从这个角度来说，BOM 包含了 DOM。

DOM 是为了操作文档出现的 API，DOM 对象最根本的是 document（实际上是 window.document）

在前端开发中，DOM 和 BOM 通常一起使用，通过 DOM 操作文档内容，而通过 BOM 与浏览器进行交互，实现与用户界面和浏览器环境的交互效果。

## 3. ECMAScript 2015

ES6（也称为 ECMAScript 2015）是 JavaScript 的一个版本，是 ECMAScript 语言规范的第六版。它是一个主要的版本更新，引入了许多新的特性和改进。

### 3.1 新特性

- 块级作用域：通过 let 和 const 关键字引入了块级作用域变量。
- 箭头函数：提供了一种简洁的函数定义方式，并且不会改变 this 的值。
- 类：引入了基于类的面向对象编程（OOP）语法。
- 模板字面量：允许嵌入表达式的字符串插值。
- 解构赋值：可以从数组或对象中提取值并赋给变量。
- Promise：用于处理异步操作的原生支持。
- 模块化：引入了 import 和 export 关键字来支持模块化开发。
- 生成器函数：使用 function\* 语法定义，可以控制函数的执行流。
- Symbol：引入了新的原始数据类型，用于创建唯一的标识符。

```js
function (config) {
   // 在发送请求之前做些什么
   return config;
}
(config)=>{
return config;
}

```

#### 3.1.1 模块化

1. export 用于对外输出本模块（一个文件可以理解为一个模块）变量的接口
2. import 用于在一个模块中加载另一个含有 export 接口的模块。

#### 3.1.2 生成器函数

#### 3.1.3 Promise

1.  Promise 是一个构造函数，自己身上有 all、reject、resolve 这几个眼熟的方法，原型上有 then、catch 等同样很眼熟的方法。
2.  Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。从语法上说，Promise 是一个对象，从它可以获取异步操作的消息。
3.  同步的方式写异步的代码，用来解决回调问题。

## 4. JavaScript 框架

2. Angular js：Google 收购的前端框架，java 开发者开发，将 java 的 mvc 模型搬到了前端，增加了模块化开发理念，与微软合作，采用 TypeScript 开发
3. React：Facebook 出品，虚拟 DOM，利用内存。
4. Vue.js：一款渐进式 javaScript 框架，用于构建用户界面（视图层），集成 Angular 和 REact 优点（模块化 mvvm-异步通信 和虚拟 DOM 技术），Vue 边界明确，只是为了处理 DOM，不具备通信能力，因此需要额外的通信框架和服务器交互，可以使用 Axios 或者 jQuery 的 ajax

## 5. JavaScript 常用库

1. jQuery： 是一个广泛使用的 JavaScript 库，它简化了 HTML 文档操作、事件处理、动画和 AJAX 请求。简化 DOM 操作
2. AJAX（Asynchronous JavaScript and XML）：是一种用于创建异步网页应用的技术，可以在不重新加载页面的情况下从服务器获取数据。
3. Axios：是一个基于 Promise 的 HTTP 客户端，用于发送 HTTP 请求。

## 6. TypeScript

TypeScript 是 Microsoft 微软开发和维护的一种静态类型语言，它 是 JavaScript 的超集，包含了 JavaScript 的所有元素，可以载入 JavaScript 代码运行，并扩展了 JavaScript 的语法。

通过 webpack 打包成 javascript；vue3.0 以上版本支持 typeScript。
