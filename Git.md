## 1. 初始配置

```bash
# 1. 设置用户密码邮箱
git config --global user.name = 'dangbo'
git config --global user.email = '1456131152@qq.com'
# 2. 配置公钥
ssh-keygen -t rsa -C 'email 地址'
# 3. 查看配置，配置都是保存在本地配置文件（.gitconfig）中，默认在当前用户的根目录，如果是项目配置，则在项目的.git/config文件中
git config -l
# 4. 忽略大小写
git config core.ignorecase true
```

## 2. 基本操作

### 2.1 分支

![查看分支](../images/Tool/git-branch.png)

```bash
git branch 分支名称        # 1. 创建分支
git checkout 分支名称      # 2. 切换分支
# 3. 本地分支和远端分支相关联，当远端新建分支时，本地也有分支时，相关联
git branch --set-upstream-to=origin/<远端分支名> 本地分支名

# 4. 创建并切换分支，远端新建（已有）分支，本地创建不同名的分支开发
git checkout -b 分支名称

# 5. 远端新建（已有）分支，本地创建同名的分支开发任务，如果本地没有远程仓库对应的分支，但是又想拉取，就需要使用该命令，而不能使用git checkout -b 分支名
git checkout -t origin/dev

git push origin --delete 分支名  # 6. 删除远端分支
git branch -d 分支名             # 7. 删除分支
git branch -D 分支名             # 8. 强制删除分支
```

### 2.2 克隆

```bash
# 1. 克隆所有分支
git clone <remote_url> 文件夹名
# 2. 克隆指定分支
git clone -b 远端分支名称 <remote_url>
# 3. idea 工具(http 协议)克隆
点击 VCS -> 选择 Get from version control
# 4. 远端新建（已有）分支，本地创建不同名的分支开发
git checkout -b 本地分支 远端分支
# 5. 远端新建（已有）分支，本地创建同名的分支开发任务，如果本地没有远程仓库对应的分支，但是又想拉取，就需要使用该命令，而不能使用git checkout -b 分支名
git checkout -t origin/dev
```

### 2.3 远端仓库

```bash
git remote -h           # 1. 查看远程的所有操作命令
git remote -v           # 2. 查看详情verbose：包括远程仓库名和url
git remote show origin  # 3. 查看配置的远程仓库信息

# 4. 重新设置远程仓库（更换地址）
git remote set-url [--push] <name> <newurl> [<oldurl>]   # 方式1：以覆盖的形式操作，直接设置远程url即可，简化：git remote set-url origin xxxxx.git
git remote rm <name>                                     # 方式2：先删后加
git remote add <name> <url>

git remote set-url --delete <name> <url>      # <url>是正则表达式，因此删除时基本不用，如果存在多个远程仓库，可以在config文件中删除
git remote set-url --add <name> <url>         # 给已有远程仓库的本地仓库添加多个远程url地址，name名称必须和已存在的远程仓库名称一致，push时就可以一次性推送到所有仓库，拉取时，默认使用fetch-url，也就是添加的第一个地址，如果拉取时，需要使用后边的url，则调整config中的顺序即可

# 5. 更改远程仓库名
git remote rename <old> <new>
```

### 2.4 标签

tag 是 git 版本库的一个标记，指向某个 commit 的指针；主要用于发布版本的管理，比如一个版本发布之后，可以打上 v.1.0-Release 这样的标签。git 有两种主要类型的标签：轻量标签（lightweight）与附注标签（annotated）。

一个轻量标签很像一个不会改变的分支，它只是一个特定提交的引用；附注标签是存储在 Git 数据库中的一个完整对象。 它们是可以被校验的；其中包含打标签者的名字、电子邮件地址、日期时间；还有一个标签信息；并且可以使用 GNU Privacy Guard （GPG）签名与验证。 通常建议创建附注标签，这样可以拥有所有信息；但是如果只是想用一个临时的标签，或者因为某些原因不想要保存那些信息，轻量标签也是可用的。

tag 和 branch 区别

1. tag 对应某次 commit，是一个点，是不可移动的
2. branch 对应一系列 commit，是很多点连成的一根线，有一个 HEAD 指针，是可以依靠 HEAD 指针移动的。

```bash
# 1. 查看
git tag                       # 只查看tag标签
git tag -l [-n<num>] [--contains <commit>] [--no-contains <commit>] [<pattern>] # 查看tag, -l列表，-n2输出几行tag消息，--contains包含某次提交，pattern正则，比如查看"v1.3*"
git show <tagname>            # 查看某个tag的详细信息
git ls-remote --tags origin   # 查看远程所有的tag

git branch --contains tags/<tag>       # 查看tag在哪个分支

# 2. 创建
git tag <tagname>                         # 轻量标签，不需要使用-a、-s或-m 选项，只需要提供标签名字。如果不加commitId，表示基于本地当前分支的最后一个commit创建的tag
git tag -a <tagname> <commitId> -m  -f    # 附注标签，基于某一个commitId创建的tag，-m消息，-f如果该标签存在则替换
git push origin <origin>                  # 推送到远程仓库
git push origin --tags                    # 若存在很多未推送的本地标签，一次全部推送

# 3. 删除
git tag -d <tagname>                   # 删除本地tag
git push origin :refs/tags/<tagname>   # 删除远程分支

# 4. 检出标签，先从远端仓库拉取代码，然后查看标签，最后检出对应标签的代码
git checkout <tagname>
```

### 2.5 查看改动

```bash
git diff fileName  	# 对比工作目录和缓存区之间的不同
git diff --staged	   # 暂存区和上一此提交之间的不同
git diff HEAD 		   # 显示工作目录和上一次提交之间的不同，
git log              # 查看提交记录，该记录只包含作者，日期，提交信息
git log -p           # 查看每个commit的改动细节，包括改动文件每一行的细节
git log --stat 		# 查看改动了哪些文件
git show commit 	   # 查看具体的改动内容
```

## 3. 常用场景

### 3.1 冲突

git stash 和 git commit 都是解决冲突的途径

```bash
git stash -h                   # 查看命令帮助
git stash list                 # 查询存储列表

# 展示[<stash>]做了哪些改动
# [<stash>]格式为：stash@{$num}，比如第二个，git stash show stash@{1}；如果[<stash>]不写，默认show第一个，其他同理
git stash show [<stash>]
# 展示改动的细节
git stash show -p [<stash>]

# 增加存储；其实git stash 也是可以的，但查找时不方便识别
git stash [save] [<message>]

git stash pop [<stash>]           # 释放缓存，将缓存堆栈中的对应stash删除
git stash apply [<stash>]         # 应用缓存，但不会把存储从存储列表中删除

# 删除某个存储
git stash drop [<stash>]
# 删除所有存储
git stash clear
```

### 3.2 合并分支

```bash
# 将开发分支代码合并到master
# 1. 进入要合并的分支
git checkout master
git pull
# 2. 查看所有分支是否都pull下来了
git branch -a
# 3. 使用merge合并开发分支
git merge 分支名
# 4. 查看合并之后的状态
git status
# 5. 有冲突的话，通过IDE解决冲突
# 6. 解决冲突之后，将冲突文件提交到暂存区
git add 冲突文件
# 7. 提交merge之后的结果
git commit
# 8.本地仓库代码提交到远程仓库
git push
```

### 3.3 版本回退

`方式一：reset(不推荐)---> 重置到这个版本 ，通过移动head指针，reset之后，后边的版本就不存在了`

> 如果是多人协作，别人本地分支的版本是最新的，当别人再次 push 时，就会被重新填充，使用于回退自己本地仓库

 <img src="../images/Tool/git-reset.png" style="zoom:26%">

```bash
git log 						         # 查看要回退的版本号
git reset --hard 版本号 		   # 版本号
git push -f -u origin develop  	# 强制push到对应的远程分支

git reset --mixed ：此为默认方式，不带任何参数的 git reset，即是这种方式，它回退到某个版本， 只保留源码，回退 commit 和 add 信息
git reset --soft：回退到某个版本， 只回退了 commit 的信息 。如果还要提交，直接 commit 即可
git reset --hard：彻底回退到某个版本，本地的源码也会变为上一个版本的内容，慎用！
```

`方式二：revert（推荐）---> 还原此版本做出的变更，只针对某一个版本`

> 不会把版本往前回退，而是生成一个新的版本。所以，你只需要让别人更新一下代码就可以了，你之前操作的提交记录也会被保留下来
>
> 适用场景： 如果我们想撤销之前的某一版本，但是又想保留该目标版本后面的版本，记录下这整个版本变动流程，就可以用这种方法。

<img src="../images/Tool/git-revert.png" style="zoom:28%">

```shell
git log 						# 找到误提交之前的版本号
git revert -n 版本号			  # 恢复
git commit -m "提交"
git push 推送到远程
```

## 4. 常用问题

### 4.1 本地初始化 init 仓库之后，关联远端仓库报错

- 报错 fatal: branch 'master' does not exist，说明本地仓库没有在 master 分支上，需要 git checkout master
- 报错 fatal: refusing to merge unrelated histories，使用 --allow-unrelated-histories 强行合并或 git pull --rebase
- 报错 error: failed to push some refs to 'git@gitee.com:dangb/git-study.git'，因为在创建仓库时，勾选 Readme 文件初始化这个仓库，这个操作会初始化 readme 文件和.gitignore 文件。也就是做一次初始提交，本地和远程两端都有内容，且没有联系，因此推送或拉取时，都会有未被跟踪的内容。解决：git pull --rebase，git push 或不初始化 readme 文件

```bash
git init # 初始化
git remote add origin xxx.git # 关联
git branch --set-upstream-to=origin/master master  # 设置上游分支，可能报错 fatal: branch 'master' does not exist
git checkout master           # 本地仓切换到master
git pull --rebase             #

--allow-unrelated-histories   # 把两段不相干的 分支进行强行合并，比如 git pull --allow-unrelated-histories
```

### 4.2 git Failed to connect to 127.0.0.1 port 1181: Connection refused

用 git 拉取代码时，出现了该错误，经过百度得知：是因为我自己安装了外网插件，导致自动设置代理了

```sh
# 查一下代理（https同理）
git config --global http.proxy

# 有就取消
git config --global --unset http.proxy
```

### 4.3 git 默认大小写不敏感，即忽略大小写

在修改文件夹大小写后，默认提不上去，是因为 git 忽略大小写

```sh
# 查看大小写配置（core.ignore属性）
git config -l

# 修改
git config core.ignore false
```

### 4.4 push 报错

1. 强制推送（名称不一致）：git push -u origin 本地分支:远程分支

   > git push -u origin master
   > 这种方式无需确保远端相应分支存在，因为不存在的话，会自动创建该分支并与本地分支进行关联
   > git push -u origin master -f 强制推送

2. 设置 upStream：git push --set-upstream 远端名称 远端分支
