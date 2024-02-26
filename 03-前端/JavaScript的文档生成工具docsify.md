## 1. docsify 文档网站生成器

说明：该文档就是基于 docsify 搭建的，配置简单，无需编译，只需要会 markdown 语法即可，详细配置可参考项目：[https://github.com/xiaoliangzong/document.git](https://github.com/xiaoliangzong/document.git)

**使用步骤：**

```shell
# 全局安装
npm install docsify-cli -g
# 初始化项目，初始化成功后，可以看到 ./docs 目录下创建的几个文件
docsify init ./docs
    # index.html 入口文件
    # README.md 会做为主页内容渲染，更新网站内容
    # .nojekyll 用于阻止 GitHub Pages 会忽略掉下划线开头的文件
# 运行项目
docsify serve docs
# 访问，默认端口为 3000
http://localhost:3000
```
