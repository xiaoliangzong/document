## JDBC

### 1. 查询

Statement 对象的另外一个方法 executeQuery()方法执行查询 sql 语句.返回一个 ResultSet 类型的对象.

ResultSet 接口代表是的结果集,实际上就是一张表

     ResultSet接口提供了很多遍历它的内容的方法

              next()      get类型()

2.Statement 存在 sql 注入的不安全问题?

    可以使用Statement接口的一个子接口PreparedStament接口 (预编译的Statement）

    在sql字符串当中如果有数据，就先将这些数据用

一个占位符(?)来替换这个数据，然后对这个 sql 字符串进行编译,生成了 sql 语句. 最后再一次性给 sql 当中的占位符进行赋值.

    1>它的效率高于Statement。

    2> 可以防止sql注入.

如何获取 PreparedStatement 对象?

     可以使用Connection对象的prepareStatement(sql)方法来获取该对象.

如何给预编译的 sql 当中的占位符赋值？

可以使用 PreparedStatement 对象的 set 系列方法

       set类型(占位符的编号,赋值的数据值)

### 2. 事务操作

事务指的是一系列动作组成的一个最小事务逻辑单元，不可再分. (ACID)

    jdbc当中默认的是将每一个动作都当中一个事务，是自动提交事务的。可以先将jdbc当中的自动提交事务关闭，然后手动进行提交事务和事务回滚.

      如何关闭jdbc当中自动提交事务?

可以使用 Connection 的 setAutoCommit(false)方法关闭自动提交事务.

     Connection的commit()方法手动提交事务
                        的rollback()方法来回滚事务.

### 3. 批次处理

一次性执行多条 sql 语句，就称为批次处理.

1>一种批次处理使用 Statement 对象的方法(可以执行不同的 sql)

         Statement对象的addBatch()方法将一次性要执行的sql加入批次处理的缓冲区当中.

          Statement对象的executeBatch()可以一次性执行批次处理缓冲区当中的所有sql语句.

2>另一种批次处理使用 PreparedStatement 对象的方法(执行同种 sql)

            addBatch()
            executeBatch()

PreparedStatement 对象的批次处理方法只能处理同类 sql，不能是不同种类的 sql.

### 4. 封装通用查询任何表的方法

     可以使用泛型方法和反射动态将结果集当中数据赋值给相应对象的属性.

      ResultSet对象有一个方法可以获取结果集元数据

       getMetaData()可以获取结果集元数据
