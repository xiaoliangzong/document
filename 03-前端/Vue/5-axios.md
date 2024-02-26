# axios

## 1. 概述

### 1.1 axios

1. 概念：axios 是一个基于 promise 的 HTTP 库，

### 1.2 vue-axios

1. vue-axios 是将 axios 集成到 Vue.js 的小包装器，可以像插件一样进行安装，通过全局方法 Vue.use()使用插件；

### 1.3 注意事项

1. axios 并不是 vue 中的插件，使用时不能通过 Vue.use()安装插件，需要在原型上进行绑定，就是使用 Vue.property.axios = axios
2. 使用 vue-axios 和 axios 声明时，只能这样子写 Vue.use(VueAxios,Axios)，分开写或者顺序颠倒都不行。
3. 实战开发说明：
   - 基本不用 vue-axios；
   - axios 的定位是 HTTP 工具库，在设计上是作为前后端数据交互的接口层；是和业务无关的，不应该使用 this 和组件关联，而应该抽象 API 层出来，在 API 层里面使用 axios 就够了，没必要污染 vue 原型，这样子更符合实战开发

## 2. 安装

```javascript
npm install axios vue-axios --save
```

## 3. 调用方式

### 3.1 通过向 axios 传递相关配置来创建请求

1. 配置选项中，只有 url 是必填的。如果没有指定 method，请求将默认使用 get 方法；
2. 所有的配置项可以参考官网：[官网链接](https://javasoho.com/axios/index.html#axios-get-url-config-1)

```javascript
// 发送 POST 请求
this.axios({
  method: 'post',
  url: '/user/12345',
  headers: {'Authorization': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJhY2NvdW50IjoiYWRtaW4iLCJsb2dpbl91c2VyX2tleSI6Ijk0MmIzYjljOTllOTQ3ZTFiMDQxYWQ2ODViMzZmNjQ1IiwiaWQiOjF9.2iIVgtDB9XBRfq5hGnktLoO3KzVY3Q43I2-lpVs3Bho'}
  data: {
    firstName: 'Fred',
    lastName: 'Flintstone',
  },
})

// 获取远端图片
axios({
  method: 'get',
  url: 'http://dxiaodang.com',
  responseType: 'stream',
}).then(function (response) {
  response.data.pipe(fs.createWriteStream('ada_lovelace.jpg'))
})
```

### 3.2 使用请求方法的别名，发送请求，相当于方式 1 的封装

1. 在使用别名方法时， url、method 属性不必在配置中指定。
2. axios 支持的请求方法：（参数中为啥','在'['后边，我也不知道，是官网这样子写的，估计是写错了。）

- axios.request(config)
- axios.get(url[, config])
- axios.delete(url[, config])
- axios.head(url[, config])
- axios.options(url[, config])
- axios.post(url[, data[, config]])
- axios.put(url[, data[, config]])
- axios.patch(url[, data[, config]])

```javascript
// 为给定 ID 的 user 创建请求
axios
  .get('/user?ID=12345')
  .then(function (response) {
    console.log(response)
  })
  .catch(function (error) {
    console.log(error)
  })

// 上面的请求也可以这样做，进行传参数的时候用的是 params
axios
  .get('/user', {
    params: {
      ID: 12345,
    },
  })
  .then(function (response) {
    console.log(response)
  })
  .catch(function (error) {
    console.log(error)
  })
```

## 4. 实例

> vue 整合 axios，从入门到实战开发，总共讲三种用法；其中用法 1 2，简单入门，便于理解，直接将 axios 绑定在 vue 实例上，在组件文件的 methods 中直接使用两种调用方式即可；用法 3 时基于实战，抽象 api 层，可以达到共用的效果

- 用法 1：只使用 axios
- 用法 2：使用 vue-axios 和 axios 结合
- 用法 3：实战开发，定义 api 层，配置全局默认值，而不是将 axios 绑定在 vue 实例上

### 4.1 方式一

```javascript
// 1. 在主入口文件main.js中，导入依赖、使用声明加载
import Axios from 'axios'
Vue.prototype.axios = Axios

// 2. 在组件文件的methods中直接使用--调用方式（通过向 axios 传递相关配置来创建请求）
axios({
  method: 'post',
  url: '/user/12345',
  data: {
    firstName: 'Fred',
    lastName: 'Flintstone',
  },
}).then((response) => {
  console.log(response)
})
```

### 4.2 方式二

```javascript
// 1. 在主入口文件main.js中，导入依赖、使用声明加载
import axios from "axios";
import VueAxios from "vue-axios";
Vue.use(VueAxios, axios);

// 3. 在组件文件的methods中直接使用--调用方式（通过别名的方式）
<script>
export default {
    name: "Login",
    components: {},
    data() {
    },
    created() {     // 钩子函数，在实例创建完成后执行的钩子
        this.getCaptcha();
    },
    methods: {
        getCaptcha(){
            this.axios.get('api/captchaImage').then((response)=>{
                 this.newsList=response.data.data;
            }).catch((response)=>{
                console.log(response);
            });
        }
    },
    computed: {},
}
</script>
```

### 4.3 方式三

> 实战使用，封装成模块化，把 axios 放到 util.js 里面, 把 axios 挂载到 window 对象而不是 Vue 实例对象上，再在入口 js 文件里引入 util.js 就行了，这样做, 其一可以避免污染 vue 原型, 其二可以在 this 不指向 vue 实例时照常使用 axios
