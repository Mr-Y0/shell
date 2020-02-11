#!/bin/bash
#Author yyh
#Description java-jdk-1.8 安装
#CreateTime 2020/2/11
baseDir="/opt/java"
src="jdk-8u231-linux-x64.tar.gz"
mkdir -p $baseDir
cd $baseDir
echo "正在下载jdk"
wget "http://code0001.com/tianyi-cloud-web-jiexi/file/download?fileId=7132224950014261" -O $src
if [ $? != 0 ];then
   echo "下载jdk失败"
   exit 1
fi
echo "正在解压jdk"
jdkDir="$baseDir/"`tar -zxvf $src | tail -1 |awk -F "/" '{print $1}'`
#rm -rf $src
echo "解压成功"
echo "export JAVA_HOME=$jdkDir">>/etc/profile
echo 'export PATH=$PATH:$JAVAHOME/bin'>>/etc/profile
source /etc/profile
java -version >/dev/null
if [ $? == 0 ];then
  echo "安装成功"
  else 
    echo "安装失败"
    echo `修改了/etc/profile`
    echo "所有下载解压文件在---$baseDir"
fi

