# CSS

## 1. 介绍

CSS 指层叠样式表 (Cascading Style Sheets)

把样式添加到 HTML 中，是为了解决内容与表现分离的问题。外部样式表可以极大提高工作效率，通常存储在 CSS 文件中。多个样式定义可层叠为一层。

## 2. 语法

CSS 规则由两个主要的部分构成：

- 选择器；
- 一条或多条声明。

```css
/* h1为选择器，大括号中为两个声明（属性:值） */
h1 {color:blue; font-size: 12px;}
```

### 2.1 背景

CSS 背景属性用于定义HTML元素的背景。CSS 属性定义背景效果：

- background-color
- background-image
- background-repeat
- background-attachment
- background-position

### 2.2 文本格式

- 文本颜色：
- 对齐方式：text-align:center; text-align:right; text-align:justify;
- 文本修饰：text-decoration:overline; text-decoration:line-through; text-decoration:underline;
- 文本转换：text-transform:uppercase; text-transform:lowercase; text-transform:capitalize;
- 文本缩进：text-indent:50px;

### 2.3 字体

- 设置文本的字体系列：font-family
- 字体大小：font-size
- 字体样式：font-style:normal; font-style:italic;

### 2.4 行高

line-height

### 2.5 链接

链接的样式，可以用任何 CSS 属性（如颜色，字体，背景等）

特别的链接，可以有不同的样式，这取决于他们是什么状态。这四个链接状态是：

- 正常，未访问过的链接：a:link    
- 用户已访问过的链接：a:visited
- 当用户鼠标放在链接上时：a:hover
- 链接被点击的那一刻：a:active  

当设置为若干链路状态的样式，也有一些顺序规则：a:hover 必须跟在 a:link 和 a:visited后面，a:active 必须跟在 a:hover后面

### 2.6 盒模型

(Box Model) 盒子模型，所有 HTML 元素可以看作盒子，在 CSS 中，"box model"这一术语是用来设计和布局时使用。

CSS 盒模型本质上是一个盒子，封装周围的 HTML 元素，它包括：边距，边框，填充，和实际内容。盒模型允许我们在其它元素和周围元素边框之间的空间放置元素。

### 2.7 列表样式

- ul.a {list-style-type: circle;}
- ul.b {list-style-type: square;}
- ol.c {list-style-type: upper-roman;}
- ol.d {list-style-type: lower-alpha;}
- list-style-image: url('sqpurple.gif');

### 2.8 表格样式

```css
/* 表格边框 */
table, th, td{border: 1px solid black;}
/* 折叠边框 */
table{border-collapse:collapse;}	
table, th, td{border: 1px solid black;}
/* 表格宽度和高度 */
table {width:100%;}  
th{height:50px;}	
/* 表格文字对齐 */
td{text-align:right;} 
td{height:50px; vertical-align:bottom;}
/* 表格填充 */
td{padding:15px;}
/* 表格颜色 */
table, td, th{border:1px  solid  green;}
th{background-color:green;color:white;}
```

## 3. CSS 注释

注释是用来解释你的代码，并且可以随意编辑它，浏览器会忽略它。CSS 注释以 "/*" 开始, 以 "*/" 结束。

## 4. 选择器

### 4.1 标签选择器

id 和 class，如果你要在 HTML 元素中设置 CSS 样式，可以在元素中设置"id" 和 "class"。需要注意的是：类名的第一个字符不能使用数字！

id 和 class 区别：id 具有唯一性，一个网页只能使用一次，class 可以使用多次。


### 4.1 标签选择器
### 4.1 标签选择器

## 5. CSS 创建

插入样式表的方法有三种:

1. 外部样式表(External style sheet)
    - `<link rel="stylesheet" type="text/css" href="mystyle.css">`
2. 内部样式表(Internal style sheet)
3. 内联样式(Inline style)
    - 在相关的标签内使用样式（style）属性。Style 属性可以包含任何 CSS 属性。比如：`<p style="color:sienna;margin-left:20px">这是一个段落。</p>`
## 6. 示例

二级菜单 HTML 布局
```html
<div class="menuDiv">
    <ul>
        <li>
            <a href="#">菜单一</a>
            <ul>
                <li><a href="#">二级菜单</a></li>
                <li><a href="#">二级菜单</a></li>
                <li><a href="#">二级菜单</a></li>
            </ul>
        </li> 
    </ul>
</div>
```
二级菜单 CSS
```css
body {padding-top:100px;text-align:center; }
.menuDiv { border: 2px solid #aac; overflow: hidden; display:inline-block;}
.menuDiv a {text-decoration: none;}
.menuDiv ul , .menuDiv li {list-style: none;margin: 0;padding: 0;float: left;} 
.menuDiv > ul > li > ul {position: absolute;display: none;}
.menuDiv > ul > li > ul > li {float: none;}
.menuDiv > ul > li:hover ul {display: block;}
.menuDiv > ul > li > a {width: 120px;line-height: 40px;border-left: 1px solid #bbf;display: block;}
.menuDiv > ul > li:first-child > a {border-left: none;}
.menuDiv > ul > li > a:hover {color: #f0f;background-color: #bcf;}
.menuDiv > ul > li > ul > li > a {width: 120px;line-height: 36px;text-align: center;border: 1px solid #ccc;border-top: none;display: block;}
.menuDiv > ul > li > ul > li:first-child > a {border-top: 1px solid #ccc;}
.menuDiv > ul > li > ul > li > a:hover {color: #a4f;background-color: #cdf;}

```

## 7. CSS 预处理语言 

用一种专门的编程语言，进行 Web 页面样式设计，再通过编译器转化为正常的 CSS 文件，以供项目使用

### 7.1 Less

Less 是一门 CSS 预处理语言，它扩充了 CSS 语言，增加了诸如变量、混合(mixin)、函数等功能，让 CSS 更易维护、方便制作主题、扩充。Less 可以运行在 Node 或浏览器端。

Less 基于 JavaScrip，是需要引入 Less.js 来处理代码输出 css 到浏览器，也可以在开发环节使用 Less，然后编译成 css 文件，直接放在项目中。

### 7.2 Sass(Scss)

Sass 是一款强化 CSS 的辅助工具，它在 CSS 语法的基础上增加了变量 (variables)、嵌套 (nested rules)、混合 (mixins)、导入 (inline imports) 等高级功能，这些拓展令 CSS 更加强大与优雅。使用 Sass 以及 Sass 的样式库(如 Compass)有助于更好地组织管理样式文件，以及更高效地开发项目。

Sass 基于 Ruby 环境。

### 7.3 对比

**相同之处**

- 变量：可以单独定义一系列通用的样式，在需要的时候进行调用。
- 混合(Mixins)：class 中的 class（将一个class引入到另一个class，实现class与class之间的继承），还可以带参数的混合，就像函数一样。
- 嵌套：class 中嵌套 class，从而减少代码的重复。
- 运算：提供了加减乘除四则运算，可以做属性值和颜色的运算。

**不同之处**

- Less 定义变量时使用前缀：@；Sass 定义变量时使用前缀：$。
- Less 中使用混合时，只需在 classB 中根据 classA 的命名来使用；Sass 中首先在定义混合时需要使用 @mixin 命令，其次在调用时需要使用 @include 命令来引入之前定义的混合。
- Less 可以向上/向下解析；Sass 只能向上解析。
- Less 变量有全局和局部之分；Sass 变量可以理解为都是全局的，但可以通过在变量后面跟 !default，在引入 Sass 文件之前改变变量的属性值来解决这一问题。
- Sass 中增加了条件语句(if、if…else)和循环语句(for循环、while循环和each循环)还有自定义函数：

**安装使用**

```js
// 1.安装
//推荐版本 node-sass: ^4.12.0     sass-loader: ^8.0.2    sass-loader: 7.3.1     node-sass: 4.14.1

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


