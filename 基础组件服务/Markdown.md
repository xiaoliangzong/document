# Markdown

是一种轻量级标记语言，可以使用简单的语法将文本内容转换为HTML格式。

## 1. 标题

标题分为6级，使用 # 标注

```makrdown
# h1 
## h2 
### h3
#### h4
##### h5
###### h6
```

## 2. 段落

```makrdown
*斜体*          _斜体_

**粗体**        __粗体__

_**斜体粗体组合**_

~~文字被横线删除~~
```

## 3. 列表

## 4. 链接

```markown {.line-numbers}
<https://baidu.com>
[baidu](https://baidu.com)

高级链接语法：

Google 网址参考链接 [Google][1]
Baidu  网址参考链接 [Baidu][baidu]

然后在文档的结尾为变量（网址）赋值
[1]: http://www.google.com/
[baidu]: https://baidu.com/
```

## 5. 图片

Markdown 不能指定图片的高度与宽度，如果需要的话，可以使用普通的 `<img> `标签。

```markdown
![alt 属性文本](url "可选标题")

![svg](../public/images/db.svg "svg title")

也可以像图片地址那样使用变量；

<img src="../public/images/db.svg" width="50%">
```

## 6. 行内代码

行内代码使用反引号 ``引起来，比如`<img>`。

## 7. 代码块

```markdown {.line-numbers highlight=1}
扩展功能，本身并不支持，因为需要使用工具或插件：
1. 代码块显示代码行数 {.line-numbers}
2. 高亮代码行数 {highlight=[1-10,15,20-22]}
```

## 8. 引用

```markdown
> 引用
>> 嵌套引用
```

## 9. 分割线

使用连续三个以上的***， 或者是---，或者是___，就可以显示成分割线

## 10. 任务列表

```markdown
- [x] 完成任务
- [ ] 未完成任务
```

## 11. 表格

文字默认居左，两边加：表示文字居中，右边加：表示文字居右

```markdown
|   |   |
|---|---|
|   |   |
```

## 12. 其他

不在 Markdown 涵盖范围之内的标签，都可以直接在文档里面用 HTML 撰写。目前支持的 HTML 元素有

```markdown
<kbd>Ctrl</kbd>   Ctrl键
<b></b>           粗体
<i></i>           斜体
<em></em>         斜体
<sup></sup>       上标
<sub></sub>       下标
<br>              换行
```

## 常用解析器

1. marked：用 JavaScript 编写的快速、灵活和易于扩展的 Markdown 解析器，支持在浏览器端和 Node.js 环境中运行。（docsify）
2. Markdown-it：用 JavaScript 编写的现代化、快速和功能丰富的 Markdown 解析器，支持在浏览器端和 Node.js 环境中运行。
3. Pandoc：用 Haskell 编写的通用文档转换器，支持多种标记语言和文档格式之间的转换，包括 Markdown 和 HTML。(typora)
4. CommonMark：一个由 John MacFarlane 等人开发的 Markdown 规范，定义了一组标准的语法和解析器行为，多个解析器支持此规范。

常用的 Markdown 解析器因应用场景不同而不同。例如，在 Node.js 环境下，可以使用 marked 和 Markdown-it 进行 Markdown 解析；在需要将 Markdown 转换成其他文档格式的情况下，可以使用 Pandoc；在需要使用标准化的 Markdown 语法进行文本编辑和解析的情况下，可以使用 CommonMark。