#!/bin/bash

source /etc/profile

 

groupadd zabbix -g 201

useradd -g zabbix -u 201 -m zabbix

mkdir /usr/local/zabbix

tar xf /home/cloud-user/zabbix_agents_3.2.0.linux2_6_23.amd64.tar.gz  -C /usr/local/zabbix
#根据需要修改zabbix包路径

chown -R zabbix.zabbix /usr/local/zabbix

 

IPPADDR=`ifconfig |grep -oP '(?<=inet )[\d\.]+'|grep -v 127.0.0.1`

cat > /usr/local/zabbix/conf/zabbix_agentd.conf  <<EOF

LogFile=/tmp/zabbix_agentd.log

Server=10.119.171.56
# （此处对应修改）

ServerActive=10.119.171.56
# （此处对应修改）

Hostname=$IPPADDR

HostMetadataItem=system.uname

Include=/usr/local/zabbix/conf/zabbix_agentd/*.conf

EOF

ln -sf /usr/local/zabbix/conf/zabbix_agentd.conf /usr/local/etc/zabbix_agentd.conf

mkdir /usr/local/zabbix/scripts

 

# configure autostart

if [ `grep /usr/local/zabbix/sbin/zabbix_agentd /etc/rc.local|wc -l` -eq 0 ];then

echo '/usr/local/zabbix/sbin/zabbix_agentd' >> /etc/rc.local

fi

chmod +x /etc/rc.d/rc.local

 

#start zabbix_agentd

/usr/local/zabbix/sbin/zabbix_agentd

sleep 3
ps -C zabbix_agentd

