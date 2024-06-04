# Mybatis Plus

## 1. 查询

mybtais plus 分页：Page<T>对象

查询个别字段：QueryWrapper.select();

实体转换为 Vo 对象：Page.convert();

```java
List<TransmissionElectricityPriceVo> recordsVo = page.convert(transmissionElectricityPrice ->
        {
            TransmissionElectricityPriceVo vo = new TransmissionElectricityPriceVo();
            beanCopy(transmissionElectricityPrice, vo, tradingCenterList);
            return vo;
        }).getRecords();

```

last-sql 后边追加语句


## 2. TypeHandler 不生效解决办法

1. 实体类注解 TableName  补充  autoResultMap = true

```java
@TableName(value = "task_info", autoResultMap = true)
```

2. 如果有写 mapper.xml，则 resultMap 也需要添加 

3. 自定义 TypeHandler，实现接口 TypeHandler<>，然后再字段上使用 @TableField(typeHandler = JacksonTypeOfDecimalListHandler.class)

4. 配置文件中，增加配置

```yml
mybatis-plus:
  type-handlers-package: com.fp.virtualplant.common.handler     # 处理器扫描

// 如果只是mybatis，那么添加的配置为
mybatis:
  type-handlers-package: com.fp.virtualplant.common.handler
```

