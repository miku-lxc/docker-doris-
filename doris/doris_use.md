四、具体使用

1.修改密码

初次登陆默认root，无需密码，极为不安全，所以对用户进行操作和赋予权限

#通过 root 或 admin 用户连接到 Doris 集群

mysql -h FE_HOST -P9030 -uroot

#对原有的root密码进行修改
SET PASSWORD FOR 'root' = PASSWORD('your_password');

##要用到多用户的情况，需创建用户，对不通用户进行授权

#创建用户
CREATE USER 'test' IDENTIFIED BY 'test_passwd';
  #后续的登录方式
mysql -h FE_HOST -P9030 -utest -ptest_passwd

#授权
GRANT ALL ON example_db TO test; #其中example_db 是你要赋予权限的数据库，这里只展示数据库单独的授权

2.数据库操作（和mysql类似后续不做说明）

1.创建数据库
CREATE DATABASE example_db;
 SHOW DATABASES; 
#如有疑问命令前面加help 查看帮助 或者自行维基/百度

2.创建表
USE example_db;
单分区
CREATE TABLE table1
(
    siteid INT DEFAULT '10',
    citycode SMALLINT,
    username VARCHAR(32) DEFAULT '',
    pv BIGINT SUM DEFAULT '0'
)
AGGREGATE KEY(siteid, citycode, username)
DISTRIBUTED BY HASH(siteid) BUCKETS 10    #分桶列卫siteid相当于主键 分桶数为10 
PROPERTIES("replication_num" = "1");  
###上面定义数据类型啥的和sql，mysql类似不做详细说明

复合分区 
REATE TABLE table2
(
    event_day DATE,
    siteid INT DEFAULT '10',
    citycode SMALLINT,
    username VARCHAR(32) DEFAULT '',
    pv BIGINT SUM DEFAULT '0'
)
AGGREGATE KEY(event_day, siteid, citycode, username)
PARTITION BY RANGE(event_day)。#分区 括号里的是分区列
(
    PARTITION p201706 VALUES LESS THAN ('2017-07-01'),
    PARTITION p201707 VALUES LESS THAN ('2017-08-01'),
    PARTITION p201708 VALUES LESS THAN ('2017-09-01')
)
DISTRIBUTED BY HASH(siteid) BUCKETS 10
PROPERTIES("replication_num" = "1");
#注意自己的分区区间

3.查询

简单查询 jion 查询 子查询

4.数据导入/导出

 1.数据导入
  1.1Broker load：将外部数据导入到Doris，入hdfs，为异步导入
  由FE生成对应的执行计划，分发给BE进行执行，BE会从文件系统拉取数据，对数据进行转换后导入到系统，反馈给FE结果，由FE确认是否完成。
  
  1.2Stream Load：通过http协议导入，主要将文件导入到doris，为同步导入
  通过发送http协议将文件导入到doris中，同步导入并返回结果，主要用来导入本地文件，支持csv和json格式。
  用户提交导入请求后，会直接提交给FE,FE会将请求redirect一个BE进行处理，最终结果由BE返回。
      url --location-trusted -u user:passwd [-H ""...] -T data.file -
      XPUT http://fe_host:http_port/api/{db}/{table}/_stream_load

  
  1.3.Routine Load:自动从数据源导入，只支持Kafka
  从数据源中监听导入数据，仅支持kafka，消息格式为csv或json。
  用户提交请求到FE，FE会将作业拆分成多个Task，每个Task负责导入一部分，Task分配到BE执行，BE中Task作为一个Stream load任务导入
  完成后想FE汇报，FE根据汇报结果继续生成新的Task，不断生成新的Task完成数据的持续导入。
  
      CREATE ROUTINE LOAD test_db.kafka_test ON student_kafka
      COLUMNS TERMINATED BY ",",
      COLUMNS(id, name, age)
      PROPERTIES
      ( "
      desired_concurrent_number"="3",
      "strict_mode" = "false"
      )
      FROM KAFKA
      (
      "kafka_broker_list"= "hadoop1:9092,hadoop2:9092,hadoop3:9092",
      "kafka_topic" = "test_doris1",
      "property.group.id"="test_doris_group",
      "property.kafka_default_offsets" = "OFFSET_BEGINNING",
      "property.enable.auto.commit"="false"
      );


  1.4.Binlog Load：通过监听binlog日志进行导入
  提供一种CDC功能，依赖Canal，伪装成从节点从主节点同步Binlog进行解析，Doris在获取解析好的数据。
  前提是需要安装Canal并且Mysql开启Binlog
      

  
  1.5Insert Into ：通过insert into select 或者insert into values（禁止使用） 的形式导入数据
  insert into支持两种写法，insert into select ：建议使用。insert into values：不建议使用，Doris官方文档中有说明。
  
      INSERT INTO tbl2 WITH LABEL label1 SELECT * FROM tbl3;

  1.6 s3协议：类似于broker load，异步导入
  Doris支持通过S3协议的形式导入数据，如百度云的 BOS、阿里云的OSS和腾讯云的 COS 等。



2.数据导出
  
  1.Export导出:将指定表或分区以文本的形式导出到存储系统中，如：HDFS
  
        export table example_site_visit2
        to "hdfs://mycluster/doris-export"
        PROPERTIES
        (
        "label" = "mylabel",
        "column_separator"="|",
        "timeout" = "3600"
        )
        WITH BROKER "broker_name"
        (
        #HDFS 开启 HA 需要指定，还指定其他参数
        "dfs.nameservices"="mycluster",
        "dfs.ha.namenodes.mycluster"="nn1,nn2,nn3",
        "dfs.namenode.rpc-address.mycluster.nn1"= "hadoop1:8020",
        "dfs.namenode.rpc-address.mycluster.nn2"= "hadoop2:8020",
        "dfs.namenode.rpc-address.mycluster.nn3"="hadoop3:8020",
        "dfs.client.failover.proxy.provider.mycluster"="org.apache.hadoop
        .hdfs.server.namenode.ha.ConfiguredFailoverProxyProvider"
        );

    
    
    
  2.查询结果导出：将查询的结果导出到存储系统中
 
        SELECT * FROM example_site_visit
        INTO OUTFILE "hdfs://hadoop1:8020/doris-out/broker_a_"
        FORMAT AS CSV
        PROPERTIES
        (
        "broker.name" = "broker_name",
        "column_separator" = ",",
        "line_delimiter" = "\n",
        "max_file_size" = "100MB"
        );
