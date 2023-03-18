#!/bin/bash
#使用wget下载二进制包
#wget -cP /dir url

# 本次的docker环境下，在本目录docker-build ，目录如下：docker -build ——》fe -》{dockerfile,resource/{init_fe.sh,apache-doris-x.x.x-bin-fe.tar.gz} 说明：启动及注册脚本以及二进制包
#分为fe和be，fe架构负责：查询解析、无数据、节点管理、负责用户接入 而be：有数据存储 查询计划


###推送镜像到到共有的hub和私有的registry仓库

#docker login XX
#docker push ${name}
docker login mikulin

docker tag images_ID your_nameid/my_doris:23.3.0-fe # (标签) 对应要进行替换
docker push  your_nameid/my_doris:23.3.0-fe  #一定要加上你的名字 对应要进行替换
