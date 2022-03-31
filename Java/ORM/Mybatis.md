## MP

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
