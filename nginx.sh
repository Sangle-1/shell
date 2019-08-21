#!/bin/bash
#构建Nginx服务器
clear
systemctl stop firewall &> /dev/null
setenforce 0 &> /dev/null
cd
yum repolist &> /dev/null
yum -y install gcc pcre-devel openssl-devel httpd-tools mariadb   mariadb-server   mariadb-devel  php   php-mysql php-fpm httpd memcached  telnet php-pecl-memcache  &> /dev/null
systemctl stop httpd &> /dev/null
systemctl start  mariadb &> /dev/null
systemctl enable  mariadb &> /dev/null
systemctl start php-fpm &> /dev/null
systemctl enable php-fpm &> /dev/null
systemctl  start  memcached &> /dev/null
systemctl enable memcached &> /dev/null
#以上是所以需要服务
useradd -s /sbin/nologin nginx &> /dev/null
tar  -xf   /root/nginx-1.12.2.tar.gz  
cd /root/nginx-1.12.2/
/root/nginx-1.12.2/configure  --prefix=/usr/local/nginx  --user=nginx  --group=nginx  --with-http_ssl_module  --with-stream --with-http_stub_status_module
cd /root/nginx-1.12.2/ && make && make install
/usr/local/nginx/sbin/nginx
ln -s /usr/local/nginx/sbin/nginx /sbin/
clear
echo "Nginx已经成功部署启动" 

