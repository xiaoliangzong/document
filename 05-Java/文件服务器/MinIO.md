#  MinIO

## 简介

[MinIO🔍](https://min.io/ "Minio官网") 是一个基于Apache License v2.0开源协议的对象存储服务。它兼容亚马逊S3云存储服务接口，非常适合于存储大容量非结构化的数据，例如图片、视频、日志文件、备份数据和容器/虚拟机镜像等，而一个对象文件可以是任意大小，从几kb到最大5T不等。

MinIO是一个非常轻量的服务，可以很简单的和其他应用的结合，类似 NodeJS、Redis 或者 MySQL。目前支持JavaScript 、Java、Python、Golang、.NET。

MinIO 是一款高性能、分布式的对象存储系统。它是一款软件产品，可以100%的运行在标准硬件。即X86等低成本机器也能够很好的运行MinIO。

MinIO与传统的存储和其他的对象存储不同的是：它一开始就针对性能要求更高的私有云标准进行软件架构设计。因为MinIO一开始就只为对象存储而设计。所以他采用了更易用的方式进行设计，它能实现对象存储所需要的全部功能，在性能上也更加强劲，它不会为了更多的业务功能而妥协，失去MinIO的易用性、高效性。 这样的结果所带来的好处是：它能够更简单的实现局有弹性伸缩能力的原生对象存储服务。

MinIO在传统对象存储用例（例如辅助存储，灾难恢复和归档）方面表现出色。同时，它在机器学习、大数据、私有云、混合云等方面的存储技术上也独树一帜。当然，也不排除数据分析、高性能应用负载、原生云的支持。

在中国：阿里巴巴、腾讯、百度、中国联通、华为、中国移动等等9000多家企业也都在使用MinIO产品

MinIO现在也是CNCF成员，在云原生存储部分和ceph等一起作为目前的解决方案之一。


## 优点

1. 高性能  
   MinIO 是全球领先的对象存储先锋，目前在全世界有数百万的用户。在标准硬件上，读/写速度上高达183 GB / 秒 和 171 GB / 秒。
   对象存储可以充当主存储层，以处理Spark、Presto、TensorFlow、H2O.ai等各种复杂工作负载以及成为Hadoop HDFS的替代品。
   MinIO用作云原生应用程序的主要存储，与传统对象存储相比，云原生应用程序需要更高的吞吐量和更低的延迟。而这些都是MinIO能够达成的性能指标。

2. 可扩展性   
   MinIO利用了Web缩放器的来之不易的知识，为对象存储带来了简单的缩放模型。 这是我们坚定的理念 “简单可扩展.” 在 MinIO，扩展从单个群集开始，该群集可以与其他MinIO群集联合以创建全局名称空间, 并在需要时可以跨越多个不同的数据中心。 通过添加更多集群可以扩展名称空间, 更多机架，直到实现目标。

3. 云的原生支持  
   MinIO 是在过去4年的时间内从0开始打造的一款软件，符合一切原生云计算的架构和构建过程，并且包含最新的云计算的全新的技术和概念。 其中包括支持Kubernetes 、微服和多租户的的容器技术。使对象存储对于 Kubernetes更加友好。

4. 开放全部源代码 + 企业级支持
   MinIO 基于Apache V2 license 100% 开放源代码 。 这就意味着 MinIO的客户能够自动的、无限制、自由免费使用和集成MinIO、自由的创新和创造、 自由的去修改、自由的再次发行新的版本和软件. 确实, MinIO 强有力的支持和驱动了很多世界500强的企业。 此外，其部署的多样性和专业性提供了其他软件无法比拟的优势。

5. 与Amazon S3兼容  
   亚马逊云的 S3 API（接口协议） 是在全球范围内达到共识的对象存储的协议，是全世界内大家都认可的标准。 MinIO 在很早的时候就采用了 S3 兼容协议，并且MinIO 是第一个支持 S3 Select 的产品. MinIO对其兼容性的全面性感到自豪， 并且得到了 750多个组织的认同, 包括Microsoft Azure使用MinIO的S3网关 - 这一指标超过其他同类产品的总和

6. 简单  
   极简主义是MinIO的指导性设计原则。简单性减少了出错的机会，提高了正常运行时间，提供了可靠性，同时简单性又是性能的基础。 只需下载一个二进制文件然后执行，即可在几分钟内安装和配置MinIO。 配置选项和变体的数量保持在最低限度，这样让失败的配置概率降低到接近于0的水平。 MinIO升级是通过一个简单命令完成的，这个命令可以无中断的完成MinIO的升级，并且不需要停机即可完成升级操作 - 降低总使用和运维成本。
    全世界增长最快的对象存储系统

 ## Docker 部署

 ```sh
 docker run -p 10000:9000 -p 10001:9001 -d --name=minio --restart=always -v /usr/local/fengpin-soft/minio/data:/data  -v /usr/local/fengpin-soft/minio/config:/root/.minio  -e "MINIO_ROOT_USER=root" -e "MINIO_ROOT_PASSWORD=root@server1"  quay.io/minio/minio server /data --console-address ":9001"
 ```   

## 使用

1. pom.xml 配置

```xml
<dependency>
    <groupId>io.minio</groupId>
    <artifactId>minio</artifactId>
    <version>8.2.1</version>
</dependency>
```

2. yml 配置

```yml
minio:
  endpoint: 192.168.100.98
  port: 10000
  accessKey: admin
  secretKey: root@server2
  secure: false
  bucketName: test
```

3. 配置类

```java
package com.fp.epower.config;

import io.minio.MinioClient;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

/**
 * @ClassName MinioConfig
 * @Description Minio配置类
 * @Author amx
 * @Date 2022/7/22 6:07 下午
 **/
@ConfigurationProperties(prefix = "minio")
@Data
@Component
public class MinioConfig {

    /**
     * 端点 ip
     */
    private String endpoint;

    /**
     * 端口
     */
    private int port;

    /**
     * accessKey
     */
    private String accessKey;

    /**
     * secretKey
     */
    private String secretKey;

    /**
     * 安全
     */
    private Boolean secure;

    /**
     * 桶名
     */
    private String bucketName;

    @Bean
    public MinioClient getMinioClient(){
        MinioClient minioClient = MinioClient.builder()
                .endpoint(endpoint,port,secure)
                .credentials(accessKey,secretKey)
                .build();
        return minioClient;
    }
}
```

4. 工具类

```java
package com.fp.epower.utils;

import com.fp.epower.config.MinioConfig;
import io.minio.*;
import io.minio.http.Method;
import io.minio.messages.Bucket;
import io.minio.messages.DeleteObject;
import io.minio.messages.Item;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

import javax.annotation.Resource;
import java.io.ByteArrayInputStream;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.util.*;

/**
 * @ClassName MinioUtils
 * @Description Minio工具类
 * @Author amx
 * @Date 2022/7/22 6:18 下午
 **/
@Component
@Slf4j
public class MinioUtils {

    @Resource
    private MinioClient minioClient;
    @Resource
    private MinioConfig minioConfig;


    /*********************************** Bucket操作 ***********************************/

    /**
     * 创建bucket
     * 命名规则：https://docs.aws.amazon.com/AmazonS3/latest/userguide/bucketnamingrules.html
     * 1.Bucket names must be between 3 (min) and 63 (max) characters long.
     * 2.Bucket names can consist only of lowercase letters, numbers, dots (.), and hyphens (-).
     * 3.Bucket names must begin and end with a letter or number.
     * 4.Bucket names must not contain two adjacent periods.
     * 5.Bucket names must not be formatted as an IP address (for example, 192.168.5.4).
     * 6.Bucket names must not start with the prefix xn--.
     * 7.Bucket names must not end with the suffix -s3alias. This suffix is reserved for access point alias names. For more information, see Using a bucket-style alias for your access point.
     * 8.Bucket names must be unique across all AWS accounts in all the AWS Regions within a partition. A partition is a grouping of Regions. AWS currently has three partitions: aws (Standard Regions), aws-cn (China Regions), and aws-us-gov (AWS GovCloud (US)).
     * 9.A bucket name cannot be used by another AWS account in the same partition until the bucket is deleted.
     * 10.Buckets used with Amazon S3 Transfer Acceleration can't have dots (.) in their names. For more information about Transfer Acceleration, see Configuring fast, secure file transfers using Amazon S3 Transfer Acceleration.
     *
     * @throws Exception
     */
    public void createBucket(String bucketName) throws Exception {
        if (!bucketExists(bucketName)) {
            minioClient.makeBucket(MakeBucketArgs.builder().bucket(bucketName).build());
        }
    }

    /**
     * 判断Bucket是否存在，true：存在，false：不存在
     *
     * @return
     * @throws Exception
     */
    public boolean bucketExists(String bucketName) throws Exception {
        return minioClient.bucketExists(BucketExistsArgs.builder().bucket(bucketName).build());
    }

    /**
     * 获得Bucket的策略
     *
     * @param bucketName
     * @return
     * @throws Exception
     */
    public String getBucketPolicy(String bucketName) throws Exception {
        String bucketPolicy = minioClient
                .getBucketPolicy(
                        GetBucketPolicyArgs
                                .builder()
                                .bucket(bucketName)
                                .build()
                );
        return bucketPolicy;
    }

    /**
     * 获得所有Bucket列表
     *
     * @return
     * @throws Exception
     */
    public List<Bucket> getAllBuckets() throws Exception {
        return minioClient.listBuckets();
    }

    /**
     * 根据bucketName获取其相关信息
     *
     * @param bucketName
     * @return
     * @throws Exception
     */
    public Optional<Bucket> getBucket(String bucketName) throws Exception {
        return getAllBuckets().stream().filter(b -> b.name().equals(bucketName)).findFirst();
    }

    /**
     * 根据bucketName删除Bucket，true：删除成功； false：删除失败，文件或已不存在
     *
     * @param bucketName
     * @throws Exception
     */
    public void removeBucket(String bucketName) throws Exception {
        minioClient.removeBucket(RemoveBucketArgs.builder().bucket(bucketName).build());
    }


    /*********************************** 文件操作 ***********************************/

    /**
     * 创建文件夹或目录  注意： 以"/"结尾
     *
     * @param objectName 目录路径
     */
    public ObjectWriteResponse createDir(String objectName) throws Exception {
        return minioClient.putObject(
                PutObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .stream(new ByteArrayInputStream(new byte[]{}), 0, -1)
                        .build());
    }


    /**
     * 使用MultipartFile进行文件上传
     *
     * @param file        文件名
     * @param objectName  对象名
     * @param contentType 类型
     * @return
     * @throws Exception
     */
    public ObjectWriteResponse uploadFile(MultipartFile file,
                                          String objectName, String contentType) throws Exception {
        InputStream inputStream = file.getInputStream();
        return minioClient.putObject(
                PutObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .contentType(contentType)
                        .stream(inputStream, inputStream.available(), -1)
                        .build());
    }

    /**
     * 上传本地文件
     *
     * @param objectName 对象名称
     * @param fileName   本地文件路径
     */
    public ObjectWriteResponse uploadFile(String objectName,
                                          String fileName) throws Exception {
        return minioClient.uploadObject(
                UploadObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .filename(fileName)
                        .build());
    }

    /**
     * 通过流上传文件
     *
     * @param objectName  对象名
     * @param inputStream 文件流
     */
    public ObjectWriteResponse uploadFile(String objectName, InputStream inputStream) throws Exception {
        return minioClient.putObject(
                PutObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .stream(inputStream, inputStream.available(), -1)
                        .build());
    }

    /**
     * 判断文件是否存在
     *
     * @param objectName 对象名
     * @return
     */
    public boolean isObjectExist(String objectName) {
        boolean exist = true;
        try {
            minioClient.statObject(StatObjectArgs.builder().bucket(minioConfig.getBucketName()).object(objectName).build());
        } catch (Exception e) {
            exist = false;
        }
        return exist;
    }

    /**
     * 判断文件夹是否存在
     * 此处不用带"/" 否则虽然可以查出来路径 但是idDir()为false  不带"/"可以查询目录和目录下所有文件 然后再通过idDir()和目录路径判断即可
     * @param folderName 文件夹名称
     * @return
     */
    public boolean isFolderExist(String folderName) {
        boolean exist = false;
        try {
            Iterable<Result<Item>> results = minioClient.listObjects(
                    ListObjectsArgs.builder().bucket(minioConfig.getBucketName()).prefix(folderName).recursive(false).build());
            for (Result<Item> result : results) {
                Item item = result.get();
                if (item.isDir() && (folderName+"/").equals(item.objectName())) {
                    return true;
                }
            }
        } catch (Exception e) {
            exist = false;
        }
        return exist;
    }

    /**
     * 根据文件前缀查询文件
     *
     * @param prefix    前缀
     * @param recursive 是否使用递归查询
     * @return MinioItem 列表
     * @throws Exception
     */
    public List<Item> getAllObjectsByPrefix(String prefix,
                                            boolean recursive) throws Exception {
        List<Item> list = new ArrayList<>();
        Iterable<Result<Item>> objectsIterator = minioClient.listObjects(
                ListObjectsArgs.builder().bucket(minioConfig.getBucketName()).prefix(prefix).recursive(recursive).build());
        if (objectsIterator != null) {
            for (Result<Item> o : objectsIterator) {
                Item item = o.get();
                list.add(item);
            }
        }
        return list;
    }

    /**
     * 获取文件流
     *
     * @param objectName 对象名
     * @return 二进制流
     */
    public InputStream getObject(String objectName) throws Exception {
        return minioClient.getObject(GetObjectArgs.builder().bucket(minioConfig.getBucketName()).object(objectName).build());
    }

    /**
     * 断点下载
     *
     * @param objectName 文件名称
     * @param offset     起始字节的位置
     * @param length     要读取的长度
     * @return 二进制流
     */
    public InputStream getObject(String objectName, long offset, long length) throws Exception {
        return minioClient.getObject(
                GetObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .offset(offset)
                        .length(length)
                        .build());
    }


    /**
     * 删除文件
     *
     * @param objectName 对象名
     */
    public void removeFile(String objectName) throws Exception {
        minioClient.removeObject(
                RemoveObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .build());
    }

    /**
     * 批量删除文件
     *
     * @param keys 需要删除的文件列表
     * @return
     */
    public void removeFiles(List<String> keys) {
        List<DeleteObject> objects = new LinkedList<>();
        keys.forEach(s -> {
            objects.add(new DeleteObject(s));
            try {
                removeFile(s);
            } catch (Exception e) {
                log.error("批量删除失败！error:{}", e);
            }
        });
    }


    /**
     * 获取路径下文件列表
     *
     * @param prefix    文件名称
     * @param recursive 是否递归查找，false：模拟文件夹结构查找
     * @return 二进制流
     */
    public Iterable<Result<Item>> listObjects(String prefix,
                                              boolean recursive) {
        return minioClient.listObjects(
                ListObjectsArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .prefix(prefix)
                        .recursive(recursive)
                        .build());
    }


    /**
     * 获取文件信息, 如果抛出异常则说明文件不存在
     *
     * @param objectName 文件名称
     */
    public String getFileStatusInfo(String objectName) throws Exception {
        return minioClient.statObject(
                StatObjectArgs.builder()
                        .bucket(minioConfig.getBucketName())
                        .object(objectName)
                        .build()).toString();
    }

    /**
     * 拷贝文件
     *
     * @param objectName    文件名
     * @param srcBucketName 目标存储桶
     * @param srcObjectName 目标文件名
     */
    public ObjectWriteResponse copyFile(String objectName,
                                        String srcBucketName, String srcObjectName) throws Exception {
        return minioClient.copyObject(
                CopyObjectArgs.builder()
                        .source(CopySource.builder().bucket(minioConfig.getBucketName()).object(objectName).build())
                        .bucket(srcBucketName)
                        .object(srcObjectName)
                        .build());
    }


    /**
     * 获取文件外链
     *
     * @param objectName 对象名
     * @param expires    过期时间 <=7 秒 （外链有效时间（单位：秒））
     * @return url
     * @throws Exception
     */
    public String getObjectUrl(String objectName, Integer expires) throws Exception {
        GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder().expiry(expires).bucket(minioConfig.getBucketName()).object(objectName).build();
        return minioClient.getPresignedObjectUrl(args);
    }

    /**
     * 获得文件外链
     *
     * @param objectName 对象名称
     * @return url
     * @throws Exception
     */
    public String getObjectUrl(String objectName) throws Exception {
        GetPresignedObjectUrlArgs args = GetPresignedObjectUrlArgs.builder()
                .bucket(minioConfig.getBucketName())
                .object(objectName)
                .method(Method.GET).build();
        return minioClient.getPresignedObjectUrl(args);
    }

    /**
     * 将URLDecoder编码转成UTF8
     *
     * @param str
     * @return
     * @throws UnsupportedEncodingException
     */
    public static String getUtf8ByURLDecoder(String str) throws UnsupportedEncodingException {
        String url = str.replaceAll("%(?![0-9a-fA-F]{2})", "%25");
        return URLDecoder.decode(url, "UTF-8");
    }


}
```


5. 测试类

```java
package com.fp.epower.utils;

import com.alibaba.fastjson.JSON;
import io.minio.ObjectWriteResponse;
import io.minio.messages.Bucket;
import io.minio.messages.Item;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.io.FileInputStream;
import java.util.List;


/**
 * @ClassName MinioUtilsTest
 * @Description Minio工具类测试类
 * @Author amx
 * @Date 2022/7/26 4:08 下午
 **/
@SpringBootTest
public class MinioUtilsTest {

    @Autowired
    private MinioUtils minioUtils;


    @Test
    public void test() throws Exception {
        String bucketName = "test-bucket";

        String filePath = "/Users/amxliuli/Desktop/test.png";
        String objectName = "inputStream.png";
        String folderName = "test/";

        //桶测试
//        //1. 创建桶
//        System.out.println("创建bucket:" + bucketName);
//        minioUtils.createBucket(bucketName);
//        //2. 查询桶是否存在
//        System.out.println(bucketName + "是否存在：" + minioUtils.bucketExists(bucketName));
//        //3. 查询桶的策略
//        System.out.println(bucketName + "桶的策略为:" + minioUtils.getBucketPolicy(bucketName));
//        //4. 获取所有的桶
//        System.out.println("获取所有的桶：" );
//        minioUtils.getAllBuckets().stream().map(item -> item.name() ).forEach(System.out::println);
//        //5. 根据桶名获取桶
//        Bucket bucket = minioUtils.getBucket(bucketName).get();
//        System.out.println("获取桶：" + bucketName + "的相关信息如下：" + JSON.toJSONString(minioUtils.getBucket(bucketName).get().name()));
//        //6. 删除桶
//        System.out.println("删除桶:" + bucketName);
//        minioUtils.removeBucket(bucketName);
//
//        //文件测试
//
//        //1. 创建目录
//        ObjectWriteResponse response = minioUtils.createDir(folderName);
//        System.out.println("创建目录" + folderName + ":" + response.object());
//
//        //2. 上传本地文件
//        ObjectWriteResponse objectResponse = minioUtils.uploadFile(objectName, filePath);
//        System.out.println("上传本地文件" + objectName + ":" + objectResponse.object());
//        //3. 输入流上传
        FileInputStream inputStream = new FileInputStream(filePath);
        ObjectWriteResponse inputStreamResponse = minioUtils.uploadFile(folderName+"inputStream.png",inputStream);
        System.out.println("输入流上传文件inputStream.png" + inputStreamResponse.object());
//        //4. 查询文件是否存在
//        System.out.println("是否查询到对象"+objectName+":"+minioUtils.isObjectExist(objectName));
//        //5. 判断文件夹是否存在
//        System.out.println("是否存在文件夹"+folderName+":"+minioUtils.isFolderExist("test"));
//        //6. 获取文件流
//        System.out.println("获取到文件流：" +minioUtils.getObject(folderName+"inputStream.png") );
//        //7. 列出所有对象
//        minioUtils.listObjects("up",true).forEach(System.out::println);
//        //8. 获取文件链接地址
//        System.out.println(objectName+"的链接地址为：" + minioUtils.getObjectUrl(objectName));
//        //9. 获取文件信息
//        System.out.println(objectName+"的文件信息为：" + minioUtils.getFileStatusInfo(objectName));
//        //10. 查询文件下文件列表
//        List<Item> allObjects = minioUtils.getAllObjectsByPrefix("/", true);
//        for(Item item : allObjects){
//            System.out.println(item.objectName());
//        }
    }
}

```