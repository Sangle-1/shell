#!/bin/bash
#快速配备单机hadoop
yum -y remove java-1.8.0-openjdk-devel > /dev/null
yum -y install java-1.8.0-openjdk-devel > /dev/null
tar -xf /root/hadoop-2.7.7.tar.gz/  -C /root/
mv  hadoop-2.7.7  /usr/local/hadoop
sed  -i  '33c export HADOOP_CONF_DIR="/usr/local/hadoop/etc/hadoop"' /usr/local/hadoop/etc/hadoop/hadoop-env.sh
sed  -i   '25c export JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.161-2.b14.el7.x86_64/jre"' /usr/local/hadoop/etc/hadoop/hadoop-env.sh
./usr/local/hadoop/bin/hadoop/
mkdir /usr/local/hadoop/input
cp /usr/local/hadoop/*.txt  /usr/local/hadoop/input
./usr/local/hadoop jar  share/hadoop/mapreduce/hadoop-mapreduce-examples-2.7.7.jar  wordcount input output
