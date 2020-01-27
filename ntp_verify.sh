#!/bin/bash
# start service if not active
ntpStatus=$(service ntp status | awk '/Active:/{print $2}')
if [ "$ntpStatus" == "inactive" ]
then
  echo 'NOTICE: ntp is not running'
  service ntp start
fi

if [ $(diff /etc/ntp.conf /etc/ntpDeploy_ntp.conf.bak | wc -l) -gt 0 ]
then
    echo 'NOTICE: /etc/ntp.conf was changed. Calculated diff'
    diff -u /etc/ntpDeploy_ntp.conf.bak /etc/ntp.conf
        
    # restore script state and restart service 
    rm /etc/ntp.conf
    cp /etc/ntpDeploy_ntp.conf.bak /etc/ntp.conf
    service ntp restart
fi

exit 0