## es6

```js
function (config) {
   // 在发送请求之前做些什么
   return config;
}
(config)=>{
return config;
}

``

ES6模块主要有两个功能：export和import

export用于对外输出本模块（一个文件可以理解为一个模块）变量的接口

import用于在一个模块中加载另一个含有export接口的模块。`
```

es6 export function

data:image/gif;base64

window.URL.createObjectURL() 可以用于在浏览器上预览本地图片或者视频；
静态方法会创建一个 DOMString，其中包含一个表示参数中给出的对象的 URL。这个 URL 的生命周期和创建它的窗口中的 document 绑定。这个新的 URL 对象表示指定的 File 对象或 Blob 对象。

@keyup.enter.native

@click.native.prevent

## new Promise():

1.  Promise 是一个构造函数，自己身上有 all、reject、resolve 这几个眼熟的方法，原型上有 then、catch 等同样很眼熟的方法
2.  Promise，简单说就是一个容器，里面保存着某个未来才会结束的事件（通常是一个异步操作）的结果。从语法上说，Promise 是一个对象，从它可以获取异步操作的消息。
3.  同步的方式写异步的代码，用来解决回调问题

        console.log(JSON.parse(JSON.stringify(res.data)))
