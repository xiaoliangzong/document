1. 创建一个 sotre 文件夹，编写 index.js
2. 在全局 main.js 中引用

```js
import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

// vuex的state和vue的data比较相似，都是用于存储一些数据（状态值），这些值被挂载到数据和dom的双向绑定事件，当改变值的时候可以触发dom的更新

// state一般被挂载到子组件的computed计算属性上，改变state的值就会及时的响应给子组件
// 如果用data去接收$store.state,当然可以接收到值,但由于这只是一个简单的赋值操作,因此state中的状态改变的时候不能被vue中的data监听到,当然你也可以通过watch $store去解决这个问题

const store = new Vuex.Store({
  state: {
    // 键值对
  },
  mutations,
})

export default store

// main
new Vue({
  el: '#app',
  router,
  store, // 将store挂载到所有的Vue实例上
  components: { App },
  template: '<App/>',
})
```

3. mutation 和 action

   - 更改 Vuex 的 store 中的状态的唯一方法是提交 mutation。
   - 修改操作 state 中的值，不能直接通过 this.$store.state.xxx=yyy的方式进行修改，必须要提交给mutation处理，通过this.$store.commit('function')修改提交
   - mutation 的辅助函数:mapMutation

   > mutation 的使用场景,mutation 在使用的是请不要涉及任何异步操作,如果你想改变 count 的值,你通过 mutation 中的两个异步事件,都改变了这个状态值,你怎么知道什么时候回调和哪个先回调呢,因此 mutation 用于管理同步事件,如果有异步操作,请用 action

   - Action 提交的是 mutation，而不是直接变更状态，
   - 在 actions 可以包含任意异步操作， 并且 Action 提交的是 mutation
   - actions 可以理解为通过将 mutations 里面处里数据的方法变成可异步的处理数据的方法，简单的说就是异步操作数据（但是还是通过 mutation 来操作，因为只有它能操作）

   > this.$store.dispatch() 和 this.$store.commit()区别
   > dispatch：异步操作，发送请求时常用，对应的是 actions，
   > commit：同步操作，对应的 mutations。

4. mapState 辅助函数

当一个组件需要获取多个状态时候，将这些状态都声明为计算属性会有些重复和冗余。为了解决这个问题，我们可以使用 mapState 辅助函数帮助我们生成计算属性

```js
import { mapState } from 'vuex'

export default {
  computed: mapState({
    count: 'count', // 第一种写法
    sex: (state) => state.sex, // 第二种写法
    from: function (state) {
      // 用普通函数this指向vue实例,要注意
      return this.str + ':' + state.from
    },
    // 注意下面的写法看起来和上面相同,事实上箭头函数的this指针并没有指向vue实例,因此不要滥用箭头函数
    // from: (state) => this.str + ':' + state.from
    myCmpted: function () {
      // 这里不需要state,测试一下computed的原有用法
      return '测试' + this.str
    },
  }),
}
```

5. ...mapState 并不是 mapState 的扩展,而是...对象展开符的扩展

```js
let MapState = mapState({
  count: 'count',
  sex: (state) => state.sex,
})
let json = {
  a: '我是json自带的',
  ...MapState,
}
console.log(json)
// 这里的json可以成功将mapState return的json格式,和json自带的a属性成功融合成一个新的对象.你可以将这个称为对象混合
```

6. getters

state 统一管理,如果在 vue 中用 computed 计算属性接收这些公共状态,以便使用,然后在接收原值的基础上对这个值做出一些改造，但其他组件也要用到这个值，可能不得不去复制粘贴这个函数到别的组件。

vuex 本身就提供了类似于计算属性的方式,getters 可以让你从 store 的 state 中派生出一些新的状态，
getter 的返回值会根据它的依赖被缓存起来，且只有当它的依赖值发生了改变才会被重新计算

vuex 的 getters 和 vue 的 computed 区别：
getters 支持传参，支持函数，ES6 语法
computed 不能传参，相当于不能计算。

7. mapGetters 辅助函数和...mapGetters

很多情况下你是用不到 getters 的,请按需使用,不要用 getters 去管理 state 的所有派生状态,如果有多个子组件或者说子页面要用到,才考虑用 getters.

8. modules

使用单一的状态树，应用的所有状态会集中到一个比较大的对象。当应用变得非常复杂，store 对象就会变得非常臃肿；

为了解决这个问题，Vuex 允许我们将 store 分隔成模块（module），每个模块拥有自己的 state，mutation，action，getter，甚至是嵌套子模块

- 对于模块内部的 mutation 和 getter，接受的第一个参数是模块的局部状态对象；
- 对于模块内部的 action，局部状态通过 context.state 暴露出来，根节点状态则为 content.rootState;
- 对于模块内部的 getter，根节点状态作为第三个参数暴露出来

9. 命名空间

- namespaced: true 使其成为命名空间模块,
  在使用的时候添加模块名：this.$store.state.xxx.count
