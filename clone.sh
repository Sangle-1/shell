#!/bin/bash
#快速创建虚拟机,配置好虚拟机名字(name),虚拟机磁盘大小(size),
mountpoint="/media/virtimage" 
read -p '请输入想要创建的主机名字:'  name
if [  -e  /var/lib/libvirt/images/$name.img  ];then
	echo "file exits"
	exit 1
else
	qemu-img create -f qcow2 -b /var/lib/libvirt/images/.node_base.qcow2  /var/lib/libvirt/images/$name.img  30G &> /dev/null
fi

if [  -e  /etc/libvirt/qemu/$name.xml  ];then
        echo "file exits"
        exit 1
else
sed  "s,node,$name,g" /etc/libvirt/qemu/node.xml > /etc/libvirt/qemu/$name.xml
fi
virsh define /etc/libvirt/qemu/$name.xml &> /dev/null
#使用guestmount来挂载虚拟机磁盘文件,虚拟机此时不打开,打开会报错
[ ! -d  $mountpoint ]&& mkdir $mountpoint 
 if  mount | grep -q  "$mountpoint" ;then
       umount $mountpoint
fi
guestmount  -d $name -i $mountpoint
read -p "请输入IP地址:" add
sed -i "s,dhcp,none,g"  $mountpoint/etc/sysconfig/network-scripts/ifcfg-eth0 
echo "IPADDR=$add" >>   $mountpoint/etc/sysconfig/network-scripts/ifcfg-eth0
umount $mountpoint
virsh start $name &> /dev/null
echo "虚拟机$name创建成功,ip为:$add"
#read -p  "你是否需要扩容(y/n):" choose
#if [ $choose == y ];then
#read -p "扩容后大小为多少(大于30G):"  size
#virsh domnblklist  $name &> /dev/null
#virsh blockresize --path /var/lib/libvirt/images/$name.img  --size $size  $name  &> /dev/null
#如果需要扩容可以打开,默认大小30G
#	virsh reboot $name &> /dev/null
#else	
#	virsh reboot $name &> /dev/null
#fi
