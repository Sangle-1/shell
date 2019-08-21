#!/bin/bash
time=`date +%Y%m%d`
logpath=/usr/local/nginx/logs/
mv $logpath/access.log  $logpath/$time-access.log
mv $logpath/error.log  $logpath/$time-error.log
kill -USR1 $(cat $logpath/nginx.pid)

