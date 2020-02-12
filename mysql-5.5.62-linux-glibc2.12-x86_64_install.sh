#!/bin/bash

echo "正在安装依赖"
yum install libaio -y >/dev/null
baseDir="/opt/mysql"
fileName="mysql-5.5.62-linux-glibc2.12-x86_64.tar.gz"
mycnf="my.cnf"
mkdir -p $baseDir
cd $baseDir
echo "开始下载文件"
wget --no-check-certificate "https://raw.githubusercontent.com/Mr-Y0/shell/master/config/my.cnf"
if [ $? == 0 ];then
   wget "http://code0001.com/tianyi-cloud-web-jiexi/file/download?fileId=8151224995999360" -O $fileName
   if [ $? != 0 ];then
     echo "文件下载失败"
    exit 1
  fi
   else
     echo "文件下载失败"
     exit 1
fi
echo "解压文件中..............."
mysqlDir="$baseDir/"`tar -zxvf $fileName |tail -1 |awk -F "/" '{print $1}'`
rm -f $fileName
useradd mysql
chown -R mysql:mysql $mysqlDir
cd $mysqlDir/support-files
sed -i -e '46,47d' -e "45abasedir=$mysqlDir\ndatadir=$mysqlDir/data"  mysql.server
if [ $? == 0 ];then
 cd ../scripts
 echo "开始安装"
 ./mysql_install_db --basedir=$mysqlDir --datadir=$mysqlDir/data --user=mysql >/dev/null
 if [ $? == 0 ];then
    mv -f /opt/mysql/$mycnf /etc/$mycnf
    cp -f ../support-files/mysql.server /etc/init.d/mysql
    service mysql start
    if [ $? == 0 ];then
       echo "export MYSQL_HOME=$mysqlDir" >>/etc/profile
       echo 'export PATH=$PATH:$MYSQL_HOME/bin' >>/etc/profile
       source /etc/profile
       echo "mysql 已经启动"
       mysql -uroot <<EOF
use mysql;
update user set host="%",password=password("123456789") where host="127.0.0.1" and user="root";
update user set password=password("123456789") where host="localhost" and user="root";
quit
EOF
       if [ $? == 0 ];then
         echo "设置允许远程访问成功"
         echo "修改mysql密码成功"
         echo "初始密码是:123456789"
         echo "正在重启mysql"
         service mysql restart >>/dev/null
         if [ $? == 0 ];then
           echo "重启mysql成功"
           echo "服务名为:mysql"
           echo "安装完成"
         fi
      fi
    fi

       exit 0
    fi
fi 
  echo "安装失败"
  exit 1
