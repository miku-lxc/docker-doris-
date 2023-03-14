#!/bin/bash

:<<!
本次的docker环境下，在本目录docker-build ，目录如下：docker -build ——》be -》{dockerfile,resource/{init_be.sh,apache-doris-x.x.x-bin-be.tar.gz} 说明：启动及注册脚本以及二进制包
#分为be和be，be架构负责：查询解析、无数据、节点管理、负责用户接入 而be：有数据存储 查询计划
!

##shell脚本中的注释方法参考上面的多行注释:<<!   !

#构建fe的相关文件 
mkdir /miku/docker-build/fe/resource
touch /miku/docker-build/fe/Dockerfile  
#touch /miku/docker-build/fe/init_fe.sh 使用官方的这里自己无需创建

#以下命令到docker-build的fe下进行执行
cd /miku/docker-build/fe/

#判断是否有对应的文件，如果没有则进行创建
if [ ! -f '/miku/docker-build/fe/Dockerfile' ]
then
	echo '不存在Dockerfile'
	echo "请问是否需要进行自定义创建，创建请输入y"
	read if_y
	if if_y == 'y'
	then
		touch Dockerfile
	else
		echo '你选择了不进行自动创创建'
	fi
else
	echo '文件已经存在了'
fi


echo '你当前的pwd：/miku/docker-build/fe'
#由于有环境变量对特殊字符会直接生效，可以用echo和printf但是考虑指定用sed
path_d1='./resource/apache-doris-fe-1.2.2-bin-x86_64.tar.gz /opt/'
path_d2='apache-doris-fe-1.2.2-bin-x86_64 /opt/apache-doris/fe'
#wget -cP /miku/docker-build/fe/resource/ https://github.com/apache/doris/blob/f1dde20315bebad1f685a512a983a52243e9bba3/docker/runtime/fe/resource/init_fe.sh

#由于官网的包是xz的，dockerile的add不支持所以下解压工具然后再压缩文件为tar


cat >>Dockerfile << EOF
#注意有全局变量的在EOF中是会自动生效的所以可以利用这个性质自己设置全局 用‘’使里面的不生效
#选择基础镜像 不需要你手动去下载
FROM openjdk:8u342-jdk 

#设置环境变量:因为有全局变量在上面使用echo添加
#这里选择sed按行号进行指定加入
#使用ADD相当于添加或者解压
RUN mkdir -p /opt/apache-doris/fe/bin

ADD $path_d1

#用yum有问题这里用apt
RUN apt-get update && \
    apt-get install -y default-mysql-client && \
    apt-get clean && \
    cd /opt && \
    mv $path_d2

#已经在上面进行下载启动文件
ADD ./resource/init_fe.sh /opt/apache-doris/fe/bin
RUN chmod 755 /opt/apache-doris/fe/bin/init_fe.sh

ENTRYPOINT ["/opt/apache-doris/fe/bin/init_fe.sh"]
EOF


##往Dockerfile指定行号处 补充环境变量
d_path1='ENV JAVA_HOME="/usr/local/openjdk-8/" \'
d_path2='ENV PATH="/opt/apache-doris/fe/bin:$PATH"'
nl -ba Dockerfile
sed -ie.bak "6a $d_path1" /miku/docker-build/fe/Dockerfile
sed -ie.bak "7a $d_path2" /miku/docker-build/fe/Dockerfile
source /etc/profile
echo '已经设置好环境变量'


#编写fe执行脚本 由于官方的启动init太长了，手动创建 直接wget执行脚本 
#wget -cP /miku/docker-build/fe/resource/ https://github.com/apache/doris/blob/f1dde20315bebad1f685a512a983a52243e9bba3/docker/runtime/fe/resource/init_fe.sh
#还是手动下载然后上传吧。然后下载太卡了 或者放到自己的阿里云上，走内网吧


#touch /miku/docker-build/fe/resource/init_fe.sh
#cat >>/miku/docker-build/fe/resource/init_fe.sh <<EOF
#EOF
#if用于判断用户是否已经创建了启动文件，是不是忽略了这一步

if [ ! -f '/miku/docker-build/fe/resource/init_fe.sh' ]
then
	echo '启动文件没有创建，请创建启动文件'
	wget -cP /miku/docker-build/fe/resource/ https://github.com/apache/doris/blob/f1dde20315bebad1f685a512a983a52243e9bba3/docker/runtime/fe/resource/init_fe.sh
	echo '已经下载官方的启动文件，下载完成开始启动'
	cd /miku/docker-build/fe
	docker build -t miku_doris:23.3.0-fe .
else
	echo '已经创建好了 现在开始启动构建执行'
	cd /miku/docker-build/fe
	docker build -t miku_doris:23.3.0-fe .
fi


##构建执行
#cd /miku/docker-build/fe
#docker build . -t ${name} 可以设置变量引
