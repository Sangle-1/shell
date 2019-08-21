#!/bin/bash
echo "Zabbix监控服务部署"
#部署环境(需要先将相关包Zabbix放在root目录下)
yum -y install gcc pcre-devel  openssl-devel  php php-mysql    mariadb mariadb-devel mariadb-server  php-fpm  net-snmp-devel  curl-devel libevent-devel  php-gd php-xml  php-bcmath   php-mbstring &> /dev/null
tar -xf  /root/Zabbix/nginx-1.12.2.tar.gz/  -C /root/
./nginx-1.12.2/configure  --with-http_ssl_module &> /dev/null
cd /root/nginx-1.12.2/ && make && make install
tar -xf /root/Zabbix-3.4.4.tar.gz
./root/zabbix-3.4.4/configure  --enable-server  --enable-proxy --enable-agent --with-mysql=/usr/bin/mysql_config  --with-net-snmp --with-libcurl 
cd /root/zabbix-3.4.4/ && make && make install
