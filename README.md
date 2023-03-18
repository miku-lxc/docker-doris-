# docker-doris-
This is a  project about docker and doris .it is using programer of shell in this project.it can to come autemactic running of 'doris'.    

一、总体思路
  
  0.简介
  本次实施主要是编写shell脚本，将
  
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
    
    2.2.doris
    doris是一个基于mmp架构的实时数据分析的仓库，具有亚秒级别的响应时间，返回海量数据。使用场景很多，支持多种数据源，技术架构上分为fe和be，fe做查询解析 无数据的节点管理、用户接入等 而be负责数据存储和查询计划。
    它起源于百度的palo项目后交给apache基金会进行孵化。适合OLAP数据分析。其余见官网介绍
    
    2.3.docker
    docker是go语言开的用于pass平台即服务，对lxc技术的高级封装，它具有部署快速、轻量级、资源耗用底、交付快速、轻量级管理。其中容器的概念可以理解为一个集装箱。docker使用的虚拟化技术是不包括内核的，只提供roots ，内核bootfs是有宿主机进行提供的，这就造成了容器和虚拟机的本质差别，同时也是它之所以如此轻量的原因。docker主要包括：数据管理、镜像管理、网络管理、自动化部署编排、镜像构建等。相关详细介绍参考百度/维基。
    
    2.4.dockerfile
    dockerfile是docker的镜像制作，这是比手动使用更高的自动化制作的一种，将部署的指令写入到Dockerfile进行制作相当于脚本，具有脚本化、企业化、自动化、模版化等。其中的一些主要参数有指定基础镜像FROM  制作者MAINAINER 相关指令 COPY 和 ADD 两者的区别在于是否自动解压缩 ENV设置环境变量 EXPOSE指定暴露的端口、CMD[]设置容器内的启动命令等等上述是常用的相关细节还有很多，初次之外还有设置启动脚本用于启动，自信百度/维基。
    
    
    2.5docke-compse
    docker的一种编排工具，对容器的启动部署进行编排，所使用的脚本是含有多个部署指令的合集，用于同时启动多个，实现自动化部署。docker-compose.yaml 启动时需放在指定的位置同级目录下，如果没有请用docker-compose -f up -d 进行指定位置的文件启动。
    
    2.6 公有云-云服务器
    这里只说明下，对于个人开发者学习者，建议用云服务器，便宜皮实，而且本次1部署doris都好几G，这要是自己流量，可能会消耗不了，肉痛，所以利用公网的云服务器，就不消耗了。同时有快照啥的安全，随时可以用ssh进行连接。
    

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









