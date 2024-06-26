# GitLab


## 1. role permission 角色权限

GitLab的成员角色有五种

Guest(访客)：自己干自己的项目
创建项目、写留言薄，自己干自己的项目。

Reporter（报告者）：可以看别人的项目
创建项目、写留言薄、拉项目、下载项目、创建代码片段。可以看别人的项目

Developer（开发者）：可以和别人一起开发同一个项目
创建项目、写留言薄、拉项目、下载项目、创建代码片段、创建合并请求、创建新分支、推送不受保护的分支、移除不受保护的分支 、创建标签、编写wiki，可以和别人一起开发同一个项目。

Master（管理者）：管理这个项目，不能删除
创建项目、写留言薄、拉项目、下载项目、创建代码片段、创建合并请求、创建新分支、推送不受保护的分支、移除不受保护的分支 、创建标签、编写wiki、增加团队成员、推送受保护的分支、移除受保护的分支、编辑项目、添加部署密钥、配置项目钩子。

Owner（所有者）：最高权限
创建项目、写留言薄、拉项目、下载项目、创建代码片段、创建合并请求、创建新分支、推送不受保护的分支、移除不受保护的分支 、创建标签、编写wiki、增加团队成员、推送受保护的分支、移除受保护的分支、编辑项目、添加部署密钥、配置项目钩子、开关公有模式、将项目转移到另一个名称空间、删除项目。

## 2. 查询项目代码存在位置

```sh
# 1. 查看项目id，登录gitlab后台找到对应项目id
# 2. 项目id转字符串
echo -n 25 | sha256sum
# 3. 找到gitlab中项目存放的位置
find / -name b7a56873cd771f2c446d369b649430b65a756ba278ff97ec81bb6f55b2e73569.git
```


## Gitlab 利用 Hook 锁定文件不被修改

几种常见的方案：

1. 在客户端做 git hook，主要是用 pre-commit 这个钩子。前端项目中常见的 husky 就是基于此实现的。但缺点也很明显，就是在本地把这个钩子删了、或者 git commit --no-verify 就绕开了。不过小团队、大家约定好的话这种方案是最方便的。
2. 在服务端做 git hook，主要是用 pre-receive 这个钩子。
3. 不限制 push、但通过其他方式限制。比如可以通过 CI 限制，例如在 forking-workflow 模式中设置在 Merge 时自动执行一个 Actions 来执行 Lint，对于不合格的 Merge Request 直接关闭掉不允许合并，以变相到达不合格代码进入主干的目的。

其中 1、2 两点跟 GitLab 无关，需要的都是写 Shell 脚本而已。第 3 种可以在 GitLab 用图形化方式设置。小团队的第一种用的比较多；大团队这一步骤大多是跟 CI/CD 工作流紧密结合的。

### Git 钩子

服务端钩子会接受到三个参数：
    
    - 被推送的引用的名字。更新的引用名称
    - 推送前分支的修订版本（revision）。引用中存放的旧的对象名称
    - 用户准备推送的修订版本（revision）。引用中存放的新的对象名称

pre-receive

处理来自客户端的推送操作时，最先被调用的脚本是 pre-receive。 它从标准输入获取一系列被推送的引用。如果它以非零值退出，所有的推送内容都不会被接受。 你可以用这个钩子阻止对引用进行非快进（non-fast-forward）的更新，或者对该推送所修改的所有引用和文件进行访问控制。

update

update 脚本和 pre-receive 脚本十分类似，不同之处在于它会为每一个准备更新的分支各运行一次。 假如推送者同时向多个分支推送内容，pre-receive 只运行一次，相比之下 update 则会为每一个被推送的分支各运行一次。 它不会从标准输入读取内容，而是接受三个参数：引用的名字（分支），推送前的引用指向的内容的 SHA-1 值，以及用户准备推送的内容的 SHA-1 值。 如果 update 脚本以非零值退出，只有相应的那一个引用会被拒绝；其余的依然会被更新。

post-receive

post-receive 挂钩在整个过程完结以后运行，可以用来更新其他系统服务或者通知用户。 它接受与 pre-receive 相同的标准输入数据。 它的用途包括给某个邮件列表发信，通知持续集成（continous integration）的服务器， 或者更新问题追踪系统（ticket-tracking system） —— 甚至可以通过分析提交信息来决定某个问题（ticket）是否应该被开启，修改或者关闭。 该脚本无法终止推送进程，不过客户端在它结束运行之前将保持连接状态， 所以如果你想做其他操作需谨慎使用它，因为它将耗费你很长的一段时间。

## gitlab 集成 cicd

1. 仓库根目录 创建一个.gitlab-ci.yml 文件
2. 安装 gitlab-runner
