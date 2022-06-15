## HTML

> HyperText Markup Language，超文本标记语言

## 1. 结构

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

## 2. 语法

**标题标签**

HTML 标题是通过<h1> - <h6> 标签来定义的，<h1>一级标题，一个页面只能有一个一级标题

**段落标签**

HTML 段落是通过标签 <p> 来定义的

**链接标签**

HTML 链接是通过标签 <a> 来定义的，href 属性中指定链接的地址

**图像标签**

HTML 图像是通过标签 <img> 来定义的，alt 和 title 属性的意义。注意： 图像的名称和尺寸是以属性的形式提供的。

**表格**

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

**列表**

1. 无序列表，ul li
2. 有序列表，ol li
3. 定义列表，dl dt

**div、span**

|  标签  | 描述                                        |
| :----: | ------------------------------------------- |
| <div>  | 定义了文档的区域，块级 (block-level)        |
| <span> | 用来组合文档中的行内元素， 内联元素(inline) |

**表单**

<form>
    input 元素
</form>

| Scheme | 访问                                            | 用于...                             |
| ------ | ----------------------------------------------- | ----------------------------------- |
| http   | 超文本传输协议                                  | 以 http:// 开头的普通网页，不加密。 |
| https  | 安全超文本传输协议 安全网页，加密所有信息交换。 |
| ftp    | 文件传输协议                                    | 用于将文件下载或上传至网站。        |
| file   |                                                 | 你计算机上的文件。                  |

URL（统一资源定位器）语法规则：scheme://host.domain:port/path/filename

- scheme - 定义因特网服务的类型。最常见的类型是 http，https
- host - 定义域主机（http 的默认主机是 www）
- domain - 定义因特网域名，比如 runoob.com
- :port - 定义主机上的端口号（http 的默认端口号是 80）
- path - 定义服务器上的路径（如果省略，则文档必须位于网站的根目录中）。
- filename - 定义文档/资源的名称
