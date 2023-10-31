- [Visual Studio Code](#visual-studio-code)
  - [1. 常用快捷键](#1-常用快捷键)
  - [2. 常用插件](#2-常用插件)
    - [简体中文](#简体中文)
    - [图标主题](#图标主题)
    - [自动关闭、重命名标签](#自动关闭重命名标签)
    - [MarkDown 增强](#markdown-增强)
    - [4. 智能化提示、补全文件路径和导入的模块](#4-智能化提示补全文件路径和导入的模块)
  - [3. 常见问题](#3-常见问题)

# Visual Studio Code

## 1. 常用快捷键

|      快捷键      |       说明       |
|:----------------:|:--------------:|
|   ctrl+shift+P   |       搜索       |
|    alt+上下键    |      上下移      |
| shift+alt+上下键 |  向上下复制一行  |
|   shift+ctrl+k   |     删除一行     |
|    ctrl+enter    |   下边插入一行   |
|   ctrl+shift+\   | 跳转到匹配的括号 |

## 2. 常用插件

### 2.1 简体中文

#### Chinese (Simplified)

### 2.2 图标主题、背景图

#### vscode-icons

图标主题插件，更倾向于使用更加传统的图标风格，更加突出了图标的轮廓和颜色。

#### material icon Theme

图标主题插件，更注重简单、扁平和现代化的设计风格，图标更为简洁明了，基于 Google 的 Material Design 风格设计，使用了单一颜色调色板。

#### background

添加背景图片，支持核心区域背景图和全屏背景图，详细设置参考插件说明；

#### background-cover

添加背景图片，background-cover，仅支持全屏背景图，操作简单。

### 2.3 Markdown

 #### Markdown Preview Enhanced

1. 创建TOC，markdown 语法本来就支持创建，只需在文件中输入 [TOC] ，但是该方式创建的 TOC 只会在预览中显示，而不会修改你的 markdown 文件。而该插件则会在原文件中增加目录，并支持排除某个标题（只需要在标题后添加 {ignore=true}） 。
2. 代码块显示行号，通过 {.line-numbers} 标注即可。
3. 标题添加 id 或者 class，{#id .class1 .class2}。
4. 导入文件 @import text.md"。
5. 导出，支持导出PDF、HTML等格式。
6. 提供支持数学公式，使用 KaTeX 或者 MathJax 来渲染数学表达式。KaTeX 拥有比 MathJax 更快的性能，但是它却少了很多 MathJax 拥有的特性。
7. 扩展语法：
    - 表格单元格合并，使用该功能的前提是打开 enableExtendedTableSyntax 选项。
    - Emoji & Font-Awesome，只适用于 markdown-it parser 而不适用于 pandoc parser。:smile:  :fa-car:
    - 上标 30^th^  下标 H~2~O
    - 标记 ==marked==

8. Admonition 告诫

!!! note This is the admonition title
    This is the admonition body

#### ~~Markdown All in One~~

1. 实时预览：在VS Code编辑器中直接预览Markdown文档。
2. 格式化
3. 语法检查
4. 快捷键：为常用Markdown格式（如加粗、斜体、标题等）提供快捷键。
5. 表格生成器：通过几次键击在编辑器中轻松添加和操作表格。
6. 粘贴图片：通过Ctrl + Shift + V（Windows / Linux）或Cmd + Shift + V（Mac）以WYSIWYG方式插入图片。
7. 大纲视图：在大纲视图中查看和导航Markdown文件的结构。
8. Snippets：将预定义的代码块插入Markdown文件中，提供最佳实践的代码示例。


**和 Markdown Preview Enhanced 对比**

- 功能： Markdown All in One主要带来了快捷键、表格生成器、粘贴图片等便利功能，侧重于让用户更轻松编写Markdown文件。而Markdown Preview Enhanced则提供了更多的预览演示功能，并支持许多高级功能，如数学公式渲染、流程图、时序图等。

- 定制化： Markdown All in One更加注重快捷键，不支持自定义预览样式。Markdown Preview Enhanced有更多的选项和更先进的功能，例如，MPE可自定义预览样式、添加各种图标、并支持主题设置。

- 难以程度：Markdown All in One更易于入门，快速上手。Markdown Preview Enhanced提供的功能更全面、更高级，使用更加复杂。

#### ~~Markdownlint~~

可配置的语法检查插件，它会使用默认的标准规则自动运行并检查文件中的语法错误和规范问题。如果想使用其他规则集合，可以通过.markdownlintrc 配置文件进行自定义配置更改。

```json
/*
    示例：
    1. 配置文件将默认启用所有规则
    2. 禁用 MD001 规则（Titles must be properly ordered）
    3. 启用 MD029 规则（Ordered list item prefix），并设置其样式为 ordered
*/
{
    "default": true,
    "MD001": false,
    "MD029": {
        "style": "ordered"
    }
}
```

#### Markdown Table Generator

#### ~~Markdown Table Prettifier~~

对表格的源文本进行美化，主要是能够自动对齐，在源码状态下便于快速观察。


### 2.4 前端开发神器

#### auto rename tag

VS Code 本身支持这两个插件的功能（语言比较少，不可配置），而两个插件支持的语言可配置，比如支持jsx（JavaScript XML）、tsx（TypeScript XML）等。

从 1.31 版本开始默认开启的。仅在 HTML、XML、XSLT 和 Razor 文件类型中生效，并在打开文件时自动启用。

#### auto close tag

从 1.44 版本开始，VS Code为HTML和Handlebars（是javaScript的一个模板引擎）提供内置的自动更新标签支持，默认是关闭的，可以通过设置editor.linkedEditing来启用。

说明：如果该设置被启用，该扩展程序将跳过HTML和Handlebars文件，而不考虑auto-rename-tag.activationOnLanguage中列出的语言。换言之，无论在 auto-rename-tag.activationOnLanguage 配置中声明支持哪些语言，自动重命名标签都不会对 HTML 和 Handlebars 文件进行修改标签名称的操作。这主要是由于 VS Code 自带的编辑器已经具备了同样的功能，因此自动重命名标签插件的功能在这种情况下就显得多余了。


#### HTMLHint 

用于检查 HTML 代码错误，包括语法错误、标签使用不当、属性使用不当、无障碍性等方面的问题。它能够帮助开发者捕获并修复这些常见的 HTML 错误，提高代码质量和可读性。


#### StyleLint

用于检查 CSS（或者 SCSS、SASS 等预处理器）代码的静态分析工具。它可以检查 CSS 代码的风格、结构、代码规范、命名约定等方面的问题，并提供有针对性的建议和修复方案，有助于开发者遵循统一的代码规范和样式风格。

#### ESLint

JavaScript/TypeScript 代码检查工具，用于识别和报告代码中的常见错误和风格问题。

#### javaScript(ES6) code snippets

为 JavaScript 语言提供了一系列 ES6 语法的代码片段

#### jQuery Code Snippets

专门针对 jQuery 框架，提供了一系列的 jQuery 代码片段

#### Vetur 

是一款针对 Vue.js 开发的 VS Code 扩展插件，为 Vue.js 项目的开发提供了全套的功能支持。它具有以下主要特点：

- 语法高亮：Vetur 支持对 Vue.js 单文件（.vue）中的 HTML、CSS 和 JS 代码都进行高亮显示，方便开发者快速定位和编辑自己代码。
- 代码提示：Vetur 提供 Vue.js 相关 API 的代码补全和智能提示，以及组件名的自动完成，大大提高开发效率。
- 语法检查：Vetur 还可以帮助您检测和修复代码错误，例如拼写错误、使用未定义变量等，提高代码质量。
- Linting：Vetur 可以集成 ESLint、StyleLint 等常用 lint 工具，实现对 Vue.js 项目中的 JavaScript、CSS/SCSS 代码风格和约定的规范化管理。
- Debugging：通过 Vetur 可以在 VS Code 中调试 Vue.js 应用程序，包括单文件组件、Vuex 状态管理系统等组件。

#### import Cost

在行尾在线显示导入包的大小

#### koroFileHeader 

在文件顶部为代码添加自动化注释，并且支持多种编程语言，包括JavaScript、TypeScript、Python、Java、C++等。

#### Code Runner

用来直接运行代码以及查看输出结果，支持多种语言的代码片断或代码文件。

#### Code Spell Checker

拼写检查插件

#### npm Intellisense 

针对 npm 模块的自动补全功能，当在代码中输入 import 或 require 语句时，会自动为你列出项目中可用的所有 npm 模块，并根据你输入的内容进行过滤和排序。

#### Path Intellisense

VSCode 本身支持文件路径的智能化提示功能，不过这个功能相对 Path Intellisense 插件而言相对简单一些，需要手动触发才能使用。

智能化提示、补全文件路径和导入的模块

使用Vue开发时，需要的配置：

```json
// 在用户配置setting.json中增加配置，解决路径别名（@）等不支持自动提示问题
"path-intellisense.mappings": {
    "@": "${workspaceRoot}/src",
    "/": "${workspaceRoot}/"
}

// 在项目package.json所在同级目录下创建文件jsconfig.json，解决使用ctrl+鼠标左键无法跳转到引入文件问题。例如 import { constantRoutes } from "@/router"; 点击router进入定义文件
{
  "compilerOptions": {
      "target": "ES6",
      "module": "commonjs",
      "allowSyntheticDefaultImports": true,
      "baseUrl": "./",
      "paths": {
        "@/*": ["src/*"]
      }
  },
  "exclude": [
      "node_modules"
  ]
}
```

### 2.6 Fix VSCode Checksums

是一款用于解决 VS Code 核心文件修改导致的插件警告问题的插件。当手动修改了 VS Code 的核心文件后，VS Code 会出现一个 [Unsupported] 标志或者弹出一个提示框。这些问题可能会影响运行和调试项目。

通过安装插件并在插件中点击 Fix Checksums 按钮，VSCode 的核心文件校验和将得到自动调整，之后我们只需重新启动 VSCode 即可消除这些插件警告问题。


### 2.7 预览插件

#### Live Server

是一个实时加载功能的服务器插件，用于实时代码调试和修改（针对HTML、CSS和JavaScript文件），能够更加高效地进行Web前端开发。

#### open in browser

只能简单地查看 HTML 页面的渲染效果，并不能进行实时修改和热重载。

#### carbon-now-sh 

将选择代码生成图片，操作：选中代码，ctrl+shift+P，输入 carbon

### 2.8 git

#### GitLens — Git supercharged

- 代码行注释：显示每个代码行最近一次提交时的作者和时间，以及提交的摘要信息。
- 显示文件历史记录：使用 GitLens 可以查看当前打开的文件的 Git 历史记录，可以方便我们回到过去某一个版本的代码。同时还可以查看当前文件的所有分支、标签等相关信息。
- 查看比较差异：可以非常方便地通过 GitLens 插件查看不同版本之间代码的变化。
- 了解分支状态：GitHub 的 Repo 让人们可以清晰地看到当前项目各个分支的状态，而 GitLens 插件也有此功能，你可以方便地知道当前分支是否已经向主干合并，或者哪些分支正在进行工作。
- 其他功能：包括追溯代码，快速查看问题引起的根源，修改和重构代码等。

#### Git History

- 查看文件历史记录：可以对一个文件的多个版本进行比较，并可通过图形方式查看文件各个版本之间的关系。
- 查看提交列表：可以查看所有提交的列表，以及每个提交的 commit id、author 和时间戳等信息。
- 搜索提交历史记录：可以根据关键字搜索提交历史记录，并可在查找结果中预览文件和版本之间的差异。
- 其他功能：包括比较两个分支之间的文件差异、撤销提交等。

### 2.9 Vim

#### Vim

#### Jumpy 

快速的光标移动

#### prettier-Code formatter

代码格式，它可以处理 JavaScript、CSS、HTML、JSON、Markdown 等语言的格式问题，并能够自动识别和正确解析这些文件类型。

#### Paste Image

链接

支持直接把图片粘贴进来，并复制到指定的文件夹。这是我认为 Typora 体验感好的杀手锏功能之一，但现在 VSCode 也支持了。

我的习惯是把图片储存在与md文档同名，且添加.assets后缀标识的文件夹下。

相比把所有图片扔到一个全局的资源文件夹，或者自动上传图床，如此配置有极大的好处。每篇文档的附件都是独立且唯一的，很好管理。比如要删除一整篇文档，或者清理未被引用的无效资源时，在一个全局文件夹里捞图片，难度不亚于大海捞针。

需要把存储的路径改为：${currentFileDir}/${currentFileNameWithoutExt}.assets。

## 3. 常见问题

- 解决换行问题：npm run lint --fix