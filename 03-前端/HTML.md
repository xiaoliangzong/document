# HTML

## 1. 介绍

HyperText Markup Language，超文本标记语言

## 2. 结构

```html
<!-- 声明为 HTML5 文档 -->
<!DOCTYPE html>
<!-- HTML 页面的根元素 -->
<html>
  <head>
    <meta charset="UTF-8" />
    <meta name="description" content="Description" />
    <!-- 文档标题 -->
    <title></title>
  </head>
  <!-- 可见的页面内容 -->
  <body></body>
</html>
```

## 3. 语法

### 3.1 标题标签

HTML 标题是通过<h1> - <h6> 标签来定义的，<h1>一级标题，一个页面只能有一个一级标题

### 3.2 段落标签

HTML 段落是通过标签 <p> 来定义的

### 3.3 链接标签

HTML 链接是通过标签 <a> 来定义的，href 属性中指定链接的地址

### 3.4 图像标签

HTML 图像是通过标签 <img> 来定义的，alt 和 title 属性的意义。注意： 图像的名称和尺寸是以属性的形式提供的。

### 3.5 表格

```html
<table border="1">
  <tr>
    <th>Header 1</th>
    <th>Header 2</th>
  </tr>
  <tr>
    <td>row 1, cell 1</td>
    <td>row 1, cell 2</td>
  </tr>
  <tr>
    <td>row 2, cell 1</td>
    <td>row 2, cell 2</td>
  </tr>
</table>
```

### 3.6 列表

1. 无序列表，ul li
2. 有序列表，ol li
3. 定义列表，dl dt

### 3.7 div、span

|  标签  | 描述                                        |
| :----: | ------------------------------------------- |
| <div>  | 定义了文档的区域，块级 (block-level)        |
| <span> | 用来组合文档中的行内元素， 内联元素(inline) |

### 3.8 表单

<form>
    input 元素
</form>

## 4 示例

```html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="UTF-8" />
    <title>网页名称</title>
  </head>
  <body>
    <!--HTML超文本标记语言，不是一种编程语言-->
    <h1>一级标题</h1>
    <h2>二级标题</h2>
    <p>这是一个段落</p>
    <img src="" alt="" title="" width="" height="" />
    <a href="" target="_blank"></a>
    <!--语义，告诉浏览器-->
    <table border="" cellspacing="" cellpadding="">
      <thead>
        <tr>
          <th>Header</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>Data</td>
        </tr>
      </tbody>
    </table>

    <ul>
      <li>1</li>
      <li>2</li>
      <li>3</li>
    </ul>

    <ol>
      <li>a</li>
      <li>b</li>
      <li>c</li>
    </ol>
    <dl>
      <dt>描述的事物</dt>
      <dd>做一个补充说明</dd>
      <dd>做一个补充说明</dd>
      <dd>做一个补充说明</dd>
    </dl>

    <form action="#" method="post">
      <input type="text" name="" id="" />
      <input type="password" name="" id="" value="" />
      <input type="radio" name="aa" />男 <input type="radio" name="aa" />女
      <input type="checkbox" name="" id="" value="" />篮球
      <input type="checkbox" name="" id="" value="" />足球
      <input type="checkbox" name="" id="" value="" />排球
      <input type="checkbox" name="" id="" value="" />冰壶

      <input type="button" value="this is a button" />
      <input type="reset" name="" id="" value="重置" />
      <input type="file" name="" id="" value="" />
      <input type="email" name="" id="" value="" />
      <input type="color" name="" id="" value="" />
      <input type="date" name="" id="" value="" />
      <input type="tel" name="" id="" value="" />
      <input type="number" name="" id="" value="" />
      <input type="submit" value="" />
    </form>
    <i>文字</i>
    <del>删除线</del>
    <hr />
    <br />
    <sub></sub>
    <sup></sup>

    <!--字符实体-->
    <!--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;-->
  </body>
</html>
```


