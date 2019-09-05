#!/bin/bash
#openstack主机配置快速部署,所需要的安装包放在/linux_solf/04/openstack里面,用base-vm脚本快速创建.
#在此之前还需要配置静态IP,主机名,DNS解析,时间服务器和yum仓库.
#开始部署环境,先检测现环境是否有冲突,系统版本需要RHEL7及以上,是否卸载了firewald和NetworkManager,检查NTP服务器是否可用
cat /etc/redhat-release | awk '{print $4}' | grep  '^7' &> /dev/null
if [ $? -eq 0 ];then
	break
else
	echo "版本过低,请升级到RHEL7及以上"
	exit
fi

rpm -qa  | grep NetworkManager*  | yum -y remove NetworkManager* &> /dev/null
rpm -qa  | grep firewalld* | yum -y remove  firewalld* &> /dev/null
#这两种服务会影响到openstack的部署,如果存在需要删除

chronyc  sources -v | grep '^\^\*' && echo "时间服务没有同步,请退出同步";exit
#时间同步未完成在后续生成配置文件时会报错

yum install -y qemu-kvm libvirt-client libvirt-daemon libvirt-daemon-driver-qemu python-setuptools  openstack-packstack &> /dev/null
#安装所有必要的软件包,使用/linux_solf/04/openstack里的光盘挂载后即可使用

packstack --gen-answer-file answer.ini &> /dev/null
#生成配置文件,ini文件结尾没有特殊含义,是使文本带有颜色区分

sed -i '42s/y/n' /root/answer.ini &> /dev/null
sed -i '45s/y/n' /root/answer.ini &> /dev/null
sed -i '49s/y/n' /root/answer.ini &> /dev/null
sed -i '53s/y/n' /root/answer.ini &> /dev/null
sed -i '1179s/y/n' /root/answer.ini &> /dev/null
sed -i "75s/\(CONFIG_NTP_SERVERS=).*/\$ip" /root/answer.ini
sed -i "98s/\(CONFIG_COMPUTE_HOSTS=).*/\$ip1" /root/answer.in
sed -i "102s/\(CONFIG_NETWORK_HOSTS=).*/\$ip0,$ip1" /root/answer.ini
sed -i "333s/\(CONFIG_KEYSTONE_ADMIN_PW=).*/\$pass" /root/answer.ini
sed -i "840s/\(CONFIG_NEUTRON_ML2_TYPE_DRIVERS=).*/\flat,vxlan"  /root/answer.ini
sed -i "876s/\(CONFIG_NEUTRON_ML2_VXLAN_GROUP=).*/\239.1.1.5"  /root/answer.ini
#ip是时间服务器ip,ip0是本机ip,ip1是管理的机器ip,pass是管理密码

packstack --answer-file=answer.ini &> /dev/null
#此时需要输入管理的机器密码,如有需要可以事先传好秘钥
echo "WSGIApplicationGroup %{GLOBAL}" >> /etc/httpd/conf.d/15-horizon_vhost.conf
apachectl  graceful
