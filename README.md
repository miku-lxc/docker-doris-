# docker-doris-
This is a  project about docker and doris .it is using programer of shell in this project.it can to come autemactic running of 'doris'.    

一、总体思路
  
  0.简介
  
  本次实施主要是编写shell脚本，将docker的一些技术和doris结合起来，利用docker的容器，将doris装入容器，实现批量部署，而shell则是最底层的，负责将docker的
  镜像构建、compose部署、准备环境、相关指令 等都集中在一个脚本中，从而实现批量部署的目的，在脚本中加上里一些交互，比上一次的hadoop搭建更加人性化。有了很大的改变
  
  2.技术解释
  
    2.1.shell
  
    Shell 是一个用 C 语言编写的程序，它是用户使用 Linux 的桥梁。Shell 既是一种命令语言，又是一种程序设计语言。
    Shell 是指一种应用程序，这个应用程序提供了一个界面，用户通过这个界面访问操作系统内核的服务。
    Ken Thompson 的 sh 是第一种 Unix Shell，Windows Explorer 是一个典型的图形界面 Shell。
      Shell 脚本
    Shell 脚本（shell script），是一种为 shell 编写的脚本程序。
    业界所说的 shell 通常都是指 shell 脚本，但读者朋友要知道，shell 和 shell script 是两个不同的概念。
    由于习惯的原因，简洁起见，本文出现的 "shell编程" 都是指 shell 脚本编程，不是指开发 shell 自身
    具体的实现以及基本语法请自行维基/百度参考
    本次主要使用shell编写dockerfile的编写，实现shell脚本，自动执行dockerfile的构建以及相关文件的下载和环境准备，以及后期的构建上传到docker hub公共库
    
    2.2.doris
    doris是一个基于mmp架构的实时数据分析的仓库，具有亚秒级别的响应时间，返回海量数据。使用场景很多，支持多种数据源，
    技术架构上分为fe和be，fe做查询解析 无数据的节点管理、用户接入等 而be负责数据存储和查询计划。它起源于百度的palo项目后交给apache基金会进行孵化。
    适合OLAP数据分析。其余见官网介绍
    
    2.3.docker
    docker是go语言开的用于pass平台即服务，对lxc技术的高级封装，它具有部署快速、轻量级、资源耗用底、交付快速、轻量级管理。
    其中容器的概念可以理解为一个集装箱。docker使用的虚拟化技术是不包括内核的，只提供roots ，内核bootfs是有宿主机进行提供的，
    这就造成了容器和虚拟机的本质差别，同时也是它之所以如此轻量的原因。docker主要包括：数据管理、镜像管理、网络管理、自动化部署编排、镜像构建等。
    相关详细介绍参考百度/维基。
    
    2.4.dockerfile
    dockerfile是docker的镜像制作，这是比手动使用更高的自动化制作的一种，将部署的指令写入到Dockerfile进行制作相当于脚本，具有脚本化、企业化、自动化、模版化等。
    其中的一些主要参数有指定基础镜像FROM  制作者MAINAINER 相关指令 COPY 和 ADD 两者的区别在于是否自动解压缩 ENV设置环境变量 EXPOSE指定暴露的端口、
    CMD[]设置容器内的启动命令等等上述是常用的相关细节还有很多，初次之外还有设置启动脚本用于启动，自行百度/维基。
    
    
    2.5docke-compse
    docker的一种编排工具，对容器的启动部署进行编排，所使用的脚本是含有多个部署指令的合集，用于同时启动多个，实现自动化部署。d
    ocker-compose.yaml 启动时需放在指定的位置同级目录下，如果没有请用docker-compose -f up -d 进行指定位置的文件启动。
    
    2.6 公有云-云服务器
    这里只说明下，对于个人开发者学习者，建议用云服务器，便宜皮实，而且本次1部署doris都好几G，这要是自己流量，可能会消耗不了，肉痛。
    所以利用公网的云服务器，就不消耗了。同时有快照啥的安全，随时可以用ssh进行连接。
    

二、环境平台：
阿里云服务器：轻量级
jdk：openjdk镜像
docker vesion：23.0.1
doris fe和be


四、代码展示

  #本次项目的主要目的是实现shell 和 docker 以及doris的联合。创建dockefile 然后推送镜像到hub上，然后部署doris集群。为了就是实现总体的搭建。代码中加入了if判断，实现了代码的可循环性
对代码的内容做了一定的交互性。

  #详细的代码细节，请见脚本内部中的注释


三、结果展示


##上传docker hub仓库截图
![图片](https://user-images.githubusercontent.com/126040842/226085047-f7328b13-c6f8-4263-a474-5d87eef43dc5.png)



docker-compose部署成功截图
![图片](https://user-images.githubusercontent.com/126040842/226081437-cf4db94e-a852-4e33-897b-a28179fe64e9.png)


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


    
    
    
   






