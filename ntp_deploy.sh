#!/bin/bash
sudo apt install ntp -y;

# add custom config to file
sed -i '/^pool / d' ntp.conf 2> /dev/null
echo "pool ua.pool.ntp.org" >> /etc/ntp.conf 
cp /etc/ntp.conf /etc/ntpDeploy_ntp.conf.bak

# restart service
service ntp restart

# add cron job to run verify shell every minute
(crontab -l ; echo "* * * * * $PWD/ntp_verify.sh") | crontab -

exit 0